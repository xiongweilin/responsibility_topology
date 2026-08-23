# Lean 4 formalization

This directory contains the staged Lean 4 mechanization extracted from the V0.1.2.2 executable kernel and `branch_conservativity_v0_2.md`.

The mechanization is intentionally layered. It does not import the full transition system unless a theorem requires it.

Current contents:

- `Syntax.lean`: raw `Requirement` and `Branch` syntax, plus the minimal vocabulary needed to name atomic obligations;
- `Satisfaction.lean`: semantic `Env.atomSat`, extrinsic `Derives E β R`, and branch-local equivalence `SatEqOn`;
- `Conservativity.lean`: `derives_transport` and machine-checked Branch Conservativity (BC);
- `ExecutableSatisfaction.lean`: executable `SatOracle`, `firstSat`, left-biased `satisfy`, extensional candidate inclusion, No-New-Witness (NW), and executable Satisfaction Soundness (SS);
- `Replay.lean`: ordered/filter-preserving replay lemmas, branch-support inclusion, canonical support projection, Support-Preserving Replay (SPR), and exact Support Projection (SP);
- `KernelFloor.lean`: abstract branch-local floor observation, the exact current V0.1.2.2 floor clauses, and Kernel-Floor Locality (KFL);
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
- `projectSupport` uses the local pure Boolean predicate `supportHas`; `supportHas_exact` proves `supportHas w xs = true ↔ w ∈ xs`. This avoids importing the proof dependencies of Lean 4.19's generic decidable list-membership instance into the SP proof term;
- KFL does not define a full `History` or full `Move`. Its observation surface is exactly `FloorLeaf = (claim, role, scope)`, a fixed `LicenseType`, and `FloorMove = (kind, scope, revisionDepth)`;
- `FloorSemantics.scopeLE` and `FloorSemantics.escalationDepth` abstract the existing Python scope containment and `EscalationDepth(n)` parsing without pulling finite-set normalization or string parsing into KFL;
- provenance ancestry, parent lineage, profile/context/currentness, move args, warrant formation, `INFER`, `TRANSPORT`, challenge/revision transitions, context activation, and concrete history refinement remain outside KFL;
- KFL is a locality theorem about the existing floor. It is explicitly not `KernelFloorAdequacy`.

The replay projection is

```text
projectSupport Γ β = Γ.filter (fun w => supportHas w β.support)
```

and SP states:

```text
satisfy O R Γ = some β
→ satisfy O R (projectSupport Γ β) = some β
```

The floor projection is

```text
floorView F β = β.support.map F.lookup
```

where `F.lookup w` exposes only `(claim, role, scope)`.

The abstract current floor preserves the V0.1.2.2 clauses:

```text
NORMATIVE                         -> false
all leaves cover move.scope       -> required
ACTION license or Act move        -> AUTHORIZATION required
Share                             -> SELECTION required
Suspect/Reopen/Adopt              -> ESCALATION required
revision move                     -> max escalation depth >= move depth
Adopt                             -> SELECTION additionally required
ResolveStatus                     -> SELECTION or AUTHORIZATION required
Accept/Review                     -> no additional move-specific floor
```

There is deliberately no universal `PROVENANCE` floor requirement: provenance guards remain a warrant-formation concern in the current kernel.

`FloorEqOn F F' β` means the two floor environments agree on the warrant IDs in `β.support`. KFL states:

```text
FloorEqOn F F' β
→ (Safe S F β τ m ↔ Safe S F' β τ m)
```

with `S`, `τ`, `m`, and `β` fixed.

Logical dependency shape:

```text
                    BC ✓

             executable satisfy
              /             \
            NW ✓             SS ✓
             |
       firstSat_replay
             |
             +------> SPR
                       |
       satisfy_support_subset
                       |
              projectSupport
                       |
                       SP ✓

       FloorLeaf / FloorEnv / FloorMove
                       |
                  floorView
                       |
                 safeFromView
                       |
                  FloorEqOn
                       |
                      KFL

BC + SS + SP + KFL + fixed ambient assumptions
                       |
                      RBC
```

This KFL milestone does not introduce RBC, concrete-history refinement, profile/context/currentness semantics, `INFER`, `TRANSPORT`, challenge/revision transitions, context activation, or a claim that the present floor is substantively adequate.
