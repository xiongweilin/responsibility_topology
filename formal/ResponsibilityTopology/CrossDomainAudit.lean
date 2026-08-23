import ResponsibilityTopology.CrossDomain.ImpactDischargeCore
import ResponsibilityTopology.CrossDomain.EvaluationLayerCore

namespace ResponsibilityTopology.CrossDomain

/-!
Audit surface for the post-D4 minimal cross-domain calculi.

This file is intentionally separate from Paper 1-3 audit surfaces.  It does not
retroactively expand any paper claim or artifact baseline.
-/

#print axioms ImpactDischargeCore.requirementsCovered_and_soundRealization_imply_discharged
#print axioms ImpactDischargeCore.affected_without_discharge_exists
#print axioms ImpactDischargeCore.affected_does_not_semantically_force_discharge

#print axioms EvaluationLayerCore.local_conformance_without_higher_acceptance_exists
#print axioms EvaluationLayerCore.local_conformance_does_not_semantically_force_higher_acceptance
#print axioms EvaluationLayerCore.same_local_observation_different_higher_verdict

end ResponsibilityTopology.CrossDomain
