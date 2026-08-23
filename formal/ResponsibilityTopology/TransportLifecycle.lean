import ResponsibilityTopology.TransportQualification

namespace ResponsibilityTopology

/-!
Adjacent TRANSPORT formation/qualification separation.

The theorem below is deliberately a witnessed two-step boundary.  It does not
quantify over arbitrary intervening transitions, does not require source or
target contexts to be active, and does not identify the original, witness, and
target formation contexts.
-/

/-- T3: a reachable TRANSPORT formation creates an exact target-context
historical object without current child usability.  The immediately following
qualification requires the stored original and bridge-witness identities to be
currently usable at their own historical formation contexts, then establishes
current usability of the transported child at the target-context key. -/
theorem transportFormationQualification_boundary
    {S₀ S₁ S₂ : CanonicalState}
    {warrantId formationOriginalId formationWitnessId : WarrantId}
    {formationBindingId formationTargetContextId formationMapId : String}
    {translatedClaim : Claim}
    {outScope : Scope}
    {qualificationBindingId qualificationTargetContextId use : String}
    {metadata : QualificationMetadata}
    (hReachable : Reachable S₀)
    (hFormation :
      Step S₀
        (.transport warrantId formationBindingId formationTargetContextId
          formationMapId formationOriginalId formationWitnessId translatedClaim
          outScope)
        S₁)
    (hQualification :
      Step S₁
        (.qualifyTransport warrantId qualificationBindingId
          qualificationTargetContextId use metadata)
        S₂) :
    ∃ formationBinding qualificationBinding warrant
        originalId witnessId original witness,
      S₀.binding formationBindingId = some formationBinding ∧
      S₁.binding qualificationBindingId = some qualificationBinding ∧
      S₁.warrant warrantId = some warrant ∧
      warrant = transportHistoricalWarrant
        formationMapId formationBinding.profileDigest formationTargetContextId
        formationOriginalId formationWitnessId
        (match S₀.warrant formationOriginalId with
          | some original => original
          | none => original)
        (match S₀.warrant formationWitnessId with
          | some bridgeWitness => bridgeWitness
          | none => witness)
        translatedClaim outScope ∧
      warrant.parents = [originalId, witnessId] ∧
      S₁.warrant originalId = some original ∧
      S₁.warrant witnessId = some witness ∧
      warrant.formationProfileDigest = qualificationBinding.profileDigest ∧
      warrant.formationContext = qualificationTargetContextId ∧
      Usable S₁
        ⟨qualificationBinding.profileDigest, original.formationContext,
          use, originalId⟩ ∧
      Usable S₁
        ⟨qualificationBinding.profileDigest, witness.formationContext,
          use, witnessId⟩ ∧
      ¬ Usable S₁
        ⟨qualificationBinding.profileDigest, qualificationTargetContextId,
          use, warrantId⟩ ∧
      Usable S₂
        ⟨qualificationBinding.profileDigest, qualificationTargetContextId,
          use, warrantId⟩ := by
  rcases transportStep_newWarrant_exact hFormation with
    ⟨formationBinding, formationContext, formationOriginal, formationWitness,
      hFormationBinding, hFormationContext, hFormationOriginal,
      hFormationWitness, hFormationDiscipline, hFormationChild⟩
  rcases qualifyTransport_requires_sourceCurrent hQualification with
    ⟨qualificationBinding, qualificationWarrant, qualificationMapId,
      originalId, witnessId, original, witness,
      hQualificationBinding, hQualificationWarrant, hConstructor, hParents,
      hOriginal, hWitness, hTargetContext, hProfile, hSourceCurrent⟩
  have hWarrantEq : qualificationWarrant =
      transportHistoricalWarrant formationMapId formationBinding.profileDigest
        formationTargetContextId formationOriginalId formationWitnessId
        formationOriginal formationWitness translatedClaim outScope := by
    exact Option.some.inj (hQualificationWarrant.symm.trans hFormationChild)
  subst qualificationWarrant
  have hNotUsable := transportStep_newWarrant_notUsable
    hReachable hFormation qualificationBinding.profileDigest
      qualificationTargetContextId use
  rcases qualifyTransport_makes_usable hQualification with
    ⟨postBinding, hPostBinding, hPostUsable⟩
  have hPostBindingEq : postBinding = qualificationBinding := by
    exact Option.some.inj (hPostBinding.symm.trans hQualificationBinding)
  subst postBinding
  refine ⟨formationBinding, qualificationBinding,
    transportHistoricalWarrant formationMapId formationBinding.profileDigest
      formationTargetContextId formationOriginalId formationWitnessId
      formationOriginal formationWitness translatedClaim outScope,
    originalId, witnessId, original, witness,
    hFormationBinding, hQualificationBinding, hFormationChild, ?_, hParents,
    hOriginal, hWitness, hProfile, hTargetContext,
    hSourceCurrent.1, hSourceCurrent.2, hNotUsable, hPostUsable⟩
  simp [hFormationOriginal, hFormationWitness]

/-- The adjacent boundary exposes three independently stored context coordinates:
the target child context and the two parent formation contexts.  No equality
between them is required by the theorem. -/
theorem transportQualification_context_coordinates
    {S S' : CanonicalState}
    {warrantId : WarrantId}
    {bindingId targetContextId use : String}
    {metadata : QualificationMetadata}
    (hStep : Step S
      (.qualifyTransport warrantId bindingId targetContextId use metadata) S') :
    ∃ binding originalId witnessId original witness,
      S.binding bindingId = some binding ∧
      Usable S
        ⟨binding.profileDigest, original.formationContext, use, originalId⟩ ∧
      Usable S
        ⟨binding.profileDigest, witness.formationContext, use, witnessId⟩ ∧
      Usable S'
        ⟨binding.profileDigest, targetContextId, use, warrantId⟩ := by
  rcases qualifyTransport_sourceContexts_exact hStep with
    ⟨binding, originalId, witnessId, original, witness,
      hBinding, hOriginal, hWitness, hOriginalUsable, hWitnessUsable⟩
  rcases qualifyTransport_makes_usable hStep with
    ⟨postBinding, hPostBinding, hChildUsable⟩
  have hEq : postBinding = binding := by
    exact Option.some.inj (hPostBinding.symm.trans hBinding)
  subst postBinding
  exact ⟨binding, originalId, witnessId, original, witness,
    hBinding, hOriginalUsable, hWitnessUsable, hChildUsable⟩

end ResponsibilityTopology
