# QX-4A₁ — Candidate A Audit: Web PKI / Symantec Distrust

Status: **SOURCE-BACKED DOMAIN AUDIT**.

Formalization: **NO**.

Parent protocol: `QX_KERNEL_PREREGISTRATION.md`.

Frozen domain set: `QX4A_DOMAIN_FREEZE.md`.

Domain ID: `A-D1`.

Verdict vocabulary is frozen to:

```text
ELIMINATED
DOMAIN-SPECIFIC
SURVIVES WITH EXACT RESIDUAL
```

This audit uses the March 2017 Chromium public record as the certificate-timing boundary. Later remediation is used only to check the historical interpretation, not to supply the early certificate.

## 1. Native domain question

In March 2017 Chrome had evidence that a substantial subset of certificates in the Symantec PKI had been issued through improperly supervised delegated validation, while the affected certificates could not be technically identified or sufficiently independently separated from the broader legacy corpus.

The domain pressure is not merely:

```text
some certificates were bad.
```

It is:

```text
existing client-observable certificate/trust-chain information
was insufficient to selectively distinguish
problematic validation provenance
from compliant validation provenance
for the legacy corpus.
```

At the same time, the public decision record explicitly considered both user-security risk and compatibility/interoperability risk.

## 2. Primary sources

### S1 — pre-remediation Chromium public record

Ryan Sleevi / Chromium blink-dev, *Intent to Deprecate and Remove: Trust in existing Symantec-issued Certificates*, March 2017:

https://groups.google.com/a/chromium.org/g/blink-dev/c/eUAKwjihhBs/m/SsLH5haOCQAJ

Material source facts:

- the investigation scope expanded from an initially reported 127 certificates to at least 30,000 certificates;
- Chrome stated that the relevant problematic certificates could not be technically identified/distinguished from certificates where Symantec performed the validation role;
- Chrome also stated that there was no sufficiently independent way to assess that the compliance failures were limited to those certificates;
- the proposed response explicitly balanced security risk against compatibility/interoperability risk;
- a gradual distrust/revalidation path was proposed because immediate complete distrust carried substantial compatibility cost while continued broad trust carried unknown security risk.

### S2 — later execution record, corroboration only

Google Online Security Blog, *Chrome’s Plan to Distrust Symantec Certificates*, September 2017:

https://security.googleblog.com/2017/09/chromes-plan-to-distrust-symantec.html

This source confirms that the eventual response used staged distrust, replacement, independent managed infrastructure, and revalidation. It is **not** used as `E_pre` certificate provenance.

## 3. Certificate timing

### `E_pre`

Available by the March 23–24, 2017 public record:

```text
known validation-governance failures;
known expanding scope;
known inability to technically identify the affected legacy certificates;
known inability to independently prove the problem was confined to the identified subset;
explicit security objective;
explicit compatibility/interoperability objective;
known possibility of broad or staged distrust.
```

### `E_post-refinement`

Later evidence included:

```text
finalized migration schedule;
independently operated Managed Partner Infrastructure;
DigiCert transition;
precise Chrome 66/70 distrust cutovers;
replacement/revalidation implementation details.
```

These later facts may validate the historical interpretation that the old corpus lacked sufficient selective provenance, but they do not count toward the early certificate.

## 4. Candidate A observables

### A-OBS1 — situations / case classes

Use two issuance-provenance classes only:

```text
x = legacy Symantec-issued certificate whose validation provenance is within the improperly supervised delegated-validation problem class;
y = legacy Symantec-issued certificate whose validation was performed through a compliant validation path.
```

The audit does not assume Chrome knew which concrete certificate belonged to which class.

### A-OBS2 — represented images under `V`

For the relevant client-side trust decision, let `V` be the legacy certificate/trust-chain information and policy-visible attributes available to Chrome **without a reliable per-certificate compliance-provenance discriminator**.

The March public record supplies the critical negative fact:

```text
problematic certificates could not be technically identified/distinguished
from the broader relevant legacy corpus.
```

Therefore the exact Candidate A pressure is not a reconstructed hidden ground-state equality. It is the source-backed absence of a usable discriminator for the affected provenance class at the client decision boundary.

### A-OBS3 — factorization of the relevant decision path

The existing trust decision could not branch on the unknown provenance class because the source record states that the affected legacy certificates were not technically identifiable at that granularity and could not be independently isolated.

The later remedy changed the trust schedule and required replacement/revalidation rather than discovering a reliable historical per-certificate discriminator.

### A-OBS4 — task/accountability source

The relevant task is deliberately narrow:

> maintain a browser trust decision that protects users against inadequately validated certificates while avoiding unnecessary breakage of legitimate relying-party connections during remediation.

Its provenance is the same March 2017 public decision record, which explicitly distinguishes security risk from compatibility/interoperability risk before the later final plan.

This audit does **not** treat compatibility as an absolute legal duty or guarantee.

### A-OBS5 — exact response incompatibility

Relative to the narrow selective-remediation task:

```text
accept x  -> preserves compatibility but carries the identified security-assurance failure;
reject y  -> removes security exposure broadly but imposes unnecessary compatibility loss on a certificate not established to share the deficient provenance;
```

No certificate-local decision rule can selectively realize `reject x / retain y` if the relevant provenance classes are not distinguishable in `V`.

A broad distrust response remains available. It is a fallback that changes the cost distribution; it is not a selective classifier satisfying both aims on each object.

### A-OBS6 — why the witness does not already supply the correct refinement

The March record identifies a provenance/assurance problem and explicitly says the affected certificates cannot be technically isolated. It does not provide a correct finer mapping from each certificate to its historical validation-compliance class.

The later solution is operational remediation by distrust/replacement/revalidation, not an ex ante oracle over the legacy corpus.

