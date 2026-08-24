# QC-SRC-F5-DNSSEC-DELEGATION — DNSSEC Delegation / KSK Rollover Stress Audit

Status: **SOURCE-BACKED STANDARDS NEGATIVE / SUCCESS CONTROL**.

Formalization: **NO**.

Parent protocol: `QC_EVIDENCE_PROTOCOL.md`.

Evidence ID: `QC-SRC-F5-DNSSEC-DELEGATION`.

This audit targets F5 after the post-QC3A reprioritization:

```text
delegation followed by orphaned revalidation.
```

DNSSEC delegation maintenance is an unusually severe test because it contains all of the tempting ingredients:

```text
child-side key/qualification change
+ parent-side shared delegation state
+ multiple independent DNS providers in some deployments
+ downstream validating resolvers
+ cache/currentness timing
+ a real risk that one local change breaks continued shared validation.
```

The question is whether those facts leave a QC-specific orphaned responsibility after ordinary delegation, parent authority, rollover state machines, consistency checking, and cache/currentness rules are applied.

## 1. Primary sources

### S1 — RFC 6781, DNSSEC Operational Practices, Version 2

https://www.rfc-editor.org/rfc/rfc6781.html

Material facts used here:

- KSK rollover requires interaction with the parent and waiting for parent-side DS changes and cache expiry.
- During a rollover, the child introduces a new DNSKEY, provides the corresponding DS information to the parent, waits for publication, and observes TTL/cache constraints before removing the old key.
- One described rollover scheme explicitly places responsibility for maintaining a valid chain of trust on the child while requiring parent interaction.
- Incorrect sequencing can cause validating resolvers to treat the zone as Bogus.

### S2 — RFC 8078, Managing DS Records from the Parent via CDS/CDNSKEY

https://www.rfc-editor.org/rfc/rfc8078.html

Material facts used here:

- CDS/CDNSKEY can request three parent-side operations: initial DNSSEC enablement, KSK rollover / DS update, and removal of DS records.
- The mechanism allows child-originated signaling to affect the parent-side secure delegation state.
- The parent remains the entity that manages the DS RRset in the parent zone.

### S3 — RFC 9975, Clarifications on CDS/CDNSKEY and CSYNC Consistency

https://www.rfc-editor.org/rfc/rfc9975.html

Material facts used here:

- In multi-provider / multi-signer deployments, different authoritative nameservers can expose inconsistent CDS/CDNSKEY state.
- A naive parent that reads one provider only can allow that provider, accidentally or maliciously, to remove another provider's DS records and break the delegation.
- The RFC therefore requires the parental agent to query all relevant authoritative nameservers and establish plausible consistency before acting.
- If a nameserver is temporarily unreachable, the parental agent should retry rather than immediately infer a stable update state.
- The parent has a concrete consistency-checking obligation before updating the shared delegation.

These sources are useful precisely because they already make the revalidation/consistency responsibility explicit instead of leaving it to an invented QC relation.

## 2. MaterialFactsFreeze

The following facts are frozen before ordinary decomposition.

### Who determined what?

```text
child / signing operator:
  determines and publishes the child-zone DNSKEY state
  and may publish CDS/CDNSKEY signaling a prospective parent DS state;

parent / parental agent:
  determines whether child signaling satisfies the acceptance/consistency rules
  and controls the DS RRset in the parent zone;

validating resolver:
  evaluates the DNSSEC chain using parent DS + child DNSKEY/signatures + cached data.
```

In a multi-provider setup, several independent providers may contribute child-side authoritative responses.

### Who actually relied?

```text
validating resolvers rely on the published parent DS RRset
+ child DNSKEY / signature material
+ cache/currentness semantics
as the chain of trust for validation.
```

Operators and applications downstream rely on resolver validation outcomes.

Unlike the RPKI negative control, this family can support a stronger claim that the parent DS RRset is a **common published bounded basis** used by many resolvers.

### What evidence does each actor own?

```text
child signer/provider:
  its keys, signatures, CDS/CDNSKEY publication state;

parental agent:
  the delegation NS set, responses from authoritative servers,
  validation/consistency evidence, and authority to alter parent DS;

resolver:
  cached parent/child DNSSEC material and validation state.
```

### What changed?

During KSK rollover or provider change:

```text
child key state changes;
CDS/CDNSKEY signaling changes;
parent DS may need to change;
old state may remain in caches;
multiple providers may temporarily expose non-identical signaling.
```

### Who could revise locally?

```text
individual provider:
  its own authoritative child-side data;

child/zone operator:
  key/signing state and, depending on deployment, intended CDS/CDNSKEY state;

parental agent:
  parent-side DS RRset after acceptance/consistency checks;

resolver:
  local cache through normal expiry/retrieval, not authoritative source state.
```

### Who could revise the shared state?

For the bounded determination embodied in the parent DS RRset:

```text
the parent / parental agent has the effective update authority.
```

Child/provider signaling can request or justify an update; it does not itself rewrite the parent zone.

### What downstream action depended on continued validity?

DNSSEC validation depends on a coherent chain from parent DS to child DNSKEY/signatures. Incorrect rollover or an inconsistent parent update can make the child zone appear Bogus or otherwise break validation/availability.

### Counterfactual consequence

If one provider publishes an incomplete CDS/CDNSKEY set and a naive parent immediately updates DS from that one view, another provider's trust material can be removed and validation can break.

