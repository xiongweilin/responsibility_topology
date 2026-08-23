import ResponsibilityTopology.CanonicalRead

namespace ResponsibilityTopology

/-!
Grounded adopted-context currentness.

This layer closes one previously abstract ambient dependency: why a context may
still count as currently ACTIVE.  It deliberately does not formalize the full
Python `check_license_current` function.  Instead `baseCurrent` is an external
judgment containing every license-currentness premise except currentness of the
license's issuing context.

The semantic choice is intentionally grounded rather than coinductive: an
adopted context is current only when it has a finite chain of base-current Adopt
licenses terminating at an explicit bootstrap activation boundary.  Cyclic
activation dependencies therefore cannot support themselves.
-/

abbrev ActivationLicenseId := String

structure ContextKey where
  binding : String
  context : String
  use : String
  deriving Repr, DecidableEq

inductive Activation where
  | bootstrap
  | adopt (license : ActivationLicenseId)
  deriving Repr, DecidableEq

/-- Finite-state observations needed by the context-currentness layer.

`seedActive` is the pre-refresh active-state boundary.  `baseCurrent L` means
that all currentness conditions for `L` other than issuing-context activity are
already established externally.  `activation` is partial so malformed/missing
activation provenance does not become current by default. -/
structure ActivationRead where
  seedActive : ContextKey → Prop
  activation : ContextKey → Option Activation
  issuerContext : ActivationLicenseId → Option ContextKey
  baseCurrent : ActivationLicenseId → Prop

/-- Grounded currentness.  Every adopted step requires a base-current activation
license and recursively current issuing context; the derivation must terminate
at an explicit bootstrap boundary. -/
inductive Grounded (R : ActivationRead) : ContextKey → Prop where
  | bootstrap {c : ContextKey}
      (seed : R.seedActive c)
      (activation : R.activation c = some Activation.bootstrap) :
      Grounded R c
  | adopt {c issuer : ContextKey} {license : ActivationLicenseId}
      (seed : R.seedActive c)
      (activation : R.activation c = some (Activation.adopt license))
      (baseCurrent : R.baseCurrent license)
      (issuerContext : R.issuerContext license = some issuer)
      (issuerGrounded : Grounded R issuer) :
      Grounded R c

/-- Contractiveness: refresh may retain a seed-active context or remove it, but
cannot synthesize activity outside the seed active state. -/
theorem grounded_contractiveness
    {R : ActivationRead} {c : ContextKey}
    (h : Grounded R c) :
    R.seedActive c := by
  cases h with
  | bootstrap seed _ => exact seed
  | adopt seed _ _ _ _ => exact seed

/-- Recursive K-Law B: every retained context is either an explicit bootstrap,
or is activated by a base-current Adopt license whose issuing context is itself
retained by the same grounded currentness relation. -/
theorem grounded_fixedPoint_soundness
    {R : ActivationRead} {c : ContextKey}
    (h : Grounded R c) :
    R.activation c = some Activation.bootstrap ∨
      ∃ license issuer,
        R.activation c = some (Activation.adopt license) ∧
        R.baseCurrent license ∧
        R.issuerContext license = some issuer ∧
        Grounded R issuer := by
  cases h with
  | bootstrap _ activation =>
      exact Or.inl activation
  | adopt _ activation baseCurrent issuerContext issuerGrounded =>
      exact Or.inr ⟨_, _, activation, baseCurrent, issuerContext, issuerGrounded⟩

/-- A semantic refresh replaces the seed-active predicate by its grounded
closure while preserving activation topology and base-currentness judgments. -/
def refreshed (R : ActivationRead) : ActivationRead :=
  { R with seedActive := Grounded R }

/-- Idempotence: once the active predicate has been replaced by grounded
currentness, applying the same currentness closure again changes nothing. -/
theorem grounded_refresh_idempotence
    (R : ActivationRead) (c : ContextKey) :
    Grounded (refreshed R) c ↔ Grounded R c := by
  constructor
  · intro h
    have hSeed := grounded_contractiveness h
    change Grounded R c at hSeed
    exact hSeed
  · intro h
    induction h with
    | bootstrap seed activation =>
        apply Grounded.bootstrap
        · exact Grounded.bootstrap seed activation
        · exact activation
    | adopt seed activation baseCurrent issuerContext issuerGrounded ih =>
        apply Grounded.adopt
        · exact Grounded.adopt seed activation baseCurrent issuerContext issuerGrounded
        · exact activation
        · exact baseCurrent
        · exact issuerContext
        · exact ih

