# Q_open QO-2B D1 — Federal Evidence Rule 103 Gate-Residue Audit

Status: **QO-2B_3 source-backed domain audit. Research only.**

Formal reopen: **NO**.

D1 is intentionally run last. D2 and D3 have already removed the following cheap interpretations:

```text
review -> ChallengeStanding                              [deleted]
different admissibility by use -> ChallengeStanding     [deleted]
ordinary review -> ReopenEntitled                       [deleted]
syntactic scope -> adequate localization                 [deleted]
```

Rule 103 is therefore not allowed to count as a Q_open positive merely because excluded material is represented in an offer of proof or because an appellate issue can be preserved.

The audit asks a narrower question:

> after use-indexed admissibility and ordinary review/appeal vocabulary are used as aggressively as possible, is there a native relational fact about the *ruling/gate itself* that remains unrepresented?

---

## 1. Official/native source baseline

Primary source:

1. United States Courts, **Federal Rules of Evidence**, current rules page:
   https://www.uscourts.gov/forms-rules/current-rules-practice-procedure/federal-rules-evidence

   The U.S. Courts page states that the Federal Rules of Evidence govern admission/exclusion in most U.S. court proceedings and that the Rules were last amended in 2024.

2. Federal Rule of Evidence 103, **Rulings on Evidence**, current text as reproduced in the U.S. Courts rules PDF and Legal Information Institute:
   https://www.uscourts.gov/sites/default/files/restyled_federal_rules_of_evidence.pdf
   https://www.law.cornell.edu/rules/fre/rule_103

Native Rule 103 facts used:

```text
Rule 103(a): a party may claim error in an evidentiary ruling only if a substantial right is affected and the specified preservation condition is satisfied.

For excluded evidence, the party ordinarily informs the court of the evidence's substance by an offer of proof, unless apparent from context.

Rule 103(b): once the court rules definitively on the record, the party need not renew the objection or offer to preserve the claim of error for appeal.

Rule 103(c): the court may state the character/form of the evidence, objection, and ruling, and may direct a question-and-answer offer.

Rule 103(d): in a jury trial, the court should prevent inadmissible evidence from being suggested to the jury, to the extent practicable.

Rule 103(e): a court may take notice of plain error affecting a substantial right even if the claim was not properly preserved.
```

The Advisory Committee material further explains that objections/offers of proof alert the judge to the alleged error and permit corrective measures; the 2000 amendment explains that a definitive ruling can preserve an appellate claim without ritual renewal.

These are procedural facts. QO-2B does not convert them into a theory-specific closure relation unless the native consequences require it.

---

## 2. Four objects that must not be collapsed

D1 requires four distinct objects/relations:

```text
E  excluded evidentiary content
P  offer/proffer that puts the substance of E on the record
R  evidentiary ruling excluding E
C  preserved claim of error concerning R
```

The following collapse is prohibited:

```text
E = P = C
```

A party can make an offer of proof precisely while the evidentiary content remains unavailable for ordinary jury use.

Likewise:

```text
preserving C
!=
reversing R
!=
admitting E to the factfinder
```

This separation is the central D1 calibration rule.

---

## 3. Four-layer elimination model

### M0 — native Rule 103 vocabulary only

Native positions:

```text
evidence admitted / excluded
objection / motion to strike
offer of proof
definitive ruling
substantial right
claim of error
preservation for appeal
plain error
jury insulation from inadmissible evidence
```

Native actors:

```text
party/proponent/opponent
trial judge
appellate/reviewing court
jury / factfinder
```

The rule is already explicitly relational: a claim of error concerns a ruling and is preserved by specified procedural acts.

### M1 — use-indexed admissibility

Aggressively apply:

```text
Admissible_K(item, use)
```

Distinguish at least:

```text
u_factfinder
  evidentiary content may be used by the jury/factfinder

u_trial-court-proffer
  the substance may be presented to the judge/record as an offer of proof

u_error-preservation
  the proffer/record may support preservation of a claim of error

u_appellate-record
  the preserved record may later be considered in appellate review
```

A typical exclusion case therefore permits:

```text
not Admissible_K(E, factfinder)
```

while allowing:

```text
Admissible_K(P, trial-court-proffer)
```

and, when Rule 103(a)'s burdens are met:

```text
P contributes to preservation of C for appellate use
```

This eliminates the naive H1 argument:

```text
"excluded evidence is somehow accepted after exclusion"
```

because the ordinary-use object and the proffer/error-preservation object are different.

### M2 — add ordinary review/appeal routing

Add ordinary procedural concepts:

```text
ReviewTriggered(ruling, appellate-stage)
AppealTaken(case)
ReviewEligible(claim)
```

This captures later appellate processing when it actually occurs.

But Rule 103(b) exposes an important timing distinction:

```text
a claim of error can be preserved now
without appellate review being triggered now.
```

A definitive ruling remains operative at trial while the issue is preserved for possible appellate review.

Therefore ordinary `ReviewTriggered` alone is not extensionally sufficient to represent the native state after preservation and before an appeal/review event.

### M3 — native residue after M2

A native residue remains:

```text
PreservedErrorClaim(party, ruling, record)
```

with the following observable combination:

```text
R remains the operative evidentiary ruling;
E remains unavailable for ordinary factfinder use;
C remains preserved against R for potential review;
no present appellate review need yet be triggered.
```

This is a genuine gate-targeting relation: the preserved claim is *about the ruling* that generated the ordinary exclusion.

It is not reducible to:

```text
Admissible_K(E, another use)
```

because the rule's preserved object is a claim of error directed at `R`, not merely a second use permission for `E`.

It is also not reducible to immediate `ReviewTriggered`, because preservation can precede any actual appeal/review invocation.

Record:

```text
Delta_D1 = PreservedErrorClaim / preserved gate-answerability relation
```

This is deliberately kept in native procedural vocabulary. QO-2B does **not** rename it `ChallengeStanding`.

---

## 4. Observable-preservation table

| Observable | M1 use-indexed admissibility | M2 + ordinary review | Native residue after M2 |
|---|---|---|---|
| target/gate | evidentiary ruling can be named | ruling can be review target | preserved claim is explicitly directed at that ruling |
| evidence use-position | factfinder vs proffer/record/appellate use distinguished | preserved | preserved |
| challenger / decision owner / review authority | party / trial court / future appellate court explicit | preserved | preserved |
| who acquires responsibility to respond | trial court is alerted; appellate court may later review if invoked | mostly preserved | claim remains review-eligible even before review is triggered |
| review consequence | not represented by use alone | appeal/review can be represented | preservation-before-review remains separate |
| closure/finality consequence | not represented | review route represented | no native automatic reversal or suspension of ruling is established |
| scope | this ruling / this evidentiary issue / stated ground | preserved | preserved |
| what remains forbidden despite challenge | excluded evidence remains inadmissible to jury/factfinder | preserved | preserved while claim remains live |

D1 is the first QO-2 sample with a nonempty `Delta_D` after M2.

But the residue is **preserved reviewability/answerability**, not yet a demonstrated bounded closure defeater.

---

## 5. Mandatory case types

### N1 — ordinary exclusion that should NOT produce a preserved gate challenge

Case shape:

```text
an evidentiary ruling excludes material
but no substantial right is affected
```

Rule 103(a) does not permit the party to predicate reversible error on the ruling merely because exclusion occurred.

Alternatively, where preservation requirements are not satisfied and no plain-error basis applies, the issue may not be preserved in the ordinary manner.

Therefore:

```text
exclusion / disagreement with ruling
-/->
preserved claim of error
```

This is an explicit native anti-flooding burden.

### P1 — excluded content remains forbidden, but error claim is preserved

Case shape:

```text
R excludes E;
a substantial right is implicated;
P informs the court of E's substance as required;
C is preserved for appeal.
```

Rule 103(d) still protects the jury from inadmissible evidence.

Thus these can coexist:

```text
not Admissible_K(E, factfinder)
+
PreservedErrorClaim(party, R, record)
```

This is the strongest D1 residual.

It survives the cheap use-indexing elimination because the second fact is a relation to `R`, not another ordinary use of `E`.

### N2 — serious-looking challenge that still fails the native preservation burden

A party may strongly disagree with an exclusion, but Rule 103(a) still requires a substantial-right effect and the appropriate preservation act unless an exception such as Rule 103(e) plain error applies.

The native regime therefore permits:

```text
serious disagreement
```

without automatically creating:

```text
preserved claim of error
```

Rule 103(e) is a useful boundary case: it shows that the system has an exceptional review channel for plain error rather than a universal rule that every unpreserved objection remains live.

---

## 6. H1 elimination audit

QO-2A H1 asks whether a purported `ChallengeStanding` can be eliminated without losing the gate-challenge role.

D1 result:

```text
USE-INDEXING ALONE DOES NOT FULLY ELIMINATE THE NATIVE STRUCTURE.
```

Reason:

```text
Admissible_K(E, factfinder)
Admissible_K(P, proffer/error-preservation use)
```

