import ResponsibilityTopology.Satisfaction

namespace ResponsibilityTopology

/-- Executable decision surface for the abstract semantic observation relation.
The Boolean test is kept separate from `Env.atomSat`; `correct` connects the
executable oracle to the existing declarative semantics. -/
structure SatOracle (E : Env) where
  test : WarrantId → Atom → Bool
  correct : ∀ w a, test w a = true ↔ E.atomSat w a

/-- Return the first candidate warrant accepted for an atomic obligation. -/
def firstSat {E : Env} (O : SatOracle E) (a : Atom) :
    List WarrantId → Option WarrantId
  | [] => none
  | w :: ws =>
      if O.test w a = true then
        some w
      else
        firstSat O a ws

/-- Left-biased executable satisfaction over a fixed canonical candidate list.
Conjunction reuses the same candidate list for both children; disjunction tries
the left requirement first and only searches the right after ordinary failure. -/
def satisfy {E : Env} (O : SatOracle E) :
    Requirement → List WarrantId → Option Branch
  | .top, _ => some .top
  | .atom a, Γ =>
      match firstSat O a Γ with
      | some w => some (.leaf a w)
      | none => none
  | .conj R₁ R₂, Γ =>
      match satisfy O R₁ Γ with
      | none => none
      | some β₁ =>
          match satisfy O R₂ Γ with
          | none => none
          | some β₂ => some (.both β₁ β₂)
  | .disj R₁ R₂, Γ =>
      match satisfy O R₁ Γ with
      | some β => some (.orL β)
      | none =>
          match satisfy O R₂ Γ with
          | some β => some (.orR β)
          | none => none

