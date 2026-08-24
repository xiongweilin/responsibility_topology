# Cross-Domain Falsification Matrix — XDI-2

Status: source-backed research audit under `CROSS_DOMAIN_FALSIFICATION_PROTOCOL.md`.

No result in this file is a Lean theorem, universal invariant, legal opinion, airworthiness determination, or metrological certification.

The first discovery round intentionally excludes software.

## Candidates under test

```text
I1  persistent relation
    != state-indexed current responsibility

I2  dependency / impact
    != repair / discharge responsibility

I3  correctness inside model
    != adequacy of model
```

The audit does not protect these wordings. If a domain forces a split or a narrower formulation, the candidate loses its original form.

---

# D1 — Physical-operational domain

## Concrete sample: FAA continued airworthiness / Airworthiness Directives

### Domain-native reconstruction

An FAA Airworthiness Directive (AD) is a legally enforceable rule under 14 CFR part 39 used to correct an unsafe condition in an aircraft, aircraft engine, propeller, or appliance. An applicable AD identifies affected products and may require corrective action, operating limitations, or both, with a specified compliance time. Owners/operators are responsible for maintaining compliance with applicable ADs.

The domain also supports Alternative Methods of Compliance (AMOCs). The FAA describes an AD as providing one means to resolve the unsafe condition and an AMOC as an FAA-approved different means that provides an acceptable level of safety. Thus the same unsafe condition and applicability relation need not determine one unique physical or procedural discharge.

AD identity is not itself permanent current obligation. FAA guidance states that a superseded AD is no longer in effect and has no compliance requirements; the superseding AD becomes the operative rule. Recent FAA rulemaking gives concrete examples in which a prior AD is superseded because additional new or more restrictive airworthiness limitations are determined necessary.

Domain-native objects used below:

```text
aircraft / engine / propeller / appliance
installed component / modification state
unsafe condition
AD applicability
AD compliance history
current applicable AD requirements
inspection / replacement / modification / limitation
AMOC
maintenance / inspection program
```

### Primary sources

1. FAA, “Airworthiness Directives (ADs)” — ADs are legally enforceable rules under 14 CFR part 39 to correct unsafe conditions.
   https://www.faa.gov/aircraft/air_cert/continued_operation/ad
2. FAA, “Airworthiness Directives (AD) - Applicability and Compliance” — no person may operate a product to which an AD applies except in accordance with the AD; owner/operator maintains compliance.
   https://www.faa.gov/aircraft/air_cert/continued_operation/ad/app_comp
3. FAA, “Airworthiness Directive (AD) - Content & Format” — ADs identify unsafe condition, affected product, corrective action and/or operating limitations, effective date and compliance time.
   https://www.faa.gov/aircraft/air_cert/continued_operation/ad/ad_content
4. FAA, “Alternative Methods of Compliance (AMOC)” — one unsafe condition may be addressed by the AD method or an approved different method providing an acceptable level of safety.
   https://www.faa.gov/aircraft/air_cert/continued_operation/ad/alt_moc
5. FAA, “Types of Airworthiness Directives” — a superseded AD is no longer in effect and has no compliance requirements.
   https://www.faa.gov/aircraft/air_cert/continued_operation/ad/type_pub
6. FAA, “Airworthiness Directives (ADs) - Responsibilities” — owner/operator compliance responsibility and type-certificate-holder correction responsibility.
   https://www.faa.gov/aircraft/air_cert/continued_operation/ad/gen_resp
7. Federal Register / FAA, AD 2026-03-07 — supersedes AD 2024-08-05 after FAA determines additional new and more restrictive limitations are necessary.
   https://public-inspection.federalregister.gov/2026-03503.pdf

---

## D1 × I1

Candidate wording:

```text
persistent relation
!=
state-indexed current responsibility
```

### Persistent object/relation

The domain clearly retains historical artifacts and facts such as:

```text
component installation/removal history
maintenance record
AD compliance action performed at a date
prior applicable AD identity
inspection/modification history
```

