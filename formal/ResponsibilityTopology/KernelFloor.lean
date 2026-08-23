import ResponsibilityTopology.Syntax

namespace ResponsibilityTopology

/-!
Abstract kernel-floor projection for V0.1.2.2.

This layer deliberately does not model full history, warrant formation,
provenance ancestry, profile/context/currentness, or full move identity. It
models only the observations consumed by the current `license_safe()` floor.
-/

inductive LicenseType where
  | epistemic
  | normative
  | action
  deriving Repr, DecidableEq

inductive MoveKind where
  | accept
  | share
  | suspect
  | reopen
  | adopt
  | act
  | resolveStatus
  | review
  deriving Repr, DecidableEq

abbrev RevisionDepth := Nat

structure FloorLeaf where
  claim : Claim
  role : Role
  scope : Scope
  deriving Repr, DecidableEq

structure FloorEnv where
  lookup : WarrantId → FloorLeaf

structure FloorMove where
  kind : MoveKind
  scope : Scope
  revisionDepth : RevisionDepth
  deriving Repr, DecidableEq

/-- The abstract semantic operations actually consulted by the current floor.
`scopeLE moveScope warrantScope` corresponds to Python's
`move.scope.narrower_or_equal(w.scope)`. `escalationDepth` abstracts the current
`EscalationDepth(n)` claim parser. -/
structure FloorSemantics where
  scopeLE : Scope → Scope → Bool
  escalationDepth : Claim → Option RevisionDepth

/-- The complete branch-local warrant observation visible to the floor. -/
def floorView (F : FloorEnv) (β : Branch) : List FloorLeaf :=
  β.support.map F.lookup

/-- Pure role equality used so the floor does not depend on generic membership
machinery. -/
def floorRoleEq : Role → Role → Bool
  | .content, .content => true
  | .bridge, .bridge => true
  | .provenance, .provenance => true
  | .coverage, .coverage => true
  | .selection, .selection => true
  | .escalation, .escalation => true
  | .authorization, .authorization => true
  | .binding, .binding => true
  | _, _ => false

/-- Whether the projected branch contains at least one leaf with the given role. -/
def hasRole (role : Role) : List FloorLeaf → Bool
  | [] => false
  | leaf :: rest =>
      if floorRoleEq leaf.role role = true then true else hasRole role rest

/-- Every selected leaf warrant must cover the move scope. -/
def allScopesCover (S : FloorSemantics) (moveScope : Scope) : List FloorLeaf → Bool
  | [] => true
  | leaf :: rest =>
      if S.scopeLE moveScope leaf.scope = true then
        allScopesCover S moveScope rest
      else
        false

/-- Maximum valid escalation depth among escalation-role leaves. Invalid or
non-escalation claims contribute no depth, matching the Python floor. -/
def maxEscalationDepth (S : FloorSemantics) : List FloorLeaf → RevisionDepth
  | [] => 0
  | leaf :: rest =>
      let tailDepth := maxEscalationDepth S rest
      if floorRoleEq leaf.role .escalation = true then
        match S.escalationDepth leaf.claim with
        | none => tailDepth
        | some depth => Nat.max depth tailDepth
      else
        tailDepth

/-- Kernel floor for revision moves: escalation role plus sufficient depth. -/
def revisionFloor (S : FloorSemantics) (m : FloorMove) (view : List FloorLeaf) : Bool :=
  if hasRole .escalation view = true then
    if m.revisionDepth ≤ maxEscalationDepth S view then true else false
  else
    false

/-- Move-specific V0.1.2.2 floor clauses, excluding the license-type-wide ACTION
requirement and the universal scope-coverage check. REVIEW and ACCEPT deliberately
have no additional floor here. -/
def moveFloor (S : FloorSemantics) (m : FloorMove) (view : List FloorLeaf) : Bool :=
  match m.kind with
  | .accept => true
  | .review => true
  | .act => hasRole .authorization view
  | .share => hasRole .selection view
  | .suspect => revisionFloor S m view
  | .reopen => revisionFloor S m view
  | .adopt =>
      if revisionFloor S m view = true then hasRole .selection view else false
  | .resolveStatus =>
      if hasRole .selection view = true then true else hasRole .authorization view

/-- Non-normative kernel floor. ACTION licenses require authorization regardless
of move kind; `Act` independently requires authorization through `moveFloor`. -/
def safeNonNorm
    (S : FloorSemantics)
    (actionLicense : Bool)
    (m : FloorMove)
    (view : List FloorLeaf) : Bool :=
  if allScopesCover S m.scope view = true then
    if actionLicense = true then
      if hasRole .authorization view = true then moveFloor S m view else false
    else
      moveFloor S m view
  else
    false

/-- Exact abstract form of the current Python `license_safe()` kernel floor.
NORMATIVE is deliberately disabled in V0.1.2.2. -/
def safeFromView
    (S : FloorSemantics)
    (τ : LicenseType)
    (m : FloorMove)
    (view : List FloorLeaf) : Bool :=
  match τ with
  | .normative => false
  | .epistemic => safeNonNorm S false m view
  | .action => safeNonNorm S true m view

