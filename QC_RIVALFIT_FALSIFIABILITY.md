# QC-RIVALFIT-FALSIFIABILITY — One-Shot Method Audit

Status: **ONE-SHOT METHOD AUDIT COMPLETE**.

Formalization: **NO**.

Research-state invariant during this audit:

```text
QC: EVIDENCE-LIMITED / PRE-FORMAL
source-backed positive QC residuals: 0
Generic QC object: NOT EARNED
QC Lean: NO
```

This audit asks one question only:

> **Can `RivalFit` fail for principled, source-disciplined reasons, or can an analyst always erase any residual by inventing an ordinary-theory label, owner, contract, arbiter, or repair?**

It does not search for a new QC case and does not create a QC theory ladder.

## 1. Problem being audited

The existing evidence protocol already requires:

```text
RawSources
-> MaterialFactsFreeze
-> NativeDecomposition
-> RivalFit
-> SharedDeterminationExistenceGate
-> Residual
-> SharedRelianceConsequence
```

and says an ordinary rival must preserve:

```text
descriptive + causal + normative + counterfactual
```

material facts.

The remaining methodological risk is that terms such as:

```text
governance
contract
ownership
versioning
revocation
service responsibility
workflow
```

could be used as unconstrained explanatory vocabulary. If the analyst may freely posit a missing owner, contract, notification path, or authority that is not source-backed, then `RivalFit` becomes an absorption sink rather than a discriminative method.

## 2. Rival admission semantics

Freeze the meta-method predicate:

```text
RivalAdmissible(M, D)
```

where `M` is an ordinary/domain-native explanatory mechanism and `D` is a source-backed case after `MaterialFactsFreeze`.

A rival is admissible only if all six conditions hold.

### R1 — Native/recognized mechanism

```text
M is an existing domain-native mechanism,
recognized ordinary theory,
protocol rule,
institutional rule,
or established explanatory model.
```

The analyst may not create a bespoke relation whose only function is to eliminate the QC residual.

Failure examples:

```text
"shared-validity owner" invented only for this audit;
"distributed responsibility contract" with no domain analogue;
a renamed QC predicate presented as an ordinary rival.
```

### R2 — Source-instantiable path

`M` must instantiate to the actual case:

```text
actors;
objects;
authority path;
evidence path;
notification/revocation/revalidation path;
relevant state transition.
```

A generic theory that could explain a different institution does not eliminate this case unless its roles and transitions can be mapped to source-backed facts in `D`.

### R3 — Institution preservation

`M` must explain the institution that actually existed.

It may not repair the case by silently replacing the institution with a better-designed one.

Freeze:

```text
counterfactual repair
!=
explanation.
```

Examples that fail R3:

```text
"the parties should have introduced a central arbiter";
"they should have added a mandatory notification contract";
"a revalidation owner could have been appointed".
```

Those may be remediation proposals. They are not evidence that the actual case had no residual.

### R4 — No invented owner/authority/contract

`M` may not introduce case facts absent from the source record, including:

```text
owner;
contract;
arbiter;
notification duty;
revocation power;
shared-state update right;
common acceptance rule.
```

If the source only shows distributed local authority, the rival cannot postulate a hidden final authority to make the case disappear.

### R5 — Four-dimensional material-fact preservation

The rival must be scored against frozen facts across:

```text
DESCRIPTIVE
CAUSAL
NORMATIVE
COUNTERFACTUAL
```

It is not sufficient to explain the observed stale state while losing who was entitled to rely, who could revise, or what withdrawal/change would do to continued reliance.

### R6 — Case-specific failure exposure

The rival must produce at least one case-specific consequence that could fail under the frozen source facts.

Examples:

```text
if A owns revocation authority, source evidence should show an authority path from A to the relevant state;
if a notification mechanism explains continued reliance, the case should identify the notification relation and its expected consequence;
if versioning is sufficient, the actual version transition should preserve the observed authority/currentness/reliance facts;
if local policy composition is sufficient, the local policy outputs should account for the downstream divergence/convergence being explained.
```

A rival with no source-checkable consequence is rhetoric, not an eliminative explanation.

## 3. Fit vector

Freeze the output:

```text
Fit(M,D) = (
  F_desc,
  F_causal,
  F_norm,
  F_cf
)
```

Each component is one of:

```text
FULL
PARTIAL
FAIL
```

### `F_desc`

Does `M` preserve the material actor/object/state/transition description?

### `F_causal`

Does `M` explain the actual event/change/success/failure pathway rather than merely name a category?

### `F_norm`