However, the domain falsifies the stronger phrase **persistent relation** if that is read to mean that the same regulatory obligation remains operative. A superseded AD is no longer in effect and carries no current compliance requirements.

### Current qualification

Current operational permissibility depends on the ADs that presently apply to the actual product/configuration and on compliance with their current requirements and times.

### Invalidator

Examples:

```text
issuance of an applicable AD after an unsafe condition is identified
superseding AD with new/more restrictive limitations
changed configuration that changes the appropriate compliance method
inspection result showing corrective action is required
```

### Repair/discharge

Possible discharge includes inspection, replacement, modification, operating limitation, maintenance-program revision, or an approved AMOC.

### Counterexample

A superseded AD is a direct counterexample to interpreting I1 as:

```text
historical regulatory relation remains a current relation forever
```

The historical AD and compliance history remain auditable, but the operative legal obligation moves to the superseding rule.

### Representation dependence

**High.** An append-only maintenance database guarantees record persistence, but the regulatory relation is defined by currently applicable law, not by the persistence characteristics of the database.

The audit must distinguish:

```text
record persistence
!=
operative-relation persistence
```

### Failure mode

Original I1 conflates persistent historical record/act with persistent operative relation.

### Migration class

`formal similarity`

There is a meaningful historical/current split, but the mechanism is physical-regulatory rather than the kernel's evaluation-state mechanism.

### Verdict

`narrows`

Surviving D1 formulation:

```text
retained historical/audit facts
can remain distinct from
current operational qualification under the presently applicable regime
```

---

## D1 × I2

Candidate wording:

```text
dependency / impact
!=
repair / discharge responsibility
```

### Persistent object/relation

The unsafe-condition/applicability relation identifies which product or configuration is affected.

### Current qualification

Current operation is permitted only under the applicable AD requirements or approved alternative compliance path.

### Invalidator

Identification of an unsafe condition and issuance/applicability of an AD creates a current compliance obligation; later inspection or configuration facts can refine what action is required.

### Repair/discharge

FAA material explicitly permits multiple classes of discharge:

```text
inspection
repair
replacement
modification
operating limitation
changed compliance time
approved AMOC
```

An AMOC exists precisely because the AD's stated method is not the only possible acceptable way to address the unsafe condition.

### Counterexample

I2 would fail if a domain defined “impact” to include the exact mandatory remedy by definition. Some individual AD provisions can be highly prescriptive. Nevertheless, the wider continued-airworthiness mechanism preserves a separate AMOC decision surface.

### Representation dependence

**Low-to-moderate.** The distinction is not produced merely by database normalization. FAA itself separates unsafe-condition/applicability from the method approved to resolve it.

### Failure mode

The candidate would overstate independence if read as “impact never constrains repair.” Impact can strongly constrain acceptable discharge; the surviving claim is non-identity, not independence.

### Migration class

`formal similarity`

The abstract distinction is strong, but physical repair, regulator approval, and operational limitations are materially different mechanisms from formal repair actions.

### Verdict

`survives`

Boundary-qualified reading:

```text
identifying what is affected does not by itself establish a unique sufficient discharge
```

---

## D1 × I3

Candidate wording:

```text
correctness inside model
!=
adequacy of model
```

### Persistent object/relation

At a given time an operator can correctly satisfy the currently applicable AD requirements and record that compliance.

### Current qualification

The current safety-control regime can later change when the FAA determines that additional or more restrictive limitations are necessary.

### Invalidator

New continued-airworthiness information can cause a prior AD to be superseded or strengthened.

### Repair/discharge

The governing rule can be replaced/superseded; maintenance or inspection programs can require new restrictions or actions.

### Counterexample

If “correctness” is defined globally as “satisfies every actually adequate safety requirement,” I3 becomes tautological or meaningless. Domain-native correctness must therefore be stated more narrowly as conformity with the rule in force at a given point.

### Representation dependence

**Moderate.** The distinction depends on separating:

```text
conformity to the current regulatory control
from
whether that control remains sufficient for the unsafe condition as knowledge changes
```

That separation is domain-native because superseding ADs change operative requirements after additional safety information.

### Failure mode

The word `model` is too computational. In D1 the relevant object is better called a **governing safety-control regime or rule set**.

### Migration class

`formal similarity`

### Verdict

`narrows`

Surviving D1 formulation:

```text
conformity with the governing safety-control regime at t
does not establish that the regime will remain sufficient under later safety evidence
```

---

# D2 — Normative-institutional domain

## Concrete sample: U.S. federal acting authority and Appointments Clause defects

### Domain-native reconstruction

The Federal Vacancies Reform Act (FVRA) authorizes temporary acting service in certain Senate-confirmed offices and generally limits acting service to a statutory time window. Under 5 U.S.C. §3346, an acting officer normally may serve no longer than 210 days from the vacancy, subject to nomination-related extensions.

GAO decisions applying 5 U.S.C. §3348 explain that after permissible acting service ends, the office must remain vacant and only the agency head may perform certain non-delegable functions/duties; actions by another person performing such a function or duty can have no force or effect and may not be ratified.

A separate constitutional example is *Lucia v. SEC* (2018). The Supreme Court held that SEC administrative law judges were Officers of the United States subject to the Appointments Clause. For a timely challenge, the remedy was a new hearing before a properly appointed official; the same ALJ who had already heard Lucia's case could not simply rehear it merely after the defect was identified.

Domain-native objects used below:

```text
appointment / designation
vacancy
acting-service statutory window
office / function / duty
current authority
agency adjudication
Appointments Clause defect
new hearing / different properly appointed officer
ratification where legally available
```

### Primary sources

1. U.S. Code, 5 U.S.C. §3346, “Time limitation.”
   https://uscode.house.gov/view.xhtml?edition=prelim&num=0&req=granuleid%3AUSC-prelim-title5-section3346
2. GAO, B-335587, “Violation of the Time Limit Imposed by the Federal Vacancies Reform Act of 1998: Legal Adviser, U.S. Department of State” — explains current acting-service limit and §3348 consequences, including no force/effect and no ratification for covered functions/duties.
   https://www.gao.gov/products/b-335587
3. GAO, B-336092, DOJ Office of Legal Policy acting-service violation — distinguishes expired acting title/current authority and discusses §3348 enforcement scope.
   https://www.gao.gov/products/b-336092
4. U.S. Supreme Court, *Lucia v. SEC*, 585 U.S. 237 (2018) — Appointments Clause violation and new-hearing remedy before a properly appointed official.
   https://www.supremecourt.gov/opinions/17pdf/17-130_4f14.pdf

---

## D2 × I1

Candidate wording:

```text
persistent relation
!=
state-indexed current responsibility
```

### Persistent object/relation

Historical facts can remain fixed and auditable:

```text
person was designated/appointed at date t
person served in an acting capacity during interval [t1,t2]
a decision/hearing occurred
```

But current legal authority is not a persistent continuation of the historical designation. Statutory time limits can terminate acting authority.

### Current qualification

Current authority depends on the governing appointment/designation rule, timing, office, and function/duty at the current point.

### Invalidator

Examples:

```text
expiration of the statutory acting-service period
failed constitutional appointment
loss of jurisdiction or other disqualifying legal condition
```

### Repair/discharge

Possible responses differ by defect:

```text
proper appointment
different authorized decisionmaker
new hearing
agency-head performance of reserved function
ratification only where law permits it
```

### Counterexample

5 U.S.C. §3348 is a direct warning against treating the operative legal relation as historically persistent. For covered functions/duties, an act outside valid acting authority can have no force/effect and may not be ratified.

Thus the safe historical object is often the **fact that an act/designation occurred**, not a still-operative authority relation.

### Representation dependence

**Very high.** Legal systems distinguish archival fact, legal validity, authority, voidness, voidability, and remedy. Collapsing all of these into “persistent relation” would erase domain-native distinctions.

