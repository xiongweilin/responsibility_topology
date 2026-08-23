import ResponsibilityTopology.Satisfaction

namespace ResponsibilityTopology

/-- One-way transport of a branch derivation across branch-local environment equivalence. -/
theorem derives_transport
    {E E' : Env} {β : Branch} {R : Requirement}
    (hEq : SatEqOn E E' β)
    (hDerives : Derives E β R) :
    Derives E' β R := by
  induction hDerives generalizing E' with
  | top =>
      exact Derives.top
  | @atom a w hSat =>
      exact Derives.atom (hEq.mp hSat)
  | @both β₁ β₂ R₁ R₂ h₁ h₂ ih₁ ih₂ =>
      exact Derives.both (ih₁ hEq.1) (ih₂ hEq.2)
  | @orL β R₁ R₂ h ih =>
      exact Derives.orL (ih hEq)
  | @orR β R₁ R₂ h ih =>
      exact Derives.orR (ih hEq)

/-- BC — Support Conservativity.
For a fixed raw branch and requirement, changing the environment outside the
atomic observations used by that branch cannot change derivability. -/
theorem branchConservativity
    {E E' : Env} {β : Branch} {R : Requirement}
    (hEq : SatEqOn E E' β) :
    Derives E β R ↔ Derives E' β R := by
  constructor
  · intro h
    exact derives_transport hEq h
  · intro h
    exact derives_transport (satEqOn_symm hEq) h

/-- Reachability is an ambient standing assumption in the V0.2 proof package.
BC is extensionally stronger: once the local projections agree, the proof does
not inspect reachability. This wrapper keeps the intended theorem boundary
explicit without adding the full transition system to the first mechanization. -/
theorem branchConservativity_reachable
    (Reach : Env → Prop)
    {E E' : Env} {β : Branch} {R : Requirement}
    (_hReach : Reach E)
    (_hReach' : Reach E')
    (hEq : SatEqOn E E' β) :
    Derives E β R ↔ Derives E' β R :=
  branchConservativity hEq

end ResponsibilityTopology
