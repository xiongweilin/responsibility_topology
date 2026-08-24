# Responsibility Topology — Formal Research Program

This repository is the Lean-centered formal research line of the Responsibility Topology program.

Its recurring concern is how finite representations carry historical responsibility, current qualification, change, and bounded reliance without silently upgrading one kind of evidence into another.

## Program history and current architecture

The completed formal sequence is:

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
```

After Paper 3, the repository completed a technical consolidation track and froze **Strict technical Level 6**.

The research architecture is no longer the old linear sequence:

```text
Q_open -> Q_close
```

Instead, current pre-formal research is organized as two independent evidence-gated tracks:

```text
Frozen Strict-L6
+
QX  Representation Inadequacy
+
QC  Provisional Shared Determination
```

Neither QX nor QC is a prerequisite for the other.

## Current research status

```text
Cross-domain strength:       FORMAL SIMILARITY
Strict technical Level 6:    PASS / FROZEN
Technical feature expansion: CLOSED by default
QO standing/closure lineage: ARCHIVED NEGATIVE CONTROL
QX:                         ACTIVE, PRE-FORMAL
QC:                         ACTIVE, PRE-FORMAL
QX Lean:                    NO
QC Lean:                    NO
```

See `RESEARCH_STATE.md` for the governance checkpoint and `RESEARCH_DEBT.md` for the evidence-gated debt ledger.

## Paper and technical map

| Stage | Research axis | Frozen/current scope | Status |
| --- | --- | --- | --- |
| **Paper 1** | Object / identity | ROOT + INFER; canonical history vs current usability | frozen artifact/manuscript line |
| **Paper 2** | Environment | TRANSPORT, source-indexed current qualification, Adopt license/currentness/groundedness | frozen manuscript/formal line |
| **Paper 3** | Change | challenge invalidation, repair selection/realization, private-cut witnesses, proof-carrying revalidation | frozen manuscript/formal line |
| **Technical consolidation** | Cross-domain + runtime/formal correspondence | minimal calculi, explicit finite-domain interpretations, executable O0/B0, verified raw-artifact checker path | **Strict technical Level 6: PASS / FROZEN** |
| **QO negative-control lineage** | standing / closure operationalization | use-indexed admissibility correction; review/standing and reviewability/closure shortcuts eliminated | archived after negative falsification |
| **QX** | representation inadequacy | finite distinction spaces and evidence for suspecting insufficiency | active pre-formal research |
| **QC** | provisional shared determination | heterogeneous finite systems, partial interpretation, bounded revocable shared reliance | active pre-formal scouting |

Paper-specific claims must be read from their own manifests and paper files, not inferred from moving `main`.

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

CrossDomain
  ImpactDischargeCore
  EvaluationLayerCore
  explicit source-audited finite-domain interpretations

Bridge
  raw selected runtime transition artifact
  Lean-owned restricted B0 projection/checker
  formal challenge witness for the same restricted observation pattern
```

The cross-domain calculi establish formal similarity only. The finite case models and interpretations are not formal verification of FAA practice, public law, metrology, software operations, or any other external domain.

## Strict Level-6 boundary

The final strict bridge is intentionally narrow.

The executable path is:

```text
actual selected runtime transition
  -> raw serialized before/after artifact
  -> Lean parser
  -> Lean-owned alpha_B0 projection
  -> Lean checker
  -> restricted B0 withdrawal contract
```

The Python O0/B0 semantic extractor is not trusted on that successful checker path.

Remaining trust includes raw runtime construction, serialization correctness, artifact transport/I/O fidelity, and the representativeness of the selected executable fixture.

The approved relationship language is therefore:

```text
end-to-end from an actual serialized selected runtime transition artifact
to a verified restricted B0 contract
```

It does **not** mean:

```text
Python runtime verified
all runtime transitions verified
RuntimeStep -> FormalStep*
impact equivalence
external-domain verification
mechanism similarity
universal responsibility invariant
```

See `STRICT_LEVEL6_TECHNICAL_AUDIT.md`, `LEVEL6_TECHNICAL_AUDIT.md`, and `CROSS_REPO_RELATION.md`.

## QO negative-control lineage

