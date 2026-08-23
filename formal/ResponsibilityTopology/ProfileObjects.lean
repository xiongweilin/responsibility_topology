import ResponsibilityTopology.RequirementResolution

namespace ResponsibilityTopology

/-!
Immutable profile objects used by historical formation.

A canonical profile owns both its exact rule table and the exact requirement
table introduced in #11.  The profile digest remains an opaque state key: no
theorem in this module treats digest equality as a cryptographic proof of
content equality.
-/

/-- Immutable rule semantics.  Rule IDs live in the enclosing `RuleEntry`, so a
rule cannot disagree with the key under which it is stored. -/
structure CanonicalRule where
  inputRoles : List Role
  outputRole : Role
  outputClaim : Claim
  kernelGuard : Option String
  deriving Repr, DecidableEq

structure RuleEntry where
  id : String
  rule : CanonicalRule
  deriving Repr, DecidableEq

/-- Exact rule-ID uniqueness.  Entry order is not a priority regime. -/
def UniqueRuleIds (entries : List RuleEntry) : Prop :=
  ∀ {ruleId e₁ e₂},
    e₁ ∈ entries →
    e₂ ∈ entries →
    e₁.id = ruleId →
    e₂.id = ruleId →
    e₁ = e₂

/-- Exact rule lookup; unknown IDs remain explicit absence. -/
def lookupRuleEntries : List RuleEntry → String → Option CanonicalRule
  | [], _ => none
  | entry :: rest, ruleId =>
      if entry.id = ruleId then some entry.rule else lookupRuleEntries rest ruleId

private theorem uniqueRuleIds_tail
    {entry : RuleEntry} {rest : List RuleEntry}
    (hUnique : UniqueRuleIds (entry :: rest)) :
    UniqueRuleIds rest := by
  intro ruleId e₁ e₂ h₁ h₂ hId₁ hId₂
  exact hUnique
    (List.Mem.tail entry h₁)
    (List.Mem.tail entry h₂)
    hId₁ hId₂

private theorem lookupRuleEntries_sound
    {entries : List RuleEntry} {ruleId : String} {rule : CanonicalRule}
    (hLookup : lookupRuleEntries entries ruleId = some rule) :
    ∃ entry, entry ∈ entries ∧ entry.id = ruleId ∧ entry.rule = rule := by
  induction entries with
  | nil =>
      simp [lookupRuleEntries] at hLookup
  | cons entry rest ih =>
      unfold lookupRuleEntries at hLookup
      by_cases hId : entry.id = ruleId
      · rw [if_pos hId] at hLookup
        cases hLookup
        exact ⟨entry, List.Mem.head rest, hId, rfl⟩
      · rw [if_neg hId] at hLookup
        rcases ih hLookup with ⟨found, hMem, hFoundId, hRule⟩
        exact ⟨found, List.Mem.tail entry hMem, hFoundId, hRule⟩

private theorem lookupRuleEntries_complete
    {entries : List RuleEntry} {ruleId : String} {entry : RuleEntry}
    (hUnique : UniqueRuleIds entries)
    (hMem : entry ∈ entries)
    (hId : entry.id = ruleId) :
    lookupRuleEntries entries ruleId = some entry.rule := by
  induction entries generalizing entry with
  | nil =>
      cases hMem
  | cons head rest ih =>
      unfold lookupRuleEntries
      by_cases hHeadId : head.id = ruleId
      · rw [if_pos hHeadId]
        have hEq : head = entry :=
          hUnique (List.Mem.head rest) hMem hHeadId hId
        cases hEq
        rfl
      · rw [if_neg hHeadId]
        cases hMem with
        | head =>
            exact False.elim (hHeadId hId)
        | tail _ hTail =>
            exact ih (uniqueRuleIds_tail hUnique) hTail hId

/-- One immutable profile referent.  Rules and requirements are two projections
of the same historical object, not two independent objects sharing a digest. -/
structure CanonicalProfile where
  rules : List RuleEntry
  uniqueRules : UniqueRuleIds rules
  requirementEntries : List RequirementEntry
  uniqueRequirements : UniqueRequirementKeys requirementEntries

/-- Exact rule lookup in one canonical profile. -/
def lookupRule (profile : CanonicalProfile) (ruleId : String) : Option CanonicalRule :=
  lookupRuleEntries profile.rules ruleId

/-- Successful lookup comes from an exact stored rule ID. -/
theorem ruleLookup_sound
    (profile : CanonicalProfile) (ruleId : String) {rule : CanonicalRule}
    (hLookup : lookupRule profile ruleId = some rule) :
    ∃ entry,
      entry ∈ profile.rules ∧ entry.id = ruleId ∧ entry.rule = rule := by
  exact lookupRuleEntries_sound hLookup

