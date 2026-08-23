import ResponsibilityTopology.InferFormation

namespace ResponsibilityTopology

/-!
Ordinary INFER current qualification.

Historical formation responsibility is carried by the immutable warrant and the
shared reachable invariant established in #14. Qualification does not replay
rule lookup, typing, guards, context acceptance, scope checks, or escalation
strength. Its new responsibility is current usability of the ordered historical
parents in the selected evaluation environment.
-/

/-- A historically well-formed INFER warrant cannot have an empty parent list.
This closes the vacuity hole in current-parent qualification. -/
theorem inferWarrantWellFormed_parents_nonempty
    {S : CanonicalState}
    {warrantId : WarrantId}
    {warrant : HistoricalWarrant}
    {ruleId : String}
    (hWellFormed : InferWarrantWellFormed S)
    (hWarrant : S.warrant warrantId = some warrant)
    (hConstructor : warrant.constructor = .infer ruleId) :
    warrant.parents ≠ [] := by
  rcases hWellFormed hWarrant hConstructor with
    ⟨profile, context, rule, parents, hProfile, hContext, hRule,
      hParents, hDiscipline, hExact⟩
  have hResolvedNonempty : parents ≠ [] := by
    intro hEmpty
    have hRoles := hDiscipline.orderedRolesExact
    rw [hEmpty] at hRoles
    exact (wellTypedRule_inputs_nonempty hDiscipline.wellTyped) hRoles.symm
  exact hParents.ids_nonempty_of_parents_nonempty hResolvedNonempty