### A-OBS7 — existing channels that might distinguish the cases

The source record explicitly attacks the strongest candidate channel:

```text
no technical identification sufficient to isolate the problematic certificates;
no sufficient independent assessment proving the issue confined to the named subset.
```

Certificate issuance dates and chain membership later supported staged policy, but they did not reconstruct the missing validation provenance for every legacy certificate.

### A-OBS8 — lower-level rival explanations

The following remain ordinary explanations of the underlying incident:

```text
CA governance failure;
delegated-validation oversight failure;
audit/compliance failure;
root-program trust-policy failure.
```

Candidate A does not compete with those explanations.

The residual concerns only the client-side selective-remediation question after those failures had occurred:

```text
can the current observable distinction space separate which legacy objects should receive different trust treatment on the basis of the failed validation provenance?
```

### A-OBS9 — exact safe conclusion

The strongest permitted conclusion is:

> **For the March 2017 selective-remediation task, the client-observable legacy certificate/trust representation lacked a reliable discriminator for the relevant validation-provenance classes; therefore it could not support certificate-specific trust treatment that simultaneously targeted the security defect and preserved unaffected compatibility.**

This is not a claim that Web PKI lacked all adequate responses, that Chrome was unable to act, or that a specific finer representation was known.

## 5. Kill-test audit

### A-K1 — refinement-generated witness

```text
PASS
```

The incompatibility source predates the later infrastructure migration and does not depend on a proposed finer representation. The public record already distinguishes security and compatibility risks while stating the affected provenance class cannot be isolated.

### A-K2 — complete-ground-state oracle

```text
PASS
```

The source record explicitly denies a per-certificate oracle sufficient to isolate the affected class.

### A-K3 — hidden existing channel

```text
PASS, FOR THE NARROW CLIENT-SIDE SELECTIVE-REMEDIATION CLAIM
```

The March record specifically states that the problematic certificates could not be technically identified/distinguished and could not be independently confined to the named subset.

This does not prove that no conceivable forensic data existed anywhere in the ecosystem. The claim is only about the then-available decision basis recorded for Chrome's remediation problem.

### A-K4 — compatible responses after all

```text
PASS ONLY UNDER THE FROZEN NARROW TASK; IMPORTANT BOUNDARY
```

A conservative broad distrust action existed. Therefore Candidate A would be killed if `T` were only:

```text
prevent reliance on potentially unsafe Symantec certificates.
```

The source-backed task considered here is narrower and conjunctive in purpose:

```text
reduce the security exposure
while avoiding unnecessary compatibility/interoperability breakage during remediation.
```

Broad distrust does not selectively satisfy both aims; it trades compatibility for security. The actual staged plan is evidence that the system could choose a compromise policy without possessing the missing per-certificate discriminator.

Therefore the survivor claim is **not** “no acceptable action existed.” It is only “selective object-level remediation was not expressible from the available discriminator set.”

### A-K5 — task-specification instability

```text
PASS WITH SCOPE RESTRICTION
```

Security and compatibility/interoperability were both explicitly articulated in the March public record before the final migration architecture. The audit does not add a post-hoc requirement that every compliant certificate must remain trusted.

The exact task is the publicly stated balancing/selective-remediation problem, not a universal Web PKI objective.

### A-K6 — ordinary partial observability

```text
PASS AS A PRIOR-ART BOUNDARY, NOT AS NOVELTY
```

The case can be described as missing/latent provenance information. That observation alone is not QX novelty. What survives is the pre-refinement source-backed certificate that the required provenance distinction is unavailable at the relied-upon decision boundary while the task pressure is independently recorded.

### A-K7 — ordinary model misspecification

```text
PASS
```

The source record is not merely evidence that a predictive model was inaccurate. The issue is the inability to isolate historical validation-provenance classes needed for selective trust treatment.

### A-K8 — definition expansion

```text
PASS
```

The audit does not assume `no V-factored response can satisfy T` as a premise. It uses source-backed non-distinguishability of the relevant provenance class plus independently documented security/compatibility pressure, and limits the conclusion to selective object-level treatment.

## 6. What this case does not establish

Do not infer:

```text
all representation insufficiency has this form;
all trust/revocation incidents are QX cases;
Chrome lacked any safe policy;
blanket or staged distrust was illegitimate;
the correct refinement was known in March 2017;
a generic InsufficiencyCertificate exists;
Candidate A is ready for Lean.
```

The case also does not show that a system must refine its representation. The actual remedy can instead replace, revalidate, distrust, or migrate the affected objects.

## 7. Domain verdict

```text
A-D1 Web PKI / Symantec distrust:
SURVIVES WITH EXACT RESIDUAL
```

Exact residual:

> A pre-refinement, source-backed record can establish that a relied-upon decision boundary lacks a task-relevant discriminator **without** identifying the correct finer representation, when (i) the missing discriminator is itself independently evidenced and (ii) the task pressure requiring selective treatment is independently recorded.

This is a **mechanism-specific certificate candidate** only.

It survives because the March 2017 record contains a contemporaneous statement of discriminator absence and the competing trust objectives before the later remediation architecture was fixed.

It does not authorize a generic QX object, theorem family, or Lean phase.

## 8. Degrees of freedom deleted

This domain removes three tempting shortcuts:

```text
later remediation architecture may not serve as E_pre provenance;
“unknown bad objects exist” alone is not enough;
“a conservative action exists” does not refute only the narrower claim about unavailable selective discrimination,
  but it does refute any stronger claim that the system had no acceptable action.
```

Candidate A remains alive only at the narrow level stated above. The next frozen domain is `A-D2` (737 MAX / MCAS) and must be allowed to kill the candidate's broader reading independently.
