# QX-SURVIVOR-ABSORPTION — One-Shot Prior-Art Absorption Audit

Status: **ONE-SHOT ELIMINATION AUDIT COMPLETE**.

Formalization: **NO**.

Governance invariant during this audit:

```text
QX: DORMANT / OPEN / PRE-FORMAL
T-WAKE: CLOSED FOR CURRENT CANDIDATE FAMILY
E-WAKE: OPEN / NOT ACTIVELY SEARCHED
```

Input object only:

```text
A* = pre-refinement discriminator-unavailability witness
```

Allowed verdicts only:

```text
ABSORBED
NARROWED
SURVIVES WITH EXACT PROVENANCE RESIDUAL
```

This audit does not reopen QX, does not create a theorem program, and does not search for a second Candidate-A domain.

## 1. Strongest new attacks

### 1.1 Nayebi 2026 selection theorems

Primary source:

- Aran Nayebi, *What Capable Agents Must Know: Selection Theorems for Robust Decision-Making under Uncertainty*, UAI 2026 / PMLR 337.
- https://proceedings.mlr.press/v337/nayebi26a.html
- https://arxiv.org/html/2603.02491

The result is a strong absorption attack against any reading of Candidate A whose contribution is merely:

```text
task-relevant aliasing -> unavoidable performance loss;
low regret -> representation must preserve task-relevant predictive distinctions;
partial observability -> sufficiently capable memory must refine a predictive partition.
```

The paper explicitly derives representation-theoretic constraints from performance on structured action-conditioned prediction tasks. Its own summary states that the relevant internal predictive structure is selected by the evaluation task family and that no representation theorem can force distinctions never tested by the goals.

Therefore the following are not QX residuals:

```text
aliasing hurts competence;
strong competence requires no-aliasing on evaluated distinctions;
a task distribution can force predictive-state / belief-like memory;
a representation may need refinement to support low-regret action.
```

### 1.2 Blackwell–Le Cam comparison of experiments

Primary reference:

- Erik Torgersen, *Comparison of Statistical Experiments*, especially Chapter 6 on deficiencies.
- https://www.cambridge.org/core/books/abs/comparison-of-statistical-experiments/deficiencies/AABD0ACA1EC297492575D9144B71AE7E

The comparison-of-experiments framework is a still broader absorption attack against any novelty claim of the form:

```text
one information structure is task-relatively worse than another;
using one experiment rather than another incurs decision loss;
information deficiency may be relative to a restricted family of decision problems.
```

Standard deficiency compares experiments over a common parameter set through risk over decision problems, and can be restricted to particular classes of decision problems.

Therefore:

```text
task-relative information deficiency
```

is not a QX contribution by itself.

## 2. Six-dimensional provenance comparison

### P1 — Comparison-universe provenance

**Nayebi.** The theorem is stated over an analyst-specified environment and structured diagnostic task/test family. In the partially observed setting, the theorem uses a finite latent-state POMDP model and predictive tests over future observations. The agent need not possess an explicit world model, but the theorem prover/evaluator possesses the comparison setup used to state the necessity result.

**Blackwell–Le Cam.** The analyst explicitly supplies the experiments being compared, their common parameter set, and the decision-theoretic comparison framework.

**A*.** The March 2017 Web-PKI record does not provide a correct per-certificate hidden-state assignment. It identifies a concrete institutional decision boundary and records that the relevant validation-provenance classes cannot be technically isolated at that boundary.

Result:

```text
A* is not absorbed merely by an analyst-side comparison theorem.
```

But this does **not** establish generic self-diagnosis.

### P2 — Task / loss / benchmark provenance

This is the strongest absorption pressure.

**Nayebi.** The evaluation family determines which predictive distinctions matter. Low regret forces exactly the distinctions tested by that family. Thus the benchmark itself carries task-relevant distinction content.

**Blackwell–Le Cam.** Decision problems, losses, and the parameter/experiment comparison structure determine what information is decision-relevant. Restricting the decision-problem family gives a task-relative deficiency.

Therefore freeze:

```text
unknown refinement
-/->
refinement-independent theorem.
```

Task-relevant distinction content may already be supplied through the loss, benchmark, test family, or comparison universe.

**A*.** The Web-PKI task pressure is contemporaneously and institutionally recorded: reduce security exposure while avoiding unnecessary compatibility/interoperability breakage during remediation. This is not a post-hoc analyst benchmark. However, it already makes the semantic relevance of validation provenance explicit.

Important correction:

```text
A* did not discover that "some unknown kind of distinction" was needed.
```

The relevant semantic discriminator was already named: validation provenance/compliance. What remained unavailable was a reliable operational per-object discriminator or assignment.

### P3 — Richer-information dependence

**Nayebi.** The agent is not assumed to have an explicit model, but the necessity result is proved relative to an analyst-defined environment/test family. Under partial observability, low regret can force predictive distinctions without handing the agent the latent state labels; nevertheless the theorem does not by itself provide an institution/system-side certificate that its current boundary is the source of failure.

**Blackwell–Le Cam.** The comparison explicitly depends on a second experiment/information structure or equivalent richer comparison relation over the same parameter set.

