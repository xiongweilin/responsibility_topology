# QX — Candidate Kernel Preregistration

Status: **QX-3 preregistration. Research only.**

Formalization: **NO**.

No domain is selected at this checkpoint.

This file preregisters two candidate certificate shapes only because QX-2 left one narrow prior-art residual:

> **Can a finite system obtain a task-relative certificate that its current distinction space is insufficient when it does not already possess a correct finer representation, a complete concrete-state oracle, or a diagnostic that simply defines the desired refinement?**

The goal of the next phase is to kill these candidates, not to protect them.

Allowed later verdicts are only:

```text
ELIMINATED
DOMAIN-SPECIFIC
SURVIVES WITH EXACT RESIDUAL
```

Promotion criteria may not be relaxed after domain evidence is observed.

---

## 1. Shared preregistration discipline

Both candidates must satisfy the same four constraints.

### P1 — independent certificate provenance

The evidence source used to indict the current representation must not be generated solely by the candidate refinement whose necessity it is supposed to establish.

Prohibited circular pattern:

```text
invent finer representation V'
-> V' distinguishes x and y
-> define the distinction as task-relevant
-> conclude V was inadequate
```

### P2 — failure localization

The evidence must survive explicit alternatives such as:

```text
observation / measurement error
implementation nonconformance
parameter error
wrong dynamics
ordinary partial observability
unknown-class encounter
model-class misspecification
task-specification error
existing but unused memory/history/context
```

The candidate need not uniquely diagnose the cause, but it cannot call every unresolved anomaly representation insufficiency.

### P3 — weak conclusion only

No candidate may conclude more than the evidence supports.

Allowed conclusion shape:

```text
current represented space is insufficient for task T
relative to the stated certificate/evidence conditions
```

Not allowed:

```text
which distinction is missing
which refinement is correct
revision is authorized
the whole regime failed
reality contains no explanation in the current scientific sense
```

### P4 — nontriviality

A candidate is killed if its “theorem” would only expand definitions after the witness has already encoded the desired conclusion.

The research burden is the certificate source and its interpretation, not elementary function extensionality or finite enumeration.

---

# 2. Candidate A — task-relevant aliasing with independent accountability witness

## 2.1 Conceptual shape

Use only as an analytical template:

```text
alpha_V : X -> V
alpha_V(x) = alpha_V(y)
```

Assume a separately justified task/accountability source requires incompatible responses for `x` and `y`.

A policy restricted to the current representation has shape:

```text
pi : V -> A
```

or otherwise factors only through `V` for the relevant decision.

Then the elementary pressure is:

```text
alpha_V(x) = alpha_V(y)
-> pi(alpha_V(x)) = pi(alpha_V(y))
```

while the accountability witness requires responses that cannot both be satisfied by one action/determination.

Safe candidate reading:

```text
V is insufficient for task T under this independently sourced witness.
```

This elementary incompatibility is **not** the research novelty.

## 2.2 Hard obligation A1 — accountability-witness provenance

The candidate survives only if the task-relevant incompatibility is justified without assuming the desired refinement.

Admissible provenance types may include, subject to later domain audit:

```text
independently governed safety or legal requirement;
separately measured downstream outcome requirement;
externally maintained task specification;
heterogeneous second system whose local distinction is independently operationalized;
intervention or counterfactual evidence that forces incompatible response obligations;
repeated concrete failures under the same represented state where the relevant response conflict is independently verifiable.
```

None is automatically accepted.

A domain audit must state exactly why the witness is independent enough for the claim being made.

## 2.3 Required observables for Candidate A

A future domain audit must record at least:

```text
A-OBS1  identity of the two situations/case classes under study;
A-OBS2  their current represented images under V;
A-OBS3  evidence that the relevant decision path actually factors through V;
A-OBS4  source of the task/accountability requirement;
A-OBS5  exact response incompatibility;
A-OBS6  why the incompatibility source does not already supply the correct refinement;
A-OBS7  existing memory/history/context channels that might distinguish the cases;
A-OBS8  alternative lower-level explanations considered;
A-OBS9  exact scope of the insufficiency conclusion.
```

If these observables cannot be obtained without reconstructing a hidden ground-truth state space, Candidate A is not earned.

## 2.4 Candidate A kill tests

### A-K1 — refinement-generated witness

Kill if:

```text
the only reason x and y “require different responses”
is that the proposed V' labels them differently.
```

### A-K2 — complete-ground-state oracle

Kill as QX evidence if the case assumes a complete concrete state model that already gives the relevant distinction and ordinary abstraction refinement fully explains the failure.

