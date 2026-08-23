# Lean 4 formalization

This directory contains the staged Lean 4 mechanization extracted from the V0.1.2.2 executable kernel and `branch_conservativity_v0_2.md`.

The mechanization is intentionally layered. It does not import the full transition system unless a theorem requires it.

Current contents:

- `Syntax.lean`: raw `Requirement` and `Branch` syntax, plus the minimal vocabulary needed to name atomic obligations;
- `Satisfaction.lean`: semantic `Env.atomSat`, extrinsic `Derives E β R`, and branch-local equivalence `SatEqOn`;
- `Conservativity.lean`: `derives_transport` and machine-checked Branch Conservativity (BC);
- `ExecutableSatisfaction.lean`: executable `SatOracle`, `firstSat`, left-biased `satisfy`, No-New-Witness (NW), and executable Satisfaction Soundness (SS);
- `Audit.lean`: `#print axioms` audit surface for the current formal theorems;
- `lake-manifest.json`: committed Lake workspace manifest used by CI.

Standing theorem boundary:

- `Env.atomSat : WarrantId → Atom → Prop` remains the declarative observation interface;
- `SatOracle` supplies a Boolean decision procedure together with a proof that it agrees with `Env.atomSat`;
- BC concerns locality of derivability for a fixed branch;
- NW concerns monotonicity of ordinary failure under candidate deletion;
- SS connects successful executable search to the existing declarative `Derives` relation;
- binding, context, profile, use, currentness, `INFER`, `TRANSPORT`, challenge/revision, context activation, kernel-floor checks, and concrete transition semantics remain outside this layer.

Candidate deletion in NW is deliberately represented extensionally by `CandidateSubset`: every retained warrant was already present in the original candidate list. Order preservation is not required to prove failure monotonicity; replay will introduce the stronger structure it needs in a later milestone.

Logical dependency shape:

```text
                    BC

             executable satisfy
              /             \
            NW               SS
             |
            SPR
             |
             SP

            KFL

BC + SS + SP + KFL + fixed ambient assumptions
             |
            RBC
```

The next milestone after NW/SS is green is replay only: `firstSat_replay`, support-preserving replay (SPR), canonical support projection, and SP. It should not introduce KFL or the concrete kernel.
