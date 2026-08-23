from __future__ import annotations

from dataclasses import dataclass
from pathlib import Path
from types import MappingProxyType
from typing import Mapping, Optional, Sequence, Tuple
import json
import subprocess
import tempfile

from v0122_kernel import (
    ContextStatus,
    EvaluationState,
    History,
    KernelError,
    MoveKind,
    ProofKernel,
)


@dataclass(frozen=True, order=True)
class ContextKey:
    binding: str
    context: str
    use: str

    @staticmethod
    def from_state_key(key: Tuple[str, str, str]) -> "ContextKey":
        return ContextKey(key[0], key[1], key[2])

    def state_key(self) -> Tuple[str, str, str]:
        return (self.binding, self.context, self.use)


@dataclass(frozen=True)
class ActivationObservation:
    kind: str
    license_id: Optional[str] = None

    @staticmethod
    def bootstrap() -> "ActivationObservation":
        return ActivationObservation("bootstrap", None)

    @staticmethod
    def adopt(license_id: str) -> "ActivationObservation":
        return ActivationObservation("adopt", license_id)

    def __post_init__(self) -> None:
        if self.kind not in {"bootstrap", "adopt"}:
            raise ValueError(f"Unknown activation observation kind: {self.kind}")
        if self.kind == "bootstrap" and self.license_id is not None:
            raise ValueError("Bootstrap activation cannot carry a license id")
        if self.kind == "adopt" and self.license_id is None:
            raise ValueError("Adopt activation requires a license id")


@dataclass(frozen=True)
class PreRefreshBoundary:
    context_keys: Tuple[ContextKey, ...]
    seed_active_before: Mapping[ContextKey, bool]
    activation: Mapping[ContextKey, ActivationObservation]


@dataclass(frozen=True)
class ContextRefreshSnapshot:
    context_keys: Tuple[ContextKey, ...]
    seed_active_before: Mapping[ContextKey, bool]
    activation: Mapping[ContextKey, ActivationObservation]
    issuer_context: Mapping[str, ContextKey]
    base_current_after: Mapping[str, bool]
    python_active_after: Mapping[ContextKey, bool]


@dataclass(frozen=True)
class GroundedCertificate:
    kind: str
    license_id: Optional[str] = None
    issuer: Optional[ContextKey] = None
    tail: Optional["GroundedCertificate"] = None


@dataclass(frozen=True)
class UngroundedCertificate:
    reason: str
    license_id: Optional[str] = None
    issuer: Optional[ContextKey] = None
    tail: Optional["UngroundedCertificate"] = None


@dataclass(frozen=True)
class CertifiedCurrentnessResult:
    context: ContextKey
    python_active: bool
    grounded: Optional[GroundedCertificate] = None
    ungrounded: Optional[UngroundedCertificate] = None


def _activation_map(state: EvaluationState) -> Mapping[ContextKey, ActivationObservation]:
    out = {}
    for raw_key, activation_license in state.context_activation_license.items():
        key = ContextKey.from_state_key(raw_key)
        if activation_license is None:
            out[key] = ActivationObservation.bootstrap()
        else:
            out[key] = ActivationObservation.adopt(activation_license)
    return MappingProxyType(out)


def capture_pre_refresh_boundary(state: EvaluationState) -> PreRefreshBoundary:
    activation = _activation_map(state)
    keys = {
        ContextKey.from_state_key(key)
        for key in state.active_contexts | state.pending_contexts
    }
    keys.update(activation.keys())
    ordered = tuple(sorted(keys))
    seed_active = MappingProxyType(
        {
            key: (
                state.context_status(key.binding, key.context, key.use)
                == ContextStatus.ACTIVE
            )
            for key in ordered
        }
    )
    return PreRefreshBoundary(ordered, seed_active, activation)


def _clone_state(state: EvaluationState) -> EvaluationState:
    """Conformance-only copy of the mutable evaluation observations.

    The copy is used to neutralize exactly one issuing-context activity bit
    while delegating all remaining currentness checks to the reference kernel.
    """

    clone = EvaluationState()
    clone._epi = dict(state.epi)
    clone._placement = dict(state.placement)
    clone._active_bindings = set(state.active_bindings)
    clone._active_contexts = set(state.active_contexts)
    clone._pending_contexts = set(state.pending_contexts)
    clone._context_activation_license = dict(state.context_activation_license)
    clone._review_required = set(state.review_required)
    return clone


def issuer_context_for_license(history: History, license_id: str) -> ContextKey:
    try:
        record = history.licenses[license_id]
    except KeyError as exc:
        raise KernelError(f"Unknown canonical license id: {license_id}") from exc
    return ContextKey(record.binding_id, record.context_id, record.use)