Such a case may be valid CEGAR/state-aggregation evidence but is weak QX evidence.

### A-K3 — hidden existing channel

Kill if the system already represents a usable distinguishing signal in:

```text
history
memory
context
metadata
confidence
provenance
another current feature
```

and the failure is merely that the current policy ignored it.

Then the issue is policy/implementation, not insufficiency of `V` as actually available to the task.

### A-K4 — compatible responses after all

Kill if the allegedly incompatible obligations can be simultaneously satisfied by one allowed response, including a conservative/abstaining/defer action already available to the task.

### A-K5 — task-specification instability

Kill if the conflict disappears once the relied-upon task is stated correctly, or if the “independent” accountability specification is itself the disputed object and has no stable external responsibility source.

### A-K6 — ordinary partial observability

Kill or classify DOMAIN-SPECIFIC if the issue is adequately represented by a standard POMDP/belief-state/history augmentation problem with a known observation model and no residual certificate issue.

### A-K7 — ordinary model misspecification

Kill if held-out/model-criticism machinery establishes only that a predictive model is wrong but does not discriminate representation insufficiency from parameters/dynamics/model-class error.

### A-K8 — definition expansion

Kill the formal candidate if the proposed theorem assumes a premise equivalent to:

```text
no V-factored response can satisfy T
```

and then concludes the same statement under a new name.

## 2.5 Candidate A promotion rule

Candidate A may survive QX domain kill only if at least one source-backed domain provides all required observables and the accountability witness remains non-circular after A-K1–A-K8.

One surviving domain would justify only:

```text
mechanism-specific certificate candidate
```

not a generic theorem family.

A later formal opening would require additional mechanism-distinct evidence or a stronger reason why the certificate source is representation-independent in the relevant sense.

Current priority:

```text
PRIMARY CANDIDATE
```

because it directly addresses task-relevant distinction insufficiency, but it has the highest oracle/circularity risk.

---

# 3. Candidate B — finite represented-candidate exhaustion

## 3.1 Conceptual shape

Let the system's **current represented candidate set** for a task-relative explanatory/decision problem be explicitly finite:

```text
H_V = {h1, ..., hn}
```

Let `C` be an independently justified test/constraint family.

Suppose:

```text
forall h in H_V, Fail(h, C)
```

Safe conclusion:

```text
current represented candidate set H_V is exhausted relative to C.
```

This is elementary finite reasoning.

QX interest exists only if `H_V` is genuinely generated by/currently expressible in `V` and the exhaustion can be interpreted as evidence that the current distinction/candidate space is insufficient for task `T`.

## 3.2 Hard obligation B1 — criterion provenance

`C` must not be chosen after seeing the failures merely to reject the represented set.

The audit must record:

```text
who/what owns C;
why C is task-relevant;
when C was fixed;
what evidence supports C;
which parts of C depend on V;
which parts are independent of V.
```

If `C` is simply a restatement of a withheld hypothesis outside `H_V`, the candidate is circular.

## 3.3 Hard obligation B2 — represented-set exhaustiveness

The audit must establish that `H_V` is in fact the current candidate space relevant to the claim.

Prohibited shortcut:

```text
test three convenient hypotheses
-> all fail
-> call the represented space exhausted
```

The finitude must be operationally meaningful: there must be a justified enumeration boundary.

## 3.4 Required observables for Candidate B

A future domain audit must record at least:

```text
B-OBS1  definition of V and how it induces/limits H_V;
B-OBS2  complete enumeration argument for H_V relative to the task;
B-OBS3  provenance and precommitment status of C;
B-OBS4  failure evidence for each h in H_V;
B-OBS5  common-mode implementation/data/test failures ruled out;
B-OBS6  whether a noncommittal/unknown candidate already exists inside H_V;
B-OBS7  exact conclusion supported by exhaustion;
B-OBS8  why the result is about representation/candidate-space insufficiency rather than only one model family.
```

## 3.5 Candidate B kill tests

### B-K1 — fake exhaustiveness

Kill if `H_V` is only a sampled subset, convenience list, or externally selected benchmark rather than the current represented candidate set relevant to the task.

### B-K2 — post-hoc criterion

Kill if `C` is defined after the failures or from an excluded alternative in a way that guarantees rejection.

### B-K3 — common-mode test failure

Kill if all candidates fail because of:

```text
measurement bug
data corruption
implementation bug
bad simulator
miscalibrated threshold
incorrect shared assumption
```

rather than because the represented candidate set lacks a task-satisfying possibility.

### B-K4 — decorative finitude

