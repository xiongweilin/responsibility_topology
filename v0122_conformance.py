from __future__ import annotations

from dataclasses import dataclass
from pathlib import Path
from types import MappingProxyType
from typing import Mapping, Optional, Sequence, Tuple
import json
import subprocess
import tempfile

from v0122_kernel import (
    And,
    Atom,
    Branch,
    Claim,
    ContextStatus,
    EvaluationState,
    History,
    KernelError,
    LicenseType,
    Move,
    MoveKind,
    Or,
    ProofKernel,
    Requirement,
    Role,
    Scope,
    SatisfactionError,
    Top,
    Warrant,
)


# ============================================================
# Deterministic wire encoding
# ============================================================


@dataclass(frozen=True)
class IdEncoding:
    """Deterministic injective encoding of canonical Python string IDs as Nat.

    This is a wire encoding only. It does not identify the semantic Python
    warrant ID with Lean's current `WarrantId := Nat` representation.
    """

    by_string: Mapping[str, int]

    @staticmethod
    def from_ids(ids: Sequence[str]) -> "IdEncoding":
        ordered = tuple(sorted(set(ids)))
        return IdEncoding(MappingProxyType({wid: i for i, wid in enumerate(ordered)}))

    def encode(self, warrant_id: str) -> int:
        try:
            return self.by_string[warrant_id]
        except KeyError as exc:
            raise KernelError(
                f"Warrant id is outside the canonical conformance encoding: {warrant_id}"
            ) from exc

    def encode_sequence(self, warrant_ids: Sequence[str]) -> Tuple[int, ...]:
        # Intentionally preserve order and every duplicate occurrence.
        return tuple(self.encode(wid) for wid in warrant_ids)


@dataclass(frozen=True)
class CanonicalReadSnapshot:
    profile_digest: str
    context_id: str
    use: str
    binding_active: bool
    binding_use: str
    context_active: bool
    binding_scope: Scope
    requirement: Requirement
    warrants: Mapping[str, Warrant]
    usable: Mapping[str, bool]
    id_encoding: IdEncoding
    escalation_depths: Mapping[Claim, Optional[int]]


def capture_licensing_read(
    kernel: ProofKernel,
    history: History,
    state: EvaluationState,
    binding_id: str,
    context_id: str,
    use: str,
    license_type: LicenseType,
    move: Move,
) -> CanonicalReadSnapshot:
    """Project one Python V0.1.2.2 licensing invocation into PR #6's read shape.

    `requirement_for` is executed here, but requirement lookup is not promoted
    into the Lean theorem model. The returned requirement is the already-resolved
    exact requirement expected by `LicensingRead`.
    """

    try:
        binding = history.bindings[binding_id]
    except KeyError as exc:
        raise KernelError(f"Unknown canonical binding id: {binding_id}") from exc
    if context_id not in history.contexts:
        raise KernelError(f"Unknown canonical context id: {context_id}")

    profile = history.profiles[binding.profile_digest]
    requirement = profile.requirement_for(license_type, move)

    warrant_ids = tuple(sorted(history.warrants.keys()))
    encoding = IdEncoding.from_ids(warrant_ids)
    warrants = MappingProxyType({wid: history.warrants[wid] for wid in warrant_ids})
    usable = MappingProxyType(
        {
            wid: state.usable(binding.profile_digest, context_id, use, wid)
            for wid in warrant_ids
        }
    )
    depths = MappingProxyType(
        {
            warrant.claim: (
                None
                if kernel._claim_depth(warrant.claim) is None
                else int(kernel._claim_depth(warrant.claim))
            )
            for warrant in warrants.values()
        }
    )

    return CanonicalReadSnapshot(
        profile_digest=binding.profile_digest,
        context_id=context_id,
        use=use,
        binding_active=binding_id in state.active_bindings,
        binding_use=binding.use,
        context_active=(
            state.context_status(binding_id, context_id, use) == ContextStatus.ACTIVE
        ),
        binding_scope=binding.scope,
        requirement=requirement,
        warrants=warrants,
        usable=usable,
        id_encoding=encoding,
        escalation_depths=depths,
    )