/-- Exact pre-state responsibility exposed by one INFER qualification step.
No historical formation check is repeated in this theorem. -/
theorem qualifyInfer_requires_usableParents
    {S S' : CanonicalState}
    {warrantId : WarrantId}
    {bindingId contextId use : String}
    {metadata : QualificationMetadata}
    (hStep :
      Step S (.qualifyInfer warrantId bindingId contextId use metadata) S') :
    ∃ binding warrant ruleId,
      S.binding bindingId = some binding ∧
      S.warrant warrantId = some warrant ∧
      warrant.constructor = .infer ruleId ∧
      warrant.formationContext = contextId ∧
      warrant.formationProfileDigest = binding.profileDigest ∧
      InferParentsUsable S binding.profileDigest contextId use warrant := by
  cases hStep with
  | @qualifyInfer wid bid cid actualUse md binding warrant
      bindingCanonical warrantCanonical isInfer formationContext formationProfile
      parentsUsable =>
      rcases isInfer with ⟨ruleId, hConstructor⟩
      exact ⟨binding, warrant, ruleId, bindingCanonical, warrantCanonical,
        hConstructor, formationContext, formationProfile, parentsUsable⟩

/-- INFER qualification writes LIVE/PLACED at exactly the derived warrant's
selected profile/context/use key. Evaluation freshness is intentionally absent. -/
theorem qualifyInfer_evaluation_exact
    {S S' : CanonicalState}
    {warrantId : WarrantId}
    {bindingId contextId use : String}
    {metadata : QualificationMetadata}
    (hStep :
      Step S (.qualifyInfer warrantId bindingId contextId use metadata) S') :
    ∃ binding warrant ruleId,
      S.binding bindingId = some binding ∧
      S.warrant warrantId = some warrant ∧
      warrant.constructor = .infer ruleId ∧
      warrant.formationContext = contextId ∧
      warrant.formationProfileDigest = binding.profileDigest ∧
      InferParentsUsable S binding.profileDigest contextId use warrant ∧
      S'.epi ⟨binding.profileDigest, contextId, use, warrantId⟩ = some .live ∧
      S'.placement ⟨binding.profileDigest, contextId, use, warrantId⟩ =
        some .placed := by
  cases hStep with
  | @qualifyInfer _ _ _ _ _ binding warrant
      bindingCanonical warrantCanonical isInfer formationContext formationProfile
      parentsUsable =>
      rcases isInfer with ⟨ruleId, hConstructor⟩
      have hExact := qualifyEvaluation_exact S
        ⟨binding.profileDigest, contextId, use, warrantId⟩
      exact ⟨binding, warrant, ruleId, bindingCanonical, warrantCanonical,
        hConstructor, formationContext, formationProfile, parentsUsable,
        hExact.1, hExact.2⟩

/-- Current usable parents plus the explicit qualification transition establish
current usability of the derived warrant in the exact selected environment. -/
theorem qualifyInfer_makes_usable
    {S S' : CanonicalState}
    {warrantId : WarrantId}
    {bindingId contextId use : String}
    {metadata : QualificationMetadata}
    (hStep :
      Step S (.qualifyInfer warrantId bindingId contextId use metadata) S') :
    ∃ binding warrant,
      S.binding bindingId = some binding ∧
      S.warrant warrantId = some warrant ∧
      InferParentsUsable S binding.profileDigest contextId use warrant ∧
      Usable S' ⟨binding.profileDigest, contextId, use, warrantId⟩ := by
  rcases qualifyInfer_evaluation_exact hStep with
    ⟨binding, warrant, ruleId, hBinding, hWarrant, hConstructor,
      hContext, hProfile, hParents, hEpi, hPlacement⟩
  exact ⟨binding, warrant, hBinding, hWarrant, hParents, hEpi, hPlacement⟩

/-- Qualification mutates evaluation only; every immutable historical referent
is preserved exactly. -/
theorem qualifyInfer_historyReferentsImmutable
    {S S' : CanonicalState}
    {warrantId : WarrantId}
    {bindingId contextId use : String}
    {metadata : QualificationMetadata}
    (hStep :
      Step S (.qualifyInfer warrantId bindingId contextId use metadata) S') :
    HistoryReferentsImmutable S S' :=
  step_historyReferentsImmutable hStep

/-- Qualification preserves shared evaluation referent/pair coherence rather
than creating an INFER-specific evaluation invariant. -/
theorem qualifyInfer_preserves_evaluationInvariant
    {S S' : CanonicalState}
    {warrantId : WarrantId}
    {bindingId contextId use : String}
    {metadata : QualificationMetadata}
    (hInv : CanonicalStateInvariant S)
    (hStep :
      Step S (.qualifyInfer warrantId bindingId contextId use metadata) S') :
    EvaluationReferentsCanonical S' ∧ EvaluationPairCoherent S' := by
  have hPost := step_preserves_invariant hInv hStep
  exact ⟨hPost.evaluationReferentsCanonical, hPost.evaluationPairCoherent⟩

/-- Current-parent responsibility carries profile/use backing forward. The
qualification API need not invent a second `binding.use = use` check to preserve
this structural provenance invariant. -/
theorem qualifyInfer_preserves_profileUseBacking
    {S S' : CanonicalState}
    {warrantId : WarrantId}
    {bindingId contextId use : String}
    {metadata : QualificationMetadata}
    (hInv : CanonicalStateInvariant S)
    (hStep :
      Step S (.qualifyInfer warrantId bindingId contextId use metadata) S') :
    EvaluationProfileUseBackedByBinding S' :=
  (step_preserves_invariant hInv hStep).evaluationProfileUseBackedByBinding

/-- The exact newly qualified child environment has canonical binding backing.
The backing binding need not be the binding argument supplied to qualification;
its provenance is inherited from a nonempty usable parent evaluation chain. -/
theorem qualifyInfer_childProfileUse_backed
    {S S' : CanonicalState}
    {warrantId : WarrantId}
    {bindingId contextId use : String}
    {metadata : QualificationMetadata}
    (hInv : CanonicalStateInvariant S)
    (hStep :
      Step S (.qualifyInfer warrantId bindingId contextId use metadata) S') :
    ∃ binding backingId backing,
      S.binding bindingId = some binding ∧
      S'.binding backingId = some backing ∧
      backing.profileDigest = binding.profileDigest ∧
      backing.use = use := by
  rcases qualifyInfer_evaluation_exact hStep with
    ⟨binding, warrant, ruleId, hBinding, hWarrant, hConstructor,
      hContext, hProfile, hParents, hEpi, hPlacement⟩
  have hPost := step_preserves_invariant hInv hStep
  have hRecord : HasEvaluationRecord S'
      ⟨binding.profileDigest, contextId, use, warrantId⟩ :=
    Or.inl ⟨.live, hEpi⟩
  rcases hPost.evaluationProfileUseBackedByBinding hRecord with
    ⟨backingId, backing, hBacking, hProfileBacking, hUseBacking⟩
  exact ⟨binding, backingId, backing, hBinding, hBacking,
    hProfileBacking, hUseBacking⟩

/-- #14 + #15 lifecycle theorem. Historical formation creates the exact derived
object without usability; explicit qualification later consumes current usable
parents and establishes child usability. -/
theorem inferFormationQualification_boundary
    {S₀ S₁ S₂ : CanonicalState}
    {warrantId : WarrantId}
    {formationBindingId formationContextId ruleId : String}
    {parentIds : List WarrantId}
    {outScope : Scope}
    {qualificationBindingId qualificationContextId use : String}
    {metadata : QualificationMetadata}
    (hReachable : Reachable S₀)
    (hFormation :
      Step S₀
        (.infer warrantId formationBindingId formationContextId
          ruleId parentIds outScope)
        S₁)
    (hQualification :
      Step S₁
        (.qualifyInfer warrantId qualificationBindingId qualificationContextId
          use metadata)
        S₂) :
    ∃ binding warrant actualRuleId,
      S₁.binding qualificationBindingId = some binding ∧
      S₁.warrant warrantId = some warrant ∧
      warrant.constructor = .infer actualRuleId ∧
      warrant.formationContext = qualificationContextId ∧
      warrant.formationProfileDigest = binding.profileDigest ∧
      InferParentsUsable
        S₁ binding.profileDigest qualificationContextId use warrant ∧
      ¬ Usable S₁
        ⟨binding.profileDigest, qualificationContextId, use, warrantId⟩ ∧
      Usable S₂
        ⟨binding.profileDigest, qualificationContextId, use, warrantId⟩ := by
  rcases qualifyInfer_requires_usableParents hQualification with
    ⟨binding, warrant, actualRuleId, hBinding, hWarrant, hConstructor,
      hContext, hProfile, hParents⟩
  have hNotUsable := inferStep_newWarrant_notUsable
    hReachable hFormation binding.profileDigest qualificationContextId use
  rcases qualifyInfer_makes_usable hQualification with
    ⟨postBinding, postWarrant, hPostBinding, hPostWarrant,
      hPostParents, hUsable⟩
  have hBindingEq : postBinding = binding := by
    exact Option.some.inj (hPostBinding.symm.trans hBinding)
  subst postBinding
  have hWarrantEq : postWarrant = warrant := by
    exact Option.some.inj (hPostWarrant.symm.trans hWarrant)
  subst postWarrant
  exact ⟨binding, warrant, actualRuleId, hBinding, hWarrant, hConstructor,
    hContext, hProfile, hParents, hNotUsable, hUsable⟩

end ResponsibilityTopology