If instead the parental agent checks all relevant authoritative servers and refuses to act on inconsistent signaling, the unsafe update is blocked.

This is a source-specified counterfactual responsibility rule, not a post-hoc QC interpretation.

## 3. NativeDecomposition

The native structure is:

```text
child signing authority
+ child-to-parent update signaling
+ parent delegation authority
+ multi-provider consistency
+ rollover state machine
+ DNS cache / TTL currentness
+ resolver validation.
```

This already names the relevant responsibility positions without a generic shared-reliance relation.

## 4. RivalFit

Strong ordinary rival:

```text
delegation contract / protocol
+ parent-side final update authority
+ explicit rollover sequencing
+ multi-provider consistency checks
+ cache/currentness timing
+ resolver validation.
```

### Descriptive fit

**PASS.**

The RFCs explicitly distinguish child, parent, parental agent, providers, parent DS state, child keys, and validating resolvers.

### Causal fit

**PASS.**

Incorrect sequencing, stale caches, inconsistent provider signaling, or naive parent update explain the documented breakage scenarios.

### Normative fit

**PASS.**

The standards assign concrete obligations:

```text
child/provider publishes intended key/signaling state;
parental agent validates and checks cross-nameserver consistency;
parental agent controls parent DS updates;
operators respect rollover/cache timing;
resolvers validate the resulting chain.
```

There is no source-backed orphaned revalidation burden once these roles are represented.

### Counterfactual fit

**PASS.**

RFC 9975's multi-provider scenarios directly show what happens if the parent omits the consistency check and how the mandated check prevents a unilateral provider view from silently deleting another provider's trust material.

RFC 6781 similarly specifies sequencing/cache counterfactuals for key rollover.

Result:

```text
ordinary rival fit: SUFFICIENT
```

## 5. SharedDeterminationExistenceGate

This case is stronger than RPKI at this gate.

A plausible bounded common basis is:

```text
d = the parent-published DS RRset for the child delegation.
```

Many validating resolvers use that same published parent state as part of the DNSSEC trust chain.

Therefore:

```text
SharedDeterminationExistenceGate:
PLAUSIBLY PASSES FOR THE BOUNDED PARENT DS STATE.
```

This does **not** yet imply QC.

The point of the gate is to stop false positives, not to guarantee a residual when it passes.

## 6. Final-arbiter test

For the bounded shared state `d = parent DS RRset`:

```text
the parent / parental agent can settle the published DS state
for that delegation position.
```

Its authority is constrained by protocol and child signaling, but the parent-side entity is precisely the actor that updates the shared delegation record.

Thus:

```text
no final arbiter: FALSE for this bounded determination.
```

The fact that multiple providers independently control child-side nameservers does not eliminate the parent-side decision authority over DS publication.

This is a decisive ordinary explanation.

## 7. F5 orphaned-revalidation test

Tempting QC reading:

```text
provider/child qualification changes
+ downstream shared reliance persists
+ multiple actors participate
-> who owns revalidation?
```

Source-backed answer:

```text
RFC 6781:
  rollover sequencing and parent interaction are explicit;

RFC 8078:
  child signals intended DS maintenance;

RFC 9975:
  parental agent must establish plausible consistency across child nameservers
  before applying the shared parent-side update.
```

The revalidation/consistency obligation is therefore **not orphaned** in the standards model.

A bad implementation or naive parent may violate that responsibility, but violation of an assigned responsibility is not evidence that the responsibility relation is missing from ordinary theory.

## 8. Residual

The strongest ordinary decomposition preserves the material facts and assigns the critical revalidation responsibility.

Therefore:

```text
Delta_D = empty
```

at the current evidence level.

## 9. SharedRelianceConsequence

This family has a genuine common-basis consequence:

```text
parent DS state changes
-> validating resolvers may change validation result
-> downstream DNS resolution/availability/security may change.
```

But continued reliance is governed by an explicit parent/child delegation and consistency protocol.

The existence of a shared consequence is therefore insufficient for QC when ordinary authority and revalidation ownership are already explicit.

## 10. Exact verdict

```text
QC-SRC-F5-DNSSEC-DELEGATION:
SOURCE-BACKED STANDARDS NEGATIVE / SUCCESS CONTROL

SharedDeterminationExistenceGate: PLAUSIBLY PASSES for bounded parent DS state
Final-arbiter test: FAILS QC — parent-side authority exists
F5 orphaned revalidation: NOT ESTABLISHED
ordinary rival: SUFFICIENT
QC residual: NONE
```

## 11. Freedom deleted

This family permanently removes:

```text
real shared bounded state
+ multiple independent providers
+ local qualification changes
+ downstream common reliance
-/->
QC residual;

multi-party revalidation work
-/->
orphaned revalidation;

provider heterogeneity
-/->
absence of final authority over the bounded shared determination;

violation of an assigned consistency obligation
-/->
missing responsibility relation.
```

It also sharpens the difference between the two recent negative controls:

```text
RPKI:
  SharedDeterminationExistenceGate not established;

DNSSEC parent DS:
  a bounded shared basis can be identified,
  but ordinary parent authority + explicit consistency/revalidation duties absorb the case.
```

## 12. Promotion status

No positive QC object is earned.

```text
Generic QC object: NOT EARNED
ProvisionalSharedReliance: NOT EARNED
QC Lean: NO
```
