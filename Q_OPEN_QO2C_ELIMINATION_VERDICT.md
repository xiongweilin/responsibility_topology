# Q_open QO-2C — Cross-Domain Elimination Verdict

Status: **QO-2 falsification verdict. Research only.**

Formal reopen: **NO**.

This checkpoint evaluates the three preregistered QO-2 domains after running the same elimination protocol in the fixed order:

```text
D2 pharmacovigilance
-> D3 EPA participatory science
-> D1 Federal Evidence Rule 103
```

The purpose was not to obtain three positive examples. It was to remove Q_open vocabulary wherever native domain structure could express the same facts without loss.

The primary rival was:

```text
Admissible_K(item, use)
```

plus ordinary review/decision routing.

The result is a substantial narrowing of the QO-1 problem kernel.

---

## 1. Domain results

| Candidate | D2 pharmacovigilance | D3 EPA participatory science | D1 Rule 103 |
|---|---|---|---|
| H1: independent standing relation needed | **FAIL** — eliminated by use-indexed admissibility + staged signal management | **FAIL** — eliminated by intended-use/graded-quality admissibility | **NARROW SURVIVAL** — `PreservedErrorClaim` remains after use-indexing and before actual review |
| H2: closure-defeater relation needed | **FAIL** — ordinary routine review is sufficient | **FAIL** — screening/supporting/further investigation is ordinary use/routing | **FAIL / NOT ESTABLISHED** — preservation for appeal does not itself suspend/reverse the ruling or establish a native closure qualifier |
| H3: bounded scope under non-unique diagnosis | **SYNTACTIC** | **SYNTACTIC/MIXED** | **SYNTACTIC/PROCEDURAL** |
| `A_K(e) -> A_K(item,use)` pressure | strong | **forced by native intended-use structure** | required to separate content, proffer, and appellate/error-preservation uses |
| nonempty `Delta_D` after M2 | no | no | yes: mechanism-specific preserved gate-answerability/error claim |

This table is the primary QO-2 result.

---

## 2. Freedom-deletion table

QO-2 is best understood as a sequence of freedoms that are no longer available.

### Before D2

It was still possible to treat:

```text
review trigger
```

as evidence for:

```text
ChallengeStanding
```

and to treat:

```text
insufficient for causal conclusion
but worthy of investigation
```

as `S_K(e,s) and not A_K(e)`.

### After D2

Delete:

```text
review -> standing
cannot support conclusion but can trigger investigation -> standing
routine review -> closure defeater
```

Pharmacovigilance natively supports:

```text
Admissible_K(e, signal/further-assessment use)
and
not Admissible_K(e, causal-conclusion use)
```

inside its ordinary signal-management pipeline.

### Before D3

Unindexed:

```text
A_K(e)
```

could still be treated as a useful generic descriptive baseline.

### After D3

Delete that freedom.

EPA's native structure directly ties data quality and documentation to intended use. A cross-domain account must therefore begin from something closer to:

```text
Admissible_K(item, use)
```

rather than a single unindexed acceptance predicate.

Also delete:

```text
screening/supporting use -> standing
further investigation -> closure defeater
site/pollutant scope -> adequate localization
```

### Before D1

A remaining hope was that a gate-directed review case would force both an independent standing relation and a closure defeater.

### After D1

The first half narrows but does not disappear completely.

Delete:

```text
excluded evidentiary content = offer/proffer = preserved claim of error
```

and delete:

```text
preserved appellate issue -> closure defeater
```

But retain the native observation:

```text
a claim of error directed at an exclusion ruling
can remain preserved for possible review
while the ruling remains operative
and the excluded evidence remains unavailable to the factfinder.
```

This is the sole nonempty `Delta_D` in the QO-2 sample.

---

## 3. Q3 does not survive unchanged

QO-1F froze:

```text
Q3: ChallengeStanding != ObjectAcceptance
```

QO-2 shows that this statement was still too coarse for cross-domain work because `ObjectAcceptance` was underspecified.