/-- Change only the externally supplied base-currentness judgment. -/
def withBaseCurrent
    (R : ActivationRead)
    (baseCurrent : ActivationLicenseId → Prop) : ActivationRead :=
  { R with baseCurrent := baseCurrent }

/-- Additional invalidation is monotone: if every license current under the
stricter judgment `B₂` was already current under `B₁`, then every context
retained under `B₂` was already retained under `B₁`. -/
theorem grounded_invalidation_monotonicity
    (R : ActivationRead)
    (B₁ B₂ : ActivationLicenseId → Prop)
    (hMono : ∀ license, B₂ license → B₁ license)
    {c : ContextKey}
    (h : Grounded (withBaseCurrent R B₂) c) :
    Grounded (withBaseCurrent R B₁) c := by
  induction h with
  | bootstrap seed activation =>
      exact Grounded.bootstrap seed activation
  | adopt seed activation baseCurrent issuerContext issuerGrounded ih =>
      exact Grounded.adopt seed activation (hMono _ baseCurrent) issuerContext ih

/-- A finite, currently valid activation chain.  The inductive shape is the
transitive dependency closure itself; unlike a greatest-fixed-point reading it
cannot contain a purely self-supporting cycle with no bootstrap endpoint. -/
inductive CurrentActivationChain
    (R : ActivationRead) : ContextKey → ContextKey → Prop where
  | bootstrap {c : ContextKey}
      (activation : R.activation c = some Activation.bootstrap) :
      CurrentActivationChain R c c
  | adopt {c issuer root : ContextKey} {license : ActivationLicenseId}
      (activation : R.activation c = some (Activation.adopt license))
      (baseCurrent : R.baseCurrent license)
      (issuerContext : R.issuerContext license = some issuer)
      (tail : CurrentActivationChain R issuer root) :
      CurrentActivationChain R c root

/-- Transitive dependency closure / groundedness theorem: every retained context
has a finite currently valid activation chain ending at an explicit bootstrap
boundary. -/
theorem grounded_has_bootstrap_chain
    {R : ActivationRead} {c : ContextKey}
    (h : Grounded R c) :
    ∃ root,
      CurrentActivationChain R c root ∧
      R.activation root = some Activation.bootstrap := by
  induction h with
  | bootstrap _ activation =>
      exact ⟨_, CurrentActivationChain.bootstrap activation, activation⟩
  | adopt _ activation baseCurrent issuerContext issuerGrounded ih =>
      rcases ih with ⟨root, tail, rootBootstrap⟩
      exact ⟨
        root,
        CurrentActivationChain.adopt activation baseCurrent issuerContext tail,
        rootBootstrap
      ⟩

/-- Purely self-supporting activation worlds cannot produce current contexts. If
there is no explicit bootstrap activation boundary anywhere, no grounded
currentness derivation exists. -/
theorem no_grounded_without_bootstrap
    {R : ActivationRead}
    (hNoBootstrap : ∀ c, R.activation c ≠ some Activation.bootstrap)
    {c : ContextKey} :
    ¬ Grounded R c := by
  intro h
  rcases grounded_has_bootstrap_chain h with
    ⟨root, _chain, rootBootstrap⟩
  exact hNoBootstrap root rootBootstrap

/-- Dynamic wrapper around the existing static canonical licensing read.  The
binding id is supplied here because `LicensingRead` intentionally did not need
one for the PR #6 static projection. -/
structure DynamicLicensingRead where
  static : LicensingRead
  bindingId : String

/-- Exact dynamic key corresponding to the static read's context/use. -/
def DynamicLicensingRead.contextKey (D : DynamicLicensingRead) : ContextKey :=
  ⟨D.bindingId, D.static.contextId, D.static.use⟩

/-- Ambient projection with context activity no longer supplied as an arbitrary
Boolean: it is the grounded currentness judgment for the exact dynamic key.
All other ambient observations remain the PR #6 canonical projections. -/
def toGroundedAmbient
    (D : DynamicLicensingRead)
    (R : ActivationRead)
    (m : FloorMove) : AmbientView :=
  { toAmbient D.static m with
    contextActive := Grounded R D.contextKey }

/-- Ambient dependency closure bridge.  This is the precise replacement for the
previous unconstrained `contextActive` input at the dynamic interpretation
boundary. -/
theorem groundedAmbient_contextActive_iff
    (D : DynamicLicensingRead)
    (R : ActivationRead)
    (m : FloorMove) :
    (toGroundedAmbient D R m).contextActive ↔ Grounded R D.contextKey := by
  rfl

end ResponsibilityTopology
