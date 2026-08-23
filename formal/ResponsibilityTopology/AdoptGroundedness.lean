import ResponsibilityTopology.AdoptActivation

namespace ResponsibilityTopology

/-!
Reachable grounded currentness for context activation.

The central result connects the reachable activation relation to the previously
orthogonal semantic `Grounded` relation. Under the current transition surface,
base-currentness is monotone: core steps may add canonical history or make an
evaluation usable, but there is not yet a review/invalidation transition that can
make a previously base-current Adopt license stale. This monotonicity is a
property of the current kernel surface, not a temporal-persistence claim once
challenge/revalidation is added.
-/

private theorem putCanonical_preserves_some_grounded
    {α β : Type} [DecidableEq α]
    {M : α → Option β} {inserted key : α} {oldValue newValue : β}
    (fresh : M inserted = none)
    (hOld : M key = some oldValue) :
    putCanonical M inserted newValue key = some oldValue := by
  by_cases hEq : key = inserted
  · subst key
    rw [fresh] at hOld
    cases hOld
  · simpa [putCanonical, hEq] using hOld

/-- Qualification can only make an evaluation key usable; it never destroys
pre-existing usability. -/
private theorem qualifyEvaluation_preserves_usable
    (S : CanonicalState)
    (selected key : EvalKey)
    (hUsable : Usable S key) :
    Usable (qualifyEvaluation S selected) key := by
  by_cases hEq : key = selected
  · subst key
    exact qualifyEvaluation_exact S selected
  · rcases hUsable with ⟨hEpi, hPlacement⟩
    exact ⟨
      by simpa [qualifyEvaluation, setOptionAt, hEq] using hEpi,
      by simpa [qualifyEvaluation, setOptionAt, hEq] using hPlacement⟩

