import ResponsibilityTopology.AdoptLicenseCurrentness

namespace ResponsibilityTopology

/-!
Reachable recording layer for canonical Adopt-license records.

This module deliberately extends the stable reachable kernel rather than editing
its existing `KernelEvent`/`Step` datatypes in place.  `AdoptState` contains the
existing `CanonicalState` unchanged plus an enriched immutable Adopt-license
lookup.  Every existing kernel step lifts verbatim.  The only new transition in
this milestone records one canonical Adopt-license object and its two-field
projection in the existing `CanonicalState.license` slot.

This is a proof-carrying record boundary, not entitlement-backed issuance.
-/

structure AdoptState where
  core : CanonicalState
  adoptLicense : ActivationLicenseId → Option CanonicalAdoptLicense

/-- Exact enriched currentness read carried by an extended state. -/
def AdoptState.toLicenseRead (A : AdoptState) : AdoptLicenseRead where
  state := A.core
  license := A.adoptLicense

/-- Immutable record-shape discipline.  No current support usability, issuer
currentness, requirement derivation, entitlement, or issuance proof is included. -/
def AdoptLicenseRecordDiscipline
    (S : CanonicalState)
    (L : CanonicalAdoptLicense) : Prop :=
  ∃ binding issuerContext targetContext,
    S.binding L.issuer.binding = some binding ∧
    S.context L.issuer.context = some issuerContext ∧
    S.context L.target.context = some targetContext ∧
    L.target.binding = L.issuer.binding ∧
    L.target.use = L.issuer.use ∧
    binding.profileDigest = L.profileDigest ∧
    binding.use = L.issuer.use ∧
    ScopeNarrowerOrEqual L.moveScope binding.scope ∧
    ∀ warrantId,
      warrantId ∈ L.support →
      ∃ warrant, S.warrant warrantId = some warrant

/-- The enriched record and the pre-existing canonical activation-license slot
must denote exactly the same issuer/target identity. -/
def AdoptLicenseProjectionCoherent (A : AdoptState) : Prop :=
  ∀ ⦃licenseId L⦄,
    A.adoptLicense licenseId = some L →
    A.core.license licenseId = some
      ({ issuer := L.issuer, target := L.target } : CanonicalActivationLicense)

/-- Every enriched reachable record satisfies the narrow canonical record
shape. -/
def AdoptLicenseWellFormed (A : AdoptState) : Prop :=
  ∀ ⦃licenseId L⦄,
    A.adoptLicense licenseId = some L →
    AdoptLicenseRecordDiscipline A.core L

structure AdoptStateInvariant (A : AdoptState) : Prop where
  coreInvariant : CanonicalStateInvariant A.core
  projectionCoherent : AdoptLicenseProjectionCoherent A
  adoptLicenseWellFormed : AdoptLicenseWellFormed A

/-- Trusted empty boundary for the extension layer. -/
def emptyAdoptState : AdoptState where
  core := emptyCanonicalState
  adoptLicense := fun _ => none

def AdoptInitialBoundary (A : AdoptState) : Prop :=
  A = emptyAdoptState

private def putActivationLicenseProjection
    (S : CanonicalState)
    (licenseId : ActivationLicenseId)
    (L : CanonicalAdoptLicense) : CanonicalState :=
  { S with
    license := putCanonical S.license licenseId
      ({ issuer := L.issuer, target := L.target } : CanonicalActivationLicense) }

private def putAdoptLicense
    (A : AdoptState)
    (licenseId : ActivationLicenseId)
    (L : CanonicalAdoptLicense) : AdoptState where
  core := putActivationLicenseProjection A.core licenseId L
  adoptLicense := putCanonical A.adoptLicense licenseId L

/-- Local copy of immutable insertion preservation; the corresponding helper in
`Reachability` is intentionally private to that module. -/
private theorem putCanonical_preserves_some_local
    {α β : Type} [DecidableEq α]
    {M : α → Option β} {key x : α} {oldValue newValue : β}
    (fresh : M key = none)
    (hOld : M x = some oldValue) :
    putCanonical M key newValue x = some oldValue := by
  by_cases hEq : x = key
  · subst x
    rw [fresh] at hOld
    cases hOld
  · simpa [putCanonical, hEq] using hOld

inductive AdoptRecordEvent where
  | core (event : KernelEvent)
  | recordAdoptLicense
      (licenseId : ActivationLicenseId)
      (license : CanonicalAdoptLicense)

