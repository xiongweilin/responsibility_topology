import ResponsibilityTopology.ContextCurrentness
import ResponsibilityTopology.HistoricalObjects

namespace ResponsibilityTopology

/-!
Reachable canonical-state skeleton, extended by #12 with the first historical
formation transition.

The state deliberately separates immutable canonical history from mutable
evaluation topology.  ROOT formation reads only canonical binding/context
history and writes only the historical warrant lookup.  Admission,
qualification, usability, INFER, TRANSPORT, license issuance, Adopt activation,
and challenge/revision remain outside this milestone.
-/

structure CanonicalBinding where
  profileDigest : String
  use : String
  scope : Scope
  deriving Repr, DecidableEq

structure CanonicalActivationLicense where
  issuer : ContextKey
  target : ContextKey
  deriving Repr, DecidableEq

structure CanonicalState where
  context : String → Option CanonicalContext
  profile : String → Prop
  binding : String → Option CanonicalBinding
  warrant : WarrantId → Option HistoricalWarrant
  license : ActivationLicenseId → Option CanonicalActivationLicense
  activeContext : ContextKey → Prop
  activationProvenance : ContextKey → Option Activation
  reviewRequired : ActivationLicenseId → Prop

private def addFact {α : Type} (P : α → Prop) (x : α) : α → Prop :=
  fun y => y = x ∨ P y

/-- Functional immutable-lookup insertion used by canonical history steps. -/
def putCanonical {α β : Type} [DecidableEq α]
    (M : α → Option β) (key : α) (value : β) : α → Option β :=
  fun x => if x = key then some value else M x

private theorem putCanonical_preserves_some
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

/-- Empty trusted starting boundary. -/
def emptyCanonicalState : CanonicalState where
  context := fun _ => none
  profile := fun _ => False
  binding := fun _ => none
  warrant := fun _ => none
  license := fun _ => none
  activeContext := fun _ => False
  activationProvenance := fun _ => none
  reviewRequired := fun _ => False

def InitialBoundary (S : CanonicalState) : Prop :=
  S = emptyCanonicalState

inductive KernelEvent where
  | registerContext (id : String) (context : CanonicalContext)
  | registerProfile (digest : String)
  | bindProfile (id : String) (binding : CanonicalBinding)
  | bootstrapContext (key : ContextKey)
  | root
      (warrantId : WarrantId)
      (bindingId contextId : String)
      (input : RootInput)
  deriving Repr

/-- ROOT has exactly the static history-plane preconditions used by Python
V0.1.2.2.  No active-context/binding or scope-within-binding premise is added. -/
inductive Step : CanonicalState → KernelEvent → CanonicalState → Prop where
  | registerContext
      {S : CanonicalState} {id : String} {context : CanonicalContext}
      (fresh : S.context id = none) :
      Step S (.registerContext id context)
        { S with context := putCanonical S.context id context }
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
        { S with binding := putCanonical S.binding id b }
  | bootstrapContext
      {S : CanonicalState} {key : ContextKey}
      (contextCanonical : ∃ context, S.context key.context = some context)
      (bindingCanonical :
        ∃ b, S.binding key.binding = some b ∧ b.use = key.use)
      (inactive : ¬ S.activeContext key)
      (freshActivation : S.activationProvenance key = none) :
      Step S (.bootstrapContext key)
        { S with
          activeContext := addFact S.activeContext key
          activationProvenance :=
            putCanonical S.activationProvenance key Activation.bootstrap }
  | root
      {S : CanonicalState}
      {warrantId : WarrantId}
      {bindingId contextId : String}
      {input : RootInput}
      {binding : CanonicalBinding}
      {context : CanonicalContext}
      (fresh : S.warrant warrantId = none)
      (bindingCanonical : S.binding bindingId = some binding)
      (contextCanonical : S.context contextId = some context)
      (accepted : context.accepts input.claim) :
      Step S (.root warrantId bindingId contextId input)
        { S with
          warrant := putCanonical S.warrant warrantId
            (rootHistoricalWarrant
              warrantId binding.profileDigest contextId input) }

