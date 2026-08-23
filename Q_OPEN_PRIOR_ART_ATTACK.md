# Q_open Prior-Art Attack

Status: **QO-1P prior-art attack. Research only.**

This document is adversarial by design. Its purpose is to determine whether the Q_open problem survives contact with strong neighboring literatures before any formal semantics are attempted.

Formal reopen: **NO**.

The target under attack is not “model revision” in general and not “defeaters exist.” The narrow candidate problem is:

> **How can evidence acquire standing to challenge the admissibility/closure regime itself when that evidence need not already satisfy the regime's ordinary object-level acceptance rules?**

The burden is to show that this problem is not already exhausted by established abstraction refinement, model criticism, assurance-case defeaters, theory/ontology repair, or descriptive philosophy of scientific change.

---

## 1. Novelty firewall before comparison

Q_open must explicitly concede the following prior art.

### 1.1 Defeaters are not new

Assurance-case research already treats defeaters as explicit doubts or counter-considerations directed at assurance arguments. Assurance 2.0 provides representation and assessment mechanisms for defeaters and discusses multiple levels of defeaters.

Therefore Q_open must **not** claim novelty for:

```text
allowing a defeater
recording a defeater
allowing defeaters of assurance claims
allowing defeaters at multiple levels
using skeptical challenge to suspend confidence in an argument
```

The 2024 Assurance 2.0 work by Bloomfield, Netkachova, and Rushby is a first-class strong neighbor, not a peripheral related-work citation.

### 1.2 Assurance weakeners are already taxonomized

A 2024 PRISMA-driven systematic mapping study of system-assurance weakeners reviewed 39 primary studies and organized weakeners into aleatory, epistemic, ontological, and argument uncertainty, while also classifying management approaches into representation, identification, and mitigation.

A 2025 real-world safety-assurance defeater study proposed a seven-category taxonomy derived from published assurance cases and practitioner experience.

Therefore Q_open cannot claim that its contribution is merely:

```text
there are epistemic/ontological/argument weakeners
assurance arguments may have missing evidence or reasoning gaps
real systems need structured defeater analysis
```

### 1.3 External or held-out model criticism is not new

Bayesian model criticism has mature mechanisms for checking fitted models against diagnostic structure not identical to the training fit. Split predictive checks, for example, deliberately separate fitting data from held-out checking data and provide calibrated predictive criticism under stated assumptions.

Therefore Q_open cannot claim novelty for:

```text
checking a model using held-out evidence
using model-external residuals as criticism
using predictive mismatch to motivate model revision
```

The remaining question is whether such a diagnostic signal has **standing to challenge the diagnostic/admissibility regime itself**, especially when the diagnostic structure is also under dispute.

### 1.4 Vocabulary/signature repair is not new

Automated theory repair already includes conceptual change that can expand, contract, or reform logical structures and can change the signature of a logical theory itself. Work on signature entrenchment explicitly studies repair of predicates and arguments, not merely truth-value updates inside a fixed vocabulary.

Therefore Q_open cannot claim novelty for:

```text
revising concepts
changing ontology
changing predicates/signatures
allowing theory repair to alter the representational vocabulary
```

The remaining candidate problem is who or what has sufficient standing to initiate regime-level revision, and how that standing differs from the regime's ordinary object-level admissibility relation.

---

## 2. Six-neighbor attack matrix

