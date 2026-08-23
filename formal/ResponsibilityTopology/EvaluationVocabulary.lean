import ResponsibilityTopology.Syntax

namespace ResponsibilityTopology

/-!
Evaluation qualification vocabulary.

The evaluation plane is deliberately two-dimensional. Epistemic status and
placement are independent responsibility axes; current usability is their
conjunction, not a collapsed warrant-state enum.
-/

structure EvalKey where
  profileDigest : String
  contextId : String
  use : String
  warrantId : WarrantId
  deriving Repr, DecidableEq

inductive EpiStatus where
  | live
  | suspended
  deriving Repr, DecidableEq

inductive Placement where
  | placed
  | pending
  deriving Repr, DecidableEq

/-- Audit metadata recorded at an explicit admission boundary.  These strings
are recorded claims, not authenticated principals or adequate justifications. -/
structure AdmissionMetadata where
  actor : String
  basis : String
  deriving Repr, DecidableEq

end ResponsibilityTopology
