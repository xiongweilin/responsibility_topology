import ResponsibilityTopology.CrossDomain.Interpretation
import ResponsibilityTopology.CrossDomain.CaseModels

namespace ResponsibilityTopology.CrossDomain.InterpretedCaseModels

/-!
Strict-L6 source-semantics interpretations for the four already-audited cases.

These `M_*` objects are finite interpretation models reconstructed from the XDI
and D4 audits.  They are not formalizations of FAA regulations, U.S. public law,
metrology standards, or the portable-runtime implementation.

Each model is explicitly interpreted into the already-existing parametric core
instance from `CaseModels.lean`.  The carrier maps happen to be identities in
these finite encodings; the responsibility relation preservation/reflection
obligations are still stated and checked explicitly.
-/

namespace Maintenance

alias S := CaseModels.Maintenance.Subject
alias Cg := CaseModels.Maintenance.Change
alias IE := CaseModels.Maintenance.ImpactEvidence
alias Req := CaseModels.Maintenance.Requirement
alias Resp := CaseModels.Maintenance.Response
alias RE := CaseModels.Maintenance.RealizationEvidence
alias Reg := CaseModels.Maintenance.Regime
alias Pur := CaseModels.Maintenance.Purpose
alias LE := CaseModels.Maintenance.LocalEvidence
alias HI := CaseModels.Maintenance.HigherInput

/-- Source-audited finite maintenance semantics. -/
def impactSemantics : ImpactDomainSemantics where
  Subject := S
  Change := Cg
  ImpactEvidence := IE
  Requirement := Req
  Response := Resp
  RealizationEvidence := RE
  DomainAffected := fun s c e =>
    s = .component ∧ c = .unsafeCondition ∧ e = .directiveApplies
  DomainRequires := fun s c r =>
    s = .component ∧ c = .unsafeCondition ∧ r = .correctiveAction
  DomainResponseCovers := fun response requirement =>
    response = .replaceComponent ∧ requirement = .correctiveAction
  DomainRealized := fun response evidence =>
    response = .replaceComponent ∧ evidence = .maintenanceRelease
  DomainDischarged := fun _ _ => False

def impactInterpretation :
    ImpactDischargeInterpretation impactSemantics CaseModels.Maintenance.impactModel where
  mapSubject := fun x => x
  mapChange := fun x => x
  mapImpactEvidence := fun x => x
  mapRequirement := fun x => x
  mapResponse := fun x => x
  mapRealizationEvidence := fun x => x
  affected_preserved := by
    intro subject change impact h
    simpa [impactSemantics, CaseModels.Maintenance.impactModel] using h
  requires_preserved := by
    intro subject change requirement h
    simpa [impactSemantics, CaseModels.Maintenance.impactModel] using h
  responseCovers_preserved := by
    intro response requirement h
    simpa [impactSemantics, CaseModels.Maintenance.impactModel] using h
  realized_preserved := by
    intro response evidence h
    simpa [impactSemantics, CaseModels.Maintenance.impactModel] using h
  discharge_reflected := by
    intro subject change h
    simpa [impactSemantics, CaseModels.Maintenance.impactModel] using h

def evaluationSemantics : EvaluationDomainSemantics where
  Subject := S
  Regime := Reg
  Purpose := Pur
  LocalEvidence := LE
  HigherInput := HI
  DomainLocalConformance := fun regime subject evidence =>
    regime = .maintenanceProcedure ∧ subject = .component ∧ evidence = .procedureConformance
  DomainHigherAccepted := fun _ _ _ _ => False

def evaluationInterpretation :
    EvaluationInterpretation evaluationSemantics CaseModels.Maintenance.evaluationModel where
  mapSubject := fun x => x
  mapRegime := fun x => x
  mapPurpose := fun x => x
  mapLocalEvidence := fun x => x
  mapHigherInput := fun x => x
  localConformance_preserved := by
    intro regime subject evidence h
    simpa [evaluationSemantics, CaseModels.Maintenance.evaluationModel] using h
  higherAccepted_reflected := by
    intro regime subject purpose higherInput h
    simpa [evaluationSemantics, CaseModels.Maintenance.evaluationModel] using h

end Maintenance

namespace InstitutionalAuthority

