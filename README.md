# Responsibility Topology for Finite Epistemic Kernels

This repository studies a narrow formal distinction:

> **Canonical historical formation and current usability are distinct state relations.**

For ordinary INFER, the stronger machine-facing distinction is:

> **Historical derivation and current usable-parent responsibility are distinct relations.**

A warrant can exist as a canonical object of immutable formation/derivation history without thereby being currently usable or entitled. `Responsibility Topology` is the broader interpretive framework for locating those responsibility boundaries; the theorem-facing claims remain narrower than claims of epistemic adequacy.

The current research phase is a **paper-freeze window**. The default task is now to compress and explain the proved argument, not to expand the kernel surface.

## Core architecture

```text
Abstract entitlement layer
        │
        │ branch-local derivability, floor locality,
        │ exact requirements, entitlement composition
        ▼
Canonical interpretation layer
        │
        │ one shared read for ambient / satisfaction / floor views
        ▼
Exact profile semantics
        │
        │ exact move identity, requirement and rule resolution
        ▼
Reachable canonical kernel
        ├── ROOT formation / admission lifecycle
        └── INFER formation / qualification lifecycle
        │
        ▼
Executable conformance boundary
        │
        └── selected Python V0.1.2.2 observations

Orthogonal semantic currentness component:
  grounded adopted-context currentness
```

Grounded currentness is connected structurally to reachable canonical state, but the current `Step` surface does not contain license issuance or Adopt transitions. It is therefore a semantic currentness component, not a completed reachable Adopt lifecycle.

The central dynamic separation is:

```text
immutable canonical history
        │
        │ formation
        ▼
historical warrant
        │
        │ explicit evaluation boundary
        ▼
current qualification
        │
        ▼
usable warrant
        │
        │ requirement + ambient + floor
        ▼
entitlement
```

The last arrow is an abstract entitlement layer, not yet a single end-to-end theorem from `CanonicalState` to `LicensingRead` and `Entitled`.

## Three paper-facing contributions

### 1. Static entitlement calculus

The static layer formalizes branch-local derivability and finite observation boundaries. Its main result family includes Branch Conservativity, Kernel-Floor Locality, Relative Branch Conservativity, exact full-move requirement resolution, and canonical projection coherence.

The exact requirement model distinguishes a missing requirement from an explicit top requirement:

```text
lookup(k) = none
```

is not identified with:

```text
lookup(k) = some Top
```

The point is not merely that several locality lemmas hold. It is that the evidence responsibility for an entitlement judgment can be located on an explicit finite observation boundary.

### 2. Reachable canonical state

The dynamic layer starts from an explicit `InitialBoundary`, applies kernel-owned `Step` transitions, and defines `Reachable` states. A shared `CanonicalStateInvariant` separates immutable canonical history from mutable evaluation state and preserves exact historical referent identity.

The first-paper reachable transition surface is deliberately small: context/profile registration, binding, bootstrap activation, ROOT formation/admission, and INFER formation/qualification.

Grounded adopted-context currentness is an orthogonal semantic closure. It defines bootstrap-rooted currentness and rules out purely self-supporting activation cycles, while `baseCurrent` remains an explicit external factor and Adopt itself is not yet a reachable transition family.

### 3. Historical formation versus current qualification

This is the main distinguishing result family.

For ROOT:

```text
Formation ⇏ Usability
```

Canonical ROOT formation creates a historical warrant but does not silently create a current evaluation position. Explicit admission establishes usability.

For INFER, historical and current parent responsibility are different:

```text
historical parent relation
    ≠
current usable-parent responsibility
```

Formation records a historically well-formed derived warrant without consuming current parent usability. Explicit qualification later requires every historical parent to be currently usable in the selected pre-state evaluation environment and then establishes child usability in the post-state:

```text
HistoricalDerived
+ CurrentUsableParents(pre)
+ ExplicitQualification
    → CurrentDerivedUsable(post)
```

The corresponding lifecycle theorem makes the intermediate non-usable state machine-visible.

## Proved / tested / not claimed