### Failure mode

I1's original noun `persistent relation` is too strong. The domain supports persistent historical description more readily than persistent legal relation.

### Migration class

`formal similarity`

### Verdict

`narrows`

Surviving D2 formulation:

```text
historical appointment/designation/act facts
can remain distinct from
current legal authority to act now
```

---

## D2 × I2

Candidate wording:

```text
dependency / impact
!=
repair / discharge responsibility
```

### Persistent object/relation

An appointment defect, expired acting authority, or Appointments Clause violation can identify an affected office/action/proceeding.

### Current qualification

The legal question then becomes what authority or remedy is now required under the relevant statute/constitutional doctrine.

### Invalidator

Examples:

```text
acting-service period expires
court finds Appointments Clause violation
a timely challenger establishes defective appointment
```

### Repair/discharge

The remedy depends on the defect and legal regime. In *Lucia*, the required response was a new hearing before a properly appointed official, and the Court required a different properly appointed adjudicator (or the Commission). Under FVRA §3348, some covered unauthorized actions may have no force/effect and may not be ratified.

### Counterexample

Some statutes can prescribe a nearly determinate consequence for a defined defect. Therefore I2 cannot mean that remedy is always discretionary or multi-valued.

### Representation dependence

**Moderate.** The affectedness/remedy distinction is domain-native in judicial remedial analysis, but its exact structure depends on the hierarchy of statutes, constitutional rules, preserved-error doctrines, ratification rules, standing/timeliness, and the function at issue.

### Failure mode

The candidate fails if it is strengthened to:

```text
impact places no constraints on remedy
```

Legal doctrine often tightly constrains remedy.

### Migration class

`formal similarity`

### Verdict

`survives`

Boundary-qualified reading:

```text
identifying the legal defect and affected act does not by itself equal the legally sufficient remedy/discharge
```

---

## D2 × I3

Candidate wording:

```text
correctness inside model
!=
adequacy of model
```

### Persistent object/relation

An institutional procedure can be carried through under an agency's operative procedural machinery: hearing held, evidence considered, decision issued.

### Current qualification

A higher-order legal question can nevertheless ask whether the decisionmaker's appointment/authority satisfies constitutional or statutory requirements.

### Invalidator

*Lucia* demonstrates that a completed agency adjudication can be challenged because the ALJ's appointment violated the Appointments Clause.

### Repair/discharge

The remedy was not merely “mark the old procedure valid.” A new hearing before a properly appointed official was required.

### Counterexample

The phrase `correctness inside model` is dangerous in law. If “legal correctness” is defined to include the entire hierarchy of constitutional, statutory, and procedural law, then a proceeding with an Appointments Clause defect was never legally correct.

The candidate therefore cannot survive with `correctness` unqualified.

### Representation dependence

**Very high.** Legal validity is hierarchical. What appears correct inside an agency sub-regime may be invalid under higher law. The separation depends on which layer is treated as the evaluated regime.

### Failure mode

I3 conflates:

```text
local/sub-regime procedural conformity
with
global legal correctness
```

### Migration class

`formal similarity` after the split

### Verdict

`splits`

Surviving D2 formulation:

```text
conformity within a lower-level institutional procedure
!=
higher-order validity/adequacy of the authority regime governing that procedure
```

This is not a statement that law has an external “model adequacy” criterion identical to scientific model adequacy.

---

# D3 — Empirical-scientific domain

## Concrete sample: metrological traceability, calibration, and measurement-process control

### Domain-native reconstruction

The International Vocabulary of Metrology (VIM) defines metrological traceability as a property of a measurement result whereby it can be related to a reference through a documented unbroken chain of calibrations, each contributing to measurement uncertainty. The definition is explicitly historical/time-sensitive: relevant documentation includes when references in the calibration hierarchy were used.

Crucially, VIM Note 5 states that metrological traceability does not ensure that the measurement uncertainty is adequate for a given purpose or that mistakes are absent.

