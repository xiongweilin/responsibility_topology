from __future__ import annotations

from dataclasses import dataclass, field
from enum import Enum, IntEnum
from types import MappingProxyType
from typing import Dict, FrozenSet, Iterable, List, Mapping, Optional, Sequence, Tuple
import hashlib
import itertools
import json


# ============================================================
# Closed kernel vocabulary
# ============================================================

class Role(str, Enum):
    CONTENT = "content"
    BRIDGE = "bridge"
    PROVENANCE = "provenance"
    COVERAGE = "coverage"
    SELECTION = "selection"
    ESCALATION = "escalation"
    AUTHORIZATION = "authorization"
    BINDING = "binding"


class LicenseType(str, Enum):
    EPISTEMIC = "K"
    NORMATIVE = "N"   # deliberately disabled in V0.1.2
    ACTION = "A"


class MoveKind(str, Enum):
    ACCEPT = "Accept"
    SHARE = "Share"
    SUSPECT = "Suspect"
    REOPEN = "Reopen"
    ADOPT = "Adopt"
    ACT = "Act"
    RESOLVE_STATUS = "ResolveStatus"
    REVIEW = "Review"


class RevisionDepth(IntEnum):
    NONE = 0
    LOCAL = 1
    STRUCTURE = 2
    BOUNDARY = 3
    DISTINCTION = 4
    ARCHITECTURE = 5


class RevisionReach(str, Enum):
    USE_LOCAL = "use-local"
    PROFILE_GLOBAL = "profile-global"


class EpiStatus(str, Enum):
    LIVE = "live"
    SUSPENDED = "suspended"
    DEFEATED = "defeated"


class Placement(str, Enum):
    PLACED = "placed"
    PENDING = "pending"
    ORPHANED = "orphaned"


class ContextStatus(str, Enum):
    CANDIDATE = "candidate"
    ACTIVE = "active"


@dataclass(frozen=True)
class Scope:
    atoms: FrozenSet[str]

    @staticmethod
    def of(*atoms: str) -> "Scope":
        return Scope(frozenset(atoms))

    def narrower_or_equal(self, other: "Scope") -> bool:
        return self.atoms <= other.atoms

    def key(self) -> Tuple[str, ...]:
        return tuple(sorted(self.atoms))


@dataclass(frozen=True)
class Claim:
    kind: str
    args: Tuple[str, ...] = ()

    def key(self) -> str:
        return json.dumps([self.kind, list(self.args)], separators=(",", ":"))

    def __str__(self) -> str:
        if not self.args:
            return self.kind
        return f"{self.kind}({', '.join(self.args)})"


@dataclass(frozen=True)
class Context:
    id: str
    # V0.1.2 interprets signature as permitted claim kinds.
    signature: FrozenSet[str]

    def accepts(self, claim: Claim) -> bool:
        return "*" in self.signature or claim.kind in self.signature


@dataclass(frozen=True)
class Move:
    kind: MoveKind
    args: Tuple[str, ...]
    scope: Scope
    revision_depth: RevisionDepth = RevisionDepth.NONE

    def __post_init__(self) -> None:
        if not isinstance(self.kind, MoveKind):
            raise TypeError("Move.kind must be a kernel-owned MoveKind")
        if not isinstance(self.revision_depth, RevisionDepth):
            raise TypeError("revision_depth must be RevisionDepth")
        if self.kind in {MoveKind.SUSPECT, MoveKind.REOPEN, MoveKind.ADOPT}:
            if self.revision_depth == RevisionDepth.NONE:
                raise ValueError(f"{self.kind.value} requires an explicit revision depth")
        if self.kind == MoveKind.ADOPT:
            if len(self.args) != 1:
                raise ValueError("Adopt requires exactly one target context id")
            if self.revision_depth < RevisionDepth.DISTINCTION:
                raise ValueError("Adopt requires at least DISTINCTION revision depth")


@dataclass(frozen=True)
class RootToken:
    id: str
    claim: Claim
    role: Role
    scope: Scope
    source: str


# ============================================================
# Requirement language
# ============================================================

class Requirement:
    pass


@dataclass(frozen=True)
class Top(Requirement):
    pass


@dataclass(frozen=True)
class Atom(Requirement):
    claim: Claim
    role: Role
    scope: Scope


@dataclass(frozen=True)
class And(Requirement):
    left: Requirement
    right: Requirement


@dataclass(frozen=True)
class Or(Requirement):
    left: Requirement
    right: Requirement


TOP = Top()


def atom(claim: Claim, role: Role, scope: Scope) -> Atom:
    return Atom(claim, role, scope)


def conj(*reqs: Requirement) -> Requirement:
    if not reqs:
        return TOP
    out = reqs[0]
    for req in reqs[1:]:
        out = And(out, req)
    return out


def disj(*reqs: Requirement) -> Requirement:
    if not reqs:
        return TOP
    out = reqs[0]
    for req in reqs[1:]:
        out = Or(out, req)
    return out


# ============================================================
# Profile authoring -> immutable snapshot
# ============================================================

KNOWN_KERNEL_GUARDS = frozenset({
    "distinct_content_sources",
    "distinct_content_roots",
})


@dataclass(frozen=True)
class Rule:
    id: str
    input_roles: Tuple[Role, ...]
    output_role: Role
    output_claim: Claim
    kernel_guard: Optional[str] = None


