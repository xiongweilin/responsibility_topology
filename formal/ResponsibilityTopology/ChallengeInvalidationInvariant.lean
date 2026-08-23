import ResponsibilityTopology.ChallengeInvalidation

namespace ResponsibilityTopology

/-!
Invariant preservation for the challenge invalidation phase.

Challenge changes values already present on the mutable evaluation axes and
monotonically adds review-required facts.  It does not create or remove canonical
history, activation topology, enriched license records, or evaluation-record
presence.  These facts let the pre-challenge shared invariant survive exactly,
even though current usability and Adopt-license BaseCurrent need not survive.
-/

/-- Epistemic invalidation changes values but never creates or removes an option
position. -/
theorem challengeEpi_none_iff
    (S : CanonicalState)
    (profileDigest use : String)
    (targetId : WarrantId)
    (key : EvalKey) :
    challengeEpi S profileDigest use targetId key = none ↔
      S.epi key = none := by
  classical
  by_cases hAffected : ChallengeEvalAffected S profileDigest use targetId key
  · cases hEpi : S.epi key with
    | none => simp [challengeEpi, hAffected, hEpi]
    | some status =>
        cases status <;> simp [challengeEpi, hAffected, hEpi]
  · simp [challengeEpi, hAffected]

/-- Placement invalidation changes values but never creates or removes an option
position. -/
theorem challengePlacement_none_iff
    (S : CanonicalState)
    (profileDigest use : String)
    (targetId : WarrantId)
    (key : EvalKey) :
    challengePlacement S profileDigest use targetId key = none ↔
      S.placement key = none := by
  classical
  by_cases hAffected :
      ChallengePlacementAffected S profileDigest use targetId key
  · cases hPlacement : S.placement key with
    | none => simp [challengePlacement, hAffected, hPlacement]
    | some placement =>
        cases placement <;> simp [challengePlacement, hAffected, hPlacement]
  · simp [challengePlacement, hAffected]

/-- Equivalent existential spelling used by the evaluation-record invariant. -/
theorem challengeEpi_some_iff
    (S : CanonicalState)
    (profileDigest use : String)
    (targetId : WarrantId)
    (key : EvalKey) :
    (∃ status, challengeEpi S profileDigest use targetId key = some status) ↔
      ∃ status, S.epi key = some status := by
  classical
  by_cases hAffected : ChallengeEvalAffected S profileDigest use targetId key
  · cases hEpi : S.epi key with
    | none => simp [challengeEpi, hAffected, hEpi]
    | some status =>
        cases status <;> simp [challengeEpi, hAffected, hEpi]
  · simp [challengeEpi, hAffected]

/-- Equivalent existential spelling for placement-record presence. -/
theorem challengePlacement_some_iff
    (S : CanonicalState)
    (profileDigest use : String)
    (targetId : WarrantId)
    (key : EvalKey) :
    (∃ placement,
        challengePlacement S profileDigest use targetId key = some placement) ↔
      ∃ placement, S.placement key = some placement := by
  classical
  by_cases hAffected :
      ChallengePlacementAffected S profileDigest use targetId key
  · cases hPlacement : S.placement key with
    | none => simp [challengePlacement, hAffected, hPlacement]
    | some placement =>
        cases placement <;> simp [challengePlacement, hAffected, hPlacement]
  · simp [challengePlacement, hAffected]

/-- The two-dimensional evaluation topology is preserved exactly: challenge
changes status values at existing keys but not which keys have records. -/
theorem challengeInvalidate_hasEvaluationRecord_iff
    (A : AdoptState)
    (profileDigest use : String)
    (targetId : WarrantId)
    (key : EvalKey) :
    HasEvaluationRecord
        (challengeInvalidate A profileDigest use targetId).core key ↔
      HasEvaluationRecord A.core key := by
  classical
  change
    ((∃ status,
        challengeEpi A.core profileDigest use targetId key = some status) ∨
      ∃ placement,
        challengePlacement A.core profileDigest use targetId key = some placement) ↔
    ((∃ status, A.core.epi key = some status) ∨
      ∃ placement, A.core.placement key = some placement)
  rw [challengeEpi_some_iff, challengePlacement_some_iff]