/-- Every exact stored rule ID is returned. -/
theorem ruleLookup_complete
    (profile : CanonicalProfile) (ruleId : String) (entry : RuleEntry)
    (hMem : entry ∈ profile.rules)
    (hId : entry.id = ruleId) :
    lookupRule profile ruleId = some entry.rule := by
  exact lookupRuleEntries_complete profile.uniqueRules hMem hId

/-- Unique IDs prevent list order from creating a hidden rule-priority regime. -/
theorem ruleLookup_deterministic
    (profile : CanonicalProfile) (ruleId : String)
    (e₁ e₂ : RuleEntry)
    (hMem₁ : e₁ ∈ profile.rules)
    (hMem₂ : e₂ ∈ profile.rules)
    (hId₁ : e₁.id = ruleId)
    (hId₂ : e₂.id = ruleId) :
    e₁.rule = e₂.rule := by
  have hEq : e₁ = e₂ := profile.uniqueRules hMem₁ hMem₂ hId₁ hId₂
  cases hEq
  rfl

/-- Projection of the requirement component of the same canonical profile.
The digest is supplied by the immutable state lookup key. -/
def CanonicalProfile.toRequirementSnapshot
    (profile : CanonicalProfile) (digest : String) : RequirementSnapshot where
  digest := digest
  entries := profile.requirementEntries
  uniqueKeys := profile.uniqueRequirements

theorem profileRequirementSnapshot_digest
    (profile : CanonicalProfile) (digest : String) :
    (profile.toRequirementSnapshot digest).digest = digest := by
  rfl

/-- Closed guard vocabulary currently owned by K0. -/
def KnownKernelGuard : Option String → Prop
  | none => True
  | some guard =>
      guard = "distinct_content_sources" ∨
      guard = "distinct_content_roots"

/-- Roles that ordinary rules may not synthesize unless the same role already
appears in the ordered input-role list. -/
def ProtectedRuleRole : Role → Prop
  | .authorization => True
  | .binding => True
  | .escalation => True
  | .provenance => True
  | .coverage => True
  | .bridge => True
  | _ => False

/-- The two special audited CONTENT^n -> PROVENANCE guard forms. -/
def UsesSpecialProvenanceGuard (rule : CanonicalRule) : Prop :=
  rule.outputRole = .provenance ∧
    (rule.kernelGuard = some "distinct_content_sources" ∨
      rule.kernelGuard = some "distinct_content_roots")

/-- Structural K0 typing discipline for profile-declared rules.  This is not a
rule-adequacy predicate. -/
def WellTypedRule (rule : CanonicalRule) : Prop :=
  KnownKernelGuard rule.kernelGuard ∧
    ((UsesSpecialProvenanceGuard rule ∧
        2 ≤ rule.inputRoles.length ∧
        ∀ role, role ∈ rule.inputRoles → role = .content) ∨
      (¬ UsesSpecialProvenanceGuard rule ∧
        (ProtectedRuleRole rule.outputRole →
          rule.outputRole ∈ rule.inputRoles) ∧
        (rule.outputRole = .content → .content ∈ rule.inputRoles) ∧
        (rule.outputRole = .selection → rule.inputRoles ≠ [])))

theorem wellTypedRule_knownGuard
    {rule : CanonicalRule} (hTyped : WellTypedRule rule) :
    KnownKernelGuard rule.kernelGuard :=
  hTyped.1

theorem wellTypedRule_special_provenance
    {rule : CanonicalRule}
    (hTyped : WellTypedRule rule)
    (hSpecial : UsesSpecialProvenanceGuard rule) :
    2 ≤ rule.inputRoles.length ∧
      ∀ role, role ∈ rule.inputRoles → role = .content := by
  rcases hTyped.2 with hSpecialCase | hNormal
  · exact ⟨hSpecialCase.2.1, hSpecialCase.2.2⟩
  · exact False.elim (hNormal.1 hSpecial)

theorem wellTypedRule_protected_output
    {rule : CanonicalRule}
    (hTyped : WellTypedRule rule)
    (hNotSpecial : ¬ UsesSpecialProvenanceGuard rule)
    (hProtected : ProtectedRuleRole rule.outputRole) :
    rule.outputRole ∈ rule.inputRoles := by
  rcases hTyped.2 with hSpecial | hNormal
  · exact False.elim (hNotSpecial hSpecial.1)
  · exact hNormal.2.1 hProtected

end ResponsibilityTopology