The QO-1/QO-2 research is preserved because it eliminated several dangerous shortcuts.

Forward representation discipline:

```text
Admissible_K(item,use)
```

replaces unindexed:

```text
A_K(e)
```

as the default cross-domain admissibility description.

The following are now negative-control boundaries:

```text
review
-/-> standing

different admissibility by use
-/-> standing

reviewability
!= closure qualification

gate review / preserved challenge
-/-> closure defeater

syntactic/procedural scope
-/-> adequate localization
```

The attempted generic objects were not earned:

```text
ChallengeStanding: NOT EARNED
generic ReopenEntitled/closure-defeater relation: NOT EARNED
QO-3 formalization: BLOCKED
```

`Q_OPEN_POST_FALSIFICATION_SYNTHESIS.md` is the owning checkpoint.

This negative result closes the standing/closure operationalization. It does **not** settle the broader mother problem of representation inadequacy.

## QX — Representation Inadequacy

Mother question:

> **How can a finite system become entitled to suspect that its current space of distinctions is inadequate for a relied-upon responsibility task without already knowing the correct refinement?**

QX must not reuse `standing`, `closure`, or `reopen` as default primitives.

Initial analytical separation:

```text
Anomaly
!=
SuspectInadequacy
!=
AuthorizedRevision
```

The first hard problem is not to prove that an already-specified abstraction loses information. It is to determine what evidence may count as an insufficiency certificate when the correct finer representation is not already supplied by an oracle.

Formal gate: **CLOSED**.

## QC — Provisional Shared Determination

Mother question:

> **How can multiple finite systems become entitled to provisionally share a bounded determination across heterogeneous representations without a final arbiter?**

QC begins with the separations:

```text
local determination
!= provisional shared determination
!= shared reliance
!= global truth
!= final authority
```

and:

```text
agreement != semantic identity
```

The absence of a central arbiter is not itself a research contribution. QC must survive ordinary consensus, federated/heterogeneous quorum, authority, and semantic-translation explanations before proposing any new responsibility object.

Formal gate: **CLOSED**.

## Research progress metric

The program no longer uses theorem count or constructor count as a progress proxy.

```text
progress
=
deleted freedom
+ resolved research debt
+ independently surviving structure
```

The controlling question after each cycle is:

> **Which degrees of theoretical freedom were removed by the evidence?**

## Formal freeze rule

Formal work is frozen by default.

A new Lean phase may open only when a research track has stable objects, a strong prior-art elimination record, a preregistered kill protocol, non-eliminable native structure in heterogeneous evidence, and a theorem/countermodel obligation that is not mere definition expansion.

No current QX or QC Lean module exists or is authorized.

## Repository map

- `formal/` — frozen/current Lean research program, cross-domain calculi, bridge checker, and audit surfaces.
- `paper/` — Paper 1–3 writing/audit material.
- `ARTIFACT.md` — Paper 1 artifact lock.
- `PAPER_VERSIONS.md` — paper-specific frozen identities.
- `STRICT_LEVEL6_TECHNICAL_AUDIT.md` — strict technical Level-6 evidence and trust boundary.
- `LEVEL6_TECHNICAL_AUDIT.md` — earlier restricted Level-6 checkpoint.
- `Q_OPEN_POST_FALSIFICATION_SYNTHESIS.md` — QO negative-control research stop.
- `RESEARCH_STATE.md` — current parallel-track governance state.
- `RESEARCH_DEBT.md` — evidence-gated research debt ledger.
- `PROGRAM_ROADMAP.md` — current execution architecture.

## Build and audit

```bash
cd formal
lake build
lake env lean ResponsibilityTopology/Audit.lean
lake env lean ResponsibilityTopology/Paper3Audit.lean
lake env lean ResponsibilityTopology/CrossDomainAudit.lean
lake env lean ResponsibilityTopology/BridgeAudit.lean
lake env lean ResponsibilityTopology/Level6Audit.lean
lake env lean ResponsibilityTopology/StrictLevel6Audit.lean
```

A Lean theorem is evidence only for its explicit formal statement and premises. It is not evidence of external-domain truth, model adequacy, full runtime refinement, QX, or QC.