def issuer_context_is_active(
    history: History,
    state: EvaluationState,
    license_id: str,
) -> bool:
    issuer = issuer_context_for_license(history, license_id)
    return (
        state.context_status(issuer.binding, issuer.context, issuer.use)
        == ContextStatus.ACTIVE
    )


def check_license_base_current(
    kernel: ProofKernel,
    history: History,
    state: EvaluationState,
    license_id: str,
) -> bool:
    """Observe currentness with only issuing-context activity neutralized.

    No license-currentness predicate is reimplemented here.  The conformance
    adapter calls the actual `ProofKernel.check_license_current` on an exact
    copy of the post-state in which the license's issuing context is forced to
    ACTIVE.  Binding/profile/use/review/scope/leaf-usability behavior remains
    delegated to the reference implementation.
    """

    issuer = issuer_context_for_license(history, license_id)
    neutral = _clone_state(state)
    key = issuer.state_key()
    neutral._pending_contexts.discard(key)
    neutral._active_contexts.add(key)
    return kernel.check_license_current(history, neutral, license_id)


def license_current_factorization_holds(
    kernel: ProofKernel,
    history: History,
    state: EvaluationState,
    license_id: str,
) -> bool:
    return kernel.check_license_current(history, state, license_id) == (
        check_license_base_current(kernel, history, state, license_id)
        and issuer_context_is_active(history, state, license_id)
    )


def _validate_activation_wf(
    history: History,
    target: ContextKey,
    observation: ActivationObservation,
) -> Optional[ContextKey]:
    if observation.kind == "bootstrap":
        return None

    assert observation.license_id is not None
    try:
        record = history.licenses[observation.license_id]
    except KeyError as exc:
        raise KernelError(
            "Malformed activation provenance: activation license is not canonical"
        ) from exc

    if record.move.kind != MoveKind.ADOPT:
        raise KernelError(
            "Malformed activation provenance: activation license is not Adopt"
        )
    if record.move.args != (target.context,):
        raise KernelError(
            "Malformed activation provenance: Adopt target does not match context"
        )
    if record.binding_id != target.binding:
        raise KernelError(
            "Malformed activation provenance: binding does not match target key"
        )
    if record.use != target.use:
        raise KernelError(
            "Malformed activation provenance: use does not match target key"
        )

    return ContextKey(record.binding_id, record.context_id, record.use)


def capture_context_refresh_snapshot(
    kernel: ProofKernel,
    history: History,
    state_after: EvaluationState,
    before: PreRefreshBoundary,
) -> ContextRefreshSnapshot:
    """Close a PR #9 pre/post refresh observation.

    Activation topology is required to be unchanged across the measured
    refresh boundary.  Transitions may change warrant/review/currentness facts,
    but a topology-changing transition is outside this conformance object.
    """

    activation_after = _activation_map(state_after)
    if dict(activation_after) != dict(before.activation):
        raise KernelError(
            "Activation topology changed across refresh-conformance boundary"
        )

    after_keys = {
        ContextKey.from_state_key(key)
        for key in state_after.active_contexts | state_after.pending_contexts
    }
    after_keys.update(activation_after.keys())
    if not after_keys <= set(before.context_keys):
        raise KernelError(
            "New context key appeared across refresh-conformance boundary"
        )

    issuers = {}
    base_current = {}
    universe = set(before.context_keys)

    for target, observation in before.activation.items():
        issuer = _validate_activation_wf(history, target, observation)
        if issuer is None:
            continue
        assert observation.license_id is not None
        if issuer not in universe:
            raise KernelError(
                "Malformed activation provenance: issuer context is outside pre-refresh universe"
            )
        issuers[observation.license_id] = issuer
        base_current[observation.license_id] = check_license_base_current(
            kernel,
            history,
            state_after,
            observation.license_id,
        )
        if not license_current_factorization_holds(
            kernel, history, state_after, observation.license_id
        ):
            raise KernelError(
                "Reference currentness no longer factors as BaseCurrent and issuer activity"
            )

    python_active = MappingProxyType(
        {
            key: (
                state_after.context_status(key.binding, key.context, key.use)
                == ContextStatus.ACTIVE
            )
            for key in before.context_keys
        }
    )

    return ContextRefreshSnapshot(
        context_keys=before.context_keys,
        seed_active_before=before.seed_active_before,
        activation=before.activation,
        issuer_context=MappingProxyType(issuers),
        base_current_after=MappingProxyType(base_current),
        python_active_after=python_active,
    )


