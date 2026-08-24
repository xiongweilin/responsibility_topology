# Meta-Architecture P4/P5 — Experiment Budget and Stop Rule

Status: **BUDGET FROZEN BEFORE EXECUTION**

This file prevents recursive expansion of the meta-audit after outcomes are known.

## 1. Maximum budget

The entire P4/P5 experiment is limited to:

```text
3 blind evaluator lineages
+ 2 held-out primary cases
+ 1 P5 adjudication
```

The two held-out cases are the deterministic `H_control` and `H_unknown` selections frozen in `META_ARCHITECTURE_HELDOUT_UNIVERSE.md`.

Reserve cases are replacement safeguards for preregistered source-viability failure only; they do not increase the two-case budget.

## 2. No automatic extension

The following do **not** authorize more evaluators, more cases, or another architecture:

```text
inconclusive result;
evaluator disagreement;
no architecture wins;
A_null performs well;
selected cases are boring;
preferred architecture performs badly;
A_D is empty;
R-U1/R-U2 do not recur.
```

No `A3` may be designed inside this experiment.

No “Architecture-Audit-Adequacy” research track may be opened.

## 3. Exhaustive allowed P5 verdicts

P5 must terminate with exactly one of:

```text
A0 retained as working architecture
A1 justified as better governance wrapper
A2 provisionally dominates
A_D provisionally dominates
A_null wins
No architecture dominance established
```

A verdict applies only to the preregistered evidence surface. None implies architecture completeness or search saturation.

## 4. Stop semantics

At experiment end:

```text
ArchitectureUse
!= ArchitectureAdequacy
!= ArchitectureCompleteness
```

A stop may be:

```text
governance/resource stop;
competition exhausted under fixed budget;
null/no-dominance verdict.
```

It may not be restated as:

```text
research-space decomposition complete;
no better architecture exists;
reality contains no further residual;
search saturation established.
```

## 5. Only legal wake condition after STOP

The experiment may be reopened only by a naturally occurring external case, not selected for this project, for which the currently retained architectures prescribe materially conflicting research actions and the difference has high practical or epistemic cost.

A legal wake record must identify before reopening:

```text
new case provenance;
why it was not selected for the prior experiment;
conflicting architecture decisions;
material consequence of the conflict;
why the prior two-case result cannot simply absorb the case.
```

A new clean taxonomy, renamed residual, additional theorem statement, or desire for more confidence is not a wake event.

## 6. Residual-development pause

Until the one P5 adjudication is completed:

```text
R-U1 active theory development: PAUSED
R-U2 active theory development: PAUSED
```

No dedicated literature-expansion program, candidate object, case hunt, or Lean work is authorized for either residual family.

## 7. Research-state boundary

This budget does not modify `RESEARCH_STATE.md`.

QX/QC remain the current working tracks under their existing evidence-gated status. The experiment is theoretical criticism/architecture comparison permitted under the closed theory-promotion gate; it does not itself authorize construction.
