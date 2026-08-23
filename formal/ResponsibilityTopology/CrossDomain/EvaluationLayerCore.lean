namespace ResponsibilityTopology.CrossDomain

/-!
A minimal domain-parametric calculus for CI-3.

The module formalizes only an evaluation-level separation.  It does not define
what higher-order adequacy, legal validity, safety sufficiency, scientific
fitness-for-purpose, or Q_open entitlement mean.  It also does not import the
Paper 1-3 object model.
-/

structure EvaluationLayerCore where
  Subject : Type
  Regime : Type
  Purpose : Type
  LocalEvidence : Type
  HigherInput : Type

  LocalConformance : Regime → Subject → LocalEvidence → Prop
  HigherAccepted : Regime → Subject → Purpose → HigherInput → Prop

namespace EvaluationLayerCore

/-- One-point model in which local conformance holds while the higher-order
judgment is false.  This finite model is enough to refute an unconditional
`LocalConformance -> HigherAccepted` schema over the bare calculus. -/
def localButHigherRejectedModel : EvaluationLayerCore where
  Subject := Unit
  Regime := Unit
  Purpose := Unit
  LocalEvidence := Unit
  HigherInput := Unit
  LocalConformance := fun _ _ _ => True
  HigherAccepted := fun _ _ _ _ => False

/-- Companion model with the same local-conformance observation shape but a
positive higher-order judgment. -/
def localAndHigherAcceptedModel : EvaluationLayerCore where
  Subject := Unit
  Regime := Unit
  Purpose := Unit
  LocalEvidence := Unit
  HigherInput := Unit
  LocalConformance := fun _ _ _ => True
  HigherAccepted := fun _ _ _ _ => True

/-- Finite counterexample witness: local conformance can hold while the
higher-order judgment does not. -/
theorem local_conformance_without_higher_acceptance_exists :
    ∃ D : EvaluationLayerCore,
      ∃ regime : D.Regime,
        ∃ subject : D.Subject,
          ∃ evidence : D.LocalEvidence,
            ∃ purpose : D.Purpose,
              ∃ higherInput : D.HigherInput,
                D.LocalConformance regime subject evidence ∧
                ¬ D.HigherAccepted regime subject purpose higherInput := by
  refine ⟨localButHigherRejectedModel, (), (), (), (), (), ?_, ?_⟩
  · trivial
  · simp [localButHigherRejectedModel]

/-- The universal inference schema from local conformance to a higher-order
verdict is false over the model class admitted by the calculus.  No definition
of `adequacy` is needed for this result. -/
theorem local_conformance_does_not_semantically_force_higher_acceptance :
    ¬ (∀ (D : EvaluationLayerCore)
          (regime : D.Regime)
          (subject : D.Subject)
          (evidence : D.LocalEvidence)
          (purpose : D.Purpose)
          (higherInput : D.HigherInput),
        D.LocalConformance regime subject evidence →
        D.HigherAccepted regime subject purpose higherInput) := by
  intro hUniversal
  have hHigher :=
    hUniversal localButHigherRejectedModel () () () () () (by trivial)
  simpa [localButHigherRejectedModel] using hHigher

/-- Observational underdetermination witness.  Two model instances expose the
same positive local-conformance observation but disagree on the higher-order
verdict.  The theorem states separation of evaluation levels, not a theory of
how the higher-order verdict should be produced. -/
theorem same_local_observation_different_higher_verdict :
    localButHigherRejectedModel.LocalConformance () () () ∧
    localAndHigherAcceptedModel.LocalConformance () () () ∧
    ¬ localButHigherRejectedModel.HigherAccepted () () () () ∧
    localAndHigherAcceptedModel.HigherAccepted () () () () := by
  simp [localButHigherRejectedModel, localAndHigherAcceptedModel]

end EvaluationLayerCore

end ResponsibilityTopology.CrossDomain
