import ResponsibilityTopology.Bridge.CertifiedObservation
import Lean.Data.Json

open Lean

namespace ResponsibilityTopology.Bridge

/-!
Strict-L6 REF-4 checker input.

Unlike the REF-3 `QualificationWithdrawalCertificate`, this structure represents
selected *raw runtime record fields*.  The Lean projection below computes the B0
historical-trace and qualification observations itself.

The remaining external trust boundary is raw runtime serialization / I/O
fidelity.  Python-side B0 extraction is not trusted by this checker.
-/

structure RawAssertionSnapshotV1 where
  id : String
  record_type : String
  lifecycle_status : String
  epistemic_status : String
  version : Nat
  deriving Repr, DecidableEq, FromJson

structure RawWithdrawalTransitionV1 where
  schema_version : String
  subject_ref : String
  before_raw_snapshot : RawAssertionSnapshotV1
  after_raw_snapshot : RawAssertionSnapshotV1
  event_ref : String
  deriving Repr, DecidableEq, FromJson

/-- Lean-owned interpretation of the runtime-native assertion status at the B0
qualification coordinate.  No Python bridge value is consumed here. -/
def rawQualificationB0 (snapshot : RawAssertionSnapshotV1) : Option QualificationState :=
  if snapshot.record_type != "Assertion" then
    none
  else if snapshot.epistemic_status == "supported" then
    some .qualified
  else if snapshot.epistemic_status == "revalidation-required" ||
      snapshot.epistemic_status == "refuted" then
    some .withdrawn
  else
    none

/-- Lean-defined projection from selected raw canonical record fields to the
restricted B0 observation.  Historical trace is present only when the raw
snapshot is the requested nonempty Assertion referent. -/
def alphaB0Lean
    (subjectRef : String)
    (snapshot : RawAssertionSnapshotV1) : Option B0QualificationObservation :=
  if subjectRef == "" || snapshot.id != subjectRef || snapshot.record_type != "Assertion" then
    none
  else
    match rawQualificationB0 snapshot with
    | some qualification =>
        some {
          historicalTracePresent := true
          qualification := qualification
        }
    | none => none

/-- The semantic contract checked from raw before/after snapshots. -/
def RawB0WithdrawalHolds (transition : RawWithdrawalTransitionV1) : Prop :=
  match alphaB0Lean transition.subject_ref transition.before_raw_snapshot,
      alphaB0Lean transition.subject_ref transition.after_raw_snapshot with
  | some before, some after => B0QualificationWithdrawalStep before after
  | _, _ => False

instance (transition : RawWithdrawalTransitionV1) : Decidable (RawB0WithdrawalHolds transition) := by
  unfold RawB0WithdrawalHolds
  infer_instance

/-- Executable raw checker.  Schema/event checks are envelope checks; the B0
judgment itself is computed solely by the Lean projection above. -/
def checkRawWithdrawal (transition : RawWithdrawalTransitionV1) : Bool :=
  decide (
    transition.schema_version = "raw-withdrawal-transition-v1" ∧
    transition.event_ref ≠ "" ∧
    RawB0WithdrawalHolds transition)

/-- Main REF-4 soundness theorem: checker success on a raw transition implies
that the Lean-computed before/after observations satisfy the existing B0
withdrawal contract. -/
theorem checkRawWithdrawal_sound
    (transition : RawWithdrawalTransitionV1)
    (hCheck : checkRawWithdrawal transition = true) :
    RawB0WithdrawalHolds transition := by
  have hEnvelope :
      transition.schema_version = "raw-withdrawal-transition-v1" ∧
      transition.event_ref ≠ "" ∧
      RawB0WithdrawalHolds transition := by
    exact of_decide_eq_true (by simpa [checkRawWithdrawal] using hCheck)
  exact hEnvelope.2.2

/-- Concrete selected-field mirror used only to exercise the checker in normal
Lean compilation.  The cross-repository CI gate separately feeds the actual raw
JSON artifact produced by portable-runtime into the JSON CLI. -/
def ref4RawSelectedFixture : RawWithdrawalTransitionV1 where
  schema_version := "raw-withdrawal-transition-v1"
  subject_ref := "assertion-ref4-1"
  before_raw_snapshot := {
    id := "assertion-ref4-1"
    record_type := "Assertion"
    lifecycle_status := "current"
    epistemic_status := "supported"
    version := 7
  }
  after_raw_snapshot := {
    id := "assertion-ref4-1"
    record_type := "Assertion"
    lifecycle_status := "current"
    epistemic_status := "revalidation-required"
    version := 8
  }
  event_ref := "fixture-transition:assertion-ref4-1:7-8"

theorem ref4RawSelectedFixture_checked :
    checkRawWithdrawal ref4RawSelectedFixture = true := by
  decide

theorem ref4RawSelectedFixture_projects_B0 :
    RawB0WithdrawalHolds ref4RawSelectedFixture := by
  exact checkRawWithdrawal_sound ref4RawSelectedFixture ref4RawSelectedFixture_checked

end ResponsibilityTopology.Bridge
