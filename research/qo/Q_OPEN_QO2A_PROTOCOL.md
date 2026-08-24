# Q_open QO-2A — Domain Selection and Elimination-Test Protocol

Status: **QO-2A preregistration. Research only.**

This checkpoint does not run the domain audits and does not assign H1/H2/H3 verdicts.

Formal reopen: **NO**.

The purpose of QO-2 is falsification, not confirmation. The primary attack surface is now stricter than the QO-1 formulation:

```text
Could ChallengeStanding be eliminated by use-indexing ordinary admissibility?
```

The principal rival explanation is:

```text
A_K(e, u_review)
and
not A_K(e, u_ordinary)
```

rather than a genuinely role-distinct relation:

```text
S_K(e, scope)
```

If the rival explanation faithfully captures the native structure across the selected domains, QO-1 Q3 must narrow or fail. QO-2 must not protect `ChallengeStanding` by definition.

---

## 1. QO-2 target after QO-1F

The frozen QO-1 kernel remains the object under attack:

```text
Q1  Anomaly != InadequacyEvidence
Q2  InadequacyEvidence != ReopenEntitlement
Q3  ChallengeStanding != ObjectAcceptance
Q4  ReopenEntitlement = bounded defeater of UnqualifiedClosure
Q5  correspondence/implementation/local-repair failure != RegimeInadequacy
```

QO-2 focuses on three candidate relations:

```text
H1  standing without ordinary acceptance is genuinely needed
H2  ReopenEntitled has a closure consequence not reducible to ordinary review triggering
H3  bounded review scope can remain meaningful under non-unique diagnosis
```

The strongest new falsifier is directed at H1:

```text
UseIndexedAdmissibilityElimination
```

The second strongest is directed at H2:

```text
ReviewTriggeredCollapse
```

QO-2C may return:

```text
survives
narrows
splits
fails
```

for any H_i and may also narrow Q3 itself.

---

## 2. Rival model: use-indexed admissibility

Introduce only as an analytical competitor:

```text
Admissible_K(e, use)
```

where `use` denotes a decision or responsibility position in which evidence may be considered.

Examples of distinct uses include:

```text
ordinary adjudicative use
preservation of an error claim
signal detection
causal determination
screening
regulatory enforcement
meta-review of an admissibility rule
```

QO-2 does **not** yet replace `A_K(e)` in the frozen QO-1 kernel. Instead it asks whether the unindexed notation hid an already-native use distinction.

The rival explanation is successful when the native system can be represented without loss as:

```text
Admissible_K(e, u1)
not Admissible_K(e, u2)
```

and no additional role is needed for evidence to challenge the rule, authority, or closure boundary that determines admissibility itself.

---

## 3. H1 elimination test

QO-1 H1 is **not** promoted merely because evidence cannot support one conclusion but can trigger investigation.

For each domain, ask:

```text
Could S_K(e, scope) be eliminated by replacing it with
Admissible_K(e, u_review)?
```

### H1 fails by elimination if

all relevant facts are preserved by a native use-indexed admissibility relation, including:

```text
who may submit/use e;
what procedural gate receives e;
what consequence follows;
what review body or workflow receives it;
what ordinary conclusion e may not support;
what scope the review concerns.
```

If the supposed challenge simply enters another ordinary, already-defined pipeline, this is not evidence for a new `ChallengeStanding` relation.

### H1 survives only if elimination loses a substantive gate-challenge role

At minimum, the native structure must support a distinction of this form:

```text
ObjectAcceptance_K(e, u)
```

versus

```text
ChallengeStanding_K(e, scope)
```

where rewriting the latter as only:

```text
ObjectAcceptance_K(e, u_meta)
```

would erase at least one substantive responsibility feature, such as:

```text
- e challenges the gate/rule/authority that generated the ordinary rejection;
- the consequence is to keep that gate's closure claim answerable;
- the challenge owner or review obligation differs from ordinary evidence use;
- the challenge can remain live without e becoming ordinary evidence;
- the challenge concerns whether the admissibility structure itself is acceptable,
  not merely whether e belongs to another ordinary evidence class.
```

Freeze the survival criterion:

```text
S_K cannot be retained merely by naming a review use.
It survives only if eliminating it loses the gate-challenge role.
```

