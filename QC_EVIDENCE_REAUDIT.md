# QC Evidence Re-Audit — Is Any Generic Object Forced?

Status: **NO GENERIC QC OBJECT EARNED / EVIDENCE-LIMITED**.

Formalization: **NO**.

Inputs:

```text
QC_FAILURE_CORPUS.md
QC_EVIDENCE_PROTOCOL.md
QC_NEG_RPKI.md
QC_SRC_F5_DNSSEC_DELEGATION.md
```

This is not a new theory checkpoint. It asks only whether the source-backed evidence accumulated so far forces a stable non-eliminable responsibility object.

## 1. Current evidence classes

### Existing empirical negative controls

```text
Stellar 2019 halt
Mars Climate Orbiter
Web PKI / Symantec distrust
RPKI currentness incidents / architecture stress
```

### Standards / successful-institution negative control

```text
DNSSEC delegation / KSK rollover / multi-provider consistency
```

### Source-backed positive QC residuals

```text
NONE
```

## 2. What the hardened protocol changed

Earlier negative controls were evaluated mainly through native decomposition and strongest ordinary theories.

The hardened protocol now requires two additional protections against false elimination or false promotion:

```text
MaterialFactsFreeze before ordinary decomposition;
SharedDeterminationExistenceGate before naming a QC residual.
```

It also strengthens ordinary-theory sufficiency to require:

```text
descriptive + causal + normative + counterfactual fit.
```

The RPKI and DNSSEC controls were audited under this stronger method.

## 3. RPKI result — shared source/currentness is not enough

RPKI provides:

```text
shared signed authorization objects;
multiple independent relying parties;
repository/currentness changes;
local downstream routing consequences;
no single global routing operator.
```

Yet the material facts support independent RP-local validation/cache states and local operator policy rather than one separately governed common determination `d`.

Thus:

```text
SharedDeterminationExistenceGate: NOT ESTABLISHED
```

and the ordinary authorization/currentness/local-policy decomposition preserves the relevant facts.

This kills the shortcut:

```text
shared source object + distributed reliance
-> shared determination.
```

## 4. DNSSEC result — even a shared bounded basis is not enough

DNSSEC delegation provides a stronger shape:

```text
parent-published DS RRset as a plausible common bounded basis;
multiple validating resolvers;
possibly multiple independent child-side providers;
local key/qualification changes;
shared downstream validation consequences.
```

Here the shared-determination gate can plausibly pass for the bounded parent DS state.

But ordinary structure then supplies:

```text
parent-side final update authority;
explicit child-to-parent signaling;
rollover sequencing and cache timing;
parental cross-provider consistency checking;
identified revalidation/consistency responsibility.
```

Therefore:

```text
shared determination
-/-> no final arbiter
-/-> orphaned revalidation
-/-> QC residual.
```

This is a stronger negative result than simply failing the shared-determination gate.

## 5. Two-sided false-positive firewall

The two recent controls now bracket two major QC false positives.

### False positive A — distributed data mistaken for shared determination

```text
shared data/object
+ multiple local users
+ local views currently agree
-> wrongly infer common d.
```

RPKI blocks this.

### False positive B — common d mistaken for novel shared-responsibility relation

```text
common d
+ multiple parties
+ currentness changes
-> wrongly infer no adequate ordinary responsibility owner.
```

DNSSEC blocks this when ordinary authority and revalidation responsibilities are explicit.

A future positive QC residual must survive **both** firewalls.

## 6. Minimum source-backed shape now required for positive QC evidence

A future case must establish at least:

```text
1. one bounded determination d is actually used as a common basis by multiple parties;
2. continued validity of d matters to downstream reliance;
3. a local evidence/qualification/authority contribution changes;
4. no single actor can unilaterally settle continued validity of shared d for the bounded reliance position;
5. the changing local contribution cannot be treated as irrelevant to the other parties' continued reliance;
6. ordinary consensus/authority/delegation/semantic-mapping/versioning/revocation/notification/
   service-ownership/revalidation models fail to preserve some frozen material fact;
7. the failure is visible in descriptive, causal, normative, or counterfactual terms, not merely in preferred vocabulary.
```

No current source-backed case satisfies this conjunction.

## 7. Why no generic object is forced

A generic object such as:

```text
ProvisionalSharedReliance(participants, d, ...)
```

would currently have to include fields inferred from source targets rather than fields forced by non-eliminable positive evidence.

The evidence does not yet determine:

```text
what exact relation between local qualification and shared continued validity is irreducible;
what authority topology is genuinely outside ordinary delegation/consensus models;
what revalidation obligation remains ownerless after native decomposition;
what theorem/countermodel obligation would be non-definitional.
```

Therefore field selection would remain theory freedom rather than evidence-constrained structure.

## 8. Exact verdict

```text
QC source-backed positive residuals: 0
Generic QC object: NOT EARNED
ProvisionalSharedReliance: NOT EARNED
QC theorem surface: NOT EARNED
QC Lean: NO
```

QC state becomes:

```text
EVIDENCE-LIMITED / PRE-FORMAL
```

This does not close the mother question. It means current evidence no longer licenses theory construction.

## 9. Legal next activity

QC may continue source acquisition only when source viability is independently high.

Use evidence IDs, not a new theory ladder.

Preferred source shapes remain F8 then F5, but there is no obligation to collect another case merely to maintain momentum.

A new case may promote QC only if it survives the complete hardened pipeline and leaves a precise nonempty residual.

## 10. Degrees of freedom deleted

The current evidence program permanently removes:

```text
ordinary model can retell case
-> ordinary model is automatically sufficient;

same/shared object
-> shared determination;

distributed agreement/currentness
-> shared reliance;

no central/global operator
-> no final arbiter over the bounded determination;

shared bounded state
-> QC residual;

multi-party revalidation work
-> orphaned revalidation;

failure to follow an assigned responsibility
-> missing responsibility relation;

continued source collection
-> automatic theory promotion.
```

## 11. Stop rule

Do not define a generic QC structure and do not open Lean until a source-backed case forces a responsibility fact that the strongest ordinary decomposition cannot preserve without loss.

If future acquisition continues to yield empty residuals, remain:

```text
QC: EVIDENCE-LIMITED
Lean: NO
```
