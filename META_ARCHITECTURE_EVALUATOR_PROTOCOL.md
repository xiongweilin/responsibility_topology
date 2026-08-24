# Meta-Architecture P4/P5 — Blind Evaluator Protocol

Status: **PREREGISTERED / NO EVALUATOR OUTPUTS YET**

This protocol freezes evaluator provenance, pre-literature prediction, and data-driven architecture rules before blind outputs are collected.

## 1. Evaluator budget and provenance

Exactly three evaluator lineages may be used in this experiment.

For each evaluator `E_i`, freeze before revealing any other evaluator output:

| Field | Required record |
|---|---|
| evaluator ID | stable pseudonymous ID |
| investigator | person/process controlling the run |
| model or family | model/system name if applicable |
| prompt derivation | exact prompt origin/version |
| repository exposure | must be `none` for blind decomposition stage |
| architecture labels visible | `no` |
| other evaluator outputs visible | `no` |
| domain expertise | declared before evaluation |
| run timestamp | recorded |
| raw output hash | recorded after output freeze |

The experiment does **not** assert statistical independence.

Permitted language is only:

```text
DistinctEvaluatorLineages
```

and, if structure recurs:

```text
AntiPathDependenceEvidence
```

At least one lineage must not be merely the same model/family in another session. If that minimum cannot be met, P4 may still be run as a protocol stress test but cannot support the anti-path-dependence label.

## 2. Three-layer blindness

Each evaluator receives only the frozen native-language case packet.

Required blindness:

```text
lexical blind: no QX/QC/Q_open/Q_close/architecture labels;
historical blind: no repository narrowing/falsification history;
architecture blind: no instruction that a small global taxonomy should exist.
```

The prompt must explicitly permit:

> These problems may not admit a small stable global decomposition.

## 3. Mandatory decomposition output

For each proposed problem group, evaluator must provide:

```text
FailureDistinction
PriorArtNeighborhood
KillTest
ResearchConsequence
CounterexampleToGroup
PredictedAbsorber
PredictedResidualIfNotAbsorbed
DecisionBeforeLiteratureReveal
```

The evaluator must not merely name a category. `DecisionBeforeLiteratureReveal` must say what research action should occur before targeted literature/source investigation.

## 4. Prediction freeze order

For every held-out case and every candidate architecture considered at P5:

```text
raw case
-> architecture prediction
-> FREEZE prediction record
-> targeted prior-art/source investigation
-> outcome record
```

The pre-literature record must include:

```text
PredictedAbsorber:
  strongest expected ordinary/native theory or mechanism;

PredictedResidualIfNotAbsorbed:
  specific material fact expected to survive if the absorber fails;

DecisionBeforeLiteratureReveal:
  admit / hold / kill / route + expected research priority.
```

Post-hoc statements such as “this was really a currentness problem” do not count as predictive success unless the distinction and absorber were frozen beforehand.

## 5. Data-driven architecture `A_D`

`A_D` may be constructed only after all three blind outputs are frozen.

It may use only structural features from:

```text
FailureDistinction
ResearchConsequence
KillTest
PriorArtNeighborhood
```

It may not use repository architecture names as clustering features.

Construct an undirected graph `G = (V,E)` where each blind problem-group output is a node. Add an edge only when the adjudicator records all of:

```text
materially same failure distinction;
same or closely related evidence-acquisition consequence;
same or closely related prior-art neighborhood;
isomorphic kill condition;
same research consequence.
```

Clusters, if any, receive neutral names only:

```text
D1, D2, D3, ...
```

until P5 adjudication is complete.

If no stable cluster appears:

```text
A_D = empty
```

This is a valid result.

The adjudicator may not manually merge clusters because they “look like Genesis/Currentness/Revision.” Comparison of `A_D` with A0/A1/A2 occurs only after `A_D` is frozen.

## 6. P5 failure-mode matrix

Coverage percentage is prohibited as the main comparison.

For each architecture `A`, explicitly record evidence for these failure modes:

```text
FP_A  false positive:
      ordinary/native problem promoted into a deeper residual without necessity;

FN_A  false negative / owner loss:
      recurring material distinction repeatedly treated as unrelated one-offs;

MR_A  misrouting:
      wrong prior-art neighborhood or kill path chosen;

OC_A  over-complexity:
      extra exceptions/subclasses/clauses needed to preserve cases;

RL_A  rewrite loss:
      native descriptive/causal/normative/counterfactual facts must be rewritten or dropped to classify.
```

`A_null` also pays costs: repeated reinvention of the same prior-art/kill protocol counts toward `FN/MR/OC` as appropriate.

Architecture comparison remains a partial order. No scalar score is authorized.

## 7. P5 dominance rule

`A_i` may be called provisionally dominant over `A_j` only when the frozen evidence shows that `A_i`:

```text
preserves at least as many material facts;
produces at least as stable discriminative/predictive consequences;
performs at least as well on blind + held-out cases;
requires no more ad hoc machinery;
and is strictly better on at least one of these dimensions.
```

If architectures trade off without dominance:

```text
No architecture dominance established
```

is mandatory.

## 8. Promotion firewall

Blind recurrence cannot by itself promote a new research track.

Any residual candidate `R` still requires:

```text
E(R)  existence;
I(R)  irreducibility after strongest ordinary explanation;
A(R)  abstraction beyond one mechanism;
D(R)  decision consequence.
```

Only `E ∧ I ∧ A ∧ D` can authorize consideration of a generic track.

Permanent firewall:

```text
UNOWNED -/-> new track
blind convergence -/-> external truth
A_D cluster -/-> theory object
```
