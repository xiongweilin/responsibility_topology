# Q_open QO-2B D2 — Pharmacovigilance Negative-Control Audit

Status: **QO-2B_1 source-backed domain audit. Research only.**

Formal reopen: **NO**.

This audit applies the preregistered QO-2A elimination protocol to pharmacovigilance first because this domain is intentionally a negative control. The audit does not modify the QO-2A promotion criteria.

The interpretive discipline is hostile:

```text
If D2 appears to strongly support H1 or H2,
re-audit the representation before trusting the result.
```

The reason is structural: EU signal management is explicitly part of routine pharmacovigilance, while adverse-event reports and safety signals are explicitly weaker than causal conclusions.

---

## 1. Official source baseline

Primary native sources used here:

1. European Medicines Agency, **Signal management**:
   https://www.ema.europa.eu/en/human-regulatory-overview/post-authorisation/pharmacovigilance-post-authorisation/signal-management

   Native facts used:
   - safety signals may arise from spontaneous reports, clinical studies, literature, and other sources;
   - the presence of a safety signal does not itself mean the medicine caused the adverse event;
   - assessment determines whether a causal relationship exists;
   - evaluation of safety signals is part of routine pharmacovigilance;
   - PRAC recommendations may conclude no further evaluation/action is needed, more information is needed, or regulatory action is needed.

2. European Medicines Agency, **Guideline on good pharmacovigilance practices (GVP), Module IX — Signal management (Rev 1)**:
   https://www.ema.europa.eu/en/documents/scientific-guideline/guideline-good-pharmacovigilance-practices-gvp-module-ix-signal-management-rev-1_en.pdf

   Native facts used:
   - the signal-management process includes detection, validation, confirmation, analysis/prioritisation, assessment, and recommendation for action;
   - signal validation asks whether available documentation contains sufficient evidence of a new potentially causal association to justify further analysis;
   - a non-validated signal does not warrant further analysis at that point;
   - signal confirmation is not a full causal assessment and does not establish causality.

3. European Medicines Agency, **GVP Annex I Definitions, Rev 5 (2024)**:
   https://www.ema.europa.eu/en/documents/scientific-guideline/guideline-good-pharmacovigilance-practices-annex-i-definitions-rev-5_en.pdf

   Native fact used:
   - a confirmed signal requires further analysis/prioritisation but confirmation does not establish causal relationship.

4. U.S. Food and Drug Administration, **FDA Adverse Event Monitoring System (AEMS)**:
   https://www.fda.gov/safety/fda-adverse-event-monitoring-system-aems

   Native facts used:
   - existence of an adverse-event report does not establish causation;
   - report information may not be verified;
   - reports are nevertheless useful to FDA's ongoing monitoring of benefit-risk profiles.

The EMA material is the primary institutional model because it exposes the internal signal-management stages most clearly. FDA supplies an independent regulatory confirmation that report acceptance and causal acceptance are distinct uses.

---

## 2. Four-layer elimination model

The audit proceeds in the preregistered order.

### M0 — native domain vocabulary only

Native entities/process positions:

```text
adverse-event / suspected-adverse-reaction report
signal detection
signal validation
validated / non-validated signal
signal confirmation
confirmed signal
signal assessment
causal relationship / new risk
PRAC recommendation
regulatory action / no action / more information
```

Native role owners include:

```text
reporter / healthcare professional / consumer
marketing-authorisation holder
EMA / national competent authority
PRAC Rapporteur / lead Member State
PRAC
```

Nothing in M0 requires a new generic relation called `ChallengeStanding`.

### M1 — add use-indexed admissibility

Introduce only the rival analytical model:

```text
Admissible_K(e, use)
```

D2 immediately exhibits different evidence burdens by use.

A raw adverse-event report may be acceptable as:

```text
u_detection
  input to signal detection / ongoing monitoring
```

while being insufficient for:

```text
u_causal
  establishing that the medicine caused the event
```

Likewise a validated or confirmed signal may be admissible for:

```text
u_further_assessment
```

without being admissible as:

```text
u_established_causality
```

The native structure is therefore naturally represented by propositions of the form:

```text
Admissible_K(e, signal-detection)
and
not Admissible_K(e, causal-conclusion)
```

or:

