import ResponsibilityTopology.ContextCurrentness

namespace ResponsibilityTopology

/-!
Reachable canonical state skeleton.

This module deliberately does not model the full Python History/EvaluationState
surface.  It fixes the common logical home for later transition refinements:

  InitialBoundary -> Step -> Reachable -> CanonicalStateInvariant.

Only four constructor-shaped transitions are admitted here: context
registration, profile registration, profile binding, and explicit bootstrap
activation.  Warrant formation, license issuance, Adopt activation,
challenge/revision, revalidation, persistence, and Python operational semantics
remain outside this milestone.
-/

structure CanonicalBinding where
  profileDigest : String
  use : String
  scope : Scope
  deriving Repr, DecidableEq

/-- Minimal immutable header needed by the currentness layer once Adopt
activation is added by a later transition milestone.  #10 does not itself add a
license-issuance or Adopt transition. -/
structure CanonicalActivationLicense where
  issuer : ContextKey
  target : ContextKey
  deriving Repr, DecidableEq

/-- Canonical state surface intentionally kept smaller than the Python runtime.
Fields are relations/lookups rather than a commitment to a final storage schema. -/
structure CanonicalState where
  context : String → Prop
  profile : String → Prop
  binding : String → Option CanonicalBinding
  warrant : WarrantId → Prop
  license : ActivationLicenseId → Option CanonicalActivationLicense
  activeContext : ContextKey → Prop
  activationProvenance : ContextKey → Option Activation
  reviewRequired : ActivationLicenseId → Prop

private def addFact {α : Type} (P : α → Prop) (x : α) : α → Prop :=
  fun y => y = x ∨ P y

private def putOption {α β : Type} [DecidableEq α]
    (M : α → Option β) (key : α) (value : β) : α → Option β :=
  fun x => if x = key then some value else M x

/-- Empty trusted starting boundary.  Later milestones may add explicit admission
transitions rather than weakening this boundary. -/
def emptyCanonicalState : CanonicalState where
  context := fun _ => False
  profile := fun _ => False
  binding := fun _ => none
  warrant := fun _ => False
  license := fun _ => none
  activeContext := fun _ => False
  activationProvenance := fun _ => none
  reviewRequired := fun _ => False

/-- The only initial state admitted by the #10 skeleton. -/
def InitialBoundary (S : CanonicalState) : Prop :=
  S = emptyCanonicalState

inductive KernelEvent where
  | registerContext (id : String)
  | registerProfile (digest : String)
  | bindProfile (id : String) (binding : CanonicalBinding)
  | bootstrapContext (key : ContextKey)
  deriving Repr

/-- Small transition surface whose purpose is to fix where later operational
semantics live.  Freshness prevents rebinding canonical identifiers. -/
inductive Step : CanonicalState → KernelEvent → CanonicalState → Prop where
  | registerContext
      {S : CanonicalState} {id : String}
      (fresh : ¬ S.context id) :
      Step S (.registerContext id)
        { S with context := addFact S.context id }
  | registerProfile
      {S : CanonicalState} {digest : String}
      (fresh : ¬ S.profile digest) :
      Step S (.registerProfile digest)
        { S with profile := addFact S.profile digest }
  | bindProfile
      {S : CanonicalState} {id : String} {b : CanonicalBinding}
      (fresh : S.binding id = none)
      (profileCanonical : S.profile b.profileDigest) :
      Step S (.bindProfile id b)
        { S with binding := putOption S.binding id b }
  | bootstrapContext
      {S : CanonicalState} {key : ContextKey}
      (contextCanonical : S.context key.context)
      (bindingCanonical :
        ∃ b, S.binding key.binding = some b ∧ b.use = key.use)
      (inactive : ¬ S.activeContext key)
      (freshActivation : S.activationProvenance key = none) :
      Step S (.bootstrapContext key)
        { S with
          activeContext := addFact S.activeContext key
          activationProvenance :=
            putOption S.activationProvenance key Activation.bootstrap }

