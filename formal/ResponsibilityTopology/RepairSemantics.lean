import ResponsibilityTopology.ActivationRefresh

namespace ResponsibilityTopology

/-!
Dependency-sensitive repair semantics.

This module intentionally does not define a unique revalidation frontier.  A
repair problem is a finite directed hypergraph from stale currentness
obligations to alternative local repair actions.  Every hyperedge is an
unresolved dependency cut: a repair set must hit every edge, while any action
inside one edge may discharge that edge.  Consequently conjunction is expressed
by multiple edges and alternatives are expressed by multiple actions inside one
edge.

The semantics remains purely extensional in this stage.  No repair action mutates
state yet; executable/reachable revalidation is deferred to later stages.
-/

/-- The three mutable/current responsibility layers that can require repair.
Historical well-formedness is intentionally not collapsed into this type: #43
preserves canonical history while these obligations may become stale. -/
inductive RepairObligation where
  | warrantUsable (key : EvalKey)
  | licenseBaseCurrent (licenseId : ActivationLicenseId)
  | contextGrounded (key : ContextKey)
  deriving Repr, DecidableEq

/-- Candidate local responsibility that may be re-established.  These are
semantic action labels in #45, not reachable kernel events. -/
inductive RepairAction where
  | revalidateWarrant (key : EvalKey)
  | revalidateLicense (licenseId : ActivationLicenseId)
  | revalidateContext (key : ContextKey)
  deriving Repr, DecidableEq

/-- Exact state-backed truth condition for one repair obligation. -/
def RepairObligation.Holds
    (A : AdoptState) : RepairObligation → Prop
  | .warrantUsable key => Usable A.core key
  | .licenseBaseCurrent licenseId =>
      A.toLicenseRead.toActivationRead.baseCurrent licenseId
  | .contextGrounded key => Grounded A.toLicenseRead.toActivationRead key

/-- A stale dependency is simply a represented currentness obligation that no
longer holds in the state. -/
def StaleDependency
    (A : AdoptState) (obligation : RepairObligation) : Prop :=
  ¬ obligation.Holds A

/-- Warrant staleness is exactly loss of usability. -/
theorem staleDependency_warrant_iff
    (A : AdoptState) (key : EvalKey) :
    StaleDependency A (.warrantUsable key) ↔ ¬ Usable A.core key := by
  rfl

/-- License staleness is exactly loss of the identifier-level BaseCurrent
observation in the same enriched Adopt-license read. -/
theorem staleDependency_license_iff
    (A : AdoptState) (licenseId : ActivationLicenseId) :
    StaleDependency A (.licenseBaseCurrent licenseId) ↔
      ¬ A.toLicenseRead.toActivationRead.baseCurrent licenseId := by
  rfl

/-- Context staleness is exactly loss of grounded currentness. -/
theorem staleDependency_context_iff
    (A : AdoptState) (key : ContextKey) :
    StaleDependency A (.contextGrounded key) ↔
      ¬ Grounded A.toLicenseRead.toActivationRead key := by
  rfl

/-- One directed hyperedge: restoring `obligation` requires selecting at least
one action from `alternatives`.  Multiple edges can point to the same obligation
when several conjunctive cuts must all be discharged. -/
structure RepairHyperedge where
  obligation : RepairObligation
  alternatives : List RepairAction
  deriving Repr

/-- A finite state-indexed repair problem.  Every edge belongs to a stale
obligation, every edge offers at least one alternative, and every recorded stale
obligation is exposed by at least one edge.  No uniqueness or canonical choice
of repair set is assumed. -/
structure RepairProblem (A : AdoptState) where
  target : RepairObligation
  staleDependencies : List RepairObligation
  staleExact : ∀ obligation,
    obligation ∈ staleDependencies → StaleDependency A obligation
  edges : List RepairHyperedge
  edgeObligationStale : ∀ edge,
    edge ∈ edges → edge.obligation ∈ staleDependencies
  edgeNonempty : ∀ edge,
    edge ∈ edges → edge.alternatives ≠ []
  staleExposed : ∀ obligation,
    obligation ∈ staleDependencies →
      ∃ edge,
        edge ∈ edges ∧ edge.obligation = obligation

abbrev RepairActionSet := RepairAction → Prop

