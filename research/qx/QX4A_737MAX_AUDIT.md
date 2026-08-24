# QX-4A₂ — Candidate A Audit: Boeing 737 MAX / Original MCAS

Status: **SOURCE-BACKED NEGATIVE-CONTROL DOMAIN AUDIT**.

Formalization: **NO**.

Parent protocol: `QX_KERNEL_PREREGISTRATION.md`.

Frozen domain set: `QX4A_DOMAIN_FREEZE.md`.

Domain ID: `A-D2`.

This domain was selected specifically to test A-K3: an existing distinguishing channel that the operative decision path did not use.

## 1. Native domain question

The original MCAS unsafe condition included reliance on erroneous data from a single angle-of-attack (`AOA`) sensor. The aircraft, however, had two AOA sensors. FAA corrective action later changed FCC software to use both AOA sensor inputs and disagreement monitoring.

A superficially attractive Candidate A reconstruction is:

```text
x = genuinely high-AOA condition;
y = false high-AOA indication caused by one erroneous AOA sensor;
V = the single AOA signal consumed by the original active MCAS path;
alpha_V(x) = alpha_V(y) = high AOA;
response(x) = MCAS augmentation may be appropriate;
response(y) = erroneous MCAS activation must be prevented.
```

If `V` is defined this narrowly, the pair aliases.

The audit question is whether this demonstrates representation insufficiency of the task-relevant system, or merely that a control law ignored / failed to cross-check a distinguishing signal already present in the aircraft architecture.

## 2. Primary sources

### S1 — FAA return-to-service technical review

FAA, *Summary of the FAA’s Review of the Boeing 737 MAX*:

https://www.faa.gov/sites/faa.gov/files/2022-08/737_RTS_Summary.pdf

Material historical facts reported by FAA:

- the unsafe condition included erroneous data from a **single AOA sensor** activating MCAS;
- the corrective design eliminated MCAS reliance on a single AOA signal by using **both AOA sensor inputs**;
- the revised design compares the two valid AOA inputs and disables MCAS / Speed Trim when the disagreement exceeds the specified threshold for the specified duration.

### S2 — FAA rulemaking / certification summary

FAA rulemaking materials describe the accident condition as erroneous data from **one of the airplane’s two AOA sensors** causing repeated MCAS nose-down commands and identify the single-AOA dependence as a safety issue.

Representative source:

https://drs.faa.gov/browse/excelExternalWindow/FR-NPRM-2024-01485-0000000000000.0001

### S3 — NTSB accident-analysis material

NTSB, *Assumptions Used in the Safety Assessment Process and the Effects of Multiple Alerts and Indications on Pilot Performance*:

https://www.ntsb.gov/investigations/accidentreports/reports/asr1901.pdf

The NTSB record describes accident-flight data in which the left AOA value diverged sharply from the right side and the flight deck exhibited multiple discrepant indications / alerts.

The source is used to establish that the broader aircraft system contained contemporaneous disagreement information, not to claim that the flight crew had an easy or sufficient operational diagnosis.

## 3. Certificate timing

### `E_pre`

Historical facts existing before the later MCAS redesign included:

```text
two installed AOA sensors;
original MCAS dependence on one selected AOA source;
contemporaneous sensor/derived-display disagreement during the accident conditions;
a safety task requiring continued safe flight after a single failure.
```

The public and certification understanding of those facts was incomplete and contested at different points, but the second sensor was not invented by the later refinement.

### `E_post-refinement`

Later evidence includes:

```text
FAA's complete post-accident review;
the revised dual-input comparison logic;
split-vane monitoring;
new MCAS disable behavior;
revised pilot procedures and alerts.
```

These later sources establish how the existing channel was operationalized in the repair. They may not be used to pretend that the complete final design was known before the accidents.

The key negative-control fact is weaker and sufficient:

```text
the relevant physical distinction channel already existed in the aircraft as a second AOA measurement.
```

## 4. Candidate A observables

### A-OBS1 — situations / case classes

```text
x = genuinely high-AOA flight condition;
y = normal / non-high-AOA condition accompanied by an erroneous high value from the AOA sensor selected by original MCAS.
```

### A-OBS2 — represented images under `V`

If `V` is artificially defined as only the original active MCAS AOA input, then both cases can present the same `high` value.

That narrow equality is real at the chosen local interface but is not sufficient to establish QX representation insufficiency.

### A-OBS3 — factorization of the decision path

The original MCAS decision path effectively relied on a single AOA input for the relevant activation condition. That establishes a narrow implementation/control-law factorization.

It does **not** establish that the task-relevant aircraft had no other represented distinguishing information.

### A-OBS4 — task/accountability source

The safety task is independently grounded in airworthiness requirements and FAA's post-accident statement of the corrective obligation:

```text
an erroneous single AOA signal must not prevent continued safe flight and landing or generate erroneous MCAS activation.
```

This safety requirement is not inferred from the later dual-sensor implementation.

### A-OBS5 — exact response incompatibility

At the narrow MCAS input level:

```text
true high AOA and false high indicated AOA require different control responses.
```

This is not disputed.

The question is whether the system lacked a way to distinguish them, not whether different responses were warranted.

### A-OBS6 — why the witness does not already supply the correct refinement

The safety requirement does not itself dictate a specific dual-AOA algorithm. Therefore A-K1 is not the main failure.

### A-OBS7 — existing channels

This observable kills the QX reading.

The aircraft already contained:

```text
a second AOA sensor;
other side-specific air-data indications derived from the independent side;
observable disagreement manifestations during the accident condition.
```

The later FAA-approved repair uses both AOA sensor inputs rather than adding a newly discovered physical distinction.

Therefore the failure is naturally described as:

```text
existing distinguishing information not used / not integrated adequately by the control law
```

rather than:

```text
current system distinction space lacked any representation of the relevant difference.
```

### A-OBS8 — lower-level rival explanations

Ordinary explanations are strong and sufficient:

```text
single-sensor dependency;
sensor-fusion / cross-check design failure;
control-law architecture;
system-safety assessment failure;
insufficient handling of valid-but-erroneous sensor data;
human-factors / alert interaction issues.
```

No representation-inadequacy residual is needed to preserve the material facts.

### A-OBS9 — exact safe conclusion

The safe conclusion is negative:

> **The original MCAS case does not earn Candidate A as a representation-insufficiency certificate when the task-relevant system boundary includes the aircraft's already-existing second AOA channel. It is better classified as failure to use/integrate existing distinguishing information.**

## 5. Kill-test audit

### A-K1 — refinement-generated witness

```text
PASS / NOT DISPOSITIVE
```

The safety requirement is independent of the later dual-sensor algorithm.

### A-K2 — complete-ground-state oracle

```text
PASS / NOT DISPOSITIVE
```

No complete concrete-state oracle is required for the negative-control classification.

### A-K3 — hidden existing channel

```text
KILL
```

This is the decisive result.

The aircraft already had two AOA sensors. The later correction uses both existing sensor inputs to detect disagreement and suppress erroneous MCAS activation.

Defining `V` as only the signal consumed by the faulty MCAS path would therefore manufacture representation insufficiency by choosing the policy's input slice as the whole system representation.

The QX-3 protocol explicitly forbids that move when a usable distinguishing channel already exists elsewhere in the current system.

### A-K4 — compatible responses after all

```text
NOT NEEDED FOR VERDICT
```

The domain is already eliminated by A-K3.

A conservative disable-on-disagreement policy later became part of the repair, further illustrating that ordinary control design can exploit the existing channel.

### A-K5 — task-specification instability

```text
PASS
```

The safety task is stable enough for the negative-control analysis.

### A-K6 — ordinary partial observability

```text
ORDINARY SENSOR-FUSION / OBSERVATION-MODEL EXPLANATION SUFFICIENT
```

The issue fits familiar redundant-sensing and observation-validation analysis without requiring a new QX certificate object.

### A-K7 — ordinary model misspecification

```text
NOT PRIMARY; ORDINARY SYSTEM-DESIGN EXPLANATION SUFFICIENT
```

### A-K8 — definition expansion

```text
PASS
```

The audit does not infer inadequacy from a premise that simply states no response is possible. Instead it rejects the candidate because the broader system already represented a discriminating channel.

## 6. Boundary lesson

This domain deletes a major degree of freedom in Candidate A:

```text
policy input vocabulary
!=
full task-relevant system representation.
```

A future Candidate A case may not obtain a certificate merely by choosing `V` to equal the feature subset actually consumed by the failed policy.

Before claiming representation insufficiency, the audit must search the broader task-relevant state for:

```text
unused sensors;
unused metadata;
history;
confidence;
provenance;
side-channel measurements;
independent redundant inputs.
```

If those already distinguish the cases sufficiently for the task, the failure belongs to policy, integration, or implementation.

## 7. Domain verdict

```text
A-D2 Boeing 737 MAX / original MCAS:
ELIMINATED
```

Primary kill:

```text
A-K3 hidden/existing distinguishing channel.
```

No Candidate A residual is admitted from this domain.

## 8. Degrees of freedom deleted

```text
“the failed controller did not consume signal s”
-/->
“the system lacked representation of s”;

single-sensor aliasing inside a chosen policy interface
-/->
system-level representation inadequacy;

later use of an already-existing sensor
must not be redescribed as discovery of a previously unavailable distinction.
```

The next frozen domain is `A-D3` (pulse oximetry), which tests the independent measurement/calibration rival.
