import ResponsibilityTopology.CanonicalRead

namespace ResponsibilityTopology

/-!
Executable adapter semantics used only by the Python V0.1.2.2 conformance suite.

This file does not alter the core theorem theory. It supplies executable adapter
operations needed to run the machine-checked PR #6 projections on serialized
Python fixtures. Escalation-depth parsing remains an explicit adapter input
because `FloorSemantics.escalationDepth` intentionally abstracts the Python
parser.
-/

private def stringMember (needle : String) : List String → Bool
  | [] => false
  | head :: tail =>
      if needle == head then true else stringMember needle tail

/-- Python `frozenset` subset semantics over the deterministic list encoding of
scope atoms. The conformance adapter emits sorted, duplicate-free lists, but the
operation itself is insensitive to list order and duplicate occurrences. -/
def pythonScopeLE (left right : Scope) : Bool :=
  left.atoms.all (fun atom => stringMember atom right.atoms)

/-- Assemble the exact semantic operations needed by the machine-checked read
model. The depth operation is supplied from the Python reference parser for the
finite fixture claim universe; this keeps parser correspondence explicit rather
than silently reimplementing Python `int` semantics in Lean. -/
def pythonConformanceSemantics
    (depth : Claim → Option RevisionDepth) : FloorSemantics where
  scopeLE := pythonScopeLE
  escalationDepth := depth

/-- Executable spelling of ambient admissibility for a canonical read. This is
needed only because `AmbientView` intentionally stores abstract `Prop` fields and
therefore has no global `Decidable (Admissible A)` instance. -/
def projectedAmbientAdmissible
    (C : LicensingRead) (m : FloorMove) : Bool :=
  C.bindingActive &&
    (decide (C.use = C.bindingUse) &&
      (C.contextActive &&
        C.semantics.scopeLE m.scope C.bindingScope))

/-- The executable conformance check is exactly the abstract PR #6 ambient
projection; it is not a second ambient semantics. -/
theorem projectedAmbientAdmissible_true_iff
    (C : LicensingRead) (m : FloorMove) :
    projectedAmbientAdmissible C m = true ↔
      Admissible (toAmbient C m) := by
  simp [projectedAmbientAdmissible, Admissible, toAmbient]

end ResponsibilityTopology
