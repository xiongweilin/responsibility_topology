# Responsibility Topology Research Roadmap

This roadmap is theory-level. It is not a constructor backlog.

## Unifying question

> **How can a finite system preserve historical structure while repeatedly re-establishing what may be relied on now?**

The current formal program advances through responsibility axes:

```text
Object -> Environment -> Change -> Regime -> Multi-agent regime
```

## 1. Object — Paper 1

Question:

> For one object, how are immutable historical formation and current qualification kept distinct?

Formal instance:

```text
historical warrant / parent identity
!=
state-indexed Usable
```

Core lesson: formation does not silently establish current usability; qualification does not replay all historical formation responsibility.

## 2. Environment — Paper 2

Question:

> When responsibility crosses contexts, which facts stay with historical objects and which must be re-established in the relevant environment?

Formal instances include:

```text
TRANSPORT historical formation
!=
source-indexed parent currentness
```

and:

```text
recorded Adopt provenance
!=
license BaseCurrent
!=
context Groundedness
```

Core lesson: cross-environment migration preserves some historical structure while current environment responsibility remains explicit.

## 3. Change — Paper 3

Question:

> When dependencies change, how can current responsibility be withdrawn and repaired without rewriting canonical history?

Formal instances:

```text
history continuity
!= currentness continuity
```

and:

```text
impact
!= selection
!= realization
!= represented-cut necessity
!= extraction completeness
!= execution
```

Core lesson: repair is meaningful only after separating what was affected, what is selected, what actually works, what cuts are necessary relative to a model, whether the model is complete, and how repair is executed.

## 4. Regime — Q_open

This is the next theory-level upgrade.

Question:

> **When is a finite system entitled to conclude that its current responsibility vocabulary, dependency cuts, or governing regime is itself insufficient?**

Paper 3 deliberately stops before this question. Given a repair model, it studies repair inside that model. `EveryRepairCutNecessary` does not establish no-missing-dependency completeness.

A future Q_open theory must avoid circular self-authorization. It should distinguish at least:

```text
anomaly / failure signal
!=
evidence that the current model is inadequate
!=
entitlement to reopen the model
!=
choice of replacement vocabulary
!=
validation of the reopened regime
```

The system must not gain authority to rewrite its responsibility regime merely because the current regime failed to produce a desired result.

## 5. Multi-agent regime — Q_close

Later question:

> How can responsibility be represented and discharged across heterogeneous agents without collapsing joint representation into joint responsibility completion?

Expected distinctions include:

```text
shared representation
!= distributed evidence ownership
!= authority to decide
!= responsibility discharge
```

This stage should follow, not precede, a clearer Q_open theory.

## Three cross-cutting research gaps

### A. Cross-domain invariance

Which structures are genuine invariants of Responsibility Topology and which are artifacts of the current epistemic kernel?

Candidate invariants should be tested by specialization into independent domains, not promoted from one formalization by analogy alone.

### B. Runtime / observational refinement

The formal kernel and `portable-runtime` need a future abstraction relation over selected observations, not literal state equality.

Candidate shape:

```text
alpha : RuntimeState -> FormalObservation
RuntimeStep(r,r') -> FormalStep* (alpha r) (alpha r')
```

The covered observation vocabulary and dependency policies must be explicit.

### C. Responsibility-model adequacy

This is the deepest gap. A system can be perfectly correct relative to a supplied responsibility model and still be wrong because the model omitted the decisive responsibility.

Therefore:

```text
correctness inside model
!= adequacy of model
```

and:

```text
verified refinement
!= adequate regime
```

## Stop rule

Do not reopen the formal kernel merely because a new constructor, optimization, or algorithm is available.

A new formal phase should begin only when it addresses a new responsibility axis or an indispensable bridge:

- cross-domain invariance;
- observational/refinement correspondence;
- Q_open regime adequacy;
- later Q_close distributed responsibility.

The research program should be measured by sharper responsibility boundaries and stronger bridges between them, not theorem count.