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
- `CanonicalRead.lean`: shared canonical licensing read model, derived ambient/satisfaction/floor projections, derived `SatOracle`, partial-lookup hygiene, fallback irrelevance, and branch-level Projection Coherence;
- `Audit.lean`: `#print axioms` audit surface for the current formal theorems;
- `lake-manifest.json`: committed Lake workspace manifest used by CI.

Standing theorem boundary:

- `Env.atomSat : WarrantId → Atom → Prop` remains the abstract declarative observation interface;
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
- RBC remains the abstract composition theorem and still depends only on BC + KFL + `FixedAmbient`; SS and SP remain executable entitlement bridges rather than RBC premises;
- `LicensingRead` is the first shared canonical interpretation source for `AmbientView`, `Env`, `FloorEnv`, and `SatOracle`;
- `LicensingRead.requirement` is still an already-resolved exact requirement. `ProfileSnapshot.requirement_for` or any equivalent requirement-lookup implementation remains outside this milestone;
- canonical warrant lookup is partial (`WarrantId → Option CanonicalWarrant`), while abstract `Env` and `FloorEnv` remain total. `Canonical` and `WellFormedCandidates` therefore mark the concrete/refinement hygiene boundary without changing abstract NW;
- the derived canonical `SatOracle` totalizes unknown IDs to ordinary `false`. Python fail-fast behavior for unknown candidate IDs is not identified with that abstract behavior; later Python conformance must be guarded by `WellFormedCandidates`;
- `toFloorEnv` needs a fallback only because `FloorEnv.lookup` is total. `Derives (toEnv C) β R` proves every support ID is canonical, which makes the fallback unobservable on the derived branch and on projected entitlement;
- ambient binding-scope checks and atomic requirement-scope checks use `C.semantics.scopeLE`; `ProjectedEntitled` evaluates the floor with that same `C.semantics`, preventing scope-semantics drift in the canonical interpretation;
- `BranchProjectionCoherent C β` states branch-by-branch that satisfaction-relevant observations and floor observations arise from the same canonical warrant objects;
- provenance ancestry, parent lineage, concrete Binding/Profile/Context state machines, requirement lookup, context-currentness transitions, move args, warrant formation, `INFER`, `TRANSPORT`, challenge/revision transitions, Python source semantics, Python conformance, Q_open, and Q_close remain outside this layer.

The replay projection is

```text
projectSupport Γ β = Γ.filter (fun w => supportHas w β.support)
```

and SP states:

```text
satisfy O R Γ = some β
→ satisfy O R (projectSupport Γ β) = some β
```

The abstract floor projection is

```text
floorView F β = β.support.map F.lookup
```

where `F.lookup w` exposes only `(claim, role, scope)`.

`FloorEqOn F F' β` means the two floor environments agree on the warrant IDs in `β.support`. KFL states:

```text
FloorEqOn F F' β
→ (Safe S F β τ m ↔ Safe S F' β τ m)
```

The abstract entitlement judgment is

```text
Entitled S A E F β τ m :=
  Admissible A ∧
  Derives E β A.requirement ∧
  Safe S F β τ m
```

RBC is the abstract composition theorem:

```text
FixedAmbient A A' R
SatEqOn E E' β
FloorEqOn F F' β
→
(Entitled S A E F β τ m ↔ Entitled S A' E' F' β τ m)
```

Its logical dependency is deliberately only BC + KFL + FixedAmbient. SS and SP are consumed by separate executable corollaries.

The canonical interpretation layer is:

```text
                 LicensingRead
                /      |       \
               /       |        \
        toAmbient     toEnv     toFloorEnv
                        |           |
                     toOracle    floorView
                         \         /
                      Projection Coherence
```

Atomic satisfaction is read from one canonical warrant:

```text
C.warrant w = some cw
C.usable w = true
cw.formationContext = C.contextId
cw.formationProfileDigest = C.profileDigest
cw.claim = a.claim
cw.role = a.role
C.semantics.scopeLE a.scope cw.scope = true
```

and `canonicalAtomTest_true_iff` proves the executable Boolean test agrees with that proposition. Therefore the executable chain at the shared-read boundary is:

```text
LicensingRead
→ toOracle
→ satisfy
→ SS
→ Derives (toEnv C)
```

The partial-to-total floor boundary is discharged by:

```text
Derives (toEnv C) β R
→ every w ∈ β.support is Canonical C w
→ FloorEqOn (toFloorEnv C d₁) (toFloorEnv C d₂) β
→ floorView (toFloorEnv C d₁) β = floorView (toFloorEnv C d₂) β
```

Projection Coherence is:

```text
Derives (toEnv C) β R
→ BranchProjectionCoherent C β
```

The leaf case records one and the same canonical warrant `cw` for both the satisfaction conditions and the floor projection `(claim, role,scope)`.

Logical dependency shape:

```text
PR #5 — Abstract Entitlement Calculus

BC ──────────────┐
                 ├── RBC
KFL ─────────────┘
        +
   FixedAmbient

SS ──────────────► executable entitlement soundness
SP ──► SS ───────► support-only entitlement replay

PR #6 — Shared Canonical Read + Projection Coherence

LicensingRead ──► toAmbient
      │
      ├─────────► toEnv ──► toOracle
      │             │
      │             ├──► support canonical / well-formed support
      │             └──► BranchProjectionCoherent
      │
      └─────────► toFloorEnv
                     ▲
                     └── fallback irrelevant on derived support
```

This Projection Coherence milestone does not claim that Python V0.1.2.2 has been machine-proved correct. A later conformance layer should compare the Python reference implementation with this machine-checked projection model under explicit encoding and well-formedness conditions. The intended next claim is **Python V0.1.2.2 is conformance-tested against the machine-checked projection model**, not **Python V0.1.2.2 is machine-proved correct**.
