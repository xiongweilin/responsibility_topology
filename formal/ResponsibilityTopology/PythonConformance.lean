import ResponsibilityTopology.CanonicalRead

namespace ResponsibilityTopology

/-!
Executable adapter semantics used only by the Python V0.1.2.2 conformance suite.

This file does not add theorem theory. It supplies the concrete scope operation
for the canonical sorted/unique list encoding used by the cross-language
fixtures. Escalation-depth parsing remains an explicit adapter input because
`FloorSemantics.escalationDepth` intentionally abstracts the Python parser.
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

end ResponsibilityTopology
