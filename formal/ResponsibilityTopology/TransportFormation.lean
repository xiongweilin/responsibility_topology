import ResponsibilityTopology.EvaluationQualification
import ResponsibilityTopology.TransportSemantics

namespace ResponsibilityTopology

/-!
Reachable TRANSPORT historical formation laws.

Exact formation remains a local `Step` fact.  Reachability is needed only for
claims that use the global evaluation-referent invariant, such as fresh-child
non-usability.
-/

/-- Evaluation/currentness topology preserved pointwise by TRANSPORT formation. -/
structure TransportEvaluationTopologyUnchanged
    (S S' : CanonicalState) : Prop where
  activeContext : ∀ key, S'.activeContext key ↔ S.activeContext key
  activationProvenance : ∀ key,
    S'.activationProvenance key = S.activationProvenance key
  reviewRequired : ∀ licenseId,
    S'.reviewRequired licenseId ↔ S.reviewRequired licenseId
  license : ∀ licenseId, S'.license licenseId = S.license licenseId
  epi : ∀ key, S'.epi key = S.epi key
  placement : ∀ key, S'.placement key = S.placement key

/-- T1.1: one TRANSPORT step exposes the exact canonical formation witnesses and
exact historical child.  No `Reachable` premise is required. -/
theorem transportStep_newWarrant_exact
    {S S' : CanonicalState}
    {warrantId originalId witnessId : WarrantId}
    {bindingId targetContextId mapId : String}
    {translatedClaim : Claim}
    {outScope : Scope}
    (hStep : Step S
      (.transport warrantId bindingId targetContextId mapId originalId witnessId
        translatedClaim outScope) S') :
    ∃ binding targetContext original witness,
      S.binding bindingId = some binding ∧
      S.context targetContextId = some targetContext ∧
      S.warrant originalId = some original ∧
      S.warrant witnessId = some witness ∧
      TransportFormationDiscipline
        targetContext binding.profileDigest targetContextId mapId
        originalId witnessId original witness translatedClaim original.role
        outScope [originalId, witnessId] ∧
      S'.warrant warrantId = some
        (transportHistoricalWarrant
          mapId binding.profileDigest targetContextId originalId witnessId
          original witness translatedClaim outScope) := by
  cases hStep with
  | @transport wid oid xid bid cid mid claim scope binding targetContext
      original witness fresh bindingCanonical contextCanonical
      originalCanonical witnessCanonical discipline =>
      exact ⟨binding, targetContext, original, witness,
        bindingCanonical, contextCanonical, originalCanonical, witnessCanonical,
        discipline, by simp [putCanonical]⟩

/-- T1.2: output scope is bounded by both the translated content source and the
translation witness. -/
theorem transportStep_scope_conservative
    {S S' : CanonicalState}
    {warrantId originalId witnessId : WarrantId}
    {bindingId targetContextId mapId : String}
    {translatedClaim : Claim}
    {outScope : Scope}
    (hStep : Step S
      (.transport warrantId bindingId targetContextId mapId originalId witnessId
        translatedClaim outScope) S') :
    ∃ original witness,
      S.warrant originalId = some original ∧
      S.warrant witnessId = some witness ∧
      ScopeNarrowerOrEqual outScope original.scope ∧
      ScopeNarrowerOrEqual outScope witness.scope := by
  rcases transportStep_newWarrant_exact hStep with
    ⟨binding, targetContext, original, witness,
      hBinding, hContext, hOriginal, hWitness, hDiscipline, hChild⟩
  exact ⟨original, witness, hOriginal, hWitness,
    hDiscipline.scopeWithinOriginal, hDiscipline.scopeWithinWitness⟩

/-- T1.3: TRANSPORT may preserve or narrow canonical escalation strength but may
not amplify it. -/
theorem transportStep_strength_nonamplifying
    {S S' : CanonicalState}
    {warrantId originalId witnessId : WarrantId}
    {bindingId targetContextId mapId : String}
    {translatedClaim : Claim}
    {outScope : Scope}
    (hStep : Step S
      (.transport warrantId bindingId targetContextId mapId originalId witnessId
        translatedClaim outScope) S') :
    ∃ original,
      S.warrant originalId = some original ∧
      NoTransportEscalationAmplification original translatedClaim := by
  rcases transportStep_newWarrant_exact hStep with
    ⟨binding, targetContext, original, witness,
      hBinding, hContext, hOriginal, hWitness, hDiscipline, hChild⟩
  exact ⟨original, hOriginal, hDiscipline.noEscalationAmplification⟩

/-- Existing warrant IDs keep the exact same historical referent. -/
theorem transportStep_oldWarrants_immutable
    {S S' : CanonicalState}
    {warrantId originalId witnessId : WarrantId}
    {bindingId targetContextId mapId : String}
    {translatedClaim : Claim}
    {outScope : Scope}
    (hStep : Step S
      (.transport warrantId bindingId targetContextId mapId originalId witnessId
        translatedClaim outScope) S') :
    ∀ ⦃id warrant⦄,
      S.warrant id = some warrant → S'.warrant id = some warrant := by
  exact (step_historyReferentsImmutable hStep).warrantImmutable

/-- T1.4: historical TRANSPORT formation writes no represented evaluation or
currentness field. -/
theorem transportStep_evaluationTopology_unchanged
    {S S' : CanonicalState}
    {warrantId originalId witnessId : WarrantId}
    {bindingId targetContextId mapId : String}
    {translatedClaim : Claim}
    {outScope : Scope}
    (hStep : Step S
      (.transport warrantId bindingId targetContextId mapId originalId witnessId
        translatedClaim outScope) S') :
    TransportEvaluationTopologyUnchanged S S' := by
  cases hStep with
  | transport fresh bindingCanonical contextCanonical originalCanonical
      witnessCanonical discipline =>
      constructor <;> intro <;> rfl

/-- Fresh TRANSPORT formation creates no evaluation position under any observed
profile/context/use key. -/
theorem transportStep_newWarrant_unqualified
    {S S' : CanonicalState}
    {warrantId originalId witnessId : WarrantId}
    {bindingId targetContextId mapId : String}
    {translatedClaim : Claim}
    {outScope : Scope}
    (hReachable : Reachable S)
    (hStep : Step S
      (.transport warrantId bindingId targetContextId mapId originalId witnessId
        translatedClaim outScope) S') :
    ∀ profileDigest observedContext use,
      S'.epi ⟨profileDigest, observedContext, use, warrantId⟩ = none ∧
      S'.placement ⟨profileDigest, observedContext, use, warrantId⟩ = none := by
  have hInv := reachable_invariant hReachable
  cases hStep with
  | transport fresh bindingCanonical contextCanonical originalCanonical
      witnessCanonical discipline =>
      intro profileDigest observedContext use
      exact freshHistoricalWarrant_noEvaluation
        hInv.evaluationReferentsCanonical fresh
        profileDigest observedContext use

/-- Historical TRANSPORT formation alone never grants current usability. -/
theorem transportStep_newWarrant_notUsable
    {S S' : CanonicalState}
    {warrantId originalId witnessId : WarrantId}
    {bindingId targetContextId mapId : String}
    {translatedClaim : Claim}
    {outScope : Scope}
    (hReachable : Reachable S)
    (hStep : Step S
      (.transport warrantId bindingId targetContextId mapId originalId witnessId
        translatedClaim outScope) S') :
    ∀ profileDigest observedContext use,
      ¬ Usable S' ⟨profileDigest, observedContext, use, warrantId⟩ := by
  intro profileDigest observedContext use
  exact noEvaluation_notUsable
    (transportStep_newWarrant_unqualified hReachable hStep
      profileDigest observedContext use)

/-- T1.5 specialized form: a TRANSPORT step from an invariant state preserves
the shared historical TRANSPORT replay invariant. -/
theorem transportStep_preserves_transportWarrantWellFormed
    {S S' : CanonicalState}
    {warrantId originalId witnessId : WarrantId}
    {bindingId targetContextId mapId : String}
    {translatedClaim : Claim}
    {outScope : Scope}
    (hInv : CanonicalStateInvariant S)
    (hStep : Step S
      (.transport warrantId bindingId targetContextId mapId originalId witnessId
        translatedClaim outScope) S') :
    TransportWarrantWellFormed S' :=
  (step_preserves_invariant hInv hStep).transportWarrantWellFormed

end ResponsibilityTopology
