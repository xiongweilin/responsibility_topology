# D4 Software Regression / Abstraction Preflight

Status: technical-consolidation research checkpoint. No Lean, Python, runtime, CI, or paper semantics are changed by this file.

Purpose: use software only as a **regression sample** after D1–D3 falsification. D4 does not participate in discovery of CI-2/CI-3 and does not increase their migration class beyond `FORMAL SIMILARITY`.

Formal regression target:

```text
D4F = current responsibility_topology kernel
baseline = db9e845cc2dbc33becf86d297236ff098553a83d
```

Runtime regression target:

```text
D4R = portable-runtime
baseline = 2dfa5b05dceeb61c4b3f0259f4dcac45e99613f6
```

The strict question is:

> Can the important responsibility boundaries already present in D4F and D4R be restated using only the falsification-adjusted abstractions CI-2 and CI-3, plus neutral observational distinctions, **without adding software/kernel-specific nouns to the generic vocabulary**?

A regression that requires `HistoricalWarrant`, `BaseCurrent`, `Grounded`, `RepairProblem`, `ChallengeStep`, `AuthorizationGrant`, `AffectedAssessment`, or other implementation-specific names as generic primitives fails.

---

## 1. Frozen inputs from XDI

Only the following cross-domain candidates are available.

### CI-2

```text
Affectedness does not by itself constitute sufficient discharge.
```

This is a separation of responsibility positions, not independence. A regime may uniquely determine a response from an impact.

### CI-3

```text
Conformance within a represented regime does not by itself settle
higher-order adequacy, validity, or fitness of that regime
for the purpose for which it is relied upon.
```

The higher-order mechanism is deliberately unspecified.

### Explicitly unavailable as a cross-domain invariant

```text
persistent relation != current responsibility
```

D4 may observe retained history and mutable operative status in software, but it must not promote that architecture back into a generic law.

---

## 2. Generic vocabulary permitted in D4

The regression is allowed to use only these neutral concepts.

```text
subject
change / challenge condition
impact observation
current or operative qualification
local conformance evidence
regime / policy reference
purpose reference
response / discharge requirement
selected response
discharge evidence
discharged judgment
historical trace (observational only)
```

`historical trace` is an observation family, not an invariant requiring every domain to retain history.

No software-specific structure is permitted in the generic definitions.

---

# 3. D4F — existing formal-kernel regression

The test deliberately describes the formal kernel first in generic vocabulary, then lists the concrete Lean witness only as an instance mapping.

## F1 — impact is not discharge

### Generic reading

A represented change/challenge condition can identify subjects whose current qualification is withdrawn or put under review. That impact observation does not itself provide a response that restores the selected target. Restoration additionally requires an explicit response-selection structure and evidence that selected responses actually restore the required current judgments.

This is an instance of CI-2:

```text
ImpactObserved(subject, change)
-/->
Discharged(subject, change)
```

### Concrete D4F witness

Instance-only names:

```text
Affected / challenge invalidation
RepairProblem / RepairSet
RepairRealization
RevalidationTrace / final refresh
```

The generic statement does not need any of those names.

### Regression verdict

`PASS`

No kernel-specific noun is required in the generic proposition.

---

## F2 — selected response is not successful discharge

### Generic reading

Selecting responses that cover all represented requirements is distinct from proving that those responses have been realized effectively. A response set can satisfy the selection criterion while restoration still depends on a separate realization certificate.

Generic decomposition:

```text
RequirementsCovered(selection)
!=
SoundRealization(selection, evidence)
```

and the current software instance supports a composition of the form:

```text
RequirementsCovered
+
SoundRealization
->
Discharged
```

This is a strengthening of the CI-2 architecture without making the strengthening cross-domain universal.

### Concrete D4F witness

Instance-only names:

```text
RepairSet
RepairRealization
RepairSufficiency
```

### Regression verdict

`PASS`

---

## F3 — local conformance is not higher-order adequacy

### Generic reading

