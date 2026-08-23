import ResponsibilityTopology.Conservativity
import ResponsibilityTopology.ExecutableSatisfaction
import ResponsibilityTopology.Replay
import ResponsibilityTopology.KernelFloor

namespace ResponsibilityTopology

/-!
Entitlement-level composition for the current abstract calculus.

This layer deliberately projects ambient assumptions instead of implementing
Binding/Profile/Context or requirement lookup. The exact requirement has already
been resolved into `AmbientView.requirement`.

`Env` and `FloorEnv` remain independent abstract projections. This PR does not
prove that their observations arise from the same concrete canonical warrant;
that later refinement obligation is called Projection Coherence.
-/

/-- Minimal ambient projection retained by the current relative theorem. -/
structure AmbientView where
  bindingActive : Prop
  useMatches : Prop
  contextActive : Prop
  moveWithinBindingScope : Prop
  requirement : Requirement

/-- Ambient admissibility is intentionally explicit rather than collapsed into
one opaque proposition. -/
def Admissible (A : AmbientView) : Prop :=
  A.bindingActive ∧
  A.useMatches ∧
  A.contextActive ∧
  A.moveWithinBindingScope

/-- Fixed ambient boundary for RBC: both sides are admissible, and exact
requirement lookup has already resolved to the same requirement `R`. -/
def FixedAmbient (A A' : AmbientView) (R : Requirement) : Prop :=
  Admissible A ∧
  Admissible A' ∧
  A.requirement = R ∧
  A'.requirement = R

/-- Abstract entitlement judgment: admissible ambient context, discharged exact
requirement, and current kernel-floor safety. -/
def Entitled
    (S : FloorSemantics)
    (A : AmbientView)
    (E : Env)
    (F : FloorEnv)
    (β : Branch)
    (τ : LicenseType)
    (m : FloorMove) : Prop :=
  Admissible A ∧
  Derives E β A.requirement ∧
  Safe S F β τ m

/-- RBC — Relative Branch Conservativity.

For a fixed branch, semantics, license type, and move, entitlement is invariant
when:

* both ambient views remain admissible;
* both exact requirement lookups resolve to the same `R`;
* the branch-local declarative observations agree (`SatEqOn`); and
* the branch-local floor observations agree (`FloorEqOn`).

The logical core depends on BC + KFL + FixedAmbient. SS and SP are not premises
of this equivalence theorem; they support the executable corollaries below. -/
theorem relativeBranchConservativity
    (S : FloorSemantics)
    (A A' : AmbientView)
    (E E' : Env)
    (F F' : FloorEnv)
    (β : Branch)
    (τ : LicenseType)
    (m : FloorMove)
    (R : Requirement)
    (hAmbient : FixedAmbient A A' R)
    (hSat : SatEqOn E E' β)
    (hFloor : FloorEqOn F F' β) :
    Entitled S A E F β τ m ↔
    Entitled S A' E' F' β τ m := by
  rcases hAmbient with ⟨hAdm, hAdm', hReq, hReq'⟩
  have hBC : Derives E β R ↔ Derives E' β R :=
    branchConservativity hSat
  have hKFL : Safe S F β τ m ↔ Safe S F' β τ m :=
    kernelFloorLocality S F F' β τ m hFloor
  constructor
  · intro hEnt
    rcases hEnt with ⟨_hAdmLeft, hDerives, hSafe⟩
    have hDerivesR : Derives E β R := by
      rw [← hReq]
      exact hDerives
    have hDerivesR' : Derives E' β R := hBC.mp hDerivesR
    have hDerives' : Derives E' β A'.requirement := by
      rw [hReq']
      exact hDerivesR'
    exact ⟨hAdm', hDerives', hKFL.mp hSafe⟩
  · intro hEnt
    rcases hEnt with ⟨_hAdmRight, hDerives, hSafe⟩
    have hDerivesR' : Derives E' β R := by
      rw [← hReq']
      exact hDerives
    have hDerivesR : Derives E β R := hBC.mpr hDerivesR'
    have hDerives' : Derives E β A.requirement := by
      rw [hReq]
      exact hDerivesR
    exact ⟨hAdm, hDerives', hKFL.mpr hSafe⟩

/-- Executable entitlement soundness.
A successful executable requirement discharge, together with ambient
admissibility and floor safety, yields the declarative entitlement judgment. -/
theorem entitled_of_satisfy
    {E : Env}
    (O : SatOracle E)
    (S : FloorSemantics)
    (A : AmbientView)
    (F : FloorEnv)
    (τ : LicenseType)
    (m : FloorMove)
    {R : Requirement}
    {Γ : List WarrantId}
    {β : Branch}
    (hAdm : Admissible A)
    (hReq : A.requirement = R)
    (hRun : satisfy O R Γ = some β)
    (hSafe : Safe S F β τ m) :
    Entitled S A E F β τ m := by
  refine ⟨hAdm, ?_, hSafe⟩
  rw [hReq]
  exact satisfySound O hRun

/-- SP bridge: the recorded branch has an executable support-only replay witness. -/
theorem entitlementSupportReplay
    {E : Env}
    (O : SatOracle E)
    {R : Requirement}
    {Γ : List WarrantId}
    {β : Branch}
    (hRun : satisfy O R Γ = some β) :
    satisfy O R (projectSupport Γ β) = some β :=
  supportProjection O hRun

/-- Support-only executable entitlement soundness.
The derivation component is reconstructed specifically from the canonical
support projection: SP first replays the same branch, then SS lifts that replay
to `Derives`. Logically this has the same entitlement conclusion as
`entitled_of_satisfy`; operationally it records the support-only replay witness
needed by later proof-bundle/certificate work. -/
theorem entitled_from_projected_support
    {E : Env}
    (O : SatOracle E)
    (S : FloorSemantics)
    (A : AmbientView)
    (F : FloorEnv)
    (τ : LicenseType)
    (m : FloorMove)
    {R : Requirement}
    {Γ : List WarrantId}
    {β : Branch}
    (hAdm : Admissible A)
    (hReq : A.requirement = R)
    (hRun : satisfy O R Γ = some β)
    (hSafe : Safe S F β τ m) :
    Entitled S A E F β τ m := by
  have hReplay : satisfy O R (projectSupport Γ β) = some β :=
    entitlementSupportReplay O hRun
  refine ⟨hAdm, ?_, hSafe⟩
  rw [hReq]
  exact satisfySound O hReplay

end ResponsibilityTopology
