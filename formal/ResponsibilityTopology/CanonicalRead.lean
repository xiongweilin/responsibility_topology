import ResponsibilityTopology.Entitlement

namespace ResponsibilityTopology

/-!
Shared canonical read model for one fixed licensing invocation.

This layer is deliberately narrower than the V0.1.2.2 state machine. It does not
implement profile requirement lookup, context-currentness transitions, warrant
formation, or Python source semantics. The exact requirement has already been
resolved, and all abstract observations are projected from one canonical read.
-/

/-- Canonical warrant fields jointly observed by satisfaction and the kernel
floor. Formation fields are read only by atomic satisfaction. -/
structure CanonicalWarrant where
  claim : Claim
  role : Role
  scope : Scope
  formationProfileDigest : String
  formationContext : String
  deriving Repr, DecidableEq

/-- Fixed read model for one licensing invocation. `requirement` is the already
resolved exact requirement; requirement lookup itself remains outside this
milestone. -/
structure LicensingRead where
  profileDigest : String
  contextId : String
  use : String
  bindingActive : Bool
  bindingUse : String
  contextActive : Bool
  bindingScope : Scope
  requirement : Requirement
  warrant : WarrantId → Option CanonicalWarrant
  usable : WarrantId → Bool
  semantics : FloorSemantics

/-- A warrant ID is canonical when the shared read has a concrete object for it. -/
def Canonical (C : LicensingRead) (w : WarrantId) : Prop :=
  ∃ cw, C.warrant w = some cw

/-- Concrete/refinement hygiene boundary for candidate lists. Abstract NW
remains total and does not require this predicate. -/
def WellFormedCandidates (C : LicensingRead) (Γ : List WarrantId) : Prop :=
  ∀ ⦃w⦄, w ∈ Γ → Canonical C w

/-- Exact propositional atomic satisfaction read from one canonical warrant.
The same `C.semantics.scopeLE` used by the projected ambient and projected floor
semantics is used here. -/
def CanonicalAtomSat (C : LicensingRead) (w : WarrantId) (a : Atom) : Prop :=
  ∃ cw,
    C.warrant w = some cw ∧
    C.usable w = true ∧
    cw.formationContext = C.contextId ∧
    cw.formationProfileDigest = C.profileDigest ∧
    cw.claim = a.claim ∧
    cw.role = a.role ∧
    C.semantics.scopeLE a.scope cw.scope = true

/-- Executable spelling of `CanonicalAtomSat`. Unknown IDs are totalized to
`false` at this abstract executable surface. Python fail-fast correspondence for
unknown candidate IDs is a later conformance obligation guarded by
`WellFormedCandidates`. -/
def canonicalAtomTest (C : LicensingRead) (w : WarrantId) (a : Atom) : Bool :=
  match C.warrant w with
  | none => false
  | some cw =>
      C.usable w &&
        (decide (cw.formationContext = C.contextId) &&
          (decide (cw.formationProfileDigest = C.profileDigest) &&
            (decide (cw.claim = a.claim) &&
              (decide (cw.role = a.role) &&
                C.semantics.scopeLE a.scope cw.scope))))

/-- The executable atomic test is exactly the propositional canonical read. -/
theorem canonicalAtomTest_true_iff
    (C : LicensingRead) (w : WarrantId) (a : Atom) :
    canonicalAtomTest C w a = true ↔ CanonicalAtomSat C w a := by
  unfold canonicalAtomTest CanonicalAtomSat
  cases hLookup : C.warrant w with
  | none =>
      simp [hLookup]
  | some cw =>
      simp [hLookup]

/-- Declarative satisfaction projection from the shared canonical read. -/
def toEnv (C : LicensingRead) : Env where
  atomSat w a := CanonicalAtomSat C w a

/-- `SatOracle` is no longer supplied independently at the concrete read-model
boundary; it is derived from the same canonical source as `toEnv`. -/
def toOracle (C : LicensingRead) : SatOracle (toEnv C) where
  test := canonicalAtomTest C
  correct := by
    intro w a
    change canonicalAtomTest C w a = true ↔ CanonicalAtomSat C w a
    exact canonicalAtomTest_true_iff C w a

/-- Ambient projection for one fixed move. Binding-scope admissibility uses the
same `scopeLE` carried by the canonical read. -/
def toAmbient (C : LicensingRead) (m : FloorMove) : AmbientView where
  bindingActive := C.bindingActive = true
  useMatches := C.use = C.bindingUse
  contextActive := C.contextActive = true
  moveWithinBindingScope := C.semantics.scopeLE m.scope C.bindingScope = true
  requirement := C.requirement