| Status | Current boundary |
| --- | --- |
| **Machine checked in Lean 4** | Branch Conservativity; Kernel-Floor Locality; Relative Branch Conservativity; exact requirement resolution; canonical projection coherence; reachable canonical-state invariance; grounded currentness semantics; ROOT formation/admission separation; INFER historical formation; INFER current-parent qualification; INFER lifecycle separation. |
| **Differentially conformance-tested** | Selected Python V0.1.2.2 projection, floor, satisfaction, ambient, and adopted-context-currentness observations against the mechanized projection/currentness surfaces. |
| **Not proved** | Full Python operational refinement; a total `CanonicalState → LicensingRead` assembly theorem; reachable Adopt lifecycle; TRANSPORT lifecycle; license lifecycle; challenge/revision/revalidation transition semantics; profile adequacy; kernel-floor adequacy; use/admission adequacy; Q_open; Q_close. |

The executable reference must therefore be described as **conformance-tested on selected observations**, not as a verified Python kernel.

## Paper-facing theorem map

The first paper exposes a small result surface rather than mirroring the source tree:

```text
R1  Relative Branch Conservativity
R2  Exact Requirement Resolution
R3  Canonical Projection Coherence
R4  Reachable Canonical-State Invariance
R5  Grounded Currentness / No Self-Support      [semantic component]
R6  ROOT Formation–Qualification Separation
R7  INFER Historical Formation Correctness
R8  INFER Current-Parent Qualification
R9  INFER Lifecycle Separation
```

Implementation lemmas such as setter locality, lookup completeness, and constructor-specific preservation facts support these results but are not separate headline contributions.

## Important non-theorems

Correct execution inside a finite responsibility regime is not a proof that the regime is adequate:

```text
ProfileExecutionCorrectness
    ⇏
ProfileAdequacy
```

and:

```text
KernelCorrectness
    ⇏
KernelFloorAdequacy
```

Likewise:

```text
CurrentDerivedUsable
    ⇏
Entitled
```

without the separate requirement, ambient, derivability, and floor-safety obligations of the entitlement layer.

These boundaries are deliberate. The project does not claim source authenticity, rule adequacy, profile adequacy, admission adequacy, or a universal epistemology.

## Current assembly boundary

Several bridges already exist:

```text
HistoricalWarrant
    → canonical warrant projection

epi + placement
    → state-backed usability

CanonicalProfile
    → exact requirement snapshot

ActivationRead
    → grounded context activity
```

However, the repository does **not** currently claim a complete theorem of the form:

```text
Reachable CanonicalState
    → LicensingRead
    → Entitled
```

The present, accurate claim is narrower: the reachable kernel establishes historical and current-evaluation facts that are inputs to the separately proved entitlement layer.

If paper writing exposes an unavoidable gap at this boundary, the next formal milestone should be a narrowly scoped state-backed licensing-read assembly theorem rather than an unrelated expansion of constructor semantics.

## Paper-freeze rule

During the current first-paper window:

> **Do not add core semantics unless writing exposes a theorem gap that cannot be crossed honestly without it.**

TRANSPORT, license issuance, Adopt lifecycle, challenge/revision/revalidation, and broader regime-reopening theory are therefore future work unless they become necessary to support a concrete paper claim.

## Repository layout

- `paper/`: first-paper workspace, theorem map, running argument, and related-work positioning.
- `formal/`: Lean 4 mechanization and theorem audit surface. See [`formal/README.md`](formal/README.md) for the technical architecture and result map.
- `proof_kernel_v0_1_2_2.py`: executable V0.1.2.2 reference kernel.
- `test_v0122_*.py`: executable regression and cross-language conformance tests.
- `v0122_conformance.py`: adapter for selected static projection conformance.
- `v0122_currentness_conformance.py`: adapter for selected grounded-currentness conformance.
- `.github/workflows/`: Lean build/audit and Python–Lean conformance CI.

The executable V0.1.2.2 code remains an important reference implementation, but it is no longer the sole identity of the repository. The repository now contains a substantial mechanized research program above that executable boundary.

## Build and test

Lean:

```bash
cd formal
lake build
lake env lean ResponsibilityTopology/Audit.lean
```

Python and cross-language conformance:

```bash
python -m pytest -q \
  test_v0122_kernel.py \
  test_v0122_currentness.py \
  test_v0122_conformance.py \
  test_v0122_currentness_conformance.py
```

CI additionally rejects `sorry` / `admit` placeholders in the formal core and prints explicit axiom dependencies for the paper-relevant theorem surface.