@dataclass
class Profile:
    """Mutable authoring object. Bindings never point to this object directly."""
    id: str
    version: str = "0"
    rules: Dict[str, Rule] = field(default_factory=dict)
    requirements: Dict[
        Tuple[str, str, Tuple[str, ...], int], Requirement
    ] = field(default_factory=dict)

    def add_rule(self, rule: Rule) -> None:
        self.rules[rule.id] = rule

    def set_requirement(
        self, license_type: LicenseType, move: Move, req: Requirement
    ) -> None:
        self.requirements[
            (
                license_type.value,
                move.kind.value,
                move.args,
                int(move.revision_depth),
            )
        ] = req

    def freeze(self) -> "ProfileSnapshot":
        rules = tuple(sorted(self.rules.items(), key=lambda x: x[0]))
        reqs = tuple(
            sorted(
                self.requirements.items(),
                key=lambda x: (x[0][0], x[0][1], x[0][2], x[0][3]),
            )
        )
        payload = {
            "id": self.id,
            "version": self.version,
            "rules": [_rule_json(k, v) for k, v in rules],
            "requirements": [
                [[k[0], k[1], list(k[2]), k[3]], _req_json(v)]
                for k, v in reqs
            ],
        }
        digest = hashlib.sha256(
            json.dumps(payload, sort_keys=True, separators=(",", ":")).encode()
        ).hexdigest()
        return ProfileSnapshot(self.id, self.version, digest, rules, reqs)


@dataclass(frozen=True)
class ProfileSnapshot:
    id: str
    version: str
    digest: str
    rules: Tuple[Tuple[str, Rule], ...]
    requirements: Tuple[
        Tuple[Tuple[str, str, Tuple[str, ...], int], Requirement], ...
    ]

    def rule_for(self, rule_id: str) -> Rule:
        for key, rule in self.rules:
            if key == rule_id:
                return rule
        raise FormationError(f"Unknown rule in bound profile snapshot: {rule_id}")

    def requirement_for(
        self, license_type: LicenseType, move: Move
    ) -> Requirement:
        key = (
            license_type.value,
            move.kind.value,
            move.args,
            int(move.revision_depth),
        )
        for candidate, req in self.requirements:
            if candidate == key:
                return req
        raise LicenseError(
            "No declared requirement in bound profile snapshot for "
            f"{license_type.value}:{move.kind.value}{move.args}"
            f"@depth={int(move.revision_depth)}"
        )


def _claim_json(c: Claim):
    return [c.kind, list(c.args)]


def _scope_json(s: Scope):
    return list(s.key())


def _rule_json(key: str, r: Rule):
    return [
        key,
        [x.value for x in r.input_roles],
        r.output_role.value,
        _claim_json(r.output_claim),
        r.kernel_guard,
    ]


def _req_json(req: Requirement):
    if isinstance(req, Top):
        return ["top"]
    if isinstance(req, Atom):
        return [
            "atom",
            _claim_json(req.claim),
            req.role.value,
            _scope_json(req.scope),
        ]
    if isinstance(req, And):
        return ["and", _req_json(req.left), _req_json(req.right)]
    if isinstance(req, Or):
        return ["or", _req_json(req.left), _req_json(req.right)]
    raise TypeError(req)


# ============================================================
# Canonical historical objects
# ============================================================

@dataclass(frozen=True)
class Warrant:
    id: str
    claim: Claim
    role: Role
    scope: Scope
    constructor: str
    parents: Tuple[str, ...]
    formation_profile_digest: str
    formation_context: str
    source: Optional[str] = None

    # Two different notions are kept explicitly separate.
    root_ids_by_role: Mapping[Role, FrozenSet[str]] = field(
        default_factory=dict, compare=False
    )
    source_ids_by_role: Mapping[Role, FrozenSet[str]] = field(
        default_factory=dict, compare=False
    )


@dataclass(frozen=True)
class Branch:
    kind: str
    children: Tuple["Branch", ...] = ()
    obligation: Optional[Atom] = None
    warrant_id: Optional[str] = None

    @property
    def leaves(self) -> Tuple["Branch", ...]:
        if self.kind == "leaf":
            return (self,)
        out: List[Branch] = []
        for child in self.children:
            out.extend(child.leaves)
        return tuple(out)


@dataclass(frozen=True)
class Binding:
    id: str
    profile_id: str
    profile_version: str
    profile_digest: str
    scope: Scope
    use: str
    source: str


@dataclass(frozen=True)
class LicenseRecord:
    id: str
    kernel_id: str
    binding_id: str
    profile_digest: str
    context_id: str
    agents: Tuple[str, ...]
    use: str
    license_type: LicenseType
    move: Move
    branch: Branch
    used_warrants: FrozenSet[str]


# ============================================================
# Trusted state boundary
# ============================================================

@dataclass(frozen=True)
class EvalKey:
    profile_digest: str
    context_id: str
    use: str
    warrant_id: str


