import ResponsibilityTopology.RepairMinimality

namespace ResponsibilityTopology

/-!
Reachable revalidation lifecycle.

This is a Paper 3 formal lifecycle extension, not a Python-refinement theorem.
The V0.1.2 reference runtime has challenge/revision, review marking, fixed-point
context refresh, and re-activation of non-ACTIVE contexts with a current Adopt
license, but no standalone generic `revalidate` operation.  The formal layer
therefore gives each repair action a narrow proof-carrying transition.

The four responsibility layers remain distinct throughout:

* historical well-formedness is never repaired by these events;
* warrant revalidation reuses an existing ROOT/INFER/TRANSPORT qualification
  `Step` and restores `Usable` only at its exact evaluation key;
* license revalidation clears review only after every other BaseCurrent premise
  is already re-established;
* context revalidation restores seed activity only from immutable Adopt
  provenance, a BaseCurrent activation license, and a Grounded issuer.  The
  final fixed-point refresh then confirms context currentness.
-/

/-- The qualification event must name the exact evaluation key and binding whose
profile digest is that key's profile. -/
def QualificationEventForKey
    (event : KernelEvent)
    (key : EvalKey)
    (bindingId : String) : Prop :=
  match event with
  | .admitRoot warrantId observedBinding contextId use _ =>
      observedBinding = bindingId ∧
      warrantId = key.warrantId ∧
      contextId = key.contextId ∧
      use = key.use
  | .qualifyInfer warrantId observedBinding contextId use _ =>
      observedBinding = bindingId ∧
      warrantId = key.warrantId ∧
      contextId = key.contextId ∧
      use = key.use
  | .qualifyTransport warrantId observedBinding contextId use _ =>
      observedBinding = bindingId ∧
      warrantId = key.warrantId ∧
      contextId = key.contextId ∧
      use = key.use
  | _ => False

/-- Warrant revalidation does not invent a new generic qualification rule.  It
must be witnessed by one of the already trusted qualification `Step`s for the
exact key. -/
def WarrantRevalidationAllowed
    (A : AdoptState)
    (key : EvalKey) : Prop :=
  ∃ event bindingId binding,
    QualificationEventForKey event key bindingId ∧
    A.core.binding bindingId = some binding ∧
    binding.profileDigest = key.profileDigest ∧
    Step A.core event (qualifyEvaluation A.core key)

/-- Warrant repair writes only the ordinary qualification result. -/
def revalidateWarrantState
    (A : AdoptState)
    (key : EvalKey) : AdoptState where
  core := qualifyEvaluation A.core key
  adoptLicense := A.adoptLicense

/-- Every BaseCurrent premise except the review flag itself.  Clearing review is
permitted only after this predicate holds. -/
def AdoptLicenseRepairReady
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
      ∃ warrant,
        S.warrant warrantId = some warrant ∧
        Usable S
          ⟨L.profileDigest, L.issuer.context, L.issuer.use, warrantId⟩

private def clearReviewFact
    (P : ActivationLicenseId → Prop)
    (licenseId : ActivationLicenseId) : ActivationLicenseId → Prop :=
  fun observed => observed ≠ licenseId ∧ P observed

/-- License repair changes only the review-required predicate. -/
def revalidateLicenseState
    (A : AdoptState)
    (licenseId : ActivationLicenseId) : AdoptState where
  core := {
    A.core with
    reviewRequired := clearReviewFact A.core.reviewRequired licenseId
  }
  adoptLicense := A.adoptLicense

private def addRepairActiveFact
    (P : ContextKey → Prop)
    (key : ContextKey) : ContextKey → Prop :=
  fun observed => observed = key ∨ P observed

/-- Context repair restores seed activity while leaving its immutable activation
provenance unchanged.  This is the formal counterpart of re-activating a
non-ACTIVE context with its historical Adopt license after dependencies recover. -/
def revalidateContextState
    (A : AdoptState)
    (key : ContextKey) : AdoptState where
  core := {
    A.core with
    activeContext := addRepairActiveFact A.core.activeContext key
  }
  adoptLicense := A.adoptLicense

