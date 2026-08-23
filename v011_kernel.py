from __future__ import annotations

from dataclasses import dataclass, field
from enum import Enum
from typing import Dict, FrozenSet, Iterable, List, Mapping, Optional, Sequence, Tuple
import hashlib
import itertools
import json


# ============================================================
# Static vocabulary
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
    NORMATIVE = "N"  # deliberately disabled in V0.1.1
    ACTION = "A"


class EpiStatus(str, Enum):
    LIVE = "live"
    SUSPENDED = "suspended"
    DEFEATED = "defeated"


class Placement(str, Enum):
    PLACED = "placed"
    PENDING = "pending"
    ORPHANED = "orphaned"


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
    # V0.1.1 interprets the signature as permitted claim kinds.
    signature: FrozenSet[str]

    def accepts(self, claim: Claim) -> bool:
        return "*" in self.signature or claim.kind in self.signature


@dataclass(frozen=True)
class Move:
    kind: str
    args: Tuple[str, ...]
    scope: Scope


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
    for r in reqs[1:]:
        out = And(out, r)
    return out


# ============================================================
# Profile builder -> immutable snapshot
# ============================================================

@dataclass(frozen=True)
class Rule:
    id: str
    input_roles: Tuple[Role, ...]
    output_role: Role
    output_claim: Claim
    kernel_guard: Optional[str] = None


