import ResponsibilityTopology.ChallengeInvalidationInvariant

namespace ResponsibilityTopology

/-!
Grounded activation refresh after challenge invalidation.

Paper 2's claim surface is frozen at TRANSPORT + Adopt/License + grounded
reachable currentness.  This module belongs to the Paper 3 revision line.  It
may reuse and locally reorganize shared currentness definitions, but it does not
expand Paper 2's claims.

The reference runtime computes a fixed point after invalidation.  The formal
semantics states that fixed point directly: a context remains ACTIVE exactly
when it is `Grounded` in the invalidated state-backed activation read.  The
projection preserves historical structure, activation provenance, licenses, and
evaluation state; it changes only active-context membership.
-/

/-- Fixed-point refresh: retain exactly contexts grounded in the current
state-backed Adopt-license read. -/
noncomputable def refreshActiveContexts (A : AdoptState) : AdoptState := by
  classical
  exact {
    core := {
      A.core with
      activeContext := Grounded A.toLicenseRead.toActivationRead
    }
    adoptLicense := A.adoptLicense
  }

/-- Exact semantic boundary advertised by the refresh stage. -/
theorem refreshActiveContexts_active_iff
    (A : AdoptState) (key : ContextKey) :
    (refreshActiveContexts A).core.activeContext key ↔
      Grounded A.toLicenseRead.toActivationRead key := by
  rfl

/-- Refresh is contractive: it cannot synthesize an active context outside the
pre-refresh seed-active set. -/
theorem refreshActiveContexts_contracts
    {A : AdoptState} {key : ContextKey}
    (hActive : (refreshActiveContexts A).core.activeContext key) :
    A.core.activeContext key := by
  exact grounded_contractiveness hActive

/-- The refresh projection changes only active-context membership. -/
theorem refreshActiveContexts_topology_unchanged
    (A : AdoptState) :
    (refreshActiveContexts A).core.context = A.core.context ∧
    (refreshActiveContexts A).core.profile = A.core.profile ∧
    (refreshActiveContexts A).core.binding = A.core.binding ∧
    (refreshActiveContexts A).core.warrant = A.core.warrant ∧
    (refreshActiveContexts A).core.license = A.core.license ∧
    (refreshActiveContexts A).adoptLicense = A.adoptLicense ∧
    (refreshActiveContexts A).core.activationProvenance =
      A.core.activationProvenance ∧
    (refreshActiveContexts A).core.reviewRequired = A.core.reviewRequired ∧
    (refreshActiveContexts A).core.epi = A.core.epi ∧
    (refreshActiveContexts A).core.placement = A.core.placement := by
  exact ⟨rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl⟩

/-- Any grounded adopted context consumes a base-current activation license. -/
theorem grounded_adopt_requires_baseCurrent
    {R : ActivationRead}
    {key : ContextKey}
    {licenseId : ActivationLicenseId}
    (hGrounded : Grounded R key)
    (hActivation :
      R.activation key = some (Activation.adopt licenseId)) :
    R.baseCurrent licenseId := by
  cases hGrounded with
  | bootstrap seed hBootstrap =>
      have hImpossible :
          Activation.bootstrap = Activation.adopt licenseId :=
        Option.some.inj (hBootstrap.symm.trans hActivation)
      cases hImpossible
  | @adopt _ issuer observedLicense seed hObservedActivation hBase
      hIssuerContext hIssuerGrounded =>
      have hLicenseEq : observedLicense = licenseId :=
        Activation.adopt.inj
          (Option.some.inj (hObservedActivation.symm.trans hActivation))
      subst observedLicense
      exact hBase