private theorem challengeInvalidate_preserves_recordDiscipline
    {A : AdoptState}
    {profileDigest use : String}
    {targetId : WarrantId}
    {L : CanonicalAdoptLicense}
    (h : AdoptLicenseRecordDiscipline A.core L) :
    AdoptLicenseRecordDiscipline
      (challengeInvalidate A profileDigest use targetId).core L := by
  rcases h with
    ⟨binding, issuerContext, targetContext, hBinding, hIssuerContext,
      hTargetContext, hTargetBinding, hTargetUse, hProfile, hUse,
      hScope, hSupport⟩
  refine ⟨binding, issuerContext, targetContext, ?_, ?_, ?_,
    hTargetBinding, hTargetUse, hProfile, hUse, hScope, ?_⟩
  · simpa [challengeInvalidate] using hBinding
  · simpa [challengeInvalidate] using hIssuerContext
  · simpa [challengeInvalidate] using hTargetContext
  · intro warrantId hMem
    rcases hSupport warrantId hMem with ⟨warrant, hWarrant⟩
    exact ⟨warrant, by simpa [challengeInvalidate] using hWarrant⟩

/-- The shared canonical/adopt-record invariant survives challenge invalidation.
This theorem intentionally does not say that usability or BaseCurrent survives. -/
theorem challengeInvalidate_preserves_invariant
    {A : AdoptState}
    {profileDigest use : String}
    {targetId : WarrantId}
    (hInv : AdoptStateInvariant A) :
    AdoptStateInvariant (challengeInvalidate A profileDigest use targetId) := by
  classical
  constructor
  · constructor
    · intro bindingId binding hBinding
      have hPre : A.core.binding bindingId = some binding := by
        simpa [challengeInvalidate] using hBinding
      rcases hInv.coreInvariant.bindingReferentsCanonical hPre with
        ⟨profile, hProfile⟩
      exact ⟨profile, by simpa [challengeInvalidate] using hProfile⟩
    · intro key hActive
      have hPre : A.core.activeContext key := by
        simpa [challengeInvalidate] using hActive
      rcases hInv.coreInvariant.activeContextReferentsCanonical hPre with
        ⟨hContext, binding, hBinding, hUse⟩
      rcases hContext with ⟨context, hContext⟩
      exact ⟨
        ⟨context, by simpa [challengeInvalidate] using hContext⟩,
        binding,
        by simpa [challengeInvalidate] using hBinding,
        hUse
      ⟩
    · intro key hActive
      have hPre : A.core.activeContext key := by
        simpa [challengeInvalidate] using hActive
      rcases hInv.coreInvariant.activeContextHasActivationProvenance hPre with
        ⟨activation, hActivation⟩
      exact ⟨activation, by simpa [challengeInvalidate] using hActivation⟩
    · intro key licenseId hActive hActivation
      have hPreActive : A.core.activeContext key := by
        simpa [challengeInvalidate] using hActive
      have hPreActivation :
          A.core.activationProvenance key = some (Activation.adopt licenseId) := by
        simpa [challengeInvalidate] using hActivation
      rcases hInv.coreInvariant.adoptedActiveContextHasCanonicalLicense
          hPreActive hPreActivation with
        ⟨license, hLicense, hTarget, hIssuer⟩
      refine ⟨license, by simpa [challengeInvalidate] using hLicense,
        hTarget, ?_⟩
      rcases hIssuer with ⟨hContext, binding, hBinding, hUse⟩
      rcases hContext with ⟨context, hContext⟩
      exact ⟨
        ⟨context, by simpa [challengeInvalidate] using hContext⟩,
        binding,
        by simpa [challengeInvalidate] using hBinding,
        hUse
      ⟩
    · intro warrantId warrant hWarrant
      have hPre : A.core.warrant warrantId = some warrant := by
        simpa [challengeInvalidate] using hWarrant
      rcases hInv.coreInvariant.warrantReferentsCanonical hPre with
        ⟨context, hContext, profile, hProfile⟩
      exact ⟨
        context, by simpa [challengeInvalidate] using hContext,
        profile, by simpa [challengeInvalidate] using hProfile
      ⟩
    · intro warrantId warrant parentId hWarrant hParent
      have hPre : A.core.warrant warrantId = some warrant := by
        simpa [challengeInvalidate] using hWarrant
      rcases hInv.coreInvariant.warrantParentsCanonical hPre hParent with
        ⟨parent, hLookup⟩
      exact ⟨parent, by simpa [challengeInvalidate] using hLookup⟩
    · intro warrantId warrant hWarrant hRoot
      have hPre : A.core.warrant warrantId = some warrant := by
        simpa [challengeInvalidate] using hWarrant
      exact hInv.coreInvariant.rootWarrantWellFormed hPre hRoot
    · intro warrantId warrant role rootId hWarrant hLineage
      have hPre : A.core.warrant warrantId = some warrant := by
        simpa [challengeInvalidate] using hWarrant
      rcases hInv.coreInvariant.warrantRootLineageCanonical hPre hLineage with
        ⟨root, hRoot⟩
      exact ⟨root, by simpa [challengeInvalidate] using hRoot⟩
    · intro warrantId warrant ruleId hWarrant hConstructor
      have hPre : A.core.warrant warrantId = some warrant := by
        simpa [challengeInvalidate] using hWarrant
      rcases hInv.coreInvariant.inferWarrantWellFormed hPre hConstructor with
        ⟨profile, context, rule, parents, hProfile, hContext, hRule,
          hParents, hFormation, hExact⟩
      refine ⟨profile, context, rule, parents,
        by simpa [challengeInvalidate] using hProfile,
        by simpa [challengeInvalidate] using hContext,
        hRule, ?_, hFormation, hExact⟩
      exact hParents.preserved (by
        intro parentId parent hLookup
        simpa [challengeInvalidate] using hLookup)
    · intro key hRecord
      have hPreRecord : HasEvaluationRecord A.core key :=
        (challengeInvalidate_hasEvaluationRecord_iff
          A profileDigest use targetId key).mp hRecord
      rcases hInv.coreInvariant.evaluationReferentsCanonical hPreRecord with
        ⟨warrant, hWarrant, hProfile, hContext⟩
      exact ⟨warrant, by simpa [challengeInvalidate] using hWarrant,
        hProfile, hContext⟩
    · intro key
      have hEpi := challengeEpi_none_iff A.core profileDigest use targetId key
      have hPlacement :=
        challengePlacement_none_iff A.core profileDigest use targetId key
      change
        challengeEpi A.core profileDigest use targetId key = none ↔
          challengePlacement A.core profileDigest use targetId key = none
      exact hEpi.trans
        ((hInv.coreInvariant.evaluationPairCoherent key).trans hPlacement.symm)
    · intro key hRecord
      have hPreRecord : HasEvaluationRecord A.core key :=
        (challengeInvalidate_hasEvaluationRecord_iff
          A profileDigest use targetId key).mp hRecord
      rcases hInv.coreInvariant.evaluationProfileUseBackedByBinding hPreRecord with
        ⟨bindingId, binding, hBinding, hProfile, hUse⟩
      exact ⟨bindingId, binding,
        by simpa [challengeInvalidate] using hBinding, hProfile, hUse⟩
    · intro warrantId warrant mapId hWarrant hConstructor
      have hPre : A.core.warrant warrantId = some warrant := by
        simpa [challengeInvalidate] using hWarrant
      rcases hInv.coreInvariant.transportWarrantWellFormed hPre hConstructor with
        ⟨targetContext, originalId, witnessId, original, witness,
          hContext, hOriginal, hWitness, hFormation, hExact⟩
      exact ⟨targetContext, originalId, witnessId, original, witness,
        by simpa [challengeInvalidate] using hContext,
        by simpa [challengeInvalidate] using hOriginal,
        by simpa [challengeInvalidate] using hWitness,
        hFormation, hExact⟩
  · intro licenseId L hLookup
    have hPre : A.adoptLicense licenseId = some L := by
      simpa [challengeInvalidate] using hLookup
    have hProjection := hInv.projectionCoherent hPre
    simpa [challengeInvalidate] using hProjection
  · intro licenseId L hLookup
    have hPre : A.adoptLicense licenseId = some L := by
      simpa [challengeInvalidate] using hLookup
    exact challengeInvalidate_preserves_recordDiscipline
      (hInv.adoptLicenseWellFormed hPre)

/-- Both prior activation steps and challenge invalidation preserve the shared
canonical/adopt-record invariant. -/
theorem challengeStep_preserves_invariant
    {A A' : AdoptState}
    {event : ChallengeEvent}
    (hInv : AdoptStateInvariant A)
    (hStep : ChallengeStep A event A') :
    AdoptStateInvariant A' := by
  cases hStep with
  | prior step =>
      exact adoptActivationStep_preserves_invariant hInv step
  | challenge bindingCanonical contextCanonical challengerCanonical
      bridgeCanonical targetCanonical challengerUsable bridgeUsable bridgeRole
      bridgeClaimExact =>
      exact challengeInvalidate_preserves_invariant hInv

/-- Every state reachable through the challenge layer retains canonical history,
record topology, and enriched Adopt-record well-formedness. -/
theorem challengeReachable_invariant
    {A : AdoptState}
    (hReachable : ChallengeReachable A) :
    AdoptStateInvariant A := by
  induction hReachable with
  | initial hInitial =>
      exact adoptInitialBoundary_invariant hInitial
  | step hReachable hStep ih =>
      exact challengeStep_preserves_invariant ih hStep

end ResponsibilityTopology