can distinguish evidence uses, but cannot by itself express:

```text
C is a preserved claim of error directed at R.
```

Adding ordinary `ReviewTriggered` still misses the pre-review state in which the claim is preserved but no appeal has yet been invoked.

Therefore a nonempty native relational residue remains.

However, the correct D1 finding is **not**:

```text
H1 = universal PASS
ChallengeStanding established as a generic relation
```

It is:

```text
D1/H1: NARROW SURVIVAL
residue = PreservedErrorClaim / gate-answerability relation
```

This is one mechanism-specific procedural witness. It must not be promoted to a generic formal object unless QO-2C finds structurally similar non-eliminable residue in at least another distinct mechanism.

---

## 7. H2 ReviewTriggered / closure-defeater audit

D1 initially looks promising for H2 because a claim of error can be preserved while the ruling remains operative.

But the native rule only establishes:

```text
preservation for appeal / reviewability
```

It does **not** state:

```text
the ruling is suspended;
the evidence becomes admissible;
the trial court loses authority to rely on the ruling;
a prior closure/finality claim is formally qualified in the Q_open sense.
```

Indeed Rule 103(d) presupposes continued enforcement of inadmissibility against the jury while the issue can be preserved.

Therefore the safe result is:

```text
D1/H2: NOT ESTABLISHED / FAILS AS A CLOSURE-DEFEATER WITNESS
```

The nonempty D1 residue is better described as:

```text
preserved reviewability / preserved gate answerability
```

than as:

```text
ReopenEntitled = not UnqualifiedClosure
```

This is an important negative result: **gate review does not imply closure defeat**.

---

## 8. H3 bounded-scope audit

Rule 103 can bound the preserved issue to native references such as:

```text
this evidentiary ruling
this excluded evidence/proffer
this stated ground
this affected substantial right
```

The bound does not require a causal diagnosis of why the legal error occurred.

Therefore D1 supports:

```text
scope bounding may precede full diagnosis
```

but largely through procedural reference and issue preservation.

Classification:

```text
D1/H3: SYNTACTIC/PROCEDURAL scope bounding
```

It does not establish a unique minimal revision scope or solve general underdetermination.

---

## 9. Representation dependence

D1 shows why both of the following are necessary:

```text
Admissible_K(item,use)
```

and a separate native relation for preserved challenge/reviewability.

The key representational correction is not:

```text
excluded evidence itself has standing
```

but:

```text
the system can preserve a claim directed at the exclusion ruling
while continuing to forbid the excluded evidence in the ordinary factfinder use.
```

This is more precise than QO-1's original unindexed `S_K(e,s) and not A_K(e)` shorthand.

The native relation concerns at least a tuple closer to:

```text
(party, ruling, proffer/record, ground, reviewability)
```

not merely an evidence item `e`.

This is another reason not to open Lean after QO-2B.

---

## 10. Freedom reduction

Before D1:

```text
a gate-review residue might be ordinary appeal;
excluded evidence appearing in review might look like standing;
preservation for appeal might be translated into closure defeat.
```

After D1:

```text
excluded content != proffer != preserved error claim;
use-indexed admissibility eliminates the "evidence re-enters" story;
ordinary ReviewTriggered does not capture preservation-before-review;
a genuine gate-targeting residue exists in this sample;
gate-targeting residue does not by itself establish closure defeat;
preserved reviewability does not imply reversal, admission, or operation stop.
```

The new hard sentence is:

```text
gate review / preserved gate challenge
-/->
closure defeater.
```

---

## 11. D1 audit result

The four-layer elimination closes as:

```text
M0 Rule 103 native procedure
  -> M1 use-indexed admissibility removes false "excluded evidence accepted" reading
  -> M2 ordinary appeal/review routing removes routine review semantics
  -> M3 nonempty residue: preserved claim of error directed at the ruling,
     live before any actual review need be triggered
```

Record for QO-2C:

```text
D1/H1: NARROW SURVIVAL as PreservedErrorClaim / gate-answerability residue
D1/H2: FAIL / NOT ESTABLISHED as closure-defeater witness
D1/H3: SYNTACTIC/PROCEDURAL scope bounding
A_K(e) -> A_K(item,use): required to avoid object/proffer conflation
Delta_D1: nonempty, mechanism-specific preserved-gate-challenge residue
```

This is the first nonempty `Delta_D` in QO-2, but it is only one mechanism-specific sample.

It does not earn QO-3 formalization by itself.

Next step: **QO-2C cross-domain elimination verdict and freedom-deletion table**.

Formal reopen remains **NO**.
