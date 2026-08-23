# Q_open — Defeasible Entitlement to Reopen a Responsibility Regime

Status: QO-1 problem formulation. Research only.

This document does **not** define a Lean object, runtime policy, legal entitlement, universal epistemology, or production governance rule.

Formal kernels remain frozen.

## Core question

The next theoretical problem is:

```text
What upgrades model failure into defeasible entitlement
to reopen the model?
```

More precisely:

> Given a finite responsibility regime that can correctly classify, qualify, invalidate, and repair objects **inside its represented vocabulary**, under what conditions does observed failure acquire standing not merely as another object-level defect, but as defeasible reason to suspend closure and reconsider the vocabulary, dependency cuts, admissibility rules, or governing regime itself?

The word **defeasible** is essential. Reopen entitlement is neither proof that the current regime is wrong nor permission to replace it arbitrarily.

---

# 1. The five non-equivalent layers

Q_open begins by refusing the following collapse:

```text
anomaly
!=
inadequacy evidence
!=
reopen entitlement
!=
replacement proposal
!=
replacement validation
```

These are five different responsibility positions.

## L0 — Anomaly

An **anomaly** is an observation, failure, contradiction, unexplained residual, rejected case, recurrent repair failure, or unrepresentable distinction that conflicts with expectations or responsibilities under the current regime.

Anomaly is initially weak evidence.

An anomaly can be:

```text
represented
  the regime can encode the failure in its own vocabulary

boundary-visible
  the regime can observe a failure signal but cannot classify it adequately

representation-external
  a relevant distinction is visible to some challenge channel
  but lacks an object-level representation inside the regime
```

An anomaly does not identify its cause.

It may arise from:

```text
bad input
sensor error
execution defect
incorrect local decision
stale dependency
wrong repair
mis-scoped responsibility
missing variable
bad ontology
inadmissible-but-relevant evidence
changed purpose
governing regime inadequacy
```

Therefore:

```text
Anomaly
-/->
RegimeInadequate
```

This arrow is a conceptual non-claim, not a mechanized non-implication theorem.

## L1 — Inadequacy evidence

**Inadequacy evidence** is structured evidence that the anomaly may be explained not merely by a bad object inside the regime but by a limitation of the regime's own representation, admissibility, dependency, discharge, or closure machinery.

This remains defeasible evidence.

Candidate evidence classes include:

```text
E1  representational omission
    materially relevant distinctions repeatedly collapse
    because the vocabulary cannot express them

E2  observation blindness
    discriminating evidence cannot enter the ordinary observation/admissibility path

E3  repair degeneracy
    internally valid repair repeatedly returns the system to the same failure
    without resolving the relied-upon purpose

E4  localization failure
    the regime can detect failure but its own dependency/cut vocabulary
    cannot distinguish materially different causes or scopes

E5  closure conflict
    the regime classifies an issue as closed/current/adequately repaired
    while an independently anchored outcome remains materially unacceptable

E6  regime-relative contradiction
    two internally legitimate procedures or views produce incompatible
    obligations that cannot be adjudicated using the current responsibility cuts

E7  purpose drift
    the purpose for which the regime is relied upon changes enough that
    old conformance no longer establishes relevant fitness
```

None of these automatically establishes inadequacy. They establish a **case for meta-level review** only when supported by provenance, relevance, and a reason the evidence cannot be discharged entirely at a lower layer.

## L2 — Defeasible reopen entitlement

A **reopen entitlement** is standing to suspend the presumption of closure over a bounded scope of the regime and to inspect or revise that scope.

It is not:

```text
proof that the regime is false
proof that the anomaly is correctly diagnosed
permission to discard all prior history
permission to install any replacement
proof that a replacement exists
```

Its immediate effect is procedural/epistemic:

```text
closure may no longer be asserted without answering the challenge
```

This formulation deliberately treats reopen entitlement as a **defeater of closure**, not as a positive theorem that the current regime is globally inadequate.

## L3 — Replacement proposal

A replacement proposal is a candidate change to some part of the regime:

```text
new distinction / predicate
new dependency edge class
new admissibility channel
new qualification rule
new repair/discharge structure
new closure criterion
new purpose/goal representation
new regime entirely
```

Reopen entitlement can exist before a satisfactory replacement proposal exists.

Therefore:

```text
ReopenEntitled
-/->
ExistsValidatedReplacement
```

The absence of a replacement may justify conservative temporary operation, containment, human escalation, or explicit unresolved status; it does not retroactively erase the reason to review the old regime.

## L4 — Replacement validation