/-- Clearing review after all other currentness premises have recovered makes the
exact represented Adopt license BaseCurrent again. -/
theorem revalidateLicenseState_makes_baseCurrent
    {A : AdoptState}
    {licenseId : ActivationLicenseId}
    {L : CanonicalAdoptLicense}
    (hReady : AdoptLicenseRepairReady A.core L) :
    AdoptLicenseBaseCurrent
      (revalidateLicenseState A licenseId).core licenseId L := by
  rcases hReady with
    ⟨binding, issuerContext, targetContext, hBinding, hIssuerContext,
      hTargetContext, hTargetBinding, hTargetUse, hProfile, hUse,
      hScope, hSupport⟩
  refine ⟨binding, issuerContext, targetContext, hBinding, hIssuerContext,
    hTargetContext, hTargetBinding, hTargetUse, hProfile, hUse, ?_, hScope, hSupport⟩
  intro hReview
  exact hReview.1 rfl

/-- Adding one context back to the seed-active predicate preserves Groundedness
of every context that was already Grounded.  All non-seed activation-read
observations are definitionally unchanged by this state update. -/
theorem grounded_preserved_by_context_revalidation
    (A : AdoptState)
    (added : ContextKey)
    {key : ContextKey}
    (hGrounded : Grounded A.toLicenseRead.toActivationRead key) :
    Grounded
      (revalidateContextState A added).toLicenseRead.toActivationRead key := by
  induction hGrounded with
  | bootstrap seed activation =>
      exact Grounded.bootstrap (Or.inr seed) activation
  | adopt seed activation baseCurrent issuerContext issuerGrounded ih =>
      exact Grounded.adopt
        (Or.inr seed) activation baseCurrent issuerContext ih

/-- If an inactive context still has immutable Adopt provenance and its exact
activation license has recovered BaseCurrent with a Grounded issuer, restoring
seed activity immediately gives a Grounded derivation for that context. -/
theorem revalidateContextState_makes_grounded
    {A : AdoptState}
    {key : ContextKey}
    {licenseId : ActivationLicenseId}
    {L : CanonicalAdoptLicense}
    (hActivation :
      A.core.activationProvenance key = some (Activation.adopt licenseId))
    (hLicense : A.adoptLicense licenseId = some L)
    (_hTarget : L.target = key)
    (hBase : AdoptLicenseBaseCurrent A.core licenseId L)
    (hIssuerGrounded :
      Grounded A.toLicenseRead.toActivationRead L.issuer) :
    Grounded
      (revalidateContextState A key).toLicenseRead.toActivationRead key := by
  apply Grounded.adopt
  · exact Or.inl rfl
  · exact hActivation
  · exact ⟨L, hLicense, hBase⟩
  · exact adoptActivationRead_issuer_exact
      (revalidateContextState A key).toLicenseRead hLicense
  · exact grounded_preserved_by_context_revalidation A key hIssuerGrounded

/-- Narrow executable meaning of the three semantic repair-action labels. -/
inductive RepairActionStep :
    AdoptState → RepairAction → AdoptState → Prop where
  | warrant
      {A : AdoptState}
      {key : EvalKey}
      (allowed : WarrantRevalidationAllowed A key) :
      RepairActionStep A (.revalidateWarrant key)
        (revalidateWarrantState A key)
  | license
      {A : AdoptState}
      {licenseId : ActivationLicenseId}
      {L : CanonicalAdoptLicense}
      (licenseCanonical : A.adoptLicense licenseId = some L)
      (ready : AdoptLicenseRepairReady A.core L) :
      RepairActionStep A (.revalidateLicense licenseId)
        (revalidateLicenseState A licenseId)
  | context
      {A : AdoptState}
      {key : ContextKey}
      {licenseId : ActivationLicenseId}
      {L : CanonicalAdoptLicense}
      (inactive : ¬ A.core.activeContext key)
      (activation :
        A.core.activationProvenance key = some (Activation.adopt licenseId))
      (licenseCanonical : A.adoptLicense licenseId = some L)
      (targetExact : L.target = key)
      (baseCurrent : AdoptLicenseBaseCurrent A.core licenseId L)
      (issuerGrounded :
        Grounded A.toLicenseRead.toActivationRead L.issuer) :
      RepairActionStep A (.revalidateContext key)
        (revalidateContextState A key)