def python_ambient_admissible(read: CanonicalReadSnapshot, move: Move) -> bool:
    """The four Python ambient observations represented by `toAmbient`.

    Tests additionally exercise `ProofKernel.license()` negative paths so this
    projection helper is not used as a substitute for checking the reference
    implementation's actual gate ordering.
    """

    return (
        read.binding_active
        and read.use == read.binding_use
        and read.context_active
        and move.scope.narrower_or_equal(read.binding_scope)
    )


def python_satisfy_option(
    kernel: ProofKernel,
    history: History,
    state: EvaluationState,
    binding_id: str,
    context_id: str,
    use: str,
    requirement: Requirement,
    candidate_ids: Sequence[str],
) -> Optional[Branch]:
    """Map ordinary Python unsatisfaction to Lean's `none` result.

    `KernelError` is intentionally not caught. In particular, an unknown
    candidate ID remains a Python fail-fast / `¬WF` case, not ordinary
    unsatisfaction.
    """

    try:
        return kernel.satisfy(
            history,
            state,
            binding_id,
            context_id,
            use,
            requirement,
            candidate_ids,
        )
    except SatisfactionError:
        return None


# ============================================================
# Lean literal encoding
# ============================================================


def _ls(value: str) -> str:
    # The conformance corpus uses ordinary UTF-8 strings. JSON string escaping
    # is compatible with the Lean string literals used by the generated module.
    return json.dumps(value, ensure_ascii=False)


def _lean_list(items: Sequence[str]) -> str:
    return "[" + ", ".join(items) + "]"


def lean_scope(scope: Scope) -> str:
    atoms = tuple(sorted(scope.atoms))
    return f"⟨{_lean_list([_ls(atom) for atom in atoms])}⟩"


def lean_claim(claim: Claim) -> str:
    return f"⟨{_ls(claim.kind)}, {_lean_list([_ls(arg) for arg in claim.args])}⟩"


_ROLE = {
    Role.CONTENT: ".content",
    Role.BRIDGE: ".bridge",
    Role.PROVENANCE: ".provenance",
    Role.COVERAGE: ".coverage",
    Role.SELECTION: ".selection",
    Role.ESCALATION: ".escalation",
    Role.AUTHORIZATION: ".authorization",
    Role.BINDING: ".binding",
}


_LICENSE = {
    LicenseType.EPISTEMIC: ".epistemic",
    LicenseType.NORMATIVE: ".normative",
    LicenseType.ACTION: ".action",
}


_MOVE = {
    MoveKind.ACCEPT: ".accept",
    MoveKind.SHARE: ".share",
    MoveKind.SUSPECT: ".suspect",
    MoveKind.REOPEN: ".reopen",
    MoveKind.ADOPT: ".adopt",
    MoveKind.ACT: ".act",
    MoveKind.RESOLVE_STATUS: ".resolveStatus",
    MoveKind.REVIEW: ".review",
}


def lean_atom(atom: Atom) -> str:
    return f"⟨{lean_claim(atom.claim)}, {_ROLE[atom.role]}, {lean_scope(atom.scope)}⟩"


def lean_requirement(requirement: Requirement) -> str:
    if isinstance(requirement, Top):
        return ".top"
    if isinstance(requirement, Atom):
        return f".atom {lean_atom(requirement)}"
    if isinstance(requirement, And):
        return (
            f".conj ({lean_requirement(requirement.left)}) "
            f"({lean_requirement(requirement.right)})"
        )
    if isinstance(requirement, Or):
        return (
            f".disj ({lean_requirement(requirement.left)}) "
            f"({lean_requirement(requirement.right)})"
        )
    raise TypeError(requirement)


