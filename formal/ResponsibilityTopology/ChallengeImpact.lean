import ResponsibilityTopology.Reachability

namespace ResponsibilityTopology

/-!
Pure challenge-impact semantics.

The Python history maintains a set-valued parent-to-children index and defines
`descendants(target)` by graph reachability.  This module reconstructs the same
historical dependency direction from immutable warrant parent identifiers and
defines the challenged impact set as the target together with its transitive
descendants.

This stage is intentionally state-effect free: there is no challenge event,
suspension, placement change, review-required update, activation refresh, or
revalidation transition here.  Unlike ordered INFER formation, impact closure is
set-like: duplicate parent occurrences do not create distinct affected warrants.
-/

/-- One historical child edge: `child` names `parent` among its immutable parent
identifiers.  The child itself must be a canonical historical warrant. -/
def DirectDescendant
    (S : CanonicalState)
    (parent child : WarrantId) : Prop :=
  ∃ warrant,
    S.warrant child = some warrant ∧
      parent ∈ warrant.parents

/-- Nonempty finite transitive closure of historical child edges. -/
inductive DescendantOf (S : CanonicalState) : WarrantId → WarrantId → Prop where
  | direct {parent child : WarrantId}
      (edge : DirectDescendant S parent child) :
      DescendantOf S parent child
  | trans {ancestor middle child : WarrantId}
      (head : DescendantOf S ancestor middle)
      (tail : DescendantOf S middle child) :
      DescendantOf S ancestor child

/-- Challenge impact is exactly the challenged target plus every historical
transitive descendant. -/
def Affected
    (S : CanonicalState)
    (target warrantId : WarrantId) : Prop :=
  warrantId = target ∨ DescendantOf S target warrantId

/-- Direct historical children are descendants. -/
theorem directDescendant_implies_descendant
    {S : CanonicalState}
    {parent child : WarrantId}
    (h : DirectDescendant S parent child) :
    DescendantOf S parent child :=
  .direct h

/-- The descendant relation is transitively closed by construction. -/
theorem descendant_transitive
    {S : CanonicalState}
    {ancestor middle child : WarrantId}
    (h₁ : DescendantOf S ancestor middle)
    (h₂ : DescendantOf S middle child) :
    DescendantOf S ancestor child :=
  .trans h₁ h₂

/-- Exact unfolding of the affected-set boundary. -/
theorem affected_iff_target_or_descendant
    (S : CanonicalState)
    (target warrantId : WarrantId) :
    Affected S target warrantId ↔
      warrantId = target ∨ DescendantOf S target warrantId := by
  rfl

/-- The challenged target is always affected, independently of descendants. -/
theorem challengeTarget_affected
    (S : CanonicalState)
    (target : WarrantId) :
    Affected S target target := by
  exact Or.inl rfl

/-- Every transitive descendant of the challenge target is affected. -/
theorem descendant_affected
    {S : CanonicalState}
    {target warrantId : WarrantId}
    (h : DescendantOf S target warrantId) :
    Affected S target warrantId := by
  exact Or.inr h

/-- Away from the target itself, affectedness is exactly descendant reachability. -/
theorem affected_nonTarget_iff_descendant
    {S : CanonicalState}
    {target warrantId : WarrantId}
    (hNe : warrantId ≠ target) :
    Affected S target warrantId ↔
      DescendantOf S target warrantId := by
  constructor
  · intro hAffected
    rcases hAffected with hEq | hDesc
    · exact False.elim (hNe hEq)
    · exact hDesc
  · intro hDesc
    exact Or.inr hDesc

/-- A warrant unrelated to the target by identity or descendant reachability is
not affected. -/
theorem unrelated_notAffected
    {S : CanonicalState}
    {target warrantId : WarrantId}
    (hNe : warrantId ≠ target)
    (hNotDescendant : ¬ DescendantOf S target warrantId) :
    ¬ Affected S target warrantId := by
  intro hAffected
  rcases hAffected with hEq | hDesc
  · exact hNe hEq
  · exact hNotDescendant hDesc

/-- Affectedness is downward closed along historical descendant dependencies. -/
theorem affected_closed_under_descendants
    {S : CanonicalState}
    {target affectedId descendantId : WarrantId}
    (hAffected : Affected S target affectedId)
    (hDescendant : DescendantOf S affectedId descendantId) :
    Affected S target descendantId := by
  rcases hAffected with hTarget | hAncestor
  · subst affectedId
    exact Or.inr hDescendant
  · exact Or.inr (descendant_transitive hAncestor hDescendant)

/-- One-edge closure corollary matching the parent-to-children index used by the
reference runtime. -/
theorem affected_closed_under_directChildren
    {S : CanonicalState}
    {target affectedId childId : WarrantId}
    (hAffected : Affected S target affectedId)
    (hChild : DirectDescendant S affectedId childId) :
    Affected S target childId := by
  exact affected_closed_under_descendants hAffected (.direct hChild)

end ResponsibilityTopology