class History:
    """Canonical append-only store.

    Caller-facing properties are read-only MappingProxyType views.
    Mutation helpers are private and intended to be called only by ProofKernel.
    Python reflection/private-field hacking is outside the V0.1.2 threat model.
    """

    def __init__(self) -> None:
        self._contexts: Dict[str, Context] = {}
        self._profiles: Dict[str, ProfileSnapshot] = {}
        self._bindings: Dict[str, Binding] = {}
        self._warrants: Dict[str, Warrant] = {}
        self._licenses: Dict[str, LicenseRecord] = {}
        self._children: Dict[str, FrozenSet[str]] = {}
        self._events: List[dict] = []

    @property
    def contexts(self) -> Mapping[str, Context]:
        return MappingProxyType(self._contexts)

    @property
    def profiles(self) -> Mapping[str, ProfileSnapshot]:
        return MappingProxyType(self._profiles)

    @property
    def bindings(self) -> Mapping[str, Binding]:
        return MappingProxyType(self._bindings)

    @property
    def warrants(self) -> Mapping[str, Warrant]:
        return MappingProxyType(self._warrants)

    @property
    def licenses(self) -> Mapping[str, LicenseRecord]:
        return MappingProxyType(self._licenses)

    @property
    def events(self) -> Tuple[dict, ...]:
        return tuple(dict(e) for e in self._events)

    def descendants(self, warrant_id: str) -> FrozenSet[str]:
        seen: set[str] = set()
        stack = list(self._children.get(warrant_id, frozenset()))
        while stack:
            wid = stack.pop()
            if wid in seen:
                continue
            seen.add(wid)
            stack.extend(self._children.get(wid, frozenset()))
        return frozenset(seen)

    # ---- kernel-only mutators ----

    def _register_context(self, context: Context) -> None:
        prior = self._contexts.get(context.id)
        if prior is not None and prior != context:
            raise KernelError(f"Context id collision: {context.id}")
        self._contexts[context.id] = context

    def _register_profile(self, snapshot: ProfileSnapshot) -> None:
        self._profiles.setdefault(snapshot.digest, snapshot)

    def _add_binding(self, binding: Binding) -> None:
        if binding.id in self._bindings:
            raise KernelError(f"Duplicate binding id: {binding.id}")
        self._bindings[binding.id] = binding

    def _add_warrant(self, warrant: Warrant) -> None:
        if warrant.id in self._warrants:
            raise KernelError(f"Duplicate warrant id: {warrant.id}")
        self._warrants[warrant.id] = warrant
        for parent in warrant.parents:
            kids = set(self._children.get(parent, frozenset()))
            kids.add(warrant.id)
            self._children[parent] = frozenset(kids)

    def _add_license(self, license_record: LicenseRecord) -> None:
        if license_record.id in self._licenses:
            raise KernelError(f"Duplicate license id: {license_record.id}")
        self._licenses[license_record.id] = license_record

    def _add_event(self, event: dict) -> None:
        self._events.append(dict(event))


class EvaluationState:
    """Mutable evaluation state with read-only caller-facing views."""

    def __init__(self) -> None:
        self._epi: Dict[EvalKey, EpiStatus] = {}
        self._placement: Dict[EvalKey, Placement] = {}
        self._active_bindings: set[str] = set()
        self._active_contexts: set[Tuple[str, str, str]] = set()
        self._review_required: set[str] = set()

    @property
    def epi(self) -> Mapping[EvalKey, EpiStatus]:
        return MappingProxyType(self._epi)

    @property
    def placement(self) -> Mapping[EvalKey, Placement]:
        return MappingProxyType(self._placement)

    @property
    def active_bindings(self) -> FrozenSet[str]:
        return frozenset(self._active_bindings)

    @property
    def active_contexts(self) -> FrozenSet[Tuple[str, str, str]]:
        return frozenset(self._active_contexts)

    @property
    def review_required(self) -> FrozenSet[str]:
        return frozenset(self._review_required)

    def key(
        self,
        profile_digest: str,
        context_id: str,
        use: str,
        warrant_id: str,
    ) -> EvalKey:
        return EvalKey(profile_digest, context_id, use, warrant_id)

    def usable(
        self,
        profile_digest: str,
        context_id: str,
        use: str,
        warrant_id: str,
    ) -> bool:
        key = self.key(profile_digest, context_id, use, warrant_id)
        return (
            self._epi.get(key) == EpiStatus.LIVE
            and self._placement.get(key) == Placement.PLACED
        )

    def context_status(
        self, binding_id: str, context_id: str, use: str
    ) -> ContextStatus:
        if (binding_id, context_id, use) in self._active_contexts:
            return ContextStatus.ACTIVE
        return ContextStatus.CANDIDATE

    # ---- kernel-only mutators ----

    def _set_status(
        self,
        profile_digest: str,
        context_id: str,
        use: str,
        warrant_id: str,
        epi: EpiStatus,
        placement: Placement,
    ) -> None:
        key = self.key(profile_digest, context_id, use, warrant_id)
        self._epi[key] = epi
        self._placement[key] = placement

    def _activate_binding(self, binding_id: str) -> None:
        self._active_bindings.add(binding_id)

    def _activate_context(
        self, binding_id: str, context_id: str, use: str
    ) -> None:
        self._active_contexts.add((binding_id, context_id, use))

    def _mark_review(self, license_ids: Iterable[str]) -> None:
        self._review_required.update(license_ids)


# ============================================================
# Errors
# ============================================================

class KernelError(Exception):
    pass


class FormationError(KernelError):
    pass


class SatisfactionError(KernelError):
    pass


class LicenseError(KernelError):
    pass


# ============================================================
# V0.1.2 kernel
# ============================================================

