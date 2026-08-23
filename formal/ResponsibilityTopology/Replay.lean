import Init.Data.List.Sublist
import ResponsibilityTopology.ExecutableSatisfaction

namespace ResponsibilityTopology

/-- A successful atomic search returns a candidate from the searched list. -/
theorem firstSat_mem
    {E : Env} (O : SatOracle E)
    {a : Atom} {Γ : List WarrantId} {w : WarrantId}
    (hRun : firstSat O a Γ = some w) :
    w ∈ Γ := by
  induction Γ with
  | nil =>
      change (none : Option WarrantId) = some w at hRun
      cases hRun
  | cons x xs ih =>
      by_cases hTest : O.test x a = true
      · rw [firstSat, if_pos hTest] at hRun
        have hEq : x = w := Option.some.inj hRun
        subst w
        exact List.Mem.head xs
      · rw [firstSat, if_neg hTest] at hRun
        exact List.Mem.tail x (ih hRun)

/-- Every order-preserving sublist is, in particular, an extensional candidate inclusion. -/
theorem candidateSubset_of_sublist
    {Γ Γ' : List WarrantId}
    (hSub : List.Sublist Γ' Γ) :
    CandidateSubset Γ' Γ := by
  intro w hMem
  exact hSub.subset hMem

/-- Replay atomic search through an ID-level candidate filter that retains the
selected warrant ID. Filtering is deliberately stronger than an arbitrary
sublist: it retains every occurrence of a kept ID, which is necessary when the
candidate sequence contains duplicate IDs. -/
theorem firstSat_replay
    {E : Env} (O : SatOracle E)
    {a : Atom} {Γ : List WarrantId} {w : WarrantId}
    (keep : WarrantId → Bool)
    (hRun : firstSat O a Γ = some w)
    (hKeep : keep w = true) :
    firstSat O a (Γ.filter keep) = some w := by
  induction Γ with
  | nil =>
      change (none : Option WarrantId) = some w at hRun
      cases hRun
  | cons x xs ih =>
      by_cases hTest : O.test x a = true
      · rw [firstSat, if_pos hTest] at hRun
        have hEq : x = w := Option.some.inj hRun
        subst w
        simp [List.filter, hKeep, firstSat, hTest]
      · rw [firstSat, if_neg hTest] at hRun
        cases hK : keep x with
        | false =>
            simp [List.filter, hK]
            exact ih hRun
        | true =>
            simp [List.filter, hK, firstSat, hTest]
            exact ih hRun

/-- Every warrant ID recorded in the returned branch support came from the
candidate sequence searched by `satisfy`. -/
theorem satisfy_support_subset
    {E : Env} (O : SatOracle E)
    {R : Requirement} {Γ : List WarrantId} {β : Branch}
    (hRun : satisfy O R Γ = some β) :
    CandidateSubset β.support Γ := by
  induction R generalizing β with
  | top =>
      change (some Branch.top : Option Branch) = some β at hRun
      have hEq : Branch.top = β := Option.some.inj hRun
      cases hEq
      intro w hMem
      cases hMem
  | atom a =>
      cases hAtom : firstSat O a Γ with
      | none =>
          rw [satisfy, hAtom] at hRun
          cases hRun
      | some w =>
          rw [satisfy, hAtom] at hRun
          have hEq : Branch.leaf a w = β := Option.some.inj hRun
          cases hEq
          intro x hMem
          cases hMem with
          | head => exact firstSat_mem O hAtom
          | tail _ hTail => cases hTail
  | conj R₁ R₂ ih₁ ih₂ =>
      cases h₁ : satisfy O R₁ Γ with
      | none =>
          rw [satisfy, h₁] at hRun
          cases hRun
      | some β₁ =>
          cases h₂ : satisfy O R₂ Γ with
          | none =>
              rw [satisfy, h₁, h₂] at hRun
              cases hRun
          | some β₂ =>
              rw [satisfy, h₁, h₂] at hRun
              have hLeft := ih₁ h₁
              have hRight := ih₂ h₂
              have hEq : Branch.both β₁ β₂ = β := Option.some.inj hRun
              cases hEq
              intro w hMem
              have hParts : w ∈ β₁.support ∨ w ∈ β₂.support :=
                List.mem_append.mp hMem
              cases hParts with
              | inl h => exact hLeft h
              | inr h => exact hRight h
  | disj R₁ R₂ ih₁ ih₂ =>
      cases h₁ : satisfy O R₁ Γ with
      | some β₁ =>
          rw [satisfy, h₁] at hRun
          have hChild := ih₁ h₁
          have hEq : Branch.orL β₁ = β := Option.some.inj hRun
          cases hEq
          exact hChild
      | none =>
          cases h₂ : satisfy O R₂ Γ with
          | none =>
              rw [satisfy, h₁, h₂] at hRun
              cases hRun
          | some β₂ =>
              rw [satisfy, h₁, h₂] at hRun
              have hChild := ih₂ h₂
              have hEq : Branch.orR β₂ = β := Option.some.inj hRun
              cases hEq
              exact hChild

/-- SPR — support-preserving replay.
Any ID-level filter that keeps every warrant ID in the recorded branch support
replays exactly the same branch. Because the filter is applied uniformly by ID,
all occurrences of a kept support ID are retained and relative order is
preserved. This avoids the duplicate-ID counterexample to the weaker arbitrary
sublist + membership formulation. -/
theorem supportPreservingReplay
    {E : Env} (O : SatOracle E)
    {R : Requirement} {Γ : List WarrantId} {β : Branch}
    (keep : WarrantId → Bool)
    (hRun : satisfy O R Γ = some β)
    (hKeep : ∀ ⦃w⦄, w ∈ β.support → keep w = true) :
    satisfy O R (Γ.filter keep) = some β := by
  induction R generalizing β with
  | top =>
      change (some Branch.top : Option Branch) = some β at hRun
      have hEq : Branch.top = β := Option.some.inj hRun
      cases hEq
      rfl
  | atom a =>
      cases hAtom : firstSat O a Γ with
      | none =>
          rw [satisfy, hAtom] at hRun
          cases hRun
      | some w =>
          rw [satisfy, hAtom] at hRun
          have hEq : Branch.leaf a w = β := Option.some.inj hRun
          have hKeepW : keep w = true := by
            apply hKeep
            rw [← hEq]
            exact List.Mem.head []
          have hReplay := firstSat_replay O keep hAtom hKeepW
          cases hEq
          rw [satisfy, hReplay]
  | conj R₁ R₂ ih₁ ih₂ =>
      cases h₁ : satisfy O R₁ Γ with
      | none =>
          rw [satisfy, h₁] at hRun
          cases hRun
      | some β₁ =>
          cases h₂ : satisfy O R₂ Γ with
          | none =>
              rw [satisfy, h₁, h₂] at hRun
              cases hRun
          | some β₂ =>
              rw [satisfy, h₁, h₂] at hRun
              have hEq : Branch.both β₁ β₂ = β := Option.some.inj hRun
              have hKeep₁ : ∀ ⦃w⦄, w ∈ β₁.support → keep w = true := by
                intro w hMem
                apply hKeep
                rw [← hEq]
                exact List.mem_append_left β₂.support hMem
              have hKeep₂ : ∀ ⦃w⦄, w ∈ β₂.support → keep w = true := by
                intro w hMem
                apply hKeep
                rw [← hEq]
                exact List.mem_append_right β₁.support hMem
              have h₁' := ih₁ h₁ hKeep₁
              have h₂' := ih₂ h₂ hKeep₂
              cases hEq
              rw [satisfy, h₁', h₂']
  | disj R₁ R₂ ih₁ ih₂ =>
      cases h₁ : satisfy O R₁ Γ with
      | some β₁ =>
          rw [satisfy, h₁] at hRun
          have hEq : Branch.orL β₁ = β := Option.some.inj hRun
          have hKeep₁ : ∀ ⦃w⦄, w ∈ β₁.support → keep w = true := by
            intro w hMem
            apply hKeep
            rw [← hEq]
            exact hMem
          have h₁' := ih₁ h₁ hKeep₁
          cases hEq
          rw [satisfy, h₁']
      | none =>
          cases h₂ : satisfy O R₂ Γ with
          | none =>
              rw [satisfy, h₁, h₂] at hRun
              cases hRun
          | some β₂ =>
              rw [satisfy, h₁, h₂] at hRun
              have hEq : Branch.orR β₂ = β := Option.some.inj hRun
              have hKeep₂ : ∀ ⦃w⦄, w ∈ β₂.support → keep w = true := by
                intro w hMem
                apply hKeep
                rw [← hEq]
                exact hMem
              have hSub : CandidateSubset (Γ.filter keep) Γ :=
                candidateSubset_of_sublist List.filter_sublist
              have h₁' := noNewWitness O hSub h₁
              have h₂' := ih₂ h₂ hKeep₂
              cases hEq
              rw [satisfy, h₁', h₂']

/-- Canonical order-preserving projection of a candidate sequence to the warrant
IDs recorded in a branch support. -/
def projectSupport (Γ : List WarrantId) (β : Branch) : List WarrantId :=
  Γ.filter (fun w => decide (w ∈ β.support))

/-- The canonical support projection is an order-preserving sublist. -/
theorem projectSupport_sublist
    {Γ : List WarrantId} {β : Branch} :
    List.Sublist (projectSupport Γ β) Γ := by
  exact List.filter_sublist

/-- A successful run guarantees that every recorded support ID occurs in its
canonical support projection. -/
theorem projectSupport_keeps_support
    {E : Env} (O : SatOracle E)
    {R : Requirement} {Γ : List WarrantId} {β : Branch}
    (hRun : satisfy O R Γ = some β) :
    ∀ ⦃w⦄, w ∈ β.support → w ∈ projectSupport Γ β := by
  intro w hMem
  have hCandidate : w ∈ Γ := satisfy_support_subset O hRun hMem
  simp [projectSupport, hCandidate, hMem]

/-- SP — support projection / exact replay. -/
theorem supportProjection
    {E : Env} (O : SatOracle E)
    {R : Requirement} {Γ : List WarrantId} {β : Branch}
    (hRun : satisfy O R Γ = some β) :
    satisfy O R (projectSupport Γ β) = some β := by
  apply supportPreservingReplay O (keep := fun w => decide (w ∈ β.support)) hRun
  intro w hMem
  simp [hMem]

end ResponsibilityTopology
