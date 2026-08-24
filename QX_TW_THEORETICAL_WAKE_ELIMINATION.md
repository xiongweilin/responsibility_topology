# QX-TW — Theoretical-Wake Elimination Audit

Status: **T-WAKE CLOSED AT CURRENT EVIDENCE/THEORY LEVEL**.

Formalization: **NO**.

Parent governance: `QX_WAKE_GOVERNANCE.md`.

This audit asks whether QX can be legitimately awakened by a representation-independent theoretical impossibility, without a second mechanism-distinct empirical case and without already knowing the correct finer representation.

The candidate residual is intentionally narrower than ordinary non-observability:

> Is there an impossibility concerning a finite responsibility system's entitlement to certify that its own representation is the source of task failure, rather than merely an impossibility of distinguishing states, diagnosing a critical property, satisfying a task, or validating a fixed model?

## 1. Required four-level firewall

The audit keeps the following levels distinct:

```text
L1  cannot distinguish states
!=
L2  cannot diagnose a critical property
!=
L3  cannot satisfy task T under the current observation/model structure
!=
L4  cannot certify that the current representation itself is the source of failure
```

A QX-specific T-WAKE would need a non-definitional result at L4 that is not already entailed by an analyst-side concrete model, ordinary diagnosis, task infeasibility, model invalidation, or abstraction refinement.

## 2. Strongest-neighbor audit

### N1 — finite-state observability / diagnosability

Elena De Santis and Maria Domenica Di Benedetto, *Observability and diagnosability of finite state systems: A unifying framework*, Automatica 81 (2017), 115–122.

Source:

https://doi.org/10.1016/j.automatica.2017.02.042

The framework explicitly separates full-state reconstruction from determining whether a state belongs to a critical set. It characterizes when available outputs can or cannot support those determinations.

Absorption:

```text
known finite state space X
+ known output map H : X -> Y
+ known critical set K subset X
+ observational equivalence crossing K / not-K
-> failure of critical observability / diagnosability
```

This already absorbs any proposed QX result whose proof assumes an analyst possesses the ground states and the task-relevant critical partition, while the system only sees `Y`.

Such a theorem can establish that the current observation relation is insufficient for a specified distinction. It does not establish a novel system-side entitlement to diagnose its own representation as inadequate.

### N2 — active diagnosis

Stefan Haar, Serge Haddad, Tarek Melliti, and Stefan Schwoon, *Optimal constructions for active diagnosis*, Journal of Computer and System Sciences 83(1) (2017), 101–120.

Source:

https://doi.org/10.1016/j.jcss.2016.04.007

Active diagnosis studies partially observed systems that may be non-diagnosable under passive observation and asks whether a controller can manipulate behavior so faults become diagnosable. The theory includes cases where no active diagnoser exists.

Absorption:

```text
ambiguity under passive observation
+ available interventions/actions
-> either an intervention policy can force diagnosis
   or active diagnosability fails
```

Therefore the idea that a system may actively test whether ambiguity can be removed is already mature diagnosis/control territory when the plant, fault distinction, and observation structure are given.

Failure of all allowed active probes still does not by itself show that the system has certified `representation inadequacy`; it shows non-diagnosability relative to the modeled plant/action/observation structure.

### N3 — observational/counterfactual equivalence under all interaction

Stuart Armstrong, *Counterfactual equivalence for POMDPs, and underlying deterministic environments* (2018).

Source:

https://arxiv.org/abs/1801.03737

The paper studies environments that an agent cannot distinguish through observations and actions, including counterfactual equivalence across policies.

Absorption:

```text
for all available policies / action-observation interactions,
environments remain observationally equivalent
```

This is already a strong interaction-level indistinguishability result. But the distinction between the equivalent environments is supplied by the external modeler. The agent's inability to distinguish them is not yet a certificate, available to the agent before a refinement is known, that its representation is the source of a task failure.

### N4 — model invalidation without a known replacement

Farshad Harirchi and Necmiye Ozay, *Guaranteed model-based fault detection in cyber–physical systems: A model invalidation approach*, Automatica (2018).

Source:

https://doi.org/10.1016/j.automatica.2018.03.040

Related earlier model-invalidation work formulates whether observed input-output behavior is consistent with a model's behavior set and can reject the current model when no consistent trajectory exists.

Absorption:

```text
current model M
+ system-accessible input/output data D
+ no behavior of M is consistent with D
-> M is invalidated
```

