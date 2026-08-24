# QC — Failure Corpus

Status: **QC-2 pre-formal failure corpus. Research only.**

Formalization: **NO**.

This file collects failure shapes before any QC calculus or generic shared-reliance object is proposed.

A corpus entry is not evidence for QC merely because it involves multiple organizations, disagreement, review, or distributed systems.

Each entry must first survive ordinary decomposition.

## 1. Corpus discipline

For every candidate failure, record native facts before QC vocabulary.

Required decomposition axes:

```text
consensus / replicated state;
quorum or trust configuration;
semantic mapping / units / ontology;
evidence ownership;
decision authority;
qualification/currentness;
delegation;
revocation/revalidation;
responsibility owner;
local versus shared consequence.
```

A case supports no QC residual if those ordinary axes preserve all material facts.

## 2. Evidence maturity labels

Use only:

```text
SOURCE-BACKED
FORMAL/KNOWN-NEIGHBOR
SOURCE TARGET
REJECTED AS QC EVIDENCE
```

Unverified archetypes remain search targets, not cases.

## 3. F0 — Stellar 2019 network halt

Evidence maturity:

```text
SOURCE-BACKED
```

Native facts:

- On May 15, 2019, Stellar halted for 67 minutes because the network could not reach consensus.
- Ledger safety was preserved; no fork or inconsistent balances resulted.
- Several validators were down, shaky, or misconfigured, and a further validator maintenance event pushed the network into a liveness failure.
- Recovery involved coordination and quorum-set reconfiguration.

Primary source:

- Stellar Development Foundation, *May 15th Network Halt*.

Ordinary decomposition:

```text
heterogeneous trust/quorum configuration
+
validator availability
+
consensus safety/liveness
+
operator coordination
```

captures the relevant failure.

No semantic-translation or shared-responsibility residual is needed.

QC classification:

```text
REJECTED AS QC EVIDENCE
```

Reason:

> This is a high-value negative control. It proves that decentralized, heterogeneous-trust failures can be fully real and operationally serious while remaining ordinary consensus/quorum problems.

Freedom deleted:

```text
heterogeneous distributed failure
-/->
QC residual
```

## 4. F1 — Mars Climate Orbiter interface-unit mismatch

Evidence maturity:

```text
SOURCE-BACKED
```

Native facts:

- NASA/JPL identifies the Mars Climate Orbiter loss as caused by failure to translate English units to metric in a ground-software/interface path.
- NASA engineering lessons state that interface documentation required metric units while actual data were supplied in English units and trajectory modelers assumed compliance with the interface requirement.
- The failure included interface communication/validation weaknesses between project elements.

Primary sources:

- NASA/JPL, *Mars Climate Orbiter* mission summary.
- NASA Software Engineering Handbook, Mars Climate Orbiter lessons learned / interface-design guidance.
- NASA/JPL, *Mars Climate Orbiter Team Finds Likely Cause of Loss*.

Ordinary decomposition:

```text
semantic/unit mismatch
+
interface contract violation
+
verification/validation failure
+
communication failure
```

captures the core failure.

QC classification:

```text
REJECTED AS QC EVIDENCE
```

Reason:

> Multiple teams exchanged apparently usable information, but the failure is already explained by semantic translation/interface validation. It does not show a distinct provisional-shared-determination responsibility relation.

Freedom deleted:

```text
shared data exchange with incompatible semantics
-/->
QC residual
```

## 5. F2 — shared representation but no responsibility owner

Evidence maturity:

```text
SOURCE TARGET
```

Candidate native shape:

```text
multiple agents accept/use one shared representation;
a downstream determination is produced;
no actor is clearly responsible for maintaining the evidence/qualification on which the shared determination depends.
```

Potential ordinary explanations to test first:

```text
governance assignment missing;
RACI/role-definition failure;
evidence provenance incomplete;
authority/delegation contract incomplete;
ordinary service ownership gap.
```

QC admission condition:

A source-backed case must show that those ordinary ownership/governance models do **not** preserve a material residual.

Until then:

```text
NOT QC EVIDENCE
```

## 6. F3 — agreement with incompatible local semantics

Evidence maturity:

```text
SOURCE TARGET
```

Candidate native shape:

```text
agents agree on one shared label/value;
their local semantic interpretations differ materially;
the shared value is relied upon as if the semantics were equivalent.
```

Required eliminations:

```text
ontology alignment;
unit conversion;
schema mapping;
semantic mediation;
ordinary data-contract validation.
```

The Mars Climate Orbiter case is a negative-control predecessor showing that semantic mismatch alone is insufficient for QC.

A genuine QC candidate would need a stronger fact, such as:

```text
partial translation is knowingly non-equivalent,
yet a bounded common determination is still operationally relied upon,
with explicit local qualification obligations that do not collapse into one shared semantics.
```

No such source-backed case is admitted yet.

## 7. F4 — distributed evidence, asymmetric decision authority

Evidence maturity:

```text
SOURCE TARGET
```

Candidate native shape:

```text
multiple agents own evidence needed for one determination;
one or a subset has authority to decide;
other evidence owners retain update/revocation responsibilities;
shared downstream reliance continues across the authority/evidence split.
```

Required ordinary decomposition:

```text
evidence provenance;
decision rights;
deliberation/advisory process;
delegation;
centralized final authority;
change-notification obligations.
```

QC residual condition:

Only admit a case if the material failure concerns the relation between shared reliance and continuing distributed qualification responsibility, rather than ordinary centralized decision-making with distributed inputs.

## 8. F5 — delegation followed by orphaned revalidation