def build_grounded_certificate(
    snapshot: ContextRefreshSnapshot,
    context: ContextKey,
    *,
    visiting: Optional[frozenset[ContextKey]] = None,
) -> GroundedCertificate:
    visiting = visiting or frozenset()
    if context in visiting:
        raise KernelError(
            "Cannot certify Python ACTIVE result: activation dependency cycle has no finite bootstrap proof"
        )
    if not snapshot.seed_active_before.get(context, False):
        raise KernelError(
            "Cannot certify Python ACTIVE result: context was not active at the pre-refresh boundary"
        )

    observation = snapshot.activation.get(context)
    if observation is None:
        raise KernelError(
            "Cannot certify Python ACTIVE result: missing activation provenance"
        )
    if observation.kind == "bootstrap":
        return GroundedCertificate("bootstrap")

    assert observation.license_id is not None
    license_id = observation.license_id
    if not snapshot.base_current_after.get(license_id, False):
        raise KernelError(
            "Cannot certify Python ACTIVE result: activation license is not BaseCurrent"
        )
    issuer = snapshot.issuer_context.get(license_id)
    if issuer is None:
        raise KernelError(
            "Cannot certify Python ACTIVE result: missing canonical issuer context"
        )
    tail = build_grounded_certificate(
        snapshot,
        issuer,
        visiting=visiting | frozenset({context}),
    )
    return GroundedCertificate("adopt", license_id, issuer, tail)


def build_ungrounded_certificate(
    snapshot: ContextRefreshSnapshot,
    context: ContextKey,
    *,
    visiting: Optional[frozenset[ContextKey]] = None,
) -> UngroundedCertificate:
    visiting = visiting or frozenset()
    if context in visiting:
        raise KernelError(
            "Activation dependency cycle is outside the well-founded PR #9 certificate boundary"
        )
    if not snapshot.seed_active_before.get(context, False):
        return UngroundedCertificate("seedInactive")

    observation = snapshot.activation.get(context)
    if observation is None:
        return UngroundedCertificate("missingActivation")
    if observation.kind == "bootstrap":
        raise KernelError(
            "Cannot certify Python INACTIVE result: pre-refresh active bootstrap context is Grounded"
        )

    assert observation.license_id is not None
    license_id = observation.license_id
    if not snapshot.base_current_after.get(license_id, False):
        return UngroundedCertificate("baseNotCurrent", license_id)

    issuer = snapshot.issuer_context.get(license_id)
    if issuer is None:
        return UngroundedCertificate("missingIssuer", license_id)

    tail = build_ungrounded_certificate(
        snapshot,
        issuer,
        visiting=visiting | frozenset({context}),
    )
    return UngroundedCertificate("issuerUngrounded", license_id, issuer, tail)


def certify_python_currentness(
    snapshot: ContextRefreshSnapshot,
) -> Tuple[CertifiedCurrentnessResult, ...]:
    out = []
    for context in snapshot.context_keys:
        active = snapshot.python_active_after[context]
        if active:
            out.append(
                CertifiedCurrentnessResult(
                    context=context,
                    python_active=True,
                    grounded=build_grounded_certificate(snapshot, context),
                )
            )
        else:
            out.append(
                CertifiedCurrentnessResult(
                    context=context,
                    python_active=False,
                    ungrounded=build_ungrounded_certificate(snapshot, context),
                )
            )
    return tuple(out)


def _ls(value: str) -> str:
    return json.dumps(value, ensure_ascii=False)


def _lean_context_key(key: ContextKey) -> str:
    return f"⟨{_ls(key.binding)}, {_ls(key.context)}, {_ls(key.use)}⟩"


def _prop_membership(variable: str, values: Sequence[str]) -> str:
    if not values:
        return "False"
    return " ∨ ".join(f"{variable} = {value}" for value in values)


def _activation_function(snapshot: ContextRefreshSnapshot) -> str:
    body = "none"
    for key in reversed(snapshot.context_keys):
        observation = snapshot.activation.get(key)
        if observation is None:
            value = "none"
        elif observation.kind == "bootstrap":
            value = "some Activation.bootstrap"
        else:
            assert observation.license_id is not None
            value = f"some (Activation.adopt {_ls(observation.license_id)})"
        body = f"if c = {_lean_context_key(key)} then {value} else ({body})"
    return f"def activationFn (c : ContextKey) : Option Activation :=\n  {body}\n"


def _issuer_function(snapshot: ContextRefreshSnapshot) -> str:
    body = "none"
    for license_id, issuer in reversed(sorted(snapshot.issuer_context.items())):
        body = (
            f"if l = {_ls(license_id)} then some {_lean_context_key(issuer)} "
            f"else ({body})"
        )
    return f"def issuerFn (l : ActivationLicenseId) : Option ContextKey :=\n  {body}\n"


