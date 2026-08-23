import ResponsibilityTopology.CrossDomain.ImpactDischargeCore
import ResponsibilityTopology.CrossDomain.EvaluationLayerCore

namespace ResponsibilityTopology.CrossDomain.CaseModels

/-!
Finite case-model encodings for the Level-6 integration audit.

These are *not* formalizations of FAA law, U.S. public law, metrology standards,
or the portable-runtime implementation.  They encode only the responsibility
separations already established by the source-backed XDI audit and D4 regression,
so that the same two minimal calculi can be instantiated without importing the
Paper 1-3 vocabulary.
-/

namespace Maintenance

inductive Subject where | component deriving Repr, DecidableEq
inductive Change where | unsafeCondition deriving Repr, DecidableEq
inductive ImpactEvidence where | directiveApplies deriving Repr, DecidableEq
inductive Requirement where | correctiveAction deriving Repr, DecidableEq
inductive Response where | replaceComponent deriving Repr, DecidableEq
inductive RealizationEvidence where | maintenanceRelease deriving Repr, DecidableEq

/-- Pre-discharge maintenance case model: applicability/impact is represented,
but the corrective responsibility has not yet been discharged. -/
def impactModel : ImpactDischargeCore where
  Subject := Subject
  Change := Change
  ImpactEvidence := ImpactEvidence
  Requirement := Requirement
  Response := Response
  RealizationEvidence := RealizationEvidence
  Affected := fun s c e =>
    s = .component ∧ c = .unsafeCondition ∧ e = .directiveApplies
  Requires := fun s c r =>
    s = .component ∧ c = .unsafeCondition ∧ r = .correctiveAction
  ResponseCovers := fun response requirement =>
    response = .replaceComponent ∧ requirement = .correctiveAction
  Realized := fun response evidence =>
    response = .replaceComponent ∧ evidence = .maintenanceRelease
  Discharged := fun _ _ => False

theorem impact_without_discharge :
    impactModel.Affected .component .unsafeCondition .directiveApplies ∧
    ¬ impactModel.Discharged .component .unsafeCondition := by
  simp [impactModel]

inductive Regime where | maintenanceProcedure deriving Repr, DecidableEq
inductive Purpose where | continuedService deriving Repr, DecidableEq
inductive LocalEvidence where | procedureConformance deriving Repr, DecidableEq
inductive HigherInput where | continuedAirworthinessEvidence deriving Repr, DecidableEq

/-- Local procedural conformance is represented positively while the higher
fitness/sufficiency judgment is deliberately not accepted in this case model. -/
def evaluationModel : EvaluationLayerCore where
  Subject := Subject
  Regime := Regime
  Purpose := Purpose
  LocalEvidence := LocalEvidence
  HigherInput := HigherInput
  LocalConformance := fun regime subject evidence =>
    regime = .maintenanceProcedure ∧
    subject = .component ∧
    evidence = .procedureConformance
  HigherAccepted := fun _ _ _ _ => False

theorem local_conformance_without_higher_acceptance :
    evaluationModel.LocalConformance
        .maintenanceProcedure .component .procedureConformance ∧
    ¬ evaluationModel.HigherAccepted
        .maintenanceProcedure .component .continuedService
        .continuedAirworthinessEvidence := by
  simp [evaluationModel]

end Maintenance

namespace InstitutionalAuthority

inductive Subject where | officialAct deriving Repr, DecidableEq
inductive Change where | authorityDefect deriving Repr, DecidableEq
inductive ImpactEvidence where | appointmentDefectFound deriving Repr, DecidableEq
inductive Requirement where | legallySufficientRemedy deriving Repr, DecidableEq
inductive Response where | newHearing deriving Repr, DecidableEq
inductive RealizationEvidence where | properlyAuthorizedHearing deriving Repr, DecidableEq

