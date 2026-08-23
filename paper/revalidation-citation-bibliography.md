# Paper 3 Citation Bibliography — Verified Core Prior Art

Status: paper-only bibliography audit. No formal semantics.

Purpose: freeze the bibliographic identity and the exact comparison role of the core prior-art families before venue formatting. This file is not itself a novelty claim; it is a citation source for the next submission assembly.

## 1. Truth maintenance and belief revision

### Doyle 1979 — Truth Maintenance System

Jon Doyle. **A Truth Maintenance System.** *Artificial Intelligence* 12(3):231–272, 1979.

DOI: `10.1016/0004-3702(79)90008-0`

Use for:

- recording/maintaining reasons for program beliefs;
- revising a current belief set when assumptions/discoveries change;
- dependency-directed explanation/revision.

Do **not** claim that Paper 3 is the first system to preserve reasons while current acceptance changes.

### de Kleer 1986 — ATMS

Johan de Kleer. **An Assumption-Based TMS.** *Artificial Intelligence* 28(2):127–162, 1986.

DOI: `10.1016/0004-3702(86)90080-9`

Use for:

- assumption-set labels and multiple environments;
- context-sensitive support;
- explicit prior art against a broad claim that “context-indexed support” is new.

Optional companion citation when space permits:

Johan de Kleer. **Problem Solving with the ATMS.** *Artificial Intelligence* 28(2):197–224, 1986.

DOI: `10.1016/0004-3702(86)90082-2`

### AGM 1985 — belief revision

Carlos E. Alchourrón, Peter Gärdenfors, and David Makinson. **On the Logic of Theory Change: Partial Meet Contraction and Revision Functions.** *Journal of Symbolic Logic* 50(2):510–530, 1985.

DOI: `10.2307/2274239`

Use for:

- rational contraction/revision of belief theories;
- positioning Paper 3 as a narrower state/obligation architecture rather than a replacement for general belief-revision theory.

## 2. Provenance, incremental maintenance, and impact analysis

### Green–Karvounarakis–Tannen 2007 — provenance semirings

Todd J. Green, Grigoris Karvounarakis, and Val Tannen. **Provenance Semirings.** In *Proceedings of the Twenty-Sixth ACM SIGMOD-SIGACT-SIGART Symposium on Principles of Database Systems (PODS 2007)*, pp. 31–40, ACM, 2007.

DOI: `10.1145/1265530.1265535`

Use for:

- mature derivational/provenance representations;
- prior art against claiming novelty for historical lineage itself.

The safe contrast is not “provenance lacks currentness.” Use the narrower statement that Paper 3 makes a separate state-indexed current-responsibility layer explicit and then studies restoration over typed currentness obligations.

### Gupta–Mumick 1995 — materialized-view maintenance

Ashish Gupta and Inderpal Singh Mumick. **Maintenance of Materialized Views: Problems, Techniques, and Applications.** *IEEE Data Engineering Bulletin* 18(2):3–18, 1995.

Use for:

- dependency-sensitive maintenance after data changes;
- prior art against claiming novelty for incremental restoration/recomputation in general.

### Acar–Blume–Donham 2011 — self-adjusting computation

Umut A. Acar, Matthias Blume, and Jacob Donham. **A Consistent Semantics of Self-Adjusting Computation.** arXiv:`1106.0478`, 2011.

Use for:

- formal semantics of change propagation and reuse under mutation;
- evidence that dependency traces and post-change propagation already have mature formal treatments.

Do not make this citation carry the responsibility/authorization comparison; it is a computation-maintenance neighbor.

### Ryder–Tip 2001 — software change impact

Barbara G. Ryder and Frank Tip. **Change Impact Analysis for Object-Oriented Programs.** In *Proceedings of the ACM SIGPLAN-SIGSOFT Workshop on Program Analysis for Software Tools and Engineering (PASTE 2001)*, pp. 46–53, 2001.

DOI: `10.1145/379605.379661`

Use for:

- the distinction between identifying effects of a change and deciding downstream repair responsibility;
- prior art against claiming novelty for `Affected`-style dependency impact.

Preferred Paper 3 comparison:

```text
impact detection
!= responsibility restoration
```

not:

```text
prior work has impact graphs; we have a better graph.
```

## 3. Stateful and revocable authorization

### Garg–Pfenning 2012 — stateful authorization logic

