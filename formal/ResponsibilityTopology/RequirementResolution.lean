import ResponsibilityTopology.CanonicalRead

namespace ResponsibilityTopology

/-!
Exact requirement resolution over full move identity.

This is a static semantics layer. It deliberately does not extend `Reachable`,
model profile registration/state correspondence, or interpret profile digests as
cryptographic proofs of contents.

`FloorMove` remains the narrow projection consumed by `licenseSafe`; full move
arguments live only in `CanonicalMove` and requirement identity.
-/

/-- Full move identity used by exact profile requirement lookup. `args` is
ordered semantic content: it is neither sorted nor deduplicated. `scope` is a
semantic set carried by the existing list transport representation. -/
structure CanonicalMove where
  kind : MoveKind
  args : List String
  scope : Scope
  revisionDepth : RevisionDepth
  deriving Repr

namespace CanonicalMove

/-- Downward projection to the strictly smaller kernel-floor observation. -/
def toFloorMove (m : CanonicalMove) : FloorMove where
  kind := m.kind
  scope := m.scope
  revisionDepth := m.revisionDepth

end CanonicalMove

/-- Projection firewall: adding full move arguments does not enlarge the input
surface of BC/KFL/RBC. -/
theorem canonicalMove_floorProjection (m : CanonicalMove) :
    m.toFloorMove = ⟨m.kind, m.scope, m.revisionDepth⟩ := by
  rfl

/-- Finite subset test for the list transport representation of a scope. -/
def scopeSubsetTest : List String → List String → Bool
  | [], _ => true
  | atom :: rest, target =>
      if atom ∈ target then scopeSubsetTest rest target else false

/-- Propositional extensional identity for scopes. Ordering and duplicate
occurrences are intentionally ignored. -/
def ScopeIdentity (left right : Scope) : Prop :=
  (∀ atom, atom ∈ left.atoms → atom ∈ right.atoms) ∧
  (∀ atom, atom ∈ right.atoms → atom ∈ left.atoms)

/-- Executable extensional scope identity. -/
def scopeIdentityTest (left right : Scope) : Bool :=
  scopeSubsetTest left.atoms right.atoms &&
    scopeSubsetTest right.atoms left.atoms

private theorem scopeSubsetTest_true_iff
    (source target : List String) :
    scopeSubsetTest source target = true ↔
      ∀ atom, atom ∈ source → atom ∈ target := by
  induction source with
  | nil =>
      simp [scopeSubsetTest]
  | cons head tail ih =>
      by_cases hHead : head ∈ target
      · rw [scopeSubsetTest, if_pos hHead, ih]
        constructor
        · intro hSubset atom hMem
          cases hMem with
          | head => exact hHead
          | tail _ hTail => exact hSubset atom hTail
        · intro hSubset atom hMem
          exact hSubset atom (List.Mem.tail head hMem)
      · rw [scopeSubsetTest, if_neg hHead]
        constructor
        · intro hFalse
          cases hFalse
        · intro hSubset
          exact False.elim (hHead (hSubset head (List.Mem.head tail)))

/-- Boolean scope identity is exactly extensional set identity. -/
theorem scopeIdentityTest_true_iff (left right : Scope) :
    scopeIdentityTest left right = true ↔ ScopeIdentity left right := by
  simp [scopeIdentityTest, ScopeIdentity, scopeSubsetTest_true_iff]

/-- Complete requirement identity: license type plus full move identity. -/
structure RequirementKey where
  licenseType : LicenseType
  move : CanonicalMove
  deriving Repr

/-- Propositional exact-key relation. All non-scope fields use exact equality;
scope uses extensional identity because its list is only a transport encoding. -/
def RequirementKeyMatches (left right : RequirementKey) : Prop :=
  left.licenseType = right.licenseType ∧
  left.move.kind = right.move.kind ∧
  left.move.args = right.move.args ∧
  left.move.revisionDepth = right.move.revisionDepth ∧
  ScopeIdentity left.move.scope right.move.scope

/-- Executable exact-key test. -/
def requirementKeyTest (left right : RequirementKey) : Bool :=
  decide (left.licenseType = right.licenseType) &&
    (decide (left.move.kind = right.move.kind) &&
      (decide (left.move.args = right.move.args) &&
        (decide (left.move.revisionDepth = right.move.revisionDepth) &&
          scopeIdentityTest left.move.scope right.move.scope)))

