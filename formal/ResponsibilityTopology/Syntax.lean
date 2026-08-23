namespace ResponsibilityTopology

abbrev WarrantId := Nat

inductive Role where
  | content
  | bridge
  | provenance
  | coverage
  | selection
  | escalation
  | authorization
  | binding
  deriving Repr, DecidableEq

structure Scope where
  atoms : List String
  deriving Repr, DecidableEq

structure Claim where
  kind : String
  args : List String := []
  deriving Repr, DecidableEq

structure Atom where
  claim : Claim
  role : Role
  scope : Scope
  deriving Repr, DecidableEq

inductive Requirement where
  | top
  | atom (a : Atom)
  | conj (left right : Requirement)
  | disj (left right : Requirement)
  deriving Repr, DecidableEq

inductive Branch where
  | top
  | leaf (a : Atom) (w : WarrantId)
  | both (left right : Branch)
  | orL (branch : Branch)
  | orR (branch : Branch)
  deriving Repr, DecidableEq

namespace Branch

def support : Branch → List WarrantId
  | .top => []
  | .leaf _ w => [w]
  | .both left right => left.support ++ right.support
  | .orL branch => branch.support
  | .orR branch => branch.support

end Branch

end ResponsibilityTopology
