import ResponsibilityTopology.EvaluationQualification

namespace ResponsibilityTopology

/-!
Ordinary INFER historical formation laws.

The transition consumes only immutable canonical history.  Parent usability is
not a formation premise; current-parent qualification is reserved for the later
`qualify_derived` milestone.
-/

/-- Evaluation/currentness topology preserved pointwise by INFER formation. -/
structure InferEvaluationTopologyUnchanged
    (S S' : CanonicalState) : Prop where
  activeContext : ∀ key, S'.activeContext key ↔ S.activeContext key
  activationProvenance : ∀ key,
    S'.activationProvenance key = S.activationProvenance key
  reviewRequired : ∀ licenseId,
    S'.reviewRequired licenseId ↔ S.reviewRequired licenseId
  license : ∀ licenseId, S'.license licenseId = S.license licenseId
  epi : ∀ key, S'.epi key = S.epi key
  placement : ∀ key, S'.placement key = S.placement key

/-- Exact history facts exposed by one ordinary INFER step.  The rule comes
from the immutable profile selected by the binding digest; parent IDs resolve in
order and with duplicates preserved. -/
theorem inferStep_newWarrant_exact
    {S S' : CanonicalState}
    {warrantId : WarrantId}
    {bindingId contextId ruleId : String}
    {parentIds : List WarrantId}
    {outScope : Scope}
    (hStep :
      Step S (.infer warrantId bindingId contextId ruleId parentIds outScope) S') :
    ∃ binding profile context rule parents,
      S.binding bindingId = some binding ∧
      S.profile binding.profileDigest = some profile ∧
      lookupRule profile ruleId = some rule ∧
      S.context contextId = some context ∧
      ResolvesParents S parentIds parents ∧
      InferFormationDiscipline
        context binding.profileDigest contextId rule parents outScope ∧
      S'.warrant warrantId = some
        (inferHistoricalWarrant
          ruleId binding.profileDigest contextId parentIds parents outScope rule) := by
  cases hStep with
  | @infer wid bid cid rid pids scope binding profile context rule parents
      fresh bindingCanonical profileCanonical ruleExact contextCanonical
      parentsCanonical discipline =>
      exact ⟨binding, profile, context, rule, parents,
        bindingCanonical, profileCanonical, ruleExact, contextCanonical,
        parentsCanonical, discipline, by simp [putCanonical]⟩

/-- Ordinary INFER is machine-fixed as intra-context and intra-profile-snapshot.
Cross-context formation must use a different constructor family. -/
theorem inferStep_parentEnvironment_exact
    {S S' : CanonicalState}
    {warrantId : WarrantId}
    {bindingId contextId ruleId : String}
    {parentIds : List WarrantId}
    {outScope : Scope}
    (hStep :
      Step S (.infer warrantId bindingId contextId ruleId parentIds outScope) S') :
    ∃ binding parents,
      S.binding bindingId = some binding ∧
      ResolvesParents S parentIds parents ∧
      (∀ parent, parent ∈ parents → parent.formationContext = contextId) ∧
      (∀ parent, parent ∈ parents →
        parent.formationProfileDigest = binding.profileDigest) := by
  rcases inferStep_newWarrant_exact hStep with
    ⟨binding, profile, context, rule, parents,
      hBinding, hProfile, hRule, hContext, hParents, hDiscipline, hWarrant⟩
  exact ⟨binding, parents, hBinding, hParents,
    hDiscipline.parentsSameContext, hDiscipline.parentsSameProfile⟩

/-- Ordered parent roles must match the exact bound rule declaration. -/
theorem inferStep_orderedParentRoles_exact
    {S S' : CanonicalState}
    {warrantId : WarrantId}
    {bindingId contextId ruleId : String}
    {parentIds : List WarrantId}
    {outScope : Scope}
    (hStep :
      Step S (.infer warrantId bindingId contextId ruleId parentIds outScope) S') :
    ∃ profile rule parents binding,
      S.binding bindingId = some binding ∧
      S.profile binding.profileDigest = some profile ∧
      lookupRule profile ruleId = some rule ∧
      ResolvesParents S parentIds parents ∧
      parents.map (fun parent => parent.role) = rule.inputRoles := by
  rcases inferStep_newWarrant_exact hStep with
    ⟨binding, profile, context, rule, parents,
      hBinding, hProfile, hRule, hContext, hParents, hDiscipline, hWarrant⟩
  exact ⟨profile, rule, parents, binding,
    hBinding, hProfile, hRule, hParents, hDiscipline.orderedRolesExact⟩

/-- Existing warrant IDs keep the exact same historical referent. -/
theorem inferStep_oldWarrants_immutable
    {S S' : CanonicalState}
    {warrantId : WarrantId}
    {bindingId contextId ruleId : String}
    {parentIds : List WarrantId}
    {outScope : Scope}
    (hStep :
      Step S (.infer warrantId bindingId contextId ruleId parentIds outScope) S') :
    ∀ ⦃id warrant⦄,
      S.warrant id = some warrant → S'.warrant id = some warrant := by
  exact (step_historyReferentsImmutable hStep).warrantImmutable

/-- INFER participates in the shared append-only historical-referent law. -/
theorem inferStep_historyReferentsImmutable
    {S S' : CanonicalState}
    {warrantId : WarrantId}
    {bindingId contextId ruleId : String}
    {parentIds : List WarrantId}
    {outScope : Scope}
    (hStep :
      Step S (.infer warrantId bindingId contextId ruleId parentIds outScope) S') :
    HistoryReferentsImmutable S S' :=
  step_historyReferentsImmutable hStep

/-- INFER formation does not write any represented evaluation/currentness field. -/
theorem inferStep_evaluationTopology_unchanged
    {S S' : CanonicalState}
    {warrantId : WarrantId}
    {bindingId contextId ruleId : String}
    {parentIds : List WarrantId}
    {outScope : Scope}
    (hStep :
      Step S (.infer warrantId bindingId contextId ruleId parentIds outScope) S') :
    InferEvaluationTopologyUnchanged S S' := by
  cases hStep with
  | infer fresh bindingCanonical profileCanonical ruleExact contextCanonical
      parentsCanonical discipline =>
      constructor <;> intro <;> rfl

/-- Fresh INFER formation creates historical derivability without creating any
evaluation position under any profile/context/use key. -/
theorem inferStep_newWarrant_unqualified
    {S S' : CanonicalState}
    {warrantId : WarrantId}
    {bindingId contextId ruleId : String}
    {parentIds : List WarrantId}
    {outScope : Scope}
    (hReachable : Reachable S)
    (hStep :
      Step S (.infer warrantId bindingId contextId ruleId parentIds outScope) S') :
    ∀ profileDigest observedContext use,
      S'.epi ⟨profileDigest, observedContext, use, warrantId⟩ = none ∧
      S'.placement ⟨profileDigest, observedContext, use, warrantId⟩ = none := by
  have hInv := reachable_invariant hReachable
  cases hStep with
  | infer fresh bindingCanonical profileCanonical ruleExact contextCanonical
      parentsCanonical discipline =>
      intro profileDigest observedContext use
      exact freshHistoricalWarrant_noEvaluation
        hInv.evaluationReferentsCanonical fresh
        profileDigest observedContext use

/-- Historical INFER formation alone never grants current usability. -/
theorem inferStep_newWarrant_notUsable
    {S S' : CanonicalState}
    {warrantId : WarrantId}
    {bindingId contextId ruleId : String}
    {parentIds : List WarrantId}
    {outScope : Scope}
    (hReachable : Reachable S)
    (hStep :
      Step S (.infer warrantId bindingId contextId ruleId parentIds outScope) S') :
    ∀ profileDigest observedContext use,
      ¬ Usable S' ⟨profileDigest, observedContext, use, warrantId⟩ := by
  intro profileDigest observedContext use
  exact noEvaluation_notUsable
    (inferStep_newWarrant_unqualified hReachable hStep
      profileDigest observedContext use)

/-- The exact output object exposes the required role-wise union of both lineage
notions without identifying those notions with one another. -/
theorem inferStep_lineage_union
    {S S' : CanonicalState}
    {warrantId : WarrantId}
    {bindingId contextId ruleId : String}
    {parentIds : List WarrantId}
    {outScope : Scope}
    (hStep :
      Step S (.infer warrantId bindingId contextId ruleId parentIds outScope) S') :
    ∃ binding profile context rule parents warrant,
      S.binding bindingId = some binding ∧
      S.profile binding.profileDigest = some profile ∧
      lookupRule profile ruleId = some rule ∧
      ResolvesParents S parentIds parents ∧
      S'.warrant warrantId = some warrant ∧
      (∀ role rootId,
        warrant.rootLineage role rootId ↔ mergeRootLineage parents role rootId) ∧
      (∀ role sourceId,
        warrant.sourceLineage role sourceId ↔ mergeSourceLineage parents role sourceId) := by
  rcases inferStep_newWarrant_exact hStep with
    ⟨binding, profile, context, rule, parents,
      hBinding, hProfile, hRule, hContext, hParents, hDiscipline, hWarrant⟩
  refine ⟨binding, profile, context, rule, parents,
    inferHistoricalWarrant ruleId binding.profileDigest contextId
      parentIds parents outScope rule,
    hBinding, hProfile, hRule, hParents, hWarrant, ?_, ?_⟩
  · intro role rootId
    rfl
  · intro role sourceId
    rfl

/-- Specialized preservation of the shared historical INFER invariant. -/
theorem inferStep_preserves_inferWarrantWellFormed
    {S S' : CanonicalState}
    {warrantId : WarrantId}
    {bindingId contextId ruleId : String}
    {parentIds : List WarrantId}
    {outScope : Scope}
    (hInv : CanonicalStateInvariant S)
    (hStep :
      Step S (.infer warrantId bindingId contextId ruleId parentIds outScope) S') :
    InferWarrantWellFormed S' :=
  (step_preserves_invariant hInv hStep).inferWarrantWellFormed

/-- Specialized preservation of canonical ordered parent references. -/
theorem inferStep_preserves_warrantParentsCanonical
    {S S' : CanonicalState}
    {warrantId : WarrantId}
    {bindingId contextId ruleId : String}
    {parentIds : List WarrantId}
    {outScope : Scope}
    (hInv : CanonicalStateInvariant S)
    (hStep :
      Step S (.infer warrantId bindingId contextId ruleId parentIds outScope) S') :
    WarrantParentsCanonical S' :=
  (step_preserves_invariant hInv hStep).warrantParentsCanonical

end ResponsibilityTopology
