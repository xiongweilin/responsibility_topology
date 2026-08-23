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
- `Entitlement.lean`: minimal ambient projection, the abstract entitlement judgment, Relative Branch Conservativity (RBC), executable entitlement soundness, and support-only entitlement replay;
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
- `projectSupport` uses the local pure Boolean predicate `supportHas`; `supportHas_exact` proves `supportHas w xs = true ↔ w ∈ xs`;
- KFL does not define a full `History` or full `Move`. Its observation surface is exactly `FloorLeaf = (claim, role, scope)`, a fixed `LicenseType`, and `FloorMove = (kind, scope, revisionDepth)`;
- `FloorSemantics.scopeLE` and `FloorSemantics.escalationDepth` abstract the existing Python scope containment and `EscalationDepth(n)` parsing without pulling finite-set normalization or string parsing into KFL;
- KFL is a locality theorem about the existing floor. It is explicitly not `KernelFloorAdequacy`;
- `AmbientView` projects only `bindingActive`, `useMatches`, `contextActive`, `moveWithinBindingScope`, and an already-resolved exact `requirement`;
- `FixedAmbient A A' R` does not formalize profile lookup. It assumes both ambient views are admissible and both exact lookups have already resolved to the same `R`;
- `Entitled` is the abstract judgment `Admissible ∧ Derives ∧ Safe`;
- `Env` and `FloorEnv` remain independent abstract projections. The future theorem that both arise coherently from the same concrete canonical warrant/history is called **Projection Coherence** and is not proved here;
- provenance ancestry, parent lineage, concrete Binding/Profile/Context implementations, requirement lookup, currentness, move args, warrant formation, `INFER`, `TRANSPORT`, challenge/revision transitions, context activation, Python refinement, Q_open, and Q_close remain outside this layer.

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

`FloorEqOn F F' β` means the two floor environments agree on the warrant IDs in `β.support`. KFL states:

```text
FloorEqOn F F' β
→ (Safe S F β τ m ↔ Safe S F' β τ m)
```

The entitlement judgment is

```text
Entitled S A E F β τ m :=
  Admissible A ∧
  Derives E β A.requirement ∧
  Safe S F β τ m
```

RBC is the composition theorem:

```text
FixedAmbient A A' R
SatEqOn E E' β
FloorEqOn F F' β
→
(Entitled S A E F β τ m ↔ Entitled S A' E' F' β τ m)
```

Its logical dependency is deliberately only BC + KFL + FixedAmbient. SS and SP are consumed by separate executable corollaries:

```text
satisfy O R Γ = some β
+ Admissible
+ exact requirement identity
+ Safe
→ Entitled
```

and

```text
satisfy O R Γ = some β
→ satisfy O R (projectSupport Γ β) = some β
→ Derives E β R
→ Entitled
```

Logical dependency shape:

```text
BC ──────────────┐
                 ├── RBC
KFL ─────────────┘
        +
   FixedAmbient

SS ──────────────► executable entitlement soundness

SP ──► SS ───────► support-only entitlement replay
```

This entitlement/RBC milestone does not introduce concrete `History`, Binding/Profile/Context implementations, requirement lookup, currentness, Projection Coherence, Python refinement, Q_open, or Q_close.