---

## 4. H2 collapse test

For each domain, replace the candidate concept:

```text
ReopenEntitled(K,e,scope)
```

with the weaker native concept:

```text
ReviewTriggered(K,e,scope)
```

Then ask whether any substantive fact is lost.

### H2 fails if

`ReviewTriggered` captures the full native consequence, for example:

```text
enter an ordinary monitoring queue
request more information
perform another routine assessment
open an ordinary appeal/review stage
route the item to an already-mandatory workflow
```

without changing the status of a prior closure claim.

### H2 survives only if

the native system requires a distinction equivalent in responsibility role to:

```text
closure may no longer be asserted in an unqualified form
while the challenge remains unresolved
```

This need not stop operation or reverse the challenged ruling.

A valid H2 witness may therefore have the shape:

```text
underlying action/ruling continues
+
challenge remains explicitly preserved/live
+
closure is no longer properly stated as uncontested/unqualified
```

QO-2 must not infer this merely from the existence of an appeal, assessment, or investigation.

---

## 5. H3 scope test

H3 asks whether bounded review responsibility can remain coherent without unique causal diagnosis.

The candidate safe conclusion is weaker than any localization theorem:

```text
scope bounding may precede causal localization
```

QO-2 must distinguish two possibilities.

### Substantive scope bounding

A review can be bounded because responsibility relations identify a meaningful challenged region even though the cause is unresolved.

### Syntactic scope bounding

The native procedure merely names an administratively convenient reference such as:

```text
this ruling
this medicine-event pair
this location/pollutant
this filing
this transaction
```

without solving revision-location underdetermination.

Syntactic bounding may still support operational review, but it is weaker evidence for a general Q_open scope principle.

QO-2C must not promote:

```text
minimal adequate reopen scope can always be determined
```

from examples that only establish bounded reference.

---

## 6. Fixed domain selection

QO-2A selects three domains with deliberately different native gate structures.

They are not chosen as positive examples. They are chosen because they are likely to pressure H1/H2 in different directions.

### D1 — Federal evidence: excluded evidence and offer of proof

Native source family:

```text
Federal Rules of Evidence, Rule 103
United States Courts
```

Current official rules page states that the Federal Rules of Evidence govern admission/exclusion in federal courts and were last amended in 2024.

Rule 103 distinguishes:

```text
ordinary admissibility/use in the proceeding
```

from preservation of a claim of error when evidence is excluded. If evidence is excluded, a party can inform the court of its substance by an offer of proof to preserve the error claim. Rule 103 also directs jury proceedings so inadmissible evidence is not suggested to the jury.

Why D1 is discriminating:

```text
- the same evidence may remain excluded from ordinary adjudicative use;
- a separate procedural role can preserve a challenge to the exclusion ruling;
- the challenged ruling may remain operative;
- the challenge need not turn the excluded item into admitted evidence.
```

Primary falsification question:

```text
Is offer-of-proof structure genuinely role-distinct standing to challenge the exclusion gate,
or is it fully representable as Admissible_K(e, use=error-preservation)?
```

H2 pressure:

```text
Does preservation of a claim of error actually defeat unqualified closure,
or merely preserve a later review right while the ruling itself remains final enough for the present proceeding?
```

No answer is preregistered.

Official sources for QO-2B:

- https://www.uscourts.gov/forms-rules/current-rules-practice-procedure/federal-rules-evidence
- Rule 103 materials from the U.S. Courts rule archive/current rule text.

### D2 — Pharmacovigilance: adverse-event reports and safety signals

Native source family:

```text
FDA Adverse Event Monitoring System (AEMS)
EMA signal management / PRAC safety-signal process
```

FDA explicitly warns that an adverse-event report does not establish causation and that report information may be unverified.

EMA explicitly states that a safety signal does not directly mean that the medicine caused the reported event. Signal assessment is part of routine pharmacovigilance and may conclude, among other outcomes:

```text
no further evaluation/action at present
additional information/analysis required
regulatory action required
```

Why D2 is discriminating:

The native regime already appears to distinguish use positions:

```text
report admissible for signal detection/assessment
!=
report sufficient for causal conclusion
```

Primary falsification question:

```text
Does any successful Q_open description add structure beyond
Admissible_K(e, signal-detection)
and
not Admissible_K(e, causal-conclusion)?
```

