from __future__ import annotations

from dataclasses import dataclass, field
from enum import Enum
from typing import Dict, FrozenSet, Iterable, List, Mapping, Optional, Sequence, Tuple
import itertools


# ---------- Static vocabulary ----------

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
    NORMATIVE = "N"
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
    """A scope is modeled as a set of admissible atoms.
    Narrower scopes are subsets of broader scopes.
    """
    atoms: FrozenSet[str]

    @staticmethod
    def of(*atoms: str) -> "Scope":
        return Scope(frozenset(atoms))

    def narrower_or_equal(self, other: "Scope") -> bool:
        return self.atoms <= other.atoms

    def __str__(self) -> str:
        return "{" + ",".join(sorted(self.atoms)) + "}"


@dataclass(frozen=True)
class Claim:
    kind: str
    args: Tuple[str, ...] = ()

    def __str__(self) -> str:
        if not self.args:
            return self.kind
        return f"{self.kind}({', '.join(self.args)})"


@dataclass(frozen=True)
class Context:
    id: str
    signature: FrozenSet[str] = frozenset()
    snapshot: Mapping[str, str] = field(default_factory=dict, compare=False)


@dataclass(frozen=True)
class Move:
    kind: str
    args: Tuple[str, ...]
    scope: Scope

    def __str__(self) -> str:
        return f"{self.kind}({', '.join(self.args)})@{self.scope}"


@dataclass(frozen=True)
class RootToken:
    id: str
    claim: Claim
    role: Role
    scope: Scope
    source: str


# ---------- Requirements ----------

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


# ---------- Rules, profiles, warrants ----------

@dataclass(frozen=True)
class Rule:
    id: str
    input_roles: Tuple[Role, ...]
    output_role: Role
    output_claim: Claim
    # Optional kernel-recognized guard. V0.1 has one:
    # "distinct_content_roots".
    kernel_guard: Optional[str] = None


@dataclass
class Profile:
    id: str
    rules: Dict[str, Rule] = field(default_factory=dict)
    requirements: Dict[Tuple[LicenseType, str, Tuple[str, ...]], Requirement] = field(
        default_factory=dict
    )

    def set_requirement(
        self, license_type: LicenseType, move: Move, req: Requirement
    ) -> None:
        self.requirements[(license_type, move.kind, move.args)] = req

    def requirement_for(self, license_type: LicenseType, move: Move) -> Requirement:
        key = (license_type, move.kind, move.args)
        if key not in self.requirements:
            raise LicenseError(f"No declared requirement for {license_type.value}:{move}")
        return self.requirements[key]


@dataclass(frozen=True)
class Warrant:
    id: str
    claim: Claim
    role: Role
    scope: Scope
    constructor: str
    parents: Tuple[str, ...]
    formation_profile: str
    formation_context: str
    source: Optional[str] = None
    # Roots remain role-separated. This is the key provenance invariant.
    roots_by_role: Mapping[Role, FrozenSet[str]] = field(default_factory=dict, compare=False)


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
    scope: Scope
    use: str
    source: str


@dataclass(frozen=True)
class LicenseRecord:
    id: str
    kernel_id: str
    profile_id: str
    context_id: str
    agents: Tuple[str, ...]
    use: str
    license_type: LicenseType
    move: Move
    branch: Branch
    used_warrants: FrozenSet[str]


# ---------- Append-only history and mutable evaluation state ----------

@dataclass
class History:
    warrants: Dict[str, Warrant] = field(default_factory=dict)
    bindings: Dict[str, Binding] = field(default_factory=dict)
    licenses: Dict[str, LicenseRecord] = field(default_factory=dict)
    events: List[dict] = field(default_factory=list)

    def add_warrant(self, warrant: Warrant) -> None:
        if warrant.id in self.warrants:
            raise KernelError(f"Duplicate warrant id: {warrant.id}")
        self.warrants[warrant.id] = warrant

    def add_event(self, event: dict) -> None:
        self.events.append(dict(event))


@dataclass
class EvaluationState:
    epi: Dict[str, EpiStatus] = field(default_factory=dict)
    placement: Dict[str, Placement] = field(default_factory=dict)
    active_bindings: FrozenSet[str] = frozenset()
    review_required: FrozenSet[str] = frozenset()

    def usable(self, warrant_id: str) -> bool:
        return (
            self.epi.get(warrant_id) == EpiStatus.LIVE
            and self.placement.get(warrant_id) == Placement.PLACED
        )


# ---------- Errors ----------

class KernelError(Exception):
    pass


class FormationError(KernelError):
    pass


class SatisfactionError(KernelError):
    pass


class LicenseError(KernelError):
    pass


# ---------- V0.1 proof kernel ----------

