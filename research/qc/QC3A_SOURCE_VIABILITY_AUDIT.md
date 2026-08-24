# QC-3A — Source Viability and Native-Decomposition Audit

Status: **PRE-FORMAL SOURCE ACQUISITION / CALIBRATION**.

Formalization: **NO**.

Parent corpus: `QC_FAILURE_CORPUS.md`.

This checkpoint does not search for a positive QC example. It tests whether a source-rich heterogeneous trust event leaves any QC residual after ordinary native decomposition.

The calibration event is the 2017 Chrome / Symantec legacy-PKI distrust process because it has unusually strong public records for trust policy, validation failure, staged distrust, revalidation/replacement, and compatibility concerns.

The same event has a narrow QX Candidate-A residual in `QX4A_WEBPKI_AUDIT.md`. That fact provides **zero automatic QC support**.

## 1. Primary sources

### S1 — Chromium public decision record

Ryan Sleevi / Chromium blink-dev, *Intent to Deprecate and Remove: Trust in existing Symantec-issued Certificates*, March 2017:

https://groups.google.com/a/chromium.org/g/blink-dev/c/eUAKwjihhBs/m/SsLH5haOCQAJ

Material facts include:

```text
loss of confidence in Symantec validation practices;
large and expanding affected scope;
inability to identify the problematic legacy certificates precisely;
explicit security risk;
explicit compatibility / interoperability risk;
proposal for staged distrust and full revalidation/replacement.
```

### S2 — finalized Chrome transition plan

Google Online Security Blog, *Chrome’s Plan to Distrust Symantec Certificates*, September 2017:

https://security.googleblog.com/2017/09/chromes-plan-to-distrust-symantec.html

Material facts include:

```text
independently operated replacement infrastructure;
certificate replacement and transition deadlines;
Chrome-version-specific distrust schedule;
continued local browser trust decisions during migration.
```

### S3 — execution summary

Chromium, *Symantec Legacy PKI*:

https://www.chromium.org/Home/chromium-security/symantec-legacy-pki/

This records the staged Chrome 65 / 66 / 70 implementation of distrust.

## 2. Source-viability result

For this event, the source chain is sufficient to reconstruct:

```text
local trust representation;
local trust determination;
shared credential objects;
validation / audit responsibility;
local decision authority;
who relies;
distrust / revalidation triggers;
replacement responsibility;
compatibility consequences;
timeline of policy change.
```

Therefore the case is **source viable** for QC calibration.

Source viability does not imply a QC residual.

## 3. Native decomposition

### Local representations

At the Chrome side, the relevant local representation contains client-visible certificate chains, certificate attributes, root/intermediate trust policy, issuance timing, and policy version / browser release information.

At the CA/site-operator side, the relevant representations include issuance/validation records, certificate lifecycle state, and deployed certificate chains.

No claim is made that these representations are semantically identical.

### Native determination(s)

The key local determination is:

```text
Chrome accepts / distrusts this certificate chain under this browser-policy state.
```

Other browsers/root programs may make their own local trust determinations.

There is no source-backed fact that the ecosystem must first produce one shared cross-browser determination before local clients may act.

### Shared object/value

The certificate and its certification path are common objects that multiple parties may inspect or rely upon.

This does **not** imply that `trusted` is one globally shared determination.

### Semantic translation path

The ecosystem already has ordinary semantic machinery:

```text
X.509 certificate semantics;
CA/Browser Forum Baseline Requirements;
client certificate-path validation;
root-program policy;
certificate issuance / renewal / replacement rules.
```

The material incident does not require a new semantic-translation object beyond these mechanisms.

### Evidence owners

```text
CA / delegated validation parties: issuance and validation evidence;
auditors / public incident reporting: compliance evidence;
site operators: deployed certificate and service configuration;
root programs / browsers: local trust-policy evidence and enforcement.
```

Evidence ownership is distributed, but distributed evidence ownership alone is already an ordinary governance/provenance fact.

### Decision authority

For Chrome users, Chrome retains final authority over its own client trust behavior.

Other browsers/root programs retain authority over their own trust stores / policies.

Therefore:

```text
no single global arbiter
```

is true at ecosystem scale, but it does not create a bounded shared determination that needs QC. Local final authorities already exist for the relied-upon client actions.

### Who may rely

```text
browser users rely on the browser's local trust decision;
site operators rely on client/root-program compatibility for service reachability;
root programs rely on CA compliance evidence to maintain trust.
```

These reliance relations are ordinary and actor-indexed.

### Purpose / scope of reliance

Chrome's scope is user security and interoperable HTTPS operation under Chrome's policy.

The scope is explicitly local to the browser/root-program decision even when ecosystem coordination influences policy.

### Currentness / qualification owners

```text
CAs / auditors maintain issuance and compliance evidence;
root programs maintain local trust qualification;
site operators maintain current deployed certificates;
clients evaluate certificate validity/trust under current policy.
```

