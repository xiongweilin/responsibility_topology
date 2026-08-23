import ResponsibilityTopology.CrossDomain.Interpretation
import ResponsibilityTopology.CrossDomain.CaseModels

namespace ResponsibilityTopology.CrossDomain.InterpretedCaseModels

/-!
Strict-L6 source-semantics interpretations for the four already-audited cases.

These finite `M_D` objects reconstruct only the responsibility cuts established
by the XDI and D4 audits. They are not formalizations of FAA regulations,
U.S. public law, metrology standards, or the portable-runtime implementation.

Each `M_D` is explicitly interpreted into the already-existing core instance in
`CaseModels.lean`. The finite carrier maps are identities because the source
model intentionally reuses the audited carrier types, but every responsibility
relation preservation/reflection obligation remains explicit and checked.
-/

namespace Maintenance

def impactSemantics : ImpactDomainSemantics where
  Subject := CaseModels.Maintenance.Subject
  Change := CaseModels.Maintenance.Change
  ImpactEvidence := CaseModels.Maintenance.ImpactEvidence
  Requirement := CaseModels.Maintenance.Requirement
  Response := CaseModels.Maintenance.Response
  RealizationEvidence := CaseModels.Maintenance.RealizationEvidence
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
  Subject := CaseModels.Maintenance.Subject
  Regime := CaseModels.Maintenance.Regime
  Purpose := CaseModels.Maintenance.Purpose
  LocalEvidence := CaseModels.Maintenance.LocalEvidence
  HigherInput := CaseModels.Maintenance.HigherInput
  DomainLocalConformance := fun regime subject evidence =>
    regime = .maintenanceProcedure ∧
    subject = .component ∧
    evidence = .procedureConformance
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

def impactSemantics : ImpactDomainSemantics where
  Subject := CaseModels.InstitutionalAuthority.Subject
  Change := CaseModels.InstitutionalAuthority.Change
  ImpactEvidence := CaseModels.InstitutionalAuthority.ImpactEvidence
  Requirement := CaseModels.InstitutionalAuthority.Requirement
  Response := CaseModels.InstitutionalAuthority.Response
  RealizationEvidence := CaseModels.InstitutionalAuthority.RealizationEvidence
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
  Subject := CaseModels.InstitutionalAuthority.Subject
  Regime := CaseModels.InstitutionalAuthority.Regime
  Purpose := CaseModels.InstitutionalAuthority.Purpose
  LocalEvidence := CaseModels.InstitutionalAuthority.LocalEvidence
  HigherInput := CaseModels.InstitutionalAuthority.HigherInput
  DomainLocalConformance := fun regime subject evidence =>
    regime = .agencyProcedure ∧
    subject = .officialAct ∧
    evidence = .proceduralCompliance
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

def impactSemantics : ImpactDomainSemantics where
  Subject := CaseModels.Measurement.Subject
  Change := CaseModels.Measurement.Change
  ImpactEvidence := CaseModels.Measurement.ImpactEvidence
  Requirement := CaseModels.Measurement.Requirement
  Response := CaseModels.Measurement.Response
  RealizationEvidence := CaseModels.Measurement.RealizationEvidence
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
  Subject := CaseModels.Measurement.Subject
  Regime := CaseModels.Measurement.Regime
  Purpose := CaseModels.Measurement.Purpose
  LocalEvidence := CaseModels.Measurement.LocalEvidence
  HigherInput := CaseModels.Measurement.HigherInput
  DomainLocalConformance := fun regime subject evidence =>
    regime = .measurementProcedure ∧
    subject = .measurementResult ∧
    evidence = .traceabilityConformance
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

def impactSemantics : ImpactDomainSemantics where
  Subject := CaseModels.SoftwareRegression.Subject
  Change := CaseModels.SoftwareRegression.Change
  ImpactEvidence := CaseModels.SoftwareRegression.ImpactEvidence
  Requirement := CaseModels.SoftwareRegression.Requirement
  Response := CaseModels.SoftwareRegression.Response
  RealizationEvidence := CaseModels.SoftwareRegression.RealizationEvidence
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
  Subject := CaseModels.SoftwareRegression.Subject
  Regime := CaseModels.SoftwareRegression.Regime
  Purpose := CaseModels.SoftwareRegression.Purpose
  LocalEvidence := CaseModels.SoftwareRegression.LocalEvidence
  HigherInput := CaseModels.SoftwareRegression.HigherInput
  DomainLocalConformance := fun regime subject evidence =>
    regime = .validationPolicy ∧
    subject = .assertion ∧
    evidence = .policyConformance
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

/-- D1-D4 affectedness observations all pass through the same generic
interpretation lemma. -/
theorem d1_d4_affected_interpret_through_one_interface :
    CaseModels.Maintenance.impactModel.Affected
        .component .unsafeCondition .directiveApplies ∧
    CaseModels.InstitutionalAuthority.impactModel.Affected
        .officialAct .authorityDefect .appointmentDefectFound ∧
    CaseModels.Measurement.impactModel.Affected
        .measurementResult .processOutOfControl .controlSignal ∧
    CaseModels.SoftwareRegression.impactModel.Affected
        .assertion .dependencyChanged .revalidationRequired := by
  refine ⟨?_, ?_, ?_, ?_⟩
  · exact ImpactDischargeInterpretation.domainAffected_to_coreAffected
      Maintenance.impactInterpretation (by simp [Maintenance.impactSemantics])
  · exact ImpactDischargeInterpretation.domainAffected_to_coreAffected
      InstitutionalAuthority.impactInterpretation
      (by simp [InstitutionalAuthority.impactSemantics])
  · exact ImpactDischargeInterpretation.domainAffected_to_coreAffected
      Measurement.impactInterpretation (by simp [Measurement.impactSemantics])
  · exact ImpactDischargeInterpretation.domainAffected_to_coreAffected
      SoftwareRegression.impactInterpretation
      (by simp [SoftwareRegression.impactSemantics])

/-- D1-D4 local-conformance observations likewise pass through one generic
interpretation lemma. No higher-order verdict is derived. -/
theorem d1_d4_local_conformance_interpret_through_one_interface :
    CaseModels.Maintenance.evaluationModel.LocalConformance
        .maintenanceProcedure .component .procedureConformance ∧
    CaseModels.InstitutionalAuthority.evaluationModel.LocalConformance
        .agencyProcedure .officialAct .proceduralCompliance ∧
    CaseModels.Measurement.evaluationModel.LocalConformance
        .measurementProcedure .measurementResult .traceabilityConformance ∧
    CaseModels.SoftwareRegression.evaluationModel.LocalConformance
        .validationPolicy .assertion .policyConformance := by
  refine ⟨?_, ?_, ?_, ?_⟩
  · exact EvaluationInterpretation.domainLocalConformance_to_coreLocalConformance
      Maintenance.evaluationInterpretation (by simp [Maintenance.evaluationSemantics])
  · exact EvaluationInterpretation.domainLocalConformance_to_coreLocalConformance
      InstitutionalAuthority.evaluationInterpretation
      (by simp [InstitutionalAuthority.evaluationSemantics])
  · exact EvaluationInterpretation.domainLocalConformance_to_coreLocalConformance
      Measurement.evaluationInterpretation (by simp [Measurement.evaluationSemantics])
  · exact EvaluationInterpretation.domainLocalConformance_to_coreLocalConformance
      SoftwareRegression.evaluationInterpretation
      (by simp [SoftwareRegression.evaluationSemantics])

end ResponsibilityTopology.CrossDomain.InterpretedCaseModels
