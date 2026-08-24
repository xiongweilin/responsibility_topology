# Q_open — Defeasible Entitlement to Reopen a Responsibility Regime

Status: **QO-1R revised problem formulation. Research only.**

This document does **not** define a Lean object, runtime policy, legal entitlement, universal epistemology, or production governance rule.

Formal reopen: **NO**.

The earlier parked formulation on `research/q-open-formulation` remains a historical research checkpoint. This revision is intentionally narrower and is based on the current strict-Level-6 repository baseline.

---

## 1. Core question

Q_open asks:

```text
What upgrades observed failure into defeasible entitlement
not merely to repair an object inside a regime,
but to suspend unqualified closure over a bounded part of that regime?
```

More precisely:

> Given a responsibility regime that can classify, qualify, invalidate, and repair objects inside its represented vocabulary, under what conditions does evidence acquire standing to challenge the adequacy of that vocabulary, its admissibility boundary, dependency cuts, repair semantics, closure rule, or relied-upon purpose?

The word **defeasible** is essential. Reopen entitlement is neither proof that the current regime is wrong nor permission to replace it arbitrarily.

The problem is intentionally narrower than general model revision, ontology change, governance, or scientific theory change.

---

## 2. Five non-equivalent analytical layers

Q_open refuses the following collapse:

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

These are analytical layers, not a universal state machine.

### L0 — Anomaly

An anomaly is an observation, failure, contradiction, unexplained residual, rejected case, recurrent repair failure, or unrepresentable distinction that conflicts with expectations or responsibilities under the current regime.

An anomaly does not identify its cause.

Possible causes include:

```text
bad input
sensor or observation error
implementation nonconformance
incorrect local decision
stale dependency
wrong repair
mis-scoped responsibility
missing variable or relation
admissibility mismatch
purpose change
regime inadequacy
```

Therefore:

```text
Anomaly
-/->
RegimeInadequate
```

This is a research non-shortcut, not a mechanized theorem.

### L1 — Inadequacy evidence

Inadequacy evidence is structured evidence that an anomaly may be explained not merely by a bad object or execution inside the regime, but by a limitation in the regime's own representation, observation, admissibility, dependency, qualification, repair, closure, or purpose boundary.

Candidate patterns include:

```text
representational omission
observation/admissibility blindness
recurrent internally valid but ineffective repair
localization failure because relevant distinctions are absent
closure conflict with a materially relevant anchor
regime-relative contradiction
purpose/regime mismatch
```

None automatically proves inadequacy.

### L2 — Defeasible reopen entitlement

`ReopenEntitled(K, e, scope)` means informally:

> challenge evidence `e` has earned enough standing and materiality to defeat **unqualified closure** over `scope`, so that the relevant part of `K` must remain answerable to the challenge and may be inspected or revised.

The immediate consequence is intentionally limited to:

```text
ReopenEntitled(K, e, scope)
->
not UnqualifiedClosure(K, scope)
```

It does **not** imply:

```text
not CurrentOperation
shutdown
withdraw all authority
isolation
mandatory replacement
proof that K is globally inadequate
```

A reopened and unresolved challenge may coexist with explicit provisional continued operation when a separate risk/governance judgment permits it.

Whether operation must stop, authority must be withdrawn, or containment must be imposed belongs to another decision layer.

### L3 — Replacement proposal

A replacement proposal is a candidate change to some part of the regime, such as:

```text
new distinction or predicate
new dependency relation
new admissibility channel
new qualification rule
new repair/discharge structure
new closure criterion
new purpose representation
new governing regime
```

Reopen entitlement can exist without a validated replacement.

### L4 — Replacement validation

Replacement validation asks whether a proposed revision actually improves the relied-upon responsibility boundary and what it breaks, preserves, invalidates, or newly assumes.

Thus:

```text
ReopenEntitled
-/->
ReplacementValidated
```

---

## 3. Conceptual responsibility regime

For research discussion only, use:

```text
K = (V, O, A, Q, D, R, C, G)
```

where:

```text
V  represented vocabulary / distinctions
O  observation interface
A  ordinary object-level admissibility
Q  qualification / currentness rules
D  dependency / impact semantics
R  repair / discharge semantics
C  closure rules
G  relied-upon purpose / mandate / evaluation goal
```

This is a conceptual decomposition, not a formal datatype.

`G` is not an escape hatch that converts dissatisfaction into regime inadequacy. A claimed purpose change must itself be accountable and within whatever authority/meta-boundary governs reliance on `K`.

---

## 4. Challenge standing and object acceptance are distinct relations

Let:

```text
A_K(e)
```

mean informally that `e` satisfies `K`'s ordinary object-level acceptance/admissibility rules for use in object-level judgments.

Let:

```text
S_K(e, scope)
```

mean informally that `e` has sufficient provenance, intelligibility, relevance, potential materiality, and reviewability to require examination of whether `K` is adequate over `scope`.

The core Q_open hypothesis is **not** that challenge standing is weaker than acceptance.

The frozen relation is:

```text
S_K is not definitionally subordinate to A_K.
```

Q_open permits:

```text
S_K(e, scope) and not A_K(e)
```

when the reason for object-level rejection is itself part of what is being challenged.

But QO-1 does **not** assume either implication:

```text
A_K(e) -> S_K(e, scope)
S_K(e, scope) -> A_K(e)
```

The two relations answer different responsibility questions.

Mother claim:

> **Challenge standing and object acceptance are distinct responsibility relations.**

This distinction is procedural, not a truth claim. Standing does not establish that `e` is true, sufficient, or suitable for ordinary object-level use.

Standing also does not itself establish reopen entitlement; materiality, escalation/scope responsibility, and reviewability remain separate burdens.

---

## 5. Failure localization inherited from Strict Level 6

The strict-Level-6 work provides an important negative discipline for Q_open.

The repository now has practical experience separating raw executable correspondence failures from semantic conclusions. That experience should be carried forward as a failure-localization firewall:

```text
observation mismatch
!=
regime inadequacy

checker rejection
!=
regime inadequacy

implementation nonconformance
!=
regime inadequacy

local repair failure
!=
reopen entitlement
```

A mismatch may indict serialization, interpretation, implementation, local semantics, a supplied repair instance, or a regime boundary. The observed failure alone does not select which layer bears responsibility.

Therefore Q_open starts after local failure has been made visible, not after it has already been diagnosed as regime inadequacy.

This is a key bridge from technical practice to Q_open's conceptual discipline:

```text
failure visibility
!=
failure localization
!=
reopen entitlement
```

---

## 6. Reopen entitlement is a bounded defeater of closure

Q_open does not initially seek a proof predicate `RegimeInadequate(K)`.

Its narrower target is:

```text
ReopenEntitled(K, e, scope)
```

with the consequence:

```text
not UnqualifiedClosure(K, scope)
```

This means that closure over `scope` may no longer be asserted while simply ignoring the challenge.

A closure claim can recover only if the challenge is answered, defeated, narrowed, displaced to an accountable lower layer, or the governing meta-process explicitly accepts unresolved risk.

QO-1 does not specify which of those outcomes is normatively or operationally correct.

---

## 7. Scope is not a universal total order

The earlier formulation used a ladder:

```text
S0  execution / instance
S1  local decision / inference
S2  dependency / qualification / repair cut
S3  representation / vocabulary / admissibility interface
S4  purpose / governing regime
```

Retain these only as **analytical strata**.

They are not claimed to form a universal total order of reopen scopes.

A future model may require a partial order, overlap relation, or family of incomparable scopes. For example, an admissibility challenge and a dependency-model challenge may be mutually non-subsuming while both are broader than one local execution failure.

Freeze:

```text
minimal escalation
!=
unique localization
```

A bounded-scope principle can still be meaningful without a unique diagnosis:

> do not reopen a scope broader than the current challenge evidence and responsibility assumptions can justify.

But QO-1 does not assume there is always one unique narrowest scope.

---

## 8. Evidence patterns that may implicate the regime

These are candidate inadequacy-evidence patterns, not entitlement rules.

### 8.1 Recurrent repair failure

An internally valid repair repeatedly returns to the same materially relevant failure.

This may implicate the repair vocabulary or dependency boundary, but it may also reflect bad execution or repeated bad inputs.

### 8.2 Non-discriminating representation

Two materially different states collapse under the current representation while requiring different responses for the relied-upon purpose.

Conceptually:

```text
x1 != x2
alpha_K(x1) = alpha_K(x2)
requiredResponse(x1) != requiredResponse(x2)
```

This resembles abstraction-refinement failure, but Q_open cannot assume a complete concrete-state oracle.

### 8.3 Missing dependency witness

A material effect propagates through a relation that `D` cannot express, causing the current impact boundary to omit a relevant review target.

### 8.4 Closure/outcome conflict

`K` says closed/current/repaired while a materially relevant outcome remains inconsistent with `G`.

The relevant anchor must be described carefully:

```text
an anchor not generated solely by the challenged responsibility path
```

This is **not** metaphysical independence and does not posit a regime-free oracle.

The anchor may itself be institutionally, empirically, or procedurally situated and may have its own defeaters.

### 8.5 Admissibility exclusion witness

Evidence rejected by `A_K` carries a distinction relevant to whether `A_K` itself is too narrow, and that evidence can satisfy a distinct challenge-standing burden.

### 8.6 Purpose/regime mismatch

`K` may correctly execute its original mandate while current reliance has changed. This can motivate review only if the claimed purpose/mandate change is itself accountable.

---

## 9. False reopen and closure blindness

Q_open has two symmetric failure modes.

### FalseReopen

A local anomaly is escalated into regime-level revision even though an adequate lower-level explanation/discharge remains available and there is insufficient evidence that the challenged regime boundary is implicated.

Typical patterns:

```text
noisy observation -> ontology change
implementation bug -> admissibility change
one failed repair -> repair vocabulary declared inadequate
disagreement with result -> purpose redefinition
preferred outcome unavailable -> governing regime change
```

### ClosureBlindness

A potentially material challenge cannot receive review because the same object-level boundary it challenges is also the sole gate for deciding whether challenges may be heard.

Canonical pattern:

```text
PotentialChallenge(e, K)
not A_K(e)
all challenge standing requires A_K(e)
-----------------------------------
e cannot challenge A_K or K
```

Candidate mechanisms include:

```text
vocabulary exclusion
admissibility recursion
metric capture
repair absorption
closure self-certification
authority capture
```

The goal is not maximal openness. It is to avoid both self-sealing closure and unconstrained escalation.

---

## 10. Regress boundary

A distinct `S_K` immediately raises:

```text
Who defines S_K?
Who may challenge S_K?
```

QO-1 does not solve the regress by asserting a self-validating meta-rule.

Possible stopping assumptions include:

```text
institutional appeal authority
independent empirical channel
heterogeneous evidence owners
constitutional or safety boundary
human/external review
finite trusted meta-boundary
```

Each relocates responsibility and must be stated explicitly.

Do not claim that meta-review eliminates trust or that Q_open provides a final authority.

The multi-agent and ultimate closure questions remain candidates for later Q_close work.

---

## 11. Candidate decomposition of reopen entitlement

QO-1 keeps the decomposition analytical:

```text
Standing
Materiality
EscalationReason
ScopeBoundedness
Reviewability
```

No scalar score, fixed threshold, or universal algorithm is introduced.

### Standing

The challenge is accountable and intelligible enough to be reviewed.

### Materiality

If substantiated, the challenge matters to the relied-upon purpose/mandate.

