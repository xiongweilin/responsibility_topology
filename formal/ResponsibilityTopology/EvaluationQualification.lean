import ResponsibilityTopology.RootFormation

namespace ResponsibilityTopology

/-!
Evaluation qualification laws.

Historical existence, evaluation presence, and current usability are distinct.
ROOT admission records declared actor/basis metadata but does not authenticate
the actor or establish adequacy of the recorded basis. Historical formation
families reuse the generic fresh-warrant non-qualification lemma below.
-/

/-- Both evaluation axes have records at this key. -/
def Evaluated (S : CanonicalState) (key : EvalKey) : Prop :=
  (∃ status, S.epi key = some status) ∧
    ∃ placement, S.placement key = some placement

/-- Narrow state-backed Boolean observation for the existing canonical-read
surface. This does not attempt to construct a full `LicensingRead`. -/
def usableFromState
    (S : CanonicalState)
    (profileDigest contextId use : String)
    (warrantId : WarrantId) : Bool :=
  match S.epi ⟨profileDigest, contextId, use, warrantId⟩,
      S.placement ⟨profileDigest, contextId, use, warrantId⟩ with
  | some .live, some .placed => true
  | _, _ => false

theorem usable_iff_live_and_placed
    (S : CanonicalState) (key : EvalKey) :
    Usable S key ↔
      S.epi key = some .live ∧ S.placement key = some .placed := by
  rfl

theorem usable_implies_evaluated
    {S : CanonicalState} {key : EvalKey}
    (hUsable : Usable S key) :
    Evaluated S key := by
  exact ⟨⟨.live, hUsable.1⟩, ⟨.placed, hUsable.2⟩⟩

theorem usableFromState_true_iff
    (S : CanonicalState)
    (profileDigest contextId use : String)
    (warrantId : WarrantId) :
    usableFromState S profileDigest contextId use warrantId = true ↔
      Usable S ⟨profileDigest, contextId, use, warrantId⟩ := by
  let key : EvalKey := ⟨profileDigest, contextId, use, warrantId⟩
  change
    (match S.epi key, S.placement key with
      | some .live, some .placed => true
      | _, _ => false) = true ↔
      (S.epi key = some .live ∧ S.placement key = some .placed)
  cases hEpi : S.epi key with
  | none =>
      simp [hEpi]
  | some status =>
      cases status with
      | live =>
          cases hPlacement : S.placement key with
          | none =>
              simp [hEpi, hPlacement]
          | some placement =>
              cases placement <;> simp [hEpi, hPlacement]
      | suspended =>
          simp [hEpi]

