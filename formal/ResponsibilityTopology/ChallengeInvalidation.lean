import ResponsibilityTopology.AdoptGroundedness
import ResponsibilityTopology.ChallengeImpact

namespace ResponsibilityTopology

/-!
Reachable challenge invalidation, before activation refresh.

The reference runtime performs challenge validation, warrant suspension,
descendant placement invalidation, license review marking, and then a fixed-point
context-currentness refresh in one method.  This module factors that operation at
the responsibility boundary: it formalizes the validation + invalidation phase
only.  Activation refresh is deliberately deferred to the next stage.

The currently reachable formal license surface contains enriched Adopt licenses,
not generic Python `LicenseRecord`s.  Review invalidation therefore ranges over
those exact records and their stored support lists; this module makes no generic
issuance claim.
-/

/-- Canonical challenge bridge claim under the current formal warrant-id
vocabulary.  Exact Python string-ID representation remains a refinement concern. -/
def challengeClaim
    (challengerId targetId : WarrantId) : Claim where
  kind := "Challenges"
  args := [toString challengerId, toString targetId]

/-- Evaluation coordinates affected by challenge suspension.  Context is
intentionally unrestricted, matching the reference runtime's scan over all
matching profile/use evaluation keys. -/
def ChallengeEvalAffected
    (S : CanonicalState)
    (profileDigest use : String)
    (targetId : WarrantId)
    (key : EvalKey) : Prop :=
  key.profileDigest = profileDigest ∧
    key.use = use ∧
    Affected S targetId key.warrantId

/-- Placement invalidation excludes the challenged target itself: descendants
move from PLACED to PENDING, while target placement is retained. -/
def ChallengePlacementAffected
    (S : CanonicalState)
    (profileDigest use : String)
    (targetId : WarrantId)
    (key : EvalKey) : Prop :=
  key.profileDigest = profileDigest ∧
    key.use = use ∧
    key.warrantId ≠ targetId ∧
    Affected S targetId key.warrantId

/-- An enriched Adopt license is challenge-impacted exactly when it has matching
profile/use coordinates and some stored support warrant lies in the affected
historical closure. -/
def ChallengeLicenseImpacted
    (A : AdoptState)
    (profileDigest use : String)
    (targetId : WarrantId)
    (licenseId : ActivationLicenseId) : Prop :=
  ∃ L,
    A.adoptLicense licenseId = some L ∧
    L.profileDigest = profileDigest ∧
    L.issuer.use = use ∧
    ∃ warrantId,
      warrantId ∈ L.support ∧
      Affected A.core targetId warrantId

/-- Pointwise epistemic invalidation.  Only LIVE positions on affected warrants
at the challenged profile/use are changed, and they become SUSPENDED. -/
noncomputable def challengeEpi
    (S : CanonicalState)
    (profileDigest use : String)
    (targetId : WarrantId) : EvalKey → Option EpiStatus := by
  classical
  exact fun key =>
    if hAffected : ChallengeEvalAffected S profileDigest use targetId key then
      match S.epi key with
      | some .live => some .suspended
      | other => other
    else
      S.epi key

/-- Pointwise placement invalidation.  Only PLACED positions on proper affected
descendants at the challenged profile/use are changed, and they become PENDING. -/
noncomputable def challengePlacement
    (S : CanonicalState)
    (profileDigest use : String)
    (targetId : WarrantId) : EvalKey → Option Placement := by
  classical
  exact fun key =>
    if hAffected : ChallengePlacementAffected S profileDigest use targetId key then
      match S.placement key with
      | some .placed => some .pending
      | other => other
    else
      S.placement key

/-- Deterministic invalidation phase.  Canonical history, active-context state,
activation provenance, and enriched license records are unchanged. -/
noncomputable def challengeInvalidate
    (A : AdoptState)
    (profileDigest use : String)
    (targetId : WarrantId) : AdoptState := by
  classical
  exact {
    core := {
      A.core with
      reviewRequired := fun licenseId =>
        A.core.reviewRequired licenseId ∨
          ChallengeLicenseImpacted A profileDigest use targetId licenseId
      epi := challengeEpi A.core profileDigest use targetId
      placement := challengePlacement A.core profileDigest use targetId
    }
    adoptLicense := A.adoptLicense
  }

