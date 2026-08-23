# Paper 3 Venue Target — iFS 2027

Status: paper-only venue-shaping decision. Formal/kernel work remains frozen.

Decision date: 2026-08-23.

## Primary target

**iFS 2027 — First International Conference on Foundations and Formal Methods for Software and Systems, regular long research paper.**

ETAPS 2027 submission deadline: **October 15, 2026 (AoE)**.

The iFS call allows long papers up to **16 pages + up to 2 pages of references**, with an optional appendix up to 6 pages. Regular research papers are double-blind and should identify a principled advance to the fundamentals of software engineering, with sufficient evidence for soundness and applicability. Artifact evaluation is available.

## Why iFS is the best current fit

The current manuscript is primarily a formal architecture / methodology paper, not a new combinatorial theory, tool paper, or empirical systems paper.

The strongest contribution is the separation and composition of revision responsibilities:

```text
canonical historical dependency
!= state-indexed current responsibility

impact detection
!= repair selection
!= semantic realization
!= represented-cut necessity
!= extraction completeness
!= ordered execution.
```

This maps naturally to iFS topics including:

- formal and semi-formal modeling;
- system architecture;
- software/system quality assurance;
- software evolution and lifecycle management;
- foundations for AI-based systems, including trust, transparency, testing, verification, and lifecycle management;
- engineering reliable/responsible software and systems.

The Lean mechanization provides rigorous evidence for soundness of the scoped semantic claims. The absence of a runtime-refinement theorem or empirical evaluation is therefore a manageable limitation at iFS if the paper is presented as a principled formal-methodology advance rather than a deployed systems contribution.

## Why not FoSSaCS as the primary target

FoSSaCS seeks foundational research with clear significance for software science and is a plausible thematic neighbor, but the present paper faces substantial theorem-depth pressure there:

- `Affected = target ∪ descendants` is largely definitional;
- hitting-set combinatorics is classical;
- `RepairRealization` carries the semantic effectiveness premise;
- `EveryRepairCutNecessary` carries the represented-cut necessity premise;
- the main novelty is architectural decomposition and formal responsibility placement rather than a new foundational calculus or combinatorial result.

A FoSSaCS submission would therefore need to defend a stronger theory-level novelty claim than the current hostile review recommends. iFS better rewards methodological/formal architecture contributions.

## Why not TACAS as the primary target

TACAS accepts theoretical research with relevance to system construction/analysis, but its center of gravity is tools, algorithms, verification methods, and case studies. The current Paper 3 deliberately does not claim:

- a repair-planning algorithm;
- complexity bounds;
- an implementation of generic revalidation;
- runtime refinement;
- benchmarks or an empirical case study.

Submitting to TACAS now would invite the predictable question: what tool/algorithmic capability or experimental validation does this deliver? That is not the paper's current contribution.

## AI/KR venue status

KR 2026 has already occurred (July 20–23, 2026). A future KR edition remains conceptually relevant because the paper connects directly to truth maintenance, belief revision, justification, and diagnosis, but the next public call should be evaluated when available.

AAAI-27 main-track deadlines have passed. Its AI Alignment track full-paper deadline was August 21, 2026, also already passed. More importantly, the present paper's strongest contribution is a formal revision architecture rather than an alignment result.

## Submission category

Default: **iFS regular long research paper**, not NIER.

Reason: the formal kernel is no longer merely a proposal. Paper 3 contains a completed mechanized theorem surface covering challenge invalidation, grounded loss, finite repair instances, conditional sufficiency, inclusion-minimal private-cut witnesses, explicit represented-cut necessity, and reachable proof-carrying restoration.

NIER should be used only if the 16-page shaping pass reveals that the contribution cannot be defended as a principled research result without relying on the broader unfinished `Q_open` theory. Current evidence does not require that downgrade.

## iFS-facing mother claim

Use:

> **We present a mechanized revision architecture for state-backed reasoning systems in which canonical history can survive while typed current-responsibility obligations become stale. Given a finite repair instance, unresolved currentness obligations form responsibility cuts; inclusion-minimal hitting sets identify locally non-redundant repair selections, semantic effectiveness is carried separately by realization certificates, and ordered proof-carrying actions reconnect the repair model to reachable state.**

Do not lead with:

> We introduce a new minimal hitting-set theory for revalidation.

Do not lead with:

> We verify a production responsibility runtime.

## Required iFS shaping

### 1. Title

Use the v2 title:

> **Dependency-Sensitive Revision and Inclusion-Minimal Responsibility Repair in a State-Backed Epistemic Kernel**

This avoids both the false implication of a type-level finite state space and the ambiguity of unqualified "minimal".

### 2. First-page positioning

The first page should establish four facts quickly:

1. "responsibility" means a formal proof/currentness obligation, not a moral/legal category;
2. currentness is **state-indexed**, not explicitly time-indexed in the Lean signature;
3. the finite object is the repair instance, not the entire `CanonicalState` type;
4. the combinatorics is classical; novelty lies in responsibility decomposition and its mechanized lifecycle boundaries.

### 3. Contribution order

Use:

```text
A. historical/currentness discontinuity
B. typed currentness loss and grounded cascade
C. finite repair-instance semantics
D. selection vs realization vs represented-cut necessity
E. inclusion-minimal private-cut witnesses
F. reachable proof-carrying realization
```

Do not make exact affectedness the first headline theorem. Its definitional nature is too easy to attack. Present it as the chosen impact semantics required to state B.

### 4. Main theorem emphasis

Headline theorem exposition should center on:

- `repairSet_sufficient_after_refresh` as a **composition/interface theorem**, explicitly carrying `RepairRealization`;
- `minimalRepairSet_has_private_edge` as a model-specific local non-redundancy witness using classical hitting-set structure;
- the `EveryRepairCutNecessary` section as a **responsibility firewall**, not a theorem-depth claim;
- `reachable_revalidation_lifecycle_restores` as a late realizability bridge.

### 5. Extraction gap

Before the repair section, say explicitly:

> **Given an extracted finite repair instance ...**

Do not write that challenge automatically induces a complete repair hypergraph. No such extraction theorem exists.

### 6. Adequacy split

Use two distinct phrases:

```text
represented-cut necessity
```

for what `EveryRepairCutNecessary` supplies, and

```text
extraction completeness
```

for the unproved no-missing-dependency obligation.

Avoid using "extraction adequacy" as if one theorem discharged both.

### 7. Running example

Keep the single warrant → license → context example. It should do all conceptual work:

```text
Usability loss
-> BaseCurrent loss
-> Groundedness loss
-> refresh removal
-> finite repair cuts
-> two abstract inclusion-minimal hitting sets
-> one directly demonstrated reachable repair branch.
```

The caption/prose must state that the second abstract branch is not independently proved reachable.

### 8. Artifact story

The paper should invite artifact evaluation around:

- building the Lean development;
- checking `Paper3Audit.lean`;
- mapping headline paper claims to named theorems;
- checking that no `sorry`/`admit` placeholders occur under the existing CI policy.

Do not use `portable-runtime` as the evaluated implementation of Paper 3. It is related architecture, not a proved refinement target.

## 16-page allocation target

A reasonable LNCS allocation is:

```text
1. Introduction and contributions                    1.5 pages
2. State model + running example                      2.0
3. Challenge/currentness loss + refresh               2.0
4. Repair hypergraph semantics                        2.0
5. Sufficiency + inclusion-minimal private cuts       2.5
6. Represented-cut necessity / completeness boundary  1.5
7. Reachable realization                              1.5
8. Related work                                       1.5
9. Limitations + discussion                           0.8
10. Conclusion                                        0.2
-------------------------------------------------------------
Total                                                ~15.5 pages
```

Use the optional appendix for expanded Lean signatures, theorem/claim mapping, and the full running-example derivation rather than crowding the main text.

## Rebuttal-risk checklist

Before submission, the main PDF must already answer:

- "Isn't this just Reiter hitting sets?" — combinatorics conceded; semantics/interface decomposition is the contribution.
- "Does `RepairSet` assume restoration?" — no; `RepairRealization` carries effectiveness.
- "Is the lower bound definitional?" — represented-cut necessity is an explicit premise; the contribution is exposing the missing responsibility, not proof difficulty.
- "Where does the repair graph come from?" — externally extracted/modelled; no automatic completeness theorem.
- "Are both example repairs executable?" — only one branch is directly demonstrated reachable.
- "Is the runtime verified?" — no cross-repository refinement claim.
- "Why call the model finite?" — do not; only repair instances/traces are finite.

## Freeze policy through submission

Formal/kernel work remains frozen.

A new formal PR is permitted only if all of the existing trigger conditions hold:

1. a concrete sentence is indispensable to the iFS thesis;
2. current theorems cannot support it honestly;
3. deleting or weakening it materially breaks the paper;
4. the missing result is narrow and does not broaden the semantic object model.

Reviewer anticipation, aesthetic theorem packaging, arbitrary generalization, cost optimization, repair-graph extraction, runtime refinement, and new action kinds do **not** independently fire the trigger.

## Decision

```text
PRIMARY VENUE: iFS 2027 regular long paper
DEADLINE: 2026-10-15 AoE
FORMAL REOPEN: NO
NEXT WORK: LNCS/iFS-specific compression and artifact packaging
```