### Revocation / distrust trigger

The event provides explicit ordinary triggers:

```text
loss of confidence in CA validation practice;
known compliance failures;
incomplete ability to bound affected issuance;
root-program policy change;
certificate age / issuance-date thresholds during migration.
```

### Revalidation owner

The migration path places concrete work on ordinary actors:

```text
CAs / replacement infrastructure perform compliant validation and issuance;
site operators obtain and deploy replacement certificates;
Chrome applies updated trust policy to the presented chain.
```

No orphaned shared-reliance revalidation obligation remains after this decomposition.

### What exactly failed

The core failure is assurance in the validation practices and legacy issuance of a CA ecosystem participant.

The downstream problem is how local client trust policies respond while managing compatibility.

### Ordinary model that explains the event

The source-backed event is preserved by:

```text
CA qualification / compliance
+
local root-program authority
+
credential lifecycle
+
staged distrust / revocation-like policy
+
revalidation / replacement
+
relying-party compatibility
+
public governance coordination.
```

## 4. Residual computation

Conceptually:

```text
Delta_D
=
native material facts
-
ordinary decomposition
```

For this calibration event:

```text
Delta_D = empty at current evidence level.
```

Nothing material requires a new relation in which heterogeneous actors jointly hold one provisional determination without a final local authority.

The fact that different root programs can make different decisions is already representable as actor-indexed local authority and trust policy.

The fact that site operators are affected by several clients is an interoperability / compatibility fact, not by itself a shared-determination responsibility relation.

## 5. QC kill checks

### Ordinary consensus / quorum

Not the governing model; no QC residual appears after removing it.

### Authority

```text
SUFFICIENTLY EXPLANATORY
```

Each client/root program has local final authority over its trust behavior.

### Semantic mapping / interoperability

```text
SUFFICIENTLY EXPLANATORY
```

Certificate semantics, validation rules, and client compatibility capture the shared-object layer.

### Revocation / revalidation

```text
SUFFICIENTLY EXPLANATORY
```

The incident is explicitly handled by staged distrust, replacement, and revalidation.

### Ownership / discharge

```text
SUFFICIENTLY EXPLANATORY AT CURRENT EVIDENCE LEVEL
```

Concrete actors own the needed actions. The public record does not show an irreducible shared obligation that no local role or contract can express.

## 6. QC classification

```text
Web PKI / Symantec distrust:
SOURCE-BACKED
REJECTED AS QC EVIDENCE
```

Reason:

> The event is heterogeneous, multi-party, revocable, and source-rich, but ordinary local trust authority + CA qualification + credential revalidation + compatibility/interoperability preserve the material facts. No provisional-shared-determination object is needed.

This is a high-value QC negative control.

## 7. Cross-track result

The same event has different track outcomes:

```text
QX Candidate A:
  narrow mechanism-specific residual survives

QC:
  no residual after native decomposition
```

Therefore this source-backed case strengthens the governance firewall:

```text
QX -/-> QC
```

at the level of empirical research discipline.

It is not a formal theorem.

## 8. Source-target viability after this checkpoint

This audit does not upgrade F2–F8 merely by analogy.

| Corpus target | Status after QC-3A | Reason |
|---|---|---|
| F2 no responsibility owner | SOURCE TARGET | no new source chain acquired |
| F3 incompatible local semantics | SOURCE TARGET | Web-PKI decomposition does not establish this shape |
| F4 distributed evidence / asymmetric authority | SOURCE TARGET | event has local authority, but no irreducible residual |
| F5 orphaned revalidation | SOURCE TARGET | Web-PKI has concrete revalidation owners, so it is a negative calibration |
| F6 joint approval != joint discharge | SOURCE TARGET | not evidenced here |
| F7 shared abstraction erases disagreement | SOURCE TARGET / HIGH PRIORITY | not evidenced here; no bridge from QX is permitted |
| F8 local qualification changes after sharing | SOURCE TARGET | local trust changes are handled by ordinary policy/version/revalidation mechanisms in this case |

Absence of a source upgrade is not evidence that these target shapes never occur.

## 9. Degrees of freedom deleted

This checkpoint removes:

```text
same event survives QX -> event supports QC;
no global arbiter -> QC;
different local trust policies -> provisional shared determination;
shared credential object -> shared trust determination;
revocable multi-party trust -> irreducible shared revalidation responsibility.
```

## 10. QC-3A verdict

```text
source-viability method: WORKS ON A SOURCE-RICH CALIBRATION CASE
Web-PKI QC calibration: NEGATIVE CONTROL
source-backed positive QC residuals: 0
generic QC object: NOT EARNED
ProvisionalSharedReliance: DO NOT DEFINE
QC Lean: NO
```

The next QC action, if continued, remains targeted source acquisition for F2–F8 under the existing native-decomposition template, with F7 still the highest-priority falsifier. Do not manufacture a positive case from the Web-PKI event.