/-- For NW, deletion only needs an extensional subset condition: every
candidate retained in `Γ'` was already present in `Γ`. Order preservation is
not needed for failure monotonicity and is deliberately deferred to replay. -/
def CandidateSubset (Γ' Γ : List WarrantId) : Prop :=
  ∀ ⦃w⦄, w ∈ Γ' → w ∈ Γ

/-- Successful atomic search is semantically sound. -/
theorem firstSat_sound
    {E : Env} (O : SatOracle E)
    {a : Atom} {Γ : List WarrantId} {w : WarrantId}
    (hRun : firstSat O a Γ = some w) :
    E.atomSat w a := by
  induction Γ with
  | nil =>
      simp [firstSat] at hRun
  | cons x xs ih =>
      by_cases hTest : O.test x a = true
      · simp [firstSat, hTest] at hRun
        subst w
        exact (O.correct x a).mp hTest
      · simp [firstSat, hTest] at hRun
        exact ih hRun

/-- If atomic search fails, every candidate in the list is rejected. -/
theorem firstSat_none_rejects
    {E : Env} (O : SatOracle E)
    {a : Atom} {Γ : List WarrantId}
    (hFail : firstSat O a Γ = none) :
    ∀ ⦃w⦄, w ∈ Γ → O.test w a ≠ true := by
  induction Γ with
  | nil =>
      intro w hMem
      simp at hMem
  | cons x xs ih =>
      by_cases hTest : O.test x a = true
      · simp [firstSat, hTest] at hFail
      · have hTail : firstSat O a xs = none := by
          simpa [firstSat, hTest] using hFail
        have ihTail := ih hTail
        intro w hMem
        simp at hMem
        rcases hMem with rfl | hMem
        · exact hTest
        · exact ihTail hMem

/-- If every candidate is rejected, atomic search fails. -/
theorem firstSat_none_of_rejects
    {E : Env} (O : SatOracle E)
    {a : Atom} {Γ : List WarrantId}
    (hReject : ∀ ⦃w⦄, w ∈ Γ → O.test w a ≠ true) :
    firstSat O a Γ = none := by
  induction Γ with
  | nil =>
      rfl
  | cons x xs ih =>
      have hx : O.test x a ≠ true := hReject (by simp)
      have hxs : ∀ ⦃w⦄, w ∈ xs → O.test w a ≠ true := by
        intro w hMem
        exact hReject (by simp [hMem])
      simp [firstSat, hx, ih hxs]

/-- Atomic failure is monotone under candidate deletion. -/
theorem firstSat_noNewWitness
    {E : Env} (O : SatOracle E)
    {a : Atom} {Γ Γ' : List WarrantId}
    (hSub : CandidateSubset Γ' Γ)
    (hFail : firstSat O a Γ = none) :
    firstSat O a Γ' = none := by
  apply firstSat_none_of_rejects O
  intro w hMem
  exact firstSat_none_rejects O hFail (hSub hMem)

/-- NW — no new witness under deletion.
If executable satisfaction fails on a candidate environment, retaining only
candidates already present in that environment cannot make it succeed. -/
theorem noNewWitness
    {E : Env} (O : SatOracle E)
    {R : Requirement} {Γ Γ' : List WarrantId}
    (hSub : CandidateSubset Γ' Γ)
    (hFail : satisfy O R Γ = none) :
    satisfy O R Γ' = none := by
  induction R with
  | top =>
      simp [satisfy] at hFail
  | atom a =>
      cases hAtom : firstSat O a Γ with
      | none =>
          have hAtom' := firstSat_noNewWitness O hSub hAtom
          simp [satisfy, hAtom']
      | some w =>
          simp [satisfy, hAtom] at hFail
  | conj R₁ R₂ ih₁ ih₂ =>
      cases h₁ : satisfy O R₁ Γ with
      | none =>
          have h₁' := ih₁ h₁
          simp [satisfy, h₁']
      | some β₁ =>
          cases h₂ : satisfy O R₂ Γ with
          | none =>
              have h₂' := ih₂ h₂
              simp [satisfy, h₁, h₂']
          | some β₂ =>
              simp [satisfy, h₁, h₂] at hFail
  | disj R₁ R₂ ih₁ ih₂ =>
      cases h₁ : satisfy O R₁ Γ with
      | some β₁ =>
          simp [satisfy, h₁] at hFail
      | none =>
          cases h₂ : satisfy O R₂ Γ with
          | some β₂ =>
              simp [satisfy, h₁, h₂] at hFail
          | none =>
              have h₁' := ih₁ h₁
              have h₂' := ih₂ h₂
              simp [satisfy, h₁', h₂']

/-- SS — executable satisfaction soundness.
Every branch returned by the executable search is a derivation in the existing
abstract branch calculus. -/
theorem satisfySound
    {E : Env} (O : SatOracle E)
    {R : Requirement} {Γ : List WarrantId} {β : Branch}
    (hRun : satisfy O R Γ = some β) :
    Derives E β R := by
  induction R generalizing β with
  | top =>
      simp [satisfy] at hRun
      subst β
      exact Derives.top
  | atom a =>
      cases hAtom : firstSat O a Γ with
      | none =>
          simp [satisfy, hAtom] at hRun
      | some w =>
          simp [satisfy, hAtom] at hRun
          subst β
          exact Derives.atom (firstSat_sound O hAtom)
  | conj R₁ R₂ ih₁ ih₂ =>
      cases h₁ : satisfy O R₁ Γ with
      | none =>
          simp [satisfy, h₁] at hRun
      | some β₁ =>
          cases h₂ : satisfy O R₂ Γ with
          | none =>
              simp [satisfy, h₁, h₂] at hRun
          | some β₂ =>
              simp [satisfy, h₁, h₂] at hRun
              subst β
              exact Derives.both (ih₁ h₁) (ih₂ h₂)
  | disj R₁ R₂ ih₁ ih₂ =>
      cases h₁ : satisfy O R₁ Γ with
      | some β₁ =>
          simp [satisfy, h₁] at hRun
          subst β
          exact Derives.orL (ih₁ h₁)
      | none =>
          cases h₂ : satisfy O R₂ Γ with
          | none =>
              simp [satisfy, h₁, h₂] at hRun
          | some β₂ =>
              simp [satisfy, h₁, h₂] at hRun
              subst β
              exact Derives.orR (ih₂ h₂)

end ResponsibilityTopology