/-- Existing kernel transitions lift unchanged.  The new record transition is
fresh in both projections and carries exactly the canonical record discipline. -/
inductive AdoptRecordStep : AdoptState → AdoptRecordEvent → AdoptState → Prop where
  | core
      {A : AdoptState} {event : KernelEvent} {S' : CanonicalState}
      (step : Step A.core event S') :
      AdoptRecordStep A (.core event) { core := S', adoptLicense := A.adoptLicense }
  | recordAdoptLicense
      {A : AdoptState}
      {licenseId : ActivationLicenseId}
      {L : CanonicalAdoptLicense}
      (freshEnriched : A.adoptLicense licenseId = none)
      (freshProjection : A.core.license licenseId = none)
      (discipline : AdoptLicenseRecordDiscipline A.core L) :
      AdoptRecordStep A (.recordAdoptLicense licenseId L)
        (putAdoptLicense A licenseId L)

inductive AdoptReachable : AdoptState → Prop where
  | initial {A : AdoptState} : AdoptInitialBoundary A → AdoptReachable A
  | step {A A' : AdoptState} {event : AdoptRecordEvent} :
      AdoptReachable A → AdoptRecordStep A event A' → AdoptReachable A'

/-- Recording is exact in the enriched immutable lookup. -/
theorem recordAdoptLicense_newRecord_exact
    {A A' : AdoptState}
    {licenseId : ActivationLicenseId}
    {L : CanonicalAdoptLicense}
    (hStep : AdoptRecordStep A (.recordAdoptLicense licenseId L) A') :
    A'.adoptLicense licenseId = some L := by
  cases hStep with
  | recordAdoptLicense freshEnriched freshProjection discipline =>
      simp [putAdoptLicense, putCanonical]

/-- Recording writes the exact two-field activation-license projection into the
existing canonical-state slot. -/
theorem recordAdoptLicense_projection_exact
    {A A' : AdoptState}
    {licenseId : ActivationLicenseId}
    {L : CanonicalAdoptLicense}
    (hStep : AdoptRecordStep A (.recordAdoptLicense licenseId L) A') :
    A'.core.license licenseId = some
      ({ issuer := L.issuer, target := L.target } : CanonicalActivationLicense) := by
  cases hStep with
  | recordAdoptLicense freshEnriched freshProjection discipline =>
      simp [putAdoptLicense, putActivationLicenseProjection, putCanonical]

/-- Record creation is not activation: active-context state and activation
provenance are unchanged. -/
theorem recordAdoptLicense_activationTopology_unchanged
    {A A' : AdoptState}
    {licenseId : ActivationLicenseId}
    {L : CanonicalAdoptLicense}
    (hStep : AdoptRecordStep A (.recordAdoptLicense licenseId L) A') :
    A'.core.activeContext = A.core.activeContext ∧
      A'.core.activationProvenance = A.core.activationProvenance := by
  cases hStep with
  | recordAdoptLicense freshEnriched freshProjection discipline =>
      exact ⟨rfl, rfl⟩

/-- Existing canonical historical referents remain exact when a fresh Adopt
license is recorded. -/
theorem recordAdoptLicense_historyReferentsImmutable
    {A A' : AdoptState}
    {licenseId : ActivationLicenseId}
    {L : CanonicalAdoptLicense}
    (hStep : AdoptRecordStep A (.recordAdoptLicense licenseId L) A') :
    HistoryReferentsImmutable A.core A'.core := by
  cases hStep with
  | recordAdoptLicense freshEnriched freshProjection discipline =>
      constructor
      · intro id context h; exact h
      · intro digest profile h; exact h
      · intro id binding h; exact h
      · intro id warrant h; exact h
      · intro id license h
        exact putCanonical_preserves_some_local freshProjection h

private theorem putActivationLicenseProjection_preserves_invariant
    {S : CanonicalState}
    {licenseId : ActivationLicenseId}
    {L : CanonicalAdoptLicense}
    (hInv : CanonicalStateInvariant S)
    (fresh : S.license licenseId = none) :
    CanonicalStateInvariant (putActivationLicenseProjection S licenseId L) := by
  constructor
  · exact hInv.bindingReferentsCanonical
  · exact hInv.activeContextReferentsCanonical
  · exact hInv.activeContextHasActivationProvenance
  · intro key observedId hActive hActivation
    by_cases hEq : observedId = licenseId
    · subst observedId
      rcases hInv.adoptedActiveContextHasCanonicalLicense hActive hActivation with
        ⟨oldLicense, hOld, hTarget, hIssuer⟩
      rw [fresh] at hOld
      cases hOld
    · rcases hInv.adoptedActiveContextHasCanonicalLicense hActive hActivation with
        ⟨oldLicense, hOld, hTarget, hIssuer⟩
      refine ⟨oldLicense, ?_, hTarget, hIssuer⟩
      simpa [putActivationLicenseProjection, putCanonical, hEq] using hOld
  · exact hInv.warrantReferentsCanonical
  · exact hInv.warrantParentsCanonical
  · exact hInv.rootWarrantWellFormed
  · exact hInv.warrantRootLineageCanonical
  · simpa [putActivationLicenseProjection] using hInv.inferWarrantWellFormed
  · exact hInv.evaluationReferentsCanonical
  · exact hInv.evaluationPairCoherent
  · exact hInv.evaluationProfileUseBackedByBinding
  · simpa [putActivationLicenseProjection] using hInv.transportWarrantWellFormed

private theorem discipline_preserved_by_coreStep
    {S S' : CanonicalState}
    {event : KernelEvent}
    {L : CanonicalAdoptLicense}
    (hStep : Step S event S')
    (hDiscipline : AdoptLicenseRecordDiscipline S L) :
    AdoptLicenseRecordDiscipline S' L := by
  rcases hDiscipline with
    ⟨binding, issuerContext, targetContext, hBinding, hIssuerContext,
      hTargetContext, hTargetBinding, hTargetUse, hProfile, hUse, hScope,
      hSupport⟩
  have hImmutable := step_historyReferentsImmutable hStep
  refine ⟨binding, issuerContext, targetContext,
    hImmutable.bindingImmutable hBinding,
    hImmutable.contextImmutable hIssuerContext,
    hImmutable.contextImmutable hTargetContext,
    hTargetBinding, hTargetUse, hProfile, hUse, hScope, ?_⟩
  intro warrantId hMem
  rcases hSupport warrantId hMem with ⟨warrant, hWarrant⟩
  exact ⟨warrant, hImmutable.warrantImmutable hWarrant⟩

/-- The extension invariant is preserved by every lifted core step and by fresh
canonical Adopt-license recording. -/
theorem adoptRecordStep_preserves_invariant
    {A A' : AdoptState} {event : AdoptRecordEvent}
    (hInv : AdoptStateInvariant A)
    (hStep : AdoptRecordStep A event A') :
    AdoptStateInvariant A' := by
  cases hStep with
  | @core event S' step =>
      constructor
      · exact step_preserves_invariant hInv.coreInvariant step
      · intro licenseId L hLookup
        have hOldProjection := hInv.projectionCoherent hLookup
        exact (step_historyReferentsImmutable step).licenseImmutable hOldProjection
      · intro licenseId L hLookup
        exact discipline_preserved_by_coreStep step
          (hInv.adoptLicenseWellFormed hLookup)
  | @recordAdoptLicense licenseId L freshEnriched freshProjection discipline =>
      constructor
      · exact putActivationLicenseProjection_preserves_invariant
          hInv.coreInvariant freshProjection
      · intro observedId observed hLookup
        by_cases hEq : observedId = licenseId
        · subst observedId
          have hObservedEq : observed = L := by
            simpa [putAdoptLicense, putCanonical] using hLookup.symm
          subst observed
          simp [putAdoptLicense, putActivationLicenseProjection, putCanonical]
        · have hOld : A.adoptLicense observedId = some observed := by
            simpa [putAdoptLicense, putCanonical, hEq] using hLookup
          have hProjection := hInv.projectionCoherent hOld
          simpa [putAdoptLicense, putActivationLicenseProjection, putCanonical, hEq]
            using hProjection
      · intro observedId observed hLookup
        by_cases hEq : observedId = licenseId
        · subst observedId
          have hObservedEq : observed = L := by
            simpa [putAdoptLicense, putCanonical] using hLookup.symm
          subst observed
          exact discipline
        · have hOld : A.adoptLicense observedId = some observed := by
            simpa [putAdoptLicense, putCanonical, hEq] using hLookup
          exact hInv.adoptLicenseWellFormed hOld

/-- Empty extended state satisfies the combined invariant. -/
theorem adoptInitialBoundary_invariant
    {A : AdoptState}
    (hInitial : AdoptInitialBoundary A) :
    AdoptStateInvariant A := by
  subst A
  constructor
  · exact initialBoundary_invariant (by rfl)
  · intro licenseId L hLookup
    simp [emptyAdoptState] at hLookup
  · intro licenseId L hLookup
    simp [emptyAdoptState] at hLookup

/-- Every state reachable through the activation-extension layer satisfies both
the stable core invariant and enriched Adopt-record well-formedness. -/
theorem adoptReachable_invariant
    {A : AdoptState}
    (hReachable : AdoptReachable A) :
    AdoptStateInvariant A := by
  induction hReachable with
  | initial hInitial => exact adoptInitialBoundary_invariant hInitial
  | step hReachable hStep ih => exact adoptRecordStep_preserves_invariant ih hStep

/-- Reachable enriched Adopt records always recover their canonical record
shape. -/
theorem reachable_adoptLicensesWellFormed
    {A : AdoptState}
    (hReachable : AdoptReachable A) :
    AdoptLicenseWellFormed A :=
  (adoptReachable_invariant hReachable).adoptLicenseWellFormed

end ResponsibilityTopology
