import ResponsibilityTopology.AdoptActivation

namespace ResponsibilityTopology

/-!
Reachable grounded currentness for context activation.

The central result connects the reachable activation relation to the previously
orthogonal semantic `Grounded` relation.  Under the current transition surface,
base-currentness is monotone: core steps may add canonical history or make an
evaluation usable, but there is not yet a review/invalidation transition that can
make a previously base-current Adopt license stale.  This monotonicity is a
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

/-- Every current core transition preserves existing usability.  This relies on
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
    | exact qualifyEvaluation_preserves_usable _ _ hUsable

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
steps.  Only bootstrap adds one fresh provenance fact. -/
theorem coreStep_preserves_activation_fact
    {S S' : CanonicalState}
    {event : KernelEvent}
    {key : ContextKey}
    {activation : Activation}
    (hStep : Step S event S')
    (hActivation : S.activationProvenance key = some activation) :
    S'.activationProvenance key = some activation := by
  cases hStep <;>
    first
    | exact hActivation
    | exact putCanonical_preserves_some_grounded freshActivation hActivation

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

/-- Generic lifting lemma specialized to the enriched Adopt-state read.  Exact
license-record preservation supplies exact issuer edges; BaseCurrent and active
facts are supplied separately. -/
private theorem grounded_preserved_between_adoptStates
    {A A' : AdoptState}
    (hActive : ∀ ⦃key⦄,
      A.core.activeContext key → A'.core.activeContext key)
    (hActivation : ∀ ⦃key activation⦄,
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
      · exact hActivation activation
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
      · exact hActivation activation
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
  · intro observed activation hActivation
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
  · intro observed activation hActivation
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
  · intro observed activation hActivation
    have hSeed : A.core.activeContext observed :=
      grounded_contractiveness hGrounded
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

/-- Main reachable closure: every context marked active in an activation-reachable
state is grounded in the exact state-backed Adopt-license read. -/
theorem reachable_activeContext_grounded
    {A : AdoptState}
    (hReachable : AdoptActivationReachable A) :
    ∀ ⦃key⦄,
      A.core.activeContext key →
      Grounded A.toLicenseRead.toActivationRead key := by
  induction hReachable with
  | initial hInitial =>
      subst A
      intro key hActive
      cases hActive
  | @step A A' event hReachable hStep ih =>
      intro key hPostActive
      cases hStep with
      | prior recordStep =>
          cases recordStep with
          | @core event S' coreStep =>
              by_cases hPreActive : A.core.activeContext key
              · exact grounded_preserved_by_coreStep coreStep
                  (ih hPreActive)
              · apply Grounded.bootstrap
                · exact hPostActive
                · exact coreStep_newActive_is_bootstrap coreStep
                    hPostActive hPreActive
          | @recordAdoptLicense licenseId L freshEnriched freshProjection
              discipline =>
              have hRecordStep :
                  AdoptRecordStep A (.recordAdoptLicense licenseId L) A' :=
                .recordAdoptLicense freshEnriched freshProjection discipline
              have hTopology :=
                recordAdoptLicense_activationTopology_unchanged hRecordStep
              have hPreActive : A.core.activeContext key := by
                rw [← hTopology.1]
                exact hPostActive
              exact grounded_preserved_by_recordStep hRecordStep
                (ih hPreActive)
      | @adoptContext licenseId target L licenseCanonical targetExact baseCurrent
          issuerGrounded inactive freshActivation =>
          have hAdoptStep :
              AdoptActivationStep A (.adoptContext licenseId target) A' :=
            .adoptContext licenseCanonical targetExact baseCurrent issuerGrounded
              inactive freshActivation
          by_cases hPreActive : A.core.activeContext key
          · exact grounded_preserved_by_adoptStep hAdoptStep
              (ih hPreActive)
          · have hKeyEq : key = target := by
              rcases hPostActive with hEq | hOld
              · exact hEq
              · exact False.elim (hPreActive hOld)
            subst key
            have hIssuerPost :
                Grounded A'.toLicenseRead.toActivationRead L.issuer :=
              grounded_preserved_by_adoptStep hAdoptStep issuerGrounded
            have hPostLicense : A'.adoptLicense licenseId = some L := by
              have hEq := adoptContext_enrichedLicenses_unchanged hAdoptStep
              rw [hEq]
              exact licenseCanonical
            have hPostBase :
                AdoptLicenseBaseCurrent A'.core licenseId L :=
              adoptContext_preserves_baseCurrent hAdoptStep baseCurrent
            have hActivation := adoptContext_activation_exact hAdoptStep
            apply Grounded.adopt
            · exact hActivation.1
            · exact hActivation.2
            · change ∃ observed,
                A'.adoptLicense licenseId = some observed ∧
                  AdoptLicenseBaseCurrent A'.core licenseId observed
              exact ⟨L, hPostLicense, hPostBase⟩
            · exact adoptActivationRead_issuer_exact A'.toLicenseRead hPostLicense
            · exact hIssuerPost

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
