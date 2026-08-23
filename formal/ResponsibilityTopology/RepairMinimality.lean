import ResponsibilityTopology.RepairSufficiency

namespace ResponsibilityTopology

/-!
Minimal repair sets and dependency-cut necessity.

Two logically distinct forms of necessity are kept separate.

1. Combinatorial minimality is unconditional relative to a `RepairProblem`: an
   inclusion-minimal hitting set loses the repair-set property when any selected
   action is removed.  Equivalently, every selected action owns a private
   unresolved dependency cut that no other selected action hits.

2. Semantic restoration lower bounds require an adequacy premise connecting the
   extracted hypergraph to a chosen restoration predicate.  The theorem below
   therefore does not pretend that arbitrary target restoration implies hitting
   every edge unless each edge has independently been justified as necessary.

No uniqueness of minimal repair sets is assumed or proved.
-/

/-- Remove one exact action from a predicate-set. -/
def removeRepairAction
    (X : RepairActionSet)
    (removed : RepairAction) : RepairActionSet :=
  fun action => X action ∧ action ≠ removed

/-- Removing an action only shrinks the action set. -/
theorem removeRepairAction_subset
    (X : RepairActionSet)
    (removed : RepairAction) :
    RepairActionSubset (removeRepairAction X removed) X := by
  intro action h
  exact h.1

/-- If the removed action was selected, removal is a proper subset. -/
theorem removeRepairAction_proper
    {X : RepairActionSet}
    {removed : RepairAction}
    (hSelected : X removed) :
    ProperRepairActionSubset (removeRepairAction X removed) X := by
  constructor
  · exact removeRepairAction_subset X removed
  · refine ⟨removed, hSelected, ?_⟩
    intro hRemoved
    exact hRemoved.2 rfl

/-- Inclusion-minimality has the expected deletion form: deleting any selected
repair action makes the remaining set insufficient to hit all unresolved cuts. -/
theorem minimalRepairSet_remove_member_insufficient
    {A : AdoptState}
    {problem : RepairProblem A}
    {X : RepairActionSet}
    (hMinimal : MinimalRepairSet problem X)
    {action : RepairAction}
    (hSelected : X action) :
    ¬ RepairSet problem (removeRepairAction X action) := by
  exact hMinimal.2 _ (removeRepairAction_proper hSelected)

/-- Every member of a minimal repair set has a private dependency cut: the
member hits that cut, and every selected alternative on the same cut is that
same member.  Thus the action is not removable merely because of an arbitrary
set-theoretic convention; some unresolved cut witnesses its necessity. -/
theorem minimalRepairSet_has_private_edge
    {A : AdoptState}
    {problem : RepairProblem A}
    {X : RepairActionSet}
    (hMinimal : MinimalRepairSet problem X)
    {action : RepairAction}
    (hSelected : X action) :
    ∃ edge,
      edge ∈ problem.edges ∧
      action ∈ edge.alternatives ∧
      ∀ alternative,
        alternative ∈ edge.alternatives →
        X alternative →
        alternative = action := by
  classical
  have hNotRepair :
      ¬ RepairSet problem (removeRepairAction X action) :=
    minimalRepairSet_remove_member_insufficient hMinimal hSelected
  have hFailedEdge :
      ∃ edge,
        edge ∈ problem.edges ∧
        ¬ HitsRepairEdge (removeRepairAction X action) edge := by
    by_contra hNoFailedEdge
    apply hNotRepair
    intro edge hEdge
    by_contra hMiss
    exact hNoFailedEdge ⟨edge, hEdge, hMiss⟩
  rcases hFailedEdge with ⟨edge, hEdge, hMiss⟩
  rcases hMinimal.1 edge hEdge with
    ⟨chosen, hChosenAlternative, hChosenSelected⟩
  have hChosenEq : chosen = action := by
    by_contra hNe
    apply hMiss
    exact ⟨chosen, hChosenAlternative, hChosenSelected, hNe⟩
  subst chosen
  refine ⟨edge, hEdge, hChosenAlternative, ?_⟩
  intro alternative hAlternative hAlternativeSelected
  by_contra hNe
  apply hMiss
  exact ⟨alternative, hAlternative, hAlternativeSelected, hNe⟩

/-- Direct corollary in the requested pointwise form: every selected member of a
minimal repair set is individually necessary for the repair-set property. -/
theorem minimalRepairSet_every_member_necessary
    {A : AdoptState}
    {problem : RepairProblem A}
    {X : RepairActionSet}
    (hMinimal : MinimalRepairSet problem X) :
    ∀ action,
      X action →
      ¬ RepairSet problem (removeRepairAction X action) := by
  intro action hSelected
  exact minimalRepairSet_remove_member_insufficient hMinimal hSelected

/-- A restoration predicate can be compared to the extracted dependency
hypergraph only after every edge has been justified as a necessary cut for that
predicate.  This is the explicit adequacy premise needed for a semantic lower
bound. -/
def EveryRepairCutNecessary
    {A : AdoptState}
    (problem : RepairProblem A)
    (Restore : RepairActionSet → Prop) : Prop :=
  ∀ X edge,
    Restore X →
    edge ∈ problem.edges →
    HitsRepairEdge X edge

/-- Universal lower bound, with its semantic adequacy premise visible:

  ∀ X, Restore(X) → X hits every unresolved dependency cut.

This is stronger than minimal-set deletion but is not derivable from the bare
hitting-set representation alone. -/
theorem restoration_hits_every_unresolved_cut
    {A : AdoptState}
    {problem : RepairProblem A}
    {Restore : RepairActionSet → Prop}
    (hNecessary : EveryRepairCutNecessary problem Restore) :
    ∀ X,
      Restore X →
      ∀ edge,
        edge ∈ problem.edges →
        HitsRepairEdge X edge := by
  intro X hRestore edge hEdge
  exact hNecessary X edge hRestore hEdge

/-- Under cut adequacy, any restoring action set is itself a `RepairSet`.  This
is the exact bridge from semantic restoration to the combinatorial hypergraph
lower bound. -/
theorem restoration_implies_repairSet
    {A : AdoptState}
    {problem : RepairProblem A}
    {Restore : RepairActionSet → Prop}
    (hNecessary : EveryRepairCutNecessary problem Restore)
    {X : RepairActionSet}
    (hRestore : Restore X) :
    RepairSet problem X := by
  intro edge hEdge
  exact hNecessary X edge hRestore hEdge

/-- If a restoring set is also inclusion-minimal among repair sets, each of its
selected actions has a private unresolved cut.  This theorem does not collapse
semantic restoration minimality into uniqueness. -/
theorem minimalRestoringRepairSet_has_private_cut
    {A : AdoptState}
    {problem : RepairProblem A}
    {Restore : RepairActionSet → Prop}
    (_hNecessary : EveryRepairCutNecessary problem Restore)
    {X : RepairActionSet}
    (_hRestore : Restore X)
    (hMinimal : MinimalRepairSet problem X)
    {action : RepairAction}
    (hSelected : X action) :
    ∃ edge,
      edge ∈ problem.edges ∧
      action ∈ edge.alternatives ∧
      ∀ alternative,
        alternative ∈ edge.alternatives →
        X alternative →
        alternative = action := by
  exact minimalRepairSet_has_private_edge hMinimal hSelected

end ResponsibilityTopology