Kill as a distinct QX candidate if finiteness contributes no exhaustive certificate and the same argument would be unchanged over an unspecified/infinite model class.

### B-K5 — ordinary model-class rejection

Classify ELIMINATED or DOMAIN-SPECIFIC if standard model criticism/model selection already captures the whole evidential role and no representation-specific conclusion remains.

### B-K6 — hidden catch-all candidate

Kill if the system already contains a valid `other/unknown/defer` candidate that satisfies the task requirement at the relevant level, so the claimed exhaustion over named hypotheses is not actually task-level exhaustion.

### B-K7 — illegitimate world-level conclusion

Kill the claim if the audit upgrades:

```text
H_V exhausted relative to C
```

into:

```text
reality has no explanation
```

or identifies a specific missing distinction without additional evidence.

### B-K8 — no link from H_V to V

Kill as a representation-inadequacy candidate if the exhausted model/hypothesis set is merely one modeling choice and is not shown to express the relevant current limitation of the system's distinction space.

## 3.6 Candidate B promotion rule

Candidate B survives only if a source-backed domain makes finiteness genuinely evidential:

```text
current represented set is enumerable;
the enumeration is complete for the relevant task position;
C is independently justified;
all candidates fail;
ordinary common-mode explanations are controlled;
the conclusion remains only candidate-space exhaustion / representation insufficiency relative to T.
```

Current priority:

```text
SECONDARY CANDIDATE
```

because it makes finitude substantive, but it is at high risk of collapsing into ordinary finite model-class rejection.

---

# 4. Candidate comparison

| Dimension | Candidate A: aliasing + accountability witness | Candidate B: finite exhaustion |
|---|---|---|
| Why finiteness matters | not essential to the elementary aliasing contradiction | potentially essential to exhaustive rejection |
| Main research burden | independent accountability-witness provenance | independent criterion + real enumeration boundary |
| Main prior-art threat | state aggregation, POMDPs, CEGAR | model criticism, model selection, finite hypothesis testing |
| Main circularity risk | post-hoc Resp distinction supplied by proposed refinement | post-hoc C or artificially restricted H_V |
| Safe conclusion | V insufficient for T under witness | current H_V exhausted relative C; maybe V insufficient only with extra link |
| Correct-refinement knowledge required? | must be NO | must be NO |
| Current priority | primary | secondary |

The candidates are not to be merged into one theorem merely because both concern insufficiency.

---

# 5. Domain-kill protocol preregistration

QX-4, if executed, must test A and B separately.

For each selected domain and each candidate:

```text
Native task vocabulary
Current representation / candidate space
Certificate source
What the system actually observes
What is independently specified
Alternative ordinary explanation
Oracle/refinement dependence
Conclusion supported
Kill-test result
Residual, if any
```

The domain audit may not change A-K1–A-K8 or B-K1–B-K8 after seeing results.

The audit must actively search for:

```text
one case that looks like representation insufficiency but is only policy/implementation error;
one case that looks like a certificate but depends on a hidden correct-refinement oracle;
one case in which a candidate genuinely survives, if such a case exists.
```

A domain with only supportive examples is not a valid QX-4 domain.

---

# 6. Domain selection is intentionally deferred

QX-3 does **not** select domains.

Domain selection must be driven by discriminating power against the preregistered kill tests, not by narrative fit.

In particular, do not select a domain merely because it contains:

```text
unknown classes
coarse categories
unexpected failures
ontology change
model revision
```

Those properties were already absorbed by prior art in QX-2.

---

# 7. Formal gate remains closed

Preregistration does not authorize Lean.

Do not formalize:

```text
SuspectInadequacy
RepresentationAdequate
ResponsibilityEquivalent
InsufficiencyCertificate
CandidateExhausted
```

at this checkpoint.

A later formal opening requires at minimum:

```text
QX-4 source-backed survival under fixed kill tests;
certificate provenance that is not circular;
stable object boundaries;
a non-definitional theorem/countermodel obligation;
no stronger ordinary prior-art representation that eliminates the object.
```

---

# 8. QX-3 verdict

```text
QX exact prior-art residual: NONEMPTY
Candidate A: PREREGISTERED, NOT VALIDATED
Candidate B: PREREGISTERED, NOT VALIDATED
Domain kill protocol: FROZEN
Domains: NOT SELECTED
QX theory: NOT ESTABLISHED
QX formalization: NO
```

The next legitimate QX move is **QX-4 domain falsification under this fixed protocol**.

This checkpoint earns only the right to test the candidates. It does not earn either candidate as a theory object.