| Neighbor | What it already solves | What it typically fixes or presupposes | Attack on Q_open | Residual Q_open question, if any |
|---|---|---|---|---|
| CEGAR / abstraction refinement | Spurious counterexample analysis followed by automatic abstraction refinement | A concrete semantics/property relationship and a verification problem from which spuriousness can be judged | “Is Q_open just abstraction refinement with philosophical vocabulary?” | What licenses reopening the semantic/admissibility boundary itself when there is no assumed complete external concrete oracle for the disputed distinction? |
| Bayesian model criticism | Detecting model misfit through posterior/predictive diagnostics; held-out/split checking can improve calibration | A chosen model class plus diagnostic/reference structure, discrepancy, data split, or predictive target | “Is standing merely a failed model check?” | What happens when the diagnostic/reference admissibility itself is part of the challenge, or when a failed check underdetermines which responsibility layer should be reopened? |
| Assurance-case defeaters / assurance weakeners | Explicit doubts against assurance claims/evidence/reasoning; multiple-level defeaters; taxonomies of assurance deficits and management approaches | An assurance-case argument structure, claim/evidence relations, and a process for representing or assessing doubts | “Closure defeaters already exist; Q_open has renamed assurance defeaters.” | How does evidence acquire **regime-level challenge standing**, especially when ordinary object-level admissibility would reject the evidence and that admissibility boundary is itself challenged? |
| Belief / ontology / automated theory repair | Revision of beliefs, theories, concepts, and even logical signatures | A repair trigger/objective, inconsistency or failure condition, repair operators, entrenchment or preference structure | “Changing vocabulary is already established.” | Who or what is entitled to initiate representation-level repair, and what prevents every ordinary anomaly from becoming ontology repair? |
| Kuhnian anomaly/crisis/paradigm change | Descriptive-historical account of anomaly accumulation, crisis, and paradigm replacement | A scientific community, disciplinary matrix, and historically situated process rather than an explicit entitlement calculus | “Anomaly-to-paradigm escalation is old.” | What explicit responsibility relation grants bounded standing to challenge closure, and how is false reopen controlled? |
| Duhem–Quine / underdetermination | Explains why failed prediction generally does not uniquely identify which hypothesis/background assumption should be revised | No unique revision-location rule follows from the evidence alone | “Your minimal-escalation story assumes localization that philosophy has already shown to be underdetermined.” | Can bounded-scope responsibility remain meaningful without unique diagnosis, perhaps over a partial order of incomparable reopen scopes? |

---

## 3. Strong-neighbor analysis

### 3.1 CEGAR: the nearest algorithmic “reopen the abstraction” neighbor

Classic counterexample-guided abstraction refinement proceeds roughly as:

```text
abstract model
-> counterexample
-> determine whether counterexample is spurious
-> refine abstraction
-> repeat
```

This is a genuine representation-revision loop. It already demonstrates that failure at an abstract level can trigger refinement of the abstraction itself.

Therefore Q_open must not claim:

```text
novelty = failures can cause representational refinement
```

The residual distinction is conditional and narrow. CEGAR is normally embedded in a verification setting where a concrete/abstract relationship and property semantics make “spurious counterexample” meaningful. Q_open asks about settings in which the semantic/admissibility boundary being used to classify the challenge may itself be under review and no complete external concrete-state oracle is assumed.

This residual distinction may still collapse under stronger generalized abstraction-refinement frameworks. QO-2 must actively test that possibility.

### 3.2 Bayesian model criticism: strong evidence that external checking can be disciplined

Bayesian model criticism already has a rich account of discrepancy detection and predictive checking. Recent split predictive checking strengthens the point: a model can be fit on one subset and criticized using held-out data, yielding calibrated predictive p-values under stated conditions.

This is important because it defeats any naive Q_open claim that “a regime needs an external signal” is itself novel.

Instead freeze:

```text
external checking
!=
general reopen entitlement
```

A predictive check has a selected discrepancy/reference structure and a defined predictive target. A failed check can establish misfit relative to that checking setup without automatically settling:

```text
which layer is responsible;
whether the diagnostic itself is adequate;
whether object-level repair is sufficient;
whether the model class, measurement process, purpose, or admissibility rule should be reopened.
```

Q_open only survives here if `ChallengeStanding` captures a responsibility not already equivalent to a standard diagnostic acceptance/rejection rule.

### 3.3 Assurance defeaters: the most dangerous conceptual neighbor

This is the primary novelty threat.

Assurance 2.0 explicitly represents defeaters as doubts about assurance arguments and supports reasoning with multiple levels of defeaters. The assurance-weakeners literature is broad enough to include epistemic, ontological, and argument uncertainty, and later work provides real-world defeater taxonomies.

