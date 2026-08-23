namespace ResponsibilityTopology.CrossDomain

/-!
A minimal domain-parametric calculus for CI-2.

This module intentionally does not import the Paper 1-3 object model.  In
particular it contains no warrant, license, challenge, repair-hypergraph, or
currentness vocabulary.

The core records only the roles needed to distinguish impact observation from
sufficient discharge.  The theorem connecting requirement coverage and sound
realization to discharge takes an explicit external adequacy premise; that
premise is not a law baked into `ImpactDischargeCore`.
-/

structure ImpactDischargeCore where
  Subject : Type
  Change : Type
  ImpactEvidence : Type
  Requirement : Type
  Response : Type
  RealizationEvidence : Type

  Affected : Subject → Change → ImpactEvidence → Prop
  Requires : Subject → Change → Requirement → Prop
  ResponseCovers : Response → Requirement → Prop
  Realized : Response → RealizationEvidence → Prop
  Discharged : Subject → Change → Prop

namespace ImpactDischargeCore

/-- Every represented requirement for one subject/change pair is covered by at
least one selected response.  This definition imposes no hypergraph structure. -/
def RequirementsCovered
    (D : ImpactDischargeCore)
    (subject : D.Subject)
    (change : D.Change)
    (selected : List D.Response) : Prop :=
  ∀ requirement,
    D.Requires subject change requirement →
      ∃ response,
        response ∈ selected ∧
        D.ResponseCovers response requirement

/-- Every selected response has some explicit realization evidence. -/
def SoundRealization
    (D : ImpactDischargeCore)
    (selected : List D.Response)
    (evidence : List D.RealizationEvidence) : Prop :=
  ∀ response,
    response ∈ selected →
      ∃ witness,
        witness ∈ evidence ∧
        D.Realized response witness

/-- External adequacy premise connecting the represented coverage/realization
judgments to the domain's discharge judgment.  It is deliberately separate from
the core structure so a domain instance cannot obtain the headline theorem by
simply storing its conclusion as an instance law. -/
def CoverageRealizationSufficient (D : ImpactDischargeCore) : Prop :=
  ∀ subject change selected evidence,
    RequirementsCovered D subject change selected →
    SoundRealization D selected evidence →
    D.Discharged subject change

/-- Generic composition theorem.  The result is conditional on the explicit
adequacy premise that the represented requirements and realization evidence are
sufficient for the domain's discharge judgment. -/
theorem requirementsCovered_and_soundRealization_imply_discharged
    (D : ImpactDischargeCore)
    (hSufficient : CoverageRealizationSufficient D)
    {subject : D.Subject}
    {change : D.Change}
    {selected : List D.Response}
    {evidence : List D.RealizationEvidence}
    (hCovered : RequirementsCovered D subject change selected)
    (hRealized : SoundRealization D selected evidence) :
    D.Discharged subject change := by
  exact hSufficient subject change selected evidence hCovered hRealized

/-- Finite one-point countermodel: an impact can be observed while discharge is
false.  This model has no requirements or successful realization mechanism; its
purpose is solely to refute the shortcut `Affected -> Discharged` as a theorem of
the bare core vocabulary. -/
def affectedNotDischargedModel : ImpactDischargeCore where
  Subject := Unit
  Change := Unit
  ImpactEvidence := Unit
  Requirement := Unit
  Response := Unit
  RealizationEvidence := Unit
  Affected := fun _ _ _ => True
  Requires := fun _ _ _ => False
  ResponseCovers := fun _ _ => False
  Realized := fun _ _ => False
  Discharged := fun _ _ => False

/-- Concrete counterexample witness for CI-2. -/
theorem affected_without_discharge_exists :
    ∃ D : ImpactDischargeCore,
      ∃ subject : D.Subject,
        ∃ change : D.Change,
          ∃ impact : D.ImpactEvidence,
            D.Affected subject change impact ∧
            ¬ D.Discharged subject change := by
  refine ⟨affectedNotDischargedModel, (), (), (), ?_, ?_⟩
  · trivial
  · simp [affectedNotDischargedModel]

/-- Stronger semantic non-validity statement: the universal inference schema
`Affected -> Discharged` is false over the class of models admitted by this
calculus.  CI-2 is therefore not recovered from a typeclass field that already
states its conclusion. -/
theorem affected_does_not_semantically_force_discharge :
    ¬ (∀ (D : ImpactDischargeCore)
          (subject : D.Subject)
          (change : D.Change)
          (impact : D.ImpactEvidence),
        D.Affected subject change impact →
        D.Discharged subject change) := by
  intro hUniversal
  have hDischarged :=
    hUniversal affectedNotDischargedModel () () () (by trivial)
  simpa [affectedNotDischargedModel] using hDischarged

end ImpactDischargeCore

end ResponsibilityTopology.CrossDomain
