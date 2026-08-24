# Q_open QO-2B D3 — EPA Participatory-Science Use-Indexing Audit

Status: **QO-2B_2 source-backed domain audit. Research only.**

Formal reopen: **NO**.

This audit applies the preregistered QO-2A elimination protocol after D2 has already removed two cheap inferences:

```text
review -> ChallengeStanding                  [not allowed]
different evidence burden by stage -> standing [not allowed]
```

D3 has one principal task:

```text
force the rival model Admissible_K(e,use)
as far as the native EPA structure permits.
```

The audit does not search for a Q_open positive case unless the official EPA material leaves a native gate-challenge fact that cannot be represented by use-indexed admissibility plus ordinary review/decision routing.

---

## 1. Official source baseline

Primary native sources:

1. U.S. EPA, **Frequently Asked Questions: Quality Assurance Project Plans**:
   https://www.epa.gov/participatory-science/frequently-asked-questions-quality-assurance-project-plans

   Native facts used:
   - data-quality planning is tied to intended purpose;
   - an organization may require a specific type of data for decision-making while accepting other data as supporting information;
   - EPA describes a graded approach because not all decisions require environmental data of the same quality;
   - screening and educational uses can have different quality/documentation burdens.

2. U.S. EPA, **Frequently Asked Questions for Participatory Science**:
   https://www.epa.gov/participatory-science/frequently-asked-questions-participatory-science

   Native facts used:
   - participatory-science data can contribute to supplemental monitoring, permitting inputs, screening-level enforcement data, and disaster-response decision making;
   - quality assurance planning affects which decision uses the data can support.

3. U.S. EPA, **Using Participatory Science at EPA: Vision and Principles**:
   https://www.epa.gov/system/files/documents/2022-06/Participatory%20Science%20Vision_06072022-508tagged_1.pdf

   Native facts used:
   - quality assurance/documentation corresponds to intended data uses;
   - regulatory uses have stringent quality requirements;
   - participatory-science data may nevertheless identify areas for compliance evaluations;
   - high-quality regulatory data and valuable screening-level data are explicitly distinguished.

4. U.S. EPA, **Policy Guidelines and Checklist for EPA Participatory Science Projects**:
   https://www.epa.gov/system/files/documents/2023-07/PSPolicyGuidelines_072723_Clean.pdf

   Native fact used:
   - data quality should match criteria for the intended data use, and this affects methodology, verification, and metadata requirements.

5. U.S. EPA, **Quality Assurance Handbook and Toolkit for Participatory Science Projects**:
   https://www.epa.gov/participatory-science/quality-assurance-handbook-and-toolkit-participatory-science-projects

   Native fact used:
   - EPA explicitly supports data users in evaluating whether public-generated data quality fits intended use.

These sources are especially hostile to unindexed `A_K(e)`: intended use is not a side condition but a first-class determinant of data-quality requirements.

---

## 2. Four-layer elimination model

### M0 — native EPA vocabulary only

Native positions include:

```text
participatory-science data
quality assurance / QAPP
intended data use
supporting information
screening-level data
supplemental monitoring
permitting input
compliance evaluation
regulatory / enforcement action
education / public understanding
scientific study / research
```

Native actors/owners include:

```text
community / project organization
data generator
EPA program / state / tribal / local environmental agency
decision maker / regulator / enforcement program
```

M0 already contains graded-use language. It does not present one global admissibility gate.

### M1 — use-indexed admissibility

The natural analytical representation is:

```text
Admissible_K(e, use)
```

with uses such as:

```text
u_education
u_screening
u_supporting-information
u_supplemental-monitoring
u_compliance-evaluation
u_permitting-input
u_regulatory-decision
u_enforcement-proof
```

The official EPA material directly supports patterns like:

```text
Admissible_K(e, supporting-information)
and
not Admissible_K(e, formal-decision)
```

and:

```text
Admissible_K(e, screening/compliance-identification)
and
not Admissible_K(e, enforcement-action-proof)
```

when the data quality/documentation is sufficient for the former but not the latter.

This is not a reconstruction imposed by Q_open. It mirrors EPA's own intended-use and graded-quality language.

