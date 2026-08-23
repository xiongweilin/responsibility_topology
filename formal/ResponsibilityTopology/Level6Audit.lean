import ResponsibilityTopology.CrossDomainAudit
import ResponsibilityTopology.CrossDomain.CaseModels
import ResponsibilityTopology.BridgeAudit

namespace ResponsibilityTopology

/-!
Level-6 technical integration audit.

The audit combines three independent evidence layers:

1. minimal cross-domain calculi and their semantic countermodels;
2. audited finite case-model instances for D1-D3 plus D4 software regression;
3. the restricted certified O0/B0 qualification-withdrawal bridge.

It does not add a new responsibility axis, a runtime-step simulation theorem,
impact-semantics equivalence, or Q_open theory.
-/

#print axioms CrossDomain.ImpactDischargeCore.affected_does_not_semantically_force_discharge
#print axioms CrossDomain.EvaluationLayerCore.local_conformance_does_not_semantically_force_higher_acceptance
#print axioms CrossDomain.CaseModels.ci2_case_models_share_one_calculus
#print axioms CrossDomain.CaseModels.ci3_case_models_share_one_calculus

#print axioms Bridge.checkQualificationWithdrawal_sound
#print axioms Bridge.checked_withdrawal_without_discharge_rejects_current_use
#print axioms Bridge.challenge_target_realizes_formal_withdrawal_pattern

end ResponsibilityTopology
