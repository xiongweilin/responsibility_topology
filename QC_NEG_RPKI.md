# QC-NEG-RPKI — RPKI Currentness as a Shared-Determination Negative Control

Status: **SOURCE-BACKED NEGATIVE CONTROL / F8 STRESS FAMILY**.

Formalization: **NO**.

Parent protocol: `QC_EVIDENCE_PROTOCOL.md`.

Evidence ID: `QC-NEG-RPKI`.

This audit tests a source-rich family that superficially resembles QC:

```text
multiple relying parties
+ shared signed routing-security objects
+ no single global network operator
+ currentness changes that affect downstream routing validation.
```

The question is not whether RPKI is distributed. It is whether the source-backed facts establish a **shared determination** whose continued validity is jointly relied upon in the QC sense, and whether ordinary authorization/currentness/local-policy models fail to preserve the resulting responsibility facts.

## 1. Primary sources

### S1 — RFC 6480, RPKI architecture

https://www.rfc-editor.org/rfc/rfc6480.html

Material facts used here:

- A ROA is an explicit, cryptographically verifiable authorization by a resource holder for an AS to originate routes to specified prefixes.
- Relying parties may use validated ROAs as inputs to local route-filter construction.
- A relying party constructs a **local cache** and validates objects to its locally configured trust anchors.
- ROA revocation occurs through revocation of the corresponding end-entity certificate / CRL publication.
- The RFC explicitly warns that revocation can affect routing behavior and requires relying parties to fetch new ROAs before acting on a revocation.

### S2 — RFC 8897, requirements for RPKI relying parties

https://www.rfc-editor.org/rfc/rfc8897.html

Material facts used here:

- RP software validates RPKI objects and constructs validated local data.
- Manifest state can be valid/current, valid/stale, or invalid.
- When stale/invalid material cannot be refreshed, RP behavior is explicitly subject to **local RP policy**.
- RPs may encounter stale manifests/CRLs or expired certificates/ROAs and are expected to contact the relevant maintainer.
- Validated data is periodically supplied from a local cache to BGP speakers.
- Network operators may maintain local exceptions/overrides to RPKI-derived data.

### S3 — JPNIC 2025 manifest-expiry incident

https://www.nic.ad.jp/ja/topics/2025/20250730-02.html

Material facts used here:

- JPNIC reported that an internal manifest-data expiry was not refreshed because of a temporary JPNIC/APNIC coordination failure.
- JPNIC-issued ROAs consequently lost validity.
- Origin-validation results for affected prefixes were expected to become `Not found`.
- JPNIC states that ordinary RP software could not foresee this internal expiry condition and planned additional monitoring.

Supporting source:

https://www.nic.ad.jp/ja/topics/2025/20250327-01.html

A separate 2025 incident caused stale RRDP data to cross `nextUpdate`, again leading RPs using that path to lose current ROA validity and likely obtain `Not found`.

## 2. MaterialFactsFreeze

The following facts are frozen before ordinary decomposition.

### Who determined what?

```text
resource holder / RPKI CA:
  signs an authorization that AS n may originate prefix p;

RP instance:
  validates repository objects against its configured trust anchors
  and constructs a local validated cache / VRP-like view;

BGP speaker / network operator:
  consumes local validated data and applies local routing policy.
```

These are different determinations at different responsibility positions.

### Who actually relied?

The standards support the following reliance chain:

```text
RP relies on signed RPKI objects + certification/revocation/currentness data
-> produces locally validated output
-> local BGP speakers may use that output in route-origin validation / filtering
-> local network operator determines routing consequences under its policy.
```

The sources do not establish that multiple independent operators rely on one jointly maintained global determination `d` as a common bounded basis.

### What evidence does each actor own?

```text
resource holder / CA:
  resource authorization + signing material + publication state;

repository / publication system:
  current certificate/CRL/manifest/ROA objects;

RP:
  fetched repository material + configured trust anchors + validation state;

network operator:
  local validated cache + local policy / overrides + BGP observations.
```

### What changed?

In the JPNIC incidents, manifest/currentness data crossed its validity boundary or failed to refresh. This changed whether associated ROAs were accepted as currently valid by RPs.

### Who could revise locally?

```text
CA / resource holder:
  issue/revoke/replace signed authorization objects within its authority;

repository operator:
  restore publication/currentness mechanisms;

RP operator:
  refresh validation state, configure trust anchors, and apply local policy;

network operator:
  revise local route-validation / routing policy, including local exceptions where supported.
```

### Who could revise the alleged shared state?

No source-backed single shared QC state has yet been established.

A CA can revise its signed authorization. It cannot unilaterally dictate every operator's local routing policy. An operator can revise local treatment of RPKI data. It cannot rewrite the resource holder's authorization for all other RPs.

This is actor-indexed authority, not evidence by itself of a jointly maintained determination.

### What downstream action depended on continued validity?

Current RPKI validity can alter the origin-validation state supplied to routers and therefore can influence route filtering / preference according to local policy.

