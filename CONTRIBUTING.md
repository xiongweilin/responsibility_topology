# Contributing to Responsibility Topology

This repository is in a **post-construction, evidence-gated research freeze**. Contributions are welcome only when they preserve the frozen claim boundaries and enter through one of the permitted maintenance/evidence channels below.

`RESEARCH_STATE.md` is authoritative for current research status. This file does not authorize a new theory object merely because an implementation or theorem would be easy to add.

## Allowed change classes

Every contribution should identify exactly one primary class:

```text
Maintenance
Correction
Absorption
EvidenceEvent
```

### Maintenance

Examples:

- reproducibility or CI failures;
- Lean/toolchain breakage that prevents the frozen artifact from building;
- Python–Lean conformance breakage;
- broken links or repository-navigation failures;
- dependency/tooling maintenance required to preserve reproducibility.

Maintenance must not silently broaden theorem claims, bridge scope, or research-state language.

### Correction

Examples:

- documentation/status drift;
- incorrect theorem description;
- incorrect source reconstruction or citation;
- licensing/citation metadata errors;
- a mismatch between README/navigation summaries and `RESEARCH_STATE.md`.

Corrections should reduce ambiguity rather than introduce new terminology.

### Absorption

An absorption contribution supplies stronger prior art, a stronger ordinary-domain explanation, or another independently checkable result that **narrows or eliminates an existing surviving research claim**.

Examples:

- prior art that further absorbs the frozen QX Candidate-A residual;
- an ordinary institutional mechanism that fully explains a previously suspected QC residual;
- evidence that a purportedly novel distinction is standard structure under a more precise existing vocabulary.

Absorption is a valid positive research outcome. It does not create a replacement theory automatically.

### EvidenceEvent

An evidence event may affect QX or QC only if it satisfies the relevant current evidence gate.

For QX, the only open empirical wake route is currently E-WAKE:

```text
mechanism-distinct
+ source-backed
+ non-eliminable residual
```

A new example selected merely to rescue Candidate A is not admissible. The completed Candidate-A cycle remains frozen.

For QC, a source-backed case must be viable enough to reconstruct the material-facts/reliance/currentness/authority timeline and then pass the current evidence pipeline:

```text
RawSources
-> MaterialFactsFreeze
-> NativeDecomposition
-> RivalAdmissible / RivalFit
-> SharedDeterminationExistenceGate
-> Residual
-> SharedRelianceConsequence
```

A new case does not become QC evidence merely because it involves distributed systems, heterogeneous trust, no global operator, semantic mismatch, stale state, or multi-party coordination.

## Not accepted by default

The following are outside the current contribution boundary unless an independently earned research-state change first authorizes them:

- new QX or QC Lean predicates/modules;
- speculative generic theory extensions;
- additional Candidate-B rescue examples;
- additional Candidate-A support/rescue cases selected after the completed falsification cycle;
- renamed revivals of `ChallengeStanding`, `ClosureDefeater`, or equivalent rejected QO objects;
- broad runtime-refinement expansion beyond the frozen Strict-L6 boundary;
- claims that a clean theorem statement, constructor, or abstraction is itself evidence for a new research object;
- feature requests whose primary purpose is to restart theory construction.

## Evidence discipline

### Primary-source preference

Use primary or authoritative sources whenever available. Clearly separate:

```text
direct source fact
from
analyst reconstruction/inference.
```

Do not use a later refinement, remediation, or institutional redesign as evidence that an earlier actor already possessed the information required by a claim.

### QX access-level burden

When an argument depends on evidence `E`, state who could access it at the relevant time:

```text
Analyst
Institution
DecisionSystem
AutonomousAgent
PostHocHistorian
```

In particular:

```text
analyst can prove a distinction is necessary
-/->
responsible system was entitled at that time to indict its own decision boundary.
```

### QC rival admission

An ordinary rival may eliminate a QC residual only if it is admissible and fully instantiated in the actual case. A label such as `governance`, `ownership`, `contract`, `versioning`, or `revocation` is not an explanation by itself.

`RivalAdmissible(M,D)` requires, at minimum:

```text
recognized/domain-native mechanism;
source-instantiable actors/objects/authority/path;
actual institution preserved rather than redesigned;
no invented owner/contract/arbiter;
material facts preserved;
case-specific consequences that can fail.
```

RivalFit is four-dimensional:

```text
Fit(M,D)
=
(F_desc, F_causal, F_norm, F_cf)
```

Each dimension is `FULL`, `PARTIAL`, or `FAIL`. Only:

```text
(FULL, FULL, FULL, FULL)
```

is eliminatively sufficient.

Permanent firewall:

```text
counterfactual repair != explanation
```

For example, “the institution should have assigned a revalidation owner” is a remediation proposal, not evidence that such an owner actually existed in the source-backed institution.

## Pull requests

Use a pull request for repository changes. A PR should state:

1. the allowed change class (`Maintenance`, `Correction`, `Absorption`, or `EvidenceEvent`);
2. the authoritative files affected;
3. whether any research-state sentence changes;
4. what CI/reproducibility surface was exercised;
5. for Absorption/EvidenceEvent changes, the source chain and exact claim boundary affected.

If the change does **not** alter research state, do not edit `RESEARCH_STATE.md` merely to record activity. Audit or debt files are sufficient when the governance state is unchanged.

## Issue entry points

Use the repository issue forms rather than a generic feature request:

- **Reproducibility bug** — builds, CI, conformance, artifact reproduction.
- **Documentation drift** — status, claim wording, links, citations, licensing metadata.
- **Prior-art threat** — stronger neighboring theory or absorption threat.
- **Evidence event** — source-backed event that may enter QX E-WAKE or QC evidence acquisition.

There is intentionally no general “Feature request” template.

## Formalization gate

Neither QX nor QC formalizes by default. A Lean phase may open only after the relevant track has all of:

```text
stable objects;
strong prior-art elimination;
pre-registered kill/evidence protocol;
non-eliminable native structure in heterogeneous evidence;
a theorem/countermodel obligation that is not definition expansion.
```

Current authoritative result remains:

```text
QX Lean: NO
QC Lean: NO
```

## Licensing of contributions

Source-code contributions are submitted under the Apache License 2.0 in `LICENSE` unless explicitly marked otherwise before submission.

Covered research-documentation contributions are submitted under the CC BY 4.0 policy in `LICENSE-DOCS`. Files under `paper/` are excluded from that repository-level documentation license unless an individual manuscript explicitly states otherwise.

If a contribution mixes code, research documentation, and manuscript text in a way that makes the license scope unclear, resolve the licensing boundary before merge.

## Final check before submitting

Ask:

> Does this change preserve the distinction between an interesting question and a theory object that the evidence has actually earned?

If the answer is unclear, prefer a documentation/correction issue over a speculative implementation.
