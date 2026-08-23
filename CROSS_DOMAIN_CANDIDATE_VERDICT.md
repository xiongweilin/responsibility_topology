# Cross-Domain Candidate Verdict — XDI-3

Status: synthesis of `CROSS_DOMAIN_FALSIFICATION_PROTOCOL.md` and `CROSS_DOMAIN_FALSIFICATION_MATRIX.md`.

This file does not establish a universal invariant. It decides only which formulations, if any, have survived enough heterogeneous-domain falsification to be called **candidate invariants** for the next research stage.

Discovery domains:

```text
D1  physical-operational
    FAA continued airworthiness / Airworthiness Directives

D2  normative-institutional
    U.S. federal acting authority / Appointments Clause defects

D3  empirical-scientific
    metrological traceability / calibration / measurement-process control
```

Software was deliberately excluded from discovery and remains a later regression sample.

---

# Decision summary

```text
I1 original: NOT PROMOTED
I2 original distinction: PROMOTED WITH NARROWED WORDING
I3 original: NOT PROMOTED AS WRITTEN
I3 higher-order reformulation: PROMOTED AS A SEPARATE CANDIDATE INVARIANT
```

No mechanism similarity is claimed. The strongest migration class established in XDI-2 is `formal similarity`.

---

# I1 verdict

Original candidate:

```text
persistent relation
!=
state-indexed current responsibility
```

## Verdict

`NOT PROMOTED — SPLIT REQUIRED`

The first half is too strong and too representation-dependent.

Across all three domains, the robust historical object was usually one of:

```text
retained record
historical act
historical measurement result
maintenance/compliance history
appointment/designation fact
traceability/calibration documentation
```

It was **not** consistently a still-existing operative relation.

D1 falsification:

- a superseded AD remains a historical regulatory artifact but is no longer in effect and has no current compliance requirements;
- therefore persistence of the historical record cannot be equated with persistence of the operative regulatory relation.

D2 falsification:

- a historical acting designation/service fact remains describable;
- current authority can terminate by statute;
- certain actions by an unauthorized acting official can have no force/effect and may not be ratified;
- therefore the operative authority relation itself cannot be assumed persistent.

D3 falsification:

- a measurement result and traceability documentation can remain recorded;
- present fitness for a purpose depends on uncertainty, process control, measurement model, and intended use;
- later out-of-control evidence does not automatically prove that every earlier result is invalid, so even the affected historical interval is an evidential question.

## Required split

The audit therefore separates:

```text
I1a  historical trace / act / record persistence

I1b  operative relation persistence
```

I1a has broad empirical support as an archival/audit pattern.

I1b does not.

## Why I1a is not yet promoted

Even record/trace persistence has high representation dependence. A domain can choose retention, expungement, sealed records, correction, data deletion, or non-event-sourced representations. The fact that the three selected domains preserve substantial audit history is not yet enough to call record persistence a domain-independent structural invariant.

## Consequence for the research program

The existing program slogan:

```text
persistent historical relation
!=
current responsibility
```

is safe as a description of the mechanized kernel papers but is **not** yet a cross-domain invariant.

For cross-domain work, use instead:

```text
historical trace / prior act / recorded derivation
may remain distinguishable from
current operative qualification
```

The modal `may` is deliberate.

## Representation-dependence verdict

`HIGH`

## Migration strength

`common problem -> formal similarity in selected cases`

## Candidate-invariant promotion

`NO`

---

# I2 verdict

Original candidate:

```text
dependency / impact
!=
repair / discharge responsibility
```

## Verdict

`PROMOTED WITH NARROWED WORDING`

All three domains preserve a non-trivial distinction between locating an affected object/condition and establishing what counts as sufficient discharge.

D1:

```text
unsafe condition / AD applicability
!=
acceptable compliance method
```

The AMOC mechanism is particularly strong evidence: an AD can specify one means of addressing an unsafe condition while an approved alternative provides a different acceptable means.

D2:

```text
authority defect / affected proceeding or act
!=
legally sufficient remedy
```

*Lucia* demonstrates that identifying the Appointments Clause defect did not itself constitute the remedy; a new hearing before a properly appointed official was required. FVRA consequences can differ by the function/duty and statutory conditions.

D3:

```text
out-of-control signal / affected measurement process
!=
adequate remediation
```

NIST guidance distinguishes repeat, discard, repair, recalibrate, and re-establish-control responses according to cause and measurement context.

## Narrowed candidate invariant CI-2

Use:

```text
CI-2:
Affectedness does not by itself constitute sufficient discharge.
```

Equivalent relational form:

```text
ImpactBoundary(x, delta)
!=
DischargeCriterion(x, delta, a)
```

where `!=` means that the two judgments occupy different responsibility positions, not that they are probabilistically or logically independent.

## Explicit boundary

CI-2 does **not** claim:

```text
impact never constrains discharge
multiple repairs always exist
repair is discretionary
no regime can prescribe a unique response
```

Some regimes prescribe a single mandatory response for a particular impact. The candidate survives because identifying the impact and satisfying the response remain different judgment/action roles even when a rule functionally determines the latter.

CI-2 would fail in a representation that defines `impact` to include complete successful discharge by construction. Such a representation must be treated as a possible ontology collapse, not silently counted as confirming evidence.

## Representation-dependence verdict

`MODERATE`

The three domains expose this separation in their native institutions/guidance, not only through imported terminology.

## Migration strength

`FORMAL SIMILARITY`

`MECHANISM SIMILARITY NOT ESTABLISHED`

## Candidate-invariant promotion

`YES — CI-2`

---

# I3 verdict

Original candidate:

```text
correctness inside model
!=
adequacy of model
```

## Verdict

`NOT PROMOTED AS WRITTEN`

The noun `model` and especially the word `correctness` fail cross-domain discipline.

D1 does not naturally speak of a maintenance AD as a “model.” The meaningful distinction is conformity with the currently governing safety-control regime versus whether later safety evidence shows that the regime requires strengthening or replacement.

D2 is the strongest falsifier. If `legal correctness` includes the entire hierarchy of constitutional/statutory law, then an agency procedure conducted by an unconstitutionally appointed officer was not legally correct in the first place. The candidate only makes sense after distinguishing **local/sub-regime procedural conformity** from **higher-order legal validity**.

D3 does not equate metrological traceability or verification with complete scientific correctness. VIM explicitly states that traceability does not ensure uncertainty adequate for a given purpose or absence of mistakes.

Thus the original wording hides three distinct lower-level notions:

```text
regulatory conformity
procedural/sub-regime conformity
traceability / specified-requirement conformance
```

and three distinct higher-order notions:

```text
sufficiency under safety evidence
higher-law validity
fitness-for-purpose / model-and-uncertainty adequacy
```

## Higher-order reformulation CI-3

A narrower relation does survive:

```text
CI-3:
Conformance within a represented regime does not by itself settle
higher-order adequacy, validity, or fitness of that regime for the purpose
for which it is being relied upon.
```

Abstract form:

```text
LocalConformance(R, x)
!=
HigherOrderEvaluation(R, x, purpose, evidence, authority)
```

The right-hand side is intentionally plural in interpretation:

```text
D1  safety sufficiency under continued-airworthiness evidence
D2  validity under higher legal authority
D3  fitness-for-purpose under uncertainty/model evidence
```

The candidate invariant is the **separation of evaluation levels**, not the claim that these domains use the same adequacy mechanism.

## Explicit boundary

CI-3 collapses if the chosen `LocalConformance` predicate is definitionally expanded to include all higher-order adequacy/validity/fitness obligations.

That collapse is representation-sensitive and must be reported, not treated as proof that no hierarchy exists.

CI-3 also does not answer:

```text
who may perform HigherOrderEvaluation
what evidence is admissible
what threshold justifies reopening R
what replacement regime should be chosen
```

Those questions lead directly toward `Q_open`.