inductive ChallengeEvent where
  | prior (event : AdoptActivationEvent)
  | challenge
      (bindingId contextId use : String)
      (challengerId bridgeId targetId : WarrantId)

/-- Challenge validation matches the represented reference checks: canonical
binding/context/warrants, current challenger and bridge usability in the challenge
context, and an exact BRIDGE warrant naming challenger and target.  No context
ACTIVE premise or binding/use equality is silently added. -/
inductive ChallengeStep : AdoptState → ChallengeEvent → AdoptState → Prop where
  | prior
      {A A' : AdoptState} {event : AdoptActivationEvent}
      (step : AdoptActivationStep A event A') :
      ChallengeStep A (.prior event) A'
  | challenge
      {A : AdoptState}
      {bindingId contextId use : String}
      {challengerId bridgeId targetId : WarrantId}
      {binding : CanonicalBinding}
      {context : CanonicalContext}
      {challenger bridge target : HistoricalWarrant}
      (bindingCanonical : A.core.binding bindingId = some binding)
      (contextCanonical : A.core.context contextId = some context)
      (challengerCanonical : A.core.warrant challengerId = some challenger)
      (bridgeCanonical : A.core.warrant bridgeId = some bridge)
      (targetCanonical : A.core.warrant targetId = some target)
      (challengerUsable : Usable A.core
        ⟨binding.profileDigest, contextId, use, challengerId⟩)
      (bridgeUsable : Usable A.core
        ⟨binding.profileDigest, contextId, use, bridgeId⟩)
      (bridgeRole : bridge.role = .bridge)
      (bridgeClaimExact : bridge.claim = challengeClaim challengerId targetId) :
      ChallengeStep A
        (.challenge bindingId contextId use challengerId bridgeId targetId)
        (challengeInvalidate A binding.profileDigest use targetId)

inductive ChallengeReachable : AdoptState → Prop where
  | initial {A : AdoptState} :
      AdoptInitialBoundary A → ChallengeReachable A
  | step {A A' : AdoptState} {event : ChallengeEvent} :
      ChallengeReachable A →
      ChallengeStep A event A' →
      ChallengeReachable A'

/-- Every pre-challenge activation-reachable state embeds unchanged into the new
challenge reachability relation. -/
theorem adoptActivationReachable_to_challengeReachable
    {A : AdoptState}
    (hReachable : AdoptActivationReachable A) :
    ChallengeReachable A := by
  induction hReachable with
  | initial hInitial => exact .initial hInitial
  | step hReachable hStep ih =>
      exact .step ih (.prior hStep)

/-- Constructor inversion exposes the exact deterministic invalidation update and
its canonical binding/profile coordinate. -/
theorem challengeStep_effect_exact
    {A A' : AdoptState}
    {bindingId contextId use : String}
    {challengerId bridgeId targetId : WarrantId}
    (hStep : ChallengeStep A
      (.challenge bindingId contextId use challengerId bridgeId targetId) A') :
    ∃ binding,
      A.core.binding bindingId = some binding ∧
      A' = challengeInvalidate A binding.profileDigest use targetId := by
  cases hStep with
  | challenge bindingCanonical contextCanonical challengerCanonical
      bridgeCanonical targetCanonical challengerUsable bridgeUsable bridgeRole
      bridgeClaimExact =>
      exact ⟨_, bindingCanonical, rfl⟩

/-- Challenge validation consumes exactly usable challenger and bridge warrants
and an exact bridge claim. -/
theorem challengeStep_validation_exact
    {A A' : AdoptState}
    {bindingId contextId use : String}
    {challengerId bridgeId targetId : WarrantId}
    (hStep : ChallengeStep A
      (.challenge bindingId contextId use challengerId bridgeId targetId) A') :
    ∃ binding challenger bridge target,
      A.core.binding bindingId = some binding ∧
      A.core.warrant challengerId = some challenger ∧
      A.core.warrant bridgeId = some bridge ∧
      A.core.warrant targetId = some target ∧
      Usable A.core ⟨binding.profileDigest, contextId, use, challengerId⟩ ∧
      Usable A.core ⟨binding.profileDigest, contextId, use, bridgeId⟩ ∧
      bridge.role = .bridge ∧
      bridge.claim = challengeClaim challengerId targetId := by
  cases hStep with
  | challenge bindingCanonical contextCanonical challengerCanonical
      bridgeCanonical targetCanonical challengerUsable bridgeUsable bridgeRole
      bridgeClaimExact =>
      exact ⟨_, _, _, _, bindingCanonical, challengerCanonical,
        bridgeCanonical, targetCanonical, challengerUsable, bridgeUsable,
        bridgeRole, bridgeClaimExact⟩

/-- Pure epistemic update theorem. -/
theorem challengeEpi_live_affected
    {S : CanonicalState}
    {profileDigest use : String}
    {targetId : WarrantId}
    {key : EvalKey}
    (hAffected : ChallengeEvalAffected S profileDigest use targetId key)
    (hLive : S.epi key = some .live) :
    challengeEpi S profileDigest use targetId key = some .suspended := by
  classical
  simp [challengeEpi, hAffected, hLive]

/-- Unaffected epistemic coordinates are unchanged. -/
theorem challengeEpi_unaffected
    {S : CanonicalState}
    {profileDigest use : String}
    {targetId : WarrantId}
    {key : EvalKey}
    (hUnaffected : ¬ ChallengeEvalAffected S profileDigest use targetId key) :
    challengeEpi S profileDigest use targetId key = S.epi key := by
  classical
  simp [challengeEpi, hUnaffected]

/-- Pure placement update theorem. -/
theorem challengePlacement_placed_affected
    {S : CanonicalState}
    {profileDigest use : String}
    {targetId : WarrantId}
    {key : EvalKey}
    (hAffected : ChallengePlacementAffected S profileDigest use targetId key)
    (hPlaced : S.placement key = some .placed) :
    challengePlacement S profileDigest use targetId key = some .pending := by
  classical
  simp [challengePlacement, hAffected, hPlaced]

/-- The target's placement is never invalidated by the challenge phase. -/
theorem challengePlacement_target_unchanged
    {S : CanonicalState}
    {profileDigest use : String}
    {targetId : WarrantId}
    {key : EvalKey}
    (hTarget : key.warrantId = targetId) :
    challengePlacement S profileDigest use targetId key = S.placement key := by
  classical
  have hNot : ¬ ChallengePlacementAffected S profileDigest use targetId key := by
    intro h
    exact h.2.2.1 hTarget
  simp [challengePlacement, hNot]

/-- Unaffected placement coordinates are unchanged. -/
theorem challengePlacement_unaffected
    {S : CanonicalState}
    {profileDigest use : String}
    {targetId : WarrantId}
    {key : EvalKey}
    (hUnaffected : ¬ ChallengePlacementAffected S profileDigest use targetId key) :
    challengePlacement S profileDigest use targetId key = S.placement key := by
  classical
  simp [challengePlacement, hUnaffected]

/-- Historical and activation topology are untouched by the invalidation phase. -/
theorem challengeStep_topology_unchanged
    {A A' : AdoptState}
    {bindingId contextId use : String}
    {challengerId bridgeId targetId : WarrantId}
    (hStep : ChallengeStep A
      (.challenge bindingId contextId use challengerId bridgeId targetId) A') :
    A'.core.context = A.core.context ∧
    A'.core.profile = A.core.profile ∧
    A'.core.binding = A.core.binding ∧
    A'.core.warrant = A.core.warrant ∧
    A'.core.license = A.core.license ∧
    A'.adoptLicense = A.adoptLicense ∧
    A'.core.activeContext = A.core.activeContext ∧
    A'.core.activationProvenance = A.core.activationProvenance := by
  cases hStep with
  | challenge bindingCanonical contextCanonical challengerCanonical
      bridgeCanonical targetCanonical challengerUsable bridgeUsable bridgeRole
      bridgeClaimExact =>
      exact ⟨rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl⟩

/-- Existing canonical history referents are exact across challenge invalidation. -/
theorem challengeStep_historyReferentsImmutable
    {A A' : AdoptState}
    {bindingId contextId use : String}
    {challengerId bridgeId targetId : WarrantId}
    (hStep : ChallengeStep A
      (.challenge bindingId contextId use challengerId bridgeId targetId) A') :
    HistoryReferentsImmutable A.core A'.core := by
  cases hStep with
  | challenge bindingCanonical contextCanonical challengerCanonical
      bridgeCanonical targetCanonical challengerUsable bridgeUsable bridgeRole
      bridgeClaimExact =>
      constructor <;> intro <;> intro <;> intro h <;> exact h

/-- Exact review-marking equation for every represented Adopt license. -/
theorem challengeStep_reviewRequired_exact
    {A A' : AdoptState}
    {bindingId contextId use : String}
    {challengerId bridgeId targetId : WarrantId}
    {binding : CanonicalBinding}
    (hStep : ChallengeStep A
      (.challenge bindingId contextId use challengerId bridgeId targetId) A')
    (hBinding : A.core.binding bindingId = some binding)
    (licenseId : ActivationLicenseId) :
    A'.core.reviewRequired licenseId ↔
      A.core.reviewRequired licenseId ∨
        ChallengeLicenseImpacted A binding.profileDigest use targetId licenseId := by
  rcases challengeStep_effect_exact hStep with
    ⟨actualBinding, hActualBinding, hPost⟩
  have hEq : actualBinding = binding :=
    Option.some.inj (hActualBinding.symm.trans hBinding)
  subst actualBinding
  subst A'
  rfl

/-- Any matching Adopt license whose support intersects the affected closure is
marked review-required. -/
theorem challengeStep_impactedLicense_reviewRequired
    {A A' : AdoptState}
    {bindingId contextId use : String}
    {challengerId bridgeId targetId : WarrantId}
    {binding : CanonicalBinding}
    {licenseId : ActivationLicenseId}
    {L : CanonicalAdoptLicense}
    {warrantId : WarrantId}
    (hStep : ChallengeStep A
      (.challenge bindingId contextId use challengerId bridgeId targetId) A')
    (hBinding : A.core.binding bindingId = some binding)
    (hLicense : A.adoptLicense licenseId = some L)
    (hProfile : L.profileDigest = binding.profileDigest)
    (hUse : L.issuer.use = use)
    (hSupport : warrantId ∈ L.support)
    (hAffected : Affected A.core targetId warrantId) :
    A'.core.reviewRequired licenseId := by
  rw [challengeStep_reviewRequired_exact hStep hBinding licenseId]
  exact Or.inr ⟨L, hLicense, hProfile, hUse, warrantId, hSupport, hAffected⟩

/-- Review marking makes an impacted represented Adopt license fail BaseCurrent.
This is the first transition family that intentionally breaks the #41
BaseCurrent-monotonicity argument. -/
theorem challengeStep_impactedLicense_notBaseCurrent
    {A A' : AdoptState}
    {bindingId contextId use : String}
    {challengerId bridgeId targetId : WarrantId}
    {binding : CanonicalBinding}
    {licenseId : ActivationLicenseId}
    {L : CanonicalAdoptLicense}
    {warrantId : WarrantId}
    (hStep : ChallengeStep A
      (.challenge bindingId contextId use challengerId bridgeId targetId) A')
    (hBinding : A.core.binding bindingId = some binding)
    (hLicense : A.adoptLicense licenseId = some L)
    (hProfile : L.profileDigest = binding.profileDigest)
    (hUse : L.issuer.use = use)
    (hSupport : warrantId ∈ L.support)
    (hAffected : Affected A.core targetId warrantId) :
    ¬ AdoptLicenseBaseCurrent A'.core licenseId L := by
  intro hCurrent
  have hReview := challengeStep_impactedLicense_reviewRequired
    hStep hBinding hLicense hProfile hUse hSupport hAffected
  exact (adoptLicenseBaseCurrent_review_scope hCurrent).1 hReview

/-- Generic reachable suspension theorem for any affected evaluation coordinate. -/
theorem challengeStep_liveAffected_suspended
    {A A' : AdoptState}
    {bindingId contextId use : String}
    {challengerId bridgeId targetId : WarrantId}
    {binding : CanonicalBinding}
    {key : EvalKey}
    (hStep : ChallengeStep A
      (.challenge bindingId contextId use challengerId bridgeId targetId) A')
    (hBinding : A.core.binding bindingId = some binding)
    (hProfile : key.profileDigest = binding.profileDigest)
    (hUse : key.use = use)
    (hAffected : Affected A.core targetId key.warrantId)
    (hLive : A.core.epi key = some .live) :
    A'.core.epi key = some .suspended := by
  rcases challengeStep_effect_exact hStep with
    ⟨actualBinding, hActualBinding, hPost⟩
  have hEq : actualBinding = binding :=
    Option.some.inj (hActualBinding.symm.trans hBinding)
  subst actualBinding
  subst A'
  apply challengeEpi_live_affected
  · exact ⟨hProfile, hUse, hAffected⟩
  · exact hLive

/-- The challenge target itself is suspended wherever it is LIVE on matching
profile/use evaluation coordinates. -/
theorem challengeStep_target_live_suspended
    {A A' : AdoptState}
    {bindingId contextId use : String}
    {challengerId bridgeId targetId : WarrantId}
    {binding : CanonicalBinding}
    {key : EvalKey}
    (hStep : ChallengeStep A
      (.challenge bindingId contextId use challengerId bridgeId targetId) A')
    (hBinding : A.core.binding bindingId = some binding)
    (hProfile : key.profileDigest = binding.profileDigest)
    (hUse : key.use = use)
    (hTarget : key.warrantId = targetId)
    (hLive : A.core.epi key = some .live) :
    A'.core.epi key = some .suspended := by
  apply challengeStep_liveAffected_suspended
    hStep hBinding hProfile hUse
  · rw [hTarget]
    exact challengeTarget_affected A.core targetId
  · exact hLive

/-- Every proper descendant is suspended wherever it is LIVE on matching
profile/use evaluation coordinates. -/
theorem challengeStep_descendant_live_suspended
    {A A' : AdoptState}
    {bindingId contextId use : String}
    {challengerId bridgeId targetId : WarrantId}
    {binding : CanonicalBinding}
    {key : EvalKey}
    (hStep : ChallengeStep A
      (.challenge bindingId contextId use challengerId bridgeId targetId) A')
    (hBinding : A.core.binding bindingId = some binding)
    (hProfile : key.profileDigest = binding.profileDigest)
    (hUse : key.use = use)
    (hDescendant : DescendantOf A.core targetId key.warrantId)
    (hLive : A.core.epi key = some .live) :
    A'.core.epi key = some .suspended := by
  exact challengeStep_liveAffected_suspended
    hStep hBinding hProfile hUse (descendant_affected hDescendant) hLive

/-- Proper affected descendants move from PLACED to PENDING. -/
theorem challengeStep_descendant_placed_pending
    {A A' : AdoptState}
    {bindingId contextId use : String}
    {challengerId bridgeId targetId : WarrantId}
    {binding : CanonicalBinding}
    {key : EvalKey}
    (hStep : ChallengeStep A
      (.challenge bindingId contextId use challengerId bridgeId targetId) A')
    (hBinding : A.core.binding bindingId = some binding)
    (hProfile : key.profileDigest = binding.profileDigest)
    (hUse : key.use = use)
    (hNe : key.warrantId ≠ targetId)
    (hDescendant : DescendantOf A.core targetId key.warrantId)
    (hPlaced : A.core.placement key = some .placed) :
    A'.core.placement key = some .pending := by
  rcases challengeStep_effect_exact hStep with
    ⟨actualBinding, hActualBinding, hPost⟩
  have hEq : actualBinding = binding :=
    Option.some.inj (hActualBinding.symm.trans hBinding)
  subst actualBinding
  subst A'
  apply challengePlacement_placed_affected
  · exact ⟨hProfile, hUse, hNe, descendant_affected hDescendant⟩
  · exact hPlaced

/-- The challenged target retains its placement exactly. -/
theorem challengeStep_targetPlacement_unchanged
    {A A' : AdoptState}
    {bindingId contextId use : String}
    {challengerId bridgeId targetId : WarrantId}
    {binding : CanonicalBinding}
    {key : EvalKey}
    (hStep : ChallengeStep A
      (.challenge bindingId contextId use challengerId bridgeId targetId) A')
    (hBinding : A.core.binding bindingId = some binding)
    (hTarget : key.warrantId = targetId) :
    A'.core.placement key = A.core.placement key := by
  rcases challengeStep_effect_exact hStep with
    ⟨actualBinding, hActualBinding, hPost⟩
  have hEq : actualBinding = binding :=
    Option.some.inj (hActualBinding.symm.trans hBinding)
  subst actualBinding
  subst A'
  exact challengePlacement_target_unchanged hTarget

end ResponsibilityTopology