class ProofKernel:
    """A deliberately small kernel.

    It does not decide domain truth. It enforces:
      * append-only derivation lineage,
      * role-separated provenance,
      * conservative scope,
      * explicit authorization / escalation / selection paths,
      * no automatic license transport across revisions.
    """

    def __init__(self, kernel_id: str = "K0") -> None:
        self.id = kernel_id
        self._ids = itertools.count(1)

    def _fresh(self, prefix: str) -> str:
        return f"{prefix}{next(self._ids)}"

    # ----- Kernel typing discipline -----

    def well_typed_rule(self, rule: Rule) -> bool:
        ins = set(rule.input_roles)
        out = rule.output_role

        # Strong roles cannot be manufactured ex nihilo by a profile rule.
        if out == Role.AUTHORIZATION and Role.AUTHORIZATION not in ins:
            return False
        if out == Role.BINDING and Role.BINDING not in ins:
            return False
        if out == Role.ESCALATION and Role.ESCALATION not in ins:
            return False
        if out == Role.PROVENANCE and Role.PROVENANCE not in ins:
            return False
        if out == Role.COVERAGE and Role.COVERAGE not in ins:
            return False
        if out == Role.BRIDGE and Role.BRIDGE not in ins:
            return False

        # Content can only be inferred from content-bearing premises.
        if out == Role.CONTENT and Role.CONTENT not in ins:
            return False

        # Selection is intentionally constructible from weaker evidence,
        # but using it for a move remains separately checked by LICENSE.
        if out == Role.SELECTION and not ins:
            return False

        return True

    def _merge_roots(
        self, warrants: Iterable[Warrant]
    ) -> Dict[Role, FrozenSet[str]]:
        acc: Dict[Role, set[str]] = {r: set() for r in Role}
        for w in warrants:
            for role, roots in w.roots_by_role.items():
                acc[role].update(roots)
        return {r: frozenset(v) for r, v in acc.items() if v}

    # ----- Formation: ROOT / INFER / TRANSPORT -----

    def root(
        self,
        history: History,
        profile: Profile,
        context: Context,
        token: RootToken,
    ) -> Warrant:
        if not token.claim.kind:
            raise FormationError("Ill-formed claim")
        wid = self._fresh("w")
        roots = {token.role: frozenset({token.source})}
        w = Warrant(
            id=wid,
            claim=token.claim,
            role=token.role,
            scope=token.scope,
            constructor="root",
            parents=(),
            formation_profile=profile.id,
            formation_context=context.id,
            source=token.source,
            roots_by_role=roots,
        )
        history.add_warrant(w)
        history.add_event(
            {"kind": "root", "warrant": wid, "token": token.id, "source": token.source}
        )
        return w

    def infer(
        self,
        history: History,
        profile: Profile,
        context: Context,
        rule_id: str,
        parents: Sequence[Warrant],
        out_scope: Optional[Scope] = None,
    ) -> Warrant:
        if rule_id not in profile.rules:
            raise FormationError(f"Unknown rule: {rule_id}")
        rule = profile.rules[rule_id]
        if not self.well_typed_rule(rule):
            raise FormationError(f"Kernel rejects ill-typed rule: {rule.id}")
        if tuple(w.role for w in parents) != rule.input_roles:
            raise FormationError("Rule input roles do not match supplied warrants")

        # Kernel-recognized provenance audit.
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

        # No inference may silently widen beyond every premise.
        if any(not out_scope.narrower_or_equal(w.scope) for w in parents):
            raise FormationError("Inference would widen scope")

        wid = self._fresh("w")
        w = Warrant(
            id=wid,
            claim=rule.output_claim,
            role=rule.output_role,
            scope=out_scope,
            constructor=f"infer:{rule.id}",
            parents=tuple(w.id for w in parents),
            formation_profile=profile.id,
            formation_context=context.id,
            roots_by_role=self._merge_roots(parents),
        )
        history.add_warrant(w)
        history.add_event({"kind": "infer", "warrant": wid, "rule": rule.id})
        return w

    def transport(
        self,
        history: History,
        profile: Profile,
        target_context: Context,
        f: str,
        witness: Warrant,
        original: Warrant,
        translated_claim: Claim,
        out_scope: Scope,
    ) -> Warrant:
        expected = Claim("Transportable", (f, original.id))
        if witness.role != Role.BRIDGE or witness.claim != expected:
            raise FormationError("Invalid transport witness")
        if not out_scope.narrower_or_equal(original.scope):
            raise FormationError("Transport would widen scope")

        roots = {r: set(v) for r, v in original.roots_by_role.items()}
        bridge_roots = roots.setdefault(Role.BRIDGE, set())
        # Every source used to justify the bridge remains bridge-role ancestry.
        for role_roots in witness.roots_by_role.values():
            bridge_roots.update(role_roots)

        wid = self._fresh("w")
        w = Warrant(
            id=wid,
            claim=translated_claim,
            role=original.role,
            scope=out_scope,
            constructor=f"transport:{f}",
            parents=(original.id, witness.id),
            formation_profile=profile.id,
            formation_context=target_context.id,
            roots_by_role={r: frozenset(v) for r, v in roots.items() if v},
        )
        history.add_warrant(w)
        history.add_event(
            {"kind": "transport", "warrant": wid, "map": f, "from": original.id}
        )
        return w

    # ----- Explicit admission boundary -----

    def admit_root(
        self,
        history: History,
        state: EvaluationState,
        warrant: Warrant,
        *,
        actor: str,
        basis: str,
    ) -> None:
        """Explicit external admission boundary.

        Only root warrants may cross this boundary. Derived warrants must be
        qualified from currently usable parents instead of being re-admitted
        as if they were fresh external premises.
        """
        if warrant.constructor != "root":
            raise KernelError("External admission is restricted to root warrants")
        state.epi[warrant.id] = EpiStatus.LIVE
        state.placement[warrant.id] = Placement.PLACED
        history.add_event(
            {
                "kind": "admit_root",
                "warrant": warrant.id,
                "actor": actor,
                "basis": basis,
            }
        )

    def qualify_derived(
        self,
        history: History,
        state: EvaluationState,
        warrant: Warrant,
        *,
        actor: str,
        basis: str,
    ) -> None:
        """Make a derived warrant currently usable only if all of its
        derivational parents are currently usable.

        This is deliberately conservative: formation is historical, while
        current usability must be re-established from the current state.
        """
        if warrant.constructor == "root":
            raise KernelError("Root warrants must use the explicit admission boundary")
        if not warrant.parents:
            raise KernelError("Derived warrant has no derivational parents")
        if any(not state.usable(pid) for pid in warrant.parents):
            raise KernelError("Cannot qualify a derived warrant from non-usable parents")
        state.epi[warrant.id] = EpiStatus.LIVE
        state.placement[warrant.id] = Placement.PLACED
        history.add_event(
            {
                "kind": "qualify_derived",
                "warrant": warrant.id,
                "actor": actor,
                "basis": basis,
                "parents": list(warrant.parents),
            }
        )

    # ----- Binding -----

    def bind_profile(
        self,
        history: History,
        state: EvaluationState,
        profile: Profile,
        scope: Scope,
        use: str,
        *,
        source: str,
    ) -> Binding:
        bid = self._fresh("b")
        b = Binding(bid, profile.id, scope, use, source)
        history.bindings[bid] = b
        state.active_bindings = frozenset(set(state.active_bindings) | {bid})
        history.add_event(
            {"kind": "bind_profile", "binding": bid, "profile": profile.id, "source": source}
        )
        return b

    # ----- Proof-relevant requirement satisfaction -----

    def satisfy(
        self,
        history: History,
        state: EvaluationState,
        req: Requirement,
        candidates: Sequence[Warrant],
    ) -> Branch:
        if isinstance(req, Top):
            return Branch("top")

        if isinstance(req, Atom):
            for w in candidates:
                if (
                    state.usable(w.id)
                    and w.claim == req.claim
                    and w.role == req.role
                    and req.scope.narrower_or_equal(w.scope)
                ):
                    return Branch("leaf", obligation=req, warrant_id=w.id)
            raise SatisfactionError(f"Unsatisfied atom: {req}")

        if isinstance(req, And):
            left = self.satisfy(history, state, req.left, candidates)
            right = self.satisfy(history, state, req.right, candidates)
            return Branch("and", (left, right))

        if isinstance(req, Or):
            try:
                left = self.satisfy(history, state, req.left, candidates)
                return Branch("or-left", (left,))
            except SatisfactionError:
                right = self.satisfy(history, state, req.right, candidates)
                return Branch("or-right", (right,))

        raise TypeError(req)

    # ----- Kernel-level licensing safety -----

    def license_safe(
        self,
        history: History,
        branch: Branch,
        move: Move,
        license_type: LicenseType,
    ) -> bool:
        leaf_warrants = [
            history.warrants[leaf.warrant_id]
            for leaf in branch.leaves
            if leaf.warrant_id is not None
        ]

        # No scope inflation: every actually-used leaf must cover the move scope.
        if any(not move.scope.narrower_or_equal(w.scope) for w in leaf_warrants):
            return False

        roles = {w.role for w in leaf_warrants}

        # No type leakage into action.
        if license_type == LicenseType.ACTION and Role.AUTHORIZATION not in roles:
            return False
        if move.kind == "Act" and Role.AUTHORIZATION not in roles:
            return False

        # Collective closure must have an explicit selection path.
        if move.kind == "Share" and Role.SELECTION not in roles:
            return False

        # Deeper revision moves require escalation-role support.
        if move.kind in {"Suspect", "Reopen"} and Role.ESCALATION not in roles:
            return False

        # Status resolution must be explicitly supported by selection or authorization.
        if move.kind == "ResolveStatus" and not (
            Role.SELECTION in roles or Role.AUTHORIZATION in roles
        ):
            return False

        return True

    def license(
        self,
        history: History,
        state: EvaluationState,
        profile: Profile,
        context: Context,
        agents: Sequence[str],
        use: str,
        binding: Binding,
        license_type: LicenseType,
        move: Move,
        candidates: Sequence[Warrant],
    ) -> LicenseRecord:
        if binding.id not in state.active_bindings:
            raise LicenseError("Profile binding is not active")
        if binding.profile_id != profile.id or binding.use != use:
            raise LicenseError("Binding/profile/use mismatch")
        if not move.scope.narrower_or_equal(binding.scope):
            raise LicenseError("Move exceeds profile binding scope")

        req = profile.requirement_for(license_type, move)
        branch = self.satisfy(history, state, req, candidates)

        if not self.license_safe(history, branch, move, license_type):
            raise LicenseError("Kernel LicenseSafe check failed")

        lid = self._fresh("L")
        used = frozenset(
            leaf.warrant_id for leaf in branch.leaves if leaf.warrant_id is not None
        )
        rec = LicenseRecord(
            id=lid,
            kernel_id=self.id,
            profile_id=profile.id,
            context_id=context.id,
            agents=tuple(agents),
            use=use,
            license_type=license_type,
            move=move,
            branch=branch,
            used_warrants=used,
        )
        history.licenses[lid] = rec
        history.add_event({"kind": "license", "license": lid, "move": str(move)})
        return rec

    # ----- Mutable evaluation state transitions -----

    def challenge(
        self,
        history: History,
        state: EvaluationState,
        *,
        challenger: Warrant,
        challenge_bridge: Warrant,
        target: Warrant,
    ) -> None:
        expected = Claim("Challenges", (challenger.id, target.id))
        if (
            not state.usable(challenger.id)
            or not state.usable(challenge_bridge.id)
            or challenge_bridge.role != Role.BRIDGE
            or challenge_bridge.claim != expected
        ):
            raise KernelError("Challenge is not supported by usable challenger + bridge")

        if state.epi.get(target.id) == EpiStatus.LIVE:
            state.epi[target.id] = EpiStatus.SUSPENDED

        affected = {
            lid
            for lid, lic in history.licenses.items()
            if target.id in lic.used_warrants
        }
        state.review_required = frozenset(set(state.review_required) | affected)
        history.add_event(
            {
                "kind": "challenge",
                "challenger": challenger.id,
                "bridge": challenge_bridge.id,
                "target": target.id,
                "affected_licenses": sorted(affected),
            }
        )

    def apply_revision(
        self,
        history: History,
        state: EvaluationState,
        affected_warrant_ids: Iterable[str],
        *,
        reason: str,
    ) -> None:
        for wid in affected_warrant_ids:
            if state.epi.get(wid) == EpiStatus.LIVE:
                state.epi[wid] = EpiStatus.SUSPENDED
            if state.placement.get(wid) == Placement.PLACED:
                state.placement[wid] = Placement.PENDING
        history.add_event(
            {"kind": "revision", "affected": list(affected_warrant_ids), "reason": reason}
        )

    # ----- Residual requirement / requalification debt -----

    def residual(
        self,
        history: History,
        state: EvaluationState,
        req: Requirement,
        candidates: Sequence[Warrant],
    ) -> Requirement:
        if isinstance(req, Top):
            return TOP
        if isinstance(req, Atom):
            try:
                self.satisfy(history, state, req, candidates)
                return TOP
            except SatisfactionError:
                return req
        if isinstance(req, And):
            l = self.residual(history, state, req.left, candidates)
            r = self.residual(history, state, req.right, candidates)
            if isinstance(l, Top):
                return r
            if isinstance(r, Top):
                return l
            return And(l, r)
        if isinstance(req, Or):
            l = self.residual(history, state, req.left, candidates)
            r = self.residual(history, state, req.right, candidates)
            if isinstance(l, Top) or isinstance(r, Top):
                return TOP
            return Or(l, r)
        raise TypeError(req)


def atom(claim: Claim, role: Role, scope: Scope) -> Atom:
    return Atom(claim, role, scope)


def conj(*reqs: Requirement) -> Requirement:
    if not reqs:
        return TOP
    out = reqs[0]
    for r in reqs[1:]:
        out = And(out, r)
    return out


def disj(*reqs: Requirement) -> Requirement:
    if not reqs:
        return TOP
    out = reqs[0]
    for r in reqs[1:]:
        out = Or(out, r)
    return out
