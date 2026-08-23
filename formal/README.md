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
- `ContextCurrentness.lean`: grounded adopted-context currentness, external activation-license `BaseCurrent`, finite bootstrap-rooted activation chains, invalidation monotonicity, semantic refresh idempotence, and the dynamic ambient currentness bridge;
- `Audit.lean`: `#print axioms` audit surface for the current formal theorems and conformance bridges;
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
- `ContextCurrentness.lean` closes the semantic meaning of adopted-context `contextActive`: currentness is the least grounded relation generated by explicit bootstrap activation and base-current Adopt licenses whose issuing contexts are recursively grounded;
- `ActivationRead.baseCurrent` remains external. It contains all activation-license currentness obligations except issuing-context activity; the full Python `check_license_current` implementation is not modeled by this milestone;
- `Grounded` is an inductive semantic closure, not a theorem that Python's current while-loop implements that closure. Python/currentness correspondence remains a separate conformance/refinement obligation;
- the dynamic ambient projection `toGroundedAmbient` replaces arbitrary `contextActive` at the semantic interpretation boundary with `Grounded R` for the exact `(binding, context, use)` key, while preserving the other PR #6 ambient projections;
- provenance ancestry, parent lineage, concrete Binding/Profile/Context transition systems, a theorem for requirement lookup, concrete context-currentness transition refinement, move args, warrant formation, `INFER`, `TRANSPORT`, challenge/revision transitions, formal Python operational semantics, verified extraction, Q_open, and Q_close remain outside this layer.

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

The PR #7 conformance surfaces are:

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

### PR #7 verified status

The dedicated `Python-Lean Conformance` workflow built the Lean library and ran both the existing V0.1.2.2 Python regression suite and the cross-language fixtures. The PR #7 final-head CI reported:

```text
51 passed
```

The existing Lean workflow separately continued to build the formal library, reject `sorry` / `admit`, and print the theorem axiom dependencies. `projectedAmbientAdmissible_true_iff` is included in that explicit audit surface.

The precise claim after PR #7 is:

> **Python V0.1.2.2 is conformance-tested against the machine-checked projection model.**

It is not:

> **Python V0.1.2.2 is machine-proved correct.**

The stronger statement would require a formal Python semantics, verified extraction, or migration of the trusted executable implementation into a language/runtime with a verified correspondence path.

## PR #8 — Adopted context currentness / ambient dependency closure

PR #8 closes the semantic `contextActive` responsibility position without importing the full dynamic kernel.

The decomposition is deliberately:

```text
Current(L, A) := BaseCurrent(L) ∧ Grounded(IssuerContext(L), A)
```

where `BaseCurrent(L)` is external to this layer. It represents every activation-license currentness condition except currentness of the license's issuing context.

The core semantic read is:

```text
ActivationRead
  seedActive    : ContextKey → Prop
  activation    : ContextKey → Option Activation
  issuerContext : ActivationLicenseId → Option ContextKey
  baseCurrent   : ActivationLicenseId → Prop
```

and `Grounded R c` is inductively generated only by:

```text
bootstrap:
  seedActive(c)
  activation(c) = bootstrap
  --------------------------------
  Grounded(c)

adopt:
  seedActive(c)
  activation(c) = adopt(L)
  BaseCurrent(L)
  issuerContext(L) = issuer
  Grounded(issuer)
  --------------------------------
  Grounded(c)
```

This is intentionally a grounded / least relation rather than a greatest-fixed-point reading. A cycle cannot manufacture its own currentness. Every `Grounded` derivation is finite and must terminate at an explicit bootstrap activation boundary.

The machine-checked theorem surface is:

```text
grounded_contractiveness
  Grounded R c → seedActive c

grounded_fixedPoint_soundness
  Grounded R c
  → bootstrap(c)
    ∨ ∃ L issuer,
        activation(c)=adopt(L)
        ∧ BaseCurrent(L)
        ∧ issuerContext(L)=issuer
        ∧ Grounded R issuer

grounded_refresh_idempotence
  Grounded (refreshed R) c ↔ Grounded R c

grounded_invalidation_monotonicity
  B₂ ⊆ B₁
  → Grounded (withBaseCurrent R B₂) c
  → Grounded (withBaseCurrent R B₁) c

grounded_has_bootstrap_chain
  Grounded R c
  → ∃ root,
      CurrentActivationChain R c root
      ∧ activation(root)=bootstrap

no_grounded_without_bootstrap
  (∀ c, activation(c) ≠ bootstrap)
  → ¬ Grounded R c

groundedAmbient_contextActive_iff
  toGroundedAmbient(D,R,m).contextActive
  ↔ Grounded R D.contextKey
```

The dynamic ambient bridge is:

```text
             LicensingRead
                  │
                  │ + bindingId
                  ▼
        DynamicLicensingRead       ActivationRead
                  │                     │
                  └────────┬────────────┘
                           ▼
                  toGroundedAmbient
                           │
                           ▼
              AmbientView.contextActive
                    = Grounded exact key
```

`toGroundedAmbient` preserves the existing PR #6 binding/use/scope/requirement projections and replaces only the previously arbitrary `contextActive` proposition with grounded currentness for the exact `(binding, context, use)` key.

### Python provenance hardening

Before freezing this semantic choice, the Python public activation path exposed a real ambiguity: `activate_context_with_adopt_license()` could target an already-ACTIVE context and `_activate_context()` would overwrite that context's recorded activation license. That allowed bootstrap provenance to be silently replaced and made self-supporting Adopt cycles constructible at the state level.

PR #8 hardens that boundary: an already-ACTIVE context cannot be re-activated by another Adopt license, so its active activation provenance is immutable. A PENDING context remains eligible for a later valid Adopt activation; the guard does not make pending state irreversible.

Two adversarial regressions pin the chosen law:

```text
active context cannot silently replace bootstrap activation provenance

cyclic Adopt dependency cannot become self-supporting
```

The current combined Python regression/conformance suite, including these two cases, reports:

```text
53 passed
```

This hardening is deliberately not presented as a Python/Lean currentness refinement theorem. It removes the concrete provenance-overwrite shortcut so that the executable reference implementation is compatible with the chosen grounded law at the activation boundary.

### PR #8 boundary

PR #8 proves the semantic closure, not the implementation correspondence. In particular it does not claim:

- that Python `_refresh_context_currentness_fixed_point` computes `Grounded`;
- that full Python `check_license_current` is modeled by `BaseCurrent`;
- that challenge/revision transitions produce a formally correct new `BaseCurrent` judgment;
- that the concrete Python History/state transition system refines `ActivationRead`.

The next currentness milestone should therefore remain separate:

```text
PR #9 — Python V0.1.2.2 Context-Currentness Conformance

actual Python dynamic state / transition
        │
        ▼
canonical dynamic snapshot
        │
        ▼
deterministic fixture
        │
        ▼
PR #8 Grounded semantics
        │
        ▼
differential currentness result
```

This preserves the same separation established by PR #6/#7: machine-check the semantic object first, then test the executable reference implementation against that object under explicit encoding and well-formedness conditions.