class ProofKernel:
    def __init__(self, kernel_id: str = "K0") -> None:
        self.id = kernel_id
        self._ids = itertools.count(1)

    def _fresh(self, prefix: str) -> str:
        return f"{prefix}{next(self._ids)}"

    # ---------------- Canonical lookup ----------------

    def _binding(self, history: History, binding_id: str) -> Binding:
        try:
            return history.bindings[binding_id]
        except KeyError:
            raise KernelError(f"Unknown canonical binding id: {binding_id}")

    def _profile(
        self, history: History, binding_id: str
    ) -> ProfileSnapshot:
        binding = self._binding(history, binding_id)
        return history.profiles[binding.profile_digest]

    def _context(self, history: History, context_id: str) -> Context:
        try:
            return history.contexts[context_id]
        except KeyError:
            raise KernelError(f"Unknown canonical context id: {context_id}")

    def _warrant(self, history: History, warrant_id: str) -> Warrant:
        try:
            return history.warrants[warrant_id]
        except KeyError:
            raise KernelError(f"Unknown canonical warrant id: {warrant_id}")

    def _license(
        self, history: History, license_id: str
    ) -> LicenseRecord:
        try:
            return history.licenses[license_id]
        except KeyError:
            raise KernelError(f"Unknown canonical license id: {license_id}")

    # ---------------- Explicit external boundaries ----------------

    def register_context_candidate(
        self, history: History, context: Context, *, source: str
    ) -> None:
        history._register_context(context)
        history._add_event({
            "kind": "register_context_candidate",
            "context": context.id,
            "source": source,
        })

    def bind_profile(
        self,
        history: History,
        state: EvaluationState,
        profile: Profile,
        scope: Scope,
        use: str,
        *,
        source: str,
    ) -> str:
        snapshot = profile.freeze()
        history._register_profile(snapshot)
        binding_id = self._fresh("b")
        binding = Binding(
            id=binding_id,
            profile_id=snapshot.id,
            profile_version=snapshot.version,
            profile_digest=snapshot.digest,
            scope=scope,
            use=use,
            source=source,
        )
        history._add_binding(binding)
        state._activate_binding(binding_id)
        history._add_event({
            "kind": "bind_profile",
            "binding": binding_id,
            "profile": snapshot.id,
            "version": snapshot.version,
            "digest": snapshot.digest,
            "source": source,
        })
        return binding_id

    def bootstrap_activate_context(
        self,
        history: History,
        state: EvaluationState,
        binding_id: str,
        context_id: str,
        use: str,
        *,
        source: str,
    ) -> None:
        """Explicit starting-boundary event.

        Only allowed when this binding/use has no active context yet.
        Later context activations must consume an Adopt license.
        """
        binding = self._binding(history, binding_id)
        self._context(history, context_id)
        if binding.use != use:
            raise KernelError("Binding/use mismatch")
        if any(
            b == binding_id and u == use
            for (b, _c, u) in state.active_contexts
        ):
            raise KernelError(
                "Bootstrap activation only allowed before any active context exists"
            )
        state._activate_context(binding_id, context_id, use)
        history._add_event({
            "kind": "bootstrap_activate_context",
            "binding": binding_id,
            "context": context_id,
            "use": use,
            "source": source,
        })

    # ---------------- Kernel typing ----------------

    def _guard_is_known(self, guard: Optional[str]) -> bool:
        return guard is None or guard in KNOWN_KERNEL_GUARDS

    def well_typed_rule(self, rule: Rule) -> bool:
        if not self._guard_is_known(rule.kernel_guard):
            return False

        inputs = set(rule.input_roles)
        output = rule.output_role

        # Special audited transition: CONTENT^n -> PROVENANCE.
        if output == Role.PROVENANCE and rule.kernel_guard in {
            "distinct_content_sources",
            "distinct_content_roots",
        }:
            return bool(rule.input_roles) and all(
                r == Role.CONTENT for r in rule.input_roles
            )

        protected = {
            Role.AUTHORIZATION,
            Role.BINDING,
            Role.ESCALATION,
            Role.PROVENANCE,
            Role.COVERAGE,
            Role.BRIDGE,
        }
        if output in protected and output not in inputs:
            return False
        if output == Role.CONTENT and Role.CONTENT not in inputs:
            return False
        if output == Role.SELECTION and not inputs:
            return False
        return True

    @staticmethod
    def _claim_depth(claim: Claim) -> Optional[RevisionDepth]:
        if claim.kind != "EscalationDepth" or len(claim.args) != 1:
            return None
        try:
            return RevisionDepth(int(claim.args[0]))
        except (ValueError, TypeError):
            return None

    def _merge_role_map(
        self,
        warrants: Iterable[Warrant],
        attr: str,
    ) -> Dict[Role, FrozenSet[str]]:
        acc: Dict[Role, set[str]] = {r: set() for r in Role}
        for warrant in warrants:
            mapping = getattr(warrant, attr)
            for role, values in mapping.items():
                acc[role].update(values)
        return {r: frozenset(v) for r, v in acc.items() if v}

    # ---------------- Warrant formation ----------------

    def root(
        self,
        history: History,
        binding_id: str,
        context_id: str,
        token: RootToken,
    ) -> str:
        binding = self._binding(history, binding_id)
        context = self._context(history, context_id)
        if not context.accepts(token.claim):
            raise FormationError(
                f"Claim {token.claim} is outside context signature {context.id}"
            )

        warrant_id = self._fresh("w")
        warrant = Warrant(
            id=warrant_id,
            claim=token.claim,
            role=token.role,
            scope=token.scope,
            constructor="root",
            parents=(),
            formation_profile_digest=binding.profile_digest,
            formation_context=context_id,
            source=token.source,
            root_ids_by_role={token.role: frozenset({warrant_id})},
            source_ids_by_role={token.role: frozenset({token.source})},
        )
        history._add_warrant(warrant)
        history._add_event({
            "kind": "root",
            "warrant": warrant_id,
            "source": token.source,
        })
        return warrant_id

    def _check_kernel_guard(
        self,
        rule: Rule,
        parents: Sequence[Warrant],
    ) -> None:
        guard = rule.kernel_guard
        if guard is None:
            return
        if guard not in KNOWN_KERNEL_GUARDS:
            raise FormationError(f"Unknown kernel guard: {guard}")

        if guard == "distinct_content_sources":
            sets = [
                p.source_ids_by_role.get(Role.CONTENT, frozenset())
                for p in parents
            ]
        elif guard == "distinct_content_roots":
            sets = [
                p.root_ids_by_role.get(Role.CONTENT, frozenset())
                for p in parents
            ]
        else:
            raise FormationError(f"Unhandled kernel guard: {guard}")

        if any(not values for values in sets):
            raise FormationError(f"{guard} requires content ancestry")
        for i in range(len(sets)):
            for j in range(i + 1, len(sets)):
                if sets[i] & sets[j]:
                    raise FormationError(f"{guard} failed: overlap detected")

    def infer(
        self,
        history: History,
        binding_id: str,
        context_id: str,
        rule_id: str,
        parent_ids: Sequence[str],
        out_scope: Optional[Scope] = None,
    ) -> str:
        binding = self._binding(history, binding_id)
        profile = self._profile(history, binding_id)
        context = self._context(history, context_id)
        rule = profile.rule_for(rule_id)

        if not self.well_typed_rule(rule):
            raise FormationError(f"Kernel rejects ill-typed rule: {rule.id}")

        parents = [self._warrant(history, wid) for wid in parent_ids]

        # Ordinary INFER is strictly intra-context and intra-profile-snapshot.
        if any(w.formation_context != context_id for w in parents):
            raise FormationError(
                "Ordinary INFER is intra-context; use TRANSPORT"
            )
        if any(
            w.formation_profile_digest != binding.profile_digest
            for w in parents
        ):
            raise FormationError(
                "Parent warrant belongs to another profile snapshot"
            )
        if tuple(w.role for w in parents) != rule.input_roles:
            raise FormationError(
                "Rule input roles do not match canonical parents"
            )
        if not context.accepts(rule.output_claim):
            raise FormationError(
                "Rule output is outside target context signature"
            )

        self._check_kernel_guard(rule, parents)

        # No implicit escalation-depth amplification.
        if rule.output_role == Role.ESCALATION:
            out_depth = self._claim_depth(rule.output_claim)
            if out_depth is not None:
                parent_depths = [
                    self._claim_depth(p.claim)
                    for p in parents
                    if p.role == Role.ESCALATION
                ]
                parent_depths = [d for d in parent_depths if d is not None]
                if not parent_depths or out_depth > max(parent_depths):
                    raise FormationError(
                        "Inference cannot amplify escalation depth"
                    )

        if out_scope is None:
            common = set(parents[0].scope.atoms)
            for parent in parents[1:]:
                common &= set(parent.scope.atoms)
            out_scope = Scope(frozenset(common))
        if any(
            not out_scope.narrower_or_equal(parent.scope)
            for parent in parents
        ):
            raise FormationError("Inference would widen scope")

        warrant_id = self._fresh("w")
        warrant = Warrant(
            id=warrant_id,
            claim=rule.output_claim,
            role=rule.output_role,
            scope=out_scope,
            constructor=f"infer:{rule.id}",
            parents=tuple(parent_ids),
            formation_profile_digest=binding.profile_digest,
            formation_context=context_id,
            root_ids_by_role=self._merge_role_map(
                parents, "root_ids_by_role"
            ),
            source_ids_by_role=self._merge_role_map(
                parents, "source_ids_by_role"
            ),
        )
        history._add_warrant(warrant)
        history._add_event({
            "kind": "infer",
            "warrant": warrant_id,
            "rule": rule.id,
        })
        return warrant_id

    def transport(
        self,
        history: History,
        binding_id: str,
        target_context_id: str,
        *,
        map_id: str,
        original_id: str,
        witness_id: str,
        translated_claim: Claim,
        out_scope: Scope,
    ) -> str:
        binding = self._binding(history, binding_id)
        target_context = self._context(history, target_context_id)
        original = self._warrant(history, original_id)
        witness = self._warrant(history, witness_id)

        if (
            original.formation_profile_digest != binding.profile_digest
            or witness.formation_profile_digest != binding.profile_digest
        ):
            raise FormationError(
                "Transport parents belong to another profile snapshot"
            )

        expected = Claim(
            "Transportable",
            (
                map_id,
                original_id,
                target_context_id,
                translated_claim.key(),
            ),
        )
        if witness.role != Role.BRIDGE or witness.claim != expected:
            raise FormationError(
                "Transport witness is not bound to this exact translation"
            )
        if not target_context.accepts(translated_claim):
            raise FormationError(
                "Translated claim is outside target context signature"
            )
        if not out_scope.narrower_or_equal(original.scope):
            raise FormationError("Transport would widen scope")

        root_ids = {
            r: set(v) for r, v in original.root_ids_by_role.items()
        }
        source_ids = {
            r: set(v) for r, v in original.source_ids_by_role.items()
        }

        bridge_roots = root_ids.setdefault(Role.BRIDGE, set())
        bridge_sources = source_ids.setdefault(Role.BRIDGE, set())

        for values in witness.root_ids_by_role.values():
            bridge_roots.update(values)
        for values in witness.source_ids_by_role.values():
            bridge_sources.update(values)

        warrant_id = self._fresh("w")
        warrant = Warrant(
            id=warrant_id,
            claim=translated_claim,
            role=original.role,
            scope=out_scope,
            constructor=f"transport:{map_id}",
            parents=(original_id, witness_id),
            formation_profile_digest=binding.profile_digest,
            formation_context=target_context_id,
            root_ids_by_role={
                r: frozenset(v) for r, v in root_ids.items() if v
            },
            source_ids_by_role={
                r: frozenset(v) for r, v in source_ids.items() if v
            },
        )
        history._add_warrant(warrant)
        history._add_event({
            "kind": "transport",
            "warrant": warrant_id,
            "map": map_id,
        })
        return warrant_id

    # ---------------- Admission / qualification ----------------

    def admit_root(
        self,
        history: History,
        state: EvaluationState,
        binding_id: str,
        context_id: str,
        use: str,
        warrant_id: str,
        *,
        actor: str,
        basis: str,
    ) -> None:
        binding = self._binding(history, binding_id)
        self._context(history, context_id)
        warrant = self._warrant(history, warrant_id)

        if warrant.constructor != "root":
            raise KernelError(
                "External admission is restricted to root warrants"
            )
        if warrant.formation_context != context_id:
            raise KernelError(
                "Root may only be admitted in its formation context"
            )
        if (
            warrant.formation_profile_digest != binding.profile_digest
            or binding.use != use
        ):
            raise KernelError("Admission environment mismatch")

        state._set_status(
            binding.profile_digest,
            context_id,
            use,
            warrant_id,
            EpiStatus.LIVE,
            Placement.PLACED,
        )
        history._add_event({
            "kind": "admit_root",
            "warrant": warrant_id,
            "actor": actor,
            "basis": basis,
        })

    def qualify_derived(
        self,
        history: History,
        state: EvaluationState,
        binding_id: str,
        context_id: str,
        use: str,
        warrant_id: str,
        *,
        actor: str,
        basis: str,
    ) -> None:
        binding = self._binding(history, binding_id)
        warrant = self._warrant(history, warrant_id)

        if warrant.constructor == "root":
            raise KernelError("Root warrants must use admission")
        if (
            warrant.formation_context != context_id
            or warrant.formation_profile_digest != binding.profile_digest
        ):
            raise KernelError(
                "Derived qualification environment mismatch"
            )

        if warrant.constructor.startswith("infer:"):
            if any(
                not state.usable(
                    binding.profile_digest, context_id, use, parent_id
                )
                for parent_id in warrant.parents
            ):
                raise KernelError(
                    "Cannot qualify inference from unusable parents"
                )

        elif warrant.constructor.startswith("transport:"):
            for parent_id in warrant.parents:
                parent = self._warrant(history, parent_id)
                if not state.usable(
                    binding.profile_digest,
                    parent.formation_context,
                    use,
                    parent_id,
                ):
                    raise KernelError(
                        "Cannot qualify transport from unusable source warrant"
                    )
        else:
            raise KernelError("Unknown derived constructor")

        state._set_status(
            binding.profile_digest,
            context_id,
            use,
            warrant_id,
            EpiStatus.LIVE,
            Placement.PLACED,
        )
        history._add_event({
            "kind": "qualify_derived",
            "warrant": warrant_id,
            "actor": actor,
            "basis": basis,
        })

    # ---------------- Requirement satisfaction ----------------

    def satisfy(
        self,
        history: History,
        state: EvaluationState,
        binding_id: str,
        context_id: str,
        use: str,
        req: Requirement,
        candidate_ids: Sequence[str],
    ) -> Branch:
        binding = self._binding(history, binding_id)
        self._context(history, context_id)

        if isinstance(req, Top):
            return Branch("top")

        if isinstance(req, Atom):
            for warrant_id in candidate_ids:
                warrant = self._warrant(history, warrant_id)
                if (
                    state.usable(
                        binding.profile_digest,
                        context_id,
                        use,
                        warrant_id,
                    )
                    and warrant.formation_context == context_id
                    and warrant.formation_profile_digest
                    == binding.profile_digest
                    and warrant.claim == req.claim
                    and warrant.role == req.role
                    and req.scope.narrower_or_equal(warrant.scope)
                ):
                    return Branch(
                        "leaf",
                        obligation=req,
                        warrant_id=warrant_id,
                    )
            raise SatisfactionError(f"Unsatisfied atom: {req}")

        if isinstance(req, And):
            left = self.satisfy(
                history,
                state,
                binding_id,
                context_id,
                use,
                req.left,
                candidate_ids,
            )
            right = self.satisfy(
                history,
                state,
                binding_id,
                context_id,
                use,
                req.right,
                candidate_ids,
            )
            return Branch("and", (left, right))

        if isinstance(req, Or):
            try:
                left = self.satisfy(
                    history,
                    state,
                    binding_id,
                    context_id,
                    use,
                    req.left,
                    candidate_ids,
                )
                return Branch("or-left", (left,))
            except SatisfactionError:
                right = self.satisfy(
                    history,
                    state,
                    binding_id,
                    context_id,
                    use,
                    req.right,
                    candidate_ids,
                )
                return Branch("or-right", (right,))

        raise TypeError(req)

    # ---------------- Kernel-owned move strength ----------------

    def _max_escalation_depth(
        self,
        history: History,
        leaf_warrants: Sequence[Warrant],
    ) -> RevisionDepth:
        depths = [
            self._claim_depth(w.claim)
            for w in leaf_warrants
            if w.role == Role.ESCALATION
        ]
        depths = [d for d in depths if d is not None]
        return max(depths, default=RevisionDepth.NONE)

    def license_safe(
        self,
        history: History,
        branch: Branch,
        move: Move,
        license_type: LicenseType,
    ) -> bool:
        if license_type == LicenseType.NORMATIVE:
            return False

        leaf_warrants = [
            self._warrant(history, leaf.warrant_id)
            for leaf in branch.leaves
            if leaf.warrant_id is not None
        ]

        if any(
            not move.scope.narrower_or_equal(w.scope)
            for w in leaf_warrants
        ):
            return False

        roles = {w.role for w in leaf_warrants}

        if license_type == LicenseType.ACTION or move.kind == MoveKind.ACT:
            if Role.AUTHORIZATION not in roles:
                return False

        if move.kind == MoveKind.SHARE:
            if Role.SELECTION not in roles:
                return False

        if move.kind in {
            MoveKind.SUSPECT,
            MoveKind.REOPEN,
            MoveKind.ADOPT,
        }:
            if Role.ESCALATION not in roles:
                return False
            if self._max_escalation_depth(
                history, leaf_warrants
            ) < move.revision_depth:
                return False

        if move.kind == MoveKind.ADOPT:
            if Role.SELECTION not in roles:
                return False

        if move.kind == MoveKind.RESOLVE_STATUS:
            if not (
                Role.SELECTION in roles
                or Role.AUTHORIZATION in roles
            ):
                return False

        # REVIEW/ACCEPT have no extra kernel floor in V0.1.2.
        return True

    # ---------------- Licensing / current reusability ----------------

    def license(
        self,
        history: History,
        state: EvaluationState,
        binding_id: str,
        context_id: str,
        agents: Sequence[str],
        use: str,
        license_type: LicenseType,
        move: Move,
        candidate_ids: Sequence[str],
    ) -> LicenseRecord:
        binding = self._binding(history, binding_id)
        self._context(history, context_id)

        if binding_id not in state.active_bindings:
            raise LicenseError("Profile binding is not active")
        if binding.use != use:
            raise LicenseError("Binding/use mismatch")
        if (
            state.context_status(binding_id, context_id, use)
            != ContextStatus.ACTIVE
        ):
            raise LicenseError(
                "Operational licensing requires an active context"
            )
        if not move.scope.narrower_or_equal(binding.scope):
            raise LicenseError("Move exceeds canonical binding scope")

        profile = self._profile(history, binding_id)
        req = profile.requirement_for(license_type, move)
        branch = self.satisfy(
            history,
            state,
            binding_id,
            context_id,
            use,
            req,
            candidate_ids,
        )
        if not self.license_safe(
            history, branch, move, license_type
        ):
            raise LicenseError("Kernel LicenseSafe check failed")

        license_id = self._fresh("L")
        used = frozenset(
            leaf.warrant_id
            for leaf in branch.leaves
            if leaf.warrant_id is not None
        )
        record = LicenseRecord(
            id=license_id,
            kernel_id=self.id,
            binding_id=binding_id,
            profile_digest=binding.profile_digest,
            context_id=context_id,
            agents=tuple(agents),
            use=use,
            license_type=license_type,
            move=move,
            branch=branch,
            used_warrants=used,
        )
        history._add_license(record)
        history._add_event({
            "kind": "license",
            "license": license_id,
            "move": move.kind.value,
        })
        return record

    def check_license_current(
        self,
        history: History,
        state: EvaluationState,
        license_id: str,
    ) -> bool:
        license_record = self._license(history, license_id)
        try:
            binding = self._binding(
                history, license_record.binding_id
            )
        except KernelError:
            return False

        if license_record.binding_id not in state.active_bindings:
            return False
        if binding.profile_digest != license_record.profile_digest:
            return False
        if binding.use != license_record.use:
            return False
        if (
            state.context_status(
                license_record.binding_id,
                license_record.context_id,
                license_record.use,
            )
            != ContextStatus.ACTIVE
        ):
            return False
        if license_id in state.review_required:
            return False
        if not license_record.move.scope.narrower_or_equal(
            binding.scope
        ):
            return False

        for leaf in license_record.branch.leaves:
            if leaf.warrant_id is None:
                continue
            if not state.usable(
                license_record.profile_digest,
                license_record.context_id,
                license_record.use,
                leaf.warrant_id,
            ):
                return False
        return True

    def activate_context_with_adopt_license(
        self,
        history: History,
        state: EvaluationState,
        license_id: str,
        target_context_id: str,
    ) -> None:
        record = self._license(history, license_id)
        self._context(history, target_context_id)

        if record.move.kind != MoveKind.ADOPT:
            raise KernelError(
                "Context activation requires an Adopt license"
            )
        if record.move.args != (target_context_id,):
            raise KernelError(
                "Adopt license targets a different context"
            )
        if not self.check_license_current(
            history, state, license_id
        ):
            raise KernelError(
                "Historical Adopt license is not currently reusable"
            )

        state._activate_context(
            record.binding_id,
            target_context_id,
            record.use,
        )
        history._add_event({
            "kind": "activate_context",
            "context": target_context_id,
            "license": license_id,
        })

    # ---------------- Challenge / dependency revalidation ----------------

    def challenge(
        self,
        history: History,
        state: EvaluationState,
        binding_id: str,
        context_id: str,
        use: str,
        *,
        challenger_id: str,
        challenge_bridge_id: str,
        target_id: str,
    ) -> FrozenSet[str]:
        binding = self._binding(history, binding_id)
        self._context(history, context_id)
        challenger = self._warrant(history, challenger_id)
        bridge = self._warrant(history, challenge_bridge_id)
        self._warrant(history, target_id)

        if not state.usable(
            binding.profile_digest,
            context_id,
            use,
            challenger_id,
        ):
            raise KernelError(
                "Challenger is not usable in challenge context"
            )
        if not state.usable(
            binding.profile_digest,
            context_id,
            use,
            challenge_bridge_id,
        ):
            raise KernelError(
                "Challenge bridge is not usable in challenge context"
            )

        expected = Claim(
            "Challenges", (challenger_id, target_id)
        )
        if bridge.role != Role.BRIDGE or bridge.claim != expected:
            raise KernelError(
                "Challenge bridge does not canonically target this warrant"
            )

        impacted = (
            frozenset({target_id})
            | history.descendants(target_id)
        )

        for warrant_id in impacted:
            for key in list(state._epi.keys()):
                if (
                    key.warrant_id != warrant_id
                    or key.profile_digest
                    != binding.profile_digest
                    or key.use != use
                ):
                    continue
                if state._epi.get(key) == EpiStatus.LIVE:
                    state._epi[key] = EpiStatus.SUSPENDED
                if (
                    warrant_id != target_id
                    and state._placement.get(key)
                    == Placement.PLACED
                ):
                    state._placement[key] = Placement.PENDING

        affected_licenses = {
            lid
            for lid, lic in history.licenses.items()
            if lic.profile_digest == binding.profile_digest
            and lic.use == use
            and bool(lic.used_warrants & impacted)
        }
        state._mark_review(affected_licenses)
        history._add_event({
            "kind": "challenge",
            "target": target_id,
            "use": use,
            "impacted": sorted(impacted),
            "affected_licenses": sorted(affected_licenses),
        })
        return impacted

    # ---------------- Explicit revision reach ----------------

    def apply_revision(
        self,
        history: History,
        state: EvaluationState,
        binding_id: str,
        affected_ids: Iterable[str],
        *,
        reach: RevisionReach,
        use: Optional[str],
        reason: str,
    ) -> None:
        binding = self._binding(history, binding_id)
        ids = tuple(affected_ids)
        for warrant_id in ids:
            self._warrant(history, warrant_id)

        if reach == RevisionReach.USE_LOCAL:
            if use is None:
                raise KernelError(
                    "USE_LOCAL revision requires an explicit use"
                )
            if use != binding.use:
                raise KernelError(
                    "USE_LOCAL revision must match binding use"
                )
        elif reach == RevisionReach.PROFILE_GLOBAL:
            if use is not None:
                raise KernelError(
                    "PROFILE_GLOBAL revision must not carry a use"
                )
        else:
            raise KernelError("Unknown revision reach")

        for warrant_id in ids:
            for key in list(state._epi.keys()):
                if (
                    key.profile_digest != binding.profile_digest
                    or key.warrant_id != warrant_id
                ):
                    continue
                if (
                    reach == RevisionReach.USE_LOCAL
                    and key.use != use
                ):
                    continue
                if state._epi.get(key) == EpiStatus.LIVE:
                    state._epi[key] = EpiStatus.SUSPENDED
                if (
                    state._placement.get(key)
                    == Placement.PLACED
                ):
                    state._placement[key] = Placement.PENDING

        # Mark only licenses within the declared reach.
        affected_licenses = {
            lid
            for lid, lic in history.licenses.items()
            if lic.profile_digest == binding.profile_digest
            and bool(lic.used_warrants & frozenset(ids))
            and (
                reach == RevisionReach.PROFILE_GLOBAL
                or lic.use == use
            )
        }
        state._mark_review(affected_licenses)
        history._add_event({
            "kind": "revision",
            "binding": binding_id,
            "reach": reach.value,
            "use": use,
            "affected": list(ids),
            "affected_licenses": sorted(affected_licenses),
            "reason": reason,
        })

    # ---------------- Residual requirement / debt ----------------

    def residual(
        self,
        history: History,
        state: EvaluationState,
        binding_id: str,
        context_id: str,
        use: str,
        req: Requirement,
        candidate_ids: Sequence[str],
    ) -> Requirement:
        if isinstance(req, Top):
            return TOP

        if isinstance(req, Atom):
            try:
                self.satisfy(
                    history,
                    state,
                    binding_id,
                    context_id,
                    use,
                    req,
                    candidate_ids,
                )
                return TOP
            except SatisfactionError:
                return req

        if isinstance(req, And):
            left = self.residual(
                history,
                state,
                binding_id,
                context_id,
                use,
                req.left,
                candidate_ids,
            )
            right = self.residual(
                history,
                state,
                binding_id,
                context_id,
                use,
                req.right,
                candidate_ids,
            )
            if isinstance(left, Top):
                return right
            if isinstance(right, Top):
                return left
            return And(left, right)

        if isinstance(req, Or):
            left = self.residual(
                history,
                state,
                binding_id,
                context_id,
                use,
                req.left,
                candidate_ids,
            )
            right = self.residual(
                history,
                state,
                binding_id,
                context_id,
                use,
                req.right,
                candidate_ids,
            )
            if isinstance(left, Top) or isinstance(right, Top):
                return TOP
            return Or(left, right)

        raise TypeError(req)