## Representation-dependence verdict

`HIGH BUT STRUCTURALLY INFORMATIVE`

The distinction depends on representing an evaluation hierarchy. However, all three domains independently contain a native reason to distinguish lower-level conformance from a higher-order question.

## Migration strength

`FORMAL SIMILARITY`

`MECHANISM SIMILARITY NOT ESTABLISHED`

## Candidate-invariant promotion

`YES — CI-3, AS REFORMULATED`

---

# Candidate-invariant set after XDI-3

Only two formulations are promoted:

```text
CI-2  Affectedness does not by itself constitute sufficient discharge.

CI-3  Conformance within a represented regime does not by itself settle
      higher-order adequacy/validity/fitness of that regime for its relied-upon purpose.
```

The following is **not** promoted:

```text
persistent relation != current responsibility
```

because the cross-domain audit showed that historical **record/trace** persistence and operative-relation persistence must be separated.

No promoted candidate is universal.

---

# Implication for the Object -> Environment -> Change research narrative

The three papers remain coherent as a kernel-specific progression:

```text
Object -> Environment -> Change
```

because their formal state architecture intentionally preserves canonical history.

The cross-domain audit changes how that progression may be generalized.

Do not generalize as:

```text
All domains preserve history while current responsibility changes.
```

Use instead:

```text
The kernel papers instantiate a stronger history-preservation architecture.
Cross-domain evidence currently supports two weaker meta-separations:

1. affectedness vs sufficient discharge;
2. local conformance vs higher-order evaluation.
```

This is a narrower and more defensible research-program claim.

---

# Implication for REF-1 observation design

XDI-3 changes the proposed `alpha_0` surface before any refinement theorem is attempted.

The old draft dimension:

```text
persistent identity
```

must not be imported as a cross-domain assumption.

Replace it with two distinct observation questions:

```text
historicalTrace
operativeStatus
```

where `historicalTrace` records what prior identity/relation/action the runtime can expose, while `operativeStatus` records whether that prior object/relation remains current/operative under the selected observation semantics.

The initial REF-1 surface should therefore start from:

```text
historicalTrace
historicalDependency
operativeStatus / currentQualification
currentActivationUse
invalidationReview
impactObservation
dischargeRequalification
```

and explicitly record information loss and semantic mismatch for each coordinate.

The distinction introduced by CI-2 also requires that:

```text
impactObservation
```

and:

```text
dischargeRequalification
```

remain separate observation coordinates.

CI-3 should **not** be put inside the initial formal observation algebra as if the current Lean kernel already formalized higher-order adequacy. Instead REF-1 should record the regime/model identifier used by an observation and leave higher-order adequacy outside the bridge.

---

# Implication for Q_open

CI-3 sharpens but does not solve the next theory problem.

If local conformance and higher-order evaluation are distinct, the next question is not simply:

```text
Is R inadequate?
```

It is:

```text
What observations count as evidence that R may be inadequate,
and what makes an agent/system entitled to reopen R
rather than merely report an anomaly inside R?
```

The XDI results also expose two symmetric errors:

```text
false reopen
  local failure is over-interpreted as regime inadequacy

closure blindness
  the regime's own admissibility rules prevent evidence of its inadequacy
  from acquiring standing as reopen evidence
```

These belong to QO-1, not to the current formal kernel.

---

# Final XDI-3 decision

```text
Original I1:          FAILS PROMOTION / SPLITS
CI-2:                 CANDIDATE INVARIANT
Original I3:          FAILS PROMOTION AS WRITTEN
CI-3 reformulation:   CANDIDATE INVARIANT

Cross-domain level:   FORMAL SIMILARITY ONLY
Mechanism similarity: NOT ESTABLISHED
Universal invariant:  NOT CLAIMED
Software discovery:   NOT USED
Formal reopen:        NO
```

The next technical stage may define the REF-1 observation algebra. It must use the falsification-adjusted surface rather than copying the existing Lean state vocabulary wholesale.