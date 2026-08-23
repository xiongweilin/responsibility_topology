# Lean 4 formalization

This directory contains the staged Lean 4 mechanization extracted from the V0.1.2.2 executable kernel and `branch_conservativity_v0_2.md`.

The mechanization is intentionally layered. It does not import the full transition system unless a theorem requires it.

Current contents:

- `Syntax.lean`: raw `Requirement` and `Branch` syntax, plus the minimal vocabulary needed to name atomic obligations;
- `Satisfaction.lean`: semantic `Env.atomSat`, extrinsic `Derives E β R`, and branch-local equivalence `SatEqOn`;
- `Conservativity.lean`: `derives_transport` and machine-checked Branch Conservativity (BC);
- `ExecutableSatisfaction.lean`: executable `SatOracle`, `firstSat`, left-biased `satisfy`, extensional candidate inclusion, No-New-Witness (NW), and executable Satisfaction Soundness (SS);
- `Replay.lean`: ordered/filter-preserving replay lemmas, branch-support inclusion, canonical support projection, Support-Preserving Replay (SPR), and exact Support Projection (SP);
- `Audit.lean`: `#print axioms` audit surface for the current formal theorems;
- `lake-manifest.json`: committed Lake workspace manifest used by CI.

Standing theorem boundary:

- `Env.atomSat : WarrantId → Atom → Prop` remains the declarative observation interface;
- `SatOracle` supplies a Boolean decision procedure together with a proof that it agrees with `Env.atomSat`;
- BC concerns locality of derivability for a fixed branch;
- NW uses extensional candidate inclusion only: retained IDs need only have occurred in the original sequence;
- SS connects successful executable search to the declarative `Derives` relation;
- replay additionally needs order preservation. The canonical projection is implemented as a list filter, hence an order-preserving sublist;
- arbitrary `Γ' <+ Γ` plus mere membership of support IDs is not sufficient for exact replay when duplicate warrant IDs are allowed. Therefore SPR is stated for ID-level filtering that keeps every support ID, which retains every occurrence of those IDs while preserving order;
- binding, context, profile, use, currentness, `INFER`, `TRANSPORT`, challenge/revision, context activation, kernel-floor checks, and concrete transition semantics remain outside this layer.

The exact projection is

```text
projectSupport Γ β = Γ.filter (fun w => decide (w ∈ β.support))
```

and SP states:

```text
satisfy O R Γ = some β
→ satisfy O R (projectSupport Γ β) = some β
```

Logical dependency shape:

```text
                    BC ✓

             executable satisfy
              /             \
            NW ✓             SS ✓
             |                \
             |                 \
       firstSat_replay          \
             |                   \
             +------> SPR --------+
                       |
             projectSupport
                       |
                       SP

                      KFL

BC + SS + SP + KFL + fixed ambient assumptions
                       |
                      RBC
```

This replay milestone does not introduce KFL, RBC, `INFER`, `TRANSPORT`, challenge/revision, context activation, or the concrete V0.1.2.2 transition kernel.