Replacement validation asks whether a proposed regime or vocabulary change actually improves the relied-upon responsibility boundary.

At minimum it must distinguish:

```text
resolves the motivating failure
preserves or intentionally revises prior successful cases
introduces new blind spots
changes admissibility/authority assumptions
changes purpose or evaluation standard
remains auditable and reversible where required
```

Replacement validation is a different problem from entitlement to start the review.

---

# 2. What is a responsibility regime in Q_open?

Q_open needs a target broader than the current Lean state but narrower than a universal ontology.

For research discussion, treat a responsibility regime `K` as a structured package:

```text
K = (
  V,   vocabulary / object and relation distinctions
  O,   observation interface
  A,   object-level admissibility rules
  Q,   qualification/currentness rules
  D,   dependency / impact semantics
  R,   repair / discharge semantics
  C,   closure rules
  G    relied-upon purpose / mandate / evaluation goal
)
```

This is a **conceptual decomposition**, not a formal datatype.

The components answer different questions:

```text
V  What can the regime say?
O  What can the regime observe?
A  What can count as object-level evidence/input?
Q  What counts as currently usable/current/authorized/fit?
D  What is considered affected by a change?
R  What counts as sufficient discharge/repair?
C  When may the regime treat the matter as closed?
G  For what purpose is the regime being relied upon?
```

The inclusion of `G` is forced by cross-domain candidate CI-3:

```text
local conformance does not by itself settle
higher-order adequacy/validity/fitness for the relied-upon purpose.
```

Without an explicit purpose or mandate, the phrase “adequate regime” is underspecified.

---

# 3. The first theoretical distinction: standing is not acceptance

The central anti-closure-blindness hypothesis is:

```text
challenge standing
!=
object-level acceptance
```

This is the strongest QO-1 candidate distinction.

## 3.1 Object-level admissibility

Let `A_K(e)` mean informally:

> evidence/object `e` satisfies the ordinary admissibility requirements of regime `K` for use inside its object-level judgments.

Examples include:

```text
approved evidence type
recognized provenance
valid measurement class
known relation type
accepted authorization source
recognized claim vocabulary
```

## 3.2 Meta-level challenge standing

Let `S_K(e, scope)` mean informally:

> `e` has enough provenance, intelligibility, relevance, and potential materiality to require review of whether `K` is adequate over `scope`.

`S_K` does **not** assert that `e` is true, accepted, or sufficient to support an ordinary object-level conclusion.

The point is procedural:

```text
S_K(e, scope)
```

can hold even when:

```text
not A_K(e)
```

if the reason for non-admissibility is itself part of what is under challenge.

This yields a key research proposal:

> **A finite regime needs a challenge-standing boundary weaker than object-level acceptance if it is to avoid making its own vocabulary the sole judge of evidence against that vocabulary.**

This is not yet claimed as a universal invariant. It is the central hypothesis for Q_open.

## 3.3 Why this is not “accept anything”

Challenge standing should require a narrower but real burden such as:

```text
identifiable provenance or accountable source
statement intelligible enough to review
connection to the relied-upon purpose or closure claim
potential materiality if the challenge were substantiated
scope indication or at least a reason ordinary classification is failing
non-triviality beyond a duplicate already discharged challenge
```

These conditions grant review standing, not truth.

Thus:

```text
challengeStanding
-/->
objectLevelTruth
```

and:

```text
challengeStanding
-/->
mandatory regime replacement
```

---

# 4. Reopen entitlement as a closure defeater

The initial Q_open model should not try to prove `K` inadequate.

Instead define the target relation conceptually as:

```text
ReopenEntitled(K, e, scope)
```

meaning:

> Given challenge evidence `e`, the current closure presumption over `scope` is defeasibly defeated; review may inspect or revise the relevant vocabulary, admissibility, dependency, qualification, repair, closure, or purpose boundary.

The immediate consequence is:

```text
MaintainClosure(K, scope)
```

now carries an additional responsibility:

```text
answer or discharge e at an adequate layer
```

This gives Q_open a narrower target than “prove the model wrong.”

It asks when closure loses its entitlement.

---

# 5. Scope discipline: reopen should escalate minimally

Q_open must solve both overreaction and blindness.

A useful scope ladder is:

```text
S0  execution / instance
S1  local decision / inference
S2  dependency, qualification, or repair cut
S3  representation / vocabulary / admissibility interface
S4  goal, purpose, or governing regime
```

This is not copied as a theorem from `portable-runtime`; it is a research scope hierarchy. The runtime's existing reopen scopes are an engineering neighbor, not its definition owner.

## Minimal escalation principle

