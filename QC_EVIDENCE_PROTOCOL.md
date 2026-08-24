# QC Evidence Protocol

Status: **PRE-FORMAL EVIDENCE METHOD**.

Formalization: **NO**.

This protocol governs QC source acquisition after QC-3A. It does not define a generic shared-reliance object.

## 1. Evidence pipeline

Every case must pass through this order:

```text
RawSources
-> MaterialFactsFreeze
-> NativeDecomposition
-> RivalFit
-> SharedDeterminationExistenceGate
-> Residual
-> SharedRelianceConsequence
```

The order is mandatory. In particular, ordinary theories may not be used to decide in advance which source-backed facts are material.

## 2. MaterialFactsFreeze

Before naming a rival explanation, record source-backed answers to at least:

```text
who determined what;
who actually relied;
what evidence each actor owned;
what changed;
who could revise locally;
who could revise the shared state;
what downstream action depended on continued validity;
what counterfactual consequence follows from withdrawal/change.
```

Also record, when available:

```text
time of determination;
time of reliance;
time of local change;
notification path;
revocation/revalidation path;
contractual or protocol authority;
which facts are direct source facts vs analyst inference.
```

A case may fail here if the sources do not support reconstruction of the relevant reliance/currentness timeline.

## 3. NativeDecomposition

Describe the case first in domain-native vocabulary.

Do not begin with QC terms such as:

```text
shared determination
shared reliance
provisional qualification
joint responsibility
```

unless the source itself uses an equivalent operational object.

Required native axes include:

```text
local representations;
local determinations;
shared artifacts/records if any;
evidence ownership;
decision authority;
qualification/currentness;
delegation;
revocation/revalidation;
versioning/notification;
responsibility owner;
local vs shared consequence.
```

## 4. RivalFit

Ordinary decomposition is not satisfied by descriptive relabeling.

A rival counts as sufficient only if it preserves all frozen material facts across four dimensions:

```text
DESCRIPTIVE:    identifies the relevant actors, objects, states, and transitions;
CAUSAL:         explains why the observed change/failure/success occurred;
NORMATIVE:      preserves who was authorized/obligated/permitted to act or rely;
COUNTERFACTUAL: preserves what would happen if a material actor withdrew, changed qualification,
                failed to notify, or exercised its revision authority.
```

A statement such as

```text
this is a versioning problem
```

is not eliminative unless versioning semantics preserve those four dimensions without material loss.

Strong ordinary rivals include, as appropriate:

```text
consensus / replicated state;
quorum / trust configuration;
centralized or federated authority;
delegation contracts;
semantic mapping / ontology / units;
credential issuance and revocation;
versioning and cache invalidation;
notification/subscription;
service ownership;
workflow revalidation;
local policy composition.
```

## 5. SharedDeterminationExistenceGate

The following are not enough to establish a QC shared determination:

```text
same object;
same identifier;
same label;
local agreement;
coordinated action;
mutual awareness;
distributed trust data;
absence of one global operator.
```

A case must source-back a bounded common basis `d` such that:

```text
multiple parties actually rely on d as a common basis
for a specified downstream decision/action/reliance position.
```

The audit must distinguish:

```text
A relies on local determination d_A
and
B relies on local determination d_B
with d_A currently agreeing with d_B
```

from:

```text
A and B both rely on the same bounded determination d.
```

If the source facts support only coincident local determinations, the gate fails.

## 6. Final-arbiter test

`No central authority` is not equivalent to `no final arbiter`.

For the specific shared determination `d`, ask whether there exists an actor `i` such that:

```text
i can unilaterally settle the continued validity of shared d
for the relevant bounded reliance position.
```

If yes, ordinary authority/revocation models have a strong prima facie explanation.

Different actors may still have final authority over different local determinations. That is not itself QC.

## 7. Residual computation

Only after RivalFit and SharedDeterminationExistenceGate compute conceptually:

```text
Delta_D = material facts not preserved by the strongest ordinary decomposition.
```

A nonempty `Delta_D` is not yet a generic QC relation. It is only a case-specific residual.

A positive residual must identify the exact missing responsibility fact, not merely say that the ordinary model feels incomplete.

## 8. SharedRelianceConsequence

A residual matters for QC only if it changes a bounded shared-reliance consequence.

Record at least one source-backed or tightly source-grounded counterfactual of the form:

```text
if local qualification / delegation / evidence status changes,
what happens to the common bounded basis d,
who may continue relying,
who must notify/revalidate/withdraw,
and who can settle continued validity?
```

Without a material consequence for continued shared reliance, the case does not promote QC.

## 9. Corpus classes

The evidence corpus may contain:

```text
FailureCases
+ SuccessCases
+ NegativeControls
```

A success case is not presumed positive evidence. It must pass the same gates and may simply show that ordinary institutional/protocol structure already solves the problem.

## 10. Post-QC3A source priorities

This is a new reprioritization, not the original QC-2 ordering:

```text
FIRST:  F8 — local qualification changes after shared determination
SECOND: F5 — delegation followed by orphaned revalidation
LOWER:  F7 — shared abstraction erases disagreement
```

F7 is downgraded because QX, lossy abstraction, and semantic-mapping rivals are unusually strong.

The preferred F8 shape is:

```text
A's local qualification changes
+ A cannot unilaterally make shared d globally invalid
+ B cannot treat A's change as irrelevant
-> continued shared reliance needs an explicit responsibility account.
```

The preferred F5 shape is:

```text
authority/evidence is delegated into a shared determination
+ downstream parties rely
+ underlying authority/evidence later changes
+ no ordinary delegation/revocation/service-ownership rule fully preserves the revalidation burden.
```

## 11. Evidence IDs, not theory ladder

Future work uses evidence IDs such as:

```text
QC-SRC-F8-<case>
QC-SRC-F5-<case>
QC-NEG-<case>
QC-SUCCESS-<case>
```

Do not create QC-4/QC-5 merely because more cases are collected.

## 12. Formal gate

This protocol does not earn:

```text
ProvisionalSharedReliance
SharedDetermination structure
QC calculus
QC Lean
```

Those remain blocked until heterogeneous source-backed cases force a stable non-eliminable responsibility structure and a non-definitional theorem/countermodel obligation.