/-- Executable key equality is exactly the intended full-move identity. -/
theorem requirementKeyTest_true_iff (left right : RequirementKey) :
    requirementKeyTest left right = true ↔ RequirementKeyMatches left right := by
  simp [requirementKeyTest, RequirementKeyMatches, scopeIdentityTest_true_iff]

structure RequirementEntry where
  key : RequirementKey
  requirement : Requirement
  deriving Repr

/-- Unique-key invariant stated observationally: for any exact query there is at
most one entry that can match it. This prevents entry ordering from encoding a
hidden priority rule. -/
def UniqueRequirementKeys (entries : List RequirementEntry) : Prop :=
  ∀ {query e₁ e₂},
    e₁ ∈ entries →
    e₂ ∈ entries →
    requirementKeyTest e₁.key query = true →
    requirementKeyTest e₂.key query = true →
    e₁ = e₂

/-- Immutable requirement-table model. `digest` is opaque canonical identity;
no theorem here relates digest equality to table-content equality. -/
structure RequirementSnapshot where
  digest : String
  entries : List RequirementEntry
  uniqueKeys : UniqueRequirementKeys entries

/-- Ordered scan is an implementation of exact lookup, not a priority regime:
`uniqueKeys` ensures at most one entry can match. -/
def lookupRequirementEntries :
    List RequirementEntry → RequirementKey → Option Requirement
  | [], _ => none
  | entry :: rest, key =>
      if requirementKeyTest entry.key key = true then
        some entry.requirement
      else
        lookupRequirementEntries rest key

/-- Exact lookup in one immutable requirement snapshot. -/
def lookupRequirement
    (snapshot : RequirementSnapshot)
    (key : RequirementKey) : Option Requirement :=
  lookupRequirementEntries snapshot.entries key

private theorem uniqueRequirementKeys_tail
    {entry : RequirementEntry} {rest : List RequirementEntry}
    (hUnique : UniqueRequirementKeys (entry :: rest)) :
    UniqueRequirementKeys rest := by
  intro query e₁ e₂ h₁ h₂ hMatch₁ hMatch₂
  exact hUnique
    (List.Mem.tail entry h₁)
    (List.Mem.tail entry h₂)
    hMatch₁ hMatch₂

private theorem lookupRequirementEntries_sound
    {entries : List RequirementEntry}
    {key : RequirementKey}
    {R : Requirement}
    (hLookup : lookupRequirementEntries entries key = some R) :
    ∃ entry,
      entry ∈ entries ∧
      requirementKeyTest entry.key key = true ∧
      entry.requirement = R := by
  induction entries with
  | nil =>
      simp [lookupRequirementEntries] at hLookup
  | cons entry rest ih =>
      unfold lookupRequirementEntries at hLookup
      by_cases hMatch : requirementKeyTest entry.key key = true
      · rw [if_pos hMatch] at hLookup
        cases hLookup
        exact ⟨entry, List.Mem.head rest, hMatch, rfl⟩
      · rw [if_neg hMatch] at hLookup
        rcases ih hLookup with ⟨found, hMem, hFoundMatch, hRequirement⟩
        exact ⟨found, List.Mem.tail entry hMem, hFoundMatch, hRequirement⟩

private theorem lookupRequirementEntries_complete
    {entries : List RequirementEntry}
    {key : RequirementKey}
    {entry : RequirementEntry}
    (hUnique : UniqueRequirementKeys entries)
    (hMem : entry ∈ entries)
    (hMatch : requirementKeyTest entry.key key = true) :
    lookupRequirementEntries entries key = some entry.requirement := by
  induction entries generalizing entry with
  | nil =>
      cases hMem
  | cons head rest ih =>
      unfold lookupRequirementEntries
      by_cases hHeadMatch : requirementKeyTest head.key key = true
      · rw [if_pos hHeadMatch]
        have hEq : head = entry :=
          hUnique (List.Mem.head rest) hMem hHeadMatch hMatch
        cases hEq
        rfl
      · rw [if_neg hHeadMatch]
        cases hMem with
        | head =>
            exact False.elim (hHeadMatch hMatch)
        | tail _ hTail =>
            exact ih (uniqueRequirementKeys_tail hUnique) hTail hMatch

