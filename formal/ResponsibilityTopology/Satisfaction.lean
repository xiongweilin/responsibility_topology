import ResponsibilityTopology.Syntax

namespace ResponsibilityTopology

/-- Minimal projection interface for the first mechanization milestone.
It intentionally abstracts away the full V0.1.2.2 transition system. -/
structure Env where
  atomSat : WarrantId → Atom → Prop

/-- Raw branch syntax remains extrinsic; validity is stated by `Derives`. -/
inductive Derives (E : Env) : Branch → Requirement → Prop where
  | top : Derives E .top .top
  | atom {a w} : E.atomSat w a → Derives E (.leaf a w) (.atom a)
  | both {β₁ β₂ R₁ R₂} :
      Derives E β₁ R₁ →
      Derives E β₂ R₂ →
      Derives E (.both β₁ β₂) (.conj R₁ R₂)
  | orL {β R₁ R₂} :
      Derives E β R₁ →
      Derives E (.orL β) (.disj R₁ R₂)
  | orR {β R₁ R₂} :
      Derives E β R₂ →
      Derives E (.orR β) (.disj R₁ R₂)

/-- Equality of exactly the atomic observations used by a branch.
This is the first mechanized form of branch-local environment equivalence. -/
def SatEqOn (E E' : Env) : Branch → Prop
  | .top => True
  | .leaf a w => E.atomSat w a ↔ E'.atomSat w a
  | .both β₁ β₂ => SatEqOn E E' β₁ ∧ SatEqOn E E' β₂
  | .orL β => SatEqOn E E' β
  | .orR β => SatEqOn E E' β

 theorem satEqOn_symm {E E' : Env} {β : Branch} :
    SatEqOn E E' β → SatEqOn E' E β := by
  induction β with
  | top =>
      intro _
      trivial
  | leaf a w =>
      intro h
      exact h.symm
  | both β₁ β₂ ih₁ ih₂ =>
      intro h
      exact ⟨ih₁ h.1, ih₂ h.2⟩
  | orL β ih =>
      intro h
      exact ih h
  | orR β ih =>
      intro h
      exact ih h

 theorem satEqOn_both_left {E E' : Env} {β₁ β₂ : Branch} :
    SatEqOn E E' (.both β₁ β₂) → SatEqOn E E' β₁ := by
  intro h
  exact h.1

 theorem satEqOn_both_right {E E' : Env} {β₁ β₂ : Branch} :
    SatEqOn E E' (.both β₁ β₂) → SatEqOn E E' β₂ := by
  intro h
  exact h.2

end ResponsibilityTopology