def impactModel : ImpactDischargeCore where
  Subject := Subject
  Change := Change
  ImpactEvidence := ImpactEvidence
  Requirement := Requirement
  Response := Response
  RealizationEvidence := RealizationEvidence
  Affected := fun s c e =>
    s = .officialAct ∧ c = .authorityDefect ∧ e = .appointmentDefectFound
  Requires := fun s c r =>
    s = .officialAct ∧ c = .authorityDefect ∧ r = .legallySufficientRemedy
  ResponseCovers := fun response requirement =>
    response = .newHearing ∧ requirement = .legallySufficientRemedy
  Realized := fun response evidence =>
    response = .newHearing ∧ evidence = .properlyAuthorizedHearing
  Discharged := fun _ _ => False

theorem impact_without_discharge :
    impactModel.Affected .officialAct .authorityDefect .appointmentDefectFound ∧
    ¬ impactModel.Discharged .officialAct .authorityDefect := by
  simp [impactModel]

inductive Regime where | agencyProcedure deriving Repr, DecidableEq
inductive Purpose where | legallyEffectiveAct deriving Repr, DecidableEq
inductive LocalEvidence where | proceduralCompliance deriving Repr, DecidableEq
inductive HigherInput where | higherLawAuthority deriving Repr, DecidableEq

def evaluationModel : EvaluationLayerCore where
  Subject := Subject
  Regime := Regime
  Purpose := Purpose
  LocalEvidence := LocalEvidence
  HigherInput := HigherInput
  LocalConformance := fun regime subject evidence =>
    regime = .agencyProcedure ∧
    subject = .officialAct ∧
    evidence = .proceduralCompliance
  HigherAccepted := fun _ _ _ _ => False

theorem local_conformance_without_higher_acceptance :
    evaluationModel.LocalConformance
        .agencyProcedure .officialAct .proceduralCompliance ∧
    ¬ evaluationModel.HigherAccepted
        .agencyProcedure .officialAct .legallyEffectiveAct .higherLawAuthority := by
  simp [evaluationModel]

end InstitutionalAuthority

namespace Measurement

inductive Subject where | measurementResult deriving Repr, DecidableEq
inductive Change where | processOutOfControl deriving Repr, DecidableEq
inductive ImpactEvidence where | controlSignal deriving Repr, DecidableEq
inductive Requirement where | measurementRemediation deriving Repr, DecidableEq
inductive Response where | recalibrate deriving Repr, DecidableEq
inductive RealizationEvidence where | controlReestablished deriving Repr, DecidableEq

def impactModel : ImpactDischargeCore where
  Subject := Subject
  Change := Change
  ImpactEvidence := ImpactEvidence
  Requirement := Requirement
  Response := Response
  RealizationEvidence := RealizationEvidence
  Affected := fun s c e =>
    s = .measurementResult ∧ c = .processOutOfControl ∧ e = .controlSignal
  Requires := fun s c r =>
    s = .measurementResult ∧ c = .processOutOfControl ∧ r = .measurementRemediation
  ResponseCovers := fun response requirement =>
    response = .recalibrate ∧ requirement = .measurementRemediation
  Realized := fun response evidence =>
    response = .recalibrate ∧ evidence = .controlReestablished
  Discharged := fun _ _ => False

theorem impact_without_discharge :
    impactModel.Affected .measurementResult .processOutOfControl .controlSignal ∧
    ¬ impactModel.Discharged .measurementResult .processOutOfControl := by
  simp [impactModel]

inductive Regime where | measurementProcedure deriving Repr, DecidableEq
inductive Purpose where | fitForIntendedUse deriving Repr, DecidableEq
inductive LocalEvidence where | traceabilityConformance deriving Repr, DecidableEq
inductive HigherInput where | uncertaintyAndModelEvidence deriving Repr, DecidableEq

def evaluationModel : EvaluationLayerCore where
  Subject := Subject
  Regime := Regime
  Purpose := Purpose
  LocalEvidence := LocalEvidence
  HigherInput := HigherInput
  LocalConformance := fun regime subject evidence =>
    regime = .measurementProcedure ∧
    subject = .measurementResult ∧
    evidence = .traceabilityConformance
  HigherAccepted := fun _ _ _ _ => False