The formal kernel checks exact local formation, qualification, activation, invalidation, and repair conditions under an explicitly represented vocabulary. None of those local conformance judgments determines whether the vocabulary, dependency cuts, or represented regime is adequate for the external purpose for which it is relied upon.

This is an instance of CI-3:

```text
LocalConformance(regime, subject)
-/->
HigherOrderAccepted(regime, subject, purpose)
```

### Concrete D4F witness

The kernel has many exact local checks and theorem-backed invariants, while Paper 3 explicitly externalizes repair-problem/extraction adequacy and REF-1 excludes higher-order adequacy from `O0`.

No new generic primitive such as `WarrantAdequacy` or `RepairCutComplete` is needed.

### Regression verdict

`PASS`

---

## F4 — historical retention is instance architecture, not generic law

### Generic reading

D4F happens to retain canonical historical objects while mutable qualification changes. D4 regression must describe this as:

```text
this instance exposes historicalTrace before/after
while operativeStatus changes
```

not as:

```text
all responsibility domains preserve historical identity
```

### Regression verdict

`PASS WITH FIREWALL`

The generic vocabulary needs only optional `historicalTrace`; it does not need a law that history is immutable.

---

# 4. D4R — portable-runtime regression

## R1 — impact detection is not response policy

### Generic reading

The runtime first records a structural impact observation. A separate policy interpretation chooses a required response. Therefore:

```text
ImpactObserved
!=
DischargeRequirement
```

This is a direct software instance of CI-2.

### Concrete D4R witness

Instance-only names:

```text
DependencyImpact
RiskAssessment
RevalidationDisposition
```

The runtime code explicitly states that `DependencyImpact` is an observed dependency impact and does not prescribe runtime action.

### Regression verdict

`PASS`

---

## R2 — required response is not discharge evidence

### Generic reading

A policy can say that a subject requires review, blocking, revalidation, or reopen without thereby proving that the required response occurred or succeeded.

Generic separation:

```text
DischargeRequirement
!=
DischargeEvidence
```

Concrete execution/revision/outcome records may later supply evidence, but the requirement itself is not that evidence.

### Concrete D4R witness

Instance-only names:

```text
RevalidationDisposition.action
RevisionRecord lifecycle
AuthorizationUse
ActionRecord / OutcomeRecord
ReopenPackage / HandoffEnvelope
```

### Regression verdict

`PASS`

---

## R3 — lifecycle/policy conformance is not regime adequacy

### Generic reading

The runtime can enforce typed authorization, lifecycle, version, dependency-policy, and handoff rules. Correct conformance to those represented rules does not by itself establish that the selected policy/vocabulary is adequate for the external purpose.

This instantiates CI-3 without requiring a software-specific notion of adequacy.

### Concrete D4R witness

Instance-only names:

```text
AuthorizationGrant validation
DefaultRevalidationPolicyProfile
record lifecycle validation
revision / reopen policy
```

The relationship contract already states:

```text
implementation correspondence
!=
responsibility-model adequacy
```

### Regression verdict

`PASS`

---

## R4 — historical use evidence is not current authorization

### Generic reading

The runtime retains evidence that a concrete use was authorized at an earlier observation time, while the associated grant can later expire or be revoked. D4 treats this as an instance observation:

```text
historicalTrace(use-at-time)
+
current operativeStatus(grant)
```

It does **not** promote the relation to a cross-domain invariant.

### Concrete D4R witness

Instance-only names:

```text
AuthorizationUse.authorized_at
AuthorizationGrant.valid_from / expires_at / revoked_at
```

### Regression verdict

`PASS WITH FIREWALL`

---

# 5. Regression against forbidden vocabulary leakage

The strongest D4 test is to delete all instance-specific names from the previous sections and ask whether the two candidates still describe the responsibility cut.

## CI-2 regression form

```text
1. observe impact on a subject;
2. determine one or more discharge requirements;
3. select a response;
4. supply evidence that the selected response was realized;
5. judge the represented requirement discharged.
```

Neither D4F nor D4R requires a generic concept named after a formal warrant, license, challenge constructor, runtime policy class, or repair hypergraph.

## CI-3 regression form

