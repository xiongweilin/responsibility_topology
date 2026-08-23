import ResponsibilityTopology.Reachability

namespace ResponsibilityTopology

/-!
ROOT historical formation laws.

The transition is intentionally formation-only.  It creates one immutable
historical warrant and does not activate contexts, mutate activation provenance,
mark licenses for review, create licenses, or otherwise qualify the new warrant
for evaluation/use.
-/

/-- Pointwise evaluation topology preserved by a ROOT formation step. -/
structure RootEvaluationTopologyUnchanged
    (S S' : CanonicalState) : Prop where
  activeContext : ∀ key, S'.activeContext key ↔ S.activeContext key
  activationProvenance : ∀ key,
    S'.activationProvenance key = S.activationProvenance key
  reviewRequired : ∀ licenseId,
    S'.reviewRequired licenseId ↔ S.reviewRequired licenseId
  license : ∀ licenseId, S'.license licenseId = S.license licenseId

/-- Exact post-state object produced by ROOT.  No active/evaluation premise is
present: only canonical binding/context, signature acceptance, and freshness
can have justified the step. -/
theorem rootStep_newWarrant_exact
    {S S' : CanonicalState}
    {warrantId : WarrantId}
    {bindingId contextId : String}
    {input : RootInput}
    (hStep : Step S (.root warrantId bindingId contextId input) S') :
    ∃ binding context,
      S.binding bindingId = some binding ∧
      S.context contextId = some context ∧
      context.accepts input.claim ∧
      S'.warrant warrantId = some
        (rootHistoricalWarrant
          warrantId binding.profileDigest contextId input) := by
  cases hStep with
  | @root wid bid cid rin binding context fresh bindingCanonical contextCanonical accepted =>
      exact ⟨binding, context, bindingCanonical, contextCanonical, accepted,
        by simp [putCanonical]⟩

/-- Existing warrant IDs keep the exact same historical referent. -/
theorem rootStep_oldWarrants_immutable
    {S S' : CanonicalState}
    {warrantId : WarrantId}
    {bindingId contextId : String}
    {input : RootInput}
    (hStep : Step S (.root warrantId bindingId contextId input) S') :
    ∀ ⦃id warrant⦄,
      S.warrant id = some warrant → S'.warrant id = some warrant := by
  exact (step_historyReferentsImmutable hStep).warrantImmutable

/-- ROOT participates in the shared append-only historical-referent law. -/
theorem rootStep_historyReferentsImmutable
    {S S' : CanonicalState}
    {warrantId : WarrantId}
    {bindingId contextId : String}
    {input : RootInput}
    (hStep : Step S (.root warrantId bindingId contextId input) S') :
    HistoryReferentsImmutable S S' :=
  step_historyReferentsImmutable hStep

/-- Machine-checked formation/admission boundary for the evaluation topology
currently represented by the canonical-state skeleton. -/
theorem rootStep_evaluationTopology_unchanged
    {S S' : CanonicalState}
    {warrantId : WarrantId}
    {bindingId contextId : String}
    {input : RootInput}
    (hStep : Step S (.root warrantId bindingId contextId input) S') :
    RootEvaluationTopologyUnchanged S S' := by
  cases hStep with
  | root fresh bindingCanonical contextCanonical accepted =>
      constructor
      · intro key
        rfl
      · intro key
        rfl
      · intro licenseId
        rfl
      · intro licenseId
        rfl

/-- ROOT preservation specialized to canonical warrant formation referents. -/
theorem rootStep_preserves_warrantReferentsCanonical
    {S S' : CanonicalState}
    {warrantId : WarrantId}
    {bindingId contextId : String}
    {input : RootInput}
    (hInv : CanonicalStateInvariant S)
    (hStep : Step S (.root warrantId bindingId contextId input) S') :
    WarrantReferentsCanonical S' :=
  (step_preserves_invariant hInv hStep).warrantReferentsCanonical

/-- ROOT has no parents, while all old parent references remain canonical. -/
theorem rootStep_preserves_warrantParentsCanonical
    {S S' : CanonicalState}
    {warrantId : WarrantId}
    {bindingId contextId : String}
    {input : RootInput}
    (hInv : CanonicalStateInvariant S)
    (hStep : Step S (.root warrantId bindingId contextId input) S') :
    WarrantParentsCanonical S' :=
  (step_preserves_invariant hInv hStep).warrantParentsCanonical

/-- The newly formed ROOT has exact empty parents and distinct root/source
singleton lineages; old ROOT shape laws are preserved. -/
theorem rootStep_preserves_rootWarrantWellFormed
    {S S' : CanonicalState}
    {warrantId : WarrantId}
    {bindingId contextId : String}
    {input : RootInput}
    (hInv : CanonicalStateInvariant S)
    (hStep : Step S (.root warrantId bindingId contextId input) S') :
    RootWarrantWellFormed S' :=
  (step_preserves_invariant hInv hStep).rootWarrantWellFormed

/-- Reachable historical warrants always point back to canonical formation
context/profile referents. -/
theorem reachable_warrantReferentsCanonical
    {S : CanonicalState}
    (hReachable : Reachable S) :
    WarrantReferentsCanonical S :=
  (reachable_invariant hReachable).warrantReferentsCanonical

/-- Reachable parent references resolve to canonical historical warrant objects. -/
theorem reachable_warrantParentsCanonical
    {S : CanonicalState}
    (hReachable : Reachable S) :
    WarrantParentsCanonical S :=
  (reachable_invariant hReachable).warrantParentsCanonical

/-- Every reachable ROOT object has the exact constructor/parent/source/lineage
shape fixed by this milestone. -/
theorem reachable_rootWarrantsWellFormed
    {S : CanonicalState}
    (hReachable : Reachable S) :
    RootWarrantWellFormed S :=
  (reachable_invariant hReachable).rootWarrantWellFormed

/-- Reachable root-lineage IDs always resolve to canonical historical warrants. -/
theorem reachable_warrantRootLineageCanonical
    {S : CanonicalState}
    (hReachable : Reachable S) :
    WarrantRootLineageCanonical S :=
  (reachable_invariant hReachable).warrantRootLineageCanonical

end ResponsibilityTopology
