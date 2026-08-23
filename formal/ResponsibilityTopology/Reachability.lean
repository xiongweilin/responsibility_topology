import ResponsibilityTopology.ContextCurrentness
import ResponsibilityTopology.InferenceSemantics
import ResponsibilityTopology.TransportSemantics
import ResponsibilityTopology.EvaluationVocabulary

namespace ResponsibilityTopology

/-!
Reachable canonical-state model including TRANSPORT historical formation and
source-context qualification.

The state keeps immutable canonical history distinct from mutable evaluation
qualification. ROOT, INFER, and TRANSPORT formation write only historical
warrants. Qualification writes only evaluation state. TRANSPORT qualification
reads current responsibility at each stored parent's own formation context;
target-context activation, license issuance, revalidation, and challenge/revision
remain outside this milestone.
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
  profile : String → Option CanonicalProfile
  binding : String → Option CanonicalBinding
  warrant : WarrantId → Option HistoricalWarrant
  license : ActivationLicenseId → Option CanonicalActivationLicense
  activeContext : ContextKey → Prop
  activationProvenance : ContextKey → Option Activation
  reviewRequired : ActivationLicenseId → Prop
  epi : EvalKey → Option EpiStatus
  placement : EvalKey → Option Placement

/-- Current usability is exactly LIVE together with PLACED. Missing records and
all other represented status combinations are unusable. -/
def Usable (S : CanonicalState) (key : EvalKey) : Prop :=
  S.epi key = some .live ∧
    S.placement key = some .placed

/-- Current-parent responsibility consumed by ordinary INFER qualification.
The predicate is explicitly pre-state indexed. -/
def InferParentsUsable
    (S : CanonicalState)
    (profileDigest contextId use : String)
    (warrant : HistoricalWarrant) : Prop :=
  ∀ parentId,
    parentId ∈ warrant.parents →
    Usable S ⟨profileDigest, contextId, use, parentId⟩

/-- Current-parent responsibility consumed by TRANSPORT qualification.
Each stored historical parent is evaluated at its own formation context, not at
the transported child's target context. No source-context activation premise is
part of this predicate. -/
def TransportParentsUsable
    (S : CanonicalState)
    (profileDigest use : String)
    (originalId witnessId : WarrantId)
    (original witness : HistoricalWarrant) : Prop :=
  Usable S
      ⟨profileDigest, original.formationContext, use, originalId⟩ ∧
    Usable S
      ⟨profileDigest, witness.formationContext, use, witnessId⟩

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

/-- Mutable evaluation setter. Unlike `putCanonical`, this intentionally has no
freshness premise: explicit qualification may overwrite an existing evaluation
position. -/
def setOptionAt {α β : Type} [DecidableEq α]
    (M : α → Option β) (key : α) (value : β) : α → Option β :=
  fun x => if x = key then some value else M x

/-- Shared evaluation qualification update. -/
def qualifyEvaluation (S : CanonicalState) (key : EvalKey) : CanonicalState :=
  { S with
    epi := setOptionAt S.epi key .live
    placement := setOptionAt S.placement key .placed }

/-- Qualification writes exactly LIVE/PLACED at its selected key. -/
theorem qualifyEvaluation_exact
    (S : CanonicalState) (key : EvalKey) :
    (qualifyEvaluation S key).epi key = some .live ∧
      (qualifyEvaluation S key).placement key = some .placed := by
  simp [qualifyEvaluation, setOptionAt]

/-- Qualification is local: every other evaluation key is unchanged. -/
theorem qualifyEvaluation_otherKey_unchanged
    (S : CanonicalState) {key other : EvalKey}
    (hNe : other ≠ key) :
    (qualifyEvaluation S key).epi other = S.epi other ∧
      (qualifyEvaluation S key).placement other = S.placement other := by
  simp [qualifyEvaluation, setOptionAt, hNe]

/-- Ordered, duplicate-preserving resolution of historical parent IDs. -/
inductive ResolvesParents
    (S : CanonicalState) : List WarrantId → List HistoricalWarrant → Prop where
  | nil : ResolvesParents S [] []
  | cons {id : WarrantId} {parent : HistoricalWarrant}
      {ids : List WarrantId} {parents : List HistoricalWarrant}
      (lookup : S.warrant id = some parent)
      (tail : ResolvesParents S ids parents) :
      ResolvesParents S (id :: ids) (parent :: parents)

namespace ResolvesParents

/-- Every parent-ID occurrence resolves to a correspondingly present historical
object; order and duplicate occurrences are not erased. -/
theorem lookup_of_id_mem
    {S : CanonicalState} {ids : List WarrantId}
    {parents : List HistoricalWarrant}
    (hResolve : ResolvesParents S ids parents)
    {id : WarrantId} (hMem : id ∈ ids) :
    ∃ parent, parent ∈ parents ∧ S.warrant id = some parent := by
  induction hResolve with
  | nil => cases hMem
  | @cons head parent tailIds tailParents hLookup hTail ih =>
      cases hMem with
      | head =>
          exact ⟨parent, List.Mem.head tailParents, hLookup⟩
      | tail _ hTailMem =>
          rcases ih hTailMem with ⟨found, hFoundMem, hFoundLookup⟩
          exact ⟨found, List.Mem.tail parent hFoundMem, hFoundLookup⟩

/-- Every resolved parent-object occurrence comes from some parent ID. -/
theorem id_of_parent_mem
    {S : CanonicalState} {ids : List WarrantId}
    {parents : List HistoricalWarrant}
    (hResolve : ResolvesParents S ids parents)
    {parent : HistoricalWarrant} (hMem : parent ∈ parents) :
    ∃ id, id ∈ ids ∧ S.warrant id = some parent := by
  induction hResolve with
  | nil => cases hMem
  | @cons head headParent tailIds tailParents hLookup hTail ih =>
      cases hMem with
      | head =>
          exact ⟨head, List.Mem.head tailIds, hLookup⟩
      | tail _ hTailMem =>
          rcases ih hTailMem with ⟨found, hFoundMem, hFoundLookup⟩
          exact ⟨found, List.Mem.tail head hFoundMem, hFoundLookup⟩