VIM also distinguishes calibration from verification and adjustment. NIST measurement-assurance guidance treats control as an ongoing process: periodic check standards determine whether current measurement performance remains in control; significant procedure/instrument/standard/location changes can require the procedure to be repeated. NIST remedial-action guidance distinguishes causes and responses such as repeating measurements, discarding current measurements, repairing instruments, recalibrating reference artifacts, and re-establishing process values/control limits.

Domain-native objects used below:

```text
measurement result
measurement uncertainty
measurement procedure
measurement model
calibrated measuring system
calibration hierarchy / traceability chain
check standard
in-control / out-of-control measurement process
recalibration / repeat measurement / discard / re-analysis
fitness for intended use
```

### Primary sources

1. BIPM/JCGM VIM3 §2.41, “metrological traceability” — documented unbroken calibration chain; Note 5: traceability does not ensure adequate uncertainty for purpose or absence of mistakes.
   https://jcgm.bipm.org/vim/en/2.41.html
2. BIPM/JCGM VIM3 §2.39, “calibration” — calibration establishes relations under specified conditions and is distinct from adjustment/verification.
   https://jcgm.bipm.org/vim/en/2.39.html
3. BIPM/JCGM VIM3 §2.1, “measurement” — measurement presupposes intended-use description, procedure, and calibrated measuring system under specified conditions.
   https://jcgm.bipm.org/vim/en/2.1.html
4. BIPM/JCGM VIM3 §2.44, “verification” — objective evidence that specified requirements are fulfilled; verification is not calibration, and not every verification is validation.
   https://jcgm.bipm.org/vim/en/2.44.html
5. NIST, SOP 30, “Process Measurement Assurance Program” — periodic check standards ensure current process remains in control; significant changes can require procedure repetition.
   https://www.nist.gov/system/files/documents/2019/05/13/sop-30-process-measurement-assurance-20190506.pdf
6. NIST/SEMATECH e-Handbook, “Remedial actions” — out-of-control signals lead to cause-sensitive responses including repeat/discard, repair, recalibration, and re-establishment of process control.
   https://itl.nist.gov/div898/handbook/mpc/section2/mpc224.htm
7. NIST/SEMATECH e-Handbook, “Control of bias and long-term variability” — an out-of-control current calibration run is rejected and recurrent signals require investigation.
   https://itl.nist.gov/div898/handbook/mpc/section3/mpc352.htm

---

## D3 × I1

Candidate wording:

```text
persistent relation
!=
state-indexed current responsibility
```

### Persistent object/relation

A measurement result, its stated uncertainty, calibration record, and documented traceability chain can remain historical scientific records.

### Current qualification

Whether a result is fit for a current intended use depends on the measurement uncertainty, purpose, model/procedure assumptions, and evidence that the relevant measurement process was under control.

### Invalidator

Examples:

```text
out-of-control check-standard signal
instrument or reference-standard damage/drift
measurement-procedure change
calibration-standard change
new evidence that stated uncertainty is not adequate for intended use
```

### Repair/discharge

Possible responses include repeat measurement, discard affected/current measurements, repair instrument, recalibrate standards, re-establish control limits, re-estimate uncertainty, or perform new analysis.

### Counterexample

A later out-of-control observation does **not automatically prove that every earlier measurement was invalid**. The affected historical interval itself must be established from evidence. Therefore a simple global currentness flag over all historical results would overstate the domain mechanism.

### Representation dependence

**Moderate-to-high.** Traceability is a property of a measurement result and includes time-specific calibration information, but “current evidential admissibility” is not one universal metrological bit. Fitness depends on intended use and uncertainty requirements.

### Failure mode

`state-indexed current responsibility` is too kernel-shaped. The domain-native replacement is closer to:

```text
current fitness/evidential usability for a specified purpose
```

### Migration class

`formal similarity`

### Verdict

`narrows`

Surviving D3 formulation:

```text
documented historical measurement/traceability information
can remain fixed while
fitness of that result for a present intended use requires a separate current judgment
```

---

## D3 × I2

Candidate wording:

```text
dependency / impact
!=
repair / discharge responsibility
```

### Persistent object/relation

A measurement process has dependencies on procedures, instruments, calibration standards, environmental conditions, operators, and traceability chains.

### Current qualification

An out-of-control signal or changed standard identifies a measurement-process problem and may delimit an affected run/interval.

### Invalidator

NIST examples include changes/damage in artifacts, degradation in instrumentation, changes in environmental conditions, or out-of-control check-standard observations.

### Repair/discharge

NIST explicitly lists cause-sensitive alternatives:

```text
repeat the measurement sequence
discard current/test-item measurements
repair instruments
recalibrate reference artifacts
re-establish process value and control limits
```

The appropriate response depends on the diagnosed cause and the measurement purpose.

### Counterexample

For a specific out-of-control calibration run, NIST can require rejection/repetition. Thus some impact states have a strongly prescribed local response. I2 therefore cannot mean that every affectedness relation admits multiple equally valid repairs.

### Representation dependence

**Low-to-moderate.** The distinction between detecting out-of-control behavior and selecting remedial action appears in domain-native NIST guidance rather than being imported from the kernel.

### Failure mode

The candidate would fail if strengthened to “impact and repair are independent.” They are not: cause/impact constrains acceptable remediation.

### Migration class

`formal similarity`

### Verdict

`survives`

Boundary-qualified reading:

```text
impact diagnosis and sufficient remediation are distinct judgments even when the former constrains the latter
```

---

## D3 × I3

Candidate wording:

```text
correctness inside model
!=
adequacy of model
```

### Persistent object/relation

A measurement result can possess documented metrological traceability and can satisfy specified verification requirements.

### Current qualification

Its uncertainty still must be adequate for the intended purpose, and measurement/model mistakes remain possible.

### Invalidator

Examples:

```text
new evidence of inadequate uncertainty
out-of-control process evidence
incorrect measurement model
mistake in procedure/execution
changed intended-use requirements
```

### Repair/discharge

Possible actions include revised uncertainty evaluation, recalibration, repeat measurement, model correction, or rejection of a result for the intended use.

### Counterexample

The VIM itself falsifies any claim that traceability is equivalent to adequacy: Note 5 states that traceability does not ensure adequate uncertainty for a given purpose or absence of mistakes.

However, `correctness inside model` is still too broad. Traceability and verification are narrower conformance properties than complete scientific correctness.

### Representation dependence

**Moderate.** Adequacy is explicitly purpose-relative in metrology. Changing the intended use can change whether the same uncertainty is acceptable without changing the historical traceability chain.

### Failure mode

I3 must distinguish at least:

```text
traceability / specified-requirement conformance
from
fitness-for-purpose / model-and-uncertainty adequacy
```

### Migration class

`formal similarity`

### Verdict

`narrows`

Surviving D3 formulation:

```text
conformance/traceability within a stated measurement framework
!=
fitness or adequacy of that framework/result for the intended purpose
```

---

# 3 × 3 verdict matrix

| Candidate | D1 physical-operational | D2 normative-institutional | D3 empirical-scientific |
| --- | --- | --- | --- |
| I1 persistent relation vs current responsibility | **narrows** — audit/history persists more reliably than operative regulatory relation | **narrows** — historical designation/act persists as fact; current authority can terminate and acts may lack legal force | **narrows** — measurement/provenance remains; present fitness is purpose/evidence dependent |
| I2 dependency/impact vs repair/discharge | **survives** — unsafe condition/applicability does not uniquely fix compliance method; AMOC exists | **survives** — defect/affected act distinct from legally sufficient remedy; *Lucia* new-hearing example | **survives** — out-of-control detection distinct from cause-sensitive remediation |
| I3 correctness-inside-model vs adequacy | **narrows** — compliance with current safety rule vs later demonstrated need for stricter regime | **splits** — local procedural conformity must be distinguished from global legal validity under higher law | **narrows** — traceability/verification vs fitness-for-purpose/model/uncertainty adequacy |

