import ResponsibilityTopology.AdoptReachability

namespace ResponsibilityTopology

/-!
Reachable Adopt context activation.

This layer extends the record-only activation kernel with one explicit Adopt
transition.  The transition consumes an exact enriched historical license,
state-backed non-recursive license currentness, and grounded currentness of the
issuing context.  It writes only active-context membership and immutable Adopt
activation provenance.

Post-state grounded closure is proved separately in the next research stage.
-/

private def addActiveFact
    (P : ContextKey → Prop)
    (key : ContextKey) : ContextKey → Prop :=
  fun observed => observed = key ∨ P observed

private def activateWithAdopt
    (A : AdoptState)
    (licenseId : ActivationLicenseId)
    (target : ContextKey) : AdoptState where
  core :=
    { A.core with
      activeContext := addActiveFact A.core.activeContext target
      activationProvenance :=
        putCanonical A.core.activationProvenance target
          (Activation.adopt licenseId) }
  adoptLicense := A.adoptLicense

inductive AdoptActivationEvent where
  | prior (event : AdoptRecordEvent)
  | adoptContext
      (licenseId : ActivationLicenseId)
      (target : ContextKey)

/-- The Adopt transition does not replay issuance.  It consumes the exact stored
record, its current non-recursive state conditions, and a grounded issuer. -/
inductive AdoptActivationStep :
    AdoptState → AdoptActivationEvent → AdoptState → Prop where
  | prior
      {A A' : AdoptState} {event : AdoptRecordEvent}
      (step : AdoptRecordStep A event A') :
      AdoptActivationStep A (.prior event) A'
  | adoptContext
      {A : AdoptState}
      {licenseId : ActivationLicenseId}
      {target : ContextKey}
      {L : CanonicalAdoptLicense}
      (licenseCanonical : A.adoptLicense licenseId = some L)
      (targetExact : L.target = target)
      (baseCurrent : AdoptLicenseBaseCurrent A.core licenseId L)
      (issuerGrounded :
        Grounded A.toLicenseRead.toActivationRead L.issuer)
      (inactive : ¬ A.core.activeContext target)
      (freshActivation : A.core.activationProvenance target = none) :
      AdoptActivationStep A (.adoptContext licenseId target)
        (activateWithAdopt A licenseId target)

inductive AdoptActivationReachable : AdoptState → Prop where
  | initial {A : AdoptState} : AdoptInitialBoundary A → AdoptActivationReachable A
  | step {A A' : AdoptState} {event : AdoptActivationEvent} :
      AdoptActivationReachable A →
      AdoptActivationStep A event A' →
      AdoptActivationReachable A'

/-- Every state reachable in the record-only layer embeds into the activation
layer without changing any state. -/
theorem adoptReachable_to_activationReachable
    {A : AdoptState}
    (hReachable : AdoptReachable A) :
    AdoptActivationReachable A := by
  induction hReachable with
  | initial hInitial => exact .initial hInitial
  | step hReachable hStep ih =>
      exact .step ih (.prior hStep)

/-- Constructor inversion: an Adopt transition consumes a fully current license
in the #38 sense, with currentness decomposed into BaseCurrent plus grounded
issuer. -/
theorem adoptContext_requires_currentLicense
    {A A' : AdoptState}
    {licenseId : ActivationLicenseId}
    {target : ContextKey}
    (hStep : AdoptActivationStep A (.adoptContext licenseId target) A') :
    AdoptLicenseCurrent A.toLicenseRead licenseId := by
  cases hStep with
  | adoptContext licenseCanonical targetExact baseCurrent issuerGrounded
      inactive freshActivation =>
      exact ⟨_, licenseCanonical, baseCurrent, issuerGrounded⟩

/-- Adopt activates exactly the selected target and records exact Adopt
provenance. -/
theorem adoptContext_activation_exact
    {A A' : AdoptState}
    {licenseId : ActivationLicenseId}
    {target : ContextKey}
    (hStep : AdoptActivationStep A (.adoptContext licenseId target) A') :
    A'.core.activeContext target ∧
      A'.core.activationProvenance target =
        some (Activation.adopt licenseId) := by
  cases hStep with
  | adoptContext licenseCanonical targetExact baseCurrent issuerGrounded
      inactive freshActivation =>
      constructor
      · exact Or.inl rfl
      · simp [activateWithAdopt, putCanonical]

/-- Adopt changes no canonical context/profile/binding/warrant/license referent. -/
theorem adoptContext_historyReferentsImmutable
    {A A' : AdoptState}
    {licenseId : ActivationLicenseId}
    {target : ContextKey}
    (hStep : AdoptActivationStep A (.adoptContext licenseId target) A') :
    HistoryReferentsImmutable A.core A'.core := by
  cases hStep with
  | adoptContext licenseCanonical targetExact baseCurrent issuerGrounded
      inactive freshActivation =>
      constructor <;> intro <;> intro <;> intro h <;> exact h

/-- Adopt does not qualify or invalidate warrants. -/
theorem adoptContext_evaluationTopology_unchanged
    {A A' : AdoptState}
    {licenseId : ActivationLicenseId}
    {target : ContextKey}
    (hStep : AdoptActivationStep A (.adoptContext licenseId target) A') :
    A'.core.epi = A.core.epi ∧
      A'.core.placement = A.core.placement := by
  cases hStep with
  | adoptContext licenseCanonical targetExact baseCurrent issuerGrounded
      inactive freshActivation =>
      exact ⟨rfl, rfl⟩

private theorem contextKeyCanonical_of_recordDiscipline_issuer
    {S : CanonicalState}
    {L : CanonicalAdoptLicense}
    (h : AdoptLicenseRecordDiscipline S L) :
    ContextKeyCanonical S L.issuer := by
  rcases h with
    ⟨binding, issuerContext, targetContext, hBinding, hIssuerContext,
      hTargetContext, hTargetBinding, hTargetUse, hProfile, hUse,
      hScope, hSupport⟩
  exact ⟨⟨issuerContext, hIssuerContext⟩, binding, hBinding, hUse⟩

private theorem contextKeyCanonical_of_recordDiscipline_target
    {S : CanonicalState}
    {L : CanonicalAdoptLicense}
    (h : AdoptLicenseRecordDiscipline S L) :
    ContextKeyCanonical S L.target := by
  rcases h with
    ⟨binding, issuerContext, targetContext, hBinding, hIssuerContext,
      hTargetContext, hTargetBinding, hTargetUse, hProfile, hUse,
      hScope, hSupport⟩
  refine ⟨⟨targetContext, hTargetContext⟩, binding, ?_, ?_⟩
  · rw [hTargetBinding]
    exact hBinding
  · exact hUse.trans hTargetUse.symm

private theorem activationOnly_preserves_coreInvariant
    {A : AdoptState}
    {licenseId : ActivationLicenseId}
    {target : ContextKey}
    {L : CanonicalAdoptLicense}
    (hInv : AdoptStateInvariant A)
    (hLicense : A.adoptLicense licenseId = some L)
    (hTarget : L.target = target)
    (hInactive : ¬ A.core.activeContext target)
    (hFresh : A.core.activationProvenance target = none) :
    CanonicalStateInvariant (activateWithAdopt A licenseId target).core := by
  have hDiscipline := hInv.adoptLicenseWellFormed hLicense
  have hIssuerCanonical :=
    contextKeyCanonical_of_recordDiscipline_issuer hDiscipline
  have hTargetCanonicalL :=
    contextKeyCanonical_of_recordDiscipline_target hDiscipline
  have hTargetCanonical : ContextKeyCanonical A.core target := by
    simpa [hTarget] using hTargetCanonicalL
  have hProjection := hInv.projectionCoherent hLicense
  constructor
  · exact hInv.coreInvariant.bindingReferentsCanonical
  · intro key hActive
    rcases hActive with hEq | hOld
    · subst key
      exact hTargetCanonical
    · exact hInv.coreInvariant.activeContextReferentsCanonical hOld
  · intro key hActive
    rcases hActive with hEq | hOld
    · subst key
      exact ⟨Activation.adopt licenseId, by
        simp [activateWithAdopt, putCanonical]⟩
    · rcases hInv.coreInvariant.activeContextHasActivationProvenance hOld with
        ⟨activation, hLookup⟩
      have hNe : key ≠ target := by
        intro hEq
        subst key
        exact hInactive hOld
      exact ⟨activation, by
        simpa [activateWithAdopt, putCanonical, hNe] using hLookup⟩
  · intro key observedId hActive hActivation
    rcases hActive with hEq | hOld
    · subst key
      have hExact :
          (activateWithAdopt A licenseId target).core.activationProvenance target =
            some (Activation.adopt licenseId) := by
        simp [activateWithAdopt, putCanonical]
      have hActivationEq :
          Activation.adopt licenseId = Activation.adopt observedId :=
        Option.some.inj (hExact.symm.trans hActivation)
      have hIdEq : licenseId = observedId := Activation.adopt.inj hActivationEq
      subst observedId
      refine ⟨
        ({ issuer := L.issuer, target := L.target } : CanonicalActivationLicense),
        ?_, hTarget, hIssuerCanonical⟩
      exact hProjection
    · have hNe : key ≠ target := by
        intro hEq
        subst key
        exact hInactive hOld
      have hOldActivation :
          A.core.activationProvenance key = some (Activation.adopt observedId) := by
        simpa [activateWithAdopt, putCanonical, hNe] using hActivation
      exact hInv.coreInvariant.adoptedActiveContextHasCanonicalLicense
        hOld hOldActivation
  · exact hInv.coreInvariant.warrantReferentsCanonical
  · exact hInv.coreInvariant.warrantParentsCanonical
  · exact hInv.coreInvariant.rootWarrantWellFormed
  · exact hInv.coreInvariant.warrantRootLineageCanonical
  · intro warrantId warrant ruleId hWarrant hConstructor
    rcases hInv.coreInvariant.inferWarrantWellFormed hWarrant hConstructor with
      ⟨profile, context, rule, parents, hProfile, hContext, hRule,
        hParents, hFormation, hExact⟩
    exact ⟨profile, context, rule, parents, hProfile, hContext, hRule,
      hParents.preserved (by intro parentId parent hLookup; exact hLookup),
      hFormation, hExact⟩
  · exact hInv.coreInvariant.evaluationReferentsCanonical
  · exact hInv.coreInvariant.evaluationPairCoherent
  · exact hInv.coreInvariant.evaluationProfileUseBackedByBinding
  · intro warrantId warrant mapId hWarrant hConstructor
    rcases hInv.coreInvariant.transportWarrantWellFormed hWarrant hConstructor with
      ⟨targetContext, originalId, witnessId, original, witness,
        hContext, hOriginal, hWitness, hFormation, hExact⟩
    exact ⟨targetContext, originalId, witnessId, original, witness,
      hContext, hOriginal, hWitness, hFormation, hExact⟩

private theorem recordDiscipline_preserved_by_activation
    {A : AdoptState}
    {licenseId : ActivationLicenseId}
    {target : ContextKey}
    {L : CanonicalAdoptLicense}
    (h : AdoptLicenseRecordDiscipline A.core L) :
    AdoptLicenseRecordDiscipline
      (activateWithAdopt A licenseId target).core L := by
  exact h

/-- The combined extension invariant is preserved by prior record/core steps and
by explicit Adopt activation. -/
theorem adoptActivationStep_preserves_invariant
    {A A' : AdoptState} {event : AdoptActivationEvent}
    (hInv : AdoptStateInvariant A)
    (hStep : AdoptActivationStep A event A') :
    AdoptStateInvariant A' := by
  cases hStep with
  | prior step =>
      exact adoptRecordStep_preserves_invariant hInv step
  | @adoptContext licenseId target L licenseCanonical targetExact baseCurrent
      issuerGrounded inactive freshActivation =>
      constructor
      · exact activationOnly_preserves_coreInvariant hInv licenseCanonical
          targetExact inactive freshActivation
      · intro observedId observed hLookup
        exact hInv.projectionCoherent hLookup
      · intro observedId observed hLookup
        exact recordDiscipline_preserved_by_activation
          (hInv.adoptLicenseWellFormed hLookup)

/-- Every activation-reachable state preserves the combined canonical-record
invariant. -/
theorem adoptActivationReachable_invariant
    {A : AdoptState}
    (hReachable : AdoptActivationReachable A) :
    AdoptStateInvariant A := by
  induction hReachable with
  | initial hInitial => exact adoptInitialBoundary_invariant hInitial
  | step hReachable hStep ih =>
      exact adoptActivationStep_preserves_invariant ih hStep

end ResponsibilityTopology
