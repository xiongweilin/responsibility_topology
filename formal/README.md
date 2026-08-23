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
- `PythonConformance.lean`: conformance-only executable adapter semantics for Python `Scope` subset behavior and the decidable canonical ambient projection; it does not add a Python operational semantics or a new entitlement theorem;
- `Audit.lean`: `#print axioms` audit surface for the current formal theorems and conformance bridge;
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
- `LicensingRead.requirement` is still an already-resolved exact requirement. `ProfileSnapshot.requirement_for` or any equivalent requirement-lookup implementation remains outside the theorem model;
- canonical warrant lookup is partial (`WarrantId → Option CanonicalWarrant`), while abstract `Env` and `FloorEnv` remain total. `Canonical` and `WellFormedCandidates` therefore mark the concrete/refinement hygiene boundary without changing abstract NW;
- the derived canonical `SatOracle` totalizes unknown IDs to ordinary `false`. Python fail-fast behavior for unknown candidate IDs is not identified with that abstract behavior; Python conformance is compared only on canonical encoded candidates, while explicit tests preserve unknown-ID fail-fast as a `¬WF` case;
- `toFloorEnv` needs a fallback only because `FloorEnv.lookup` is total. `Derives (toEnv C) β R` proves every support ID is canonical, which makes the fallback unobservable on the derived branch and on projected entitlement;
- ambient binding-scope checks and atomic requirement-scope checks use `C.semantics.scopeLE`; `ProjectedEntitled` evaluates the floor with that same `C.semantics`, preventing scope-semantics drift in the canonical interpretation;
- `BranchProjectionCoherent C β` states branch-by-branch that satisfaction-relevant observations and floor observations arise from the same canonical warrant objects;
- `PythonConformance.lean` supplies `pythonScopeLE` for the deterministic list encoding of Python `frozenset` scopes and proves `projectedAmbientAdmissible_true_iff`; this is an executable conformance bridge, not a proof that Python source execution refines Lean;
- provenance ancestry, parent lineage, concrete Binding/Profile/Context state machines, a theorem for requirement lookup, context-currentness transitions, move args, warrant formation, `INFER`, `TRANSPORT`, challenge/revision transitions, formal Python operational semantics, verified extraction, Q_open, and Q_close remain outside this layer.

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

The leaf case records one and the same canonical warrant `cw` for both the satisfaction conditions and the floor projection `(claim, role, scope)`.

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

## PR #7 — Python V0.1.2.2 reference-semantics conformance

The conformance layer is deliberately a separate obligation from PR #6. It does not introduce a Lean model that merely resembles Python and then call that a Python proof. Instead, the Python reference implementation is executed, its current canonical licensing read is serialized, and a generated Lean fixture imports the machine-checked PR #6 definitions for the comparison:

```text
Python V0.1.2.2 canonical state
        │
        │ capture_licensing_read
        ▼
CanonicalReadSnapshot
        │
        │ deterministic wire encoding
        ▼
generated Lean fixture data
        │
        │ imports PR #6 definitions
        ▼
toAmbient / toOracle / satisfy / toFloorEnv / licenseSafe
        │
        ▼
differential conformance result
```

The Python adapter does not contain a second implementation of Lean `satisfy` or `licenseSafe`. The generated Lean module contains fixture data and encoding declarations; satisfaction and floor evaluation are performed by the formal definitions.

The current conformance surfaces are:

1. the four Python licensing ambient observations against `toAmbient`;
2. actual `ProofKernel.satisfy()` against `satisfy (toOracle C)` for canonical candidate lists;
3. actual `ProofKernel.license_safe()` against `licenseSafe` through `toFloorEnv`;
4. Python branch constructors against the raw Lean `Branch` encoding;
5. duplicate candidate IDs with original order and occurrence count preserved;
6. unknown Python IDs kept as fail-fast / `¬WellFormedCandidates` cases rather than ordinary unsatisfaction;
7. actual `ProfileSnapshot.requirement_for(τ,m)` used only to populate the already-resolved `LicensingRead.requirement` adapter field;
8. ACTION authorization, scope coverage, SHARE selection, and revision-depth floor cases;
9. actual `ProofKernel.license()` negative ambient gates for binding activity, use, context activity, and binding scope.

### Encoding boundary

Python warrant IDs are strings and the current Lean `WarrantId` is `Nat`. The adapter builds a deterministic injective enumeration of the finite canonical warrant universe. Equal Python IDs encode to the same Nat; distinct IDs encode to distinct Nats inside that snapshot. Candidate lists are mapped occurrence-by-occurrence, so duplicates are not collapsed.

Python `Scope` is a `frozenset`; the wire representation is a sorted, duplicate-free `List String`. `pythonScopeLE` interprets the encoded lists with subset semantics. The list is therefore a transport representation, not the semantic identity of a scope:

```text
SemanticObject != WireEncoding
```

`FloorSemantics.escalationDepth` remains explicit. For the finite fixture claim universe, the adapter supplies the output of the actual Python `_claim_depth` parser instead of silently duplicating Python integer parsing in Lean.

### Verified status

The dedicated `Python-Lean Conformance` workflow builds the Lean library and runs both the existing V0.1.2.2 Python regression suite and the cross-language fixtures. The current successful CI run reports:

```text
51 passed
```

The existing Lean workflow separately continues to build the formal library, reject `sorry` / `admit`, and print the theorem axiom dependencies. `projectedAmbientAdmissible_true_iff` is included in that explicit audit surface.

The precise claim after this milestone is:

> **Python V0.1.2.2 is conformance-tested against the machine-checked projection model.**

It is not:

> **Python V0.1.2.2 is machine-proved correct.**

The stronger statement would require a formal Python semantics, verified extraction, or migration of the trusted executable implementation into a language/runtime with a verified correspondence path.
