# QX — Representation Inadequacy Problem Kernel

Status: **QX-1 pre-formal problem kernel. Research only.**

Formalization: **NO**.

This document restates the unresolved mother problem after the QO standing/closure operationalization was rejected by falsification. It does not revive `ChallengeStanding`, `ClosureDefeater`, `ReopenEntitled`, or any renamed equivalent.

## 1. Mother question

QX asks:

> **How can a finite system obtain defensible evidence that its current space of distinctions is inadequate for a relied-upon responsibility task without already knowing the correct refinement?**

The target is narrower than general self-improvement and weaker than successful revision.

QX is about suspicion of representational insufficiency, not authority to change the representation.

## 2. Three analytical layers

Freeze:

```text
Anomaly
!=
SuspectInadequacy
!=
AuthorizedRevision
```

These are analytical roles, not a state machine.

### 2.1 Anomaly

An anomaly is a task-relevant failure, contradiction, unexplained residual, repeated miss, unexpected outcome, incompatible demanded response, or observation that the current system does not handle as expected.

An anomaly can arise from many causes:

```text
bad input
measurement/observation error
implementation bug
stale state
wrong local decision
wrong policy
partial observability
unknown class
model misspecification
bad task specification
representation insufficiency
```

Therefore:

```text
Anomaly
-/->
RepresentationInadequate
```

### 2.2 SuspectInadequacy

`SuspectInadequacy` is only a conceptual label for the research target:

> evidence supports treating inadequacy of the current distinction space as a live explanatory hypothesis for a relied-upon task.

It does not mean the system knows what is missing.

Freeze:

```text
SuspectInadequacy
-/-> know the missing distinction
-/-> know a better representation
-/-> know the correct refinement
-/-> AuthorizedRevision
-/-> RegimeFailure
```

QX-1 does not define a predicate or algorithm for `SuspectInadequacy`.

### 2.3 AuthorizedRevision

Authorized revision concerns whether and how a system may change its representation, observation interface, policy, model, or task specification.

QX does not currently study this layer.

A representation may be reasonably suspected to be insufficient while revision remains unauthorized, unsafe, underspecified, or unavailable.

## 3. Conceptual objects

These objects are research vocabulary only.

### 3.1 Finite system

A **finite system** is a system whose current decision-relevant representational resources are finitely describable for the task under study.

QX does not require the physical world, observation stream, or set of possible future situations to be finite.

The finitude claim applies to the current represented candidate/distinction space used by the system.

### 3.2 Distinction space V

Let:

```text
V
```

denote the finite space of distinctions the system can currently use for task-relevant representation.

`V` may be a state abstraction, vocabulary, partition, finite model class, finite hypothesis family, finite feature coding, or another finite decision-relevant representation.

QX must not assume that `V` is the true state space.

### 3.3 Encounter space X

For analysis only, use:

```text
X
```

for situations/encounters about which the relied-upon task makes demands.

`X` is not assumed to be fully visible, finitely enumerable, or available to the system as a ground-truth oracle.

### 3.4 Representation alpha_V

Use conceptually:

```text
alpha_V : X -> V
```

only when a domain supplies a meaningful mapping from task situations to represented distinctions.

This notation must not smuggle in full access to `X`.

In partially observable domains the available mapping may instead be mediated by observations, histories, or belief states.

### 3.5 Relied-upon responsibility task T

Let:

```text
T
```

denote the task for which the representation is relied upon.

`T` must identify the relevant responsibility burden without assuming the answer to the representation problem.

Examples may eventually include:

```text
which response is permitted/required;
which cases must be distinguished;
which risk or obligation class must be assigned;
which decision must remain correct under the relied-upon specification.
```

QX does not assume one universal task semantics.

### 3.6 Responsibility-relevant difference

A difference between situations `x` and `y` is **responsibility-relevant for T** only when an independently justified task/accountability source requires treating the situations differently for the relied-upon responsibility purpose.

Crucial prohibition:

```text
invent a finer representation
-> observe that it distinguishes x and y
-> declare the distinction responsibility-relevant
```

is circular.

The source of responsibility relevance must not be generated solely by the proposed refinement whose necessity is being argued.

## 4. The central certificate problem

The easy mathematical observation is familiar:

```text
alpha_V(x) = alpha_V(y)
```

can force any policy that factors only through `V` to treat `x` and `y` identically.

If a separately justified task specification requires incompatible responses, then the current representation cannot support both requirements through a `V`-factored policy.

But QX does **not** treat that observation as the research contribution.

The hard question is upstream:

> **How does a finite system obtain evidence for the responsibility-relevant incompatibility without already possessing the correct finer representation or a complete external oracle?**

This is the certificate problem.

## 5. Candidate certificate families, not accepted criteria

QX-1 records candidate evidence shapes only so QX-2 can try to eliminate them against prior art.

### 5.1 Aliasing-with-independent-accountability witness

Conceptual shape:

```text
alpha_V(x) = alpha_V(y)
```

while a separately justified accountability source requires incompatible task responses.

Risk:

```text
post-hoc or oracle-supplied Resp(x) != Resp(y)
```

may make the result tautological.

### 5.2 Finite represented-candidate exhaustion

Conceptual shape:

```text
H_V = {h1,...,hn}
forall h in H_V, Fail(h,C)
```

Safe conclusion only:

```text
current represented candidate space is exhausted relative to C
```

Do not infer:

```text
reality has no explanation;
the missing explanation is outside V in a particular direction;
the correct refinement is known;
revision is authorized.
```

Finiteness matters here only if it turns testing of the current represented candidate set into an exhaustive certificate relative to the stated criterion `C`.

### 5.3 Persistent task conflict under representation-preserving repair

A system may repeatedly modify parameters, policies, or local hypotheses while preserving `V`, yet a task-relevant conflict persists.

This may support suspicion that the problem is representational.

It may also indicate poor optimization, bad data, wrong dynamics, or misspecified task requirements.

Therefore it is not yet an insufficiency criterion.

## 6. Oracle firewall

QX rejects a regime-independent omniscient observer as a default assumption.

A future insufficiency certificate may rely on evidence not generated solely by the current representation path, but that evidence must expose its own source and limitations.

Examples of possible external/heterogeneous evidence include:

```text
held-out observations;
independently governed accountability requirements;
separately measured outcomes;
contradictory downstream obligations;
inter-agent evidence with a different representation;
```

None is automatically privileged or infallible.

## 7. QO negative-control inheritance

QX inherits only methodological firewalls from the archived QO lineage.

In particular:

```text
observation mismatch
-/-> representation inadequacy

implementation nonconformance
-/-> representation inadequacy

reviewability
-/-> representation inadequacy

use-specific inadmissibility
-/-> representation inadequacy
```

QX does not inherit `ChallengeStanding`, `ReopenEntitled`, or closure semantics.

## 8. Required prior-art attack

Before any QX candidate is promoted, QX-2 must attack at least:

```text
unawareness / partial-state-space models;
awareness of unawareness;
open-set / open-world recognition;
unknown-unknown discovery;
state aliasing and state aggregation;
POMDP representation learning;
CEGAR / abstraction refinement;
model misspecification / model criticism.
```

The question is not whether these literatures use different names.

The question is whether they already provide the same evidence role and consequence without loss.

## 9. QX-1 kill conditions

QX should stop if prior art already supplies a complete account of:

```text
how a finite/coarse representation can recognize its own possible insufficiency;
what evidence certifies that insufficiency without a known correct refinement;
how ordinary uncertainty/misspecification is separated from representation insufficiency;
what conclusion follows without overclaiming revision or truth.
```

QX should also stop if every proposed certificate requires either:

```text
a complete external ground-truth state;
a pre-specified correct finer representation;
a post-hoc responsibility difference chosen to manufacture failure;
or a definition of inadequacy that merely restates the observed conflict.
```

## 10. Formal gate

No Lean work is authorized by QX-1.

The formal gate remains closed until:

```text
objects stabilize;
prior-art residual is nonempty;
certificate source is independent enough to avoid tautology;
kill protocol is preregistered;
a theorem/countermodel obligation is non-definitional.
```

Current status:

```text
QX problem kernel: OPEN FOR PRIOR-ART ATTACK
QX theory: NOT ESTABLISHED
QX certificate criterion: NOT ESTABLISHED
QX formalization: NO
```