def _seed_function(snapshot: ContextRefreshSnapshot) -> str:
    active = [
        _lean_context_key(key)
        for key in snapshot.context_keys
        if snapshot.seed_active_before[key]
    ]
    return (
        "def seedActiveFn (c : ContextKey) : Prop :=\n"
        f"  {_prop_membership('c', active)}\n"
    )


def _base_current_function(snapshot: ContextRefreshSnapshot) -> str:
    current = [
        _ls(license_id)
        for license_id, value in sorted(snapshot.base_current_after.items())
        if value
    ]
    return (
        "def baseCurrentFn (l : ActivationLicenseId) : Prop :=\n"
        f"  {_prop_membership('l', current)}\n"
    )


def _lean_grounded_certificate(cert: GroundedCertificate) -> str:
    if cert.kind == "bootstrap":
        return ".bootstrap"
    if cert.kind != "adopt" or cert.license_id is None or cert.issuer is None or cert.tail is None:
        raise ValueError("Malformed grounded certificate")
    return (
        f".adopt {_ls(cert.license_id)} {_lean_context_key(cert.issuer)} "
        f"({_lean_grounded_certificate(cert.tail)})"
    )


def _lean_ungrounded_certificate(cert: UngroundedCertificate) -> str:
    if cert.reason == "seedInactive":
        return ".seedInactive"
    if cert.reason == "missingActivation":
        return ".missingActivation"
    if cert.reason == "baseNotCurrent" and cert.license_id is not None:
        return f".baseNotCurrent {_ls(cert.license_id)}"
    if cert.reason == "missingIssuer" and cert.license_id is not None:
        return f".missingIssuer {_ls(cert.license_id)}"
    if (
        cert.reason == "issuerUngrounded"
        and cert.license_id is not None
        and cert.issuer is not None
        and cert.tail is not None
    ):
        return (
            f".issuerUngrounded {_ls(cert.license_id)} {_lean_context_key(cert.issuer)} "
            f"({_lean_ungrounded_certificate(cert.tail)})"
        )
    raise ValueError("Malformed ungrounded certificate")


def build_currentness_lean_fixture(snapshot: ContextRefreshSnapshot) -> str:
    results = certify_python_currentness(snapshot)
    lines = [
        "import ResponsibilityTopology.CurrentnessConformance",
        "",
        "open ResponsibilityTopology",
        "",
        _seed_function(snapshot),
        _activation_function(snapshot),
        _issuer_function(snapshot),
        _base_current_function(snapshot),
        "def R : ActivationRead where",
        "  seedActive := seedActiveFn",
        "  activation := activationFn",
        "  issuerContext := issuerFn",
        "  baseCurrent := baseCurrentFn",
        "",
    ]

    for index, result in enumerate(results):
        c_name = f"c{index}"
        cert_name = f"cert{index}"
        lines.append(f"def {c_name} : ContextKey := {_lean_context_key(result.context)}")
        if result.python_active:
            assert result.grounded is not None
            lines.append(
                f"def {cert_name} : GroundedCertificate := "
                f"{_lean_grounded_certificate(result.grounded)}"
            )
            lines.append(
                f"example : Grounded R {c_name} := by\n"
                f"  apply groundedCertificate_sound (cert := {cert_name})\n"
                f"  decide"
            )
        else:
            assert result.ungrounded is not None
            lines.append(
                f"def {cert_name} : UngroundedCertificate := "
                f"{_lean_ungrounded_certificate(result.ungrounded)}"
            )
            lines.append(
                f"example : ¬ Grounded R {c_name} := by\n"
                f"  apply ungroundedCertificate_sound (cert := {cert_name})\n"
                f"  decide"
            )
        lines.append("")

    return "\n".join(lines)


def run_currentness_lean_fixture(
    snapshot: ContextRefreshSnapshot,
    *,
    formal_dir: Optional[Path] = None,
) -> str:
    root = Path(__file__).resolve().parent
    formal = formal_dir or (root / "formal")
    program = build_currentness_lean_fixture(snapshot)

    with tempfile.NamedTemporaryFile(
        mode="w",
        encoding="utf-8",
        suffix=".lean",
        prefix="CurrentnessConformanceGenerated_",
        dir=formal,
        delete=False,
    ) as handle:
        handle.write(program)
        path = Path(handle.name)

    try:
        proc = subprocess.run(
            ["lake", "env", "lean", path.name],
            cwd=formal,
            text=True,
            capture_output=True,
            check=False,
        )
    finally:
        path.unlink(missing_ok=True)

    if proc.returncode != 0:
        raise RuntimeError(
            "Lean currentness conformance fixture failed to elaborate:\n"
            f"STDOUT:\n{proc.stdout}\nSTDERR:\n{proc.stderr}\n"
            f"PROGRAM:\n{program}"
        )
    return proc.stdout