/-- Soundness: any resolved requirement comes from an exact matching entry. -/
theorem requirementLookup_sound
    (snapshot : RequirementSnapshot)
    (key : RequirementKey)
    {R : Requirement}
    (hLookup : lookupRequirement snapshot key = some R) :
    ∃ entry,
      entry ∈ snapshot.entries ∧
      RequirementKeyMatches entry.key key ∧
      entry.requirement = R := by
  rcases lookupRequirementEntries_sound hLookup with
    ⟨entry, hMem, hMatch, hRequirement⟩
  exact ⟨entry, hMem, (requirementKeyTest_true_iff entry.key key).mp hMatch, hRequirement⟩

/-- Completeness: an exact matching declared entry is returned. -/
theorem requirementLookup_complete
    (snapshot : RequirementSnapshot)
    (key : RequirementKey)
    (entry : RequirementEntry)
    (hMem : entry ∈ snapshot.entries)
    (hMatch : RequirementKeyMatches entry.key key) :
    lookupRequirement snapshot key = some entry.requirement := by
  exact lookupRequirementEntries_complete
    snapshot.uniqueKeys
    hMem
    ((requirementKeyTest_true_iff entry.key key).mpr hMatch)

/-- Determinism is a property of the unique-key snapshot, not an implicit
priority of the entry list. -/
theorem requirementLookup_deterministic
    (snapshot : RequirementSnapshot)
    (key : RequirementKey)
    (e₁ e₂ : RequirementEntry)
    (hMem₁ : e₁ ∈ snapshot.entries)
    (hMem₂ : e₂ ∈ snapshot.entries)
    (hMatch₁ : RequirementKeyMatches e₁.key key)
    (hMatch₂ : RequirementKeyMatches e₂.key key) :
    e₁.requirement = e₂.requirement := by
  have hEq : e₁ = e₂ := snapshot.uniqueKeys
    hMem₁ hMem₂
    ((requirementKeyTest_true_iff e₁.key key).mpr hMatch₁)
    ((requirementKeyTest_true_iff e₂.key key).mpr hMatch₂)
  cases hEq
  rfl

/-- Exact-key audit theorem. A successful lookup fixes license type, kind,
ordered args, revision depth, and extensional scope identity. No subsumption or
near-match rule is available. -/
theorem requirementLookup_exactKey
    (snapshot : RequirementSnapshot)
    (key : RequirementKey)
    {R : Requirement}
    (hLookup : lookupRequirement snapshot key = some R) :
    ∃ entry,
      entry ∈ snapshot.entries ∧
      entry.requirement = R ∧
      entry.key.licenseType = key.licenseType ∧
      entry.key.move.kind = key.move.kind ∧
      entry.key.move.args = key.move.args ∧
      entry.key.move.revisionDepth = key.move.revisionDepth ∧
      ScopeIdentity entry.key.move.scope key.move.scope := by
  rcases requirementLookup_sound snapshot key hLookup with
    ⟨entry, hMem, hExact, hRequirement⟩
  rcases hExact with ⟨hLicense, hKind, hArgs, hDepth, hScope⟩
  exact ⟨entry, hMem, hRequirement, hLicense, hKind, hArgs, hDepth, hScope⟩

/-- Explicit absence means there is no exact matching declaration. -/
theorem missingRequirement_noMatchingEntry
    (snapshot : RequirementSnapshot)
    (key : RequirementKey) :
    lookupRequirement snapshot key = none ↔
      ∀ entry, entry ∈ snapshot.entries → ¬ RequirementKeyMatches entry.key key := by
  constructor
  · intro hNone entry hMem hMatch
    have hSome := requirementLookup_complete snapshot key entry hMem hMatch
    rw [hNone] at hSome
    cases hSome
  · intro hNoMatch
    cases hLookup : lookupRequirement snapshot key with
    | none => rfl
    | some R =>
        rcases requirementLookup_sound snapshot key hLookup with
          ⟨entry, hMem, hMatch, _⟩
        exact False.elim ((hNoMatch entry hMem) hMatch)