Deepak Garg and Frank Pfenning. **Stateful Authorization Logic — Proof Theory and a Case Study.** *Journal of Computer Security* 20(4):353–391, 2012.

DOI: `10.3233/JCS-2012-0456`

An earlier conference version appeared at STM 2010. Prefer the journal version in the final bibliography unless the manuscript specifically discusses the conference artifact.

Use for:

- authorization whose validity depends on mutable system state;
- explicit time/state in authorization logic;
- prior art against the slogan “once authorized does not imply still authorized” as a novelty claim.

### Morgenstern–Garg–Pfenning 2011 — revocable/use-once PCA

Jamie Morgenstern, Deepak Garg, and Frank Pfenning. **A Proof-Carrying File System with Revocable and Use-Once Certificates.** In *Security and Trust Management — 7th International Workshop, STM 2011, Revised Selected Papers*, LNCS 7170, pp. 40–55, Springer, 2011.

DOI: `10.1007/978-3-642-29963-6_5`

Use for:

- explicit proof-carrying authorization combined with revocation/use-once state;
- strong prior art showing that persistent policy certificates can coexist with mutable current authorization state.

Paper 3 must not characterize proof-carrying authorization as inherently timeless.

## 4. Model-based diagnosis and hitting sets

### Reiter 1987 — diagnosis from first principles

Raymond Reiter. **A Theory of Diagnosis from First Principles.** *Artificial Intelligence* 32(1):57–95, 1987.

DOI: `10.1016/0004-3702(87)90062-2`

This is the most important combinatorial prior-art citation.

Use for:

- conflict/diagnosis structure;
- minimal hitting-set characterization of diagnoses;
- explicit concession that minimal hitting sets and non-unique minimal solutions are not new mathematics in Paper 3.

Required positioning:

> Paper 3 does not claim a new hitting-set theory. Its contribution is the responsibility interpretation and the mechanized separation of typed currentness loss, repair selection, semantic realization, represented-cut necessity, extraction completeness, and reachable execution.

## 5. Citation-to-claim matrix

| Manuscript claim | Primary prior-art pressure | Required response |
| --- | --- | --- |
| historical reason can persist while current acceptance changes | Doyle; de Kleer; stateful authorization | concede general phenomenon; emphasize typed state decomposition and lifecycle |
| currentness can be context/state sensitive | ATMS; stateful authorization | do not claim abstract context/state indexing as new |
| derivational lineage is preserved | provenance | do not claim provenance novelty |
| changes propagate through dependencies | view maintenance; self-adjusting computation; change-impact analysis | do not claim dependency propagation novelty |
| repair is a hitting-set problem | Reiter diagnosis | explicitly concede classical combinatorics |
| inclusion-minimal solutions may be non-unique | diagnosis/hypergraph literature | no novelty claim; use only as model-specific local witness structure |
| impact differs from restoration | change-impact + diagnosis | locate contribution in downstream typed responsibility decomposition |
| current authorization may be revoked | stateful/revocable authorization | no novelty claim for revocation itself |

## 6. Citation discipline for the submission draft

Use prior art to narrow the claim, not to manufacture a uniqueness contrast.

Avoid categorical claims of the form:

```text
existing systems do not preserve history
existing provenance cannot model validity
belief revision erases justification
stateful authorization lacks revalidation
model-based diagnosis lacks repair actions
```

Those statements are too broad.

Prefer relation-specific comparisons:

```text
Paper 3 explicitly keeps warrant Usability,
license BaseCurrent, and context Groundedness separate.
```

```text
Paper 3 separates impact detection from repair selection,
selection from semantic realization,
and represented-cut necessity from extraction completeness.
```

```text
The hitting-set combinatorics is classical;
the claim is about its semantic placement inside a mechanized revision lifecycle.
```

## 7. Reference-format policy

Before venue formatting:

- preserve full author names where practical;
- preserve DOI for journal/conference entries when available;
- use one canonical version of each work (e.g. Garg–Pfenning journal 2012 rather than simultaneously citing conference and journal versions without need);
- do not cite secondary summaries when a publisher/author version is available;
- do not use citation counts as novelty evidence;
- keep related-work statements narrower than what the cited source actually establishes.

Venue-specific BibTeX/LNCS formatting is a later packaging step and does not alter this bibliographic identity.