/-- Explicit audit lemma for the shared ambient scope semantics. -/
theorem toAmbient_scope_iff (C : LicensingRead) (m : FloorMove) :
    (toAmbient C m).moveWithinBindingScope ↔
      C.semantics.scopeLE m.scope C.bindingScope = true := by
  rfl

/-- Floor projection of a canonical warrant. -/
def floorLeafOf (cw : CanonicalWarrant) : FloorLeaf :=
  ⟨cw.claim, cw.role, cw.scope⟩

/-- Total abstract floor environment obtained from the partial canonical lookup.
`fallback` exists only to inhabit the existing total `FloorEnv` interface. -/
def toFloorEnv (C : LicensingRead) (fallback : FloorLeaf) : FloorEnv where
  lookup w :=
    match C.warrant w with
    | some cw => floorLeafOf cw
    | none => fallback

/-- Canonical lookup selects the same warrant object for the floor projection,
independently of the totalization fallback. -/
theorem toFloorEnv_lookup_canonical
    (C : LicensingRead) (fallback : FloorLeaf)
    {w : WarrantId} {cw : CanonicalWarrant}
    (hLookup : C.warrant w = some cw) :
    (toFloorEnv C fallback).lookup w = floorLeafOf cw := by
  change
    (match C.warrant w with
      | some cw => floorLeafOf cw
      | none => fallback) = floorLeafOf cw
  rw [hLookup]

/-- A branch leaf is projection-coherent when both satisfaction-relevant fields
and the floor leaf are observations of one and the same canonical warrant. -/
def LeafProjectionCoherent
    (C : LicensingRead) (a : Atom) (w : WarrantId) : Prop :=
  ∃ cw,
    C.warrant w = some cw ∧
    C.usable w = true ∧
    cw.formationContext = C.contextId ∧
    cw.formationProfileDigest = C.profileDigest ∧
    cw.claim = a.claim ∧
    cw.role = a.role ∧
    C.semantics.scopeLE a.scope cw.scope = true ∧
    ∀ fallback, (toFloorEnv C fallback).lookup w = floorLeafOf cw

/-- Branch-level coherence recursively records that every selected leaf reads
one canonical warrant across the satisfaction and floor projections. -/
def BranchProjectionCoherent (C : LicensingRead) : Branch → Prop
  | .top => True
  | .leaf a w => LeafProjectionCoherent C a w
  | .both left right =>
      BranchProjectionCoherent C left ∧ BranchProjectionCoherent C right
  | .orL branch => BranchProjectionCoherent C branch
  | .orR branch => BranchProjectionCoherent C branch

/-- Every warrant selected by a derivation over the canonical environment exists
in the partial canonical lookup. -/
theorem derives_support_canonical
    {C : LicensingRead} {β : Branch} {R : Requirement}
    (hDerives : Derives (toEnv C) β R) :
    ∀ ⦃w⦄, w ∈ β.support → Canonical C w := by
  induction hDerives with
  | top =>
      intro w hMem
      change w ∈ ([] : List WarrantId) at hMem
      cases hMem
  | @atom a w hSat =>
      intro x hMem
      change x ∈ [w] at hMem
      cases hMem with
      | head =>
          change CanonicalAtomSat C w a at hSat
          rcases hSat with ⟨cw, hLookup, _⟩
          exact ⟨cw, hLookup⟩
      | tail _ hTail =>
          cases hTail
  | @both β₁ β₂ R₁ R₂ h₁ h₂ ih₁ ih₂ =>
      intro w hMem
      change w ∈ β₁.support ++ β₂.support at hMem
      rcases List.mem_append.mp hMem with hLeft | hRight
      · exact ih₁ hLeft
      · exact ih₂ hRight
  | @orL β R₁ R₂ h ih =>
      intro w hMem
      change w ∈ β.support at hMem
      exact ih hMem
  | @orR β R₁ R₂ h ih =>
      intro w hMem
      change w ∈ β.support at hMem
      exact ih hMem

/-- Equivalent list-level spelling of support canonicality. -/
theorem derives_support_wellFormed
    {C : LicensingRead} {β : Branch} {R : Requirement}
    (hDerives : Derives (toEnv C) β R) :
    WellFormedCandidates C β.support := by
  intro w hMem
  exact derives_support_canonical hDerives hMem