def lean_branch(branch: Branch, encoding: IdEncoding) -> str:
    if branch.kind == "top":
        return ".top"
    if branch.kind == "leaf":
        if branch.obligation is None or branch.warrant_id is None:
            raise ValueError("Malformed Python leaf branch")
        return (
            f".leaf {lean_atom(branch.obligation)} "
            f"{encoding.encode(branch.warrant_id)}"
        )
    if branch.kind == "and":
        if len(branch.children) != 2:
            raise ValueError("Malformed Python and branch")
        return (
            f".both ({lean_branch(branch.children[0], encoding)}) "
            f"({lean_branch(branch.children[1], encoding)})"
        )
    if branch.kind == "or-left":
        if len(branch.children) != 1:
            raise ValueError("Malformed Python or-left branch")
        return f".orL ({lean_branch(branch.children[0], encoding)})"
    if branch.kind == "or-right":
        if len(branch.children) != 1:
            raise ValueError("Malformed Python or-right branch")
        return f".orR ({lean_branch(branch.children[0], encoding)})"
    raise ValueError(f"Unknown Python branch kind: {branch.kind}")


def lean_move(move: Move) -> str:
    return f"⟨{_MOVE[move.kind]}, {lean_scope(move.scope)}, {int(move.revision_depth)}⟩"


def lean_license_type(license_type: LicenseType) -> str:
    return _LICENSE[license_type]


def _lean_canonical_warrant(warrant: Warrant) -> str:
    return (
        "⟨"
        f"{lean_claim(warrant.claim)}, "
        f"{_ROLE[warrant.role]}, "
        f"{lean_scope(warrant.scope)}, "
        f"{_ls(warrant.formation_profile_digest)}, "
        f"{_ls(warrant.formation_context)}"
        "⟩"
    )


def _depth_function(read: CanonicalReadSnapshot) -> str:
    positive = sorted(
        (
            (claim, depth)
            for claim, depth in read.escalation_depths.items()
            if depth is not None
        ),
        key=lambda item: (item[0].kind, item[0].args),
    )
    body = "none"
    for claim, depth in reversed(positive):
        body = f"if c = {lean_claim(claim)} then some {depth} else ({body})"
    return f"def depthFn (c : Claim) : Option RevisionDepth :=\n  {body}\n"


def _warrant_function(read: CanonicalReadSnapshot) -> str:
    rows = []
    for wid, nat_id in sorted(read.id_encoding.by_string.items(), key=lambda x: x[1]):
        rows.append(f"  | {nat_id} => some {_lean_canonical_warrant(read.warrants[wid])}")
    rows.append("  | _ => none")
    return "def warrantFn : WarrantId → Option CanonicalWarrant\n" + "\n".join(rows) + "\n"


def _usable_function(read: CanonicalReadSnapshot) -> str:
    rows = []
    for wid, nat_id in sorted(read.id_encoding.by_string.items(), key=lambda x: x[1]):
        value = "true" if read.usable[wid] else "false"
        rows.append(f"  | {nat_id} => {value}")
    rows.append("  | _ => false")
    return "def usableFn : WarrantId → Bool\n" + "\n".join(rows) + "\n"


@dataclass(frozen=True)
class LeanFixtureResult:
    ambient: bool
    satisfy_matches: bool
    floor: Optional[bool]
    stdout: str


