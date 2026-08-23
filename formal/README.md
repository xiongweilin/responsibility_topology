# Formalization milestone: Branch Conservativity foundation

This directory is the first Lean 4 mechanization extracted from the V0.1.2.2 executable kernel and `branch_conservativity_v0_2.md`.

The first milestone is intentionally narrow. It mechanizes the raw proof objects and Branch Conservativity without importing the full transition system.

Current contents:

- `Syntax.lean`: raw `Requirement` and `Branch` syntax, plus the minimal vocabulary needed to name atomic obligations;
- `Satisfaction.lean`: a minimal `Env.atomSat` projection, extrinsic `Derives E β R`, and branch-local environment equivalence `SatEqOn`;
- `Conservativity.lean`: one-way derivation transport and `branchConservativity`;
- `Audit.lean`: `#print axioms` audit surface for the BC declarations;
- `lake-manifest.json`: committed Lake workspace manifest used by CI.

The standing architecture is preserved:

- the full V0.1.2.2 state machine remains outside this first theorem model;
- reachability is an ambient condition, not a source of branch-local justification;
- `Branch` stays raw/extrinsic rather than becoming a dependent `Branch R` type;
- no `INFER`, `TRANSPORT`, `Challenge`, `Revision`, or `ContextActivation` semantics are introduced here.

The first milestone is complete only when CI has actually run `lake build` against the committed manifest and the proof audit contains no placeholders.

Next proof-engineering work after BC is green:

- define an executable `SatOracle` / `satisfy` layer without replacing semantic `Env.atomSat : ... → Prop`;
- prove `NW` and `SS` in parallel;
- prove the stronger `SPR` support-preserving replay lemma;
- derive exact `SP` as a corollary;
- add `floorView` / `safe`, prove `KFL`, and compose `RBC`.

Logical dependency shape:

```text
             BC

satisfy
  ├── NW ──> SPR ──> SP
  └── SS

KFL

BC + SS + SP + KFL + fixed ambient assumptions ──> RBC
```