```text
Admissible_K(signal, further-assessment)
and
not Admissible_K(signal, established-causality)
```

This is already a strong reduction of QO-1's unindexed `A_K(e)` notation.

### M2 — add ordinary ReviewTriggered

Add the ordinary native review/assessment relation:

```text
ReviewTriggered(item, stage)
```

Examples:

```text
validated signal
  -> further analysis

confirmed signal
  -> PRAC discussion / prioritisation / assessment

assessment outcome
  -> no further evaluation/action
     or request more information
     or regulatory action
```

These are not exceptional meta-level challenges to the pharmacovigilance admissibility regime. They are the ordinary signal-management pipeline defined by the regime itself.

### M3 — native relational residue after M2

Only facts not preserved by M2 may remain here.

Candidate native facts checked for residue:

```text
challenge targets the gate itself
an actor acquires a duty to answer the validity of the gate
an unresolved objection remains preserved against a prior finality claim
an earlier closure becomes formally qualified while ordinary use remains forbidden
review scope is bounded independently of ordinary signal workflow
```

For the source-backed D2 material audited here, no such additional native relation is required.

The review object is a suspected medicine-event association/new risk within an established pharmacovigilance process. Validation, confirmation, assessment, and recommendation are ordinary stages, not evidence that the rule defining those stages has itself become answerable.

Therefore:

```text
Delta_D2 = empty
```

for the H1/H2-specific gate-challenge/closure-defeater residue tested here.

This does **not** say pharmacovigilance can never contain a regime-level challenge. It says the selected native signal-management cases do not establish one.

---

## 3. Observable-preservation table

| Observable | M1 use-indexed admissibility | M2 + ordinary review | Residue needed? |
|---|---|---|---|
| target/gate | medicine-event association / signal stage identified | preserved | no |
| evidence use-position | detection vs validation vs causal assessment | preserved | no |
| challenger / decision owner / review authority | reporter/MAH/NCA/EMA/PRAC roles remain explicit | preserved | no |
| who acquires responsibility to respond | ordinary signal-management owner at each stage | preserved | no |
| review consequence | validate, confirm, assess, request information, no action, regulatory action | preserved | no |
| closure/finality consequence | no separate prior closure claim is shown to be defeasibly qualified merely by signal entry | preserved as ordinary workflow status | no H2 residue |
| scope | medicine/product-event association; sometimes product/class-specific | preserved | no special standing relation required |
| what remains forbidden despite review | causal conclusion is not licensed merely by report/signal/confirmation | preserved | no |

The final row is decisive. D2 natively supports:

```text
review/further assessment may proceed
while
causal conclusion remains unavailable
```

but this fact is fully expressible through different evidence uses and ordinary signal stages.

It therefore cannot by itself establish `ChallengeStanding`.

---

## 4. Mandatory case types

### N1 — ordinary anomaly that should NOT reopen

Case:

```text
one adverse-event report exists
report information may be unverified
causation is not established
```

Native treatment:

```text
report may enter monitoring/detection
```

but the report does not by itself establish:

```text
causal relationship
new safety risk
regime inadequacy
need to reopen the pharmacovigilance framework
```

QO reading:

```text
Anomaly / report visibility
-/->
ReopenEntitled
```

This is an ordinary negative case.

### P1 candidate — inadmissible for causal conclusion, but review-worthy

Case:

```text
validated or confirmed signal
```

Native treatment:

```text
requires further analysis / PRAC-level investigation
```

while:

```text
causal relationship is not yet established
```

At first glance this resembles:

```text
S_K(e,s) and not A_K(e)
```

Elimination result:

```text
Admissible_K(e, further-assessment)
and
not Admissible_K(e, causal-conclusion)
```

preserves the native facts without loss.

Therefore this candidate does **not** count as an H1 witness.

### N2 — serious-looking signal that should still fail further standing/action

Case:

```text
detected signal
```

whose validation finds that available documentation does not contain sufficient evidence to justify further analysis.

Native treatment:

```text
non-validated signal
-> further analysis not warranted at that point
```

This is stronger than saying “anything suspicious gets review standing.” The native regime has an explicit stage that rejects detected signals from further analysis when the evidence burden is not met.

A second native negative outcome occurs after assessment:

```text
PRAC may conclude no need for further evaluation or action at present
```

Thus serious appearance does not guarantee escalation.

---

## 5. H1 elimination audit

QO-2A H1 survival criterion:

```text
S_K cannot be eliminated without losing the gate-challenge role.
```

D2 result:

```text
ELIMINATED in the audited signal-management cases.
```

Reason:

```text
Admissible_K(e,use)
+
ordinary staged signal management
```

preserves:

```text
who submits/uses evidence
which stage receives it
what further analysis follows
what conclusion is still unavailable
who owns assessment
what product/event scope is under review
```

No source-backed fact requires the evidence to challenge the admissibility/closure rule that rejected it for causal use.

Domain-level finding for later QO-2C:

```text
D2 / H1: FAIL by use-indexed-admissibility elimination
```

This is not yet a cross-domain verdict on Q3.

---

## 6. H2 ReviewTriggered-collapse audit

QO-2A H2 asks whether replacing:

```text
ReopenEntitled
```

with:

```text
ReviewTriggered
```

loses a real closure-qualification fact.

D2 result:

```text
COLLAPSES in the audited signal-management cases.
```

EMA explicitly describes signal evaluation as routine pharmacovigilance. PRAC outcomes range from no further action, through information requests, to regulatory action.

The selected cases therefore show:

```text
ordinary monitoring/review is triggered
```

but do not show a previously established closure/finality claim becoming formally qualified solely because a signal entered the pipeline.

Domain-level finding for later QO-2C:

```text
D2 / H2: FAIL by ReviewTriggered collapse
```

A later domain may still provide a non-collapsible closure consequence.

---

## 7. H3 bounded-scope audit

Signals can be bounded by native identifiers such as:

```text
this active substance / medicinal product
this adverse event or related event set
this indication / strength / pharmaceutical form / route
possibly a whole product class
```

This supports a weak fact:

```text
scope bounding may precede final causal determination
```

However, the source-backed bound is largely supplied by the syntax and institutional data model of the signal itself.

The audit does not establish:

```text
unique causal localization
minimal adequate reopen scope
solution of Duhem-Quine underdetermination
```

Domain-level classification:

```text
D2 / H3: SYNTACTIC scope bounding only
```

---

## 8. Representation dependence

The D2 result is highly sensitive to distinguishing at least these use positions:

```text
reporting/detection
validation
confirmation
further assessment
causal determination
regulatory action
```

An unindexed `A_K(e)` would collapse these stages and create a false appearance of “inadmissible evidence gaining standing.”

D2 therefore forces the methodological correction:

```text
any surviving Q_open account must survive
Admissible_K(e,use).
```

But QO-2B does not yet modify the frozen QO-1 kernel. That modification, if warranted cross-domain, belongs to QO-2C.

---

## 9. Freedom reduction

Before D2:

```text
review trigger might count as challenge standing;
evidence insufficient for causal conclusion but review-worthy
might look like S_K and not A_K;
ReviewTriggered might be read as ReopenEntitled.
```

After D2:

```text
review does not imply standing;
insufficiency for one use plus admissibility for another use
does not imply standing;
routine signal assessment does not imply a closure defeater;
confirmation without causality is ordinary staged admissibility;
medicine-event scope can be bounded syntactically before causal localization.
```

The main freedom removed is:

```text
"cannot support conclusion but can trigger investigation"
```

is no longer admissible as evidence for H1.

The second freedom removed is:

```text
"enters review"
```

is no longer admissible as evidence for H2.

---

## 10. D2 audit result

The four-layer elimination sequence closes as:

```text
M0 native pharmacovigilance vocabulary
  -> M1 Admissible_K(e,use) explains differing evidence burdens
  -> M2 ordinary ReviewTriggered explains signal workflow
  -> M3 no H1/H2-specific gate-challenge residue identified
```

Record for later QO-2C only:

```text
D2/H1: FAIL by elimination
D2/H2: FAIL by ordinary-review collapse
D2/H3: SYNTACTIC scope bounding
Delta_D2: empty for the tested standing/closure residue
```

This is a successful negative-control result. It reduces Q_open freedom rather than supporting the theory.

Next preregistered audit: **D3 EPA participatory science — use-indexing attack**.

Formal reopen remains **NO**.
