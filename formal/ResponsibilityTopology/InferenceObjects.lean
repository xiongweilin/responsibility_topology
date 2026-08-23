import ResponsibilityTopology.HistoricalObjects
import ResponsibilityTopology.ProfileObjects

namespace ResponsibilityTopology

/-!
Historical INFER object construction.

Ordered parent IDs remain ordered derivational inputs.  Root/source lineage is a
separate extensional ancestry relation and is merged role-wise across all parent
warrants.
-/

/-- Role-wise extensional union of all parent root lineages. -/
def mergeRootLineage (parents : List HistoricalWarrant) : RootLineage :=
  fun role rootId =>
    ∃ parent, parent ∈ parents ∧ parent.rootLineage role rootId

/-- Role-wise extensional union of all parent external-source lineages. -/
def mergeSourceLineage (parents : List HistoricalWarrant) : SourceLineage :=
  fun role sourceId =>
    ∃ parent, parent ∈ parents ∧ parent.sourceLineage role sourceId

/-- Exact historical object created by ordinary INFER formation. -/
def inferHistoricalWarrant
    (ruleId profileDigest contextId : String)
    (parentIds : List WarrantId)
    (parents : List HistoricalWarrant)
    (outScope : Scope)
    (rule : CanonicalRule) : HistoricalWarrant where
  claim := rule.outputClaim
  role := rule.outputRole
  scope := outScope
  constructor := .infer ruleId
  parents := parentIds
  formationProfileDigest := profileDigest
  formationContext := contextId
  source := none
  rootLineage := mergeRootLineage parents
  sourceLineage := mergeSourceLineage parents

end ResponsibilityTopology