Candidate principle:

> Reopen entitlement should be granted at the narrowest scope that can account for the inadequacy evidence without suppressing a materially relevant distinction.

This guards against:

```text
one failed execution
-> replace ontology
```

while still permitting escalation when lower-level repair repeatedly fails.

## Escalation witness

Moving from `S_i` to `S_{i+1}` should require at least one explicit reason such as:

```text
lower-scope repair has been attempted and failure persists
lower-scope diagnosis is underdetermined because required distinctions are absent
ordinary evidence needed to discriminate causes is inadmissible by construction
closure at lower scope conflicts with independently anchored outcomes
purpose/mandate changed beyond the old representation's intended range
```

No fixed universal threshold is claimed at QO-1.

---

# 6. False reopen

The first symmetric failure is:

```text
false reopen
```

Informally:

> A local anomaly is escalated into regime-level revision even though an adequate lower-level explanation/discharge remains available and there is insufficient evidence that the regime boundary is implicated.

Typical false-reopen patterns:

```text
FR1  noisy or erroneous observation -> ontology change
FR2  ordinary implementation bug -> representation change
FR3  one failed repair action -> conclude repair vocabulary inadequate
FR4  disagreement with a result -> redefine admissibility rules
FR5  unavailable preferred outcome -> redefine goal/regime
FR6  outlier inside known accepted limits -> global model replacement
```

A conservative regime is not automatically defective for refusing these escalations.

## False-reopen guard candidate

Before escalating to representation/regime scope, require evidence that at least one of the following is true:

```text
ordinary repair has failed in a repeated or materially severe way
available lower-level hypotheses do not discriminate the observed failure
relevant evidence cannot be represented/admitted at the lower layer
current closure produces a material contradiction with an independent anchor
purpose changed outside the old regime's stated responsibility envelope
```

This is a research candidate, not a complete decision procedure.

---

# 7. Closure blindness

The opposite failure is:

```text
closure blindness
```

The core pattern is:

```text
exists e:
  e would justify review of K,
  but K prevents e from acquiring standing
  because admissibility/representation is controlled by the same
  boundary that e challenges.
```

More explicitly:

```text
PotentialChallenge(e, K)
+
not A_K(e)
+
all review standing requires A_K

-> e can never challenge K
```

This is a circular closure architecture.

## Closure-blindness mechanisms

### CB1 — vocabulary exclusion

The regime has no category for the distinction carried by the challenge, so the evidence is coerced into an existing category or discarded.

### CB2 — admissibility recursion

Only evidence already certified under the current regime may question the current regime.

### CB3 — metric capture

The regime evaluates adequacy only through metrics it itself optimizes, so failures outside those metrics have no standing.

### CB4 — repair absorption

Every anomaly is automatically classified as another local repair problem, making representation-level failure impossible to express.

### CB5 — closure self-certification

A closure state is considered evidence that all relevant objections have been handled, while the rules defining relevance are themselves under challenge.

### CB6 — authority capture

Only the authority whose decision/regime is challenged may grant standing to the challenge, with no independent appeal boundary.

## Anti-blindness requirement

A candidate Q_open architecture should support:

```text
standing without acceptance
```

and preserve the challenge long enough for an accountable meta-review to decide whether ordinary admissibility was appropriately restrictive or pathologically self-sealing.

---

# 8. The regress problem is real and not solved here

Introducing `S_K`, a challenge-standing relation, immediately raises:

```text
Who defines S_K?
Who judges whether S_K itself is adequate?
```

QO-1 does not solve this regress by hiding it.

Possible future stopping assumptions include:

```text
explicit institutional appeal authority
independent empirical channel
multiple heterogeneous evidence owners
constitutional/safety boundary
human or external review
finite trusted meta-boundary
```

Each simply relocates responsibility.

Therefore a future theory must state its trusted/meta boundary explicitly.

Do not claim:

```text
meta-review eliminates the need for trust
```

or:

```text
Q_open can be solved by one self-validating rule
```

The multi-agent/authority version of this problem is likely part of later `Q_close` work.

---

# 9. Candidate evidence that a failure implicates the regime

QO-1 needs positive evidence patterns stronger than anomaly but weaker than proof of inadequacy.

## 9.1 Recurrent repair failure

```text
same or structurally equivalent failure
persists after multiple internally valid repairs
```

This raises the probability that the repair vocabulary or dependency cut is incomplete.

It does not prove that conclusion; repeated repair may simply be badly executed.

## 9.2 Non-discriminating ontology

Two materially different states map to the same represented state but require different safe/valid responses.