The forward analytical baseline must be use-indexed:

```text
Admissible_K(item, use)
```

The following is no longer an acceptable argument for a distinct standing relation:

```text
not admissible for use u1
but admissible/reviewable for use u2
therefore ChallengeStanding exists
```

That pattern is native ordinary structure in both D2 and D3 and is also necessary to model D1 correctly.

### Forward Q3 verdict

```text
Q3 as a generic cross-domain relation: NARROWS / NOT EARNED AS FORMAL OBJECT
```

What survives is weaker:

> use-indexed admissibility does not necessarily exhaust every gate-directed procedural relation.

D1 provides one witness:

```text
PreservedErrorClaim(party, ruling, record)
```

which is not merely another use permission for the excluded evidentiary content and can exist before appellate review is actually triggered.

However, one mechanism-specific witness is insufficient to generalize this residue as `ChallengeStanding`.

Therefore QO-2 does **not** rename `PreservedErrorClaim` into a new generic predicate.

---

## 4. H1 verdict — not promoted

The preregistered H1 survival test required a non-eliminable gate-challenge role.

Results:

```text
D2: eliminated
D3: eliminated
D1: one mechanism-specific residue survives
```

The correct cross-domain verdict is:

```text
H1: NARROWS / FAILS TO PROMOTE
```

This means:

```text
there is evidence that use-indexed admissibility can sometimes be insufficient,
```

but not enough evidence that a reusable cross-domain `ChallengeStanding` relation has been earned.

The QO-3 formal-reopen discipline therefore fails its positive threshold:

```text
at least two mechanism-distinct domains with structurally similar,
non-eliminable residual responsibility relations
```

were not found.

No additional domain should now be selected merely to search for a second positive case.

---

## 5. Q4 / H2 verdict — closure-defeater interpretation not earned

QO-1F froze the candidate:

```text
ReopenEntitled = bounded defeater of UnqualifiedClosure
```

QO-2 did not find a native witness that requires this generic relation.

### D2

Signal detection/validation/assessment is routine pharmacovigilance. Review may lead to no action, more information, or regulatory action.

No prior closure claim must be represented as defeasibly qualified merely because a signal enters review.

### D3

Screening/supporting/compliance-identification uses are ordinary graded data uses. They do not natively require a prior regulatory closure/finality claim to become qualified.

### D1

Rule 103 gives the strongest gate-directed case, but still establishes only:

```text
preservation of a claim of error for possible appeal/review
```

while the evidentiary ruling remains operative and the excluded evidence remains inadmissible to the jury.

The audit found no source-backed requirement to translate this procedural state as:

```text
not UnqualifiedClosure
```

rather than ordinary preserved reviewability/answerability.

### Forward Q4/H2 verdict

```text
H2: FAIL in the QO-2 sample
Q4 as a cross-domain positive relation: NOT EARNED
```

The conceptual distinction remains useful as a question, but QO-2 provides no basis to open a formal `ReopenEntitled` object around it.

Freeze the negative sentence instead:

```text
gate review / preserved gate challenge
-/->
closure defeater
```

---

## 6. H3 verdict — narrow but useful

All three domains support some form of scope bounding before full causal/legal diagnosis:

```text
D2: this medicine-event/product association
D3: this site/pollutant/project/program/use
D1: this ruling/evidentiary issue/ground
```

But these bounds are supplied mainly by native identifiers, procedural references, data models, or institutional routing.

Therefore QO-2 safely supports only:

```text
scope bounding may precede causal localization
```

and:

```text
bounded review does not require unique causal diagnosis
```

It does **not** support:

```text
unique minimal reopen scope
minimal adequate revision scope can always be identified
solution of general revision underdetermination
```

Cross-domain verdict:

```text
H3: NARROWS / SURVIVES ONLY AS PRE-LOCALIZATION SCOPE BOUNDING
```

---

## 7. Revised role of QO-1 Q1, Q2, and Q5

