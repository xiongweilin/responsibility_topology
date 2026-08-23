import ResponsibilityTopology.InferenceSemantics

namespace ResponsibilityTopology

/-!
Pure canonical semantics for TRANSPORT formation.

This module deliberately does not add TRANSPORT to `KernelEvent`, `Step`, or
`Reachable`.  It fixes the semantic responsibility boundary that a later
reachable transition must satisfy.

The Python reference binds a bridge witness using `translated_claim.key()`,
whose payload is a JSON encoding.  K0 does not import that representation
choice.  `transportableClaim` below is a canonical semantic encoding over the
existing structured `Claim` vocabulary.  Correspondence with the Python JSON
container representation is a future executable-refinement obligation.

TRANSPORT is same-profile at this stage.  Target-context activation/adoption is
not a formation premise: static transportability is distinct from target-context
currentness.
-/

/-- Canonical K0 witness claim for one exact transport translation.

The first four arguments identify the transport map, formal original warrant,
target context, and translated claim kind; the remaining arguments are exactly
the translated claim arguments.  This is intentionally not Python's JSON
`Claim.key()` representation. -/
def transportableClaim
    (mapId : String)
    (originalId : WarrantId)
    (targetContextId : String)
    (translatedClaim : Claim) : Claim where
  kind := "Transportable"
  args :=
    [mapId, toString originalId, targetContextId, translatedClaim.kind] ++
      translatedClaim.args

/-- TRANSPORT preserves the original role-indexed root ancestry and places every
root-ancestry contribution of the bridge witness under BRIDGE responsibility. -/
def transportRootLineage
    (original witness : HistoricalWarrant) : RootLineage :=
  fun role rootId =>
    original.rootLineage role rootId ∨
      (role = .bridge ∧
        ∃ witnessRole, witness.rootLineage witnessRole rootId)

/-- TRANSPORT preserves the original role-indexed external-source ancestry and
places every source-ancestry contribution of the bridge witness under BRIDGE
responsibility. -/
def transportSourceLineage
    (original witness : HistoricalWarrant) : SourceLineage :=
  fun role sourceId =>
    original.sourceLineage role sourceId ∨
      (role = .bridge ∧
        ∃ witnessRole, witness.sourceLineage witnessRole sourceId)

/-- Canonically interpretable escalation strength may be preserved or narrowed
by TRANSPORT but not amplified.  As in the Python kernel, an uninterpretable
translated escalation claim creates no numeric comparison obligation; a valid
translated depth requires a valid original depth at least as large. -/
def NoTransportEscalationAmplification
    (original : HistoricalWarrant)
    (translatedClaim : Claim) : Prop :=
  if original.role = .escalation then
    match canonicalEscalationDepth translatedClaim with
    | none => True
    | some translatedDepth =>
        ∃ originalDepth,
          canonicalEscalationDepth original.claim = some originalDepth ∧
          translatedDepth ≤ originalDepth
  else
    True

/-- Static canonical discipline for TRANSPORT formation.

Current usability and target-context activation are intentionally absent.  Both
parents must belong to the current profile snapshot, the bridge witness must
bind this exact translation, the target context must accept the translated
claim, scope may only narrow, output role is inherited from the original, and
parents are exactly `[original, witness]`. -/
structure TransportFormationDiscipline
    (targetContext : CanonicalContext)
    (profileDigest targetContextId mapId : String)
    (originalId witnessId : WarrantId)
    (original witness : HistoricalWarrant)
    (translatedClaim : Claim)
    (outRole : Role)
    (outScope : Scope)
    (parentIds : List WarrantId) : Prop where
  originalSameProfile :
    original.formationProfileDigest = profileDigest
  witnessSameProfile :
    witness.formationProfileDigest = profileDigest
  witnessRoleBridge : witness.role = .bridge
  witnessExactBinding :
    witness.claim =
      transportableClaim mapId originalId targetContextId translatedClaim
  outputAccepted : targetContext.accepts translatedClaim
  scopeWithinOriginal : ScopeNarrowerOrEqual outScope original.scope
  scopeWithinWitness : ScopeNarrowerOrEqual outScope witness.scope
  outputRolePreserved : outRole = original.role
  noEscalationAmplification :
    NoTransportEscalationAmplification original translatedClaim
  parentsExact : parentIds = [originalId, witnessId]