Evidence maturity:

```text
SOURCE TARGET
```

Candidate native shape:

```text
A delegates or contributes authority/evidence to shared determination D;
D becomes relied upon by B/C;
underlying evidence or authority changes;
no participant has a complete local rule for who must revalidate D;
D remains shared despite orphaned update responsibility.
```

Required ordinary decomposition:

```text
delegation contract;
certificate/credential expiry;
subscription/change notification;
service ownership;
revocation propagation;
workflow revalidation.
```

QC must not invent a new object if those mechanisms explain the failure.

## 9. F6 — joint approval mistaken for joint discharge

Evidence maturity:

```text
SOURCE TARGET
```

Candidate native shape:

```text
several agents approve one artifact/determination;
the existence of multiple approvals is interpreted as if all responsibility obligations were jointly discharged;
some evidence/authority/maintenance obligation actually remains local and incomplete.
```

Required eliminations:

```text
ordinary approval workflow;
signature semantics;
role-based authorization;
separation of duties;
assurance-case ownership;
discharge evidence requirements.
```

This corpus entry is motivated by an existing program firewall:

```text
affectedness != discharge
```

but QC must not transfer that theorem across domains by analogy.

## 10. F7 — shared abstraction erases real disagreement

Evidence maturity:

```text
SOURCE TARGET / HIGH PRIORITY
```

Candidate native shape:

```text
agent A distinguishes x and y one way;
agent B distinguishes them another way;
a shared abstraction maps both local representations to one common label;
agents appear to agree at the shared layer;
the apparent agreement disappears when a task-relevant local distinction is restored.
```

This is the most important prospective bridge to QX, but no bridge theorem is assumed.

Required eliminations:

```text
ordinary lossy translation;
ontology-mapping error;
aggregation over a shared agenda;
state abstraction/aliasing;
information-loss annotation.
```

A genuine QC residual would require more than showing information loss.

It would need a source-backed failure in which:

```text
shared reliance is authorized because of the apparent common determination,
while the local systems retain incompatible responsibility-relevant meanings,
and ordinary translation/consensus models do not capture the resulting update/discharge burden.
```

Until such evidence exists:

```text
RepresentationInsufficiency -> FalseSharedDetermination
```

is **not** a QX/QC law.

## 11. F8 — local qualification changes after shared determination

Evidence maturity:

```text
SOURCE TARGET
```

Candidate native shape:

```text
A and B share determination d;
A's local evidence/qualification later changes;
B still relies on d;
the shared system has no semantically adequate rule for whether A's local change propagates, withdraws, or merely qualifies B's reliance.
```

Required eliminations:

```text
cache invalidation;
versioning;
subscription/event propagation;
credential revocation;
ordinary distributed consistency;
contractual revalidation rules.
```

QC residue requires a failure of responsibility interpretation, not merely stale data.

## 12. Failure-corpus admission matrix

| Entry | Source status | Ordinary decomposition currently sufficient? | QC residual admitted? |
|---|---|---|---|
| F0 Stellar halt | SOURCE-BACKED | yes — quorum/consensus/liveness | no |
| F1 Mars Climate Orbiter | SOURCE-BACKED | yes — semantic/interface/V&V | no |
| F2 no responsibility owner | SOURCE TARGET | unknown | no |
| F3 incompatible local semantics under agreement | SOURCE TARGET | unknown | no |
| F4 distributed evidence / asymmetric authority | SOURCE TARGET | unknown | no |
| F5 orphaned revalidation | SOURCE TARGET | unknown | no |
| F6 joint approval != joint discharge | SOURCE TARGET | unknown | no |
| F7 shared abstraction erases disagreement | SOURCE TARGET / HIGH PRIORITY | unknown | no |
| F8 local qualification changes after sharing | SOURCE TARGET | unknown | no |

This table is intentionally conservative.

## 13. What fields are not yet earned

Do not define a generic QC structure with fields such as:

```text
participants
shared proposition
semantic mappings
authority
revocation
revalidation
```

merely because the failure corpus mentions them.

A field becomes a candidate only after multiple source-backed failures require it and ordinary decomposition cannot eliminate it.

## 14. Native-decomposition template for next QC phase

For each future source-backed case, record:

```text
Local representations
Native determination(s)
Shared object/value, if any
Semantic translation path
Evidence owners
Decision authority
Who may rely
Purpose/scope of reliance
Currentness/qualification owners
Revocation trigger
Revalidation owner
What exactly failed
What ordinary model explains
What native fact remains after ordinary explanation
```

Then compute conceptually:

```text
Delta_D = native material facts not preserved by ordinary decomposition
```

Do not name `Delta_D` as a generic QC relation.

## 15. Corpus result

The current corpus has two source-backed negative controls and six evidence-acquisition targets.

Current earned statements are only:

```text
real heterogeneous consensus failures can be ordinary quorum failures;
real multi-team semantic failures can be ordinary interface/translation failures;
therefore neither distributed agreement failure nor semantic mismatch alone earns QC.
```

No positive QC relation is earned.

## 16. QC stop / next gate

Do not open Lean.

Do not define `ProvisionalSharedReliance` yet.

Do not count unsourced failure archetypes as validation.

The next QC move, if continued, is **native source acquisition and decomposition** for F2–F8, with F7 the highest-priority falsifier/candidate because it most directly tests whether apparent agreement can be an artifact of a lossy shared abstraction.

Current status:

```text
QC failure corpus: SEEDED
source-backed positive QC residuals: NONE
QC generic object: NOT EARNED
QC formalization: NO
```
