# QX-4B₁ — Candidate B Audit: Incomplete Model-Based Diagnosis / Hidden Interaction Faults

Status: **SOURCE-BACKED DOMAIN AUDIT**.

Formalization: **NO**.

Parent protocol: `QX4B_DOMAIN_KILL_FREEZE.md` and `QX_KERNEL_PREREGISTRATION.md`.

Domain ID: `B-D1`.

## 1. Domain question

This domain asks the strongest apparent positive version of Candidate B:

> **If every diagnosis expressible in a finite current diagnostic model is inconsistent with observations, does that provide a distinct certificate of representation/distinction-space insufficiency, or is it already ordinary incomplete-model diagnosis?**

The central danger is B-K5/B-K8:

```text
current diagnosis class rejected
-/->
current distinction space V inadequate in a distinct QX sense.
```

## 2. Source-backed prior art

Primary source:

- Lukas Kuhn and Johan de Kleer, *Diagnosis with Incomplete Models: Diagnosing Hidden Interaction Faults* (2010), PHM Society / AAAI Spring Symposium. DOI: `10.36001/phmconf.2010.v2i1.1934`.
  - PHM record: https://papers.phmsociety.org/index.php/phmconf/article/view/1934
  - AAAI PDF mirror: https://cdn.aaai.org/ocs/1167/1167-5928-1-PB.pdf

The paper explicitly treats model-based diagnosis under incomplete system models. Its motivating case is an unmodeled interaction: individual components satisfy their specifications, but an interaction among them produces observable failure. Standard diagnosis assumes the necessary failure-causing structure is captured by the system description; an incomplete topology can make the ordinary diagnosis problem inconsistent or irresolvable. The proposed framework therefore extends diagnosis to hidden interaction faults without requiring every such interaction to have been explicitly modeled in advance.

This is not merely adjacent work. It directly targets the situation in which the existing diagnostic candidate class fails because the represented model omits a failure-relevant interaction.

## 3. Active Candidate-B audit matrix

### Finite?

```text
YES, relative to the modeled component set / health-assignment diagnosis space used in the example.
```

For a finite component set, ordinary component-health assignments form a finite represented diagnosis class. The paper's logic-circuit example uses a finite component set and a system description whose topology is incomplete.

Finiteness is therefore operationally real enough to test Candidate B; this is not the beta-decay problem of reconstructing a finite list after the fact.

### Enumeration authority

```text
E2 — formal model generates the represented candidate class relative to explicit assumptions.
```

The model, component set, component behavior assumptions, and represented topology determine what ordinary diagnoses are expressible. This is stronger than an analyst's convenience list.

But E2 grants completeness only **relative to the diagnostic model**. It does not grant that the model exhausts the task-relevant physical or representational possibilities.

### Exhaustive relative to what task position?

The standard diagnosis class is exhaustive only relative to the current model's component-health vocabulary and modeled topology.

That boundary is exactly what the incomplete-model work questions.

### `V -> H_V` link

```text
ESTABLISHED MODEL-RELATIVELY.
```

The represented system description induces the diagnoses available to standard MBD. The link is materially stronger here than in the beta-decay audit.

However, the link still supports only:

```text
all diagnoses expressible under the current diagnostic model have been considered / rejected
```

not:

```text
therefore the system's distinction space is inadequate in a novel QX sense.
```

### Independent `C`

```text
YES, model-relative observational consistency.
```

Observed system behavior supplies constraints independently of any later proposed hidden-interaction explanation. The discrepancy between predictions and observations is not generated solely by a candidate refinement.

### Every represented candidate fails?

```text
YES in the target failure shape: standard diagnosis can become inconsistent / irresolvable under an incomplete topology.
```

The paper's contribution presupposes precisely that ordinary diagnosis is insufficient when hidden interactions are outside the model.

### Common-mode rival

The case is not eliminated as mere measurement error or implementation noise. The source intentionally constructs hidden interaction behavior absent from the represented topology.

### Unknown/defer semantics

```text
Unknown-as-response may remain available, but it does not provide a diagnosis.
```

A system can safely report `no diagnosis under the current model`. That may satisfy a bounded operational task such as avoiding a false diagnosis, but it does not restore explanatory identification.