alias S := CaseModels.InstitutionalAuthority.Subject
alias Cg := CaseModels.InstitutionalAuthority.Change
alias IE := CaseModels.InstitutionalAuthority.ImpactEvidence
alias Req := CaseModels.InstitutionalAuthority.Requirement
alias Resp := CaseModels.InstitutionalAuthority.Response
alias RE := CaseModels.InstitutionalAuthority.RealizationEvidence
alias Reg := CaseModels.InstitutionalAuthority.Regime
alias Pur := CaseModels.InstitutionalAuthority.Purpose
alias LE := CaseModels.InstitutionalAuthority.LocalEvidence
alias HI := CaseModels.InstitutionalAuthority.HigherInput

def impactSemantics : ImpactDomainSemantics where
  Subject := S
  Change := Cg
  ImpactEvidence := IE
  Requirement := Req
  Response := Resp
  RealizationEvidence := RE
  DomainAffected := fun s c e =>
    s = .officialAct ∧ c = .authorityDefect ∧ e = .appointmentDefectFound
  DomainRequires := fun s c r =>
    s = .officialAct ∧ c = .authorityDefect ∧ r = .legallySufficientRemedy
  DomainResponseCovers := fun response requirement =>
    response = .newHearing ∧ requirement = .legallySufficientRemedy
  DomainRealized := fun response evidence =>
    response = .newHearing ∧ evidence = .properlyAuthorizedHearing
  DomainDischarged := fun _ _ => False

def impactInterpretation :
    ImpactDischargeInterpretation impactSemantics CaseModels.InstitutionalAuthority.impactModel where
  mapSubject := fun x => x
  mapChange := fun x => x
  mapImpactEvidence := fun x => x
  mapRequirement := fun x => x
  mapResponse := fun x => x
  mapRealizationEvidence := fun x => x
  affected_preserved := by
    intro subject change impact h
    simpa [impactSemantics, CaseModels.InstitutionalAuthority.impactModel] using h
  requires_preserved := by
    intro subject change requirement h
    simpa [impactSemantics, CaseModels.InstitutionalAuthority.impactModel] using h
  responseCovers_preserved := by
    intro response requirement h
    simpa [impactSemantics, CaseModels.InstitutionalAuthority.impactModel] using h
  realized_preserved := by
    intro response evidence h
    simpa [impactSemantics, CaseModels.InstitutionalAuthority.impactModel] using h
  discharge_reflected := by
    intro subject change h
    simpa [impactSemantics, CaseModels.InstitutionalAuthority.impactModel] using h

def evaluationSemantics : EvaluationDomainSemantics where
  Subject := S
  Regime := Reg
  Purpose := Pur
  LocalEvidence := LE
  HigherInput := HI
  DomainLocalConformance := fun regime subject evidence =>
    regime = .agencyProcedure ∧ subject = .officialAct ∧ evidence = .proceduralCompliance
  DomainHigherAccepted := fun _ _ _ _ => False

def evaluationInterpretation :
    EvaluationInterpretation evaluationSemantics CaseModels.InstitutionalAuthority.evaluationModel where
  mapSubject := fun x => x
  mapRegime := fun x => x
  mapPurpose := fun x => x
  mapLocalEvidence := fun x => x
  mapHigherInput := fun x => x
  localConformance_preserved := by
    intro regime subject evidence h
    simpa [evaluationSemantics, CaseModels.InstitutionalAuthority.evaluationModel] using h
  higherAccepted_reflected := by
    intro regime subject purpose higherInput h
    simpa [evaluationSemantics, CaseModels.InstitutionalAuthority.evaluationModel] using h

end InstitutionalAuthority

namespace Measurement

alias S := CaseModels.Measurement.Subject
alias Cg := CaseModels.Measurement.Change
alias IE := CaseModels.Measurement.ImpactEvidence
alias Req := CaseModels.Measurement.Requirement
alias Resp := CaseModels.Measurement.Response
alias RE := CaseModels.Measurement.RealizationEvidence
alias Reg := CaseModels.Measurement.Regime
alias Pur := CaseModels.Measurement.Purpose
alias LE := CaseModels.Measurement.LocalEvidence
alias HI := CaseModels.Measurement.HigherInput

def impactSemantics : ImpactDomainSemantics where
  Subject := S
  Change := Cg
  ImpactEvidence := IE
  Requirement := Req
  Response := Resp
  RealizationEvidence := RE
  DomainAffected := fun s c e =>
    s = .measurementResult ∧ c = .processOutOfControl ∧ e = .controlSignal
  DomainRequires := fun s c r =>
    s = .measurementResult ∧ c = .processOutOfControl ∧ r = .measurementRemediation
  DomainResponseCovers := fun response requirement =>
    response = .recalibrate ∧ requirement = .measurementRemediation
  DomainRealized := fun response evidence =>
    response = .recalibrate ∧ evidence = .controlReestablished
  DomainDischarged := fun _ _ => False

