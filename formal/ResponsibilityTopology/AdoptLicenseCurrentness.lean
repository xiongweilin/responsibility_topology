import ResponsibilityTopology.Reachability

namespace ResponsibilityTopology

/-!
Canonical Adopt-license currentness semantics.

This module is intentionally pure: it does not add reachable license-recording or
context-activation transitions.  It defines the enriched semantic record that the
reachable kernel will store in a later stage and replaces the abstract
`ActivationRead.baseCurrent` component with a narrow state-backed predicate over
binding/profile/use coordinates, review status, move scope, and support usability.

Issuer-context currentness remains separate and is supplied by `Grounded` over the
same Adopt-license read.  No entitlement-backed issuance, full licensing assembly,
Python refinement, challenge/revalidation, or temporal-persistence theorem is
introduced here.
-/

/-- Narrow historical record needed by Adopt currentness.  This is not the full
Python `LicenseRecord`: agents, license category, resolved requirement, branch
syntax, kernel identifier, and issuance proof are intentionally absent. -/
structure CanonicalAdoptLicense where
  issuer : ContextKey
  target : ContextKey
  profileDigest : String
  moveScope : Scope
  support : List WarrantId
  deriving Repr, DecidableEq

/-- Pure semantic read used before the enriched license record is wired into the
reachable `CanonicalState.license` slot.  The ordinary canonical state supplies
all mutable/current observations; `license` supplies the enriched immutable Adopt
records that #39 will make reachable. -/
structure AdoptLicenseRead where
  state : CanonicalState
  license : ActivationLicenseId → Option CanonicalAdoptLicense

/-- All Adopt-license currentness conditions represented by the current Lean
state except currentness of the issuing context itself.

The issuer and target must be canonical coordinates under one binding/use; the
recorded profile digest must match that binding; review must not be required; the
move scope must remain within the binding scope; and every recorded support
warrant must still resolve canonically and be usable at the issuer coordinate.

Canonical binding presence is the current reachable-kernel representation here:
there is not yet a separate reachable binding-deactivation lifecycle. -/
def AdoptLicenseBaseCurrent
    (S : CanonicalState)
    (licenseId : ActivationLicenseId)
    (L : CanonicalAdoptLicense) : Prop :=
  ∃ binding issuerContext targetContext,
    S.binding L.issuer.binding = some binding ∧
    S.context L.issuer.context = some issuerContext ∧
    S.context L.target.context = some targetContext ∧
    L.target.binding = L.issuer.binding ∧
    L.target.use = L.issuer.use ∧
    binding.profileDigest = L.profileDigest ∧
    binding.use = L.issuer.use ∧
    ¬ S.reviewRequired licenseId ∧
    ScopeNarrowerOrEqual L.moveScope binding.scope ∧
    ∀ warrantId,
      warrantId ∈ L.support →
      ∃ warrant,
        S.warrant warrantId = some warrant ∧
        Usable S
          ⟨L.profileDigest, L.issuer.context, L.issuer.use, warrantId⟩

/-- The state-backed base-currentness predicate lifted to license identifiers in
one enriched Adopt read. -/
def AdoptLicenseRead.baseCurrent
    (R : AdoptLicenseRead)
    (licenseId : ActivationLicenseId) : Prop :=
  ∃ L,
    R.license licenseId = some L ∧
    AdoptLicenseBaseCurrent R.state licenseId L

/-- Activation projection whose recursive issuer edge and base-currentness are
both sourced from the same enriched Adopt-license lookup. -/
def AdoptLicenseRead.toActivationRead (R : AdoptLicenseRead) : ActivationRead where
  seedActive := R.state.activeContext
  activation := R.state.activationProvenance
  issuerContext := fun licenseId =>
    match R.license licenseId with
    | none => none
    | some L => some L.issuer
  baseCurrent := R.baseCurrent

/-- Full currentness of one exact Adopt-license record: the non-recursive
state-backed conditions hold, and the issuing context is grounded through the
same activation/license read. -/
def AdoptLicenseCurrent
    (R : AdoptLicenseRead)
    (licenseId : ActivationLicenseId) : Prop :=
  ∃ L,
    R.license licenseId = some L ∧
    AdoptLicenseBaseCurrent R.state licenseId L ∧
    Grounded R.toActivationRead L.issuer