This domain is expected to be a serious negative control for H1 and H2.

A routine safety-signal workflow must **not** be counted as regime-level standing merely because it can trigger investigation.

Official sources for QO-2B:

- https://www.fda.gov/safety/fda-adverse-event-monitoring-system-aems
- https://www.ema.europa.eu/en/human-regulatory-overview/post-authorisation/pharmacovigilance-post-authorisation/signal-management
- current EMA PRAC signal recommendations/highlights where needed.

### D3 — EPA participatory science: graded data use

Native source family:

```text
EPA participatory-science quality assurance / QAPP guidance
EPA participatory-science FAQ and quality toolkit
```

EPA explicitly uses intended-use/graded-quality reasoning. Participatory-science data may support different forms of decision-making, including supplemental monitoring, permitting inputs, screening-level enforcement use, and other purposes. EPA guidance also states that organizations may require one data type for a decision while accepting other data as supporting information, and that data-quality planning should be appropriate to intended use.

Why D3 is discriminating:

This is the strongest direct pressure toward:

```text
Admissible_K(e, use)
```

rather than an unindexed `A_K(e)`.

Primary falsification question:

```text
When lower-tier/screening participatory-science data prompts compliance review or identifies an information gap,
is this only an ordinary admitted screening use,
or is there a distinct case in which the data challenges the adequacy of the data-quality/admissibility gate itself?
```

A screening use that merely enters the ordinary EPA workflow is **not** sufficient evidence for H1.

Official sources for QO-2B:

- https://www.epa.gov/participatory-science/frequently-asked-questions-participatory-science
- https://www.epa.gov/participatory-science/frequently-asked-questions-quality-assurance-project-plans
- https://www.epa.gov/participatory-science/quality-assurance-handbook-and-toolkit-participatory-science-projects

---

## 7. Required domain matrix for QO-2B

Each domain audit must populate all of the following fields before any verdict is assigned:

| Field | Required content |
|---|---|
| Native gate | What rule/process decides whether evidence may enter the relevant use position? |
| Native ordinary-use consequence | What may happen if evidence is accepted for ordinary use? |
| Native review/challenge consequence | What distinct review, preservation, investigation, or challenge consequence exists? |
| Positive standing candidate | Strongest source-backed candidate for a gate-challenge role |
| Ordinary anomaly that must NOT escalate | A source-backed or structurally native negative case |
| Serious-looking challenge that must FAIL standing | A challenge that appears important but still lacks the native burden for challenge/review |
| Use-indexed admissibility elimination | Can all relevant facts be captured by `Admissible_K(e,use)`? |
| Gate-challenge test | Does the evidence challenge the gate/rule itself, or merely pass through another gate? |
| ReviewTriggered collapse test | Does replacing `ReopenEntitled` with `ReviewTriggered` lose anything? |
| Closure consequence | Exactly what closure claim, if any, becomes qualified? |
| Scope bounding | How is review scope bounded without assuming unique causal diagnosis? |
| Scope type | substantive / syntactic / mixed |
| Representation dependence | Which conclusions depend on how evidence/use/gate/scope are represented? |
| Failure mode | What would make the candidate H_i fail in this domain? |
| Verdict | reserved for QO-2C: survives / narrows / splits / fails |

QO-2B may record observations but must not alter the promotion criteria in Sections 3-5.

---

## 8. Mandatory three-case pattern in every domain

Each domain must supply all three of the following.

### N1 — ordinary anomaly that should NOT reopen

Purpose:

```text
control false reopen
```

The case must show that an anomaly or failure can remain within ordinary lower-level processing.

### P1 — inadmissible-for-ordinary-use challenge that SHOULD receive review consideration

Purpose:

```text
stress H1
```

But this case counts for H1 only if it also survives the use-indexed-admissibility elimination test.

### N2 — serious-looking challenge that should STILL fail standing/review burden

Purpose:

```text
control flooding
```

The case must not be trivial spam if the native regime provides a stronger negative example. Prefer a plausible but insufficient challenge lacking provenance, materiality, scope, reliability, or required procedural posture.

A domain without all three case types cannot support a QO-2C promotion decision.

---

## 9. QO-2C promotion rules preregistered now