/-- Successful executable satisfaction from the derived canonical oracle selects
only canonical support, even though the oracle itself is total on unknown IDs. -/
theorem satisfy_support_wellFormed
    {C : LicensingRead} {R : Requirement}
    {Γ : List WarrantId} {β : Branch}
    (hRun : satisfy (toOracle C) R Γ = some β) :
    WellFormedCandidates C β.support := by
  exact derives_support_wellFormed (satisfySound (toOracle C) hRun)

/-- Totalization fallback is observationally irrelevant on the support of any
canonical derivation. -/
theorem floorEqOn_fallback_irrelevant
    {C : LicensingRead} {β : Branch} {R : Requirement}
    (d₁ d₂ : FloorLeaf)
    (hDerives : Derives (toEnv C) β R) :
    FloorEqOn (toFloorEnv C d₁) (toFloorEnv C d₂) β := by
  intro w hMem
  rcases derives_support_canonical hDerives hMem with ⟨cw, hLookup⟩
  rw [toFloorEnv_lookup_canonical C d₁ hLookup]
  rw [toFloorEnv_lookup_canonical C d₂ hLookup]

/-- View-level corollary of fallback irrelevance. -/
theorem floorView_fallback_irrelevant
    {C : LicensingRead} {β : Branch} {R : Requirement}
    (d₁ d₂ : FloorLeaf)
    (hDerives : Derives (toEnv C) β R) :
    floorView (toFloorEnv C d₁) β = floorView (toFloorEnv C d₂) β := by
  exact floorView_eq
    (toFloorEnv C d₁)
    (toFloorEnv C d₂)
    β
    (floorEqOn_fallback_irrelevant d₁ d₂ hDerives)

/-- Derivability forces branch-level projection coherence: the SatView and
FloorView of each selected leaf are projections of the same canonical warrant. -/
theorem derives_projection_coherent
    {C : LicensingRead} {β : Branch} {R : Requirement}
    (hDerives : Derives (toEnv C) β R) :
    BranchProjectionCoherent C β := by
  induction hDerives with
  | top =>
      trivial
  | @atom a w hSat =>
      change CanonicalAtomSat C w a at hSat
      rcases hSat with
        ⟨cw, hLookup, hUsable, hContext, hProfile, hClaim, hRole, hScope⟩
      change LeafProjectionCoherent C a w
      refine ⟨cw, hLookup, hUsable, hContext, hProfile, hClaim, hRole, hScope, ?_⟩
      intro fallback
      exact toFloorEnv_lookup_canonical C fallback hLookup
  | both h₁ h₂ ih₁ ih₂ =>
      exact ⟨ih₁, ih₂⟩
  | orL h ih =>
      exact ih
  | orR h ih =>
      exact ih

/-- Canonical interpretation of the existing entitlement judgment. Using
`C.semantics` here is the coherence point that prevents ambient/satisfaction
scope semantics from drifting away from the kernel-floor semantics. -/
def ProjectedEntitled
    (C : LicensingRead)
    (fallback : FloorLeaf)
    (β : Branch)
    (τ : LicenseType)
    (m : FloorMove) : Prop :=
  Entitled C.semantics (toAmbient C m) (toEnv C) (toFloorEnv C fallback) β τ m

/-- Because entitlement contains a canonical derivation, the totalization
fallback cannot affect projected entitlement. -/
theorem projectedEntitled_fallback_irrelevant
    (C : LicensingRead)
    (d₁ d₂ : FloorLeaf)
    (β : Branch)
    (τ : LicenseType)
    (m : FloorMove) :
    ProjectedEntitled C d₁ β τ m ↔ ProjectedEntitled C d₂ β τ m := by
  unfold ProjectedEntitled Entitled
  constructor
  · intro hEnt
    rcases hEnt with ⟨hAdm, hDerives, hSafe⟩
    have hFloor := floorEqOn_fallback_irrelevant d₁ d₂ hDerives
    have hKFL := kernelFloorLocality
      C.semantics (toFloorEnv C d₁) (toFloorEnv C d₂) β τ m hFloor
    exact ⟨hAdm, hDerives, hKFL.mp hSafe⟩
  · intro hEnt
    rcases hEnt with ⟨hAdm, hDerives, hSafe⟩
    have hFloor := floorEqOn_fallback_irrelevant d₂ d₁ hDerives
    have hKFL := kernelFloorLocality
      C.semantics (toFloorEnv C d₂) (toFloorEnv C d₁) β τ m hFloor
    exact ⟨hAdm, hDerives, hKFL.mp hSafe⟩

end ResponsibilityTopology
