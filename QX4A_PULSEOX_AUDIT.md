# QX-4A₃ — Candidate A Audit: Pulse Oximetry / Occult Hypoxemia

Status: **SOURCE-BACKED NEGATIVE-CONTROL DOMAIN AUDIT**.

Formalization: **NO**.

Parent protocol: `QX_KERNEL_PREREGISTRATION.md`.

Frozen domain set: `QX4A_DOMAIN_FREEZE.md`.

Domain ID: `A-D3`.

This domain was selected specifically to attack failure localization. The tempting pattern is:

```text
same or similar displayed SpO2
-> materially different underlying arterial oxygenation / treatment need
-> therefore current distinction space is inadequate.
```

The audit asks whether that last step survives the ordinary measurement/calibration explanation required by QX-3 P2.

## 1. Primary sources

### S1 — paired pulse-ox / arterial-blood-gas evidence

Sjoding et al., *Racial Bias in Pulse Oximetry Measurement*, New England Journal of Medicine, 2020:

https://www.nejm.org/doi/abs/10.1056/NEJMc2029240

Material findings include:

- among measurements with pulse-ox saturation in the 92–96% range, occult hypoxemia measured by arterial blood gas occurred substantially more often in Black patients than in White patients;
- the paper explicitly frames the issue as pulse-oximetry measurement inaccuracy with implications for triage and oxygen adjustment;
- it recommends integrating pulse-ox readings with other clinical and patient-reported data rather than treating the device reading as a complete state description.

### S2 — clinical-impact analysis

Sudat et al., *Racial Disparities in Pulse Oximeter Device Inaccuracy and Estimated Clinical Impact on COVID-19 Treatment Course*, American Journal of Epidemiology, 2023:

https://academic.oup.com/aje/article/192/5/703/6730981

Material findings include:

- pulse oximetry systematically overestimated blood oxygenation more in the studied Black population than in the studied White population;
- hypoxemia not detected by SpO2 was more frequent in the studied Black group;
- estimated measurement error was associated with lower treatment/admission probabilities and treatment delays.

### S3 — regulator characterization

FDA, *Pulse Oximeters*:

https://www.fda.gov/medical-devices/products-and-medical-procedures/pulse-oximeters

FDA states that pulse oximeters have limitations and risk of inaccuracy and identifies factors including skin pigmentation, circulation, skin thickness, temperature, tobacco use, and nail polish as affecting accuracy.

## 2. Certificate timing

### `E_pre`

For the relevant modern clinical-use period, evidence available before later device-guidance revisions included:

```text
paired SpO2 / arterial-blood-gas discrepancies;
known occult hypoxemia under apparently acceptable pulse-ox readings;
known differential measurement error across patient groups;
known clinical reliance on oxygen-saturation thresholds.
```

The 2020 study is therefore usable as an early warning about the measurement channel.

### `E_post-refinement`

Later evidence includes:

```text
additional large real-world cohorts;
FDA advisory activity;
newer proposed device-evaluation / calibration guidance;
more explicit skin-pigmentation performance requirements.
```

These later developments may corroborate the mechanism but are not needed for the negative-control verdict.

## 3. Candidate A observables

### A-OBS1 — situations / case classes

A tempting pair is:

```text
x = patient whose pulse-ox reading is in an apparently acceptable range and whose arterial oxygenation is also acceptable;
y = patient with the same/similar pulse-ox reading but materially lower arterial oxygenation (occult hypoxemia).
```

### A-OBS2 — represented images under `V`

If `V` is defined as the pulse-ox display value alone, then x and y can map to the same/similar represented reading.

That local aliasing is empirically supported.

It does **not** by itself establish QX representation insufficiency.

### A-OBS3 — factorization of the decision path

Clinical guidelines and workflows may use SpO2 thresholds as important inputs to treatment decisions. The cited clinical-impact literature shows that pulse-ox measurements can influence admission, oxygen, and dexamethasone decisions.

However, clinical decision making need not factor solely through the pulse-ox display. Symptoms, other measurements, confirmatory arterial blood gas, history, and clinician judgment remain available in many workflows.

Therefore a stronger whole-task factorization claim is not earned.

### A-OBS4 — task/accountability source

The task is independently meaningful:

```text
detect clinically important hypoxemia and initiate appropriate treatment in a timely way.
```

This task does not depend on a later proposed representation refinement.

### A-OBS5 — exact response incompatibility

Patients with adequate versus inadequate true oxygenation can require different clinical responses even when one device displays similar SpO2 values.