Therefore the following sentence is prohibited:

> “Q_open is novel because it allows evidence to defeat closure.”

That is too broad and likely false.

Q_open's only defensible residual candidate is:

```text
ordinary object-level acceptance A_K(e)
need not be the same responsibility relation as
challenge standing S_K(e, scope)
```

especially in the self-challenge pattern:

```text
not A_K(e)
because e violates or exceeds the current admissibility boundary
+
e is relevant to whether that very admissibility boundary is too narrow
```

The research question is then not “can there be a defeater?” but:

> **What makes such evidence eligible to function as a regime-level defeater without first satisfying the ordinary rule it challenges?**

This may still be captured by mature argumentation/assurance formalisms through meta-level attack relations, appeal structures, or dialectical rules. QO-1H must treat that collapse as a real kill condition.

### 3.4 Belief, ontology, and theory repair: representation change is prior art

Automated theory repair explicitly covers conceptual change and logical-signature change. Signature-entrenchment work demonstrates that predicates and their arguments can themselves be revised and ranked for retention.

Thus Q_open cannot sell:

```text
we can reopen V
we can add concepts
we can change the ontology
```

as a contribution.

Its residual question is upstream of repair:

```text
what earns the right to treat the failure as a candidate failure of V/A/D/R/C/G
rather than as another defect inside the current represented problem?
```

This is a trigger/standing problem, not a repair-operator problem.

### 3.5 Kuhn: anomaly and regime change are descriptively old

Kuhn's account already links persistent anomalies, loss of confidence, crisis, and paradigm revision/replacement.

Q_open therefore cannot claim novelty for the broad sequence:

```text
anomaly -> crisis -> framework change
```

The residual candidate is prescriptive/structural rather than historical:

```text
what responsibility relation makes a challenge review-entitled,
what bounded closure consequence follows,
and how false reopen is defeated?
```

Q_open should not pretend to derive a universal algorithm from Kuhn.

### 3.6 Duhem–Quine: failure location is underdetermined

Holist underdetermination directly attacks any simple “minimal escalation” rule. A failed prediction often leaves multiple hypotheses, auxiliaries, measurement assumptions, or background beliefs available for revision.

Therefore freeze:

```text
minimal escalation
!=
unique localization
```

Q_open must allow multiple incomparable plausible reopen scopes.

The only potentially defensible bounded-scope principle is weaker:

> do not reopen a scope broader than the current evidence, purpose, and explicit meta-responsibility assumptions justify.

Even this must survive QO-2 falsification.

---

## 4. Prior-art consequences for QO-1

After this attack, Q_open must abandon the following candidate novelty claims:

```text
defeaters can challenge closure                        [already established]
defeaters can target multiple argument levels          [already established]
external/held-out evidence can criticize a model       [already established]
anomalies can trigger abstraction/model revision       [already established]
vocabularies/signatures can be repaired                [already established]
persistent anomalies can precede framework change      [historically established]
failed evidence does not uniquely localize revision    [classical underdetermination]
```

The residual kernel, if it survives, is narrower:

```text
How can a challenge become review-entitled against
an admissibility/closure boundary when the challenge
need not already satisfy that boundary's ordinary
object-level acceptance relation?
```

This is a **standing-to-challenge-the-gate** problem.

It is not yet shown to be novel. It is only the portion not obviously consumed by the six neighbors above.

---

## 5. Distinction from ordinary model checking

Q_open should maintain this firewall:

```text
failure detector
!=
challenge-standing relation
!=
reopen-entitlement relation
```

A detector can produce a statistically or formally meaningful rejection. That does not by itself determine whether responsibility lies in:

```text
raw observation
serialization
implementation
local decision
parameterization
model class
admissibility rule
dependency model
repair semantics
closure rule
purpose/governance
```

The strict-Level-6 bridge provides a concrete technical precedent for this separation: executable mismatch and checker rejection were deliberately localized without being promoted to a global regime-inadequacy conclusion.

Q_open generalizes only the **problem discipline**, not the verified semantics of that bridge.

