import ResponsibilityTopology.CanonicalRead

namespace ResponsibilityTopology

/-!
Canonical immutable history objects used by formation transitions.

This module models semantic identity rather than the Python container layout.
In particular, lineage is an extensional predicate indexed by role; list/map
ordering is not part of lineage identity.
-/

/-- Canonical context referent.  V0.1.2 interprets the signature as the finite
set of admitted claim kinds, with `"*"` as a wildcard. -/
structure CanonicalContext where
  signature : List String
  deriving Repr, DecidableEq

namespace CanonicalContext

/-- Static context-signature acceptance.  This is a history-plane predicate;
it does not consult context activation or any evaluation state. -/
def accepts (context : CanonicalContext) (claim : Claim) : Prop :=
  "*" ∈ context.signature ∨ claim.kind ∈ context.signature

end CanonicalContext

/-- Historical constructor identity.  #12 only introduces `.root`; the other
constructors reserve the canonical vocabulary needed by later formation PRs. -/
inductive WarrantConstructor where
  | root
  | infer (ruleId : String)
  | transport (mapId : String)
  deriving Repr, DecidableEq

/-- Root ancestry and external-source ancestry are deliberately distinct. -/
abbrev RootLineage := Role → WarrantId → Prop
abbrev SourceLineage := Role → String → Prop

/-- Exact singleton root lineage for one role. -/
def singletonRootLineage (role : Role) (warrantId : WarrantId) : RootLineage :=
  fun observedRole observedId =>
    observedRole = role ∧ observedId = warrantId

/-- Exact singleton external-source lineage for one role. -/
def singletonSourceLineage (role : Role) (source : String) : SourceLineage :=
  fun observedRole observedSource =>
    observedRole = role ∧ observedSource = source

/-- Full canonical historical warrant.  The warrant identifier is the key of the
canonical state lookup, not a duplicated field inside this object. -/
structure HistoricalWarrant where
  claim : Claim
  role : Role
  scope : Scope
  constructor : WarrantConstructor
  parents : List WarrantId
  formationProfileDigest : String
  formationContext : String
  source : Option String
  rootLineage : RootLineage
  sourceLineage : SourceLineage

namespace HistoricalWarrant

/-- One-way projection into the narrower read object already consumed by
satisfaction/floor/entitlement.  Historical constructor, parents, source, and
lineage remain outside that downstream interface. -/
def toReadWarrant (warrant : HistoricalWarrant) : CanonicalWarrant where
  claim := warrant.claim
  role := warrant.role
  scope := warrant.scope
  formationProfileDigest := warrant.formationProfileDigest
  formationContext := warrant.formationContext

end HistoricalWarrant

/-- Projection firewall between full historical identity and the pre-existing
canonical read surface. -/
theorem historicalWarrant_readProjection (warrant : HistoricalWarrant) :
    warrant.toReadWarrant =
      { claim := warrant.claim
        role := warrant.role
        scope := warrant.scope
        formationProfileDigest := warrant.formationProfileDigest
        formationContext := warrant.formationContext } := by
  rfl

/-- Semantic ROOT input.  Python `RootToken.id` is intentionally absent because
it is not copied into the canonical warrant produced by `root()`. -/
structure RootInput where
  claim : Claim
  role : Role
  scope : Scope
  source : String
  deriving Repr, DecidableEq

/-- Exact historical object created by ROOT formation. -/
def rootHistoricalWarrant
    (warrantId : WarrantId)
    (profileDigest contextId : String)
    (input : RootInput) : HistoricalWarrant where
  claim := input.claim
  role := input.role
  scope := input.scope
  constructor := .root
  parents := []
  formationProfileDigest := profileDigest
  formationContext := contextId
  source := some input.source
  rootLineage := singletonRootLineage input.role warrantId
  sourceLineage := singletonSourceLineage input.role input.source

end ResponsibilityTopology