def build_lean_fixture_program(
    read: CanonicalReadSnapshot,
    move: Move,
    license_type: LicenseType,
    candidate_ids: Sequence[str],
    expected_branch: Optional[Branch],
) -> str:
    encoded_candidates = read.id_encoding.encode_sequence(candidate_ids)
    candidate_literal = _lean_list([str(wid) for wid in encoded_candidates])
    expected = (
        "none"
        if expected_branch is None
        else f"some ({lean_branch(expected_branch, read.id_encoding)})"
    )

    fallback = "⟨⟨\"ConformanceFallback\", []⟩, .content, ⟨[]⟩⟩"
    warrant_fn = _warrant_function(read)
    usable_fn = _usable_function(read)
    depth_fn = _depth_function(read)

    floor_eval = ""
    if expected_branch is not None:
        floor_eval = (
            "#eval licenseSafe C.semantics (toFloorEnv C fallback) "
            f"expectedBranch {lean_license_type(license_type)} M\n"
        )

    expected_branch_def = (
        ""
        if expected_branch is None
        else (
            "def expectedBranch : Branch := "
            f"{lean_branch(expected_branch, read.id_encoding)}\n"
        )
    )

    return f"""import ResponsibilityTopology.PythonConformance

open ResponsibilityTopology

{depth_fn}
def S : FloorSemantics := pythonConformanceSemantics depthFn

{warrant_fn}
{usable_fn}
def C : LicensingRead where
  profileDigest := {_ls(read.profile_digest)}
  contextId := {_ls(read.context_id)}
  use := {_ls(read.use)}
  bindingActive := {str(read.binding_active).lower()}
  bindingUse := {_ls(read.binding_use)}
  contextActive := {str(read.context_active).lower()}
  bindingScope := {lean_scope(read.binding_scope)}
  requirement := {lean_requirement(read.requirement)}
  warrant := warrantFn
  usable := usableFn
  semantics := S

def M : FloorMove := {lean_move(move)}
def fallback : FloorLeaf := {fallback}
{expected_branch_def}
#eval decide (Admissible (toAmbient C M))
#eval decide (satisfy (toOracle C) C.requirement {candidate_literal} = {expected})
{floor_eval}"""


def run_lean_fixture(
    program: str,
    *,
    formal_dir: Optional[Path] = None,
) -> LeanFixtureResult:
    root = Path(__file__).resolve().parent
    formal = formal_dir or (root / "formal")

    with tempfile.NamedTemporaryFile(
        mode="w",
        encoding="utf-8",
        suffix=".lean",
        prefix="ConformanceGenerated_",
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
            "Lean conformance fixture failed to elaborate:\n"
            f"STDOUT:\n{proc.stdout}\nSTDERR:\n{proc.stderr}"
        )

    bool_lines = [
        line.strip() == "true"
        for line in proc.stdout.splitlines()
        if line.strip() in {"true", "false"}
    ]
    if len(bool_lines) not in {2, 3}:
        raise RuntimeError(
            "Unexpected Lean conformance output; expected 2 or 3 Boolean results:\n"
            f"{proc.stdout}"
        )

    return LeanFixtureResult(
        ambient=bool_lines[0],
        satisfy_matches=bool_lines[1],
        floor=(bool_lines[2] if len(bool_lines) == 3 else None),
        stdout=proc.stdout,
    )


@dataclass(frozen=True)
class CrossLanguageResult:
    read: CanonicalReadSnapshot
    python_ambient: bool
    lean: LeanFixtureResult
    python_branch: Optional[Branch]
    python_floor: Optional[bool]


def run_cross_language_fixture(
    kernel: ProofKernel,
    history: History,
    state: EvaluationState,
    binding_id: str,
    context_id: str,
    use: str,
    license_type: LicenseType,
    move: Move,
    candidate_ids: Sequence[str],
) -> CrossLanguageResult:
    read = capture_licensing_read(
        kernel,
        history,
        state,
        binding_id,
        context_id,
        use,
        license_type,
        move,
    )
    branch = python_satisfy_option(
        kernel,
        history,
        state,
        binding_id,
        context_id,
        use,
        read.requirement,
        candidate_ids,
    )
    python_floor = (
        None
        if branch is None
        else kernel.license_safe(history, branch, move, license_type)
    )
    program = build_lean_fixture_program(
        read,
        move,
        license_type,
        candidate_ids,
        branch,
    )
    lean = run_lean_fixture(program)
    return CrossLanguageResult(
        read=read,
        python_ambient=python_ambient_admissible(read, move),
        lean=lean,
        python_branch=branch,
        python_floor=python_floor,
    )
