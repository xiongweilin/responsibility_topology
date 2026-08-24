# Successor Formal Line Gate

Status: **NO SUCCESSOR FORMAL LINE AUTHORIZED**

This gate applies only after the completed P4/P5 meta-architecture experiment and the freeze-semantics clarification in `FREEZE_GOVERNANCE.md`.

Its purpose is to keep the repository challengeable without turning non-uniqueness into an obligation to generate alternative formal architectures.

## 1. SelectionProvenance is mandatory

Any proposed successor formal line `S` must first submit a pre-formal `SelectionProvenance(S)` answering all five questions:

```text
Why this problem now?
Why this decomposition?
Why this abstraction boundary?
Why this observable / bridge surface?
What evidence would make this choice lose priority?
```

A proposal that cannot answer all five remains an idea, not a research objective.

## 2. At least one independent trigger is required

A successor proposal must be grounded in at least one of the following externally discriminative triggers.

### T1 — new source-backed residual

```text
T1 = a new source-backed residual survives the strongest ordinary/native explanation
```

The residual must preserve descriptive, causal, normative, and counterfactual material facts and cannot be created merely by renaming an existing local mechanism.

### T2 — materially different formal consequence

```text
T2 = an alternative formalization produces a materially different theorem,
     verification boundary, or decision consequence
```

Presentation differences, naming changes, or equivalent API organization are insufficient.

### T3 — counterexample to current abstraction

```text
T3 = a concrete counterexample exposes a material limitation of the current abstraction
```

The counterexample must show a lost fact, unsound inference, missing admissible behavior, or materially wrong decision boundary—not merely an omitted convenience theorem.

### T4 — representation/equivalence evidence

```text
T4 = a representation, embedding, conservative translation, or equivalence result
     suggests a deeper common structure worth testing
```

This trigger may support either positive consolidation or a negative result showing that two apparent architectures are merely different presentations.

### T5 — runtime/product evidence changes bridge value

```text
T5 = runtime/product evidence makes a different observable or bridge surface
     materially more valuable for verification or safety decisions
```

A desire for broader coverage without a concrete decision consequence is insufficient.

## 3. No trigger means no successor formal work

```text
not (T1 or T2 or T3 or T4 or T5)
->
No successor formal work
```

In particular, these are not triggers:

```text
ArchitectureOptimality is not established;
Canonicality is not established;
PathUniqueness is not established;
A cleaner taxonomy can be imagined;
a reviewer might like a more symmetric theorem surface;
current papers use one successful historical lineage;
P5 found no architecture dominance;
more Lean coverage is technically possible.
```

## 4. Trigger grants only pre-formal competition

Even when a trigger is present:

```text
Trigger
-/-> Lean
```

The permitted sequence is:

```text
Trigger evidence
-> SelectionProvenance
-> pre-formal competing account(s)
-> hostile ordinary/prior-art absorption
-> explicit decision-difference audit
-> formalization entitlement decision
-> Lean only if independently earned
```

No candidate architecture is entitled to Lean merely by surviving taxonomy comparison.

## 5. Do not manufacture formal competitors for symmetry

The repository must not automatically stage a competition such as:

```text
Object -> Environment -> Change
vs.
Formation -> Qualification -> Revision
```

unless a real T1-T5 trigger has already produced a materially distinct candidate.

Formal architectures are competitors only when their difference changes theorem-relevant or decision-relevant consequences.

## 6. Formal-competition dimensions

If a successor candidate is genuinely triggered, compare it with the relevant baseline using the following dimensions. No scalar score is required.

### ExpressivePreservation

Does the candidate preserve all existing theorem-relevant distinctions and material facts that should survive translation?

### TheoremLeverage

Does it enable a nontrivial theorem or compositional result that the baseline cannot obtain without materially stronger assumptions or ad hoc encodings?

### AssumptionCost

What new external premises, guards, interpretation obligations, or adequacy assumptions are required?

### Transfer

Does the structure transfer to a genuinely new domain/problem without rewriting the native material facts into the candidate vocabulary?

### DecisionDifference

Does the alternative change a prediction, intervention, evidence requirement, withdrawal/revalidation rule, repair choice, admission boundary, or safe-action boundary?

### RepresentationRelation

Can the relationship between candidate and baseline itself be proved?

Permitted outcomes include:

```text
A embeds into B
A conservatively translates into B
A and B are equivalent on a restricted observable surface
A and B are presentation variants under a preservation theorem
A and B are genuinely incomparable
```

A representation theorem showing that two apparent architectures are equivalent or conservative presentations is a successful negative result and usually removes the need for a second lineage.

## 7. Kill conditions for a successor candidate

A candidate loses priority if any of the following occurs:

```text
strong native/prior-art absorption preserves all material facts;
no theorem/decision consequence differs from the baseline;
required assumptions erase the claimed gain;
the candidate needs ad hoc exceptions to preserve existing results;
a representation theorem shows it is only a presentation variant;
its proposed observable/bridge surface has no material runtime/product value;
its motivating residual disappears under better source reconstruction.
```

The proposal's own `SelectionProvenance` must state which of these or other concrete evidence would cause it to lose priority.

## 8. Current status

As of this gate's creation:

```text
SuccessorFormalLine: NONE AUTHORIZED
SelectionProvenance submissions: NONE
T1-T5 trigger: NONE ASSERTED BY THIS DOCUMENT
Lean reopening: NO
```

The completed P5 meta-audit itself is not a trigger. Its result—`No architecture dominance established` and `GlobalPartition: NOT EARNED`—supports continued challengeability but creates no successor-search obligation.
