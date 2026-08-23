import ResponsibilityTopology.CrossDomain.ImpactDischargeCore
import ResponsibilityTopology.CrossDomain.EvaluationLayerCore

namespace ResponsibilityTopology.CrossDomain

/-!
Explicit interpretation layer for the strict Level-6 cross-domain gate.

The parametric calculi already exist.  This module does not introduce another
responsibility ontology.  It separates a source-audited finite domain semantics
`M` from a core calculus instance `C` and records the maps and preservation /
reflection obligations that justify reading `C` as an abstraction of `M`.

An interpretation is an obligation-bearing bridge.  It is not evidence that the
real external domain itself has been formalized.
-/

structure ImpactDomainSemantics where
  Subject : Type
  Change : Type
  ImpactEvidence : Type
  Requirement : Type
  Response : Type
  RealizationEvidence : Type

  DomainAffected : Subject → Change → ImpactEvidence → Prop
  DomainRequires : Subject → Change → Requirement → Prop
  DomainResponseCovers : Response → Requirement → Prop
  DomainRealized : Response → RealizationEvidence → Prop
  DomainDischarged : Subject → Change → Prop

/-- Interpretation from one finite source semantics into an existing
`ImpactDischargeCore` instance.

`discharge_reflected` is intentionally an interpretation obligation.  The core
calculus does not manufacture domain discharge on its own. -/
structure ImpactDischargeInterpretation
    (M : ImpactDomainSemantics)
    (C : ImpactDischargeCore) where
  mapSubject : M.Subject → C.Subject
  mapChange : M.Change → C.Change
  mapImpactEvidence : M.ImpactEvidence → C.ImpactEvidence
  mapRequirement : M.Requirement → C.Requirement
  mapResponse : M.Response → C.Response
  mapRealizationEvidence : M.RealizationEvidence → C.RealizationEvidence

  affected_preserved :
    ∀ {subject change impact},
      M.DomainAffected subject change impact →
      C.Affected (mapSubject subject) (mapChange change) (mapImpactEvidence impact)

  requires_preserved :
    ∀ {subject change requirement},
      M.DomainRequires subject change requirement →
      C.Requires (mapSubject subject) (mapChange change) (mapRequirement requirement)

  responseCovers_preserved :
    ∀ {response requirement},
      M.DomainResponseCovers response requirement →
      C.ResponseCovers (mapResponse response) (mapRequirement requirement)

  realized_preserved :
    ∀ {response evidence},
      M.DomainRealized response evidence →
      C.Realized (mapResponse response) (mapRealizationEvidence evidence)

  discharge_reflected :
    ∀ {subject change},
      C.Discharged (mapSubject subject) (mapChange change) →
      M.DomainDischarged subject change

namespace ImpactDischargeInterpretation

/-- Source-domain affectedness maps into the core through the explicit
interpretation; this is not a claim that affectedness implies discharge. -/
theorem domainAffected_to_coreAffected
    {M : ImpactDomainSemantics}
    {C : ImpactDischargeCore}
    (I : ImpactDischargeInterpretation M C)
    {subject : M.Subject}
    {change : M.Change}
    {impact : M.ImpactEvidence}
    (hAffected : M.DomainAffected subject change impact) :
    C.Affected (I.mapSubject subject) (I.mapChange change) (I.mapImpactEvidence impact) := by
  exact I.affected_preserved hAffected

/-- Reuse of the existing generic core theorem followed by an explicit
interpretation read-back.

The crucial sufficiency premise remains external to both the core structure and
the interpretation.  Likewise, coverage and realization are supplied at the
core level; this theorem does not assume that an interpretation has captured all
real-world requirements or evidence. -/
theorem interpreted_core_discharge_reads_back
    {M : ImpactDomainSemantics}
    {C : ImpactDischargeCore}
    (I : ImpactDischargeInterpretation M C)
    (hSufficient : ImpactDischargeCore.CoverageRealizationSufficient C)
    {subject : M.Subject}
    {change : M.Change}
    {selected : List C.Response}
    {evidence : List C.RealizationEvidence}
    (hCovered :
      ImpactDischargeCore.RequirementsCovered
        C (I.mapSubject subject) (I.mapChange change) selected)
    (hRealized : ImpactDischargeCore.SoundRealization C selected evidence) :
    M.DomainDischarged subject change := by
  apply I.discharge_reflected
  exact ImpactDischargeCore.requirementsCovered_and_soundRealization_imply_discharged
    C hSufficient hCovered hRealized

end ImpactDischargeInterpretation

structure EvaluationDomainSemantics where
  Subject : Type
  Regime : Type
  Purpose : Type
  LocalEvidence : Type
  HigherInput : Type

  DomainLocalConformance : Regime → Subject → LocalEvidence → Prop
  DomainHigherAccepted : Regime → Subject → Purpose → HigherInput → Prop

/-- Explicit source-semantics interpretation for `EvaluationLayerCore`.

No adequacy predicate is introduced.  Local conformance is preserved into the
core, while a positive higher-order core verdict may be read back only through
an explicit reflection obligation. -/
structure EvaluationInterpretation
    (M : EvaluationDomainSemantics)
    (C : EvaluationLayerCore) where
  mapSubject : M.Subject → C.Subject
  mapRegime : M.Regime → C.Regime
  mapPurpose : M.Purpose → C.Purpose
  mapLocalEvidence : M.LocalEvidence → C.LocalEvidence
  mapHigherInput : M.HigherInput → C.HigherInput

  localConformance_preserved :
    ∀ {regime subject evidence},
      M.DomainLocalConformance regime subject evidence →
      C.LocalConformance (mapRegime regime) (mapSubject subject) (mapLocalEvidence evidence)

  higherAccepted_reflected :
    ∀ {regime subject purpose higherInput},
      C.HigherAccepted
        (mapRegime regime)
        (mapSubject subject)
        (mapPurpose purpose)
        (mapHigherInput higherInput) →
      M.DomainHigherAccepted regime subject purpose higherInput

namespace EvaluationInterpretation

/-- The interpretation carries local evidence into the core.  There is
intentionally no generic theorem from this fact to a higher-order verdict. -/
theorem domainLocalConformance_to_coreLocalConformance
    {M : EvaluationDomainSemantics}
    {C : EvaluationLayerCore}
    (I : EvaluationInterpretation M C)
    {regime : M.Regime}
    {subject : M.Subject}
    {evidence : M.LocalEvidence}
    (hLocal : M.DomainLocalConformance regime subject evidence) :
    C.LocalConformance
      (I.mapRegime regime)
      (I.mapSubject subject)
      (I.mapLocalEvidence evidence) := by
  exact I.localConformance_preserved hLocal

/-- Positive higher-order core acceptance can be read back only because the
interpretation explicitly undertakes that obligation. -/
theorem coreHigherAccepted_reads_back
    {M : EvaluationDomainSemantics}
    {C : EvaluationLayerCore}
    (I : EvaluationInterpretation M C)
    {regime : M.Regime}
    {subject : M.Subject}
    {purpose : M.Purpose}
    {higherInput : M.HigherInput}
    (hHigher :
      C.HigherAccepted
        (I.mapRegime regime)
        (I.mapSubject subject)
        (I.mapPurpose purpose)
        (I.mapHigherInput higherInput)) :
    M.DomainHigherAccepted regime subject purpose higherInput := by
  exact I.higherAccepted_reflected hHigher

end EvaluationInterpretation

end ResponsibilityTopology.CrossDomain