### H1 promotion

`H1 survives` only if at least one heterogeneous domain contains a source-backed gate-challenge role that cannot be eliminated into use-indexed ordinary admissibility without substantive loss, and the other domains do not show that the distinction is systematically unnecessary.

Possible results include:

```text
survives
  a genuinely role-distinct gate challenge remains necessary

narrows
  standing survives only for a subset of self-challenging gate cases

splits
  use-indexed admissibility handles ordinary review uses,
  while a separate challenge-standing relation is needed only beyond them

fails
  every successful case is fully captured by native use-indexed admissibility
```

If H1 fails broadly, Q3 must be revised. Do not preserve Q3 by definitional fiat.

### H2 promotion

`H2 survives` only when replacing `ReopenEntitled` with `ReviewTriggered` loses a native responsibility fact concerning qualification of a closure claim.

If all three domains expose only ordinary appeals, monitoring, or assessment workflows, H2 fails.

### H3 promotion

The strongest result QO-2 may earn without further theory is:

```text
scope bounding may precede causal localization
```

Do not promote:

```text
minimal adequate reopen scope always exists
unique minimal scope exists
bounded review solves revision underdetermination
```

---

## 10. Representation-dependence firewall

QO-2 must explicitly test whether apparent support is created by representation choice.

Particularly dangerous transformations are:

```text
- calling every review use a new standing predicate;
- calling every workflow state a closure state;
- calling every escalation a regime challenge;
- defining `use` so coarsely that self-challenge disappears;
- defining `use` so finely that every responsibility relation becomes ordinary admissibility;
- treating an appeal identifier or medicine-event pair as proof of unique diagnosis;
- treating source-specific procedural terminology as a cross-domain invariant.
```

A result is weak if it can be made to appear or disappear solely by relabeling the same native gate.

---

## 11. Hard kill criteria

QO-2 should narrow or retire the relevant part of Q_open if any of the following emerges across the audits.

### K1 — use-indexed elimination

```text
All apparent S_K cases are faithfully captured by Admissible_K(e,use).
```

Consequence:

```text
Q3 narrows or fails.
```

### K2 — review-trigger collapse

```text
All apparent ReopenEntitled cases are ordinary ReviewTriggered cases
with no additional closure qualification.
```

Consequence:

```text
H2 fails.
```

### K3 — gate non-challenge

```text
The evidence never challenges the rule that defines admissibility/closure;
it only enters another native pipeline.
```

Consequence:

```text
standing-to-challenge-the-gate lacks cross-domain support.
```

### K4 — scope illusion

```text
All bounded-scope examples rely only on syntactic identifiers
and provide no transferable responsibility structure.
```

Consequence:

```text
H3 narrows to a procedural observation only.
```

---

## 12. Source discipline

QO-2B should prefer primary official sources and must distinguish:

```text
native rule/process text
agency explanatory guidance
secondary interpretation
our abstraction
```

No domain conclusion should be inferred from a single slogan such as:

```text
"does not establish causality"
"screening level"
"offer of proof"
```

The audit must reconstruct the native gate, allowed use, review consequence, and negative cases from the source context.

QO-2A source check was performed against current official U.S. Courts, FDA, EMA, and EPA materials available in August 2026.

---

## 13. Frozen QO-2A checkpoint

Selected domains:

```text
D1  Federal evidence — excluded evidence / offer of proof
D2  Pharmacovigilance — adverse-event reports / safety signals
D3  EPA participatory science — graded data use
```

Primary falsification axes:

```text
F-A  Standing-vs-use-indexed-admissibility discrimination
F-B  ReopenEntitled-vs-ReviewTriggered collapse
F-C  Bounded-scope-vs-unique-localization discrimination
```

Frozen questions:

```text
Could S_K be eliminated by indexing A_K by use?
Does the challenge attack the gate, or merely pass through another gate?
Does ReopenEntitled add a closure consequence beyond ordinary review triggering?
Can scope be bounded without pretending causal localization is unique?
```

No H1/H2/H3 verdict is assigned here.

Next legitimate step:

```text
QO-2B — three source-backed domain audits under this fixed protocol
```

The promotion criteria above are not to be modified in response to intermediate QO-2B results.

Formal reopen remains:

```text
NO
```