QO-2 primarily attacks Q3/Q4. The following methodological distinctions remain intact:

```text
Q1  Anomaly != InadequacyEvidence
Q2  InadequacyEvidence != ReopenEntitlement
Q5  correspondence/implementation/local-repair failure != RegimeInadequacy
```

Indeed D2 and D3 reinforce the importance of not promoting ordinary signals, screening results, or review triggers directly into regime-level conclusions.

But QO-2 does not convert Q1/Q2/Q5 into formal invariants.

---

## 8. The surviving research residue

After QO-2, the broad mother formulation:

```text
standing-to-challenge-the-gate
```

must be weakened.

The evidence now supports this more cautious question:

> When use-indexed admissibility and ordinary review/routing have already been modeled explicitly, do some domains still contain a distinct gate-directed responsibility relation — such as preserved answerability, objection, appeal eligibility, or unresolved challenge status — that cannot be eliminated without loss?

QO-2 answers:

```text
yes in one selected mechanism (Rule 103),
no in two selected mechanisms (pharmacovigilance and EPA participatory science).
```

This is not enough to posit a cross-domain formal relation.

The native D1 residue should remain native:

```text
PreservedErrorClaim / preserved gate answerability
```

until a second mechanism-distinct domain independently exhibits a structurally similar residue under the same elimination discipline.

---

## 9. QO-3 formal-reopen decision

The QO-3 gate remains closed.

Reasons:

```text
1. use-indexed admissibility eliminates H1 in D2 and D3;
2. only one mechanism-specific H1 residue remains;
3. H2 fails across all three selected samples;
4. H3 survives only in a weak syntactic/procedural form;
5. no generic positive entitlement rule has been earned.
```

Therefore do **not** formalize yet:

```text
ChallengeStanding
ReopenEntitled
ClosureEntitled
full K=(V,O,A,Q,D,R,C,G)
```

and do not search for additional domains merely to satisfy a numerical promotion threshold.

Formal reopen:

```text
NO
```

---

## 10. QO-2 final falsification verdict

```text
QO-2 falsification protocol: PASS
```

This means the falsification phase successfully reduced theoretical freedom. It does not mean the Q_open theory passed.

Forward status:

```text
Q1  retained as problem distinction
Q2  retained as problem distinction
Q3  NARROWED: unindexed ObjectAcceptance is underspecified;
    generic ChallengeStanding is NOT EARNED
Q4  NOT EARNED as cross-domain closure-defeater relation
Q5  retained as methodological firewall

H1  NARROWS / FAILS TO PROMOTE
H2  FAILS in selected sample
H3  NARROWS to scope-bounding-before-localization
```

The four strongest negative sentences earned by QO-2 are:

```text
review
-/-> standing

different admissibility by use
-/-> standing

gate review / preserved gate challenge
-/-> closure defeater

syntactic/procedural scope
-/-> adequate localization
```

The central representation correction is:

```text
A_K(e)
```

must no longer be used as the default cross-domain descriptive form when the native system distinguishes uses. Prefer:

```text
Admissible_K(item, use)
```

before asking whether any non-eliminable gate-directed residue remains.

---

## 11. Stop rule after QO-2C

Do not open Lean.

Do not immediately select three new domains.

Do not rescue `ChallengeStanding` by definition.

Do not rename D1's procedural residue into a generic relation.

The next legitimate theoretical move, if Q_open work later resumes, is a non-formal reinterpretation of the problem around:

```text
use-indexed admissibility
+
native gate-directed residual responsibility, when one exists
+
explicit review/finality consequence
```

Only after at least one additional mechanism-distinct residual survives the same elimination test should a new formal-object proposal be reconsidered.

Until then:

```text
Q_open broad theory: NOT EARNED
Q_open generic ChallengeStanding: NOT EARNED
Q_open generic closure-defeater relation: NOT EARNED
QO-3 formalization: BLOCKED
Formal reopen: NO
```
