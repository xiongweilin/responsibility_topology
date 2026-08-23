import ResponsibilityTopology.RepairSemantics

namespace ResponsibilityTopology

/-!
Repair-set sufficiency before reachable revalidation events.

A `RepairRealization` is a proof certificate for one semantic revalidation
result: whenever a selected action hits an unresolved hyperedge, that edge's
obligation holds in the revalidated state; once all declared stale dependencies
hold, the target obligation follows.  This is deliberately separate from the
reachable event encoding reserved for #48.

The final semantic refresh is not an extra repair obligation.  Refresh preserves
all three represented obligation truth conditions exactly, including context
Groundedness by fixed-point idempotence.
-/

/-- The state-backed activation read after the explicit refresh is exactly the
semantic `refreshed` read of the pre-refresh state. -/
theorem refreshActiveContexts_activationRead_eq_refreshed
    (A : AdoptState) :
    (refreshActiveContexts A).toLicenseRead.toActivationRead =
      refreshed A.toLicenseRead.toActivationRead := by
  rfl

/-- All represented repair-obligation truth conditions are invariant under the
final grounded refresh.  Warrant usability and license BaseCurrent do not read
active-context membership; context Groundedness is refresh-idempotent. -/
theorem repairObligation_refresh_iff
    (A : AdoptState) (obligation : RepairObligation) :
    obligation.Holds (refreshActiveContexts A) ↔ obligation.Holds A := by
  cases obligation with
  | warrantUsable key =>
      rfl
  | licenseBaseCurrent licenseId =>
      rw [refreshActiveContexts_activationRead_eq_refreshed]
      rfl
  | contextGrounded key =>
      rw [refreshActiveContexts_activationRead_eq_refreshed]
      exact grounded_refresh_idempotence A.toLicenseRead.toActivationRead key

/-- Semantic certificate that the selected repair actions are effective in one
revalidated state and that restoration of all declared stale dependencies is
sufficient for the specified target.  No kernel transition is postulated here. -/
structure RepairRealization
    {A : AdoptState}
    (problem : RepairProblem A)
    (X : RepairActionSet)
    (revalidated : AdoptState) : Prop where
  selectedRestoresEdge : ∀ edge action,
    edge ∈ problem.edges →
    action ∈ edge.alternatives →
    X action →
    edge.obligation.Holds revalidated
  targetClosure :
    (∀ obligation,
      obligation ∈ problem.staleDependencies →
      obligation.Holds revalidated) →
    problem.target.Holds revalidated

/-- A repair set plus a sound realization restores every unresolved hyperedge
obligation in the revalidated state. -/
theorem repairSet_realization_restores_edges
    {A revalidated : AdoptState}
    {problem : RepairProblem A}
    {X : RepairActionSet}
    (hRepair : RepairSet problem X)
    (hRealization : RepairRealization problem X revalidated) :
    ∀ edge,
      edge ∈ problem.edges →
      edge.obligation.Holds revalidated := by
  intro edge hEdge
  rcases repairSet_hits_edge hRepair hEdge with
    ⟨action, hAlternative, hSelected⟩
  exact hRealization.selectedRestoresEdge
    edge action hEdge hAlternative hSelected

/-- Because every declared stale dependency is exposed by at least one edge,
edge restoration repairs every declared stale dependency. -/
theorem repairSet_realization_restores_staleDependencies
    {A revalidated : AdoptState}
    {problem : RepairProblem A}
    {X : RepairActionSet}
    (hRepair : RepairSet problem X)
    (hRealization : RepairRealization problem X revalidated) :
    ∀ obligation,
      obligation ∈ problem.staleDependencies →
      obligation.Holds revalidated := by
  intro obligation hStale
  rcases problem.staleExposed obligation hStale with
    ⟨edge, hEdge, hObligation⟩
  have hRestored :=
    repairSet_realization_restores_edges hRepair hRealization edge hEdge
  rw [hObligation] at hRestored
  exact hRestored

/-- The revalidated state itself satisfies the target once every unresolved cut
is hit by an effective repair set. -/
theorem repairSet_sufficient_before_refresh
    {A revalidated : AdoptState}
    {problem : RepairProblem A}
    {X : RepairActionSet}
    (hRepair : RepairSet problem X)
    (hRealization : RepairRealization problem X revalidated) :
    problem.target.Holds revalidated := by
  apply hRealization.targetClosure
  exact repairSet_realization_restores_staleDependencies hRepair hRealization

/-- Semantic name for the post-revalidation fixed-point projection. -/
def RefreshAfterRevalidation (revalidated : AdoptState) : AdoptState :=
  refreshActiveContexts revalidated

/-- Main #46 sufficiency theorem.

If `X` hits every unresolved dependency cut and its selected actions are soundly
realized in `revalidated`, then the final refresh restores the specified target
currentness obligation. -/
theorem repairSet_sufficient_after_refresh
    {A revalidated : AdoptState}
    {problem : RepairProblem A}
    {X : RepairActionSet}
    (hRepair : RepairSet problem X)
    (hRealization : RepairRealization problem X revalidated) :
    problem.target.Holds (RefreshAfterRevalidation revalidated) := by
  apply (repairObligation_refresh_iff revalidated problem.target).2
  exact repairSet_sufficient_before_refresh hRepair hRealization

/-- Minimality is not required for restoration: every minimal repair set is
sufficient only because it is first of all an ordinary repair set. -/
theorem minimalRepairSet_sufficient_after_refresh
    {A revalidated : AdoptState}
    {problem : RepairProblem A}
    {X : RepairActionSet}
    (hMinimal : MinimalRepairSet problem X)
    (hRealization : RepairRealization problem X revalidated) :
    problem.target.Holds (RefreshAfterRevalidation revalidated) := by
  exact repairSet_sufficient_after_refresh
    (minimalRepairSet_is_repairSet hMinimal) hRealization

end ResponsibilityTopology