```text
1. identify the represented regime and purpose;
2. establish local conformance under that regime;
3. leave higher-order adequacy/validity/fitness as a separately sourced judgment;
4. do not infer the higher-order judgment from local conformance alone.
```

Again neither D4F nor D4R requires a generic software noun.

## Leakage verdict

`NO REQUIRED SOFTWARE-SPECIFIC GENERIC PRIMITIVE FOUND`

---

# 6. Failed abstraction candidates caught by D4

D4 rejects several tempting genericizations.

### Rejected A — universal historical immutability

```text
Every domain must preserve immutable historical identity.
```

Reason: already falsified by XDI representation dependence; software retention is only an instance design.

### Rejected B — generic transitive affected closure

```text
Impact is always target + transitive descendants.
```

Reason: D4R uses direct typed matching while D4F challenge impact uses transitive historical closure.

### Rejected C — generic repair hypergraph

```text
Every domain's discharge responsibility is a hitting-set problem.
```

Reason: Paper 3 uses that representation, but D4R does not expose the same generic repair structure and D1–D3 did not establish mechanism similarity.

### Rejected D — generic recursive groundedness

```text
Every current-use relation requires a recursively grounded issuer chain.
```

Reason: this is a Paper 2 formal specialization, not a cross-domain result.

### Rejected E — generic higher-order adequacy Boolean

```text
Adequate(regime) : Bool
```

Reason: CI-3 establishes only separation of evaluation levels; it does not define adequacy or Q_open standing.

These rejections are part of the D4 PASS, not weaknesses to erase.

---

# 7. Minimal abstraction surface justified after D4

D4 supports opening a new formal phase only for **two small independent calculi**.

## 7.1 Candidate core A — `ImpactDischargeCore`

The regression justifies only these roles:

```text
Subject
Change
ImpactEvidence
Requirement
Response
RealizationEvidence

Affected      : Subject -> Change -> ImpactEvidence -> Prop
Requires      : Subject -> Change -> Requirement -> Prop
ResponseCovers: Response -> Requirement -> Prop
Realized      : Response -> RealizationEvidence -> Prop
Discharged    : Subject -> Change -> Prop
```

The core should prove a generic composition theorem only after explicit premises connect coverage and realization to discharge.

It must also contain a finite countermodel showing:

```text
Affected
-/->
Discharged
```

without adding that conclusion as an interface law.

## 7.2 Candidate core B — `EvaluationLayerCore`

D4 justifies only:

```text
Subject
Regime
Purpose
LocalEvidence
HigherInput

LocalConformance : Regime -> Subject -> LocalEvidence -> Prop
HigherAccepted   : Regime -> Subject -> Purpose -> HigherInput -> Prop
```

The core must **not** define higher-order adequacy.

Its key machine result should be a finite countermodel / observational underdetermination statement, e.g. two evaluations with identical local-conformance observations but different higher-order verdicts.

CI-3 may not be inserted as a class law and then restated as a theorem.

---

# 8. D4 gate verdict

```text
D4F existing formal kernel: PASS
D4R portable-runtime:       PASS
Vocabulary leakage test:    PASS
CI-2 regression:            PASS
CI-3 regression:            PASS
Mechanism similarity:       NOT ESTABLISHED
Universal invariant:        NOT CLAIMED
```

Therefore:

```text
D4 GATE = PASS
```

The pass has a narrow meaning:

> The falsification-adjusted CI-2/CI-3 abstraction is not merely a renaming of the existing software/kernel vocabulary when regressed against both software targets.

It does **not** mean CI-2/CI-3 are universal, nor that one large domain ontology is justified.

---

# 9. Consequence

D4 authorizes the next technical step:

```text
XDC-1
  = two independent minimal domain-parametric calculi
  + finite countermodels
  + no refactor of Paper 1–3 modules
```

Formal opening is therefore allowed **only** under a new isolated namespace/module family. Existing paper semantic baselines remain frozen.

After XDC-1, REF-2 should make `O0` executable and discover the correspondence fragment `B0` from adapter outputs rather than preselecting it.
