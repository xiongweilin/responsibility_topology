import ResponsibilityTopology.InferenceObjects

namespace ResponsibilityTopology

/-!
Static ordinary-INFER formation discipline.

The escalation interpretation below deliberately accepts only the canonical
closed spellings `EscalationDepth("0")` through `EscalationDepth("5")`.  Python
currently obtains its result through `_claim_depth`/`int`; correspondence between
that parser and this canonical interpretation remains a future executable
refinement obligation.  The transition law itself nevertheless includes the
no-amplification responsibility boundary.
-/

/-- Set-semantic scope narrowing over the existing list transport encoding. -/
def ScopeNarrowerOrEqual (left right : Scope) : Prop :=
  ∀ atom, atom ∈ left.atoms → atom ∈ right.atoms

/-- Canonical closed interpretation of V0.1.2 revision-strength claims. -/
def canonicalEscalationDepth (claim : Claim) : Option RevisionDepth :=
  if claim.kind = "EscalationDepth" then
    match claim.args with
    | [raw] =>
        if raw = "0" then some 0
        else if raw = "1" then some 1
        else if raw = "2" then some 2
        else if raw = "3" then some 3
        else if raw = "4" then some 4
        else if raw = "5" then some 5
        else none
    | _ => none
  else
    none

private def maxDepthOption
    (left right : Option RevisionDepth) : Option RevisionDepth :=
  match left, right with
  | none, none => none
  | some depth, none => some depth
  | none, some depth => some depth
  | some leftDepth, some rightDepth => some (Nat.max leftDepth rightDepth)

/-- Maximum valid escalation-role depth among historical parents. -/
def maxParentEscalationDepth : List HistoricalWarrant → Option RevisionDepth
  | [] => none
  | parent :: rest =>
      let tail := maxParentEscalationDepth rest
      if parent.role = .escalation then
        maxDepthOption (canonicalEscalationDepth parent.claim) tail
      else
        tail

/-- INFER may not amplify a canonically interpretable escalation output beyond
its strongest canonically interpretable escalation parent. -/
def NoEscalationAmplification
    (rule : CanonicalRule) (parents : List HistoricalWarrant) : Prop :=
  if rule.outputRole = .escalation then
    match canonicalEscalationDepth rule.outputClaim with
    | none => True
    | some outputDepth =>
        ∃ parentDepth,
          maxParentEscalationDepth parents = some parentDepth ∧
          outputDepth ≤ parentDepth
  else
    True

/-- Every parent contributes at least one CONTENT external source. -/
def ContentSourcesNonempty (parents : List HistoricalWarrant) : Prop :=
  ∀ parent, parent ∈ parents →
    ∃ sourceId, parent.sourceLineage .content sourceId

/-- Pairwise disjoint CONTENT source ancestry.  This recursion is occurrence
sensitive: duplicate parent occurrences are not silently deduplicated. -/
def PairwiseContentSourcesDisjoint : List HistoricalWarrant → Prop
  | [] => True
  | parent :: rest =>
      (∀ other, other ∈ rest →
        ∀ sourceId,
          parent.sourceLineage .content sourceId →
          ¬ other.sourceLineage .content sourceId) ∧
      PairwiseContentSourcesDisjoint rest

/-- Every parent contributes at least one CONTENT root warrant. -/
def ContentRootsNonempty (parents : List HistoricalWarrant) : Prop :=
  ∀ parent, parent ∈ parents →
    ∃ rootId, parent.rootLineage .content rootId

/-- Pairwise disjoint CONTENT root ancestry, again preserving duplicate parent
occurrences as semantically meaningful inputs. -/
def PairwiseContentRootsDisjoint : List HistoricalWarrant → Prop
  | [] => True
  | parent :: rest =>
      (∀ other, other ∈ rest →
        ∀ rootId,
          parent.rootLineage .content rootId →
          ¬ other.rootLineage .content rootId) ∧
      PairwiseContentRootsDisjoint rest

/-- Guard execution over the two distinct lineage notions established in #12.
Unknown guards have no fallback semantics. -/
def KernelGuardSatisfied
    (guard : Option String) (parents : List HistoricalWarrant) : Prop :=
  match guard with
  | none => True
  | some guardName =>
      (guardName = "distinct_content_sources" ∧
        ContentSourcesNonempty parents ∧
        PairwiseContentSourcesDisjoint parents) ∨
      (guardName = "distinct_content_roots" ∧
        ContentRootsNonempty parents ∧
        PairwiseContentRootsDisjoint parents)

theorem kernelGuard_distinctContentSources
    (parents : List HistoricalWarrant) :
    KernelGuardSatisfied (some "distinct_content_sources") parents ↔
      ContentSourcesNonempty parents ∧ PairwiseContentSourcesDisjoint parents := by
  simp [KernelGuardSatisfied]

theorem kernelGuard_distinctContentRoots
    (parents : List HistoricalWarrant) :
    KernelGuardSatisfied (some "distinct_content_roots") parents ↔
      ContentRootsNonempty parents ∧ PairwiseContentRootsDisjoint parents := by
  simp [KernelGuardSatisfied]

/-- Complete static discipline checked by ordinary INFER formation after exact
profile/rule and parent lookup.  Parent usability is intentionally absent. -/
structure InferFormationDiscipline
    (context : CanonicalContext)
    (profileDigest contextId : String)
    (rule : CanonicalRule)
    (parents : List HistoricalWarrant)
    (outScope : Scope) : Prop where
  wellTyped : WellTypedRule rule
  parentsSameContext :
    ∀ parent, parent ∈ parents → parent.formationContext = contextId
  parentsSameProfile :
    ∀ parent, parent ∈ parents →
      parent.formationProfileDigest = profileDigest
  orderedRolesExact : parents.map (fun parent => parent.role) = rule.inputRoles
  outputAccepted : context.accepts rule.outputClaim
  scopeNonWidening :
    ∀ parent, parent ∈ parents → ScopeNarrowerOrEqual outScope parent.scope
  guardSatisfied : KernelGuardSatisfied rule.kernelGuard parents
  noEscalationAmplification : NoEscalationAmplification rule parents

end ResponsibilityTopology