/-- Reachability is generated only from the explicit initial boundary and
machine-described steps. -/
inductive Reachable : CanonicalState → Prop where
  | initial {S : CanonicalState} : InitialBoundary S → Reachable S
  | step {S S' : CanonicalState} {event : KernelEvent} :
      Reachable S → Step S event S' → Reachable S'

/-- A context key is structurally backed by a canonical context and a binding
whose declared use exactly matches the key. -/
def ContextKeyCanonical (S : CanonicalState) (key : ContextKey) : Prop :=
  S.context key.context ∧
    ∃ b, S.binding key.binding = some b ∧ b.use = key.use

/-- Every canonical binding points at a registered profile digest. -/
def BindingReferentsCanonical (S : CanonicalState) : Prop :=
  ∀ ⦃id b⦄, S.binding id = some b → S.profile b.profileDigest

/-- No active context key may float free of canonical context/binding referents. -/
def ActiveContextReferentsCanonical (S : CanonicalState) : Prop :=
  ∀ ⦃key⦄, S.activeContext key → ContextKeyCanonical S key

/-- Every active context carries an explicit activation provenance object. -/
def ActiveContextHasActivationProvenance (S : CanonicalState) : Prop :=
  ∀ ⦃key⦄, S.activeContext key →
    ∃ activation, S.activationProvenance key = some activation

/-- Future-stable Adopt invariant: if an active key is Adopt-activated, the
activation license is canonical, targets that exact key, and names a canonical
issuer key.  The #10 transition surface creates no Adopt activations yet. -/
def AdoptedActiveContextHasCanonicalLicense (S : CanonicalState) : Prop :=
  ∀ ⦃key licenseId⦄,
    S.activeContext key →
    S.activationProvenance key = some (Activation.adopt licenseId) →
    ∃ license,
      S.license licenseId = some license ∧
      license.target = key ∧
      ContextKeyCanonical S license.issuer

/-- Shared unary invariant intended to become the common precondition exported
by all later transition-refinement milestones. -/
def CanonicalStateInvariant (S : CanonicalState) : Prop :=
  BindingReferentsCanonical S ∧
  ActiveContextReferentsCanonical S ∧
  ActiveContextHasActivationProvenance S ∧
  AdoptedActiveContextHasCanonicalLicense S

/-- Functional canonical lookups cannot bind one identifier to two distinct
objects.  This is a modeling invariant independent of reachability. -/
def CanonicalIdsUnique (S : CanonicalState) : Prop :=
  (∀ ⦃id b₁ b₂⦄,
      S.binding id = some b₁ → S.binding id = some b₂ → b₁ = b₂) ∧
  (∀ ⦃id l₁ l₂⦄,
      S.license id = some l₁ → S.license id = some l₂ → l₁ = l₂) ∧
  (∀ ⦃key a₁ a₂⦄,
      S.activationProvenance key = some a₁ →
      S.activationProvenance key = some a₂ → a₁ = a₂)

/-- Binary append-only/history-stability property.  Existing canonical history
referents are not rebound by a step.  Evaluation topology/facts such as
activation provenance, active context, and review-required are intentionally
not classified as immutable history. -/
def HistoryReferentsImmutable (S S' : CanonicalState) : Prop :=
  (∀ ⦃id⦄, S.context id → S'.context id) ∧
  (∀ ⦃digest⦄, S.profile digest → S'.profile digest) ∧
  (∀ ⦃id b⦄, S.binding id = some b → S'.binding id = some b) ∧
  (∀ ⦃w⦄, S.warrant w → S'.warrant w) ∧
  (∀ ⦃id license⦄, S.license id = some license → S'.license id = some license)

/-- #8 read projected from a canonical state.  Base-currentness remains an
external judgment at #10; the point here is to make seed/provenance/issuer
observations come from one state. -/
def toActivationRead
    (S : CanonicalState)
    (baseCurrent : ActivationLicenseId → Prop) : ActivationRead where
  seedActive := S.activeContext
  activation := S.activationProvenance
  issuerContext := fun licenseId =>
    match S.license licenseId with
    | none => none
    | some license => some license.issuer
  baseCurrent := baseCurrent

/-- Minimal well-formedness expected by grounded-currentness projection:
seed-active keys have provenance, and adopted active keys have a resolvable
issuer. -/
def WellFormedActivationRead (R : ActivationRead) : Prop :=
  (∀ ⦃key⦄, R.seedActive key → ∃ a, R.activation key = some a) ∧
  (∀ ⦃key licenseId⦄,
      R.seedActive key →
      R.activation key = some (Activation.adopt licenseId) →
      ∃ issuer, R.issuerContext licenseId = some issuer)

theorem canonicalIdsUnique (S : CanonicalState) : CanonicalIdsUnique S := by
  refine ⟨?_, ?_, ?_⟩
  · intro id b₁ b₂ h₁ h₂
    exact Option.some.inj (h₁.symm.trans h₂)
  · intro id l₁ l₂ h₁ h₂
    exact Option.some.inj (h₁.symm.trans h₂)
  · intro key a₁ a₂ h₁ h₂
    exact Option.some.inj (h₁.symm.trans h₂)

theorem initialBoundary_invariant
    {S : CanonicalState}
    (hInitial : InitialBoundary S) :
    CanonicalStateInvariant S := by
  subst S
  refine ⟨?_, ?_, ?_, ?_⟩
  · intro id b h
    cases h
  · intro key h
    cases h
  · intro key h
    cases h
  · intro key licenseId h
    cases h

theorem step_historyReferentsImmutable
    {S S' : CanonicalState} {event : KernelEvent}
    (hStep : Step S event S') :
    HistoryReferentsImmutable S S' := by
  cases hStep with
  | registerContext fresh =>
      refine ⟨?_, ?_, ?_, ?_, ?_⟩
      · intro id h
        exact Or.inr h
      · intro digest h
        exact h
      · intro id b h
        exact h
      · intro w h
        exact h
      · intro id license h
        exact h
  | registerProfile fresh =>
      refine ⟨?_, ?_, ?_, ?_, ?_⟩
      · intro id h
        exact h
      · intro digest h
        exact Or.inr h
      · intro id b h
        exact h
      · intro w h
        exact h
      · intro id license h
        exact h
  | @bindProfile id b fresh profileCanonical =>
      refine ⟨?_, ?_, ?_, ?_, ?_⟩
      · intro contextId h
        exact h
      · intro digest h
        exact h
      · intro id' b' hLookup
        by_cases hEq : id' = id
        · rw [hEq, fresh] at hLookup
          cases hLookup
        · simpa [putOption, hEq] using hLookup
      · intro w h
        exact h
      · intro licenseId license h
        exact h
  | @bootstrapContext key contextCanonical bindingCanonical inactive freshActivation =>
      refine ⟨?_, ?_, ?_, ?_, ?_⟩
      · intro contextId h
        exact h
      · intro digest h
        exact h
      · intro id b h
        exact h
      · intro w h
        exact h
      · intro licenseId license h
        exact h

theorem step_preserves_invariant
    {S S' : CanonicalState} {event : KernelEvent}
    (hInv : CanonicalStateInvariant S)
    (hStep : Step S event S') :
    CanonicalStateInvariant S' := by
  rcases hInv with ⟨hBinding, hActiveRefs, hProvenance, hAdopt⟩
  cases hStep with
  | registerContext fresh =>
      refine ⟨?_, ?_, ?_, ?_⟩
      · exact hBinding
      · intro key hActive
        rcases hActiveRefs hActive with ⟨hContext, hKeyBinding⟩
        exact ⟨Or.inr hContext, hKeyBinding⟩
      · exact hProvenance
      · intro key licenseId hActive hActivation
        rcases hAdopt hActive hActivation with
          ⟨license, hLicense, hTarget, hIssuer⟩
        exact ⟨license, hLicense, hTarget,
          ⟨Or.inr hIssuer.1, hIssuer.2⟩⟩
  | registerProfile fresh =>
      refine ⟨?_, ?_, ?_, ?_⟩
      · intro id b hLookup
        exact Or.inr (hBinding hLookup)
      · exact hActiveRefs
      · exact hProvenance
      · exact hAdopt
  | @bindProfile id b fresh profileCanonical =>
      refine ⟨?_, ?_, ?_, ?_⟩
      · intro id' b' hLookup
        by_cases hEq : id' = id
        · have hNew : b' = b := by
            simpa [putOption, hEq] using hLookup.symm
          subst b'
          exact profileCanonical
        · have hOld : S.binding id' = some b' := by
            simpa [putOption, hEq] using hLookup
          exact hBinding hOld
      · intro key hActive
        rcases hActiveRefs hActive with ⟨hContext, oldBinding, hLookup, hUse⟩
        refine ⟨hContext, oldBinding, ?_, hUse⟩
        by_cases hEq : key.binding = id
        · rw [hEq, fresh] at hLookup
          cases hLookup
        · simpa [putOption, hEq] using hLookup
      · exact hProvenance
      · intro key licenseId hActive hActivation
        rcases hAdopt hActive hActivation with
          ⟨license, hLicense, hTarget, hIssuerContext, issuerBinding,
            hIssuerBinding, hIssuerUse⟩
        refine ⟨license, hLicense, hTarget, hIssuerContext, issuerBinding, ?_, hIssuerUse⟩
        by_cases hEq : license.issuer.binding = id
        · rw [hEq, fresh] at hIssuerBinding
          cases hIssuerBinding
        · simpa [putOption, hEq] using hIssuerBinding
  | @bootstrapContext key contextCanonical bindingCanonical inactive freshActivation =>
      refine ⟨hBinding, ?_, ?_, ?_⟩
      · intro key' hActive
        rcases hActive with hEq | hOld
        · subst key'
          exact ⟨contextCanonical, bindingCanonical⟩
        · exact hActiveRefs hOld
      · intro key' hActive
        rcases hActive with hEq | hOld
        · subst key'
          exact ⟨Activation.bootstrap, by simp [putOption]⟩
        · rcases hProvenance hOld with ⟨activation, hLookup⟩
          refine ⟨activation, ?_⟩
          have hNe : key' ≠ key := by
            intro hEq
            subst key'
            exact inactive hOld
          simpa [putOption, hNe] using hLookup
      · intro key' licenseId hActive hActivation
        rcases hActive with hEq | hOld
        · subst key'
          simp [putOption] at hActivation
        · have hNe : key' ≠ key := by
            intro hEq
            subst key'
            exact inactive hOld
          have hOldActivation :
              S.activationProvenance key' =
                some (Activation.adopt licenseId) := by
            simpa [putOption, hNe] using hActivation
          rcases hAdopt hOld hOldActivation with
            ⟨license, hLicense, hTarget, hIssuer⟩
          exact ⟨license, hLicense, hTarget, hIssuer⟩

/-- Every reachable state shares one invariant package rather than requiring
operation-specific well-formedness hypotheses. -/
theorem reachable_invariant
    {S : CanonicalState}
    (hReachable : Reachable S) :
    CanonicalStateInvariant S := by
  induction hReachable with
  | initial hInitial =>
      exact initialBoundary_invariant hInitial
  | step hReachable hStep ih =>
      exact step_preserves_invariant ih hStep

theorem reachable_canonicalIdsUnique
    {S : CanonicalState}
    (_hReachable : Reachable S) :
    CanonicalIdsUnique S :=
  canonicalIdsUnique S

theorem reachable_activeContextHasActivationProvenance
    {S : CanonicalState}
    (hReachable : Reachable S) :
    ActiveContextHasActivationProvenance S :=
  (reachable_invariant hReachable).2.2.1

theorem reachable_adoptedActiveContextHasCanonicalLicense
    {S : CanonicalState}
    (hReachable : Reachable S) :
    AdoptedActiveContextHasCanonicalLicense S :=
  (reachable_invariant hReachable).2.2.2

/-- Reachability closes the structural side of #8's arbitrary ActivationRead:
seed/provenance/issuer observations projected from a reachable canonical state
are well formed.  BaseCurrent remains deliberately external. -/
theorem reachable_toActivationRead_wellFormed
    {S : CanonicalState}
    (hReachable : Reachable S)
    (baseCurrent : ActivationLicenseId → Prop) :
    WellFormedActivationRead (toActivationRead S baseCurrent) := by
  have hInv := reachable_invariant hReachable
  refine ⟨?_, ?_⟩
  · intro key hActive
    exact hInv.2.2.1 hActive
  · intro key licenseId hActive hActivation
    rcases hInv.2.2.2 hActive hActivation with
      ⟨license, hLicense, hTarget, hIssuer⟩
    exact ⟨license.issuer, by simp [toActivationRead, hLicense]⟩

end ResponsibilityTopology
