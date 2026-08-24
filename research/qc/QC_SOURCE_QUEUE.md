# QC Source Queue

Status: **EVIDENCE-ONLY / PRE-FORMAL**.

This queue records current source-acquisition priorities after QC-3A and the hardened evidence protocol. It does not replace the historical ordering recorded in `QC_FAILURE_CORPUS.md`.

## 1. Historical-order firewall

`QC_FAILURE_CORPUS.md` records the original QC-2 corpus and its then-current priority, including F7 as the highest-priority prospective falsifier/candidate.

That history remains unchanged.

The present queue is a **post-QC3A reprioritization** produced after stronger QX/QC separation and evidence-method hardening.

Current operational ordering:

```text
F8 local qualification changes after shared determination: first
F5 delegation followed by orphaned revalidation: second
F7 shared abstraction erases disagreement: lower priority
```

F7 is downgraded because ordinary lossy-abstraction, semantic-mapping, and QX representation-inadequacy explanations are especially strong.

## 2. Completed queue items

### QC-NEG-RPKI

File: `QC_NEG_RPKI.md`

Role:

```text
F8 stress
+ source-rich negative control
+ SharedDeterminationExistenceGate calibration
```

Result:

```text
shared signed source material: YES
multiple independent relying parties: YES
currentness change with downstream effect: YES
common QC shared determination d: NOT ESTABLISHED
ordinary rival fit: SUFFICIENT
QC residual: NONE
```

Primary lesson:

```text
distributed trust/security data
+ no global network operator
-/->
shared determination.
```

### QC-SRC-F5-DNSSEC-DELEGATION

File: `QC_SRC_F5_DNSSEC_DELEGATION.md`

Role:

```text
F5 stress
+ source-backed standards negative/success control
+ final-arbiter / revalidation-owner calibration
```

Result:

```text
bounded common basis d = parent DS RRset: PLAUSIBLE
multiple independent providers: possible / source-backed by standards model
local key/qualification changes: YES
parent-side final update authority: YES
explicit consistency/revalidation owner: YES
ordinary rival fit: SUFFICIENT
QC residual: NONE
```

Primary lesson:

```text
real common bounded state
+ multi-party qualification changes
-/->
QC residual
```

when ordinary delegation, bounded final authority, and explicit revalidation obligations already preserve the material facts.

## 3. Current source-acquisition rule

No next case is owed merely because the queue exists.

A new item should be admitted only when source viability is high enough to reconstruct:

```text
MaterialFactsFreeze
+ reliance/currentness timeline
+ local vs shared revision authority
+ downstream counterfactual consequence.
```

Do not search for a case merely to keep QC active.

## 4. Preferred future F8 shape

A source-rich F8 candidate is valuable only if it can establish all of:

```text
there is one bounded shared determination d;
multiple parties actually rely on d;
one participant's local qualification changes;
that participant cannot unilaterally settle continued validity of shared d;
other participants cannot treat the change as responsibility-irrelevant;
ordinary versioning/revocation/notification/local-policy models do not preserve the full burden.
```

RPKI failed before this point because the common `d` was not established.

## 5. Preferred future F5 shape

A source-rich F5 candidate is valuable only if it can establish:

```text
delegated authority/evidence contributes to a common bounded determination d;
downstream parties actually rely on d;
the delegated contribution later changes or loses currentness;
no bounded final authority can settle continued validity;
no ordinary delegation/revocation/service-ownership rule owns the revalidation burden.
```

DNSSEC delegation failed as a positive case because parent-side update authority and consistency/revalidation responsibilities were explicit.

## 6. Corpus classes

The queue may contain:

```text
FailureCases
SuccessCases
NegativeControls
```

Success is not positive QC evidence by default. A successful institution may be a severe negative control if ordinary authority/currentness structure fully explains why it works.

## 7. Current evidence frontier

Completed source-backed controls now cover distinct failure modes:

```text
Stellar halt:
  heterogeneous distributed failure absorbed by quorum/consensus/liveness;

Mars Climate Orbiter:
  multi-team semantic failure absorbed by interface/translation/V&V;

Web PKI / Symantec:
  shared credential ecosystem absorbed by local root-program authority + credential lifecycle;

RPKI:
  distributed trust/currentness does not establish one shared determination;

DNSSEC delegation:
  even a plausible common bounded basis does not yield QC when bounded authority and revalidation ownership are explicit.
```

No source-backed positive QC residual has survived.

## 8. Promotion firewall

This queue earns none of:

```text
ProvisionalSharedReliance
SharedDetermination generic structure
QC calculus
QC Lean
```

Those require a non-eliminable source-backed responsibility fact, not continued case accumulation.