theorem local_conformance_without_higher_acceptance :
    evaluationModel.LocalConformance
        .measurementProcedure .measurementResult .traceabilityConformance ∧
    ¬ evaluationModel.HigherAccepted
        .measurementProcedure .measurementResult .fitForIntendedUse
        .uncertaintyAndModelEvidence := by
  simp [evaluationModel]

end Measurement

namespace SoftwareRegression

inductive Subject where | assertion deriving Repr, DecidableEq
inductive Change where | dependencyChanged deriving Repr, DecidableEq
inductive ImpactEvidence where | revalidationRequired deriving Repr, DecidableEq
inductive Requirement where | requalification deriving Repr, DecidableEq
inductive Response where | rerunValidation deriving Repr, DecidableEq
inductive RealizationEvidence where | acceptedValidation deriving Repr, DecidableEq

def impactModel : ImpactDischargeCore where
  Subject := Subject
  Change := Change
  ImpactEvidence := ImpactEvidence
  Requirement := Requirement
  Response := Response
  RealizationEvidence := RealizationEvidence
  Affected := fun s c e =>
    s = .assertion ∧ c = .dependencyChanged ∧ e = .revalidationRequired
  Requires := fun s c r =>
    s = .assertion ∧ c = .dependencyChanged ∧ r = .requalification
  ResponseCovers := fun response requirement =>
    response = .rerunValidation ∧ requirement = .requalification
  Realized := fun response evidence =>
    response = .rerunValidation ∧ evidence = .acceptedValidation
  Discharged := fun _ _ => False

theorem impact_without_discharge :
    impactModel.Affected .assertion .dependencyChanged .revalidationRequired ∧
    ¬ impactModel.Discharged .assertion .dependencyChanged := by
  simp [impactModel]

inductive Regime where | validationPolicy deriving Repr, DecidableEq
inductive Purpose where | currentUse deriving Repr, DecidableEq
inductive LocalEvidence where | policyConformance deriving Repr, DecidableEq
inductive HigherInput where | externalAdequacyEvidence deriving Repr, DecidableEq

def evaluationModel : EvaluationLayerCore where
  Subject := Subject
  Regime := Regime
  Purpose := Purpose
  LocalEvidence := LocalEvidence
  HigherInput := HigherInput
  LocalConformance := fun regime subject evidence =>
    regime = .validationPolicy ∧
    subject = .assertion ∧
    evidence = .policyConformance
  HigherAccepted := fun _ _ _ _ => False

theorem local_conformance_without_higher_acceptance :
    evaluationModel.LocalConformance
        .validationPolicy .assertion .policyConformance ∧
    ¬ evaluationModel.HigherAccepted
        .validationPolicy .assertion .currentUse .externalAdequacyEvidence := by
  simp [evaluationModel]

end SoftwareRegression

/-- Integration statement: the same CI-2 calculus admits all three heterogeneous
XDI case encodings plus the D4 software regression encoding.  This theorem says
nothing about empirical correctness of the encodings beyond the audited source
interpretation recorded outside Lean. -/
theorem ci2_case_models_share_one_calculus :
    Maintenance.impact_without_discharge ∧
    InstitutionalAuthority.impact_without_discharge ∧
    Measurement.impact_without_discharge ∧
    SoftwareRegression.impact_without_discharge := by
  exact ⟨Maintenance.impact_without_discharge,
    InstitutionalAuthority.impact_without_discharge,
    Measurement.impact_without_discharge,
    SoftwareRegression.impact_without_discharge⟩

/-- Integration statement for the CI-3 evaluation-layer separation. -/
theorem ci3_case_models_share_one_calculus :
    Maintenance.local_conformance_without_higher_acceptance ∧
    InstitutionalAuthority.local_conformance_without_higher_acceptance ∧
    Measurement.local_conformance_without_higher_acceptance ∧
    SoftwareRegression.local_conformance_without_higher_acceptance := by
  exact ⟨Maintenance.local_conformance_without_higher_acceptance,
    InstitutionalAuthority.local_conformance_without_higher_acceptance,
    Measurement.local_conformance_without_higher_acceptance,
    SoftwareRegression.local_conformance_without_higher_acceptance⟩

end ResponsibilityTopology.CrossDomain.CaseModels