/-- Every current core transition preserves existing usability. This relies on
the present absence of evaluation-invalidation transitions. -/
theorem coreStep_preserves_usable
    {S S' : CanonicalState}
    {event : KernelEvent}
    {key : EvalKey}
    (hStep : Step S event S')
    (hUsable : Usable S key) :
    Usable S' key := by
  cases hStep <;>
    first
    | exact hUsable
    | exact qualifyEvaluation_preserves_usable _ _ _ hUsable

/-- Current core transitions do not modify Adopt-license review flags. -/
theorem coreStep_reviewRequired_unchanged
    {S S' : CanonicalState}
    {event : KernelEvent}
    (hStep : Step S event S') :
    S'.reviewRequired = S.reviewRequired := by
  cases hStep <;> rfl

/-- Existing active contexts remain active across every current core step. -/
theorem coreStep_active_monotone
    {S S' : CanonicalState}
    {event : KernelEvent}
    {key : ContextKey}
    (hStep : Step S event S')
    (hActive : S.activeContext key) :
    S'.activeContext key := by
  cases hStep <;>
    first
    | exact hActive
    | exact Or.inr hActive

/-- Existing activation provenance facts are immutable across current core
steps. Only bootstrap adds one fresh provenance fact. -/
theorem coreStep_preserves_activation_fact
    {S S' : CanonicalState}
    {event : KernelEvent}
    {key : ContextKey}
    {activation : Activation}
    (hStep : Step S event S')
    (hActivation : S.activationProvenance key = some activation) :
    S'.activationProvenance key = some activation := by
  cases hStep with
  | registerContext fresh => exact hActivation
  | registerProfile fresh => exact hActivation
  | bindProfile fresh profileCanonical => exact hActivation
  | bootstrapContext contextCanonical bindingCanonical inactive freshActivation =>
      exact putCanonical_preserves_some_grounded freshActivation hActivation
  | root fresh bindingCanonical contextCanonical accepted => exact hActivation
  | admitRoot bindingCanonical contextCanonical warrantCanonical isRoot
      formationContext formationProfile useMatches => exact hActivation
  | infer fresh bindingCanonical profileCanonical ruleExact contextCanonical
      parentsCanonical discipline => exact hActivation
  | transport fresh bindingCanonical contextCanonical originalCanonical
      witnessCanonical discipline => exact hActivation
  | qualifyInfer bindingCanonical warrantCanonical isInfer formationContext
      formationProfile parentsUsable => exact hActivation
  | qualifyTransport bindingCanonical warrantCanonical isTransport parentsExact
      originalCanonical witnessCanonical formationContext formationProfile
      parentsUsable => exact hActivation

/-- If a core step creates activity that was absent in the pre-state, the new
activity is exactly a bootstrap activation. -/
theorem coreStep_newActive_is_bootstrap
    {S S' : CanonicalState}
    {event : KernelEvent}
    {key : ContextKey}
    (hStep : Step S event S')
    (hPost : S'.activeContext key)
    (hPre : ¬ S.activeContext key) :
    S'.activationProvenance key = some Activation.bootstrap := by
  cases hStep with
  | @bootstrapContext bootstrapKey contextCanonical bindingCanonical inactive
      freshActivation =>
      rcases hPost with hEq | hOld
      · subst key
        simp [putCanonical]
      · exact False.elim (hPre hOld)
  | registerContext fresh => exact False.elim (hPre hPost)
  | registerProfile fresh => exact False.elim (hPre hPost)
  | bindProfile fresh profileCanonical => exact False.elim (hPre hPost)
  | root fresh bindingCanonical contextCanonical accepted =>
      exact False.elim (hPre hPost)
  | admitRoot bindingCanonical contextCanonical warrantCanonical isRoot
      formationContext formationProfile useMatches =>
      exact False.elim (hPre hPost)
  | infer fresh bindingCanonical profileCanonical ruleExact contextCanonical
      parentsCanonical discipline =>
      exact False.elim (hPre hPost)
  | transport fresh bindingCanonical contextCanonical originalCanonical
      witnessCanonical discipline =>
      exact False.elim (hPre hPost)
  | qualifyInfer bindingCanonical warrantCanonical isInfer formationContext
      formationProfile parentsUsable =>
      exact False.elim (hPre hPost)
  | qualifyTransport bindingCanonical warrantCanonical isTransport parentsExact
      originalCanonical witnessCanonical formationContext formationProfile
      parentsUsable =>
      exact False.elim (hPre hPost)

/-- The state-backed non-recursive currentness predicate is monotone across the
current core transition surface. -/
theorem coreStep_preserves_adoptLicenseBaseCurrent
    {S S' : CanonicalState}
    {event : KernelEvent}
    {licenseId : ActivationLicenseId}
    {L : CanonicalAdoptLicense}
    (hStep : Step S event S')
    (hCurrent : AdoptLicenseBaseCurrent S licenseId L) :
    AdoptLicenseBaseCurrent S' licenseId L := by
  rcases hCurrent with
    ⟨binding, issuerContext, targetContext, hBinding, hIssuerContext,
      hTargetContext, hTargetBinding, hTargetUse, hProfile, hUse,
      hReview, hScope, hSupport⟩
  have hImmutable := step_historyReferentsImmutable hStep
  have hReviewEq := coreStep_reviewRequired_unchanged hStep
  refine ⟨binding, issuerContext, targetContext,
    hImmutable.bindingImmutable hBinding,
    hImmutable.contextImmutable hIssuerContext,
    hImmutable.contextImmutable hTargetContext,
    hTargetBinding, hTargetUse, hProfile, hUse, ?_, hScope, ?_⟩
  · rw [hReviewEq]
    exact hReview
  · intro warrantId hMem
    rcases hSupport warrantId hMem with ⟨warrant, hWarrant, hUsable⟩
    exact ⟨warrant, hImmutable.warrantImmutable hWarrant,
      coreStep_preserves_usable hStep hUsable⟩

/-- Generic lifting lemma specialized to the enriched Adopt-state read. Exact
license-record preservation supplies exact issuer edges; BaseCurrent and active
facts are supplied separately. Activation preservation is required only for
contexts already active in the pre-state, matching each `Grounded` constructor's
own seed fact. -/
private theorem grounded_preserved_between_adoptStates
    {A A' : AdoptState}
    (hActive : ∀ ⦃key⦄,
      A.core.activeContext key → A'.core.activeContext key)
    (hActivation : ∀ ⦃key activation⦄,
      A.core.activeContext key →
      A.core.activationProvenance key = some activation →
        A'.core.activationProvenance key = some activation)
    (hLicense : ∀ ⦃licenseId L⦄,
      A.adoptLicense licenseId = some L →
        A'.adoptLicense licenseId = some L)
    (hBase : ∀ ⦃licenseId L⦄,
      A.adoptLicense licenseId = some L →
      AdoptLicenseBaseCurrent A.core licenseId L →
        AdoptLicenseBaseCurrent A'.core licenseId L)
    {key : ContextKey}
    (hGrounded : Grounded A.toLicenseRead.toActivationRead key) :
    Grounded A'.toLicenseRead.toActivationRead key := by
  induction hGrounded with
  | @bootstrap key seed activation =>
      apply Grounded.bootstrap
      · exact hActive seed
      · exact hActivation seed activation
  | @adopt key issuer license seed activation baseCurrent issuerContext
      issuerGrounded ih =>
      change ∃ L,
        A.adoptLicense license = some L ∧
          AdoptLicenseBaseCurrent A.core license L at baseCurrent
      rcases baseCurrent with ⟨L, hLookup, hBaseCurrent⟩
      have hIssuerExact :=
        adoptActivationRead_issuer_exact A.toLicenseRead hLookup
      have hIssuerEq : L.issuer = issuer :=
        Option.some.inj (hIssuerExact.symm.trans issuerContext)
      have hPostLookup := hLicense hLookup
      have hPostBase := hBase hLookup hBaseCurrent
      have hPostIssuer :=
        adoptActivationRead_issuer_exact A'.toLicenseRead hPostLookup
      apply Grounded.adopt
      · exact hActive seed
      · exact hActivation seed activation
      · change ∃ observed,
          A'.adoptLicense license = some observed ∧
            AdoptLicenseBaseCurrent A'.core license observed
        exact ⟨L, hPostLookup, hPostBase⟩
      · simpa [hIssuerEq] using hPostIssuer
      · exact ih

/-- Groundedness of existing contexts survives any lifted core step. -/
private theorem grounded_preserved_by_coreStep
    {A : AdoptState}
    {S' : CanonicalState}
    {event : KernelEvent}
    {key : ContextKey}
    (hStep : Step A.core event S')
    (hGrounded : Grounded A.toLicenseRead.toActivationRead key) :
    Grounded
      ({ core := S', adoptLicense := A.adoptLicense } : AdoptState).toLicenseRead.toActivationRead
      key := by
  apply grounded_preserved_between_adoptStates
  · intro observed hActive
    exact coreStep_active_monotone hStep hActive
  · intro observed activation hSeed hActivation
    exact coreStep_preserves_activation_fact hStep hActivation
  · intro licenseId L hLookup
    exact hLookup
  · intro licenseId L hLookup hCurrent
    exact coreStep_preserves_adoptLicenseBaseCurrent hStep hCurrent
  · exact hGrounded

/-- Groundedness of existing contexts survives recording one fresh Adopt license. -/
private theorem grounded_preserved_by_recordStep
    {A A' : AdoptState}
    {licenseId : ActivationLicenseId}
    {L : CanonicalAdoptLicense}
    {key : ContextKey}
    (hStep : AdoptRecordStep A (.recordAdoptLicense licenseId L) A')
    (hGrounded : Grounded A.toLicenseRead.toActivationRead key) :
    Grounded A'.toLicenseRead.toActivationRead key := by
  have hTopology := recordAdoptLicense_activationTopology_unchanged hStep
  apply grounded_preserved_between_adoptStates
  · intro observed hActive
    rw [hTopology.1]
    exact hActive
  · intro observed activation hSeed hActivation
    rw [hTopology.2]
    exact hActivation
  · intro observedId observed hLookup
    exact recordAdoptLicense_oldRecords_immutable hStep hLookup
  · intro observedId observed hLookup hCurrent
    exact recordAdoptLicense_preserves_baseCurrent hStep hCurrent
  · exact hGrounded

/-- Groundedness of existing contexts survives either kind of record-layer step. -/
private theorem grounded_preserved_by_recordLayerStep
    {A A' : AdoptState}
    {event : AdoptRecordEvent}
    {key : ContextKey}
    (hStep : AdoptRecordStep A event A')
    (hGrounded : Grounded A.toLicenseRead.toActivationRead key) :
    Grounded A'.toLicenseRead.toActivationRead key := by
  cases hStep with
  | @core event S' step =>
      exact grounded_preserved_by_coreStep step hGrounded
  | @recordAdoptLicense licenseId L freshEnriched freshProjection discipline =>
      exact grounded_preserved_by_recordStep
        (.recordAdoptLicense freshEnriched freshProjection discipline) hGrounded

/-- Groundedness of existing contexts survives an Adopt activation itself. -/
private theorem grounded_preserved_by_adoptStep
    {A A' : AdoptState}
    {licenseId : ActivationLicenseId}
    {target key : ContextKey}
    (hStep : AdoptActivationStep A (.adoptContext licenseId target) A')
    (hGrounded : Grounded A.toLicenseRead.toActivationRead key) :
    Grounded A'.toLicenseRead.toActivationRead key := by
  apply grounded_preserved_between_adoptStates
  · intro observed hActive
    exact adoptContext_active_monotone hStep hActive
  · intro observed activation hSeed hActivation
    have hEq := adoptContext_oldActivation_unchanged hStep hSeed
    rw [hEq]
    exact hActivation
  · intro observedId observed hLookup
    have hEq := adoptContext_enrichedLicenses_unchanged hStep
    rw [hEq]
    exact hLookup
  · intro observedId observed hLookup hCurrent
    exact adoptContext_preserves_baseCurrent hStep hCurrent
  · exact hGrounded

/-- Constructor inversion used only at the proof boundary: an Adopt step cannot
create any fresh active context except its named target. -/
private theorem adoptContext_newActive_is_target
    {A A' : AdoptState}
    {licenseId : ActivationLicenseId}
    {target key : ContextKey}
    (hStep : AdoptActivationStep A (.adoptContext licenseId target) A')
    (hPost : A'.core.activeContext key)
    (hPre : ¬ A.core.activeContext key) :
    key = target := by
  cases hStep with
  | adoptContext licenseCanonical targetExact baseCurrent issuerGrounded
      inactive freshActivation =>
      rcases hPost with hEq | hOld
      · exact hEq
      · exact False.elim (hPre hOld)

/-- State-level invariant used by the reachability induction. -/
def ActiveContextsGrounded (A : AdoptState) : Prop :=
  ∀ ⦃key⦄,
    A.core.activeContext key →
      Grounded A.toLicenseRead.toActivationRead key

/-- The empty activation boundary has no active contexts. -/
theorem adoptInitial_activeContextsGrounded
    {A : AdoptState}
    (hInitial : AdoptInitialBoundary A) :
    ActiveContextsGrounded A := by
  subst A
  intro key hActive
  exact False.elim hActive

/-- One-step preservation of grounded active-context closure. Existing active
contexts preserve their grounded derivations; a genuinely new core context is a
bootstrap, while a genuinely new Adopt context is grounded by the exact current
license consumed by that transition. -/
theorem adoptActivationStep_preserves_activeContextsGrounded
    {A A' : AdoptState}
    {event : AdoptActivationEvent}
    (hBefore : ActiveContextsGrounded A)
    (hStep : AdoptActivationStep A event A') :
    ActiveContextsGrounded A' := by
  cases event with
  | prior recordEvent =>
      cases hStep with
      | prior recordStep =>
          intro key hPostActive
          cases recordStep with
          | @core coreEvent S' coreStep =>
              by_cases hPreActive : A.core.activeContext key
              · exact grounded_preserved_by_coreStep coreStep
                  (hBefore hPreActive)
              · apply Grounded.bootstrap
                · exact hPostActive
                · exact coreStep_newActive_is_bootstrap coreStep
                    hPostActive hPreActive
          | @recordAdoptLicense licenseId L freshEnriched freshProjection
              discipline =>
              have hRecordStep :=
                AdoptRecordStep.recordAdoptLicense
                  freshEnriched freshProjection discipline
              have hTopology :=
                recordAdoptLicense_activationTopology_unchanged hRecordStep
              have hPreActive : A.core.activeContext key := by
                rw [hTopology.1] at hPostActive
                exact hPostActive
              exact grounded_preserved_by_recordStep hRecordStep
                (hBefore hPreActive)
  | adoptContext licenseId target =>
      intro key hPostActive
      by_cases hPreActive : A.core.activeContext key
      · exact grounded_preserved_by_adoptStep hStep
          (hBefore hPreActive)
      · have hKeyEq :=
          adoptContext_newActive_is_target hStep hPostActive hPreActive
        subst key
        rcases adoptContext_requires_currentLicense hStep with
          ⟨L, hLookup, hBaseCurrent, hIssuerGrounded⟩
        have hIssuerPost :=
          grounded_preserved_by_adoptStep hStep hIssuerGrounded
        have hPostLookup : A'.adoptLicense licenseId = some L := by
          rw [adoptContext_enrichedLicenses_unchanged hStep]
          exact hLookup
        have hPostBase :
            AdoptLicenseBaseCurrent A'.core licenseId L :=
          adoptContext_preserves_baseCurrent hStep hBaseCurrent
        have hActivation := adoptContext_activation_exact hStep
        apply Grounded.adopt (issuer := L.issuer) (license := licenseId)
        · exact hActivation.1
        · exact hActivation.2
        · change ∃ observed,
            A'.adoptLicense licenseId = some observed ∧
              AdoptLicenseBaseCurrent A'.core licenseId observed
          exact ⟨L, hPostLookup, hPostBase⟩
        · exact adoptActivationRead_issuer_exact A'.toLicenseRead hPostLookup
        · exact hIssuerPost

/-- Main reachable closure: every context marked active in an activation-reachable
state is grounded in the exact state-backed Adopt-license read. -/
theorem reachable_activeContext_grounded
    {A : AdoptState}
    (hReachable : AdoptActivationReachable A) :
    ∀ ⦃key⦄,
      A.core.activeContext key →
      Grounded A.toLicenseRead.toActivationRead key := by
  have hAll : ActiveContextsGrounded A := by
    induction hReachable with
    | initial hInitial =>
        exact adoptInitial_activeContextsGrounded hInitial
    | step hReachable hStep ih =>
        exact adoptActivationStep_preserves_activeContextsGrounded ih hStep
  exact hAll

/-- Reachable form of the finite bootstrap-chain theorem. -/
theorem reachable_activeContext_has_bootstrap_chain
    {A : AdoptState}
    (hReachable : AdoptActivationReachable A)
    {key : ContextKey}
    (hActive : A.core.activeContext key) :
    ∃ root,
      CurrentActivationChain A.toLicenseRead.toActivationRead key root ∧
      A.core.activationProvenance root = some Activation.bootstrap := by
  have hGrounded := reachable_activeContext_grounded hReachable hActive
  exact grounded_has_bootstrap_chain hGrounded

/-- Reachable no-self-support consequence: a reachable active context cannot
exist in a state with no bootstrap activation boundary anywhere. -/
theorem reachable_no_active_without_bootstrap
    {A : AdoptState}
    (hReachable : AdoptActivationReachable A)
    (hNoBootstrap : ∀ key,
      A.core.activationProvenance key ≠ some Activation.bootstrap) :
    ∀ key, ¬ A.core.activeContext key := by
  intro key hActive
  have hGrounded := reachable_activeContext_grounded hReachable hActive
  exact no_grounded_without_bootstrap hNoBootstrap hGrounded

end ResponsibilityTopology