Materiality cannot simply be defined as whatever `K` already accepts, or closure blindness is reintroduced. Nor can it be delegated silently to an unexplained external oracle.

### EscalationReason

There is reason not to classify the issue solely as an ordinary lower-level defect or repair problem.

### ScopeBoundedness

The requested review scope is no broader than current evidence and responsibility assumptions justify. A unique minimal scope is not assumed.

### Reviewability

Challenge provenance, reasoning, and subsequent revision decisions remain auditable.

---

## 12. Defeaters of reopen entitlement

A candidate reopen entitlement can be defeated or narrowed when, for example:

```text
the anomaly is explained by known input/measurement corruption
a lower-level repair resolves the material issue
the challenge duplicates an answered issue without new evidence
the evidence is irrelevant to the relied-upon purpose
the alleged representation failure disappears under an already-supported observation
the requested scope is much broader than the evidence supports
source/provenance is too weak even for challenge standing
independent evidence contradicts the claimed inadequacy mechanism
```

These are not yet a complete defeater calculus.

---

## 13. Relationship to Paper 3 and runtime reopen

Paper 3 reasons inside a supplied repair ontology. It separates repair selection, realization, represented-cut necessity, and extraction completeness.

Q_open begins at the boundary:

```text
Paper 3:
  given represented repair obligations/cuts,
  reason about repair.

Q_open:
  when is there defeasible reason to question whether
  the represented obligations/cuts are adequate for closure?
```

Q_open must therefore not be reduced to “generate a larger RepairProblem.”

`portable-runtime` already represents operational reopen scopes and routes deeper reopen to reframing rather than simple retry. That is engineering precedent for distinguishing retry from reframing, but it does not establish the entitlement criterion for selecting a reopen scope.

---

## 14. Research propositions after QO-1R

These are hypotheses, not theorems.

### QO-P1 — Standing/acceptance distinction

Challenge standing and object acceptance are distinct responsibility relations; neither implication is assumed universally.

### QO-P2 — Closure-defeater interpretation

Reopen entitlement is initially modeled as bounded defeat of unqualified closure, not proof of global inadequacy and not an operation-stop rule.

### QO-P3 — Bounded escalation without unique localization

A challenge should not justify a broader scope than its evidence supports, even when multiple incomparable scopes remain plausible.

### QO-P4 — No failure-to-reopen shortcut

Anomaly, observation mismatch, checker rejection, implementation nonconformance, or local repair failure does not by itself establish reopen entitlement.

### QO-P5 — Preservation of challenge history

Any later revision method should preserve enough challenge/reopen history to audit why closure was defeated and how it was subsequently restored or left unresolved.

---

## 15. What would seriously narrow or kill this formulation?

The problem kernel should be rejected or narrowed if, for relevant regimes, research shows that:

```text
challenge standing safely collapses into ordinary object acceptance;
there is no coherent bounded closure state distinct from operation status;
all useful regime-level revision triggers are already fully captured by
  established neighboring theories without a distinct standing problem;
bounded scope responsibility becomes meaningless under diagnosis underdetermination;
standing without acceptance cannot be controlled against flooding/false reopen;
materiality or appeal authority can only be supplied by an unexplained infinite regress.
```

These are genuine research risks.

---

## 16. QO-1R checkpoint

The revised problem target is:

```text
How can evidence acquire standing to challenge
an admissibility/closure regime itself
when that evidence need not already satisfy
that regime's ordinary object-level acceptance rules,
without turning every anomaly into regime-level reopening?
```

Current frozen distinctions:

```text
Anomaly != InadequacyEvidence
InadequacyEvidence != ReopenEntitlement
ChallengeStanding != ObjectAcceptance
ReopenEntitlement -> not UnqualifiedClosure
Correspondence/implementation/local-repair failure != RegimeInadequacy
minimal escalation != unique localization
```

The next required step is **QO-1P prior-art attack**, with assurance-case defeaters treated as a first-class strong neighbor.

Formal reopen: **NO**.