/-- Warrant repair restores exactly LIVE/PLACED usability at its selected key. -/
theorem repairActionStep_warrant_makes_usable
    {A A' : AdoptState}
    {key : EvalKey}
    (hStep : RepairActionStep A (.revalidateWarrant key) A') :
    Usable A'.core key := by
  cases hStep with
  | warrant allowed =>
      exact qualifyEvaluation_exact A.core key

/-- License repair restores BaseCurrent for the exact enriched record whose
review flag was cleared. -/
theorem repairActionStep_license_makes_baseCurrent
    {A A' : AdoptState}
    {licenseId : ActivationLicenseId}
    (hStep : RepairActionStep A (.revalidateLicense licenseId) A') :
    ∃ L,
      A'.adoptLicense licenseId = some L ∧
      AdoptLicenseBaseCurrent A'.core licenseId L := by
  cases hStep with
  | license licenseCanonical ready =>
      exact ⟨_, licenseCanonical,
        revalidateLicenseState_makes_baseCurrent ready⟩

/-- Context repair restores both seed activity and a Grounded currentness
certificate; the final refresh therefore retains it. -/
theorem repairActionStep_context_makes_grounded
    {A A' : AdoptState}
    {key : ContextKey}
    (hStep : RepairActionStep A (.revalidateContext key) A') :
    A'.core.activeContext key ∧
      Grounded A'.toLicenseRead.toActivationRead key := by
  cases hStep with
  | context inactive activation licenseCanonical targetExact baseCurrent
      issuerGrounded =>
      constructor
      · exact Or.inl rfl
      · exact revalidateContextState_makes_grounded
          activation licenseCanonical targetExact baseCurrent issuerGrounded

/-- None of the repair actions rewrites canonical historical referents. -/
theorem repairActionStep_historyReferentsImmutable
    {A A' : AdoptState}
    {action : RepairAction}
    (hStep : RepairActionStep A action A') :
    HistoryReferentsImmutable A.core A'.core := by
  cases hStep with
  | warrant allowed =>
      rcases allowed with
        ⟨event, bindingId, binding, hEvent, hBinding, hProfile, hCoreStep⟩
      exact step_historyReferentsImmutable hCoreStep
  | license licenseCanonical ready =>
      constructor <;> intro <;> intro <;> intro h <;> exact h
  | context inactive activation licenseCanonical targetExact baseCurrent
      issuerGrounded =>
      constructor <;> intro <;> intro <;> intro h <;> exact h

/-- A finite ordered execution trace realizes an unordered repair set only after
its action order has been chosen.  This keeps dependency-sensitive execution
order separate from the set-level sufficiency/minimality theorems. -/
inductive RevalidationTrace :
    AdoptState → List RepairAction → AdoptState → Prop where
  | nil {A : AdoptState} : RevalidationTrace A [] A
  | cons
      {A A₁ A₂ : AdoptState}
      {action : RepairAction}
      {rest : List RepairAction}
      (head : RepairActionStep A action A₁)
      (tail : RevalidationTrace A₁ rest A₂) :
      RevalidationTrace A (action :: rest) A₂

/-- Predicate-set represented by a concrete execution trace. -/
def TraceActionSet (actions : List RepairAction) : RepairActionSet :=
  fun action => action ∈ actions

/-- Reachability layer combining the prior challenge/refresh transitions with
explicit repair actions. -/
inductive RevalidationEvent where
  | prior (event : RefreshEvent)
  | repair (action : RepairAction)

inductive RevalidationStep :
    AdoptState → RevalidationEvent → AdoptState → Prop where
  | prior
      {A A' : AdoptState}
      {event : RefreshEvent}
      (step : RefreshStep A event A') :
      RevalidationStep A (.prior event) A'
  | repair
      {A A' : AdoptState}
      {action : RepairAction}
      (step : RepairActionStep A action A') :
      RevalidationStep A (.repair action) A'

inductive RevalidationReachable : AdoptState → Prop where
  | initial {A : AdoptState} :
      AdoptInitialBoundary A → RevalidationReachable A
  | step
      {A A' : AdoptState}
      {event : RevalidationEvent} :
      RevalidationReachable A →
      RevalidationStep A event A' →
      RevalidationReachable A'

/-- Every refresh-reachable state embeds unchanged into the revalidation layer. -/
theorem refreshReachable_to_revalidationReachable
    {A : AdoptState}
    (hReachable : RefreshReachable A) :
    RevalidationReachable A := by
  induction hReachable with
  | initial hInitial => exact .initial hInitial
  | step hReachable hStep ih =>
      exact .step ih (.prior hStep)

/-- A concrete repair trace extends revalidation reachability. -/
theorem revalidationTrace_preserves_reachability
    {A A' : AdoptState}
    {actions : List RepairAction}
    (hReachable : RevalidationReachable A)
    (hTrace : RevalidationTrace A actions A') :
    RevalidationReachable A' := by
  induction hTrace with
  | nil => exact hReachable
  | cons head tail ih =>
      exact ih (.step hReachable (.repair head))

/-- A context restored by the dedicated context-revalidation action survives the
immediately following fixed-point refresh. -/
theorem contextRevalidation_survives_refresh
    {A A₁ A₂ : AdoptState}
    {key : ContextKey}
    (hRepair : RepairActionStep A (.revalidateContext key) A₁)
    (hRefresh : RefreshStep A₁ .refresh A₂) :
    A₂.core.activeContext key := by
  have hEq := refreshStep_exact hRefresh
  subst A₂
  exact (repairActionStep_context_makes_grounded hRepair).2

/-- Conditional adjacent Paper 3 restoration theorem.

The challenge, first refresh, and ordered trace witness the intended lifecycle;
`RepairSet` plus a sound `RepairRealization` provide the restoration argument,
and the final refresh preserves the restored target obligation.  This theorem
itself does not assert that the states are reachable from the formal initial
boundary.

  S₀ --challenge--> S₁ --refresh--> S₂
     --revalidate(actions)--> S₃ --refresh--> S₄
-/
theorem revalidation_lifecycle_restores
    {S₀ S₁ S₂ S₃ S₄ : AdoptState}
    {bindingId contextId use : String}
    {challengerId bridgeId targetId : WarrantId}
    {actions : List RepairAction}
    {problem : RepairProblem S₂}
    (_hChallenge : ChallengeStep S₀
      (.challenge bindingId contextId use challengerId bridgeId targetId) S₁)
    (_hFirstRefresh : RefreshStep S₁ .refresh S₂)
    (_hTrace : RevalidationTrace S₂ actions S₃)
    (hRepairSet : RepairSet problem (TraceActionSet actions))
    (hRealization : RepairRealization problem (TraceActionSet actions) S₃)
    (hFinalRefresh : RefreshStep S₃ .refresh S₄) :
    problem.target.Holds S₄ := by
  have hEq := refreshStep_exact hFinalRefresh
  subst S₄
  exact repairSet_sufficient_after_refresh hRepairSet hRealization

/-- Reachability-strengthened lifecycle corollary.

If the pre-challenge state is reachable, the challenge, first refresh, ordered
repair trace, and final refresh all remain inside `RevalidationReachable`; the
same lifecycle also restores the target obligation. -/
theorem reachable_revalidation_lifecycle_restores
    {S₀ S₁ S₂ S₃ S₄ : AdoptState}
    {bindingId contextId use : String}
    {challengerId bridgeId targetId : WarrantId}
    {actions : List RepairAction}
    {problem : RepairProblem S₂}
    (hReachable : RevalidationReachable S₀)
    (hChallenge : ChallengeStep S₀
      (.challenge bindingId contextId use challengerId bridgeId targetId) S₁)
    (hFirstRefresh : RefreshStep S₁ .refresh S₂)
    (hTrace : RevalidationTrace S₂ actions S₃)
    (hRepairSet : RepairSet problem (TraceActionSet actions))
    (hRealization : RepairRealization problem (TraceActionSet actions) S₃)
    (hFinalRefresh : RefreshStep S₃ .refresh S₄) :
    RevalidationReachable S₄ ∧ problem.target.Holds S₄ := by
  have hS₁ : RevalidationReachable S₁ :=
    RevalidationReachable.step hReachable
      (RevalidationStep.prior (RefreshStep.prior hChallenge))
  have hS₂ : RevalidationReachable S₂ :=
    RevalidationReachable.step hS₁ (RevalidationStep.prior hFirstRefresh)
  have hS₃ : RevalidationReachable S₃ :=
    revalidationTrace_preserves_reachability hS₂ hTrace
  have hS₄ : RevalidationReachable S₄ :=
    RevalidationReachable.step hS₃ (RevalidationStep.prior hFinalRefresh)
  exact ⟨hS₄,
    revalidation_lifecycle_restores hChallenge hFirstRefresh hTrace
      hRepairSet hRealization hFinalRefresh⟩

end ResponsibilityTopology