Conceptual witness:

```text
x1 != x2 in relied-upon reality/purpose
alpha_K(x1) = alpha_K(x2)
but requiredResponse(x1) != requiredResponse(x2)
```

This is a strong candidate form of representational inadequacy evidence.

It resembles an abstraction-refinement failure, but Q_open cannot assume a complete concrete-state oracle.

## 9.3 Missing dependency witness

A material failure propagates through a relation the regime cannot express, causing its impact boundary to omit a necessary review target.

This is particularly relevant to the Paper 3 extraction-completeness boundary.

## 9.4 Closure/outcome contradiction

The regime's own closure rule says:

```text
closed / repaired / current
```

while an independently anchored outcome remains materially inconsistent with the relied-upon purpose.

The word **independently** is doing real work. A metric generated solely by `K` is weaker evidence against `K`.

## 9.5 Admissibility exclusion witness

Evidence rejected by `A_K` would, if reviewed under a weaker challenge-standing boundary, reveal a distinction relevant to whether `A_K` itself is too narrow.

This is a direct closure-blindness witness.

## 9.6 Purpose/regime mismatch

The regime is correctly executing its original mandate, but the relied-upon purpose has changed.

This is not necessarily “failure” in the ordinary sense. It is evidence that current reliance on the unchanged regime may be inadequate.

---

# 10. Candidate structure of reopen entitlement

QO-1 does not choose a final logic, but a useful decomposition is:

```text
ReopenEntitled(K, e, scope)
requires evidence for several independent responsibilities:

Standing
Materiality
EscalationReason
ScopeBoundedness
Reviewability
```

## Standing

`e` is accountable/intelligible/relevant enough to demand review.

## Materiality

If `e` is substantiated, it matters to the purpose/mandate `G` for which `K` is relied upon.

## EscalationReason

There is reason not to treat the case solely as a lower-level instance/repair failure.

## ScopeBoundedness

The requested reopen scope is no broader than the evidence currently supports.

## Reviewability

The challenge and subsequent regime changes remain inspectable; the review process does not erase the history needed to evaluate why reopening occurred.

These responsibilities are deliberately conjunctive in the conceptual proposal.

No numeric score or scalar cost is introduced.

---

# 11. Defeaters of reopen entitlement

A reopen entitlement may be defeated or narrowed by evidence that:

```text
D1  the anomaly was produced by known measurement/input corruption
D2  a lower-level repair fully resolves the material failure
D3  the challenge duplicates an already answered issue with no new evidence
D4  the evidence is irrelevant to the relied-upon purpose
D5  claimed representation failure disappears once a missing but already supported observation is supplied
D6  the requested scope is much broader than the evidence supports
D7  the challenge source/provenance is too weak even for meta-level standing
D8  independent evidence contradicts the claimed inadequacy mechanism
```

A defeater need not restore full confidence in the regime. It may simply narrow the reopen scope.

---

# 12. Reopen entitlement is not a replacement-selection rule

A major discipline rule is:

```text
permission to inspect/change K
!=
choice of K'
```

Once reopening begins, replacement proposals have separate burdens:

```text
explain motivating failures
state changed vocabulary/relations explicitly
show which previous judgments migrate
show which previous judgments are invalidated
expose new assumptions
validate against independent or held-out evidence where meaningful
preserve rejected counterexamples/challenges
```

This separation prevents a system from using the existence of a preferred replacement as retrospective proof that the old regime deserved reopening.

---

# 13. Relationship to current Paper 3 repair semantics

Paper 3 operates **inside a supplied repair ontology**.

It deliberately separates:

```text
RepairProblem
RepairSet
RepairRealization
represented-cut necessity
extraction completeness
ordered execution
```

Q_open starts exactly where that paper stops.

The critical boundary is:

```text
Given the right repair cuts,
Paper 3 can reason about repair selection and realization.

Q_open asks when there is reason to think
the current responsibility cuts are not the right cuts.
```

Therefore Q_open must not be implemented as:

```text
just generate a larger RepairProblem
```

without first answering why the existing ontology is entitled to be revised.

---

# 14. Relationship to current runtime reopen semantics

`portable-runtime` already represents operational reopen scopes including:

```text
execution
decision
representation
inputs
goal
authorization
evidence-acquisition
verification
problem-definition
```

and deep reopen routes to a reframing work item rather than auto-rerunning the original workflow.

This is useful engineering evidence for preserving a distinction between retry and reframing.

It does **not** solve Q_open because the runtime consumes a `ReopenAssessment` with a selected `revision_scope` and reason. It does not prove that the assessment has correctly earned entitlement to reopen that scope.