/-- Exact referent preservation lifts an ordered parent resolution unchanged. -/
theorem preserved
    {S S' : CanonicalState} {ids : List WarrantId}
    {parents : List HistoricalWarrant}
    (hResolve : ResolvesParents S ids parents)
    (hPreserve : ∀ ⦃id parent⦄,
      S.warrant id = some parent → S'.warrant id = some parent) :
    ResolvesParents S' ids parents := by
  induction hResolve with
  | nil => exact .nil
  | cons hLookup hTail ih =>
      exact .cons (hPreserve hLookup) ih

/-- A nonempty resolved parent-object list implies a nonempty ordered ID list. -/
theorem ids_nonempty_of_parents_nonempty
    {S : CanonicalState} {ids : List WarrantId}
    {parents : List HistoricalWarrant}
    (hResolve : ResolvesParents S ids parents)
    (hParents : parents ≠ []) :
    ids ≠ [] := by
  intro hIds
  subst ids
  cases hResolve
  exact hParents rfl

end ResolvesParents

/-- Empty trusted starting boundary. -/
def emptyCanonicalState : CanonicalState where
  context := fun _ => none
  profile := fun _ => none
  binding := fun _ => none
  warrant := fun _ => none
  license := fun _ => none
  activeContext := fun _ => False
  activationProvenance := fun _ => none
  reviewRequired := fun _ => False
  epi := fun _ => none
  placement := fun _ => none

def InitialBoundary (S : CanonicalState) : Prop :=
  S = emptyCanonicalState

inductive KernelEvent where
  | registerContext (id : String) (context : CanonicalContext)
  | registerProfile (digest : String) (profile : CanonicalProfile)
  | bindProfile (id : String) (binding : CanonicalBinding)
  | bootstrapContext (key : ContextKey)
  | root
      (warrantId : WarrantId)
      (bindingId contextId : String)
      (input : RootInput)
  | admitRoot
      (warrantId : WarrantId)
      (bindingId contextId use : String)
      (metadata : QualificationMetadata)
  | infer
      (warrantId : WarrantId)
      (bindingId contextId ruleId : String)
      (parentIds : List WarrantId)
      (outScope : Scope)
  | transport
      (warrantId : WarrantId)
      (bindingId targetContextId mapId : String)
      (originalId witnessId : WarrantId)
      (translatedClaim : Claim)
      (outScope : Scope)
  | qualifyInfer
      (warrantId : WarrantId)
      (bindingId contextId use : String)
      (metadata : QualificationMetadata)
  | qualifyTransport
      (warrantId : WarrantId)
      (bindingId targetContextId use : String)
      (metadata : QualificationMetadata)

/-- Formation and qualification transitions through source-current TRANSPORT
qualification. Formation does not consume parent usability; qualification does
not replay formation discipline. -/
inductive Step : CanonicalState → KernelEvent → CanonicalState → Prop where
  | registerContext
      {S : CanonicalState} {id : String} {context : CanonicalContext}
      (fresh : S.context id = none) :
      Step S (.registerContext id context)
        { S with context := putCanonical S.context id context }
  | registerProfile
      {S : CanonicalState} {digest : String} {profile : CanonicalProfile}
      (fresh : S.profile digest = none) :
      Step S (.registerProfile digest profile)
        { S with profile := putCanonical S.profile digest profile }
  | bindProfile
      {S : CanonicalState} {id : String} {b : CanonicalBinding}
      (fresh : S.binding id = none)
      (profileCanonical : ∃ profile, S.profile b.profileDigest = some profile) :
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
  | admitRoot
      {S : CanonicalState}
      {warrantId : WarrantId}
      {bindingId contextId use : String}
      {metadata : QualificationMetadata}
      {binding : CanonicalBinding}
      {context : CanonicalContext}
      {warrant : HistoricalWarrant}
      (bindingCanonical : S.binding bindingId = some binding)
      (contextCanonical : S.context contextId = some context)
      (warrantCanonical : S.warrant warrantId = some warrant)
      (isRoot : warrant.constructor = .root)
      (formationContext : warrant.formationContext = contextId)
      (formationProfile :
        warrant.formationProfileDigest = binding.profileDigest)
      (useMatches : binding.use = use) :
      Step S (.admitRoot warrantId bindingId contextId use metadata)
        (qualifyEvaluation S
          ⟨binding.profileDigest, contextId, use, warrantId⟩)
  | infer
      {S : CanonicalState}
      {warrantId : WarrantId}
      {bindingId contextId ruleId : String}
      {parentIds : List WarrantId}
      {outScope : Scope}
      {binding : CanonicalBinding}
      {profile : CanonicalProfile}
      {context : CanonicalContext}
      {rule : CanonicalRule}
      {parents : List HistoricalWarrant}
      (fresh : S.warrant warrantId = none)
      (bindingCanonical : S.binding bindingId = some binding)
      (profileCanonical : S.profile binding.profileDigest = some profile)
      (ruleExact : lookupRule profile ruleId = some rule)
      (contextCanonical : S.context contextId = some context)
      (parentsCanonical : ResolvesParents S parentIds parents)
      (discipline : InferFormationDiscipline
        context binding.profileDigest contextId rule parents outScope) :
      Step S (.infer warrantId bindingId contextId ruleId parentIds outScope)
        { S with
          warrant := putCanonical S.warrant warrantId
            (inferHistoricalWarrant
              ruleId binding.profileDigest contextId parentIds parents outScope rule) }
  | transport
      {S : CanonicalState}
      {warrantId originalId witnessId : WarrantId}
      {bindingId targetContextId mapId : String}
      {translatedClaim : Claim}
      {outScope : Scope}
      {binding : CanonicalBinding}
      {targetContext : CanonicalContext}
      {original witness : HistoricalWarrant}
      (fresh : S.warrant warrantId = none)
      (bindingCanonical : S.binding bindingId = some binding)
      (contextCanonical : S.context targetContextId = some targetContext)
      (originalCanonical : S.warrant originalId = some original)
      (witnessCanonical : S.warrant witnessId = some witness)
      (discipline : TransportFormationDiscipline
        targetContext binding.profileDigest targetContextId mapId
        originalId witnessId original witness translatedClaim original.role
        outScope [originalId, witnessId]) :
      Step S
        (.transport warrantId bindingId targetContextId mapId originalId witnessId
          translatedClaim outScope)
        { S with
          warrant := putCanonical S.warrant warrantId
            (transportHistoricalWarrant
              mapId binding.profileDigest targetContextId originalId witnessId
              original witness translatedClaim outScope) }
  | qualifyInfer
      {S : CanonicalState}
      {warrantId : WarrantId}
      {bindingId contextId use : String}
      {metadata : QualificationMetadata}
      {binding : CanonicalBinding}
      {warrant : HistoricalWarrant}
      (bindingCanonical : S.binding bindingId = some binding)
      (warrantCanonical : S.warrant warrantId = some warrant)
      (isInfer : ∃ ruleId, warrant.constructor = .infer ruleId)
      (formationContext : warrant.formationContext = contextId)
      (formationProfile : warrant.formationProfileDigest = binding.profileDigest)
      (parentsUsable : InferParentsUsable
        S binding.profileDigest contextId use warrant) :
      Step S (.qualifyInfer warrantId bindingId contextId use metadata)
        (qualifyEvaluation S
          ⟨binding.profileDigest, contextId, use, warrantId⟩)
  | qualifyTransport
      {S : CanonicalState}
      {warrantId originalId witnessId : WarrantId}
      {bindingId targetContextId use mapId : String}
      {metadata : QualificationMetadata}
      {binding : CanonicalBinding}
      {warrant original witness : HistoricalWarrant}
      (bindingCanonical : S.binding bindingId = some binding)
      (warrantCanonical : S.warrant warrantId = some warrant)
      (isTransport : warrant.constructor = .transport mapId)
      (parentsExact : warrant.parents = [originalId, witnessId])
      (originalCanonical : S.warrant originalId = some original)
      (witnessCanonical : S.warrant witnessId = some witness)
      (formationContext : warrant.formationContext = targetContextId)
      (formationProfile : warrant.formationProfileDigest = binding.profileDigest)
      (parentsUsable : TransportParentsUsable
        S binding.profileDigest use originalId witnessId original witness) :
      Step S (.qualifyTransport warrantId bindingId targetContextId use metadata)
        (qualifyEvaluation S
          ⟨binding.profileDigest, targetContextId, use, warrantId⟩)

inductive Reachable : CanonicalState → Prop where
  | initial {S : CanonicalState} : InitialBoundary S → Reachable S
  | step {S S' : CanonicalState} {event : KernelEvent} :
      Reachable S → Step S event S' → Reachable S'

def ContextKeyCanonical (S : CanonicalState) (key : ContextKey) : Prop :=
  (∃ context, S.context key.context = some context) ∧
    ∃ b, S.binding key.binding = some b ∧ b.use = key.use

def BindingReferentsCanonical (S : CanonicalState) : Prop :=
  ∀ ⦃id b⦄, S.binding id = some b →
    ∃ profile, S.profile b.profileDigest = some profile

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

/-- Every historical warrant names exact canonical formation context/profile
referents. -/
def WarrantReferentsCanonical (S : CanonicalState) : Prop :=
  ∀ ⦃id warrant⦄,
    S.warrant id = some warrant →
    (∃ context, S.context warrant.formationContext = some context) ∧
      ∃ profile, S.profile warrant.formationProfileDigest = some profile

/-- Every ordered historical parent identifier resolves canonically. -/
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

/-- Every root-lineage warrant ID resolves in the same state. -/
def WarrantRootLineageCanonical (S : CanonicalState) : Prop :=
  ∀ ⦃id warrant role rootId⦄,
    S.warrant id = some warrant →
    warrant.rootLineage role rootId →
    ∃ root, S.warrant rootId = some root

/-- Every historical INFER object can be replayed against the exact immutable
formation profile/rule and its ordered historical parents. -/
def InferWarrantWellFormed (S : CanonicalState) : Prop :=
  ∀ ⦃id warrant ruleId⦄,
    S.warrant id = some warrant →
    warrant.constructor = .infer ruleId →
    ∃ profile context rule parents,
      S.profile warrant.formationProfileDigest = some profile ∧
      S.context warrant.formationContext = some context ∧
      lookupRule profile ruleId = some rule ∧
      ResolvesParents S warrant.parents parents ∧
      InferFormationDiscipline
        context warrant.formationProfileDigest warrant.formationContext
        rule parents warrant.scope ∧
      warrant = inferHistoricalWarrant
        ruleId warrant.formationProfileDigest warrant.formationContext
        warrant.parents parents warrant.scope rule

/-- Every historical TRANSPORT object can recover the exact target context,
canonical original/witness parents, and the complete immutable formation
discipline. Qualification can later rely on this invariant without replaying
formation checks. -/
def TransportWarrantWellFormed (S : CanonicalState) : Prop :=
  ∀ ⦃id warrant mapId⦄,
    S.warrant id = some warrant →
    warrant.constructor = .transport mapId →
    ∃ targetContext originalId witnessId original witness,
      S.context warrant.formationContext = some targetContext ∧
      S.warrant originalId = some original ∧
      S.warrant witnessId = some witness ∧
      TransportFormationDiscipline
        targetContext warrant.formationProfileDigest warrant.formationContext
        mapId originalId witnessId original witness warrant.claim warrant.role
        warrant.scope warrant.parents ∧
      warrant = transportHistoricalWarrant
        mapId warrant.formationProfileDigest warrant.formationContext
        originalId witnessId original witness warrant.claim warrant.scope

/-- At least one evaluation axis is populated at this key. -/
def HasEvaluationRecord (S : CanonicalState) (key : EvalKey) : Prop :=
  (∃ status, S.epi key = some status) ∨
    ∃ placement, S.placement key = some placement

/-- Any evaluation record resolves to the same immutable historical warrant and
uses exactly its formation profile/context identity. -/
def EvaluationReferentsCanonical (S : CanonicalState) : Prop :=
  ∀ ⦃key⦄,
    HasEvaluationRecord S key →
    ∃ warrant,
      S.warrant key.warrantId = some warrant ∧
      warrant.formationProfileDigest = key.profileDigest ∧
      warrant.formationContext = key.contextId

/-- Evaluation positions are created as a pair. -/
def EvaluationPairCoherent (S : CanonicalState) : Prop :=
  ∀ key, S.epi key = none ↔ S.placement key = none

/-- Every populated evaluation profile/use pair is backed by some canonical
binding. This is provenance of the evaluation environment, not use adequacy. -/
def EvaluationProfileUseBackedByBinding (S : CanonicalState) : Prop :=
  ∀ ⦃key⦄,
    HasEvaluationRecord S key →
    ∃ bindingId binding,
      S.binding bindingId = some binding ∧
      binding.profileDigest = key.profileDigest ∧
      binding.use = key.use

structure CanonicalStateInvariant (S : CanonicalState) : Prop where
  bindingReferentsCanonical : BindingReferentsCanonical S
  activeContextReferentsCanonical : ActiveContextReferentsCanonical S
  activeContextHasActivationProvenance : ActiveContextHasActivationProvenance S
  adoptedActiveContextHasCanonicalLicense : AdoptedActiveContextHasCanonicalLicense S
  warrantReferentsCanonical : WarrantReferentsCanonical S
  warrantParentsCanonical : WarrantParentsCanonical S
  rootWarrantWellFormed : RootWarrantWellFormed S
  warrantRootLineageCanonical : WarrantRootLineageCanonical S
  inferWarrantWellFormed : InferWarrantWellFormed S
  evaluationReferentsCanonical : EvaluationReferentsCanonical S
  evaluationPairCoherent : EvaluationPairCoherent S
  evaluationProfileUseBackedByBinding : EvaluationProfileUseBackedByBinding S
  transportWarrantWellFormed : TransportWarrantWellFormed S

structure CanonicalIdsUnique (S : CanonicalState) : Prop where
  contextUnique : ∀ ⦃id c₁ c₂⦄,
    S.context id = some c₁ → S.context id = some c₂ → c₁ = c₂
  profileUnique : ∀ ⦃digest p₁ p₂⦄,
    S.profile digest = some p₁ → S.profile digest = some p₂ → p₁ = p₂
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
  profileImmutable : ∀ ⦃digest profile⦄,
    S.profile digest = some profile → S'.profile digest = some profile
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
  · intro digest p₁ p₂ h₁ h₂
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
  constructor <;> simp [
    BindingReferentsCanonical,
    ActiveContextReferentsCanonical,
    ActiveContextHasActivationProvenance,
    AdoptedActiveContextHasCanonicalLicense,
    WarrantReferentsCanonical,
    WarrantParentsCanonical,
    RootWarrantWellFormed,
    WarrantRootLineageCanonical,
    InferWarrantWellFormed,
    EvaluationReferentsCanonical,
    EvaluationPairCoherent,
    EvaluationProfileUseBackedByBinding,
    TransportWarrantWellFormed,
    HasEvaluationRecord,
    emptyCanonicalState]

theorem step_historyReferentsImmutable
    {S S' : CanonicalState} {event : KernelEvent}
    (hStep : Step S event S') :
    HistoryReferentsImmutable S S' := by
  cases hStep with
  | registerContext fresh =>
      constructor
      · intro id context h
        exact putCanonical_preserves_some fresh h
      · intro digest profile h
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
      · intro digest profile h
        exact putCanonical_preserves_some fresh h
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
      · intro digest profile h
        exact h
      · intro id binding h
        exact putCanonical_preserves_some fresh h
      · intro id warrant h
        exact h
      · intro id license h
        exact h
  | bootstrapContext contextCanonical bindingCanonical inactive freshActivation =>
      constructor <;> intros <;> assumption
  | root fresh bindingCanonical contextCanonical accepted =>
      constructor
      · intro id context h
        exact h
      · intro digest profile h
        exact h
      · intro id binding h
        exact h
      · intro id warrant h
        exact putCanonical_preserves_some fresh h
      · intro id license h
        exact h
  | admitRoot bindingCanonical contextCanonical warrantCanonical isRoot
      formationContext formationProfile useMatches =>
      constructor <;> intros <;> assumption
  | infer fresh bindingCanonical profileCanonical ruleExact contextCanonical
      parentsCanonical discipline =>
      constructor
      · intro id context h
        exact h
      · intro digest profile h
        exact h
      · intro id binding h
        exact h
      · intro id warrant h
        exact putCanonical_preserves_some fresh h
      · intro id license h
        exact h
  | transport fresh bindingCanonical contextCanonical originalCanonical
      witnessCanonical discipline =>
      constructor
      · intro id context h
        exact h
      · intro digest profile h
        exact h
      · intro id binding h
        exact h
      · intro id warrant h
        exact putCanonical_preserves_some fresh h
      · intro id license h
        exact h
  | qualifyInfer bindingCanonical warrantCanonical isInfer formationContext
      formationProfile parentsUsable =>
      constructor <;> intros <;> assumption
  | qualifyTransport bindingCanonical warrantCanonical isTransport parentsExact
      originalCanonical witnessCanonical formationContext formationProfile
      parentsUsable =>
      constructor <;> intros <;> assumption

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
      · intro warrantId warrant ruleId hWarrant hConstructor
        rcases hInv.inferWarrantWellFormed hWarrant hConstructor with
          ⟨profile, oldContext, rule, parents, hProfile, hContext, hRule,
            hParents, hDiscipline, hExact⟩
        exact ⟨profile, oldContext, rule, parents, hProfile,
          putCanonical_preserves_some fresh hContext, hRule,
          hParents.preserved (by intro parentId parent hLookup; exact hLookup),
          hDiscipline, hExact⟩
      · exact hInv.evaluationReferentsCanonical
      · exact hInv.evaluationPairCoherent
      · exact hInv.evaluationProfileUseBackedByBinding
      · intro warrantId warrant mapId hWarrant hConstructor
        rcases hInv.transportWarrantWellFormed hWarrant hConstructor with
          ⟨targetContext, originalId, witnessId, original, witness,
            hContext, hOriginal, hWitness, hDiscipline, hExact⟩
        exact ⟨targetContext, originalId, witnessId, original, witness,
          putCanonical_preserves_some fresh hContext,
          hOriginal, hWitness, hDiscipline, hExact⟩
  | @registerProfile digest profile fresh =>
      constructor
      · intro bindingId binding hBinding
        rcases hInv.bindingReferentsCanonical hBinding with
          ⟨oldProfile, hProfile⟩
        exact ⟨oldProfile, putCanonical_preserves_some fresh hProfile⟩
      · exact hInv.activeContextReferentsCanonical
      · exact hInv.activeContextHasActivationProvenance
      · exact hInv.adoptedActiveContextHasCanonicalLicense
      · intro warrantId warrant hWarrant
        rcases hInv.warrantReferentsCanonical hWarrant with
          ⟨hContext, oldProfile, hProfile⟩
        exact ⟨hContext, oldProfile, putCanonical_preserves_some fresh hProfile⟩
      · exact hInv.warrantParentsCanonical
      · exact hInv.rootWarrantWellFormed
      · exact hInv.warrantRootLineageCanonical
      · intro warrantId warrant ruleId hWarrant hConstructor
        rcases hInv.inferWarrantWellFormed hWarrant hConstructor with
          ⟨oldProfile, context, rule, parents, hProfile, hContext, hRule,
            hParents, hDiscipline, hExact⟩
        exact ⟨oldProfile, context, rule, parents,
          putCanonical_preserves_some fresh hProfile, hContext, hRule,
          hParents.preserved (by intro parentId parent hLookup; exact hLookup),
          hDiscipline, hExact⟩
      · exact hInv.evaluationReferentsCanonical
      · exact hInv.evaluationPairCoherent
      · exact hInv.evaluationProfileUseBackedByBinding
      · exact hInv.transportWarrantWellFormed
  | @bindProfile id binding fresh profileCanonical =>
      constructor
      · intro id' binding' hLookup
        by_cases hEq : id' = id
        · subst id'
          have hBindingEq : binding' = binding := by
            simpa [putCanonical] using hLookup.symm
          subst binding'
          exact profileCanonical
        · have hOld : S.binding id' = some binding' := by
            simpa [putCanonical, hEq] using hLookup
          exact hInv.bindingReferentsCanonical hOld
      · intro key hActive
        rcases hInv.activeContextReferentsCanonical hActive with
          ⟨hContext, oldBinding, hLookup, hUse⟩
        exact ⟨hContext, oldBinding,
          putCanonical_preserves_some fresh hLookup, hUse⟩
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
      · intro warrantId warrant ruleId hWarrant hConstructor
        rcases hInv.inferWarrantWellFormed hWarrant hConstructor with
          ⟨profile, context, rule, parents, hProfile, hContext, hRule,
            hParents, hDiscipline, hExact⟩
        exact ⟨profile, context, rule, parents, hProfile, hContext, hRule,
          hParents.preserved (by intro parentId parent hLookup; exact hLookup),
          hDiscipline, hExact⟩
      · exact hInv.evaluationReferentsCanonical
      · exact hInv.evaluationPairCoherent
      · intro key hRecord
        rcases hInv.evaluationProfileUseBackedByBinding hRecord with
          ⟨oldId, oldBinding, hOldBinding, hProfileEq, hUseEq⟩
        exact ⟨oldId, oldBinding,
          putCanonical_preserves_some fresh hOldBinding, hProfileEq, hUseEq⟩
      · exact hInv.transportWarrantWellFormed
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
      · intro warrantId warrant ruleId hWarrant hConstructor
        rcases hInv.inferWarrantWellFormed hWarrant hConstructor with
          ⟨profile, context, rule, parents, hProfile, hContext, hRule,
            hParents, hDiscipline, hExact⟩
        exact ⟨profile, context, rule, parents, hProfile, hContext, hRule,
          hParents.preserved (by intro parentId parent hLookup; exact hLookup),
          hDiscipline, hExact⟩
      · exact hInv.evaluationReferentsCanonical
      · exact hInv.evaluationPairCoherent
      · exact hInv.evaluationProfileUseBackedByBinding
      · exact hInv.transportWarrantWellFormed
  | @root warrantId bindingId contextId input binding context
      fresh bindingCanonical contextCanonical accepted =>
      have hPreserve : ∀ ⦃id warrant⦄,
          S.warrant id = some warrant →
            putCanonical S.warrant warrantId
              (rootHistoricalWarrant warrantId binding.profileDigest contextId input) id =
              some warrant := by
        intro id warrant hLookup
        exact putCanonical_preserves_some fresh hLookup
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
          rcases hInv.bindingReferentsCanonical bindingCanonical with
            ⟨profile, hProfile⟩
          exact ⟨⟨context, contextCanonical⟩, profile, hProfile⟩
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
          exact ⟨parent, hPreserve hParentLookup⟩
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
          exact ⟨root, hPreserve hRootLookup⟩
      · intro id warrant ruleId hLookup hConstructor
        by_cases hEq : id = warrantId
        · subst id
          have hWarrantEq :
              warrant = rootHistoricalWarrant warrantId
                binding.profileDigest contextId input := by
            simpa [putCanonical] using hLookup.symm
          subst warrant
          simp [rootHistoricalWarrant] at hConstructor
        · have hOld : S.warrant id = some warrant := by
            simpa [putCanonical, hEq] using hLookup
          rcases hInv.inferWarrantWellFormed hOld hConstructor with
            ⟨profile, oldContext, rule, parents, hProfile, hContext, hRule,
              hParents, hDiscipline, hExact⟩
          exact ⟨profile, oldContext, rule, parents, hProfile, hContext, hRule,
            hParents.preserved hPreserve, hDiscipline, hExact⟩
      · intro key hRecord
        rcases hInv.evaluationReferentsCanonical hRecord with
          ⟨warrant, hWarrant, hProfile, hContext⟩
        exact ⟨warrant, hPreserve hWarrant, hProfile, hContext⟩
      · exact hInv.evaluationPairCoherent
      · exact hInv.evaluationProfileUseBackedByBinding
      · intro id warrant mapId hLookup hConstructor
        by_cases hEq : id = warrantId
        · subst id
          have hWarrantEq :
              warrant = rootHistoricalWarrant warrantId
                binding.profileDigest contextId input := by
            simpa [putCanonical] using hLookup.symm
          subst warrant
          simp [rootHistoricalWarrant] at hConstructor
        · have hOld : S.warrant id = some warrant := by
            simpa [putCanonical, hEq] using hLookup
          rcases hInv.transportWarrantWellFormed hOld hConstructor with
            ⟨targetContext, originalId, witnessId, original, witness,
              hTargetContext, hOriginal, hWitness, hDiscipline, hExact⟩
          exact ⟨targetContext, originalId, witnessId, original, witness,
            hTargetContext, hPreserve hOriginal, hPreserve hWitness,
            hDiscipline, hExact⟩
  | @admitRoot warrantId bindingId contextId use metadata binding context warrant
      bindingCanonical contextCanonical warrantCanonical isRoot formationContext
      formationProfile useMatches =>
      let key : EvalKey :=
        ⟨binding.profileDigest, contextId, use, warrantId⟩
      constructor
      · exact hInv.bindingReferentsCanonical
      · exact hInv.activeContextReferentsCanonical
      · exact hInv.activeContextHasActivationProvenance
      · exact hInv.adoptedActiveContextHasCanonicalLicense
      · exact hInv.warrantReferentsCanonical
      · exact hInv.warrantParentsCanonical
      · exact hInv.rootWarrantWellFormed
      · exact hInv.warrantRootLineageCanonical
      · intro warrantId' warrant' ruleId hWarrant hConstructor
        rcases hInv.inferWarrantWellFormed hWarrant hConstructor with
          ⟨profile, oldContext, rule, parents, hProfile, hContext, hRule,
            hParents, hDiscipline, hExact⟩
        exact ⟨profile, oldContext, rule, parents, hProfile, hContext, hRule,
          hParents.preserved (by intro parentId parent hLookup; exact hLookup),
          hDiscipline, hExact⟩
      · intro key' hRecord
        by_cases hEq : key' = key
        · subst key'
          exact ⟨warrant, warrantCanonical, formationProfile, formationContext⟩
        · have hOldRecord : HasEvaluationRecord S key' := by
            rcases qualifyEvaluation_otherKey_unchanged S hEq with
              ⟨hEpi, hPlacement⟩
            rcases hRecord with hStatus | hPlace
            · rcases hStatus with ⟨status, hStatus⟩
              exact Or.inl ⟨status, hEpi.symm.trans hStatus⟩
            · rcases hPlace with ⟨placement, hPlace⟩
              exact Or.inr ⟨placement, hPlacement.symm.trans hPlace⟩
          exact hInv.evaluationReferentsCanonical hOldRecord
      · intro key'
        by_cases hEq : key' = key
        · subst key'
          simp [key, qualifyEvaluation, setOptionAt]
        · rcases qualifyEvaluation_otherKey_unchanged S hEq with
            ⟨hEpi, hPlacement⟩
          rw [hEpi, hPlacement]
          exact hInv.evaluationPairCoherent key'
      · intro key' hRecord
        by_cases hEq : key' = key
        · subst key'
          exact ⟨bindingId, binding, bindingCanonical, rfl, useMatches⟩
        · have hOldRecord : HasEvaluationRecord S key' := by
            rcases qualifyEvaluation_otherKey_unchanged S hEq with
              ⟨hEpi, hPlacement⟩
            rcases hRecord with hStatus | hPlace
            · rcases hStatus with ⟨status, hStatus⟩
              exact Or.inl ⟨status, hEpi.symm.trans hStatus⟩
            · rcases hPlace with ⟨placement, hPlace⟩
              exact Or.inr ⟨placement, hPlacement.symm.trans hPlace⟩
          exact hInv.evaluationProfileUseBackedByBinding hOldRecord
      · exact hInv.transportWarrantWellFormed
  | @infer warrantId bindingId contextId ruleId parentIds outScope
      binding profile context rule parents fresh bindingCanonical profileCanonical
      ruleExact contextCanonical parentsCanonical discipline =>
      let newWarrant := inferHistoricalWarrant
        ruleId binding.profileDigest contextId parentIds parents outScope rule
      have hPreserve : ∀ ⦃id warrant⦄,
          S.warrant id = some warrant →
            putCanonical S.warrant warrantId newWarrant id = some warrant := by
        intro id warrant hLookup
        exact putCanonical_preserves_some fresh hLookup
      constructor
      · exact hInv.bindingReferentsCanonical
      · exact hInv.activeContextReferentsCanonical
      · exact hInv.activeContextHasActivationProvenance
      · exact hInv.adoptedActiveContextHasCanonicalLicense
      · intro id warrant hLookup
        by_cases hEq : id = warrantId
        · subst id
          have hWarrantEq : warrant = newWarrant := by
            simpa [putCanonical, newWarrant] using hLookup.symm
          subst warrant
          exact ⟨⟨context, contextCanonical⟩, profile, profileCanonical⟩
        · have hOld : S.warrant id = some warrant := by
            simpa [putCanonical, hEq, newWarrant] using hLookup
          exact hInv.warrantReferentsCanonical hOld
      · intro id warrant parentId hLookup hParentMem
        by_cases hEq : id = warrantId
        · subst id
          have hWarrantEq : warrant = newWarrant := by
            simpa [putCanonical, newWarrant] using hLookup.symm
          subst warrant
          have hParentInIds : parentId ∈ parentIds := by
            simpa [newWarrant, inferHistoricalWarrant] using hParentMem
          rcases parentsCanonical.lookup_of_id_mem hParentInIds with
            ⟨parent, hParentObjMem, hParentLookup⟩
          exact ⟨parent, hPreserve hParentLookup⟩
        · have hOld : S.warrant id = some warrant := by
            simpa [putCanonical, hEq, newWarrant] using hLookup
          rcases hInv.warrantParentsCanonical hOld hParentMem with
            ⟨parent, hParentLookup⟩
          exact ⟨parent, hPreserve hParentLookup⟩
      · intro id warrant hLookup hConstructor
        by_cases hEq : id = warrantId
        · subst id
          have hWarrantEq : warrant = newWarrant := by
            simpa [putCanonical, newWarrant] using hLookup.symm
          subst warrant
          simp [newWarrant, inferHistoricalWarrant] at hConstructor
        · have hOld : S.warrant id = some warrant := by
            simpa [putCanonical, hEq, newWarrant] using hLookup
          exact hInv.rootWarrantWellFormed hOld hConstructor
      · intro id warrant role rootId hLookup hLineage
        by_cases hEq : id = warrantId
        · subst id
          have hWarrantEq : warrant = newWarrant := by
            simpa [putCanonical, newWarrant] using hLookup.symm
          subst warrant
          rcases hLineage with ⟨parent, hParentMem, hParentLineage⟩
          rcases parentsCanonical.id_of_parent_mem hParentMem with
            ⟨parentId, hParentIdMem, hParentLookup⟩
          rcases hInv.warrantRootLineageCanonical hParentLookup hParentLineage with
            ⟨root, hRootLookup⟩
          exact ⟨root, hPreserve hRootLookup⟩
        · have hOld : S.warrant id = some warrant := by
            simpa [putCanonical, hEq, newWarrant] using hLookup
          rcases hInv.warrantRootLineageCanonical hOld hLineage with
            ⟨root, hRootLookup⟩
          exact ⟨root, hPreserve hRootLookup⟩
      · intro id warrant observedRuleId hLookup hConstructor
        by_cases hEq : id = warrantId
        · subst id
          have hWarrantEq : warrant = newWarrant := by
            simpa [putCanonical, newWarrant] using hLookup.symm
          subst warrant
          have hRuleId : ruleId = observedRuleId := by
            simpa [newWarrant, inferHistoricalWarrant] using hConstructor
          subst observedRuleId
          refine ⟨profile, context, rule, parents,
            profileCanonical, contextCanonical, ruleExact, ?_, discipline, ?_⟩
          · exact parentsCanonical.preserved hPreserve
          · rfl
        · have hOld : S.warrant id = some warrant := by
            simpa [putCanonical, hEq, newWarrant] using hLookup
          rcases hInv.inferWarrantWellFormed hOld hConstructor with
            ⟨oldProfile, oldContext, oldRule, oldParents,
              hProfile, hContext, hRule, hParents, hDiscipline, hExact⟩
          exact ⟨oldProfile, oldContext, oldRule, oldParents,
            hProfile, hContext, hRule, hParents.preserved hPreserve,
            hDiscipline, hExact⟩
      · intro key hRecord
        rcases hInv.evaluationReferentsCanonical hRecord with
          ⟨warrant, hWarrant, hProfile, hContext⟩
        exact ⟨warrant, hPreserve hWarrant, hProfile, hContext⟩
      · exact hInv.evaluationPairCoherent
      · exact hInv.evaluationProfileUseBackedByBinding
      · intro id warrant mapId hLookup hConstructor
        by_cases hEq : id = warrantId
        · subst id
          have hWarrantEq : warrant = newWarrant := by
            simpa [putCanonical, newWarrant] using hLookup.symm
          subst warrant
          simp [newWarrant, inferHistoricalWarrant] at hConstructor
        · have hOld : S.warrant id = some warrant := by
            simpa [putCanonical, hEq, newWarrant] using hLookup
          rcases hInv.transportWarrantWellFormed hOld hConstructor with
            ⟨targetContext, originalId, witnessId, original, witness,
              hTargetContext, hOriginal, hWitness, hDiscipline, hExact⟩
          exact ⟨targetContext, originalId, witnessId, original, witness,
            hTargetContext, hPreserve hOriginal, hPreserve hWitness,
            hDiscipline, hExact⟩
  | @transport warrantId originalId witnessId bindingId targetContextId mapId
      translatedClaim outScope binding targetContext original witness
      fresh bindingCanonical contextCanonical originalCanonical witnessCanonical
      discipline =>
      let newWarrant := transportHistoricalWarrant
        mapId binding.profileDigest targetContextId originalId witnessId
        original witness translatedClaim outScope
      have hPreserve : ∀ ⦃id warrant⦄,
          S.warrant id = some warrant →
            putCanonical S.warrant warrantId newWarrant id = some warrant := by
        intro id warrant hLookup
        exact putCanonical_preserves_some fresh hLookup
      constructor
      · exact hInv.bindingReferentsCanonical
      · exact hInv.activeContextReferentsCanonical
      · exact hInv.activeContextHasActivationProvenance
      · exact hInv.adoptedActiveContextHasCanonicalLicense
      · intro id warrant hLookup
        by_cases hEq : id = warrantId
        · subst id
          have hWarrantEq : warrant = newWarrant := by
            simpa [putCanonical, newWarrant] using hLookup.symm
          subst warrant
          rcases hInv.bindingReferentsCanonical bindingCanonical with
            ⟨profile, hProfile⟩
          exact ⟨⟨targetContext, contextCanonical⟩, profile, hProfile⟩
        · have hOld : S.warrant id = some warrant := by
            simpa [putCanonical, hEq, newWarrant] using hLookup
          exact hInv.warrantReferentsCanonical hOld
      · intro id warrant parentId hLookup hParentMem
        by_cases hEq : id = warrantId
        · subst id
          have hWarrantEq : warrant = newWarrant := by
            simpa [putCanonical, newWarrant] using hLookup.symm
          subst warrant
          have hParentCases : parentId = originalId ∨ parentId = witnessId := by
            simpa [newWarrant, transportHistoricalWarrant] using hParentMem
          rcases hParentCases with hOriginal | hWitness
          · subst parentId
            exact ⟨original, hPreserve originalCanonical⟩
          · subst parentId
            exact ⟨witness, hPreserve witnessCanonical⟩
        · have hOld : S.warrant id = some warrant := by
            simpa [putCanonical, hEq, newWarrant] using hLookup
          rcases hInv.warrantParentsCanonical hOld hParentMem with
            ⟨parent, hParentLookup⟩
          exact ⟨parent, hPreserve hParentLookup⟩
      · intro id warrant hLookup hConstructor
        by_cases hEq : id = warrantId
        · subst id
          have hWarrantEq : warrant = newWarrant := by
            simpa [putCanonical, newWarrant] using hLookup.symm
          subst warrant
          simp [newWarrant, transportHistoricalWarrant] at hConstructor
        · have hOld : S.warrant id = some warrant := by
            simpa [putCanonical, hEq, newWarrant] using hLookup
          exact hInv.rootWarrantWellFormed hOld hConstructor
      · intro id warrant role rootId hLookup hLineage
        by_cases hEq : id = warrantId
        · subst id
          have hWarrantEq : warrant = newWarrant := by
            simpa [putCanonical, newWarrant] using hLookup.symm
          subst warrant
          change transportRootLineage original witness role rootId at hLineage
          rcases hLineage with hOriginalLineage | hWitnessLineage
          · rcases hInv.warrantRootLineageCanonical originalCanonical
              hOriginalLineage with ⟨root, hRootLookup⟩
            exact ⟨root, hPreserve hRootLookup⟩
          · rcases hWitnessLineage with ⟨hRole, witnessRole, hWitnessLineage⟩
            rcases hInv.warrantRootLineageCanonical witnessCanonical
              hWitnessLineage with ⟨root, hRootLookup⟩
            exact ⟨root, hPreserve hRootLookup⟩
        · have hOld : S.warrant id = some warrant := by
            simpa [putCanonical, hEq, newWarrant] using hLookup
          rcases hInv.warrantRootLineageCanonical hOld hLineage with
            ⟨root, hRootLookup⟩
          exact ⟨root, hPreserve hRootLookup⟩
      · intro id warrant ruleId hLookup hConstructor
        by_cases hEq : id = warrantId
        · subst id
          have hWarrantEq : warrant = newWarrant := by
            simpa [putCanonical, newWarrant] using hLookup.symm
          subst warrant
          simp [newWarrant, transportHistoricalWarrant] at hConstructor
        · have hOld : S.warrant id = some warrant := by
            simpa [putCanonical, hEq, newWarrant] using hLookup
          rcases hInv.inferWarrantWellFormed hOld hConstructor with
            ⟨oldProfile, oldContext, oldRule, oldParents,
              hProfile, hContext, hRule, hParents, hDiscipline, hExact⟩
          exact ⟨oldProfile, oldContext, oldRule, oldParents,
            hProfile, hContext, hRule, hParents.preserved hPreserve,
            hDiscipline, hExact⟩
      · intro key hRecord
        rcases hInv.evaluationReferentsCanonical hRecord with
          ⟨warrant, hWarrant, hProfile, hContext⟩
        exact ⟨warrant, hPreserve hWarrant, hProfile, hContext⟩
      · exact hInv.evaluationPairCoherent
      · exact hInv.evaluationProfileUseBackedByBinding
      · intro id warrant observedMapId hLookup hConstructor
        by_cases hEq : id = warrantId
        · subst id
          have hWarrantEq : warrant = newWarrant := by
            simpa [putCanonical, newWarrant] using hLookup.symm
          subst warrant
          have hMapId : mapId = observedMapId := by
            simpa [newWarrant, transportHistoricalWarrant] using hConstructor
          subst observedMapId
          refine ⟨targetContext, originalId, witnessId, original, witness,
            contextCanonical, hPreserve originalCanonical,
            hPreserve witnessCanonical, ?_, rfl⟩
          simpa [newWarrant, transportHistoricalWarrant] using discipline
        · have hOld : S.warrant id = some warrant := by
            simpa [putCanonical, hEq, newWarrant] using hLookup
          rcases hInv.transportWarrantWellFormed hOld hConstructor with
            ⟨oldTargetContext, oldOriginalId, oldWitnessId, oldOriginal,
              oldWitness, hTargetContext, hOriginal, hWitness,
              hDiscipline, hExact⟩
          exact ⟨oldTargetContext, oldOriginalId, oldWitnessId, oldOriginal,
            oldWitness, hTargetContext, hPreserve hOriginal,
            hPreserve hWitness, hDiscipline, hExact⟩
  | @qualifyInfer warrantId bindingId contextId use metadata binding warrant
      bindingCanonical warrantCanonical isInfer formationContext formationProfile
      parentsUsable =>
      let key : EvalKey :=
        ⟨binding.profileDigest, contextId, use, warrantId⟩
      constructor
      · exact hInv.bindingReferentsCanonical
      · exact hInv.activeContextReferentsCanonical
      · exact hInv.activeContextHasActivationProvenance
      · exact hInv.adoptedActiveContextHasCanonicalLicense
      · exact hInv.warrantReferentsCanonical
      · exact hInv.warrantParentsCanonical
      · exact hInv.rootWarrantWellFormed
      · exact hInv.warrantRootLineageCanonical
      · intro warrantId' warrant' ruleId hWarrant hConstructor
        rcases hInv.inferWarrantWellFormed hWarrant hConstructor with
          ⟨profile, oldContext, rule, parents, hProfile, hContext, hRule,
            hParents, hDiscipline, hExact⟩
        exact ⟨profile, oldContext, rule, parents, hProfile, hContext, hRule,
          hParents.preserved (by intro parentId parent hLookup; exact hLookup),
          hDiscipline, hExact⟩
      · intro key' hRecord
        by_cases hEq : key' = key
        · subst key'
          exact ⟨warrant, warrantCanonical, formationProfile, formationContext⟩
        · have hOldRecord : HasEvaluationRecord S key' := by
            rcases qualifyEvaluation_otherKey_unchanged S hEq with
              ⟨hEpi, hPlacement⟩
            rcases hRecord with hStatus | hPlace
            · rcases hStatus with ⟨status, hStatus⟩
              exact Or.inl ⟨status, hEpi.symm.trans hStatus⟩
            · rcases hPlace with ⟨placement, hPlace⟩
              exact Or.inr ⟨placement, hPlacement.symm.trans hPlace⟩
          exact hInv.evaluationReferentsCanonical hOldRecord
      · intro key'
        by_cases hEq : key' = key
        · subst key'
          simp [key, qualifyEvaluation, setOptionAt]
        · rcases qualifyEvaluation_otherKey_unchanged S hEq with
            ⟨hEpi, hPlacement⟩
          rw [hEpi, hPlacement]
          exact hInv.evaluationPairCoherent key'
      · intro key' hRecord
        by_cases hEq : key' = key
        · subst key'
          rcases isInfer with ⟨ruleId, hConstructor⟩
          rcases hInv.inferWarrantWellFormed warrantCanonical hConstructor with
            ⟨profile, context, rule, parents, hProfile, hContext, hRule,
              hParents, hDiscipline, hExact⟩
          have hRuleInputs : rule.inputRoles ≠ [] :=
            wellTypedRule_inputs_nonempty hDiscipline.wellTyped
          have hResolvedParentsNonempty : parents ≠ [] := by
            intro hEmpty
            have hRoles := hDiscipline.orderedRolesExact
            rw [hEmpty] at hRoles
            exact hRuleInputs hRoles.symm
          have hParentIdsNonempty : warrant.parents ≠ [] :=
            hParents.ids_nonempty_of_parents_nonempty hResolvedParentsNonempty
          cases hIds : warrant.parents with
          | nil =>
              exact False.elim (hParentIdsNonempty hIds)
          | cons parentId rest =>
              have hParentUsable :
                  Usable S ⟨binding.profileDigest, contextId, use, parentId⟩ :=
                parentsUsable parentId (by simp [hIds])
              have hParentRecord :
                  HasEvaluationRecord S
                    ⟨binding.profileDigest, contextId, use, parentId⟩ :=
                Or.inl ⟨.live, hParentUsable.1⟩
              rcases hInv.evaluationProfileUseBackedByBinding hParentRecord with
                ⟨backingId, backing, hBacking, hProfileBacking, hUseBacking⟩
              exact ⟨backingId, backing, hBacking,
                hProfileBacking, hUseBacking⟩
        · have hOldRecord : HasEvaluationRecord S key' := by
            rcases qualifyEvaluation_otherKey_unchanged S hEq with
              ⟨hEpi, hPlacement⟩
            rcases hRecord with hStatus | hPlace
            · rcases hStatus with ⟨status, hStatus⟩
              exact Or.inl ⟨status, hEpi.symm.trans hStatus⟩
            · rcases hPlace with ⟨placement, hPlace⟩
              exact Or.inr ⟨placement, hPlacement.symm.trans hPlace⟩
          exact hInv.evaluationProfileUseBackedByBinding hOldRecord
      · exact hInv.transportWarrantWellFormed
  | @qualifyTransport warrantId originalId witnessId bindingId targetContextId use
      mapId metadata binding warrant original witness bindingCanonical
      warrantCanonical isTransport parentsExact originalCanonical witnessCanonical
      formationContext formationProfile parentsUsable =>
      let key : EvalKey :=
        ⟨binding.profileDigest, targetContextId, use, warrantId⟩
      constructor
      · exact hInv.bindingReferentsCanonical
      · exact hInv.activeContextReferentsCanonical
      · exact hInv.activeContextHasActivationProvenance
      · exact hInv.adoptedActiveContextHasCanonicalLicense
      · exact hInv.warrantReferentsCanonical
      · exact hInv.warrantParentsCanonical
      · exact hInv.rootWarrantWellFormed
      · exact hInv.warrantRootLineageCanonical
      · intro warrantId' warrant' ruleId hWarrant hConstructor
        rcases hInv.inferWarrantWellFormed hWarrant hConstructor with
          ⟨profile, oldContext, rule, parents, hProfile, hContext, hRule,
            hParents, hDiscipline, hExact⟩
        exact ⟨profile, oldContext, rule, parents, hProfile, hContext, hRule,
          hParents.preserved (by intro parentId parent hLookup; exact hLookup),
          hDiscipline, hExact⟩
      · intro key' hRecord
        by_cases hEq : key' = key
        · subst key'
          exact ⟨warrant, warrantCanonical, formationProfile, formationContext⟩
        · have hOldRecord : HasEvaluationRecord S key' := by
            rcases qualifyEvaluation_otherKey_unchanged S hEq with
              ⟨hEpi, hPlacement⟩
            rcases hRecord with hStatus | hPlace
            · rcases hStatus with ⟨status, hStatus⟩
              exact Or.inl ⟨status, hEpi.symm.trans hStatus⟩
            · rcases hPlace with ⟨placement, hPlace⟩
              exact Or.inr ⟨placement, hPlacement.symm.trans hPlace⟩
          exact hInv.evaluationReferentsCanonical hOldRecord
      · intro key'
        by_cases hEq : key' = key
        · subst key'
          simp [key, qualifyEvaluation, setOptionAt]
        · rcases qualifyEvaluation_otherKey_unchanged S hEq with
            ⟨hEpi, hPlacement⟩
          rw [hEpi, hPlacement]
          exact hInv.evaluationPairCoherent key'
      · intro key' hRecord
        by_cases hEq : key' = key
        · subst key'
          have hOriginalUsable :
              Usable S
                ⟨binding.profileDigest, original.formationContext, use,
                  originalId⟩ := parentsUsable.1
          have hOriginalRecord :
              HasEvaluationRecord S
                ⟨binding.profileDigest, original.formationContext, use,
                  originalId⟩ :=
            Or.inl ⟨.live, hOriginalUsable.1⟩
          rcases hInv.evaluationProfileUseBackedByBinding hOriginalRecord with
            ⟨backingId, backing, hBacking, hProfileBacking, hUseBacking⟩
          exact ⟨backingId, backing, hBacking, hProfileBacking, hUseBacking⟩
        · have hOldRecord : HasEvaluationRecord S key' := by
            rcases qualifyEvaluation_otherKey_unchanged S hEq with
              ⟨hEpi, hPlacement⟩
            rcases hRecord with hStatus | hPlace
            · rcases hStatus with ⟨status, hStatus⟩
              exact Or.inl ⟨status, hEpi.symm.trans hStatus⟩
            · rcases hPlace with ⟨placement, hPlace⟩
              exact Or.inr ⟨placement, hPlacement.symm.trans hPlace⟩
          exact hInv.evaluationProfileUseBackedByBinding hOldRecord
      · exact hInv.transportWarrantWellFormed

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

theorem reachable_inferWarrantsWellFormed
    {S : CanonicalState}
    (hReachable : Reachable S) :
    InferWarrantWellFormed S :=
  (reachable_invariant hReachable).inferWarrantWellFormed

/-- Reachable states replay every historical TRANSPORT object against its exact
canonical formation responsibility. -/
theorem reachable_transportWarrantsWellFormed
    {S : CanonicalState}
    (hReachable : Reachable S) :
    TransportWarrantWellFormed S :=
  (reachable_invariant hReachable).transportWarrantWellFormed

theorem reachable_evaluationProfileUseBackedByBinding
    {S : CanonicalState}
    (hReachable : Reachable S) :
    EvaluationProfileUseBackedByBinding S :=
  (reachable_invariant hReachable).evaluationProfileUseBackedByBinding

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
