# Paper Workspace Index

This directory contains writing, claim maps, running examples, hostile reviews, and submission drafts for multiple papers in the Responsibility Topology research program.

It is **not** a single first-paper workspace. Paper-specific claims are frozen by their own files and commit baselines; later `main` changes do not retroactively expand an earlier paper.

## Program sequence

```text
Paper 1 — Object / identity
  historical formation != current qualification

Paper 2 — Environment
  transported historical responsibility != current environment responsibility

Paper 3 — Change
  preserved history != invalidated/restored current responsibility

Next — Cross-domain falsification
  candidate structures must survive heterogeneous-domain attacks
  before any cross-domain invariant claim

Then — Observation/refinement bridge

Then — Regime adequacy / Q_open
  correct repair inside a model != knowing the model is adequate

Later — Multi-agent regime / Q_close
```

The three completed paper lines should be described as:

```text
Object -> Environment -> Change
```

not as:

```text
INFER -> TRANSPORT -> challenge constructor
```

## Paper 1 — history / qualification

Primary files:

- `draft.md` — long-form working draft.
- `submission-draft.md` — submission-oriented compressed draft.
- `theorem-map.md` — R1–R9 paper-facing theorem map.
- `related-work-matrix.md` — related-work/novelty discipline.
- `novelty-freeze.md` — frozen novelty wording.
- `hostile-review-audit.md` — adversarial claim audit.

Repository-root `ARTIFACT.md` belongs **only** to Paper 1 and locks semantic baseline `d0074353176fc74c11bc33adab2feae448f56bd8`. It must not be edited to describe Paper 2 or Paper 3.

Paper 1 mother distinction:

```text
persistent historical parent identity
!=
state-indexed current usable-parent responsibility
```

## Paper 2 — cross-environment responsibility

Current environment-synthesis files:

- `transport-environment-submission-v2.md` — current Paper 2 environment manuscript; integrates final TRANSPORT + Adopt/License/Grounded formal scope.
- `transport-environment-claim-map.md` — current two-block E1/E2 claim map and end-to-end firewall.
- `transport-environment-hostile-consistency.md` — final P2-S2 adversarial consistency pass; formal trigger not fired.

Historical TRANSPORT-only files remain preserved, including:

- `transport-paper-checkpoint.md`
- `transport-theorem-map.md`
- `transport-running-example.md`
- `transport-related-work.md` / novelty material
- `transport-submission-draft.md`
- `transport-hostile-review.md`

Program-level Paper 2 scope is:

```text
TRANSPORT historical formation
+
source-context current qualification
+
Adopt-license record / BaseCurrent
+
reachable Adopt activation
+
Grounded reachable currentness
```

Reader-facing Paper 2 result blocks are now exactly:

```text
E1  cross-context historical transport
    != source-indexed current qualification

E2  recorded activation provenance
    != license BaseCurrent
    != context Groundedness
```

The old P2-R1–P2-R4 labels remain an artifact-level decomposition of the TRANSPORT half of E1. They are not four additional headline contributions on top of E1/E2.

Permanent Paper 2 firewall:

```text
There is no current end-to-end theorem
TRANSPORT qualification
  -> Adopt license issuance/recording
  -> Adopt activation
  -> Grounded target.
```

The paper must not reopen Lean merely to fill that narrative joint. `AdoptLicenseRecordDiscipline` is explicitly not entitlement-backed issuance, and no theorem derives an Adopt license from a transported child.

Paper 2 formal semantic baseline remains PR #41 merge:

```text
4dfa0c19e6fb40947e3fe5dd5b8600c55e1ad424
```

Paper 2 mother question:

> When responsibility crosses an environment boundary, which facts remain attached to historical objects and which current responsibilities must be discharged in source, issuer, or target environment coordinates?

## Paper 3 — dependency-sensitive revision

Primary files:

- `revalidation-paper-checkpoint.md` — formal-kernel checkpoint.
- `revalidation-claim-map.md` — theorem/claim firewall.
- `revalidation-running-example.md` — three-layer currentness counterexample.
- `revalidation-related-work.md` — prior-art narrowing.
- `revalidation-submission-draft.md` — first full manuscript.
- `revalidation-hostile-review.md` — adversarial review.
- `revalidation-post-review-corrections.md` — terminology/claim corrections.
- `revalidation-submission-v2.md` — venue-neutral pre-compression baseline.
- `revalidation-submission-v3.md` — current conceptually normalized manuscript baseline: four result families and mother claim above hitting-set machinery.
- `revalidation-figure-spec.md` — frozen two-figure architecture and caption/claim rules.
- `revalidation-citation-bibliography.md` — verified core prior-art bibliography and claim-pressure matrix.
- `revalidation-language-polish.md` — venue-neutral wording firewall that must survive later compression.
- `revalidation-venue-target.md` — historical venue-specific planning; not part of the semantic claim surface.

Repository-root `PAPER3_ARTIFACT.md` owns the Paper 3 semantic/manuscript/artifact freeze. `PAPER_VERSIONS.md` records exact commit identities.

Paper 3 mother distinction:

```text
Revision should withdraw current responsibility
without rewriting historical dependency.
```

The paper then separates:

```text
impact detection
!= repair selection
!= semantic effectiveness
!= represented-cut necessity
!= extraction completeness
!= ordered execution
```

The formal kernel is frozen at PR #48 / `190e24e4...`. Manuscript work should reduce theorem-catalog presentation rather than request more Lean by default.

## Paper 3 result hierarchy

Use four memorable result families:

```text
T1  history-preserving currentness invalidation
T2  repair selection + realization -> restoration
T3  inclusion-minimal repair -> private-cut witnesses
T4  proof-carrying repair has a reachable realization bridge
```

Treat these as supporting definitions/lemmas/boundaries rather than peer headline theorems:

- target-plus-descendants `Affected` boundary;
- refresh contractiveness;
- `EveryRepairCutNecessary` represented-cut necessity premise;
- stage-local history-preservation lemmas.

`EveryRepairCutNecessary` does not prove extraction completeness. `MinimalRepairSet` does not mean minimum-cardinality, minimum-cost, optimal, unique, or canonical.

## Figure architecture

Paper 3 carries two primary figures.

### Figure A — persistent history vs typed currentness across change

```text
                         formation/qualification   challenge      refresh       repair       final refresh

historical plane        ======================= identity preserved ======================================

warrant currentness           LIVE/PLACED       SUSPENDED/...                restored
                                      |
license currentness              BaseCurrent       stale                      restored
                                      |
context currentness               Grounded        loss/inactive              reactivated -> Grounded
```

The visual point is persistent historical identity plus typed, non-monotone currentness.

### Figure B — repair responsibility interfaces

```text
RepairProblem
    |
    v
RepairSet                 unordered selection
    |
    v
RepairRealization         semantic effectiveness certificate
    |
    v
RevalidationTrace         ordered proof-carrying execution
```

The hypergraph is a technical representation inside this argument, not the conceptual starting point. `revalidation-figure-spec.md` is authoritative for caption and non-claim rules.

## Permanent writing rule

Across all papers:

> **Fix prose before reopening semantics.**

A new formal milestone is permitted only when an indispensable central sentence cannot be supported honestly, cannot be deleted or weakened without breaking the thesis, and the missing result is narrow enough not to broaden the object model opportunistically.

Version identities are recorded in repository-root `PAPER_VERSIONS.md`.