Thus:

```text
represented reopen decision
!=
justified reopen entitlement
```

---

# 15. Relationship to CI-2 and CI-3

## CI-2

```text
Affectedness does not by itself constitute sufficient discharge.
```

Q_open adds a higher-order analogue:

```text
Failure does not by itself constitute entitlement to revise the regime.
```

The latter is not yet promoted as a cross-domain invariant; it is the problem under study.

## CI-3

```text
Conformance within a represented regime does not by itself settle
higher-order adequacy/validity/fitness for the relied-upon purpose.
```

Q_open asks what evidence and standing make that higher-order evaluation actionable.

---

# 16. First candidate research propositions

These are **research propositions**, not theorems.

## QO-P1 — Standing/acceptance separation

A regime capable of principled self-reopening requires some challenge-standing path not definitionally identical to object-level admissibility.

## QO-P2 — Closure-defeater interpretation

Reopen entitlement is better modeled first as defeasible loss of closure entitlement over a bounded scope than as proof of global regime inadequacy.

## QO-P3 — Minimal escalation

Evidence should reopen the narrowest responsibility layer capable of accounting for the inadequacy evidence without suppressing a materially relevant distinction.

## QO-P4 — No anomaly-to-reopen shortcut

Anomaly alone is insufficient; the transition to reopen entitlement carries separate standing, materiality, escalation, and scope responsibilities.

## QO-P5 — Preservation of challenge history

A regime revision process should preserve the anomaly/challenge/reopen history needed to audit why the old regime was reopened and why the replacement was accepted.

## QO-P6 — Adequacy cannot be reduced to local conformance

No amount of proof that `K` executed its own rules correctly can, by itself, discharge the higher-order question whether those rules remain adequate for `G`.

---

# 17. What would falsify or seriously narrow this formulation?

QO-1 itself must be falsifiable.

The formulation would narrow if research shows that:

```text
F1  challenge standing can always be reduced safely to object-level admissibility
    without producing closure blindness in relevant regimes

F2  regime-level inadequacy can always be localized from anomaly evidence
    without an independent meta-review responsibility

F3  real systems cannot meaningfully distinguish closure entitlement
    from positive proof of regime adequacy

F4  minimal reopen scope is incoherent because representation changes
    necessarily alter all higher/lower layers simultaneously

F5  standing without acceptance is too permissive to control false reopen
    even with provenance/materiality/scope burdens
```

These are open research risks, not rhetorical possibilities.

---

# 18. What QO-1 intentionally does not solve

Do not claim answers yet to:

```text
how to compute challenge standing automatically
how to identify all omitted variables/relations
how to prove extraction completeness
how to choose the optimal replacement vocabulary
how to compare incommensurable regimes universally
who has ultimate normative/legal authority to reopen
how to avoid infinite meta-level regress
how multiple agents share or close responsibility
how to make Q_open decidable
how to mechanize general ontology adequacy
```

The purpose of QO-1 is to make these responsibilities visible rather than hide them inside one `reopen : Bool`.

---

# 19. Initial research architecture

The problem can now be represented as:

```text
                 ordinary object-level path

observation
   |
   v
anomaly --------------------------+
   |                               |
   | ordinary diagnosis/repair     | challenge-standing path
   v                               v
local discharge             inadequacy evidence
   |                               |
resolved?                           | standing + materiality
   | yes                           | + escalation reason
   v                               | + bounded scope
 remain closed                     v
                            reopen entitlement
                                   |
                                   | suspend closure over scope
                                   v
                            replacement search
                                   |
                                   v
                            proposal K'
                                   |
                                   v
                            replacement validation
                                   |
                                   v
                             adopt / reject / remain open
```

The important structural feature is the side channel:

```text
challenge standing
```

which prevents ordinary admissibility from being the only route by which the regime can learn that its admissibility boundary may itself be defective.

---

# 20. QO-1 decision

The research target is now narrow enough to proceed:

```text
Q_open is NOT:
  automatic anomaly-driven ontology replacement.

Q_open IS:
  a theory of when evidence earns defeasible standing
  to suspend closure over a bounded responsibility-regime scope.
```

The strongest current hypothesis is:

```text
challenge standing != object-level acceptance
```

combined with:

```text
reopen entitlement = defeater of closure,
not proof of global inadequacy.
```

The two principal failure modes remain symmetric:

```text
false reopen
closure blindness
```

Next theoretical work, if continued, should attack these two hypotheses with prior art and counterexamples before any formalization is attempted.

Formal reopen: **NO**.