Does `M` preserve the source-backed authority, obligation, permission, reliance entitlement, and revalidation responsibility structure?

### `F_cf`

Does `M` preserve the material counterfactuals fixed before decomposition, including what happens if an actor withdraws, changes qualification, fails to notify, or exercises revision authority?

Only:

```text
(FULL, FULL, FULL, FULL)
```

may support:

```text
M is sufficient for the frozen material facts of D.
```

Anything else leaves at least a method-level candidate residual for further source audit.

Important:

```text
(FULL, FULL, PARTIAL, PARTIAL)
```

is **not** sufficient merely because the mechanism explains the visible failure transition.

## 4. Falsifiability conditions

With R1–R6 and the fit vector, `RivalFit` has explicit failure modes.

A proposed rival fails if:

```text
not RivalAdmissible(M,D);
```

or if:

```text
Fit(M,D) != (FULL,FULL,FULL,FULL).
```

This is a genuine methodological rejection condition because an analyst cannot repair a failed rival merely by adding an unsupported owner, rule, authority, or redesigned institution: doing so triggers R3/R4.

The method therefore admits cases in which:

```text
all admissible ordinary rivals
have at least one PARTIAL or FAIL component.
```

If that occurs after `MaterialFactsFreeze`, ordinary decomposition has **not** eliminated the case. A residual may proceed to the later gates.

This statement does not assert that such a source-backed QC case currently exists.

## 5. Why synthetic fixtures are unnecessary

The second-line synthetic test is authorized only if the rule audit cannot determine whether `RivalFit` can fail.

That condition is not met.

The semantics above already make failure possible and auditable:

```text
R2 can fail because no source-instantiated path exists;
R3 can fail because the alleged explanation changes the institution;
R4 can fail because the rival invents authority/ownership facts;
R5 can fail on normative or counterfactual preservation even when description/causation pass;
R6 can fail because the rival has no case-specific empirical/institutional consequence.
```

Therefore:

```text
SyntheticFixture: NOT USED
```

and no synthetic object is added to the evidence corpus.

The permanent firewalls remain recorded anyway:

```text
SyntheticFixture notin QCEvidenceCorpus;
SyntheticPass -/-> PositiveQCResidual;
SyntheticFixture -/-> SourceBacked.
```

## 6. Existing controls under the stricter semantics

This audit does not reclassify prior cases, but the two most recent controls demonstrate why the distinction matters.

### RPKI

The ordinary rival is not merely the word `versioning` or `local policy`. It has a source-instantiated architecture:

```text
resource-holder authorization;
repository/currentness lifecycle;
RP-local validation/cache;
local trust-anchor/policy use;
operator-local routing action.
```

That mechanism can be assessed against actual actors and paths.

### DNSSEC delegation

The ordinary rival is not the remediation suggestion "assign a revalidation owner". The standards architecture already source-backs:

```text
child signaling;
parent-side DS update authority;
rollover/cache sequencing;
parental consistency checking.
```

Thus the owner/authority exists in the actual institution being explained.

These cases illustrate admissible rivals; they do not prove that every future case will have one.

## 7. Verdict

```text
QC-RIVALFIT-FALSIFIABILITY:
FALSIFIABLE / DISCRIMINATIVE AT THE EVIDENCE-METHOD LEVEL
```

Meaning:

```text
ordinary rival labels are not sufficient;
only source-instantiated admissible mechanisms may compete;
counterfactual repair cannot erase a residual;
fit is vector-valued rather than binary rhetorical judgment;
FULL on all four dimensions is required for eliminative sufficiency;
a future source-backed case can, in principle, defeat every admissible rival.
```

This does **not** mean:

```text
QC phenomenon has been shown to exist;
positive QC evidence exists;
RivalFit is a formal theorem;
the admissible rival set is globally complete;
QC theory is now earned.
```

## 8. Research-state consequence

No source-backed positive evidence was added.

Therefore:

```text
QC: EVIDENCE-LIMITED / PRE-FORMAL        [UNCHANGED]
source-backed positive QC residuals: 0   [UNCHANGED]
Generic QC object: NOT EARNED            [UNCHANGED]
ProvisionalSharedReliance: NOT EARNED    [UNCHANGED]
QC Lean: NO                              [UNCHANGED]
```

Only the evidence method is strengthened.

## 9. Stop rule

This audit creates no automatic next step.

Do not immediately acquire another QC case merely because `RivalFit` is now more constrained. A new case is admitted only when an independently source-viable event can reconstruct the required material-facts, shared-reliance, currentness, and authority timeline.