/-- A candidate action set hits one unresolved dependency cut when it contains
at least one alternative named by that hyperedge. -/
def HitsRepairEdge
    (X : RepairActionSet) (edge : RepairHyperedge) : Prop :=
  ∃ action,
    action ∈ edge.alternatives ∧ X action

/-- A repair set is a hitting set of all unresolved dependency cuts.  This is
intentionally not a selected frontier and need not be unique. -/
def RepairSet
    {A : AdoptState}
    (problem : RepairProblem A)
    (X : RepairActionSet) : Prop :=
  ∀ edge,
    edge ∈ problem.edges → HitsRepairEdge X edge

/-- Pointwise subset relation on repair-action sets. -/
def RepairActionSubset
    (X Y : RepairActionSet) : Prop :=
  ∀ action, X action → Y action

/-- Strict inclusion of repair-action sets. -/
def ProperRepairActionSubset
    (X Y : RepairActionSet) : Prop :=
  RepairActionSubset X Y ∧
    ∃ action, Y action ∧ ¬ X action

/-- Inclusion-minimal repair set.  The definition says nothing about uniqueness:
several incomparable minimal hitting sets may exist. -/
def MinimalRepairSet
    {A : AdoptState}
    (problem : RepairProblem A)
    (X : RepairActionSet) : Prop :=
  RepairSet problem X ∧
    ∀ Y,
      ProperRepairActionSubset Y X →
      ¬ RepairSet problem Y

/-- Every repair set hits each concrete unresolved dependency cut. -/
theorem repairSet_hits_edge
    {A : AdoptState}
    {problem : RepairProblem A}
    {X : RepairActionSet}
    (hRepair : RepairSet problem X)
    {edge : RepairHyperedge}
    (hEdge : edge ∈ problem.edges) :
    ∃ action,
      action ∈ edge.alternatives ∧ X action := by
  exact hRepair edge hEdge

/-- Repair-set validity is monotone upward: adding actions cannot destroy the
hitting-set property. -/
theorem repairSet_monotone
    {A : AdoptState}
    {problem : RepairProblem A}
    {X Y : RepairActionSet}
    (hRepair : RepairSet problem X)
    (hSubset : RepairActionSubset X Y) :
    RepairSet problem Y := by
  intro edge hEdge
  rcases hRepair edge hEdge with ⟨action, hAlternative, hAction⟩
  exact ⟨action, hAlternative, hSubset action hAction⟩

/-- Every hyperedge in a well-formed repair problem points to an actually stale
obligation in the indexed state. -/
theorem repairProblem_edge_is_stale
    {A : AdoptState}
    (problem : RepairProblem A)
    {edge : RepairHyperedge}
    (hEdge : edge ∈ problem.edges) :
    StaleDependency A edge.obligation := by
  exact problem.staleExact edge.obligation
    (problem.edgeObligationStale edge hEdge)

/-- Every declared stale obligation has at least one unresolved dependency edge.
This is the finite hypergraph exposure boundary used by later sufficiency and
minimality theorems. -/
theorem repairProblem_stale_has_edge
    {A : AdoptState}
    (problem : RepairProblem A)
    {obligation : RepairObligation}
    (hStale : obligation ∈ problem.staleDependencies) :
    ∃ edge,
      edge ∈ problem.edges ∧ edge.obligation = obligation := by
  exact problem.staleExposed obligation hStale

/-- Minimality always includes ordinary sufficiency-at-the-cut-level. -/
theorem minimalRepairSet_is_repairSet
    {A : AdoptState}
    {problem : RepairProblem A}
    {X : RepairActionSet}
    (hMinimal : MinimalRepairSet problem X) :
    RepairSet problem X := by
  exact hMinimal.1

/-- Historical well-formedness remains a separate judgment from repair
staleness.  A caller may carry both facts simultaneously; this theorem merely
exposes the canonical-history side without folding it into `StaleDependency`. -/
theorem historicalWellFormedness_separate_from_staleness
    {A : AdoptState}
    (hInvariant : AdoptStateInvariant A)
    {obligation : RepairObligation}
    (_hStale : StaleDependency A obligation) :
    AdoptStateInvariant A := by
  exact hInvariant

end ResponsibilityTopology
