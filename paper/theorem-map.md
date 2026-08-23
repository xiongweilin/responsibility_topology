# Paper-facing theorem map

This file maps the first paper's claims to a deliberately small set of mechanized result families. It is **not** organized by source-file chronology and it is **not** an exhaustive theorem index. `formal/ResponsibilityTopology/Audit.lean` remains authoritative for axiom dependencies.

The theorem-facing state thesis is deliberately narrow:

```text
canonical historical existence ≠ current usability
```

Historical formation and current qualification are distinct transitions governing those relations. For ordinary INFER, the stronger relation-level thesis is:

```text
historical derivation relation ≠ current usable-parent responsibility
```

`Responsibility Topology` is the interpretive framework for these boundaries; the result map does not claim source, rule, profile, or regime adequacy.

The paper should cite R1–R9 as result families and move implementation lemmas, setter locality, and preservation specializations to the artifact/appendix discussion.

## R1 — Relative Branch Conservativity

**Paper statement.** For a fixed recorded branch, license type, move, and exact requirement, entitlement is invariant under changes outside the branch-local satisfaction and floor observations, provided both ambient views remain admissible.

Representative Lean theorem:

```lean
relativeBranchConservativity
```

Core logical ingredients:

```lean
branchConservativity
kernelFloorLocality
FixedAmbient
```

Important interpretation:

\[
\boxed{
\text{unused facts outside the recorded branch cannot secretly validate that branch}
}
\]

under the fixed admissible regime represented by the theorem premises.

**Do not claim:** profile adequacy, kernel-floor adequacy, or invariance under changing the exact requirement.

---

## R2 — Exact Requirement Resolution

**Paper statement.** Requirement selection is an exact lookup on license type plus full move identity. Ordered move arguments are semantic identity; scope identity is extensional; there is no subsumption or priority fallback. Missing declaration is distinct from explicitly declaring `top`.

Representative Lean theorems:

```lean
requirementLookup_exactKey
requirementLookup_deterministic
missingRequirement_noMatchingEntry
missingRequirement_notTop
requirementLookup_permutation
```

Key boundary:

\[
\boxed{
lookup(k)=none \not\equiv lookup(k)=some\;top
}
\]

and entry ordering is semantically irrelevant for unique-key snapshots.

Supporting projection:

```lean
resolvedLicensingRead_requirement
```

**Do not claim:** digest collision resistance, serialization correctness, or total state-backed licensing-read assembly.

---

## R3 — Canonical Projection Coherence

**Paper statement.** Once a branch is derived from a canonical licensing read, its satisfaction-relevant fields and floor leaves are projections of the same canonical warrant objects.

Representative Lean theorem:

```lean
derives_projection_coherent
```

Supporting interface:

```lean
LicensingRead
toEnv
toOracle
toAmbient
toFloorEnv
```

This closes a consistency problem internal to the static read model: satisfaction and floor reasoning do not independently invent warrant contents.

**Do not claim:** every reachable state already determines a complete `LicensingRead`.

---

## R4 — Reachable Canonical-State Invariance

**Paper statement.** Every state generated from the explicit initial boundary by the modeled kernel transitions satisfies one shared canonical-state invariant separating immutable history from mutable evaluation state.

Representative Lean theorem:

```lean
reachable_invariant
```

Supporting results:

```lean
step_preserves_invariant
step_historyReferentsImmutable
canonicalIdsUnique
```

The invariant currently covers, among other obligations:

```text
binding/profile/context referent coherence
historical warrant referent coherence
parent and root-lineage canonicality
ROOT historical shape
INFER historical well-formedness
evaluation referent coherence
evaluation pair coherence
profile/use binding backing
```

Historical identity law:

\[
S.warrant(w)=some\;W
\land
Step(S,e,S')
\Rightarrow
S'.warrant(w)=some\;W.
\]

**Do not claim:** the Python runtime state is proved to refine `CanonicalState` or every Python operation refines `Step`.

---

## R5 — Grounded Currentness / No Self-Support — semantic component

**Paper statement.** In the separate adopted-context currentness semantics, every grounded adopted context has a finite activation dependency chain terminating at an explicit bootstrap boundary. A pure activation cycle cannot create its own currentness.

Representative Lean theorems:

```lean
grounded_has_bootstrap_chain
no_grounded_without_bootstrap
grounded_fixedPoint_soundness
grounded_refresh_idempotence
```

Key law:

\[
\boxed{
Grounded(c)
\Rightarrow
\text{finite current activation chain from }c\text{ to bootstrap}
}
\]

The state bridge is structural:

```lean
reachable_toActivationRead_wellFormed
```

**Paper status.** R5 is an orthogonal semantic currentness component connected to reachable state. It is **not** a completed reachable Adopt lifecycle: the current `Step` surface does not contain license issuance or Adopt transitions.

**Do not claim:** the complete Python refresh algorithm is proved to compute `Grounded`, that `baseCurrent` itself is adequate, or that reachable states are closed under an Adopt transition already formalized in `Step`.

---

## R6 — ROOT Formation–Qualification Separation

**Paper statement.** Canonical ROOT historical formation creates an immutable warrant but no evaluation position. Explicit ROOT admission separately establishes `LIVE/PLACED`, hence usability, at the exact evaluation key.

Representative Lean theorems:

```lean
rootStep_newWarrant_exact
rootStep_newWarrant_unqualified
rootStep_newWarrant_notUsable
admitRoot_evaluation_exact
admitRoot_makes_usable
```

Lifecycle distinction:

\[
\boxed{
ROOT\ Formation \not\Rightarrow Usable
}
\]

while:

\[
\boxed{
Valid\ ROOT\ Admission \Rightarrow Usable.
}
\]

Formation reads canonical binding/context history and context signature acceptance. Admission does not replay formation acceptance.

**Do not claim:** recorded admission actor is authenticated, recorded basis is adequate, source identity is authentic, or admission implies entitlement.

---

## R7 — INFER Historical Formation Correctness

**Paper statement.** Ordinary INFER uses an exact rule from the immutable bound profile and ordered canonical historical parents in the same formation context and profile snapshot. Subject to the structural kernel discipline, it creates the exact immutable derived warrant and preserves root/source lineage by role-wise union.

Representative Lean theorems:

```lean
inferStep_newWarrant_exact
inferStep_parentEnvironment_exact
inferStep_orderedParentRoles_exact
inferStep_lineage_union
reachable_inferWarrantsWellFormed
inferStep_newWarrant_notUsable
```

The static discipline includes:

```text
exact rule lookup
ordered input-role agreement
known kernel guard
protected-role discipline
context acceptance of output
scope non-widening
formal escalation non-amplification
same formation context
same formation profile snapshot
root-lineage and source-lineage guard inputs
```

Key distinction:

\[
\boxed{
HistoricalParentExistence
\text{ may support formation without CurrentParentUsability}
}
\]

and ordinary INFER is machine-fixed as intra-context and intra-profile-snapshot.

**Do not claim:** rule adequacy or exact Python parser/refinement correspondence for escalation-depth strings.

---

## R8 — INFER Current-Parent Qualification

**Paper statement.** Qualification of an already formed INFER warrant does not replay historical formation. Its new responsibility is that every historical parent is currently usable in the selected pre-state `(profile, context, use)` environment; the transition then establishes child usability in the post-state.

Representative Lean theorems:

```lean
qualifyInfer_requires_usableParents
qualifyInfer_evaluation_exact
qualifyInfer_makes_usable
inferWarrantWellFormed_parents_nonempty
qualifyInfer_childProfileUse_backed
```

Direction of responsibility:

\[
\boxed{
ParentsUsable_{pre}
+ ExplicitQualification
\Rightarrow
ChildUsable_{post}
}
\]

No theorem freezes parent currentness permanently into the child.

The nonempty-parent result prevents a vacuous qualification path. Combined with evaluation profile/use backing, current-parent responsibility carries the selected use environment forward from an already binding-backed usable parent.

**Do not claim:** that the qualification call's binding itself satisfies `binding.use = use`, or that a binding-backed use is normatively adequate.

---

## R9 — INFER Lifecycle Separation

**Paper statement.** A two-step formation/qualification trace exposes the intermediate responsibility boundary directly: the derived historical warrant exists in the intermediate state but is not usable; qualification consumes current usable-parent responsibility and makes it usable in the successor state.

Representative Lean theorem:

```lean
inferFormationQualification_boundary
```

Paper form:

\[
\boxed{
HistoricalDerived
+ CurrentUsableParents_{pre}
+ ExplicitQualification
\Rightarrow
CurrentDerivedUsable_{post}
}
\]

with the intermediate fact:

\[
\boxed{
HistoricalDerived \not\Rightarrow CurrentUsability.
}
\]

This is the paper's most important lifecycle result because it distinguishes two relations over the same parent identities:

\[
\underbrace{ParentOf(p,d)}_{\text{persistent historical relation}}
\qquad\text{versus}\qquad
\underbrace{Usable(S_{pre},k_p)}_{\text{time-indexed evaluation predicate}}.
\]

Formation carries the already-discharged rule/guard/context/scope/strength/lineage obligations in immutable history; qualification later evaluates current usability over those same historical parents rather than replaying formation.

**Do not claim:** `DerivedUsable → Entitled`. Entitlement additionally requires ambient admissibility, exact requirement discharge, and kernel-floor safety.

---

# Supporting results kept out of the contribution list

The following results matter for proof maintenance or artifact audit but should normally not appear as independent contributions:

```lean
qualifyEvaluation_exact
qualifyEvaluation_otherKey_unchanged
rootStep_oldWarrants_immutable
inferStep_oldWarrants_immutable
admitRoot_historyReferentsImmutable
qualifyInfer_historyReferentsImmutable
ruleLookup_sound
ruleLookup_complete
ruleLookup_deterministic
usableFromState_true_iff
reachable_usable_implies_canonical
```

They should appear where needed in proofs, appendices, or the artifact description.

# Composition currently available and currently missing

Available narrow bridges:

```text
HistoricalWarrant.toReadWarrant
usableFromState
CanonicalProfile.toRequirementSnapshot
reachable_toActivationRead_wellFormed
```

The canonical read itself projects coherently to:

```text
AmbientView
Env / SatOracle
FloorEnv
```

The missing paper-sensitive bridge is one total assembly theorem of the form:

```text
reachable CanonicalState
+ selected binding/context/use
+ selected full move/license type
+ grounded currentness observations
        ↓
state-backed LicensingRead
        ↓
existing ProjectedEntitled / Entitled layer
```

No such end-to-end theorem is claimed in the present artifact. Sections 3–6 currently remain precise without it, so the paper-freeze trigger condition has not fired.

# Non-theorems that should be explicit in the paper

\[
\boxed{
ProfileExecutionCorrectness
\not\Rightarrow
ProfileAdequacy
}
\]

\[
\boxed{
KernelCorrectness
\not\Rightarrow
KernelFloorAdequacy
}
\]

\[
\boxed{
RecordedBasis
\not\Rightarrow
AdequateBasis
}
\]

\[
\boxed{
RecordedActor
\not\Rightarrow
AuthenticatedPrincipal
}
\]

\[
\boxed{
CurrentUsability
\not\Rightarrow
Entitlement
}
\]

These are not deficiencies to hide. They delimit the theorem regime: the work formalizes correct execution and explicit responsibility boundaries inside a finite regime, not universal epistemic adequacy.