The response difference is real, but the existence of a real response difference does not localize the fault to the representation layer.

### A-OBS6 — why the witness does not already supply the correct refinement

Paired arterial blood gas supplies an independent reference measurement for oxygenation in the study. It does not, by itself, determine the universally correct future pulse-ox representation or device design.

This observable therefore does not kill the case by A-K1 alone.

### A-OBS7 — existing channels

Other task-relevant channels may already exist:

```text
clinical symptoms;
arterial blood gas;
other vital signs;
patient history;
repeat measurements;
provider judgment.
```

This weakens any claim that the entire clinical system lacked the relevant distinction, although it is not the primary kill.

### A-OBS8 — lower-level rival explanations

The decisive ordinary rival is explicit and source-backed:

```text
measurement error / device calibration / sensor-performance variation.
```

FDA itself characterizes pulse-ox limitations in these terms. The epidemiological literature measures the discrepancy by comparing the pulse-ox estimate with a more direct arterial measurement.

The material facts are therefore preserved without introducing a new representation-insufficiency object.

### A-OBS9 — exact safe conclusion

The safe conclusion is:

> **Pulse-ox readings can be insufficiently accurate for some clinical decisions and patient populations, but this domain does not earn Candidate A as a distinct representation-inadequacy certificate because ordinary measurement/calibration error already explains the key aliasing and treatment consequences.**

## 4. Kill-test audit

### A-K1 — refinement-generated witness

```text
PASS / NOT DISPOSITIVE
```

The clinical need and paired ABG evidence do not depend on a proposed later representation.

### A-K2 — complete-ground-state oracle

```text
NOT THE PRIMARY KILL
```

Arterial blood gas is an independent reference measurement for the target physiological quantity, not a complete concrete-state oracle for the patient.

But its availability underscores that the study is diagnosing a measurement channel, not proving a general unknown-refinement problem.

### A-K3 — hidden existing channel

```text
PARTIAL PRESSURE AGAINST THE CLAIM
```

The broader clinical system can use symptoms, ABG, repeated readings, and other evidence. Therefore defining `V` as only the pulse-ox number risks the same boundary error seen in A-D2.

This is not needed for the final verdict because failure localization already kills the QX reading.

### A-K4 — compatible responses after all

```text
NOT DISPOSITIVE
```

Conservative confirmatory testing or integration with other clinical evidence may reduce the risk, but the domain is already explained at the measurement layer.

### A-K5 — task-specification instability

```text
PASS
```

Detection and timely treatment of clinically important hypoxemia is a stable task for this audit.

### A-K6 — ordinary partial observability

```text
ORDINARY OBSERVATION / ESTIMATION MODEL SUFFICIENT
```

The device is an observation channel that estimates an underlying physiological variable. Standard noisy-observation reasoning naturally represents the problem.

No residual certificate mechanism is established merely because one observation value aliases multiple underlying states.

### A-K7 — ordinary model / measurement misspecification

```text
KILL
```

This is the decisive Candidate A failure.

The sources directly support device measurement inaccuracy / calibration-performance variation as the mechanism. The case therefore fails QX-3 P2 failure localization: the anomaly can be explained without positing a distinct insufficiency of the system's distinction space.

### A-K8 — definition expansion

```text
PASS
```

The audit does not assume the desired inadequacy conclusion. It rejects it because a stronger ordinary explanation preserves the material facts.

## 5. Boundary lesson

This domain freezes the following negative rule:

```text
same displayed measurement
+
different underlying state / response need
-/->
representation-insufficiency certificate.
```

Before a Candidate A interpretation is admissible, the audit must first eliminate or materially outgrow:

```text
measurement error;
calibration error;
known observation noise;
sensor-performance variation;
ordinary latent-state estimation;
existing confirmatory channels.
```

If those mechanisms account for the case, QX adds no independently necessary object.

## 6. Domain verdict

```text
A-D3 pulse oximetry / occult hypoxemia:
ELIMINATED
```

Primary kill:

```text
P2 failure localization + A-K7 ordinary measurement/model explanation.
```

No Candidate A residual is admitted from this domain.

## 7. Degrees of freedom deleted

```text
measurement aliasing
-/->
QX aliasing;

independent gold-standard disagreement
-/->
proof that the representation layer, rather than the sensor/model, is the failed object;

clinical consequence
-/->
new representation-inadequacy relation.
```

The frozen three-domain Candidate A cycle is now complete. The next legitimate QX action is the aggregate `QX-4A_V` verdict; no fourth rescue domain may be added.