/-- Exact decomposition advertised by this stage: issuer grounding is not folded
into `AdoptLicenseBaseCurrent`. -/
theorem adoptLicenseCurrent_iff
    (R : AdoptLicenseRead)
    (licenseId : ActivationLicenseId) :
    AdoptLicenseCurrent R licenseId ↔
      ∃ L,
        R.license licenseId = some L ∧
        AdoptLicenseBaseCurrent R.state licenseId L ∧
        Grounded R.toActivationRead L.issuer := by
  rfl

/-- The `ActivationRead.baseCurrent` observation is exactly the enriched
state-backed Adopt predicate, not an independent oracle. -/
theorem adoptActivationRead_baseCurrent_iff
    (R : AdoptLicenseRead)
    (licenseId : ActivationLicenseId) :
    R.toActivationRead.baseCurrent licenseId ↔
      ∃ L,
        R.license licenseId = some L ∧
        AdoptLicenseBaseCurrent R.state licenseId L := by
  rfl

/-- Exact issuer projection from the enriched canonical record. -/
theorem adoptActivationRead_issuer_exact
    (R : AdoptLicenseRead)
    {licenseId : ActivationLicenseId}
    {L : CanonicalAdoptLicense}
    (hLicense : R.license licenseId = some L) :
    R.toActivationRead.issuerContext licenseId = some L.issuer := by
  simp [AdoptLicenseRead.toActivationRead, hLicense]

/-- Base currentness exposes exact binding/profile/use coordinate agreement. -/
theorem adoptLicenseBaseCurrent_coordinates
    {S : CanonicalState}
    {licenseId : ActivationLicenseId}
    {L : CanonicalAdoptLicense}
    (hCurrent : AdoptLicenseBaseCurrent S licenseId L) :
    ∃ binding,
      S.binding L.issuer.binding = some binding ∧
      L.target.binding = L.issuer.binding ∧
      L.target.use = L.issuer.use ∧
      binding.profileDigest = L.profileDigest ∧
      binding.use = L.issuer.use := by
  rcases hCurrent with
    ⟨binding, issuerContext, targetContext, hBinding, hIssuerContext,
      hTargetContext, hTargetBinding, hTargetUse, hProfile, hUse,
      hReview, hScope, hSupport⟩
  exact ⟨binding, hBinding, hTargetBinding, hTargetUse, hProfile, hUse⟩

/-- Base currentness keeps review and scope checks outside recursive issuer
currentness. -/
theorem adoptLicenseBaseCurrent_review_scope
    {S : CanonicalState}
    {licenseId : ActivationLicenseId}
    {L : CanonicalAdoptLicense}
    (hCurrent : AdoptLicenseBaseCurrent S licenseId L) :
    ¬ S.reviewRequired licenseId ∧
      ∃ binding,
        S.binding L.issuer.binding = some binding ∧
        ScopeNarrowerOrEqual L.moveScope binding.scope := by
  rcases hCurrent with
    ⟨binding, issuerContext, targetContext, hBinding, hIssuerContext,
      hTargetContext, hTargetBinding, hTargetUse, hProfile, hUse,
      hReview, hScope, hSupport⟩
  exact ⟨hReview, binding, hBinding, hScope⟩

/-- Every support identity recorded by a base-current Adopt license is an exact
canonical historical referent and is currently usable at the issuer coordinate. -/
theorem adoptLicenseBaseCurrent_support_usable
    {S : CanonicalState}
    {licenseId : ActivationLicenseId}
    {L : CanonicalAdoptLicense}
    (hCurrent : AdoptLicenseBaseCurrent S licenseId L)
    {warrantId : WarrantId}
    (hSupport : warrantId ∈ L.support) :
    ∃ warrant,
      S.warrant warrantId = some warrant ∧
      Usable S
        ⟨L.profileDigest, L.issuer.context, L.issuer.use, warrantId⟩ := by
  rcases hCurrent with
    ⟨binding, issuerContext, targetContext, hBinding, hIssuerContext,
      hTargetContext, hTargetBinding, hTargetUse, hProfile, hUse,
      hReview, hScope, hAllSupport⟩
  exact hAllSupport warrantId hSupport

/-- Full currentness always exposes the separately grounded issuing context. -/
theorem adoptLicenseCurrent_issuer_grounded
    {R : AdoptLicenseRead}
    {licenseId : ActivationLicenseId}
    (hCurrent : AdoptLicenseCurrent R licenseId) :
    ∃ L,
      R.license licenseId = some L ∧
      AdoptLicenseBaseCurrent R.state licenseId L ∧
      Grounded R.toActivationRead L.issuer :=
  hCurrent

end ResponsibilityTopology
