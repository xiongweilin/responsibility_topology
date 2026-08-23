namespace ResponsibilityTopology.Bridge

/-!
Verified checker for the first restricted O0/B0 observational fragment.

The checker does not inspect Python state and does not verify certificate
extraction.  It verifies only the abstract certificate presented to it.  This
keeps the trust boundary explicit:

raw runtime state/event extraction
  | unverified certificate extraction/encoding
  | this Lean checker
  | abstract B0 transition contract
-/

inductive QualificationState where
  | qualified
  | withdrawn
  deriving Repr, DecidableEq

structure QualificationWithdrawalCertificate where
  historicalTraceBefore : Bool
  historicalTraceAfter : Bool
  qualificationBefore : QualificationState
  qualificationAfter : QualificationState
  acceptedDischargeEvidenceAfter : Bool
  deriving Repr, DecidableEq

structure B0QualificationObservation where
  historicalTracePresent : Bool
  qualification : QualificationState
  deriving Repr, DecidableEq

/-- The neutral before-observation encoded by one certificate. -/
def QualificationWithdrawalCertificate.before
    (c : QualificationWithdrawalCertificate) : B0QualificationObservation where
  historicalTracePresent := c.historicalTraceBefore
  qualification := c.qualificationBefore

/-- The neutral after-observation encoded by one certificate. -/
def QualificationWithdrawalCertificate.after
    (c : QualificationWithdrawalCertificate) : B0QualificationObservation where
  historicalTracePresent := c.historicalTraceAfter
  qualification := c.qualificationAfter

/-- Abstract observational transition contract for the first certified fragment. -/
def B0QualificationWithdrawalStep
    (before after : B0QualificationObservation) : Prop :=
  before.historicalTracePresent = true ∧
  after.historicalTracePresent = true ∧
  before.qualification = .qualified ∧
  after.qualification = .withdrawn

/-- Boolean checker used as the executable decision surface. -/
def checkQualificationWithdrawal
    (c : QualificationWithdrawalCertificate) : Bool :=
  c.historicalTraceBefore &&
  c.historicalTraceAfter &&
  match c.qualificationBefore, c.qualificationAfter with
  | .qualified, .withdrawn => true
  | _, _ => false

/-- The checker is sound for the abstract B0 transition contract. -/
theorem checkQualificationWithdrawal_sound
    (c : QualificationWithdrawalCertificate)
    (hCheck : checkQualificationWithdrawal c = true) :
    B0QualificationWithdrawalStep c.before c.after := by
  cases c with
  | mk hBefore hAfter qBefore qAfter discharge =>
      cases hBefore <;>
      cases hAfter <;>
      cases qBefore <;>
      cases qAfter <;>
      simp [checkQualificationWithdrawal,
        B0QualificationWithdrawalStep,
        QualificationWithdrawalCertificate.before,
        QualificationWithdrawalCertificate.after] at hCheck ⊢

/-- Current-use continuation under this narrow certificate contract is accepted
only when qualification remains current or explicit accepted discharge evidence
is present after a withdrawal.  This is an abstract checker rule, not a claim
that every runtime uses this policy. -/
def currentUseContinuationAccepted
    (c : QualificationWithdrawalCertificate) : Bool :=
  match c.qualificationAfter with
  | .qualified => true
  | .withdrawn => c.acceptedDischargeEvidenceAfter

/-- Main checker consequence requested by the Level-6 bridge: once a checked
withdrawal certificate is present and no accepted discharge/requalification
evidence is recorded, certified current-use continuation is rejected. -/
theorem checked_withdrawal_without_discharge_rejects_current_use
    (c : QualificationWithdrawalCertificate)
    (hCheck : checkQualificationWithdrawal c = true)
    (hNoDischarge : c.acceptedDischargeEvidenceAfter = false) :
    currentUseContinuationAccepted c = false := by
  have hStep := checkQualificationWithdrawal_sound c hCheck
  rcases hStep with ⟨hTraceBefore, hTraceAfter, hBefore, hAfter⟩
  simp [currentUseContinuationAccepted, hAfter, hNoDischarge]

/-- Mirror of the frozen REF-3 runtime fixture.  This proves only that the
presented certificate satisfies the checker contract; provenance from raw Python
state to these values remains outside the Lean TCB. -/
def ref3RuntimeFixture : QualificationWithdrawalCertificate where
  historicalTraceBefore := true
  historicalTraceAfter := true
  qualificationBefore := .qualified
  qualificationAfter := .withdrawn
  acceptedDischargeEvidenceAfter := false

 theorem ref3RuntimeFixture_checked :
    checkQualificationWithdrawal ref3RuntimeFixture = true := by
  decide

 theorem ref3RuntimeFixture_rejects_current_use :
    currentUseContinuationAccepted ref3RuntimeFixture = false := by
  decide

end ResponsibilityTopology.Bridge