/-- Groundedness of an adopted context carries groundedness of the exact issuer
named by its activation license. -/
theorem grounded_adopt_issuer_grounded
    {R : ActivationRead}
    {key issuer : ContextKey}
    {licenseId : ActivationLicenseId}
    (hGrounded : Grounded R key)
    (hActivation :
      R.activation key = some (Activation.adopt licenseId))
    (hIssuer : R.issuerContext licenseId = some issuer) :
    Grounded R issuer := by
  cases hGrounded with
  | bootstrap seed hBootstrap =>
      have hImpossible :
          Activation.bootstrap = Activation.adopt licenseId :=
        Option.some.inj (hBootstrap.symm.trans hActivation)
      cases hImpossible
  | @adopt _ observedIssuer observedLicense seed hObservedActivation hBase
      hObservedIssuer hIssuerGrounded =>
      have hLicenseEq : observedLicense = licenseId :=
        Activation.adopt.inj
          (Option.some.inj (hObservedActivation.symm.trans hActivation))
      subst observedLicense
      have hIssuerEq : observedIssuer = issuer :=
        Option.some.inj (hObservedIssuer.symm.trans hIssuer)
      subst observedIssuer
      exact hIssuerGrounded

/-- Challenge invalidation cannot create LIVE status.  Any post-invalidation LIVE
position was already LIVE before the challenge. -/
theorem challengeInvalidate_live_implies_pre
    (A : AdoptState)
    (profileDigest use : String)
    (targetId : WarrantId)
    (key : EvalKey)
    (hLive :
      (challengeInvalidate A profileDigest use targetId).core.epi key =
        some .live) :
    A.core.epi key = some .live := by
  classical
  change challengeEpi A.core profileDigest use targetId key = some .live at hLive
  unfold challengeEpi at hLive
  split at hLive
  · cases hOld : A.core.epi key with
    | none => simp [hOld] at hLive
    | some status =>
        cases status <;> simp [hOld] at hLive
  · simpa using hLive

/-- Challenge invalidation cannot create PLACED status. -/
theorem challengeInvalidate_placed_implies_pre
    (A : AdoptState)
    (profileDigest use : String)
    (targetId : WarrantId)
    (key : EvalKey)
    (hPlaced :
      (challengeInvalidate A profileDigest use targetId).core.placement key =
        some .placed) :
    A.core.placement key = some .placed := by
  classical
  change challengePlacement A.core profileDigest use targetId key =
    some .placed at hPlaced
  unfold challengePlacement at hPlaced
  split at hPlaced
  · cases hOld : A.core.placement key with
    | none => simp [hOld] at hPlaced
    | some placement =>
        cases placement <;> simp [hOld] at hPlaced
  · simpa using hPlaced

/-- Therefore challenge invalidation cannot create usability. -/
theorem challengeInvalidate_usable_implies_pre
    (A : AdoptState)
    (profileDigest use : String)
    (targetId : WarrantId)
    (key : EvalKey)
    (hUsable : Usable
      (challengeInvalidate A profileDigest use targetId).core key) :
    Usable A.core key := by
  exact ⟨
    challengeInvalidate_live_implies_pre A profileDigest use targetId key hUsable.1,
    challengeInvalidate_placed_implies_pre A profileDigest use targetId key hUsable.2
  ⟩

