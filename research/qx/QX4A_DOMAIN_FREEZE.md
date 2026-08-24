# QX-4A₀ — Candidate A Domain Freeze

Status: **PRE-EVIDENCE DOMAIN FREEZE**.

Formalization: **NO**.

Parent protocol: `QX_KERNEL_PREREGISTRATION.md`.

This checkpoint selects the Candidate A falsification domains before any domain verdict is written. It does not alter A-K1–A-K8, the A-OBS1–A-OBS9 requirements, or the QX-3 promotion rule.

The selected set is intentionally adversarial. The three domains were chosen to exercise different kill mechanisms, not to maximize narrative support for Candidate A.

## 1. Frozen domain set

| ID | Domain | Primary falsification role | Candidate A pressure point |
|---|---|---|---|
| `A-D1` | Web PKI / Chrome–Symantec distrust | possible pre-refinement certificate without a per-object compliance oracle | A-K1, A-K2, A-K4, A-K5 |
| `A-D2` | Boeing 737 MAX / original MCAS single-AOA dependence | existing or recoverable distinguishing channel / policy-design negative control | A-K3, ordinary sensor-fusion explanation |
| `A-D3` | pulse oximetry / occult hypoxemia | measurement/calibration rival negative control | P2 failure localization, A-K7 |

No fourth domain may be added to rescue Candidate A if all three fail.

Candidate B is explicitly out of scope for this cycle.

## 2. Domain-specific source targets fixed before verdicts

### A-D1 — Web PKI / Symantec distrust

Primary source target:

- Chromium blink-dev, Ryan Sleevi, *Intent to Deprecate and Remove: Trust in existing Symantec-issued Certificates* (March 2017):
  https://groups.google.com/a/chromium.org/g/blink-dev/c/eUAKwjihhBs/m/SsLH5haOCQAJ

Facts to verify from the source record include:

```text
improper-validation scope expanded materially;
existing problematic certificates could not be technically identified/distinguished from the broader Symantec-issued corpus;
Chrome explicitly considered both security risk and compatibility/interoperability risk;
proposed response was staged distrust and replacement/revalidation rather than per-certificate classification.
```

The audit must not assume that compatibility is a hard accountability requirement merely because it is an engineering objective. A-K4 and A-K5 remain live.

### A-D2 — Boeing 737 MAX / MCAS

Primary source targets:

- FAA, *Summary of the FAA’s Review of the Boeing 737 MAX*:
  https://www.faa.gov/sites/faa.gov/files/2022-08/737_RTS_Summary.pdf
- FAA, *Boeing 737 MAX Reading Room*:
  https://www.faa.gov/foia/electronic_reading_room/boeing_reading_room
- NTSB, MCAS-related safety recommendations / accident-analysis materials:
  https://www.ntsb.gov/news/press-releases/Pages/NR20190926.aspx

Facts to verify include:

```text
the aircraft had two AOA sensors;
the original unsafe condition included MCAS reliance on erroneous data from a single AOA sensor;
post-accident corrective action uses both AOA inputs / disagreement monitoring;
whether the second signal or other current channels were already available strongly enough to make this an A-K3 policy/design case rather than representation insufficiency.
```

The audit must distinguish `not consumed by MCAS` from `not represented anywhere in the system`.

### A-D3 — pulse oximetry / occult hypoxemia

Primary source targets:

- Sjoding et al., *Racial Bias in Pulse Oximetry Measurement*, NEJM 2020:
  https://www.nejm.org/doi/abs/10.1056/NEJMc2029240
- Sudat et al., *Racial Disparities in Pulse Oximeter Device Inaccuracy and Estimated Clinical Impact on COVID-19 Treatment Course*, AJE 2023:
  https://academic.oup.com/aje/article/192/5/703/6730981
- FDA, *Pulse Oximeters*:
  https://www.fda.gov/medical-devices/products-and-medical-procedures/pulse-oximeters

Facts to verify include:

```text
similar pulse-oximeter readings can coexist with materially different arterial oxygenation;
measurement error varies systematically across patient populations / skin pigmentation;
clinical treatment decisions can be affected;
ordinary measurement/calibration error is a strong rival explanation and must be given its strongest reading.
```

The audit must not infer distinction-space insufficiency merely from `same displayed value -> different underlying physiology`.

## 3. Frozen certificate-timing column

Each domain audit must separate evidence available before the relevant refinement/remediation from evidence available only after the correct distinction or repair became known.

Use exactly:

```text
E_pre              evidence available before the later refinement/remediation;
E_post-refinement  evidence learned or made operational only after the later distinction/repair was known.
```

Only `E_pre` may support a Candidate A certificate claim.

A later refinement may be used to test whether a historical interpretation was correct, but it may not supply the provenance that was missing at the earlier decision point.

The central timing question is:

```text
Does there exist W_pre such that
W_pre indicts V for task T
and
W_pre does not already contain the later correct refinement V'?
```

This is an audit field, not a new Candidate A kill criterion and not a formal object.

## 4. Required per-domain audit record

Every QX-4A domain audit must preserve all QX-3 observables and add timing explicitly:

```text
A-OBS1  situations/case classes;
A-OBS2  represented images under V;
A-OBS3  factorization of the relevant decision path through V;
A-OBS4  task/accountability source;
A-OBS5  exact response incompatibility;
A-OBS6  independence from the later refinement;
A-OBS7  existing history/memory/context/metadata channels;
A-OBS8  lower-level rival explanations;
A-OBS9  exact safe conclusion;
TIMING  E_pre versus E_post-refinement.
```

Each audit must then run A-K1–A-K8 without modification.

Allowed per-domain verdicts remain:

```text
ELIMINATED
DOMAIN-SPECIFIC
SURVIVES WITH EXACT RESIDUAL
```

## 5. Aggregate stop rule

After `A-D1`, `A-D2`, and `A-D3` are audited under the frozen protocol:

- issue one Candidate A verdict;
- do not add a fourth rescue domain;
- if only one domain survives, the strongest permissible promotion is a mechanism-specific certificate candidate;
- do not define `InsufficiencyCertificate`;
- do not open Lean;
- do not start Candidate B in the same evidence cycle.

## 6. QX-4A₀ verdict

```text
Candidate A kill protocol: FROZEN / UNCHANGED
Domain set: FROZEN to A-D1, A-D2, A-D3
Certificate timing field: ADDED AS AUDIT DISCIPLINE ONLY
Candidate A verdict: NOT YET RUN
Candidate B: DEFERRED
QX Lean: NO
```