/-- Anti-shortcut boundary: an undeclared key is not the same thing as an
explicitly declared no-obligation (`top`) key. -/
theorem missingRequirement_notTop
    (snapshot : RequirementSnapshot)
    (key : RequirementKey)
    (hMissing : lookupRequirement snapshot key = none) :
    lookupRequirement snapshot key ≠ some .top := by
  rw [hMissing]
  intro h
  cases h

/-- Entry order is semantically irrelevant for unique-key snapshots. -/
theorem requirementLookup_permutation
    (left right : RequirementSnapshot)
    (key : RequirementKey)
    (hPerm : left.entries.Perm right.entries) :
    lookupRequirement left key = lookupRequirement right key := by
  cases hLeft : lookupRequirement left key with
  | none =>
      cases hRight : lookupRequirement right key with
      | none => rfl
      | some R =>
          rcases requirementLookup_sound right key hRight with
            ⟨entry, hMemRight, hMatch, _⟩
          have hMemLeft : entry ∈ left.entries :=
            (hPerm.mem_iff).mpr hMemRight
          have hSomeLeft := requirementLookup_complete left key entry hMemLeft hMatch
          rw [hLeft] at hSomeLeft
          cases hSomeLeft
  | some R =>
      rcases requirementLookup_sound left key hLeft with
        ⟨entry, hMemLeft, hMatch, hRequirement⟩
      have hMemRight : entry ∈ right.entries :=
        (hPerm.mem_iff).mp hMemLeft
      have hRight := requirementLookup_complete right key entry hMemRight hMatch
      have hRightR : lookupRequirement right key = some R := by
        simpa [hRequirement] using hRight
      exact hRightR.symm

/-- Requirement-free portion of the existing canonical licensing read. -/
structure UnresolvedLicensingRead where
  profileDigest : String
  contextId : String
  use : String
  bindingActive : Bool
  bindingUse : String
  contextActive : Bool
  bindingScope : Scope
  warrant : WarrantId → Option CanonicalWarrant
  usable : WarrantId → Bool
  semantics : FloorSemantics

namespace UnresolvedLicensingRead

/-- Downstream projection after exact resolution. -/
def withRequirement
    (U : UnresolvedLicensingRead)
    (R : Requirement) : LicensingRead where
  profileDigest := U.profileDigest
  contextId := U.contextId
  use := U.use
  bindingActive := U.bindingActive
  bindingUse := U.bindingUse
  contextActive := U.contextActive
  bindingScope := U.bindingScope
  requirement := R
  warrant := U.warrant
  usable := U.usable
  semantics := U.semantics

end UnresolvedLicensingRead

/-- Resolve a full move against an opaque-identical profile snapshot, then feed
only the resolved requirement into the existing `LicensingRead` interface.
Digest equality is an explicit identity premise; it is not a hashing theorem. -/
def resolveLicensingRead
    (snapshot : RequirementSnapshot)
    (τ : LicenseType)
    (m : CanonicalMove)
    (U : UnresolvedLicensingRead)
    (_digestIdentity : U.profileDigest = snapshot.digest) : Option LicensingRead :=
  match lookupRequirement snapshot ⟨τ, m⟩ with
  | none => none
  | some R => some (U.withRequirement R)

/-- The existing canonical read consumes exactly the result of static exact
resolution and does not learn the requirement-table representation. -/
theorem resolvedLicensingRead_requirement
    (snapshot : RequirementSnapshot)
    (τ : LicenseType)
    (m : CanonicalMove)
    (U : UnresolvedLicensingRead)
    (hDigest : U.profileDigest = snapshot.digest)
    {C : LicensingRead}
    (hResolved : resolveLicensingRead snapshot τ m U hDigest = some C) :
    lookupRequirement snapshot ⟨τ, m⟩ = some C.requirement := by
  unfold resolveLicensingRead at hResolved
  cases hLookup : lookupRequirement snapshot ⟨τ, m⟩ with
  | none =>
      simp [hLookup] at hResolved
  | some R =>
      simp [hLookup] at hResolved
      cases hResolved
      change lookupRequirement snapshot ⟨τ, m⟩ = some R
      exact hLookup

end ResponsibilityTopology