@dataclass
class Profile:
    """Mutable authoring object. Never used directly by LICENSE."""
    id: str
    version: str = "0"
    rules: Dict[str, Rule] = field(default_factory=dict)
    requirements: Dict[Tuple[str, str, Tuple[str, ...]], Requirement] = field(
        default_factory=dict
    )

    def set_requirement(
        self, license_type: LicenseType, move: Move, req: Requirement
    ) -> None:
        self.requirements[(license_type.value, move.kind, move.args)] = req

    def add_rule(self, rule: Rule) -> None:
        self.rules[rule.id] = rule

    def freeze(self) -> "ProfileSnapshot":
        rules = tuple(sorted(self.rules.items(), key=lambda x: x[0]))
        reqs = tuple(
            sorted(
                self.requirements.items(),
                key=lambda x: (x[0][0], x[0][1], x[0][2]),
            )
        )
        payload = {
            "id": self.id,
            "version": self.version,
            "rules": [_rule_json(k, v) for k, v in rules],
            "requirements": [
                [list(k[:2]) + [list(k[2])], _req_json(v)] for k, v in reqs
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
    requirements: Tuple[Tuple[Tuple[str, str, Tuple[str, ...]], Requirement], ...]

    def rule_for(self, rule_id: str) -> Rule:
        for key, rule in self.rules:
            if key == rule_id:
                return rule
        raise FormationError(f"Unknown rule in bound profile snapshot: {rule_id}")

    def requirement_for(self, license_type: LicenseType, move: Move) -> Requirement:
        key = (license_type.value, move.kind, move.args)
        for k, req in self.requirements:
            if k == key:
                return req
        raise LicenseError(
            f"No declared requirement in bound profile snapshot for "
            f"{license_type.value}:{move.kind}{move.args}"
        )


def _claim_json(c: Claim):
    return [c.kind, list(c.args)]


def _scope_json(s: Scope):
    return list(s.key())


def _rule_json(key: str, r: Rule):
    return [
        key,
        list(x.value for x in r.input_roles),
        r.output_role.value,
        _claim_json(r.output_claim),
        r.kernel_guard,
    ]


def _req_json(req: Requirement):
    if isinstance(req, Top):
        return ["top"]
    if isinstance(req, Atom):
        return ["atom", _claim_json(req.claim), req.role.value, _scope_json(req.scope)]
    if isinstance(req, And):
        return ["and", _req_json(req.left), _req_json(req.right)]
    if isinstance(req, Or):
        return ["or", _req_json(req.left), _req_json(req.right)]
    raise TypeError(req)


# ============================================================
# History objects
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
    roots_by_role: Mapping[Role, FrozenSet[str]] = field(
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
    profile_digest: str
    context_id: str
    agents: Tuple[str, ...]
    use: str
    license_type: LicenseType
    move: Move
    branch: Branch
    used_warrants: FrozenSet[str]


@dataclass
class History:
    contexts: Dict[str, Context] = field(default_factory=dict)
    profiles: Dict[str, ProfileSnapshot] = field(default_factory=dict)  # digest -> snapshot
    bindings: Dict[str, Binding] = field(default_factory=dict)
    warrants: Dict[str, Warrant] = field(default_factory=dict)
    licenses: Dict[str, LicenseRecord] = field(default_factory=dict)
    children: Dict[str, FrozenSet[str]] = field(default_factory=dict)
    events: List[dict] = field(default_factory=list)

    def register_context(self, context: Context) -> None:
        prior = self.contexts.get(context.id)
        if prior is not None and prior != context:
            raise KernelError(f"Context id collision: {context.id}")
        self.contexts[context.id] = context

    def add_warrant(self, warrant: Warrant) -> None:
        if warrant.id in self.warrants:
            raise KernelError(f"Duplicate warrant id: {warrant.id}")
        self.warrants[warrant.id] = warrant
        for parent in warrant.parents:
            old = set(self.children.get(parent, frozenset()))
            old.add(warrant.id)
            self.children[parent] = frozenset(old)

    def descendants(self, warrant_id: str) -> FrozenSet[str]:
        seen: set[str] = set()
        stack = list(self.children.get(warrant_id, frozenset()))
        while stack:
            wid = stack.pop()
            if wid in seen:
                continue
            seen.add(wid)
            stack.extend(self.children.get(wid, frozenset()))
        return frozenset(seen)

    def add_event(self, event: dict) -> None:
        self.events.append(dict(event))


# ============================================================
# Context/profile/use-indexed mutable evaluation state
# ============================================================

@dataclass(frozen=True)
class EvalKey:
    profile_digest: str
    context_id: str
    use: str
    warrant_id: str


@dataclass
class EvaluationState:
    epi: Dict[EvalKey, EpiStatus] = field(default_factory=dict)
    placement: Dict[EvalKey, Placement] = field(default_factory=dict)
    active_bindings: FrozenSet[str] = frozenset()
    review_required: FrozenSet[str] = frozenset()

    def key(self, profile_digest: str, context_id: str, use: str, warrant_id: str) -> EvalKey:
        return EvalKey(profile_digest, context_id, use, warrant_id)

    def usable(
        self, profile_digest: str, context_id: str, use: str, warrant_id: str
    ) -> bool:
        k = self.key(profile_digest, context_id, use, warrant_id)
        return (
            self.epi.get(k) == EpiStatus.LIVE
            and self.placement.get(k) == Placement.PLACED
        )

    def set_status(
        self,
        profile_digest: str,
        context_id: str,
        use: str,
        warrant_id: str,
        epi: EpiStatus,
        placement: Placement,
    ) -> None:
        k = self.key(profile_digest, context_id, use, warrant_id)
        self.epi[k] = epi
        self.placement[k] = placement


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
# V0.1.1 proof kernel
# ============================================================

class ProofKernel:
    def __init__(self, kernel_id: str = "K0") -> None:
        self.id = kernel_id
        self._ids = itertools.count(1)

    def _fresh(self, prefix: str) -> str:
        return f"{prefix}{next(self._ids)}"

    # ---------------- Canonical lookup only ----------------

    def _binding(self, history: History, binding_id: str) -> Binding:
        try:
            return history.bindings[binding_id]
        except KeyError:
            raise KernelError(f"Unknown canonical binding id: {binding_id}")

    def _profile(self, history: History, binding_id: str) -> ProfileSnapshot:
        b = self._binding(history, binding_id)
        return history.profiles[b.profile_digest]

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

    # ---------------- Profile binding / snapshot ----------------

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
        snap = profile.freeze()
        history.profiles.setdefault(snap.digest, snap)
        bid = self._fresh("b")
        history.bindings[bid] = Binding(
            id=bid,
            profile_id=snap.id,
            profile_version=snap.version,
            profile_digest=snap.digest,
            scope=scope,
            use=use,
            source=source,
        )
        state.active_bindings = frozenset(set(state.active_bindings) | {bid})
        history.add_event(
            {
                "kind": "bind_profile",
                "binding": bid,
                "profile": snap.id,
                "version": snap.version,
                "digest": snap.digest,
                "source": source,
            }
        )
        return bid

    # ---------------- Kernel typing ----------------

    def well_typed_rule(self, rule: Rule) -> bool:
        ins = set(rule.input_roles)
        out = rule.output_role

        protected = {
            Role.AUTHORIZATION,
            Role.BINDING,
            Role.ESCALATION,
            Role.PROVENANCE,
            Role.COVERAGE,
            Role.BRIDGE,
        }
        if out in protected and out not in ins:
            return False
        if out == Role.CONTENT and Role.CONTENT not in ins:
            return False
        if out == Role.SELECTION and not ins:
            return False
        return True

    def _merge_roots(self, warrants: Iterable[Warrant]) -> Dict[Role, FrozenSet[str]]:
        acc: Dict[Role, set[str]] = {r: set() for r in Role}
        for w in warrants:
            for role, roots in w.roots_by_role.items():
                acc[role].update(roots)
        return {r: frozenset(v) for r, v in acc.items() if v}

    # ---------------- Warrant formation ----------------

    def root(
        self,
        history: History,
        binding_id: str,
        context: Context,
        token: RootToken,
    ) -> str:
        history.register_context(context)
        b = self._binding(history, binding_id)
        if not context.accepts(token.claim):
            raise FormationError(
                f"Claim {token.claim} is outside context signature {context.id}"
            )
        wid = self._fresh("w")
        w = Warrant(
            id=wid,
            claim=token.claim,
            role=token.role,
            scope=token.scope,
            constructor="root",
            parents=(),
            formation_profile_digest=b.profile_digest,
            formation_context=context.id,
            source=token.source,
            roots_by_role={token.role: frozenset({token.source})},
        )
        history.add_warrant(w)
        history.add_event({"kind": "root", "warrant": wid, "source": token.source})
        return wid

    def infer(
        self,
        history: History,
        binding_id: str,
        context_id: str,
        rule_id: str,
        parent_ids: Sequence[str],
        out_scope: Optional[Scope] = None,
    ) -> str:
        b = self._binding(history, binding_id)
        profile = self._profile(history, binding_id)
        context = self._context(history, context_id)
        rule = profile.rule_for(rule_id)
        if not self.well_typed_rule(rule):
            raise FormationError(f"Kernel rejects ill-typed rule: {rule.id}")

        parents = [self._warrant(history, wid) for wid in parent_ids]

        # Canonical-reference + context integrity:
        # ordinary inference is strictly intra-context.
        if any(w.formation_context != context_id for w in parents):
            raise FormationError("Ordinary INFER is intra-context; use TRANSPORT")
        if any(w.formation_profile_digest != b.profile_digest for w in parents):
            raise FormationError("Parent warrant belongs to a different profile snapshot")
        if tuple(w.role for w in parents) != rule.input_roles:
            raise FormationError("Rule input roles do not match canonical parents")
        if not context.accepts(rule.output_claim):
            raise FormationError("Rule output is outside target context signature")

        if rule.kernel_guard == "distinct_content_roots":
            roots = [w.roots_by_role.get(Role.CONTENT, frozenset()) for w in parents]
            if any(not rs for rs in roots):
                raise FormationError("Distinct-root audit requires content ancestry")
            for i in range(len(roots)):
                for j in range(i + 1, len(roots)):
                    if roots[i] & roots[j]:
                        raise FormationError("Content roots are not audited-distinct")

        if out_scope is None:
            common = set(parents[0].scope.atoms)
            for w in parents[1:]:
                common &= set(w.scope.atoms)
            out_scope = Scope(frozenset(common))
        if any(not out_scope.narrower_or_equal(w.scope) for w in parents):
            raise FormationError("Inference would widen scope")

        wid = self._fresh("w")
        w = Warrant(
            id=wid,
            claim=rule.output_claim,
            role=rule.output_role,
            scope=out_scope,
            constructor=f"infer:{rule.id}",
            parents=tuple(parent_ids),
            formation_profile_digest=b.profile_digest,
            formation_context=context_id,
            roots_by_role=self._merge_roots(parents),
        )
        history.add_warrant(w)
        history.add_event({"kind": "infer", "warrant": wid, "rule": rule.id})
        return wid

    def transport(
        self,
        history: History,
        binding_id: str,
        target_context: Context,
        *,
        map_id: str,
        original_id: str,
        witness_id: str,
        translated_claim: Claim,
        out_scope: Scope,
    ) -> str:
        history.register_context(target_context)
        b = self._binding(history, binding_id)
        original = self._warrant(history, original_id)
        witness = self._warrant(history, witness_id)

        # Profile snapshot is fixed across this safe transport.
        if (
            original.formation_profile_digest != b.profile_digest
            or witness.formation_profile_digest != b.profile_digest
        ):
            raise FormationError("Transport parents belong to another profile snapshot")

        # Witness is bound to map, original id, target context and exact target claim.
        expected = Claim(
            "Transportable",
            (map_id, original_id, target_context.id, translated_claim.key()),
        )
        if witness.role != Role.BRIDGE or witness.claim != expected:
            raise FormationError("Transport witness is not bound to this exact translation")
        if not target_context.accepts(translated_claim):
            raise FormationError("Translated claim is outside target context signature")
        if not out_scope.narrower_or_equal(original.scope):
            raise FormationError("Transport would widen scope")

        roots = {r: set(v) for r, v in original.roots_by_role.items()}
        bridge_roots = roots.setdefault(Role.BRIDGE, set())
        for rs in witness.roots_by_role.values():
            bridge_roots.update(rs)

        wid = self._fresh("w")
        w = Warrant(
            id=wid,
            claim=translated_claim,
            role=original.role,
            scope=out_scope,
            constructor=f"transport:{map_id}",
            parents=(original_id, witness_id),
            formation_profile_digest=b.profile_digest,
            formation_context=target_context.id,
            roots_by_role={r: frozenset(v) for r, v in roots.items() if v},
        )
        history.add_warrant(w)
        history.add_event({"kind": "transport", "warrant": wid, "map": map_id})
        return wid

    # ---------------- Evaluation / admission ----------------

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
        b = self._binding(history, binding_id)
        w = self._warrant(history, warrant_id)
        if warrant_id not in history.warrants:
            raise KernelError("Noncanonical warrant")
        if w.constructor != "root":
            raise KernelError("External admission is restricted to root warrants")
        if w.formation_context != context_id:
            raise KernelError("Root may only be admitted in its formation context")
        if w.formation_profile_digest != b.profile_digest or b.use != use:
            raise KernelError("Admission environment mismatch")
        state.set_status(
            b.profile_digest, context_id, use, warrant_id,
            EpiStatus.LIVE, Placement.PLACED
        )
        history.add_event(
            {"kind": "admit_root", "warrant": warrant_id, "actor": actor, "basis": basis}
        )

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
        b = self._binding(history, binding_id)
        w = self._warrant(history, warrant_id)
        if w.constructor == "root":
            raise KernelError("Root warrants must use admission")
        if w.formation_context != context_id or w.formation_profile_digest != b.profile_digest:
            raise KernelError("Derived qualification environment mismatch")

        # INFER: all parents must be usable in the same target context.
        if w.constructor.startswith("infer:"):
            if any(
                not state.usable(b.profile_digest, context_id, use, pid)
                for pid in w.parents
            ):
                raise KernelError("Cannot qualify inference from unusable parents")

        # TRANSPORT: each parent must be usable where it was formed.
        elif w.constructor.startswith("transport:"):
            for pid in w.parents:
                parent = self._warrant(history, pid)
                if not state.usable(
                    b.profile_digest, parent.formation_context, use, pid
                ):
                    raise KernelError("Cannot qualify transport from unusable source warrant")

        else:
            raise KernelError("Unknown derived constructor")

        state.set_status(
            b.profile_digest, context_id, use, warrant_id,
            EpiStatus.LIVE, Placement.PLACED
        )
        history.add_event(
            {"kind": "qualify_derived", "warrant": warrant_id, "actor": actor, "basis": basis}
        )

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
        b = self._binding(history, binding_id)
        self._context(history, context_id)  # canonical context is mandatory

        if isinstance(req, Top):
            return Branch("top")

        if isinstance(req, Atom):
            for wid in candidate_ids:
                w = self._warrant(history, wid)  # canonical fields only
                if (
                    state.usable(b.profile_digest, context_id, use, wid)
                    and w.formation_context == context_id
                    and w.formation_profile_digest == b.profile_digest
                    and w.claim == req.claim
                    and w.role == req.role
                    and req.scope.narrower_or_equal(w.scope)
                ):
                    return Branch("leaf", obligation=req, warrant_id=wid)
            raise SatisfactionError(f"Unsatisfied atom: {req}")

        if isinstance(req, And):
            left = self.satisfy(
                history, state, binding_id, context_id, use, req.left, candidate_ids
            )
            right = self.satisfy(
                history, state, binding_id, context_id, use, req.right, candidate_ids
            )
            return Branch("and", (left, right))

        if isinstance(req, Or):
            try:
                left = self.satisfy(
                    history, state, binding_id, context_id, use, req.left, candidate_ids
                )
                return Branch("or-left", (left,))
            except SatisfactionError:
                right = self.satisfy(
                    history, state, binding_id, context_id, use, req.right, candidate_ids
                )
                return Branch("or-right", (right,))

        raise TypeError(req)

    # ---------------- Kernel licensing gate ----------------

    def license_safe(
        self,
        history: History,
        branch: Branch,
        move: Move,
        license_type: LicenseType,
    ) -> bool:
        # V0.1.1 deliberately has no normative role/path.
        if license_type == LicenseType.NORMATIVE:
            return False

        leaf_warrants = [
            self._warrant(history, leaf.warrant_id)
            for leaf in branch.leaves
            if leaf.warrant_id is not None
        ]
        if any(not move.scope.narrower_or_equal(w.scope) for w in leaf_warrants):
            return False

        roles = {w.role for w in leaf_warrants}

        if license_type == LicenseType.ACTION or move.kind == "Act":
            if Role.AUTHORIZATION not in roles:
                return False

        if move.kind == "Share" and Role.SELECTION not in roles:
            return False

        if move.kind in {"Suspect", "Reopen"} and Role.ESCALATION not in roles:
            return False

        # Adoption strengthens the determination architecture: require both
        # escalation justification and a selection path.
        if move.kind == "Adopt":
            if not {Role.ESCALATION, Role.SELECTION} <= roles:
                return False

        if move.kind == "ResolveStatus" and not (
            Role.SELECTION in roles or Role.AUTHORIZATION in roles
        ):
            return False

        return True

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
        b = self._binding(history, binding_id)  # canonical binding only
        self._context(history, context_id)  # license is always context-indexed
        if binding_id not in state.active_bindings:
            raise LicenseError("Profile binding is not active")
        if b.use != use:
            raise LicenseError("Binding/use mismatch")
        if not move.scope.narrower_or_equal(b.scope):
            raise LicenseError("Move exceeds canonical binding scope")

        profile = self._profile(history, binding_id)
        req = profile.requirement_for(license_type, move)
        branch = self.satisfy(
            history, state, binding_id, context_id, use, req, candidate_ids
        )
        if not self.license_safe(history, branch, move, license_type):
            raise LicenseError("Kernel LicenseSafe check failed")

        lid = self._fresh("L")
        used = frozenset(
            leaf.warrant_id for leaf in branch.leaves if leaf.warrant_id is not None
        )
        rec = LicenseRecord(
            id=lid,
            kernel_id=self.id,
            profile_digest=b.profile_digest,
            context_id=context_id,
            agents=tuple(agents),
            use=use,
            license_type=license_type,
            move=move,
            branch=branch,
            used_warrants=used,
        )
        history.licenses[lid] = rec
        history.add_event({"kind": "license", "license": lid, "move": move.kind})
        return rec

    # ---------------- Dependency-aware challenge / revalidation ----------------

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
        b = self._binding(history, binding_id)
        challenger = self._warrant(history, challenger_id)
        bridge = self._warrant(history, challenge_bridge_id)
        self._warrant(history, target_id)

        if not state.usable(b.profile_digest, context_id, use, challenger_id):
            raise KernelError("Challenger is not usable in challenge context")
        if not state.usable(b.profile_digest, context_id, use, challenge_bridge_id):
            raise KernelError("Challenge bridge is not usable in challenge context")
        expected = Claim("Challenges", (challenger_id, target_id))
        if bridge.role != Role.BRIDGE or bridge.claim != expected:
            raise KernelError("Challenge bridge does not canonically target this warrant")

        impacted = frozenset({target_id}) | history.descendants(target_id)

        # Revalidation propagates through derivation descendants, but does not
        # recursively defeat them.
        for wid in impacted:
            for key in list(state.epi.keys()):
                if (
                    key.warrant_id != wid
                    or key.profile_digest != b.profile_digest
                    or key.use != use
                ):
                    continue
                if state.epi.get(key) == EpiStatus.LIVE:
                    state.epi[key] = EpiStatus.SUSPENDED
                if wid != target_id and state.placement.get(key) == Placement.PLACED:
                    state.placement[key] = Placement.PENDING

        affected_licenses = {
            lid
            for lid, lic in history.licenses.items()
            if lic.profile_digest == b.profile_digest
            and bool(lic.used_warrants & impacted)
        }
        state.review_required = frozenset(
            set(state.review_required) | affected_licenses
        )
        history.add_event(
            {
                "kind": "challenge",
                "target": target_id,
                "impacted": sorted(impacted),
                "affected_licenses": sorted(affected_licenses),
            }
        )
        return impacted

    # ---------------- Revision and debt ----------------

    def apply_revision(
        self,
        history: History,
        state: EvaluationState,
        binding_id: str,
        affected_ids: Iterable[str],
        *,
        reason: str,
    ) -> None:
        b = self._binding(history, binding_id)
        for wid in affected_ids:
            self._warrant(history, wid)
            for key in list(state.epi.keys()):
                if key.profile_digest != b.profile_digest or key.warrant_id != wid:
                    continue
                if state.epi.get(key) == EpiStatus.LIVE:
                    state.epi[key] = EpiStatus.SUSPENDED
                if state.placement.get(key) == Placement.PLACED:
                    state.placement[key] = Placement.PENDING
        history.add_event({"kind": "revision", "reason": reason})

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
                    history, state, binding_id, context_id, use, req, candidate_ids
                )
                return TOP
            except SatisfactionError:
                return req
        if isinstance(req, And):
            l = self.residual(
                history, state, binding_id, context_id, use, req.left, candidate_ids
            )
            r = self.residual(
                history, state, binding_id, context_id, use, req.right, candidate_ids
            )
            if isinstance(l, Top):
                return r
            if isinstance(r, Top):
                return l
            return And(l, r)
        if isinstance(req, Or):
            l = self.residual(
                history, state, binding_id, context_id, use, req.left, candidate_ids
            )
            r = self.residual(
                history, state, binding_id, context_id, use, req.right, candidate_ids
            )
            if isinstance(l, Top) or isinstance(r, Top):
                return TOP
            return Or(l, r)
        raise TypeError(req)
