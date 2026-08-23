import ResponsibilityTopology.ContextCurrentness

namespace ResponsibilityTopology

/-!
Proof-carrying conformance certificates for PR #9.

This module does not implement another grounded-currentness solver.  It checks
finite certificates against the PR #8 `ActivationRead` semantics and proves
that successful checks entail either `Grounded` or `¬ Grounded`.
-/

inductive GroundedCertificate where
  | bootstrap
  | adopt
      (license : ActivationLicenseId)
      (issuer : ContextKey)
      (tail : GroundedCertificate)
  deriving Repr

/-- Declarative checker for a positive grounded-currentness certificate. -/
def CheckGroundedCertificate
    (R : ActivationRead)
    (c : ContextKey) : GroundedCertificate → Prop
  | .bootstrap =>
      R.seedActive c ∧
      R.activation c = some Activation.bootstrap
  | .adopt license issuer tail =>
      R.seedActive c ∧
      R.activation c = some (Activation.adopt license) ∧
      R.baseCurrent license ∧
      R.issuerContext license = some issuer ∧
      CheckGroundedCertificate R issuer tail

/-- Positive certificate soundness: a checked finite chain is a PR #8
`Grounded` derivation. -/
theorem groundedCertificate_sound
    {R : ActivationRead}
    {c : ContextKey}
    {cert : GroundedCertificate}
    (h : CheckGroundedCertificate R c cert) :
    Grounded R c := by
  induction cert generalizing c with
  | bootstrap =>
      exact Grounded.bootstrap h.1 h.2
  | adopt license issuer tail ih =>
      rcases h with ⟨seed, activation, baseCurrent, issuerContext, tailCheck⟩
      exact Grounded.adopt
        seed
        activation
        baseCurrent
        issuerContext
        (ih tailCheck)

inductive UngroundedCertificate where
  | seedInactive
  | missingActivation
  | baseNotCurrent (license : ActivationLicenseId)
  | missingIssuer (license : ActivationLicenseId)
  | issuerUngrounded
      (license : ActivationLicenseId)
      (issuer : ContextKey)
      (tail : UngroundedCertificate)
  deriving Repr

/-- Declarative checker for one finite obstruction to grounded currentness.
Because activation and issuer observations are functional, a failed point on
the unique predecessor chain is enough to refute `Grounded`. -/
def CheckUngroundedCertificate
    (R : ActivationRead)
    (c : ContextKey) : UngroundedCertificate → Prop
  | .seedInactive =>
      ¬ R.seedActive c
  | .missingActivation =>
      R.activation c = none
  | .baseNotCurrent license =>
      R.activation c = some (Activation.adopt license) ∧
      ¬ R.baseCurrent license
  | .missingIssuer license =>
      R.activation c = some (Activation.adopt license) ∧
      R.baseCurrent license ∧
      R.issuerContext license = none
  | .issuerUngrounded license issuer tail =>
      R.activation c = some (Activation.adopt license) ∧
      R.baseCurrent license ∧
      R.issuerContext license = some issuer ∧
      CheckUngroundedCertificate R issuer tail

private theorem adoptLicense_eq_of_activation_eq
    {R : ActivationRead}
    {c : ContextKey}
    {l₁ l₂ : ActivationLicenseId}
    (h₁ : R.activation c = some (Activation.adopt l₁))
    (h₂ : R.activation c = some (Activation.adopt l₂)) :
    l₁ = l₂ := by
  have hSome :
      some (Activation.adopt l₁) = some (Activation.adopt l₂) :=
    h₁.symm.trans h₂
  have hActivation : Activation.adopt l₁ = Activation.adopt l₂ :=
    Option.some.inj hSome
  exact Activation.adopt.inj hActivation

private theorem context_eq_of_issuer_eq
    {R : ActivationRead}
    {license : ActivationLicenseId}
    {c₁ c₂ : ContextKey}
    (h₁ : R.issuerContext license = some c₁)
    (h₂ : R.issuerContext license = some c₂) :
    c₁ = c₂ := by
  exact Option.some.inj (h₁.symm.trans h₂)

/-- Negative certificate soundness: a checked obstruction rules out every
possible PR #8 `Grounded` derivation for the context. -/
theorem ungroundedCertificate_sound
    {R : ActivationRead}
    {c : ContextKey}
    {cert : UngroundedCertificate}
    (h : CheckUngroundedCertificate R c cert) :
    ¬ Grounded R c := by
  induction cert generalizing c with
  | seedInactive =>
      intro grounded
      exact h (grounded_contractiveness grounded)
  | missingActivation =>
      intro grounded
      rcases grounded_fixedPoint_soundness grounded with bootstrap | adopted
      · have impossible : some Activation.bootstrap = none :=
          bootstrap.symm.trans h
        cases impossible
      · rcases adopted with ⟨license, issuer, activation, _, _, _⟩
        have impossible : some (Activation.adopt license) = none :=
          activation.symm.trans h
        cases impossible
  | baseNotCurrent license =>
      intro grounded
      rcases h with ⟨activation, notCurrent⟩
      rcases grounded_fixedPoint_soundness grounded with bootstrap | adopted
      · have impossible :
            Activation.bootstrap = Activation.adopt license :=
          Option.some.inj (bootstrap.symm.trans activation)
        cases impossible
      · rcases adopted with
          ⟨actualLicense, issuer, actualActivation, actualCurrent, _, _⟩
        have licenseEq : license = actualLicense :=
          adoptLicense_eq_of_activation_eq activation actualActivation
        subst actualLicense
        exact notCurrent actualCurrent
  | missingIssuer license =>
      intro grounded
      rcases h with ⟨activation, baseCurrent, missingIssuer⟩
      rcases grounded_fixedPoint_soundness grounded with bootstrap | adopted
      · have impossible :
            Activation.bootstrap = Activation.adopt license :=
          Option.some.inj (bootstrap.symm.trans activation)
        cases impossible
      · rcases adopted with
          ⟨actualLicense, issuer, actualActivation, _, actualIssuer, _⟩
        have licenseEq : license = actualLicense :=
          adoptLicense_eq_of_activation_eq activation actualActivation
        subst actualLicense
        have impossible : some issuer = none :=
          actualIssuer.symm.trans missingIssuer
        cases impossible
  | issuerUngrounded license issuer tail ih =>
      intro grounded
      rcases h with ⟨activation, baseCurrent, issuerContext, tailCheck⟩
      rcases grounded_fixedPoint_soundness grounded with bootstrap | adopted
      · have impossible :
            Activation.bootstrap = Activation.adopt license :=
          Option.some.inj (bootstrap.symm.trans activation)
        cases impossible
      · rcases adopted with
          ⟨actualLicense, actualIssuer, actualActivation, _, actualIssuerContext,
            issuerGrounded⟩
        have licenseEq : license = actualLicense :=
          adoptLicense_eq_of_activation_eq activation actualActivation
        subst actualLicense
        have issuerEq : issuer = actualIssuer :=
          context_eq_of_issuer_eq issuerContext actualIssuerContext
        subst actualIssuer
        exact (ih tailCheck) issuerGrounded

end ResponsibilityTopology
