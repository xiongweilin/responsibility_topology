# Responsibility Topology — Formal Research Program

This repository is the Lean-centered formal research line of a broader Responsibility Topology program. Its recurring question is:

> **How can a finite system preserve why something exists while separately re-establishing what may be relied on now?**

The repository is no longer a first-paper-only kernel. Current `main` contains three paper-scale formal stages plus shared entitlement, projection, conformance, and currentness machinery.

## Program progression

The first three papers form one theoretical progression rather than three feature bundles:

```text
Object
  Paper 1: identity / formation
  historical relation != current qualification
        |
        v
Environment
  Paper 2: cross-context responsibility
  transported history != source/target current responsibility
        |
        v
Change
  Paper 3: invalidation / repair
  preserved history != restored current responsibility
        |
        v
Regime                    [open]
  Q_open: when is the responsibility vocabulary / cut model itself inadequate?
        |
        v
Multi-agent regime         [open]
  Q_close: how is responsibility discharged across heterogeneous agents?
```

The unifying principle is not a particular constructor. It is the repeated separation of **persistent structure** from **state-indexed current responsibility** along progressively harder axes.

## Paper map

| Stage | Research axis | Frozen / current scope | Status |
| --- | --- | --- | --- |
| **Paper 1** | Object / identity | ROOT + INFER; canonical history vs current usability; exact current-parent qualification | frozen artifact and manuscript line |
| **Paper 2** | Environment | same-profile TRANSPORT; source-indexed current qualification; Adopt-license `BaseCurrent`; reachable Adopt activation; `Grounded` currentness | formal kernel complete; manuscript line frozen separately |
| **Paper 3** | Change | challenge impact/invalidation; grounded refresh; finite repair instances; `RepairSet`; `RepairRealization`; inclusion-minimal private cuts; reachable revalidation | formal kernel frozen at PR #48; manuscript work active/frozen by paper manifests |
| **Next theory** | Regime adequacy | responsibility-model adequacy / `Q_open` | not formalized |
| **Later theory** | Multi-agent regime | distributed responsibility / `Q_close` | not formalized |

Paper-specific claims must be read from their own manifests and paper files, not inferred from current `main`.

## Current formal architecture

```text
static entitlement / locality
        |
canonical interpretation + exact profile semantics
        |
reachable canonical history/evaluation state
        |
ROOT / INFER formation and qualification
        |
TRANSPORT formation and source-indexed qualification
        |
Adopt license records / BaseCurrent / activation / Grounded
        |
challenge invalidation
        |
grounded refresh
        |
finite repair hypergraph
        |
selection -- realization -- represented-cut necessity
        |
ordered proof-carrying revalidation trace
```

Current Paper 3 semantics deliberately keep distinct:

```text
historical dependency
!= state-indexed current responsibility

impact detection
!= repair selection
!= semantic realization
!= represented-cut necessity
!= extraction completeness
!= ordered execution
```

## Three program-level open gaps

The highest-value next research questions are not additional lifecycle constructors.

1. **Cross-domain invariance.** Which responsibility structures survive specialization outside the present epistemic kernel?
2. **Runtime / refinement bridge.** Which observations of an executable runtime correspond to the Lean model, and under what abstraction/refinement relation?
3. **Responsibility-model adequacy / Q_open.** When is a system entitled to conclude that its current vocabulary, dependency cuts, or governing regime is itself insufficient and must be reopened?

The third is the deepest theoretical gap. The current repair theory assumes a represented repair problem; it does not make the model self-certifying.

## Relationship to `portable-runtime`

`xiongweilin/portable-runtime` and this repository are related but not in a verified implementation relation.

The relationship uses the Framework V1.0 call vocabulary:

```text
portable-runtime theory/docs
    --specialize / boundary-reference-->
responsibility_topology formal kernels

portable-runtime record/runtime mechanisms
    --operationalize / represent-->
engineering behavior and records

responsibility_topology
    --does NOT currently refine-->
portable-runtime runtime
```

The two repositories may share concepts without sharing transition semantics. In particular, Paper 3 uses transitive canonical warrant-descendant impact, while the runtime also contains direct typed dependency-impact mechanisms. See [`CROSS_REPO_RELATION.md`](CROSS_REPO_RELATION.md).

## Versioning and artifact identity

`main` is a moving research branch and must not be used as a paper identity.

- [`ARTIFACT.md`](ARTIFACT.md) remains the immutable **Paper 1** artifact freeze. Do not update it to describe later semantics.
- [`PAPER_VERSIONS.md`](PAPER_VERSIONS.md) records paper-specific semantic/manuscript baselines and versioning policy.
- `paper/` contains multiple paper workspaces; its README is a navigation index, not a claim source.
- `formal/README.md` describes the current formal program surface; paper-specific theorem claims remain frozen separately.

## Formal freeze rule

The default state is now **writing/research-program management first, formal frozen**.

A formal milestone may reopen only when all of the following hold:

1. a concrete manuscript or next-theory sentence is central and indispensable;
2. the existing theorem surface cannot support it honestly;
3. deleting or weakening the sentence materially breaks the thesis;
4. the missing result can be added without opportunistic semantic expansion.

Reviewer anticipation, aesthetic theorem packaging, more constructors, cost optimization, automatic repair extraction, or runtime refinement do not fire the current Paper 3 trigger by themselves.

## Repository layout

- `formal/` — current Lean 4 research program and theorem audit surfaces.
- `paper/` — Paper 1, Paper 2, and Paper 3 writing/audit material.
- `ARTIFACT.md` — Paper 1 artifact lock only.
- `PAPER_VERSIONS.md` — paper-specific frozen commit identities.
- `CROSS_REPO_RELATION.md` — relation contract with `portable-runtime`.
- `proof_kernel_v0_1_2_2.py`, `v0122_*.py`, `test_v0122_*.py` — older executable/conformance boundary retained for reproducibility and selected observation tests.

## Build and audit

```bash
cd formal
lake build
lake env lean ResponsibilityTopology/Audit.lean
lake env lean ResponsibilityTopology/Paper3Audit.lean
```

Repository CI also rejects `sorry` / `admit` placeholders in the formal core. The existence of a Lean theorem is evidence only for its explicit formal statement and premises; it is not evidence of profile adequacy, model adequacy, runtime refinement, or `Q_open`.