No original candidate receives an unqualified 3/3 `survives` verdict.

That is a substantive result of the falsification protocol, not a defect in the audit.

---

# Cross-domain comparison by required field

## I1

### Persistent object/relation

Across the three domains, the most robust common object is not a persistent operative relation. It is a retained historical **trace/act/result/record**:

```text
D1  maintenance / compliance history
D2  appointment/designation/proceeding history
D3  measurement result / calibration and traceability record
```

### Current qualification

```text
D1  current operational compliance / airworthiness control
D2  current legal authority / validity to perform the relevant function
D3  current fitness/evidential usability for intended purpose
```

### Shared failure boundary

The original phrase `persistent relation` overstates the commonality. In D1 and D2 especially, the operative relation can end, be superseded, or lack legal force while the record remains.

### Representation-dependence conclusion

High enough that original I1 cannot be promoted as written.

The candidate must split:

```text
I1a  historical trace/record persistence
I1b  historical operative-relation persistence
```

Only I1a has clear cross-domain support in this round, and even I1a may depend on archival/institutional record practices.

---

## I2

### Persistent object/relation

All three domains expose an impact/affectedness diagnosis that is logically and institutionally distinguishable from sufficient discharge.

### Current qualification

All three impose present obligations after the impact is recognized.

### Shared failure boundary

The distinction does not imply independence, discretion, or multiple possible remedies in every case. Some regimes prescribe a specific response.

### Representation-dependence conclusion

Moderate. The distinction appears in domain-native rule structures:

```text
FAA unsafe condition / applicability vs AMOC/compliance method
legal defect / affected act vs remedy
NIST out-of-control signal / cause vs remedial action
```

This is stronger than a merely lexical analogy.

---

## I3

### Persistent object/relation

The cross-domain commonality is not literally “model correctness.” Instead the domains distinguish a lower-level conformity relation from a higher-order sufficiency/validity question:

```text
D1  current-rule compliance
D2  sub-regime procedural conformity
D3  traceability / specified-requirement conformance
```

against:

```text
D1  sufficiency of safety-control regime under later evidence
D2  higher-order constitutional/statutory validity
D3  fitness-for-purpose / uncertainty/model adequacy
```

### Shared failure boundary

If `correctness` is defined to already include the higher-order adequacy criterion, the distinction collapses by definition.

### Representation-dependence conclusion

High but informative. The hierarchy exists in all three domains, but the higher-order judge differs radically:

```text
safety evidence / regulator
higher law / court or legally competent authority
empirical/metrological evidence and intended use
```

Thus any promoted abstraction must avoid pretending these adequacy mechanisms are the same.

---

# Migration-class summary

The first round establishes **formal similarity**, not mechanism similarity, for every surviving/narrowed cross-domain relation.

Why mechanism similarity is withheld:

```text
D1 discharge changes physical equipment and is regulator-controlled.
D2 discharge changes legal authority/procedure and depends on hierarchy/remedy doctrine.
D3 discharge changes measurement procedure/evidence/uncertainty and is empirically controlled.
```

The common relation shapes are non-trivial, but formation, invalidation, admissibility, and repair mechanisms are not yet shown to be structure-preservingly identical.

Therefore:

```text
mechanism similarity: NOT ESTABLISHED
universal invariant: NOT CLAIMED
```

---

# XDI-2 result

The falsification run changes the candidate landscape:

```text
I1 original wording: too strong; must split record/trace persistence from operative-relation persistence.

I2 original distinction: survives all three domains with a boundary against interpreting non-identity as independence.

I3 original wording: too broad; must be reformulated as lower-level conformity vs higher-order adequacy/validity/fitness.
```

This file does not decide candidate-invariant promotion. That decision belongs to XDI-3 and must explicitly account for representation dependence and the counterexample boundaries identified here.