/-- Challenge makes the state-backed nonrecursive license judgment stricter:
anything BaseCurrent after invalidation was already BaseCurrent before it. -/
theorem challengeStep_baseCurrent_stricter
    {A A' : AdoptState}
    {bindingId contextId use : String}
    {challengerId bridgeId targetId : WarrantId}
    {licenseId : ActivationLicenseId}
    {L : CanonicalAdoptLicense}
    (hStep : ChallengeStep A
      (.challenge bindingId contextId use challengerId bridgeId targetId) A')
    (hCurrent : AdoptLicenseBaseCurrent A'.core licenseId L) :
    AdoptLicenseBaseCurrent A.core licenseId L := by
  rcases challengeStep_effect_exact hStep with
    ⟨binding, hBinding, hPost⟩
  subst A'
  rcases hCurrent with
    ⟨licenseBinding, issuerContext, targetContext,
      hLicenseBinding, hIssuerContext, hTargetContext,
      hTargetBinding, hTargetUse, hProfile, hUse,
      hReview, hScope, hSupport⟩
  refine ⟨licenseBinding, issuerContext, targetContext, ?_, ?_, ?_,
    hTargetBinding, hTargetUse, hProfile, hUse, ?_, hScope, ?_⟩
  · simpa [challengeInvalidate] using hLicenseBinding
  · simpa [challengeInvalidate] using hIssuerContext
  · simpa [challengeInvalidate] using hTargetContext
  · intro hPreReview
    apply hReview
    exact Or.inl hPreReview
  · intro warrantId hMem
    rcases hSupport warrantId hMem with ⟨warrant, hWarrant, hUsable⟩
    refine ⟨warrant, ?_, ?_⟩
    · simpa [challengeInvalidate] using hWarrant
    · exact challengeInvalidate_usable_implies_pre
        A binding.profileDigest use targetId
        ⟨L.profileDigest, L.issuer.context, L.issuer.use, warrantId⟩ hUsable

/-- At the identifier-level base-current observation, post-challenge truth also
implies pre-challenge truth. -/
theorem challengeStep_baseCurrentRead_stricter
    {A A' : AdoptState}
    {bindingId contextId use : String}
    {challengerId bridgeId targetId : WarrantId}
    (hStep : ChallengeStep A
      (.challenge bindingId contextId use challengerId bridgeId targetId) A') :
    ∀ licenseId,
      A'.toLicenseRead.toActivationRead.baseCurrent licenseId →
      A.toLicenseRead.toActivationRead.baseCurrent licenseId := by
  intro licenseId hCurrent
  rcases hCurrent with ⟨L, hLicense, hBase⟩
  have hLicenses : A'.adoptLicense = A.adoptLicense :=
    (challengeStep_topology_unchanged hStep).2.2.2.2.2.1
  refine ⟨L, ?_, challengeStep_baseCurrent_stricter hStep hBase⟩
  rw [hLicenses] at hLicense
  exact hLicense

/-- Challenge changes the activation read only through its base-currentness
judgment; seed activity, provenance, and issuer edges are identical. -/
theorem challengeStep_activationRead_eq_withBaseCurrent
    {A A' : AdoptState}
    {bindingId contextId use : String}
    {challengerId bridgeId targetId : WarrantId}
    (hStep : ChallengeStep A
      (.challenge bindingId contextId use challengerId bridgeId targetId) A') :
    A'.toLicenseRead.toActivationRead =
      withBaseCurrent A.toLicenseRead.toActivationRead
        A'.toLicenseRead.toActivationRead.baseCurrent := by
  cases hStep with
  | challenge bindingCanonical contextCanonical challengerCanonical
      bridgeCanonical targetCanonical challengerUsable bridgeUsable bridgeRole
      bridgeClaimExact =>
      rfl

/-- Reachable invalidation is monotone in grounded currentness: any context still
grounded after challenge was grounded before challenge.  This is the concrete
bridge from #43 to the existing abstract `grounded_invalidation_monotonicity`. -/
theorem challengeStep_grounded_post_implies_pre
    {A A' : AdoptState}
    {bindingId contextId use : String}
    {challengerId bridgeId targetId : WarrantId}
    {key : ContextKey}
    (hStep : ChallengeStep A
      (.challenge bindingId contextId use challengerId bridgeId targetId) A')
    (hGrounded : Grounded A'.toLicenseRead.toActivationRead key) :
    Grounded A.toLicenseRead.toActivationRead key := by
  rw [challengeStep_activationRead_eq_withBaseCurrent hStep] at hGrounded
  have hMonotone := grounded_invalidation_monotonicity
    A.toLicenseRead.toActivationRead
    A.toLicenseRead.toActivationRead.baseCurrent
    A'.toLicenseRead.toActivationRead.baseCurrent
    (challengeStep_baseCurrentRead_stricter hStep)
    hGrounded
  simpa [withBaseCurrent] using hMonotone

/-- Direct loss: a context activated by a stale Adopt license cannot survive the
fixed-point refresh. -/
theorem refresh_staleActivation_notActive
    {A : AdoptState}
    {key : ContextKey}
    {licenseId : ActivationLicenseId}
    (hActivation :
      A.core.activationProvenance key = some (Activation.adopt licenseId))
    (hStale : ¬ A.toLicenseRead.toActivationRead.baseCurrent licenseId) :
    ¬ (refreshActiveContexts A).core.activeContext key := by
  intro hActive
  have hGrounded : Grounded A.toLicenseRead.toActivationRead key := hActive
  apply hStale
  apply grounded_adopt_requires_baseCurrent hGrounded
  exact hActivation

/-- Retention is issuer-closed: if an adopted context survives refresh, its exact
issuing context survives the same refresh. -/
theorem refresh_activeAdopt_implies_issuerActive
    {A : AdoptState}
    {key issuer : ContextKey}
    {licenseId : ActivationLicenseId}
    (hActive : (refreshActiveContexts A).core.activeContext key)
    (hActivation :
      A.core.activationProvenance key = some (Activation.adopt licenseId))
    (hIssuer :
      A.toLicenseRead.toActivationRead.issuerContext licenseId = some issuer) :
    (refreshActiveContexts A).core.activeContext issuer := by
  have hGrounded : Grounded A.toLicenseRead.toActivationRead key := hActive
  exact grounded_adopt_issuer_grounded hGrounded hActivation hIssuer

/-- Cascading loss, stated contrapositively: loss of the issuer at refresh forces
loss of every adopted context whose currentness depends on that issuer. -/
theorem refresh_issuerLoss_cascades
    {A : AdoptState}
    {key issuer : ContextKey}
    {licenseId : ActivationLicenseId}
    (hActivation :
      A.core.activationProvenance key = some (Activation.adopt licenseId))
    (hIssuer :
      A.toLicenseRead.toActivationRead.issuerContext licenseId = some issuer)
    (hIssuerLost : ¬ (refreshActiveContexts A).core.activeContext issuer) :
    ¬ (refreshActiveContexts A).core.activeContext key := by
  intro hActive
  exact hIssuerLost
    (refresh_activeAdopt_implies_issuerActive hActive hActivation hIssuer)

inductive RefreshEvent where
  | prior (event : ChallengeEvent)
  | refresh

inductive RefreshStep : AdoptState → RefreshEvent → AdoptState → Prop where
  | prior
      {A A' : AdoptState} {event : ChallengeEvent}
      (step : ChallengeStep A event A') :
      RefreshStep A (.prior event) A'
  | refresh {A : AdoptState} :
      RefreshStep A .refresh (refreshActiveContexts A)

inductive RefreshReachable : AdoptState → Prop where
  | initial {A : AdoptState} :
      AdoptInitialBoundary A → RefreshReachable A
  | step {A A' : AdoptState} {event : RefreshEvent} :
      RefreshReachable A → RefreshStep A event A' → RefreshReachable A'

/-- Existing challenge-reachable states embed unchanged into the refresh layer. -/
theorem challengeReachable_to_refreshReachable
    {A : AdoptState}
    (hReachable : ChallengeReachable A) : RefreshReachable A := by
  induction hReachable with
  | initial hInitial => exact .initial hInitial
  | step hReachable hStep ih => exact .step ih (.prior hStep)

/-- Constructor inversion for the explicit refresh boundary. -/
theorem refreshStep_exact
    {A A' : AdoptState}
    (hStep : RefreshStep A .refresh A') :
    A' = refreshActiveContexts A := by
  cases hStep
  rfl

/-- Adjacent challenge + refresh closure: every context retained after refresh
was already grounded before the challenge. -/
theorem challengeRefresh_retained_implies_preGrounded
    {A A₁ A₂ : AdoptState}
    {bindingId contextId use : String}
    {challengerId bridgeId targetId : WarrantId}
    {key : ContextKey}
    (hChallenge : ChallengeStep A
      (.challenge bindingId contextId use challengerId bridgeId targetId) A₁)
    (hRefresh : RefreshStep A₁ .refresh A₂)
    (hActive : A₂.core.activeContext key) :
    Grounded A.toLicenseRead.toActivationRead key := by
  have hEq := refreshStep_exact hRefresh
  subst A₂
  exact challengeStep_grounded_post_implies_pre hChallenge hActive

end ResponsibilityTopology