/-- Exact immutable historical object produced by canonical TRANSPORT formation.
The target context becomes the child's formation context while both parents
remain their original historical objects. -/
def transportHistoricalWarrant
    (mapId profileDigest targetContextId : String)
    (originalId witnessId : WarrantId)
    (original witness : HistoricalWarrant)
    (translatedClaim : Claim)
    (outScope : Scope) : HistoricalWarrant where
  claim := translatedClaim
  role := original.role
  scope := outScope
  constructor := .transport mapId
  parents := [originalId, witnessId]
  formationProfileDigest := profileDigest
  formationContext := targetContextId
  source := none
  rootLineage := transportRootLineage original witness
  sourceLineage := transportSourceLineage original witness

/-! ## Lineage conservation facts -/

/-- Original root ancestry is preserved under its original responsibility role. -/
theorem transportRootLineage_preserves_original
    (original witness : HistoricalWarrant)
    (role : Role) (rootId : WarrantId)
    (h : original.rootLineage role rootId) :
    transportRootLineage original witness role rootId := by
  exact Or.inl h

/-- Every root-ancestry contribution of the translation witness is visible under
BRIDGE responsibility in the transported child. -/
theorem transportRootLineage_witness_as_bridge
    (original witness : HistoricalWarrant)
    (witnessRole : Role) (rootId : WarrantId)
    (h : witness.rootLineage witnessRole rootId) :
    transportRootLineage original witness .bridge rootId := by
  exact Or.inr ⟨rfl, ⟨witnessRole, h⟩⟩

/-- Away from BRIDGE, TRANSPORT introduces no root ancestry beyond the original
warrant's ancestry at that same role. -/
theorem transportRootLineage_nonBridge_exact
    (original witness : HistoricalWarrant)
    (role : Role) (rootId : WarrantId)
    (hRole : role ≠ .bridge) :
    transportRootLineage original witness role rootId ↔
      original.rootLineage role rootId := by
  constructor
  · intro h
    rcases h with hOriginal | hWitness
    · exact hOriginal
    · exact False.elim (hRole hWitness.1)
  · intro h
    exact Or.inl h

/-- Original external-source ancestry is preserved under its original role. -/
theorem transportSourceLineage_preserves_original
    (original witness : HistoricalWarrant)
    (role : Role) (sourceId : String)
    (h : original.sourceLineage role sourceId) :
    transportSourceLineage original witness role sourceId := by
  exact Or.inl h

/-- Every source-ancestry contribution of the translation witness is visible
under BRIDGE responsibility in the transported child. -/
theorem transportSourceLineage_witness_as_bridge
    (original witness : HistoricalWarrant)
    (witnessRole : Role) (sourceId : String)
    (h : witness.sourceLineage witnessRole sourceId) :
    transportSourceLineage original witness .bridge sourceId := by
  exact Or.inr ⟨rfl, ⟨witnessRole, h⟩⟩

/-- Away from BRIDGE, TRANSPORT introduces no source ancestry beyond the
original warrant's ancestry at that same role. -/
theorem transportSourceLineage_nonBridge_exact
    (original witness : HistoricalWarrant)
    (role : Role) (sourceId : String)
    (hRole : role ≠ .bridge) :
    transportSourceLineage original witness role sourceId ↔
      original.sourceLineage role sourceId := by
  constructor
  · intro h
    rcases h with hOriginal | hWitness
    · exact hOriginal
    · exact False.elim (hRole hWitness.1)
  · intro h
    exact Or.inl h

/-! ## Exact historical-shape facts for later reachable formation -/

theorem transportHistoricalWarrant_parents_exact
    (mapId profileDigest targetContextId : String)
    (originalId witnessId : WarrantId)
    (original witness : HistoricalWarrant)
    (translatedClaim : Claim) (outScope : Scope) :
    (transportHistoricalWarrant mapId profileDigest targetContextId
      originalId witnessId original witness translatedClaim outScope).parents =
      [originalId, witnessId] := by
  rfl

theorem transportHistoricalWarrant_role_exact
    (mapId profileDigest targetContextId : String)
    (originalId witnessId : WarrantId)
    (original witness : HistoricalWarrant)
    (translatedClaim : Claim) (outScope : Scope) :
    (transportHistoricalWarrant mapId profileDigest targetContextId
      originalId witnessId original witness translatedClaim outScope).role =
      original.role := by
  rfl

theorem transportHistoricalWarrant_formation_exact
    (mapId profileDigest targetContextId : String)
    (originalId witnessId : WarrantId)
    (original witness : HistoricalWarrant)
    (translatedClaim : Claim) (outScope : Scope) :
    let child := transportHistoricalWarrant mapId profileDigest targetContextId
      originalId witnessId original witness translatedClaim outScope
    child.constructor = .transport mapId ∧
      child.formationProfileDigest = profileDigest ∧
      child.formationContext = targetContextId ∧
      child.claim = translatedClaim ∧
      child.scope = outScope := by
  rfl

end ResponsibilityTopology
