# Lean 4 Formalization — Current Research Surface

This directory contains the current mechanized Responsibility Topology research program. It is **not** limited to the first-paper `Step` surface.

The recurring formal separation is:

> **Persistent historical structure and state-indexed current responsibility are distinct relations.**

Different paper stages instantiate that separation along different axes.

## Paper-scale layers

### Paper 1 — Object / identity

Core distinction:

```text
historical formation / parent identity
!=
current evaluation qualification
```

Principal modules include:

- `Reachability.lean`
- `RootFormation.lean`
- `EvaluationQualification.lean`
- `InferFormation.lean`
- `InferQualification.lean`
- static entitlement / canonical-read modules

The first-paper artifact remains separately frozen in repository-root `ARTIFACT.md` and must not be inferred from current `main`.

### Paper 2 — Environment

Core distinction:

```text
cross-context historical transport
!=
source-indexed current qualification
!=
current Adopt/license/context responsibility
```

Principal modules include:

- `TransportSemantics.lean`
- reachable TRANSPORT formation/qualification modules
- two-hop transport conservation modules
- `AdoptLicenseCurrentness.lean`
- `AdoptReachability.lean`
- `AdoptActivation.lean`
- `AdoptGroundedness.lean`
- `ContextCurrentness.lean`

The current Paper 2 formal boundary includes same-profile TRANSPORT plus reachable Adopt/license/grounded currentness. It does **not** establish arbitrary interoperability, entitlement-backed issuance, runtime refinement, or arbitrary temporal persistence.

### Paper 3 — Change

Core distinction:

```text
canonical historical continuity
!=
currentness continuity
```

and then:

```text
impact detection
!= repair selection
!= repair realization
!= represented-cut necessity
!= extraction completeness
!= ordered execution
```

Principal modules:

- `ChallengeImpact.lean`
- `ChallengeInvalidation.lean`
- `ChallengeInvalidationInvariant.lean`
- `ActivationRefresh.lean`
- `RepairSemantics.lean`
- `RepairSufficiency.lean`
- `RepairMinimality.lean`
- `RevalidationLifecycle.lean`
- `Paper3Audit.lean`

Paper 3 formal semantics are frozen at PR #48 / merge commit `190e24e404c864ef8f535f8dbd101c319689e4bc` unless the manuscript trigger is explicitly fired.

## Current state layers

The source tree now contains several related reachability layers rather than one monolithic transition type:

```text
CanonicalState / Step / Reachable
        |
        +-- ROOT / INFER / TRANSPORT
        |
AdoptState / AdoptReachable / AdoptActivationReachable
        |
        +-- enriched Adopt license records
        +-- BaseCurrent
        +-- Adopt activation
        +-- Grounded
        |
ChallengeReachable / RefreshReachable
        |
        +-- challenge invalidation
        +-- fixed-point refresh
        |
RevalidationReachable
        |
        +-- proof-carrying RepairActionStep
        +-- ordered RevalidationTrace
```

These layers are intentional. Later stages extend earlier stable semantics without retroactively changing a frozen paper's claim surface.

## Paper 3 theorem hierarchy

For current writing, the formal surface should be read in four result families rather than as a theorem catalog.

### T1 — History-preserving currentness invalidation

A valid challenge preserves canonical historical referents while mutable current responsibility can weaken. The modeled affected boundary is target plus historical descendants; downstream effects include warrant suspension, license review/currentness loss, refresh removal, and issuer-dependent groundedness cascades.

`Affected = target ∪ descendants` is primarily a **modeled impact boundary**. Its paper value comes from the invalidation/preservation/cascade results built on top of it, not from treating the equivalence itself as deep mathematics.

### T2 — Repair selection + realization implies restoration

`RepairProblem` is a finite directed-hypergraph instance over three currentness obligation kinds:

```text
warrant Usability
license BaseCurrent
context Groundedness
```

`RepairSet` is a hitting-set condition over represented unresolved cuts. It does **not** establish semantic effectiveness.

Restoration requires:

```text
RepairSet
+
RepairRealization
=>
target restoration
```

including preservation through the final refresh.

### T3 — Inclusion-minimal repair admits private-cut witnesses

`MinimalRepairSet` means inclusion-minimal only. Each selected action in an inclusion-minimal repair set has a private unresolved cut witnessing local non-removability relative to that selected set.

Not proved:

```text
minimum cardinality
minimum cost
optimality
uniqueness
canonical frontier
```

Universal semantic necessity additionally requires `EveryRepairCutNecessary`; that premise establishes necessity of **represented cuts** for a chosen restoration predicate. It does not prove that no necessary dependency was omitted from the extracted model.

### T4 — Proof-carrying repair can be realized in reachable state

`RevalidationTrace` is ordered even though `RepairSet` is not. Warrant, license, and context repair remain distinct action families. `reachable_revalidation_lifecycle_restores` threads a valid challenge, refresh, ordered repair trace, and final refresh through `RevalidationReachable` and returns target restoration.

This is a realizability/reachability bridge, not a completeness theorem for all abstract repair sets or all action orders.

## Historical preservation boundary

Challenge, refresh, and repair transitions have stage-local historical/topology preservation results. The current final lifecycle theorem does not syntactically package an end-to-end

```text
HistoryReferentsImmutable S0.core S4.core
```

conjunct. Manuscripts should cite stage-local preservation compositionally unless a future indispensable claim specifically requires a packaged theorem.

## Current formal non-claims

Current `main` does **not** prove:

- that `portable-runtime` refines this Lean model or vice versa;
- a total executable Python operational refinement;
- automatic or complete `Challenge -> RepairProblem` extraction;
- that every abstract repair set has an executable ordering;
- that every abstract minimal alternative is reachable;
- minimum-cost/cardinality repair;
- a generic all-domain change-impact theory;
- cross-domain invariance of the responsibility structures;
- responsibility-vocabulary or cut-model adequacy (`Q_open`);
- distributed responsibility closure (`Q_close`).

## Relation to `portable-runtime`

The two repositories are conceptually related but semantically non-identical. Framework V1.0 call vocabulary is used to prevent accidental redefinition:

```text
reference
boundary-reference
specialize
operationalize
represent
handoff
```

Current formal Paper 3 challenge impact uses transitive warrant-parent descendant closure. The runtime also contains direct typed dependency-impact semantics and explicitly does not reduce every dependency kind to that closure. Therefore there is no current equality or refinement claim between their transition systems.

See repository-root `CROSS_REPO_RELATION.md`.

## Formal reopen rule

Formal work is frozen by default. Reopen only when a central, indispensable manuscript or next-theory statement cannot be honestly supported by the existing surface and cannot be weakened/deleted without breaking the thesis.

The next theory-level trigger is expected to concern regime/model adequacy rather than another lifecycle constructor:

```text
Q_open:
When is a system entitled to conclude that
its current responsibility vocabulary or cut model is insufficient?
```

## Build and audit

```bash
lake build
lake env lean ResponsibilityTopology/Audit.lean
lake env lean ResponsibilityTopology/Paper3Audit.lean
```

`Audit.lean` remains the first-paper/shared audit surface; `Paper3Audit.lean` owns Paper 3 theorem auditing. Paper-specific commit identities are recorded in repository-root `PAPER_VERSIONS.md`.