This is especially important for QX-TW because it does **not** require possession of the correct replacement model. It already provides a principled certificate that the current model is inconsistent with observations.

Therefore a proposed T-WAKE of the form

```text
system can establish that its current account is inadequate
without knowing the correct replacement
```

is not QX-specific if the certificate is simply model/data inconsistency.

Model invalidation may establish `current model false/inconsistent`; it does not automatically establish `current distinction space lacks a task-required discriminator`. But any stronger QX conclusion needs additional provenance for that distinction-space diagnosis.

## 3. The ground-distinction dilemma

The theoretical candidate faces a two-horn provenance problem.

### Horn A — analyst owns the hidden distinction

Suppose the argument uses:

```text
x1 != x2
H(x1) = H(x2)
R_T(x1) != R_T(x2)
```

where an external analyst already knows `x1`, `x2`, and their incompatible task-relevant statuses.

Then the proof establishes an analyst-side observability/diagnosability limitation. The crucial finer distinction is already present in the meta-model used to state the theorem.

It does not solve the QX mother problem:

```text
how the finite system itself becomes entitled to suspect its distinction space
without already possessing that finer decomposition.
```

### Horn B — system owns only current-model evidence

Suppose instead the system has only current-model observations and can derive a contradiction/inconsistency with the represented model.

Then the strongest representation-independent conclusion supported by the evidence is model invalidation / misspecification / anomaly detection:

```text
current model does not explain the observed data.
```

Without an independently sourced task-relevant discriminator, the step from model inconsistency to

```text
the representation is specifically too coarse for task T
```

is not licensed.

That additional step recreates the same provenance obligation already isolated in frozen Candidate A.

## 4. Why the obvious impossibility theorem does not wake QX

Candidate statement:

```text
No purely V-internal procedure can detect every V-invisible inadequacy.
```

This sounds representation-independent, but its proof must quantify over cases that are identical from the procedure's `V`-accessible perspective and differ in some externally specified ground property.

Therefore either:

1. the distinguishing ground property is built into the analyst's concrete/meta state space, reducing the theorem to an indistinguishability/non-identifiability argument; or
2. the procedure obtains a system-accessible inconsistency witness, in which case model invalidation already captures the generic certificate of current-model failure; or
3. a task-specific discriminator-unavailability witness is added independently, which is exactly the unresolved Candidate-A provenance problem rather than a new representation-independent theorem.

No fourth provenance route was identified.

## 5. Exact conclusion

The strongest surviving distinction is conceptual, not a new theorem surface:

```text
analyst can prove current observations erase a known distinction
!=
system can certify that its own representation is the source of failure.
```

But under current prior art and current QX evidence, there is no independently justified representation-independent certificate mechanism for the second statement.

The proposed T-WAKE is therefore absorbed as follows:

```text
known hidden distinction + observational equivalence
-> observability / diagnosability / non-identifiability;

intervention cannot remove ambiguity
-> active-diagnosis impossibility;

current model inconsistent with observations
-> model invalidation / model criticism;

claim that the missing issue is specifically a task-required absent discriminator
-> requires the same independent provenance burden as frozen Candidate A.
```

Verdict:

```text
T-WAKE: CLOSED
```

This is a negative research result. It does not prove that no future theoretical wake is logically possible. It closes the current candidate family and prohibits rebranding standard non-observability, non-diagnosability, non-identifiability, or model invalidation as QX-specific theoretical progress.

## 6. Degrees of freedom deleted

This audit permanently removes the shortcuts:

```text
V-internal indistinguishability impossibility
-/->
QX-specific impossibility;

analyst-known hidden distinction
-/->
system-side representation-inadequacy certificate;

failure of all active probes
-/->
certificate that representation is the source of failure;

model invalidation without replacement model
-/->
task-relative distinction-space insufficiency;

compact diagonal/impossibility syntax
-/->
T-WAKE.
```

## 7. Governance result

After this audit:

```text
QX: DORMANT / OPEN
E-WAKE: OPEN BUT NOT ACTIVELY SEARCHED
T-WAKE: CLOSED FOR THE CURRENT THEORETICAL CANDIDATE FAMILY
Candidate A: FROZEN / mechanism-specific only
Candidate B: ELIMINATED
Generic QX object: NOT EARNED
QX Lean: NO
```

A future T-WAKE would require a materially different provenance mechanism, not a variant of the four absorbed families above.