Therefore the audit must distinguish:

```text
failure of diagnostic identification
!=
failure of every possible operational response.
```

### Task defeated?

For the task `produce a diagnosis from the current model`, yes: the ordinary diagnostic task can fail.

For the broader task `remain safe when diagnosis fails`, not necessarily: abstention / escalation may still be valid.

Candidate B therefore cannot infer task-level representation inadequacy without fixing which task is relied upon.

## 4. B-K1 ... B-K8

### B-K1 — fake exhaustiveness

```text
PASS for the model-relative diagnosis class.
```

Unlike a hand-picked hypothesis list, the represented diagnosis class is generated by the formal model.

### B-K2 — post-hoc criterion

```text
PASS.
```

Observational consistency is not introduced only after a hidden-interaction refinement is known.

### B-K3 — common-mode test failure

```text
PASS for the intended constructed failure shape.
```

The case is about structural incompleteness / hidden interaction, not a shared measurement bug.

### B-K4 — decorative finitude

```text
PASS narrowly.
```

Finiteness can make the represented diagnosis class exhaustible. This is a stronger Candidate-B test than open-ended historical hypothesis formation.

### B-K5 — ordinary model-class rejection

```text
KILL / PRIOR-ART ABSORPTION.
```

This is decisive.

The mature incomplete-model diagnosis literature already gives the native interpretation:

```text
all ordinary diagnoses fail
+
model omits relevant interaction structure
->
extend diagnosis to incomplete models / hidden interactions.
```

Candidate B has not identified an additional responsibility-specific evidential role beyond this established incomplete-model diagnosis problem.

Calling the same event `distinction-space insufficiency` would currently rename the model-incompleteness conclusion rather than add a non-eliminable structure.

### B-K6 — hidden catch-all candidate

```text
NO decisive rescue.
```

A generic `unknown/no diagnosis` response can acknowledge model failure but is not itself an explanatory diagnosis. If the relied-upon task is only safe handling of uncertainty, that response may already satisfy the task and weaken any representation-inadequacy claim. If the task requires explanatory diagnosis, the existing incomplete-model literature already captures the failure.

### B-K7 — illegitimate world-level conclusion

```text
PASS AS FIREWALL.
```

The audit does not infer that reality lacks an explanation. It infers only that the current model-relative diagnosis class is insufficient for the observed case.

### B-K8 — no distinct link from `H_V` exhaustion to QX-level `V` inadequacy

```text
KILL.
```

A strong `V -> H_V` link exists at the level of the diagnostic model, but the additional step Candidate B needs is not earned:

```text
model-relative diagnosis exhaustion
->
distinct task-relative representation-insufficiency certificate.
```

The cited prior art already names the relevant native object as an incomplete system model / incomplete structural information problem. No independently surviving QX structure remains after that decomposition.

## 5. Exact domain verdict

```text
B-D1 incomplete-model diagnosis / hidden interaction faults:
ELIMINATED
```

Primary kills:

```text
B-K5 mature incomplete-model diagnosis absorbs the evidential role
B-K8 no distinct representation-level residual beyond model incompleteness
```

Important positive calibration:

```text
finite: YES
model-relative exhaustiveness: YES
independent observational criterion: YES
all represented diagnoses can fail: YES
```

Yet:

```text
Candidate-B QX residual: NONE
```

This is stronger evidence against Candidate B than the preliminary beta-decay negative control because the finite exhaustion is genuine here.

## 6. Freedom deleted

This domain permanently removes:

```text
a formally generated finite diagnosis class
+
complete model-relative exhaustion
+
independent observational inconsistency
-/->
a distinct QX certificate.
```

It also removes the shortcut:

```text
"the current diagnostic model is incomplete"
=
novel representation-inadequacy theory.
```

## 7. QX status after B-D1

```text
Candidate A: FROZEN / pre-refinement discriminator-unavailability witness / mechanism-specific only
Candidate B active cycle:
  B-D1 incomplete-model diagnosis: ELIMINATED
  B-D2 TLS: pending
  B-D3 spacecraft fault catalogue: pending
Candidate-B aggregate verdict: NOT YET WRITTEN
QX generic object: NOT EARNED
QX Lean: NO
```
