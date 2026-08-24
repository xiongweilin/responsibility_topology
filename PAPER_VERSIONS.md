# Paper-Specific Version Manifest

`main` is a moving research/maintenance branch. Papers must cite frozen commit identities rather than “current main.”

This manifest separates three identities where relevant:

```text
formal semantic baseline
manuscript baseline
artifact packaging baseline
```

A later paper may build on an earlier formal baseline, but it may not retroactively change the earlier paper's claim surface.

## Paper 1 — Object / identity

Research axis:

```text
historical formation / parent identity
!=
state-indexed current qualification
```

| Identity | Commit | Meaning |
| --- | --- | --- |
| formal/semantic baseline | `d0074353176fc74c11bc33adab2feae448f56bd8` | semantic artifact locked by `ARTIFACT.md` after first-paper submission/novelty passes |
| artifact packaging baseline | `295a6911c739221ae87b262e234f706bd2fb3e96` | PR #24 packaging/reproducibility merge; does not redefine semantic baseline |
| manuscript/claim-audit baseline | `7d75255066782457010dd2ef09c07465295bea88` | PR #25 hostile-review merge; paper-only claim narrowing |

Authoritative artifact file: repository-root `ARTIFACT.md`.

Do not replace its semantic baseline with a later commit.

## Paper 2 — Environment

Research axis:

```text
cross-context historical responsibility
!=
source/issuer/target current responsibility
```

Program-level scope:

```text
TRANSPORT historical formation / source-indexed qualification
+
Adopt-license record / BaseCurrent
+
reachable Adopt activation
+
Grounded reachable currentness
```

Reader-facing result blocks:

```text
E1  cross-context historical transport
    != source-indexed current qualification

E2  recorded activation provenance
    != license BaseCurrent
    != context Groundedness
```

| Identity | Commit | Meaning |
| --- | --- | --- |
| historical TRANSPORT manuscript freeze | `621ff84dbb4e70c95e77cb0608e2b9376f46f214` | PR #37 hostile-review / TRANSPORT-only manuscript freeze; predates final Adopt/License/Grounded formal closure |
| formal semantic baseline | `4dfa0c19e6fb40947e3fe5dd5b8600c55e1ad424` | PR #41 merge; final Paper 2 formal scope including reachable Adopt activation -> `Grounded` closure |
| Environment synthesis baseline | `1c755353ecc8bd610a82bb50261de76b45c70f02` | PR #64 merge; reorganizes Paper 2 into E1/E2 without formal changes |
| Environment hostile/manuscript freeze | `88567a749cfa695c8be393dbe926ae0d4484b0cd` | PR #65 merge; hostile consistency pass, end-to-end TRANSPORT -> Adopt firewall retained, formal trigger not fired |

Current Paper 2 manuscript identity is `88567a74...` evaluated against formal semantic identity `4dfa0c19...`.

The older `621ff84d...` freeze remains historically valid for the TRANSPORT-only subline but is no longer the current whole-paper manuscript identity.

Permanent Paper 2 firewall:

```text
No theorem currently composes
TRANSPORT qualification
into entitlement-backed Adopt license issuance/recording,
Adopt activation, and Grounded target
as one end-to-end pipeline.
```

That missing bridge is not a reason to reopen Paper 2 formal semantics merely for expository symmetry.

## Paper 3 — Change

Research axis:

```text
preserved canonical history
!=
invalidated / restored current responsibility
```

| Identity | Commit | Meaning |
| --- | --- | --- |
| formal semantic baseline | `190e24e404c864ef8f535f8dbd101c319689e4bc` | PR #48 merge; final reachable revalidation lifecycle on top of challenge/refresh/repair semantics |
| paper checkpoint baseline | `95e4c93bc558dba93a817753d0e13439030d6229` | PR #49 merge; kernel expansion frozen by default |
| first full manuscript baseline | `1d87f0327a7edea891db41ef3b71d0d5d3421837` | PR #54 merge |
| hostile-review baseline | `252030ec777baa52cf7cc41c0da0487283c3a5d5` | PR #55 merge |
| venue-neutral v2 manuscript baseline | `c5d569e0219cf7ff9c78eb6054631fe44b06dd48` | PR #57 merge; state-indexed/finite/adequacy terminology corrected |
| conceptual v3 manuscript baseline | `44605d00d66921aebc6279fc11270d1e58d7867f` | PR #60 merge; four result families, two-figure architecture, affected/necessity hierarchy normalized |
| artifact packaging baseline | `2b620cd7479aec3700f72c2faead0873a889cb63` | PR #61 merge; `PAPER3_ARTIFACT.md` and version packaging only; formal semantics unchanged |

The formal identity remains `190e24e4...` unless an explicit future formal trigger is independently earned. Later paper-only or post-paper technical commits do not change Paper 3 semantics.

`PAPER3_ARTIFACT.md` is the authoritative Paper 3 artifact/version document. It freezes the formal baseline separately from manuscript and packaging identities.

## Naming policy

Preferred human-readable release names are:

```text
paper1-formal-v1
paper1-manuscript-v1
paper1-artifact-v1

paper2-formal-v1
paper2-manuscript-v1

paper3-formal-v1
paper3-manuscript-v1
paper3-artifact-v1
```

The exact commit SHA in this manifest is authoritative even if a human-readable tag/ref is added later.

## Freeze semantics

A paper-specific freeze means:

1. claims are evaluated against the recorded semantic commit;
2. later `main` changes are not silently imported;
3. manuscript-only changes may narrow/reorganize claims without changing the semantic identity;
4. if formal semantics later change for a new independently authorized research objective, the older paper keeps its original baseline;
5. artifact packaging must identify whether it reproduces the semantic commit exactly or adds post-baseline packaging files.

## Cross-paper inheritance

The research program is cumulative, but paper claims are not.

Safe:

```text
Paper 3 uses structures introduced before its formal baseline.
```

Unsafe:

```text
Because current main proves Paper 3, Paper 1's artifact also proves Paper 3.
```

Each paper owns its theorem surface and non-claims at its own baseline.

## Current post-freeze policy

The older pre-Strict-L6 roadmap language (`define alpha_0`, then attempt a refinement theorem, then proceed to `Q_open`) is historical and no longer describes the current execution state.

Current authoritative status is:

```text
Paper 1 formal:                 FROZEN
Paper 2 formal:                 FROZEN
Paper 3 formal:                 FROZEN
Strict Technical Level 6:       PASS / FROZEN
Cross-domain strength:           FORMAL SIMILARITY
Full RuntimeStep -> FormalStep*: NOT PROVED / NOT OWED TO STRICT-L6
QO:                              ARCHIVED NEGATIVE CONTROL
QX:                              DORMANT / OPEN / PRE-FORMAL
QC:                              EVIDENCE-LIMITED / PRE-FORMAL
QX Lean:                         NO
QC Lean:                         NO
```

The current strict bridge is the raw selected-transition path documented in `STRICT_LEVEL6_TECHNICAL_AUDIT.md`; it does not alter any paper semantic identity.

Neither QX nor QC is the default “next paper” or next formal stage. Any future formal line must be independently earned under `RESEARCH_STATE.md`, `PROGRAM_ROADMAP.md`, and `CONTRIBUTING.md`.