---

## 6. Assurance-defeater firewall

Because assurance-case defeaters are the strongest conceptual neighbor, any later Q_open claim must answer four questions explicitly.

### A. What is the attacked object?

Is the challenge attacking:

```text
a claim inside an assurance case;
the evidence for a claim;
an inference/assumption;
or the regime that decides which objects/evidence may enter the case at all?
```

If it is only one of the first three, assurance-defeater literature may already own the problem.

### B. What grants standing?

If the answer is simply “the assurance notation permits a defeater node,” Q_open has not supplied an independent problem.

The residual question requires an accountable burden for `S_K(e, scope)` that does not merely restate `A_K(e)`.

### C. What is the immediate consequence?

Q_open only claims:

```text
ReopenEntitled -> not UnqualifiedClosure
```

not operation stop, truth of the defeater, or replacement.

### D. Can mature argumentation already encode this?

If meta-level attack/appeal structures in assurance or structured argumentation can fully express the same standing relation, bounded closure consequence, regress boundary, and false-reopen control without loss, then Q_open's independent kernel should be considered collapsed.

---

## 7. Kill criterion carried into QO-1H

The strongest prior-art kill criterion is:

> **If every successful Q_open case can be faithfully restated as an ordinary instance of CEGAR, Bayesian model criticism, assurance-case defeater handling, or established theory/ontology repair, with no independent role for a challenge-standing relation distinct from ordinary object-level acceptance, then Q_open has no independent problem kernel.**

“Faithfully” means the restatement preserves at least:

```text
who/what may challenge;
why evidence rejected at object level may still be reviewable;
the bounded scope of the challenge;
the distinction between closure defeat and replacement;
false-reopen control;
explicit regress/meta-boundary responsibility.
```

If those are already standard consequences of a neighboring theory, Q_open should be retired rather than renamed.

---

## 8. References used for this attack

1. E. Clarke, O. Grumberg, S. Jha, Y. Lu, H. Veith. **Counterexample-Guided Abstraction Refinement.** CAV 2000, LNCS 1855, pp. 154–169. DOI: `10.1007/10722167_15`.
2. R. Bloomfield, K. Netkachova, J. Rushby. **Defeaters and Eliminative Argumentation in Assurance 2.0.** 2024, arXiv:`2405.15800`.
3. K. Khakzad Shahandashti, A. B. Belle, T. C. Lethbridge, O. Odu, M. Sivakumar. **A PRISMA-driven systematic mapping study on system assurance weakeners.** Information and Software Technology 175 (2024), 107526. DOI: `10.1016/j.infsof.2024.107526`.
4. U. Gohar, M. C. Hunter, M. B. Cohen, R. R. Lutz. **A Taxonomy of Real-World Defeaters in Safety Assurance Cases.** MO2RE 2025. DOI: `10.1109/MO2RE66661.2025.00007`.
5. J. Li, J. Wang. **Calibrated Model Criticism Using Split Predictive Checks.** Journal of the American Statistical Association, online 2026. DOI: `10.1080/01621459.2026.2649585`.
6. X. Li, A. Bundy, E. Philalithis. **Signature Entrenchment and Conceptual Changes in Automated Theory Repair.** Ninth Annual Conference on Advances in Cognitive Systems, 2021.
7. T. S. Kuhn. **The Structure of Scientific Revolutions.** University of Chicago Press, 1962/1970.
8. Duhem–Quine underdetermination literature; for a modern survey see the Stanford Encyclopedia of Philosophy entry **Underdetermination of Scientific Theory**.

---

## 9. QO-1P checkpoint

Prior-art verdict:

```text
Q_open broad novelty: FAIL
Q_open narrow problem candidate: SURVIVES FOR HOSTILE TESTING
```

What survives is only:

> **regime-level challenge standing where ordinary object-level acceptance is itself part of the challenged boundary.**

This is not yet a theory and not yet established as independent of mature assurance/argumentation frameworks.

Next required step: **QO-1H hostile kill tests.**

Formal reopen: **NO**.