JPNIC's incidents specifically report the expected transition to `Not found` for affected prefixes.

### Counterfactual consequence

If a previously valid ROA becomes unavailable/invalid after refresh:

```text
RP validation output changes according to RPKI validation semantics;
local BGP speakers receive the changed local validated state;
local routing consequence depends on operator policy.
```

If a resource holder republishes valid current material and the RP refreshes, the local validated state may become current again.

No source establishes a universal routing consequence common to all operators.

## 3. NativeDecomposition

The case is naturally represented as:

```text
resource authorization
+
certificate / CRL / manifest lifecycle
+
repository publication currentness
+
RP-local trust-anchor validation
+
RP-local validated cache
+
local route-origin-validation state
+
local routing policy / overrides
+
refresh / notification / retrieval timing.
```

This decomposition is entirely native to the RPKI/ROV architecture.

## 4. RivalFit

Strong ordinary rival:

```text
cryptographic authorization lifecycle
+ distributed publication
+ local relying-party validation
+ local policy composition
+ cache/currentness refresh.
```

### Descriptive fit

**PASS.**

The ordinary model distinguishes the resource holder, repository, RP, BGP speaker, and operator, and identifies the signed authorization, publication/currentness objects, local cache, and local policy.

### Causal fit

**PASS.**

Manifest/CRL/ROA expiry or publication failure explains why an RP ceases to validate the authorization as current. JPNIC's incidents directly report this causal path to likely `Not found` results.

### Normative fit

**PASS.**

The resource holder has authority to sign/revoke its authorization; the RP is responsible for validating against configured trust anchors/currentness data; the operator retains local control over how validated data affects routing.

No additional joint authority relation is needed to allocate those responsibilities.

### Counterfactual fit

**PASS.**

The ordinary lifecycle explains how revocation, stale publication, refresh, restored publication, local override, or local routing-policy changes affect each actor's downstream state.

The fact that different RPs may refresh at different times or use different local policies is preserved rather than erased.

Result:

```text
ordinary rival fit: SUFFICIENT AT CURRENT EVIDENCE LEVEL
```

## 5. SharedDeterminationExistenceGate

Candidate tempting interpretation:

```text
all operators share the determination:
"AS n is currently authorized to originate prefix p".
```

The source-backed architecture does not support that claim strongly enough.

What is source-backed is:

```text
one signed authorization object may be globally published;
multiple RPs may independently fetch it;
each RP constructs a local validated cache using local trust anchors/currentness checks;
each operator applies local policy to local validation output.
```

Therefore the evidence is compatible with:

```text
RP_A derives d_A;
RP_B derives d_B;
d_A and d_B may currently agree because they consume overlapping signed source material.
```

It does not force:

```text
RP_A and RP_B jointly rely on one shared determination d
whose continued validity is a separately maintained common responsibility object.
```

Gate verdict:

```text
SharedDeterminationExistenceGate: FAIL / NOT ESTABLISHED
```

## 6. Final-arbiter test

The family also illustrates why:

```text
no global network operator
-/->
no final arbiter over a QC shared determination.
```

Different bounded questions have different authorities:

```text
resource holder / CA:
  authority over its signed origin authorization;

RP:
  authority over its local validation state under configured trust anchors/policy;

network operator:
  authority over its local routing consequence.
```

There is no demonstrated global actor that can settle all routing behavior, but there is also no demonstrated single QC shared `d` requiring such an arbiter.

The absence of a global actor is therefore non-probative for QC.

## 7. Residual

Because the SharedDeterminationExistenceGate fails and the ordinary rival preserves all frozen material facts:

```text
Delta_D = empty
```

at the current evidence level.

No `ProvisionalSharedReliance` relation is needed.

## 8. SharedRelianceConsequence

There is a real distributed consequence of currentness change:

```text
ROA/currentness change
-> RP-local validation change after refresh
-> possible local routing-policy consequence.
```

But the consequence remains actor-indexed and lifecycle-explainable.

It does not establish a separately governed common bounded determination whose continued reliance responsibility is orphaned across operators.

## 9. Exact verdict

```text
QC-NEG-RPKI:
SOURCE-BACKED NEGATIVE CONTROL

F8 stress value: HIGH
SharedDeterminationExistenceGate: FAIL / NOT ESTABLISHED
ordinary rival: SUFFICIENT
QC residual: NONE
```

## 10. Freedom deleted

This case permanently removes the shortcut:

```text
distributed trust/security data
+ multiple independent relying parties
+ no single global network operator
+ currentness changes with downstream effect
-/->
QC shared determination.
```

It also sharpens:

```text
shared source object
!= shared determination;

agreement among independently validated local views
!= common bounded basis;

no global operator
!= no final arbiter over the relevant determination;

source authorization currentness
!= uniform downstream reliance policy.
```

## 11. Promotion status

This audit earns no positive QC object.

```text
source-backed QC positive residuals: unchanged
Generic QC object: NOT EARNED
ProvisionalSharedReliance: NOT EARNED
QC Lean: NO
```
