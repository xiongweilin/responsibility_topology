import ResponsibilityTopology.TransportFormation

namespace ResponsibilityTopology

/-!
TRANSPORT qualification laws.

Formation responsibilities remain in immutable history. Qualification consumes
only the historical transport identity needed to locate its exact two stored
parents, requires those parent identities to be currently usable at their own
formation contexts, and writes the transported child at its target-context key.
-/

/-- Constructor inversion exposes the source-context currentness responsibility
without replaying TRANSPORT formation discipline. -/
theorem qualifyTransport_requires_sourceCurrent
    {S S' : CanonicalState}
    {warrantId : WarrantId}
    {bindingId targetContextId use : String}
    {metadata : QualificationMetadata}
    (hStep : Step S
      (.qualifyTransport warrantId bindingId targetContextId use metadata) S') :
    ∃ binding warrant mapId originalId witnessId original witness,
      S.binding bindingId = some binding ∧
      S.warrant warrantId = some warrant ∧
      warrant.constructor = .transport mapId ∧
      warrant.parents = [originalId, witnessId] ∧
      S.warrant originalId = some original ∧
      S.warrant witnessId = some witness ∧
      warrant.formationContext = targetContextId ∧
      warrant.formationProfileDigest = binding.profileDigest ∧
      TransportParentsUsable
        S binding.profileDigest use originalId witnessId original witness := by
  cases hStep with
  | @qualifyTransport wid oid xid bid cid observedUse mapId meta binding warrant
      original witness bindingCanonical warrantCanonical isTransport parentsExact
      originalCanonical witnessCanonical formationContext formationProfile
      parentsUsable =>
      exact ⟨binding, warrant, mapId, oid, xid, original, witness,
        bindingCanonical, warrantCanonical, isTransport, parentsExact,
        originalCanonical, witnessCanonical, formationContext, formationProfile,
        parentsUsable⟩

/-- The currentness coordinates are inherited from each historical parent,
not from the transported child's target context. -/
theorem qualifyTransport_sourceContexts_exact
    {S S' : CanonicalState}
    {warrantId : WarrantId}
    {bindingId targetContextId use : String}
    {metadata : QualificationMetadata}
    (hStep : Step S
      (.qualifyTransport warrantId bindingId targetContextId use metadata) S') :
    ∃ binding originalId witnessId original witness,
      S.binding bindingId = some binding ∧
      S.warrant originalId = some original ∧
      S.warrant witnessId = some witness ∧
      Usable S
        ⟨binding.profileDigest, original.formationContext, use, originalId⟩ ∧
      Usable S
        ⟨binding.profileDigest, witness.formationContext, use, witnessId⟩ := by
  rcases qualifyTransport_requires_sourceCurrent hStep with
    ⟨binding, warrant, mapId, originalId, witnessId, original, witness,
      hBinding, hWarrant, hConstructor, hParents, hOriginal, hWitness,
      hContext, hProfile, hUsable⟩
  exact ⟨binding, originalId, witnessId, original, witness,
    hBinding, hOriginal, hWitness, hUsable.1, hUsable.2⟩

/-- TRANSPORT qualification writes LIVE/PLACED at the exact child target key. -/
theorem qualifyTransport_evaluation_exact
    {S S' : CanonicalState}
    {warrantId : WarrantId}
    {bindingId targetContextId use : String}
    {metadata : QualificationMetadata}
    (hStep : Step S
      (.qualifyTransport warrantId bindingId targetContextId use metadata) S') :
    ∃ binding warrant mapId originalId witnessId original witness,
      S.binding bindingId = some binding ∧
      S.warrant warrantId = some warrant ∧
      warrant.constructor = .transport mapId ∧
      warrant.parents = [originalId, witnessId] ∧
      S.warrant originalId = some original ∧
      S.warrant witnessId = some witness ∧
      warrant.formationContext = targetContextId ∧
      warrant.formationProfileDigest = binding.profileDigest ∧
      TransportParentsUsable
        S binding.profileDigest use originalId witnessId original witness ∧
      S'.epi
          ⟨binding.profileDigest, targetContextId, use, warrantId⟩ = some .live ∧
      S'.placement
          ⟨binding.profileDigest, targetContextId, use, warrantId⟩ =
        some .placed := by
  cases hStep with
  | @qualifyTransport wid oid xid bid cid observedUse mapId meta binding warrant
      original witness bindingCanonical warrantCanonical isTransport parentsExact
      originalCanonical witnessCanonical formationContext formationProfile
      parentsUsable =>
      refine ⟨binding, warrant, mapId, oid, xid, original, witness,
        bindingCanonical, warrantCanonical, isTransport, parentsExact,
        originalCanonical, witnessCanonical, formationContext, formationProfile,
        parentsUsable, ?_, ?_⟩
      · simp [qualifyEvaluation, setOptionAt]
      · simp [qualifyEvaluation, setOptionAt]

/-- Explicit TRANSPORT qualification makes the transported child usable at the
exact target-context key. -/
theorem qualifyTransport_makes_usable
    {S S' : CanonicalState}
    {warrantId : WarrantId}
    {bindingId targetContextId use : String}
    {metadata : QualificationMetadata}
    (hStep : Step S
      (.qualifyTransport warrantId bindingId targetContextId use metadata) S') :
    ∃ binding,
      S.binding bindingId = some binding ∧
      Usable S'
        ⟨binding.profileDigest, targetContextId, use, warrantId⟩ := by
  rcases qualifyTransport_evaluation_exact hStep with
    ⟨binding, warrant, mapId, originalId, witnessId, original, witness,
      hBinding, hWarrant, hConstructor, hParents, hOriginal, hWitness,
      hContext, hProfile, hUsable, hEpi, hPlacement⟩
  exact ⟨binding, hBinding, hEpi, hPlacement⟩

/-- Qualification changes evaluation only; all canonical historical referents
remain immutable. -/
theorem qualifyTransport_historyReferentsImmutable
    {S S' : CanonicalState}
    {warrantId : WarrantId}
    {bindingId targetContextId use : String}
    {metadata : QualificationMetadata}
    (hStep : Step S
      (.qualifyTransport warrantId bindingId targetContextId use metadata) S') :
    HistoryReferentsImmutable S S' :=
  step_historyReferentsImmutable hStep

/-- Specialized preservation of evaluation referent/pair coherence. -/
theorem qualifyTransport_preserves_evaluationInvariant
    {S S' : CanonicalState}
    {warrantId : WarrantId}
    {bindingId targetContextId use : String}
    {metadata : QualificationMetadata}
    (hInv : CanonicalStateInvariant S)
    (hStep : Step S
      (.qualifyTransport warrantId bindingId targetContextId use metadata) S') :
    EvaluationReferentsCanonical S' ∧ EvaluationPairCoherent S' := by
  have hPost := step_preserves_invariant hInv hStep
  exact ⟨hPost.evaluationReferentsCanonical, hPost.evaluationPairCoherent⟩

/-- The exact child evaluation remains backed by a canonical profile/use binding.
The proof is sourced from the pre-state parent-usability record, not from a new
`binding.use = use` premise. -/
theorem qualifyTransport_preserves_profileUseBacking
    {S S' : CanonicalState}
    {warrantId : WarrantId}
    {bindingId targetContextId use : String}
    {metadata : QualificationMetadata}
    (hInv : CanonicalStateInvariant S)
    (hStep : Step S
      (.qualifyTransport warrantId bindingId targetContextId use metadata) S') :
    EvaluationProfileUseBackedByBinding S' :=
  (step_preserves_invariant hInv hStep).evaluationProfileUseBackedByBinding

end ResponsibilityTopology
