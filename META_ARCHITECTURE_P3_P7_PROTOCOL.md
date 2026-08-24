# Meta-Architecture Audit — P3–P7 Competition Protocol

Status: **P3 CANDIDATES FROZEN / P4 PACKET READY / NO WINNER / NO BLIND RESULT YET**

This protocol follows the P0 informativeness pass, P1 corpus freeze, and P2 narrowing provenance audit. It deliberately allows the final result to be `A_null`, `No architecture dominance established`, or a governance pause.

## P3 — competing architectures

### A0 — current working architecture

```text
QX Representation Inadequacy
QC Provisional Shared Determination
```

Strength: already has evidence gates, negative controls, and established governance.

Risk: may be a useful working decomposition without being a complete map of open problems.

### A1 — QX/QC plus an unowned residual pool

```text
QX
QC
UnownedResidualPool
```

`UnownedResidualPool` has no constructors, theory vocabulary, or formal gate. It records only that a problem remains after ordinary decomposition but has no current owner.

Permanent rule:

```text
UNOWNED -/-> new track
```

### A2 — lifecycle-position architecture

```text
Genesis
Currentness
Revision/Constitution
```

Interpretive intent:

```text
Genesis:
  where distinctions, identities, admission bases, or mappings come from;

Currentness:
  when an already-formed object/basis remains usable under changed conditions;

Revision/Constitution:
  when dependency, evaluation, authority, or the governing structure itself must be revised/reconstituted.
```

A2 is not assumed disjoint or exhaustive. A case requiring multiple axes is allowed and counts as complexity cost.

### A_null — null architecture

```text
No small stable global decomposition.
Use local problem families + provenance + overlap.
```

A_null wins if global partitions add taxonomy without stable research consequences.

### A_D — data-driven candidate

`A_D` is intentionally **undefined at P3**.

It may be instantiated only after P4 blind outputs are collected without architecture hints. Creating `A_D` now would contaminate the blind test.

## P3 distinctness rule

Two architectures are merged if, on the frozen corpus, they induce the same:

```text
case admission;
prior-art neighborhood;
kill condition;
research priority;
```

up to renaming.

P0 already establishes that A0/A1/A2/A_null are not all research-equivalent. P3 therefore retains all four for hostile competition.

No superiority verdict is issued at P3.

---

# P4 — blind decomposition protocol

P4 produces **anti-path-dependence evidence only**.

It is not external reality evidence and does not establish statistical independence among evaluators.

## P4.1 Three blindness levels

### B1 lexical blind

Do not provide repository labels or the banned vocabulary used in P1.

### B2 historical blind

Do not provide prior QO/QX/QC outcomes, failed candidates, architecture history, or which cases have previously been studied.

### B3 architecture blind

Do not imply that a small taxonomy should exist. Explicitly permit:

```text
no stable small decomposition;
overlapping local families;
one-off mechanism-specific clusters.
```

## P4.2 Frozen evaluator prompt

Each evaluator receives only the raw EXO descriptions from `META_ARCHITECTURE_P1_CORPUS.md` and the following task:

> Group these problems only if the grouping changes what evidence should be collected, what neighboring literature should be checked, what would falsify the candidate explanation, or what intervention/research action should follow. Do not optimize for a small number of groups. Overlap is allowed. A valid answer may be that no stable small decomposition exists. For each proposed group, state the recurring failure distinction in domain-neutral language and one case that would falsify the grouping.

## P4.3 Required output schema

```text
GroupId
MemberCases
FailureDistinction
NativeFactsPreserved
PriorArtNeighborhood
KillTest
ResearchConsequence
CounterexampleToGroup
OverlapAllowed
```

Names are ignored during comparison. Structural reproduction means recurrence of the same failure distinction and research consequence.

## P4.4 Independence discipline

Outputs from the same model, prompt family, investigator, or shared hidden context must not be counted as statistically independent replications.

If only one evaluator source is available:

```text
P4 may prepare packets;
P4 may record one exploratory decomposition;
P4 may NOT claim independent convergence.
```