### M2 — add ordinary ReviewTriggered / DecisionUse routing

Add ordinary native consequences:

```text
consider as supporting information
use for screening
identify information gap
identify area for compliance evaluation
request/collect higher-quality data
route to permitting or regulatory process if required standards are met
```

These consequences are ordinary environmental-data governance and program-routing actions.

The selected EPA material does not state that accepting lower-grade data for screening automatically makes the rule defining regulatory-quality requirements answerable.

### M3 — native residue after M2

Only native facts not preserved by M1+M2 may remain.

Candidate residue tested:

```text
the data challenge the validity of the intended-use quality gate itself;
the agency/program owes an answer about why that gate is legitimate;
an unresolved objection qualifies a prior finality/closure claim;
the data remain forbidden for formal use while a gate-level challenge remains live;
a review right exists whose object is the admissibility rule, not the environmental concern.
```

The audited EPA sources do not establish these facts.

They show that lower-quality or differently documented data may still have other legitimate uses. That is exactly the rival model QO-2A was designed to expose.

Therefore, for the selected D3 material:

```text
Delta_D3 = empty
```

for a non-eliminable H1/H2 gate-challenge residue.

This does not claim that environmental law contains no appeal, petition, judicial-review, or administrative challenge mechanisms. Those would be different native objects and are not imported into this participatory-science sample merely to rescue Q_open.

---

## 3. Observable-preservation table

| Observable | M1 use-indexed admissibility | M2 + ordinary routing/review | Residue needed? |
|---|---|---|---|
| target/gate | intended-use quality criterion identified | preserved | no |
| evidence use-position | screening/supporting/regulatory/enforcement/etc. | preserved explicitly | no |
| challenger / decision owner / review authority | generator and receiving agency/program remain explicit | preserved | no gate-challenger role shown |
| who acquires responsibility to respond | receiving program may evaluate, screen, or request better data | preserved | no special answerability relation shown |
| review consequence | supporting use, screening, compliance evaluation, further data collection | preserved | no |
| closure/finality consequence | no source-backed prior closure is automatically qualified by mere screening-level use | preserved | no H2 residue |
| scope | location/project/pollutant/measurement/program/use | preserved | mostly syntactic or mixed |
| what remains forbidden despite review | data may remain insufficient for a stricter regulatory/enforcement use | preserved | no |

The last row again matters:

```text
data can be considered for one purpose
while remaining unusable for another purpose
```

is already native EPA structure. It must not be redescribed as `ChallengeStanding`.

---

## 4. Mandatory case types

### N1 — ordinary anomaly that should NOT reopen

Case:

```text
participatory monitoring produces a surprising reading
but the collection/documentation quality is only suitable for screening
```

Native consequence may include:

```text
screening
additional monitoring
supporting information
```

It does not establish:

```text
regulatory violation
invalidity of EPA's quality gate
regime inadequacy
```

Thus:

```text
surprising environmental observation
-/->
gate-level reopen
```

### P1 candidate — lower-grade data legitimately considered for another use

Case:

```text
community-generated data do not meet the formal decision/enforcement standard
but are useful for screening, supporting information,
or identifying an area for compliance evaluation
```

This is the exact pattern most likely to generate a false H1 positive.

Elimination:

```text
Admissible_K(e, screening/supporting/compliance-identification)
and
not Admissible_K(e, formal-regulatory/enforcement-decision)
```

preserves the native facts.

No source-backed fact in the selected material says that the evidence thereby challenges the rule determining which data quality is required for formal regulatory use.

Therefore this P1 candidate does **not** count as an H1 witness.

### N2 — serious-looking information that should still fail the stricter use gate

Case:

```text
community data identify a potentially serious environmental concern
but lack the quality assurance/documentation required for the proposed formal use
```

Native consequence can remain:

```text
screening / supporting / further investigation
```

while:

```text
formal regulatory/enforcement use remains unavailable
```

The seriousness of the suspected concern does not automatically erase intended-use quality requirements.

This is a native anti-flooding analogue: seriousness alone does not promote the data to every use-position.

---

## 5. H1 elimination audit