/-- Exact history and evaluation facts exposed by a valid ROOT admission. The
constructor does not require evaluation freshness, context activity, binding
activity, or a repeated context-signature check. -/
theorem admitRoot_evaluation_exact
    {S S' : CanonicalState}
    {warrantId : WarrantId}
    {bindingId contextId use : String}
    {metadata : AdmissionMetadata}
    (hStep :
      Step S (.admitRoot warrantId bindingId contextId use metadata) S') :
    ∃ binding context warrant,
      S.binding bindingId = some binding ∧
      S.context contextId = some context ∧
      S.warrant warrantId = some warrant ∧
      warrant.constructor = .root ∧
      warrant.formationContext = contextId ∧
      warrant.formationProfileDigest = binding.profileDigest ∧
      binding.use = use ∧
      S'.epi ⟨binding.profileDigest, contextId, use, warrantId⟩ =
        some .live ∧
      S'.placement ⟨binding.profileDigest, contextId, use, warrantId⟩ =
        some .placed := by
  cases hStep with
  | @admitRoot _ _ _ _ _ binding context warrant
      bindingCanonical contextCanonical warrantCanonical isRoot
      formationContext formationProfile useMatches =>
      refine ⟨binding, context, warrant, bindingCanonical, contextCanonical,
        warrantCanonical, isRoot, formationContext, formationProfile,
        useMatches, ?_, ?_⟩
      · exact (qualifyEvaluation_exact S
          ⟨binding.profileDigest, contextId, use, warrantId⟩).1
      · exact (qualifyEvaluation_exact S
          ⟨binding.profileDigest, contextId, use, warrantId⟩).2

/-- Valid ROOT admission establishes usability at the exact formation-profile,
context, and requested-use evaluation key. -/
theorem admitRoot_makes_usable
    {S S' : CanonicalState}
    {warrantId : WarrantId}
    {bindingId contextId use : String}
    {metadata : AdmissionMetadata}
    (hStep :
      Step S (.admitRoot warrantId bindingId contextId use metadata) S') :
    ∃ binding,
      S.binding bindingId = some binding ∧
      Usable S' ⟨binding.profileDigest, contextId, use, warrantId⟩ := by
  rcases admitRoot_evaluation_exact hStep with
    ⟨binding, context, warrant, hBinding, hContext, hWarrant, hRoot,
      hFormationContext, hFormationProfile, hUse, hEpi, hPlacement⟩
  exact ⟨binding, hBinding, hEpi, hPlacement⟩

/-- Admission mutates evaluation state only; immutable canonical history keeps
all exact referents. -/
theorem admitRoot_historyReferentsImmutable
    {S S' : CanonicalState}
    {warrantId : WarrantId}
    {bindingId contextId use : String}
    {metadata : AdmissionMetadata}
    (hStep :
      Step S (.admitRoot warrantId bindingId contextId use metadata) S') :
    HistoryReferentsImmutable S S' :=
  step_historyReferentsImmutable hStep

/-- Specialized warrant-history corollary for ROOT admission. -/
theorem admitRoot_preserves_existing_warrant_history
    {S S' : CanonicalState}
    {warrantId : WarrantId}
    {bindingId contextId use : String}
    {metadata : AdmissionMetadata}
    (hStep :
      Step S (.admitRoot warrantId bindingId contextId use metadata) S') :
    ∀ ⦃id warrant⦄,
      S.warrant id = some warrant → S'.warrant id = some warrant := by
  exact (admitRoot_historyReferentsImmutable hStep).warrantImmutable

/-- ROOT admission preserves the shared evaluation coherence obligations rather
than creating an operation-specific invariant package. -/
theorem admitRoot_preserves_evaluationInvariant
    {S S' : CanonicalState}
    {warrantId : WarrantId}
    {bindingId contextId use : String}
    {metadata : AdmissionMetadata}
    (hInv : CanonicalStateInvariant S)
    (hStep :
      Step S (.admitRoot warrantId bindingId contextId use metadata) S') :
    EvaluationReferentsCanonical S' ∧ EvaluationPairCoherent S' := by
  have hPost := step_preserves_invariant hInv hStep
  exact ⟨hPost.evaluationReferentsCanonical, hPost.evaluationPairCoherent⟩

/-- Fresh historical IDs cannot already carry an evaluation position in any
canonical state satisfying evaluation-referent coherence. This is reusable by
all history-only formation constructors. -/
theorem freshHistoricalWarrant_noEvaluation
    {S : CanonicalState}
    {warrantId : WarrantId}
    (hEvaluation : EvaluationReferentsCanonical S)
    (fresh : S.warrant warrantId = none) :
    ∀ profileDigest contextId use,
      S.epi ⟨profileDigest, contextId, use, warrantId⟩ = none ∧
      S.placement ⟨profileDigest, contextId, use, warrantId⟩ = none := by
  intro profileDigest contextId use
  let key : EvalKey := ⟨profileDigest, contextId, use, warrantId⟩
  have hEpiNone : S.epi key = none := by
    cases hStatus : S.epi key with
    | none => rfl
    | some status =>
        exfalso
        rcases hEvaluation (key := key) (Or.inl ⟨status, hStatus⟩) with
          ⟨warrant, hWarrant, hProfile, hContext⟩
        rw [fresh] at hWarrant
        cases hWarrant
  have hPlacementNone : S.placement key = none := by
    cases hPlacement : S.placement key with
    | none => rfl
    | some placement =>
        exfalso
        rcases hEvaluation (key := key) (Or.inr ⟨placement, hPlacement⟩) with
          ⟨warrant, hWarrant, hProfile, hContext⟩
        rw [fresh] at hWarrant
        cases hWarrant
  exact ⟨hEpiNone, hPlacementNone⟩

/-- A missing evaluation pair is sufficient to refute usability. -/
theorem noEvaluation_notUsable
    {S : CanonicalState} {key : EvalKey}
    (hNone : S.epi key = none ∧ S.placement key = none) :
    ¬ Usable S key := by
  intro hUsable
  have hLive : S.epi key = some .live := hUsable.1
  rw [hNone.1] at hLive
  cases hLive

/-- A freshly formed ROOT has no evaluation position under any
profile/context/use key. Historical formation therefore does not silently
qualify the new warrant. -/
theorem rootStep_newWarrant_unqualified
    {S S' : CanonicalState}
    {warrantId : WarrantId}
    {bindingId contextId : String}
    {input : RootInput}
    (hReachable : Reachable S)
    (hStep : Step S (.root warrantId bindingId contextId input) S') :
    ∀ profileDigest observedContext use,
      S'.epi ⟨profileDigest, observedContext, use, warrantId⟩ = none ∧
      S'.placement ⟨profileDigest, observedContext, use, warrantId⟩ = none := by
  have hInv := reachable_invariant hReachable
  cases hStep with
  | root fresh bindingCanonical contextCanonical accepted =>
      intro profileDigest observedContext use
      exact freshHistoricalWarrant_noEvaluation
        hInv.evaluationReferentsCanonical fresh
        profileDigest observedContext use

/-- Machine-checked responsibility boundary: ROOT formation alone cannot make
the newly created historical warrant currently usable. -/
theorem rootStep_newWarrant_notUsable
    {S S' : CanonicalState}
    {warrantId : WarrantId}
    {bindingId contextId : String}
    {input : RootInput}
    (hReachable : Reachable S)
    (hStep : Step S (.root warrantId bindingId contextId input) S') :
    ∀ profileDigest observedContext use,
      ¬ Usable S' ⟨profileDigest, observedContext, use, warrantId⟩ := by
  intro profileDigest observedContext use
  exact noEvaluation_notUsable
    (rootStep_newWarrant_unqualified hReachable hStep
      profileDigest observedContext use)

/-- Any usable evaluation position resolves to one immutable historical warrant
with the same formation profile/context, and those referents are canonical in
the shared state invariant. -/
theorem usable_implies_canonicalHistoricalWarrant
    {S : CanonicalState} {key : EvalKey}
    (hInv : CanonicalStateInvariant S)
    (hUsable : Usable S key) :
    ∃ warrant,
      S.warrant key.warrantId = some warrant ∧
      warrant.formationProfileDigest = key.profileDigest ∧
      warrant.formationContext = key.contextId ∧
      (∃ profile, S.profile key.profileDigest = some profile) ∧
      ∃ context, S.context key.contextId = some context := by
  have hRecord : HasEvaluationRecord S key :=
    Or.inl ⟨.live, hUsable.1⟩
  rcases hInv.evaluationReferentsCanonical hRecord with
    ⟨warrant, hWarrant, hProfile, hContext⟩
  rcases hInv.warrantReferentsCanonical hWarrant with
    ⟨⟨context, hCanonicalContext⟩, profile, hCanonicalProfile⟩
  rw [hProfile] at hCanonicalProfile
  rw [hContext] at hCanonicalContext
  exact ⟨warrant, hWarrant, hProfile, hContext,
    ⟨profile, hCanonicalProfile⟩, context, hCanonicalContext⟩

theorem reachable_usable_implies_canonical
    {S : CanonicalState} {key : EvalKey}
    (hReachable : Reachable S)
    (hUsable : Usable S key) :
    ∃ warrant,
      S.warrant key.warrantId = some warrant ∧
      warrant.formationProfileDigest = key.profileDigest ∧
      warrant.formationContext = key.contextId ∧
      (∃ profile, S.profile key.profileDigest = some profile) ∧
      ∃ context, S.context key.contextId = some context := by
  exact usable_implies_canonicalHistoricalWarrant
    (reachable_invariant hReachable) hUsable

end ResponsibilityTopology