def impactInterpretation :
    ImpactDischargeInterpretation impactSemantics CaseModels.Measurement.impactModel where
  mapSubject := fun x => x
  mapChange := fun x => x
  mapImpactEvidence := fun x => x
  mapRequirement := fun x => x
  mapResponse := fun x => x
  mapRealizationEvidence := fun x => x
  affected_preserved := by
    intro subject change impact h
    simpa [impactSemantics, CaseModels.Measurement.impactModel] using h
  requires_preserved := by
    intro subject change requirement h
    simpa [impactSemantics, CaseModels.Measurement.impactModel] using h
  responseCovers_preserved := by
    intro response requirement h
    simpa [impactSemantics, CaseModels.Measurement.impactModel] using h
  realized_preserved := by
    intro response evidence h
    simpa [impactSemantics, CaseModels.Measurement.impactModel] using h
  discharge_reflected := by
    intro subject change h
    simpa [impactSemantics, CaseModels.Measurement.impactModel] using h

def evaluationSemantics : EvaluationDomainSemantics where
  Subject := S
  Regime := Reg
  Purpose := Pur
  LocalEvidence := LE
  HigherInput := HI
  DomainLocalConformance := fun regime subject evidence =>
    regime = .measurementProcedure ∧ subject = .measurementResult ∧ evidence = .traceabilityConformance
  DomainHigherAccepted := fun _ _ _ _ => False

def evaluationInterpretation :
    EvaluationInterpretation evaluationSemantics CaseModels.Measurement.evaluationModel where
  mapSubject := fun x => x
  mapRegime := fun x => x
  mapPurpose := fun x => x
  mapLocalEvidence := fun x => x
  mapHigherInput := fun x => x
  localConformance_preserved := by
    intro regime subject evidence h
    simpa [evaluationSemantics, CaseModels.Measurement.evaluationModel] using h
  higherAccepted_reflected := by
    intro regime subject purpose higherInput h
    simpa [evaluationSemantics, CaseModels.Measurement.evaluationModel] using h

end Measurement

namespace SoftwareRegression

alias S := CaseModels.SoftwareRegression.Subject
alias Cg := CaseModels.SoftwareRegression.Change
alias IE := CaseModels.SoftwareRegression.ImpactEvidence
alias Req := CaseModels.SoftwareRegression.Requirement
alias Resp := CaseModels.SoftwareRegression.Response
alias RE := CaseModels.SoftwareRegression.RealizationEvidence
alias Reg := CaseModels.SoftwareRegression.Regime
alias Pur := CaseModels.SoftwareRegression.Purpose
alias LE := CaseModels.SoftwareRegression.LocalEvidence
alias HI := CaseModels.SoftwareRegression.HigherInput

def impactSemantics : ImpactDomainSemantics where
  Subject := S
  Change := Cg
  ImpactEvidence := IE
  Requirement := Req
  Response := Resp
  RealizationEvidence := RE
  DomainAffected := fun s c e =>
    s = .assertion ∧ c = .dependencyChanged ∧ e = .revalidationRequired
  DomainRequires := fun s c r =>
    s = .assertion ∧ c = .dependencyChanged ∧ r = .requalification
  DomainResponseCovers := fun response requirement =>
    response = .rerunValidation ∧ requirement = .requalification
  DomainRealized := fun response evidence =>
    response = .rerunValidation ∧ evidence = .acceptedValidation
  DomainDischarged := fun _ _ => False

def impactInterpretation :
    ImpactDischargeInterpretation impactSemantics CaseModels.SoftwareRegression.impactModel where
  mapSubject := fun x => x
  mapChange := fun x => x
  mapImpactEvidence := fun x => x
  mapRequirement := fun x => x
  mapResponse := fun x => x
  mapRealizationEvidence := fun x => x
  affected_preserved := by
    intro subject change impact h
    simpa [impactSemantics, CaseModels.SoftwareRegression.impactModel] using h
  requires_preserved := by
    intro subject change requirement h
    simpa [impactSemantics, CaseModels.SoftwareRegression.impactModel] using h
  responseCovers_preserved := by
    intro response requirement h
    simpa [impactSemantics, CaseModels.SoftwareRegression.impactModel] using h
  realized_preserved := by
    intro response evidence h
    simpa [impactSemantics, CaseModels.SoftwareRegression.impactModel] using h
  discharge_reflected := by
    intro subject change h
    simpa [impactSemantics, CaseModels.SoftwareRegression.impactModel] using h

