# Formalization milestone: Branch Conservativity foundation

This directory is the first Lean 4 mechanization extracted from the V0.1.2.2 executable kernel and `branch_conservativity_v0_2.md`.

The first milestone is intentionally narrow. It mechanizes the raw proof objects and Branch Conservativity without importing the full transition system.

Current contents:

- `Syntax.lean`: raw `Requirement` and `Branch` syntax, plus the minimal vocabulary needed to name atomic obligations;
- `Satisfaction.lean`: a minimal `Env.atomSat` projection, extrinsic `Derives E β R`, and branch-local environment equivalence `SatEqOn`;
- `Conservativity.lean`: one-way derivation transport and machine-checked `branchConservativity`.

The standing architecture is preserved:

- the full V0.1.2.2 state machine remains outside this first theorem model;
- reachability is an ambient condition, not a source of branch-local justification;
- `Branch` stays raw/extrinsic rather than becoming a dependent `Branch R` type;
- no `INFER`, `TRANSPORT`, `Challenge`, `Revision`, or `ContextActivation` semantics are introduced here.

Next proof-engineering step:

1. define executable `satisfy` over canonical candidate lists;
2. prove `NW` (no-new-witness under deletion);
3. prove the stronger `SPR` support-preserving replay lemma;
4. derive exact `SP` as a corollary;
5. connect executable satisfaction to `Derives` via `SS`;
6. add `floorView` / `safe`, prove `KFL`, and compose `RBC`.

The target dependency order remains:

`NW -> BC -> SS -> SPR -> SP -> KFL -> RBC`.