inductive Reachable : CanonicalState → Prop where
  | initial {S : CanonicalState} : InitialBoundary S → Reachable S
  | step {S S' : CanonicalState} {event : KernelEvent} :
      Reachable S → Step S event S' → Reachable S'

def ContextKeyCanonical (S : CanonicalState) (key : ContextKey) : Prop :=
  (∃ context, S.context key.context = some context) ∧
    ∃ b, S.binding key.binding = some b ∧ b.use = key.use

def BindingReferentsCanonical (S : CanonicalState) : Prop :=
  ∀ ⦃id b⦄, S.binding id = some b → S.profile b.profileDigest

def ActiveContextReferentsCanonical (S : CanonicalState) : Prop :=
  ∀ ⦃key⦄, S.activeContext key → ContextKeyCanonical S key

def ActiveContextHasActivationProvenance (S : CanonicalState) : Prop :=
  ∀ ⦃key⦄, S.activeContext key →
    ∃ activation, S.activationProvenance key = some activation

def AdoptedActiveContextHasCanonicalLicense (S : CanonicalState) : Prop :=
  ∀ ⦃key licenseId⦄,
    S.activeContext key →
    S.activationProvenance key = some (Activation.adopt licenseId) →
    ∃ license,
      S.license licenseId = some license ∧
      license.target = key ∧
      ContextKeyCanonical S license.issuer

/-- Every historical warrant names canonical formation context/profile
referents.  Source authenticity is intentionally not part of this predicate. -/
def WarrantReferentsCanonical (S : CanonicalState) : Prop :=
  ∀ ⦃id warrant⦄,
    S.warrant id = some warrant →
    (∃ context, S.context warrant.formationContext = some context) ∧
      S.profile warrant.formationProfileDigest

/-- Every historical parent identifier resolves canonically. -/
def WarrantParentsCanonical (S : CanonicalState) : Prop :=
  ∀ ⦃id warrant parentId⦄,
    S.warrant id = some warrant →
    parentId ∈ warrant.parents →
    ∃ parent, S.warrant parentId = some parent

/-- Exact shape law for historical ROOT warrants. -/
def RootWarrantWellFormed (S : CanonicalState) : Prop :=
  ∀ ⦃id warrant⦄,
    S.warrant id = some warrant →
    warrant.constructor = .root →
    warrant.parents = [] ∧
      ∃ source,
        warrant.source = some source ∧
        (∀ role rootId,
          warrant.rootLineage role rootId ↔
            role = warrant.role ∧ rootId = id) ∧
        (∀ role sourceId,
          warrant.sourceLineage role sourceId ↔
            role = warrant.role ∧ sourceId = source)

/-- Every root-lineage warrant ID resolves in the same post-state. -/
def WarrantRootLineageCanonical (S : CanonicalState) : Prop :=
  ∀ ⦃id warrant role rootId⦄,
    S.warrant id = some warrant →
    warrant.rootLineage role rootId →
    ∃ root, S.warrant rootId = some root

structure CanonicalStateInvariant (S : CanonicalState) : Prop where
  bindingReferentsCanonical : BindingReferentsCanonical S
  activeContextReferentsCanonical : ActiveContextReferentsCanonical S
  activeContextHasActivationProvenance : ActiveContextHasActivationProvenance S
  adoptedActiveContextHasCanonicalLicense : AdoptedActiveContextHasCanonicalLicense S
  warrantReferentsCanonical : WarrantReferentsCanonical S
  warrantParentsCanonical : WarrantParentsCanonical S
  rootWarrantWellFormed : RootWarrantWellFormed S
  warrantRootLineageCanonical : WarrantRootLineageCanonical S

structure CanonicalIdsUnique (S : CanonicalState) : Prop where
  contextUnique : ∀ ⦃id c₁ c₂⦄,
    S.context id = some c₁ → S.context id = some c₂ → c₁ = c₂
  bindingUnique : ∀ ⦃id b₁ b₂⦄,
    S.binding id = some b₁ → S.binding id = some b₂ → b₁ = b₂
  warrantUnique : ∀ ⦃id w₁ w₂⦄,
    S.warrant id = some w₁ → S.warrant id = some w₂ → w₁ = w₂
  licenseUnique : ∀ ⦃id l₁ l₂⦄,
    S.license id = some l₁ → S.license id = some l₂ → l₁ = l₂
  activationUnique : ∀ ⦃key a₁ a₂⦄,
    S.activationProvenance key = some a₁ →
    S.activationProvenance key = some a₂ → a₁ = a₂

/-- Existing canonical history IDs keep their exact referents. -/
structure HistoryReferentsImmutable (S S' : CanonicalState) : Prop where
  contextImmutable : ∀ ⦃id context⦄,
    S.context id = some context → S'.context id = some context
  profileImmutable : ∀ ⦃digest⦄, S.profile digest → S'.profile digest
  bindingImmutable : ∀ ⦃id binding⦄,
    S.binding id = some binding → S'.binding id = some binding
  warrantImmutable : ∀ ⦃id warrant⦄,
    S.warrant id = some warrant → S'.warrant id = some warrant
  licenseImmutable : ∀ ⦃id license⦄,
    S.license id = some license → S'.license id = some license

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

def WellFormedActivationRead (R : ActivationRead) : Prop :=
  (∀ ⦃key⦄, R.seedActive key → ∃ a, R.activation key = some a) ∧
  (∀ ⦃key licenseId⦄,
      R.seedActive key →
      R.activation key = some (Activation.adopt licenseId) →
      ∃ issuer, R.issuerContext licenseId = some issuer)

theorem canonicalIdsUnique (S : CanonicalState) : CanonicalIdsUnique S := by
  constructor
  · intro id c₁ c₂ h₁ h₂
    exact Option.some.inj (h₁.symm.trans h₂)
  · intro id b₁ b₂ h₁ h₂
    exact Option.some.inj (h₁.symm.trans h₂)
  · intro id w₁ w₂ h₁ h₂
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
  constructor <;> intro <;> simp [
    BindingReferentsCanonical,
    ActiveContextReferentsCanonical,
    ActiveContextHasActivationProvenance,
    AdoptedActiveContextHasCanonicalLicense,
    WarrantReferentsCanonical,
    WarrantParentsCanonical,
    RootWarrantWellFormed,
    WarrantRootLineageCanonical,
    emptyCanonicalState] at *

theorem step_historyReferentsImmutable
    {S S' : CanonicalState} {event : KernelEvent}
    (hStep : Step S event S') :
    HistoryReferentsImmutable S S' := by
  cases hStep with
  | registerContext fresh =>
      constructor
      · intro id context h
        exact putCanonical_preserves_some fresh h
      · intro digest h
        exact h
      · intro id binding h
        exact h
      · intro id warrant h
        exact h
      · intro id license h
        exact h
  | registerProfile fresh =>
      constructor
      · intro id context h
        exact h
      · intro digest h
        exact Or.inr h
      · intro id binding h
        exact h
      · intro id warrant h
        exact h
      · intro id license h
        exact h
  | bindProfile fresh profileCanonical =>
      constructor
      · intro id context h
        exact h
      · intro digest h
        exact h
      · intro id binding h
        exact putCanonical_preserves_some fresh h
      · intro id warrant h
        exact h
      · intro id license h
        exact h
  | bootstrapContext contextCanonical bindingCanonical inactive freshActivation =>
      constructor
      · intro id context h
        exact h
      · intro digest h
        exact h
      · intro id binding h
        exact h
      · intro id warrant h
        exact h
      · intro id license h
        exact h
  | root fresh bindingCanonical contextCanonical accepted =>
      constructor
      · intro id context h
        exact h
      · intro digest h
        exact h
      · intro id binding h
        exact h
      · intro id warrant h
        exact putCanonical_preserves_some fresh h
      · intro id license h
        exact h

theorem step_preserves_invariant
    {S S' : CanonicalState} {event : KernelEvent}
    (hInv : CanonicalStateInvariant S)
    (hStep : Step S event S') :
    CanonicalStateInvariant S' := by
  cases hStep with
  | @registerContext id context fresh =>
      constructor
      · exact hInv.bindingReferentsCanonical
      · intro key hActive
        rcases hInv.activeContextReferentsCanonical hActive with
          ⟨⟨oldContext, hContext⟩, hBinding⟩
        exact ⟨⟨oldContext, putCanonical_preserves_some fresh hContext⟩, hBinding⟩
      · exact hInv.activeContextHasActivationProvenance
      · intro key licenseId hActive hActivation
        rcases hInv.adoptedActiveContextHasCanonicalLicense hActive hActivation with
          ⟨license, hLicense, hTarget, ⟨⟨issuerContext, hIssuerContext⟩, hIssuerBinding⟩⟩
        exact ⟨license, hLicense, hTarget,
          ⟨⟨issuerContext, putCanonical_preserves_some fresh hIssuerContext⟩,
            hIssuerBinding⟩⟩
      · intro warrantId warrant hWarrant
        rcases hInv.warrantReferentsCanonical hWarrant with
          ⟨⟨formationContext, hFormationContext⟩, hProfile⟩
        exact ⟨⟨formationContext,
          putCanonical_preserves_some fresh hFormationContext⟩, hProfile⟩
      · exact hInv.warrantParentsCanonical
      · exact hInv.rootWarrantWellFormed
      · exact hInv.warrantRootLineageCanonical
  | @registerProfile digest fresh =>
      constructor
      · intro id binding hBinding
        exact Or.inr (hInv.bindingReferentsCanonical hBinding)
      · exact hInv.activeContextReferentsCanonical
      · exact hInv.activeContextHasActivationProvenance
      · exact hInv.adoptedActiveContextHasCanonicalLicense
      · intro warrantId warrant hWarrant
        rcases hInv.warrantReferentsCanonical hWarrant with
          ⟨hContext, hProfile⟩
        exact ⟨hContext, Or.inr hProfile⟩
      · exact hInv.warrantParentsCanonical
      · exact hInv.rootWarrantWellFormed
      · exact hInv.warrantRootLineageCanonical
  | @bindProfile id binding fresh profileCanonical =>
      constructor
      · intro id' binding' hLookup
        by_cases hEq : id' = id
        · subst id'
          have hEqBinding : binding' = binding := by
            simpa [putCanonical] using hLookup.symm
          subst binding'
          exact profileCanonical
        · have hOld : S.binding id' = some binding' := by
            simpa [putCanonical, hEq] using hLookup
          exact hInv.bindingReferentsCanonical hOld
      · intro key hActive
        rcases hInv.activeContextReferentsCanonical hActive with
          ⟨hContext, oldBinding, hLookup, hUse⟩
        refine ⟨hContext, oldBinding, ?_, hUse⟩
        exact putCanonical_preserves_some fresh hLookup
      · exact hInv.activeContextHasActivationProvenance
      · intro key licenseId hActive hActivation
        rcases hInv.adoptedActiveContextHasCanonicalLicense hActive hActivation with
          ⟨license, hLicense, hTarget, hIssuerContext, issuerBinding,
            hIssuerBinding, hIssuerUse⟩
        exact ⟨license, hLicense, hTarget, hIssuerContext, issuerBinding,
          putCanonical_preserves_some fresh hIssuerBinding, hIssuerUse⟩
      · exact hInv.warrantReferentsCanonical
      · exact hInv.warrantParentsCanonical
      · exact hInv.rootWarrantWellFormed
      · exact hInv.warrantRootLineageCanonical
  | @bootstrapContext key contextCanonical bindingCanonical inactive freshActivation =>
      constructor
      · exact hInv.bindingReferentsCanonical
      · intro key' hActive
        rcases hActive with hEq | hOld
        · subst key'
          exact ⟨contextCanonical, bindingCanonical⟩
        · exact hInv.activeContextReferentsCanonical hOld
      · intro key' hActive
        rcases hActive with hEq | hOld
        · subst key'
          exact ⟨Activation.bootstrap, by simp [putCanonical]⟩
        · rcases hInv.activeContextHasActivationProvenance hOld with
            ⟨activation, hLookup⟩
          refine ⟨activation, ?_⟩
          have hNe : key' ≠ key := by
            intro hEq
            subst key'
            exact inactive hOld
          simpa [putCanonical, hNe] using hLookup
      · intro key' licenseId hActive hActivation
        rcases hActive with hEq | hOld
        · subst key'
          simp [putCanonical] at hActivation
        · have hNe : key' ≠ key := by
            intro hEq
            subst key'
            exact inactive hOld
          have hOldActivation :
              S.activationProvenance key' =
                some (Activation.adopt licenseId) := by
            simpa [putCanonical, hNe] using hActivation
          exact hInv.adoptedActiveContextHasCanonicalLicense hOld hOldActivation
      · exact hInv.warrantReferentsCanonical
      · exact hInv.warrantParentsCanonical
      · exact hInv.rootWarrantWellFormed
      · exact hInv.warrantRootLineageCanonical
  | @root warrantId bindingId contextId input binding context
      fresh bindingCanonical contextCanonical accepted =>
      constructor
      · exact hInv.bindingReferentsCanonical
      · exact hInv.activeContextReferentsCanonical
      · exact hInv.activeContextHasActivationProvenance
      · exact hInv.adoptedActiveContextHasCanonicalLicense
      · intro id warrant hLookup
        by_cases hEq : id = warrantId
        · subst id
          have hWarrantEq :
              warrant = rootHistoricalWarrant warrantId
                binding.profileDigest contextId input := by
            simpa [putCanonical] using hLookup.symm
          subst warrant
          exact ⟨⟨context, contextCanonical⟩,
            hInv.bindingReferentsCanonical bindingCanonical⟩
        · have hOld : S.warrant id = some warrant := by
            simpa [putCanonical, hEq] using hLookup
          exact hInv.warrantReferentsCanonical hOld
      · intro id warrant parentId hLookup hParent
        by_cases hEq : id = warrantId
        · subst id
          have hWarrantEq :
              warrant = rootHistoricalWarrant warrantId
                binding.profileDigest contextId input := by
            simpa [putCanonical] using hLookup.symm
          subst warrant
          simp [rootHistoricalWarrant] at hParent
        · have hOld : S.warrant id = some warrant := by
            simpa [putCanonical, hEq] using hLookup
          rcases hInv.warrantParentsCanonical hOld hParent with
            ⟨parent, hParentLookup⟩
          exact ⟨parent, putCanonical_preserves_some fresh hParentLookup⟩
      · intro id warrant hLookup hConstructor
        by_cases hEq : id = warrantId
        · subst id
          have hWarrantEq :
              warrant = rootHistoricalWarrant warrantId
                binding.profileDigest contextId input := by
            simpa [putCanonical] using hLookup.symm
          subst warrant
          refine ⟨rfl, input.source, rfl, ?_, ?_⟩
          · intro role rootId
            rfl
          · intro role sourceId
            rfl
        · have hOld : S.warrant id = some warrant := by
            simpa [putCanonical, hEq] using hLookup
          exact hInv.rootWarrantWellFormed hOld hConstructor
      · intro id warrant role rootId hLookup hLineage
        by_cases hEq : id = warrantId
        · subst id
          have hWarrantEq :
              warrant = rootHistoricalWarrant warrantId
                binding.profileDigest contextId input := by
            simpa [putCanonical] using hLookup.symm
          subst warrant
          have hRootEq : rootId = warrantId := hLineage.2
          subst rootId
          exact ⟨rootHistoricalWarrant warrantId
            binding.profileDigest contextId input, by simp [putCanonical]⟩
        · have hOld : S.warrant id = some warrant := by
            simpa [putCanonical, hEq] using hLookup
          rcases hInv.warrantRootLineageCanonical hOld hLineage with
            ⟨root, hRootLookup⟩
          exact ⟨root, putCanonical_preserves_some fresh hRootLookup⟩

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
  (reachable_invariant hReachable).activeContextHasActivationProvenance

theorem reachable_adoptedActiveContextHasCanonicalLicense
    {S : CanonicalState}
    (hReachable : Reachable S) :
    AdoptedActiveContextHasCanonicalLicense S :=
  (reachable_invariant hReachable).adoptedActiveContextHasCanonicalLicense

theorem reachable_toActivationRead_wellFormed
    {S : CanonicalState}
    (hReachable : Reachable S)
    (baseCurrent : ActivationLicenseId → Prop) :
    WellFormedActivationRead (toActivationRead S baseCurrent) := by
  have hInv := reachable_invariant hReachable
  refine ⟨?_, ?_⟩
  · intro key hActive
    exact hInv.activeContextHasActivationProvenance hActive
  · intro key licenseId hActive hActivation
    rcases hInv.adoptedActiveContextHasCanonicalLicense hActive hActivation with
      ⟨license, hLicense, hTarget, hIssuer⟩
    exact ⟨license.issuer, by simp [toActivationRead, hLicense]⟩

end ResponsibilityTopology