QO-2A survival condition:

```text
S_K survives only if eliminating it loses a substantive gate-challenge role.
```

D3 result in the audited participatory-science material:

```text
ELIMINATED / NOT SUPPORTED beyond use-indexed admissibility.
```

`Admissible_K(e,use)` preserves the central native distinctions more faithfully than unindexed `A_K(e)`.

The selected sources do not establish a separate native relation in which data rejected for formal use force the admissibility rule itself to become answerable.

Record for QO-2C:

```text
D3 / H1: FAIL in selected sample by use-indexed-admissibility elimination
```

This is a pressure on frozen Q3, not yet the final cross-domain decision.

---

## 6. H2 ReviewTriggered-collapse audit

Native D3 review/routing consequences include:

```text
screening
supporting-information use
supplemental monitoring
compliance evaluation
additional data collection
```

The selected EPA material does not show that these consequences automatically change the status of a prior closure/finality claim.

Thus replacing `ReopenEntitled` by ordinary:

```text
ReviewTriggered / FurtherInvestigation / SupportingUse
```

loses no source-backed closure fact in this sample.

Record for QO-2C:

```text
D3 / H2: FAIL by ordinary-use/review collapse
```

---

## 7. H3 bounded-scope audit

EPA participatory-science uses can be bounded through native references such as:

```text
this project
this site/location
this pollutant/measurement
this environmental program
this proposed decision use
this possible compliance concern
```

This supports:

```text
scope bounding may precede causal localization
```

but the bound is often supplied by project/data identifiers and intended-use metadata.

Some cases are slightly stronger than pure syntax because a receiving program can bound further investigation to a particular possible compliance concern or environmental program. Nevertheless, the sources do not establish a general revision-localization principle.

Domain-level classification:

```text
D3 / H3: SYNTACTIC/MIXED scope bounding
```

Do not infer:

```text
unique diagnosis
unique minimal reopen scope
adequate causal localization
```

---

## 8. Representation dependence

D3 provides the strongest QO-2 evidence so far that unindexed object admissibility was underspecified.

The native structure is more accurately represented as:

```text
Admissible_K(e,use)
```

because data quality is explicitly evaluated against intended use.

The consequence for later QO-2C is potentially substantial:

```text
Q3 cannot survive merely by contrasting
"accepted" versus "not accepted"
without specifying the decision use.
```

Any residual `ChallengeStanding` must be distinguished from a legitimate meta-review use after use-indexing is already in place.

---

## 9. Freedom reduction

Before D3:

```text
A_K(e) could remain unindexed;
lower-quality-but-reviewable data might look like standing;
screening could be mistaken for bounded reopen.
```

After D3:

```text
any surviving account must survive A_K(e,use);
different admissibility by use does not imply standing;
supporting/screening use does not imply gate challenge;
ordinary further investigation does not imply closure defeat;
site/pollutant/project scope does not imply adequate localization.
```

D3 therefore removes a larger freedom than D2:

```text
unindexed ObjectAcceptance is not an adequate descriptive baseline
for this domain.
```

Whether QO-1 Q3 should be rewritten cross-domain is reserved for QO-2C.

---

## 10. D3 audit result

The elimination sequence is:

```text
M0 native EPA participatory-science vocabulary
  -> M1 Admissible_K(e,use) captures graded intended-use quality
  -> M2 ordinary screening/supporting/further-investigation routing
  -> M3 no source-backed H1/H2 gate-challenge residue identified
```

Record for later QO-2C:

```text
D3/H1: FAIL in selected sample by elimination
D3/H2: FAIL by ReviewTriggered/ordinary-use collapse
D3/H3: SYNTACTIC/MIXED scope bounding
A_K(e) -> A_K(e,use): strongly forced by native structure
Delta_D3: empty for tested standing/closure residue
```

Next preregistered audit: **D1 Federal Evidence Rule 103 — gate-challenge residue audit**.

D1 must begin after these freedoms have already been deleted:

```text
review != standing
different admissibility by use != standing
gate review != closure defeater unless a native closure consequence exists
syntactic scope != adequate localization
```

Formal reopen remains **NO**.