def evaluationSemantics : EvaluationDomainSemantics where
  Subject := S
  Regime := Reg
  Purpose := Pur
  LocalEvidence := LE
  HigherInput := HI
  DomainLocalConformance := fun regime subject evidence =>
    regime = .validationPolicy ∧ subject = .assertion ∧ evidence = .policyConformance
  DomainHigherAccepted := fun _ _ _ _ => False

def evaluationInterpretation :
    EvaluationInterpretation evaluationSemantics CaseModels.SoftwareRegression.evaluationModel where
  mapSubject := fun x => x
  mapRegime := fun x => x
  mapPurpose := fun x => x
  mapLocalEvidence := fun x => x
  mapHigherInput := fun x => x
  localConformance_preserved := by
    intro regime subject evidence h
    simpa [evaluationSemantics, CaseModels.SoftwareRegression.evaluationModel] using h
  higherAccepted_reflected := by
    intro regime subject purpose higherInput h
    simpa [evaluationSemantics, CaseModels.SoftwareRegression.evaluationModel] using h

end SoftwareRegression

/-- All four source-audited finite semantics use the same generic
`domainAffected_to_coreAffected` interpretation method. -/
theorem d1_d4_affected_interpret_through_one_interface :
    CaseModels.Maintenance.impactModel.Affected
        .component .unsafeCondition .directiveApplies ∧
    CaseModels.InstitutionalAuthority.impactModel.Affected
        .officialAct .authorityDefect .appointmentDefectFound ∧
    CaseModels.Measurement.impactModel.Affected
        .measurementResult .processOutOfControl .controlSignal ∧
    CaseModels.SoftwareRegression.impactModel.Affected
        .assertion .dependencyChanged .revalidationRequired := by
  constructor
  · exact ImpactDischargeInterpretation.domainAffected_to_coreAffected
      Maintenance.impactInterpretation (by simp [Maintenance.impactSemantics])
  constructor
  · exact ImpactDischargeInterpretation.domainAffected_to_coreAffected
      InstitutionalAuthority.impactInterpretation
      (by simp [InstitutionalAuthority.impactSemantics])
  constructor
  · exact ImpactDischargeInterpretation.domainAffected_to_coreAffected
      Measurement.impactInterpretation (by simp [Measurement.impactSemantics])
  · exact ImpactDischargeInterpretation.domainAffected_to_coreAffected
      SoftwareRegression.impactInterpretation
      (by simp [SoftwareRegression.impactSemantics])

/-- D1-D4 local-conformance observations likewise pass through one generic
interpretation lemma.  No higher-order verdict is derived. -/
theorem d1_d4_local_conformance_interpret_through_one_interface :
    CaseModels.Maintenance.evaluationModel.LocalConformance
        .maintenanceProcedure .component .procedureConformance ∧
    CaseModels.InstitutionalAuthority.evaluationModel.LocalConformance
        .agencyProcedure .officialAct .proceduralCompliance ∧
    CaseModels.Measurement.evaluationModel.LocalConformance
        .measurementProcedure .measurementResult .traceabilityConformance ∧
    CaseModels.SoftwareRegression.evaluationModel.LocalConformance
        .validationPolicy .assertion .policyConformance := by
  constructor
  · exact EvaluationInterpretation.domainLocalConformance_to_coreLocalConformance
      Maintenance.evaluationInterpretation (by simp [Maintenance.evaluationSemantics])
  constructor
  · exact EvaluationInterpretation.domainLocalConformance_to_coreLocalConformance
      InstitutionalAuthority.evaluationInterpretation
      (by simp [InstitutionalAuthority.evaluationSemantics])
  constructor
  · exact EvaluationInterpretation.domainLocalConformance_to_coreLocalConformance
      Measurement.evaluationInterpretation (by simp [Measurement.evaluationSemantics])
  · exact EvaluationInterpretation.domainLocalConformance_to_coreLocalConformance
      SoftwareRegression.evaluationInterpretation
      (by simp [SoftwareRegression.evaluationSemantics])

end ResponsibilityTopology.CrossDomain.InterpretedCaseModels