**A*.** The March 2017 record does not contain a reliable mapping from legacy certificates to the correct validation-compliance class. The later migration/revalidation architecture is excluded from `E_pre` provenance.

Thus A* retains a narrow difference from explicit richer-experiment comparison.

### P4 — Access level

Freeze the audit-only field:

```text
Access(E) in {
  Analyst,
  Institution,
  DecisionSystem,
  AutonomousAgent,
  PostHocHistorian
}
```

**Nayebi:** primarily `Analyst` for the selection-theorem conclusion. The agent's low regret constrains its internal structure; the theorem does not show that the agent itself forms a justified meta-judgment that its representation is inadequate.

**Blackwell–Le Cam:** `Analyst` / decision theorist. The comparison structure is externally specified.

**Web PKI A*:** `Institution` / sociotechnical decision system. The evidence was available to the actors responsible for Chrome root-program/trust decisions in the actual contemporaneous decision process.

Freeze:

```text
SystemAccessible(E_pre)
```

for Candidate A means institutionally accessible to the responsible sociotechnical decision process. It does **not** mean an autonomous algorithm internally proves a metacognitive theorem.

### P5 — Temporal availability

**Nayebi / Blackwell–Le Cam.** These are structural analyst-side results. They can characterize necessity/deficiency once the environment, tests, decision problems, or comparison experiments are fixed. They do not by themselves establish the historical timing condition that the responsible system possessed a particular inadequacy witness before a later repair/refinement was known.

**A*.** The March 2017 Chromium record predates the later migration architecture and already records:

```text
validation-governance failures;
expanding uncertainty;
inability to technically isolate affected legacy certificates;
security pressure;
compatibility/interoperability pressure.
```

This temporal provenance remains a live domain-specific difference.

### P6 — Discriminator-status diagnosis

This dimension forces the main narrowing.

A broader formulation suggested:

```text
the system knows that a task-required discriminator is unavailable
without knowing what the correct discriminator is.
```

That is too strong for the actual survivor.

The Web-PKI record already identifies the semantic distinction of interest:

```text
problematic / inadequately supervised validation provenance
vs
compliant validation provenance.
```

What it lacks is:

```text
a reliable operational discriminator / per-certificate assignment
at the relied-upon client decision boundary.
```

Therefore the survivor is not a theorem of "unknown distinction discovery". It is a narrower provenance claim about contemporaneously justified **operational unavailability of an already task-identified distinction**.

## 3. Absorption result by layer

```text
aliasing / performance-loss layer:
ABSORBED
  by mature partial-observability, regret, prediction, and information-comparison theory.

representation-necessity layer:
LARGELY ABSORBED
  by Nayebi-style task-conditioned selection theorems and Blackwell–Le Cam task-relative information comparison.

pre-refinement institutional provenance layer:
NOT ABSORBED, BUT NARROWED
  because existing comparison theorems are analyst-side and the Web-PKI evidence predates the later operational refinement.
```

The surviving content is weaker than the previous wording and more domain-specific than a generic QX object.

## 4. Exact post-audit residual

Replace the broader survivor wording with:

> **A contemporaneous institution-accessible record can justify that an already task-identified discriminator is not operationally available at the relied-upon decision boundary, even when no reliable per-object finer assignment or remediation architecture is yet available, provided that (i) the task pressure is independently recorded, (ii) the discriminator-unavailability fact is independently recorded, and (iii) later refinement/remediation evidence is excluded from the justification.**

For Web PKI the relevant distinction is validation provenance/compliance, and the unavailable object is the reliable per-certificate operational discriminator needed for selective provenance-sensitive trust treatment.

This does **not** establish:

```text
a system can discover an unknown missing distinction;
a generic representation-insufficiency certificate;
a new theorem of task-relative information deficiency;
an autonomous metacognitive certificate;
that no adequate fallback action exists;
that representation refinement is required rather than replacement/revalidation/distrust.
```

## 5. Verdict

```text
QX-SURVIVOR-ABSORPTION: NARROWED
```

Consequences:

```text
QX: DORMANT / OPEN / PRE-FORMAL       [UNCHANGED]
T-WAKE: CLOSED FOR CURRENT FAMILY     [UNCHANGED]
E-WAKE: OPEN / NOT ACTIVELY SEARCHED  [UNCHANGED]
Generic QX object: NOT EARNED         [UNCHANGED]
QX Lean: NO                           [UNCHANGED]
```

This verdict does not wake QX.

## 6. Permanent burdens retained

Three methodological burdens remain the durable output:

```text
ProvenanceBurden:
  the evidence for boundary inadequacy must not be generated by the later refinement it is meant to justify;

NonDefinitionalityBurden:
  the conclusion must add more than an analyst-specified task/loss/test family already encoding the required distinction;

AccessLevelBurden:
  analyst ability to prove a distinction necessary does not imply that the responsible system was entitled to suspect its own decision boundary.
```

The last burden is now the strongest surviving QX methodological firewall:

```text
analyst can prove a distinction is necessary
-/->
responsible system was entitled, at that time, to indict its own distinction boundary.
```

## 7. Stop rule

No next Candidate-A case, no new theorem family, no Lean milestone, and no T-WAKE reopening follows from this audit.

A future QX change still requires an independently legal wake event under `QX_WAKE_GOVERNANCE.md`.