/-- Branch/history-facing wrapper around the pure view function. -/
def licenseSafe
    (S : FloorSemantics)
    (F : FloorEnv)
    (β : Branch)
    (τ : LicenseType)
    (m : FloorMove) : Bool :=
  safeFromView S τ m (floorView F β)

/-- Propositional spelling used by KFL. -/
def Safe
    (S : FloorSemantics)
    (F : FloorEnv)
    (β : Branch)
    (τ : LicenseType)
    (m : FloorMove) : Prop :=
  licenseSafe S F β τ m = true

/-- Two floor environments agree on exactly the warrant IDs selected by a branch. -/
def FloorEqOn (F F' : FloorEnv) (β : Branch) : Prop :=
  ∀ ⦃w⦄, w ∈ β.support → F.lookup w = F'.lookup w

/-- Pointwise agreement on a list is sufficient to replay its mapped lookup view. -/
theorem lookupMap_eq_on
    (F F' : FloorEnv)
    {ws : List WarrantId}
    (hEq : ∀ ⦃w⦄, w ∈ ws → F.lookup w = F'.lookup w) :
    ws.map F.lookup = ws.map F'.lookup := by
  induction ws with
  | nil => rfl
  | cons w ws ih =>
      have hHead : F.lookup w = F'.lookup w := hEq (List.Mem.head ws)
      have hTail : ∀ ⦃x⦄, x ∈ ws → F.lookup x = F'.lookup x := by
        intro x hMem
        exact hEq (List.Mem.tail w hMem)
      rw [List.map_cons, List.map_cons, hHead, ih hTail]

/-- Floor projection locality: changing warrant data outside the branch support,
or fields not represented by `FloorLeaf`, cannot change the projected view. -/
theorem floorView_eq
    (F F' : FloorEnv)
    (β : Branch)
    (hEq : FloorEqOn F F' β) :
    floorView F β = floorView F' β := by
  unfold floorView
  exact lookupMap_eq_on F F' hEq

/-- KFL — Kernel-Floor Locality.
For fixed semantics, license type, move, and branch, current floor safety depends
only on the branch-local `FloorLeaf` projection. This is a locality theorem, not
a KernelFloorAdequacy theorem. -/
theorem kernelFloorLocality
    (S : FloorSemantics)
    (F F' : FloorEnv)
    (β : Branch)
    (τ : LicenseType)
    (m : FloorMove)
    (hEq : FloorEqOn F F' β) :
    Safe S F β τ m ↔ Safe S F' β τ m := by
  unfold Safe licenseSafe
  rw [floorView_eq F F' β hEq]

/-! Small clause-characterization lemmas. These are translation checks for the
current floor, not adequacy claims. -/

theorem normative_disabled
    (S : FloorSemantics)
    (F : FloorEnv)
    (β : Branch)
    (m : FloorMove) :
    licenseSafe S F β .normative m = false := by
  rfl

theorem action_without_authorization_unsafe
    (S : FloorSemantics)
    (F : FloorEnv)
    (β : Branch)
    (m : FloorMove)
    (hAuth : hasRole .authorization (floorView F β) = false) :
    licenseSafe S F β .action m = false := by
  unfold licenseSafe safeFromView safeNonNorm
  cases hScope : allScopesCover S m.scope (floorView F β) with
  | false => rw [hScope]
  | true => rw [hScope, hAuth]

theorem share_without_selection_moveFloor
    (S : FloorSemantics)
    (scope : Scope)
    (depth : RevisionDepth)
    (view : List FloorLeaf)
    (hSelection : hasRole .selection view = false) :
    moveFloor S ⟨.share, scope, depth⟩ view = false := by
  exact hSelection

theorem revisionFloor_insufficient_depth
    (S : FloorSemantics)
    (m : FloorMove)
    (view : List FloorLeaf)
    (hDepth : maxEscalationDepth S view < m.revisionDepth) :
    revisionFloor S m view = false := by
  unfold revisionFloor
  cases hEsc : hasRole .escalation view with
  | false => rw [hEsc]
  | true =>
      rw [hEsc]
      have hNot : ¬ m.revisionDepth ≤ maxEscalationDepth S view :=
        Nat.not_le_of_lt hDepth
      rw [if_neg hNot]

theorem accept_has_no_extra_moveFloor
    (S : FloorSemantics)
    (scope : Scope)
    (depth : RevisionDepth)
    (view : List FloorLeaf) :
    moveFloor S ⟨.accept, scope, depth⟩ view = true := by
  rfl

theorem review_has_no_extra_moveFloor
    (S : FloorSemantics)
    (scope : Scope)
    (depth : RevisionDepth)
    (view : List FloorLeaf) :
    moveFloor S ⟨.review, scope, depth⟩ view = true := by
  rfl

end ResponsibilityTopology