Current execution status:

```text
P4 packet: READY
P4 independent blind outputs: NOT COLLECTED
AntiPathDependenceEvidence: NOT YET ESTABLISHED
```

---

# P5 — out-of-sample hostile competition

P5 may begin only after P4 has at least one blind decomposition and at least one genuinely held-out source case not used to design A0/A1/A2.

## P5 dimensions

### Preservation

Does the architecture preserve descriptive, causal, normative, and counterfactual material facts?

### Discrimination

Does it send materially different cases to different evidence, prior-art, kill, or intervention paths?

### Out-of-sample stability

Does the architecture still work on held-out problems without rewriting them into its preferred vocabulary?

### Predictive consequence

Before seeing the full literature/result, does it identify what kind of neighbor is likely to absorb the candidate or what residual would remain if absorption fails?

### Complexity cost

Count architecture-specific exceptions, overlaps that require special repair clauses, ad hoc subtypes, and post-hoc reclassification.

## P5 partial order

No scalar total score is required.

```text
Ai > Aj
```

is permitted only when Ai:

```text
preserves at least as many frozen material facts;
produces strictly more stable discriminative/predictive consequences;
is at least as stable out of sample;
requires no more ad hoc machinery.
```

If tradeoffs remain incomparable:

```text
No architecture dominance established
```

is the required verdict.

If no global candidate stably beats A_null:

```text
GlobalPartition: NOT EARNED
```

---

# P6 — residual promotion gate

An unowned or recurring residual `R` is not promoted until all four gates pass.

```text
E(R): existence
I(R): irreducibility
A(R): abstraction-worthiness
D(R): decision consequence
```

### E — existence

The phenomenon is source-backed or otherwise reconstructible from real evidence.

### I — irreducibility

The strongest admissible ordinary/native explanation loses at least one frozen material fact.

### A — abstraction

The structure survives beyond a one-off mechanism-specific anomaly and is not reproduced solely by renaming.

### D — decision consequence

The extra distinction changes at least one of:

```text
prediction;
intervention;
evidence requirement;
withdrawal or revalidation;
repair choice;
safe-action boundary.
```

Only

```text
E && I && A && D
```

allows consideration of a generic track.

Otherwise preserve one of:

```text
mechanism-specific research;
cross-domain observation;
unowned but not promoted.
```

---

# P7 — stop and wake semantics

The governing separation is:

```text
ArchitectureUse
!= ArchitectureAdequacy
!= ArchitectureCompleteness
```

Allowed terminal states include:

```text
ArchitectureCompetition: NOT INFORMATIVE
```

or:

```text
CurrentWorkingArchitecture: QX/QC RETAINED
No identified defect currently justifies restructuring
ArchitectureAdequacy: NOT ESTABLISHED
ArchitectureCompleteness: NOT ESTABLISHED
```

or:

```text
CurrentWorkingArchitecture: RESTRUCTURING JUSTIFIED
Reason: stable out-of-sample unowned residual / superior competing partition
```

or:

```text
GlobalPartition: NOT EARNED
Use overlapping local problem families
```

## P7 meta-stop rule

This protocol may not spawn an `Architecture-Audit-Adequacy` object theory.

If P0–P7 governance is found defective, amend the protocol as a correction and record the changed premise. Do not create a recursive meta-theory merely to continue activity.

A resource/governance pause is allowed without architecture saturation. Any paused state must preserve explicit wake conditions and keep the reality hypothesis unresolved.

---

# Current checkpoint

```text
P0: AUDIT-WORTHY
P1: CORPORA FROZEN
P2: NARROWING PROVENANCE AUDITED
P3: A0/A1/A2/A_null FROZEN; A_D DEFERRED
P4: BLIND PACKET READY; INDEPENDENT EXECUTION NOT DONE
P5: BLOCKED ON P4 + HELD-OUT CASE
P6: NOT TRIGGERED
P7: ACTIVE STOP/Wake RULES
```

No QX/QC research-state verdict changes at this checkpoint. No new generic object, architecture winner, or Lean work is authorized.
