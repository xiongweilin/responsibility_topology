# Search-Scope Provenance for Research Freezes

Status: **GOVERNANCE CORRECTION / NO NEW RESEARCH CHECKPOINT**.

Formalization: **NO**.

This document re-audits existing freeze/park/dormancy decisions under one rule:

> **A recorded absence of positive residuals does not by itself establish that the search was sufficiently broad, sufficiently observable, or saturated. Search scope must be recorded before search closure can be claimed as an epistemic justification.**

This is a correction to freeze semantics, not a new QO/QX/QC theory.

`RESEARCH_STATE.md` remains authoritative for research status. This file is the owning provenance record for what was actually searched, what was not recorded, what was deliberately excluded, and what kind of stopping claim the evidence can support.

## 1. Three state variables must remain separate

For every evidence-gated research track, distinguish:

```text
TheoryGate
SearchState
RealityHypothesis
```

Current meanings:

```text
TheoryGate = CLOSED
```

means only that the current evidence/theory record does not authorize constructing or formalizing a new object.

```text
SearchState = DORMANT / ACTIVE / SATURATED / EXTERNALLY-WAKEABLE / ...
```

records what the research process is doing. It requires its own provenance.

```text
RealityHypothesis = UNRESOLVED
```

means the record does not distinguish among at least:

```text
H1  the relevant phenomenon is genuinely rare or absent in reality;
H2  search coverage/capability was insufficient;
H3  the phenomenon exists but available sources cannot reconstruct it;
H4  the phenomenon exists but the current hypothesis/search vocabulary misses it;
H5  candidate cases exist but are correctly absorbed by stronger ordinary explanations.
```

Therefore:

```text
TheoryGate = CLOSED
-/-> RealityHypothesis = ABSENT

no positive residual found
-/-> search exhaustion

research dormancy
-/-> search saturation
```

## 2. Search exhaustion, saturation, and suspension are different

Freeze vocabulary must distinguish:

```text
SearchExhaustion
!= SearchSaturation
!= SearchSuspensionEntitlement
```

- **SearchExhaustion** requires a justified finite universe and actual exhaustion of that universe.
- **SearchSaturation** requires evidence that additional admissible search, across declared strategies/mechanism families, yields diminishing structural novelty rather than merely repeated sampling from one corner.
- **SearchSuspensionEntitlement** is a procedural permission to stop active search under bounded resources despite unresolved reality. It does not imply either exhaustion or saturation unless those have separately been established.

The existing repository has not established global SearchExhaustion or global SearchSaturation for QO, QX empirical wake, or QC.

## 3. Hard SearchScopeRecord requirement

Any future claim that active search is sufficiently complete to justify suspension on epistemic grounds must contain a `SearchScopeRecord`.

Minimum required fields:

```text
SearchQuestion
PositiveCriterion
Negative/AbsorptionCriteria
MechanismFamiliesSearched
MechanismFamiliesKnownButNotSearched
DomainOrCaseSet
SourceClassesSearched
SourceAvailabilityFailures
SearchStrategiesUsed
Independent/AdversarialStrategiesUsed
Date/TimeBoundary
Databases/SearchEngines/QueryFamilies
BudgetOrStoppingBudget
CasesScreened
CasesAuditedDeeply
CasesExcludedForInsufficientSources
CasesAbsorbedByOrdinaryExplanation
NovelResidualsBySearchBatch
MarginalNoveltyPattern
KnownBlindSpots
StopRule
WakeConditions
```

A case count without these fields is not a saturation argument.

If a historical field was not contemporaneously recorded, the only allowed value is:

```text
UNRECORDED
```

Do not reconstruct exact search queries, database coverage, or search budgets from memory and then treat that reconstruction as contemporaneous provenance.

Record, at minimum, five distinct possible search inadequacies:

```text
CoverageInsufficiency
SourceInsufficiency
HypothesisInsufficiency
StrategyInsufficiency
DiscriminatorInsufficiency
```

where `DiscriminatorInsufficiency` means the search may possess cases but lack a sufficiently discriminating audit protocol to separate a new residual from an ordinary explanation.

Hard gate:

```text
no SearchScopeRecord
-> no claim that search sufficiency justifies freeze;

bounded SearchScopeRecord
-> only scope-relative stopping claims;

bounded SearchScopeRecord + independent multi-strategy saturation evidence
-> may support provisional SearchSaturation;

none of the above
-> RealityHypothesis = ABSENT.
```

## 4. Repository-wide freeze re-audit

| Track | Freeze basis | Search-scope status | Search state | Theory gate | Reality-level interpretation |
| --- | --- | --- | --- | --- | --- |
| Papers 1–3 | artifact / semantic-baseline freeze | search closure not required for theorem identity | N/A | closed for expansion by default | external generalization unresolved |
| Strict Technical L6 | bounded technical verification scope | exact checked bridge scope recorded | N/A | closed for feature expansion by default | no claim about all runtime transitions |
| Cross-domain XDI | bounded heterogeneous falsification sample | explicit bounded discovery set; not exhaustive | dormant | no universal promotion | unresolved outside sampled domains |
| QO | preregistered falsification stop | explicit bounded literature/domain scope; query/database/budget fields incomplete | dormant / externally wakeable | closed | generic object not earned; reality unresolved |
| QX | candidate-specific falsification + prior-art absorption | explicit bounded families/cases; query/database/budget fields incomplete; E-WAKE not actively searched | dormant / externally wakeable | closed | generic object not earned; reality unresolved |
| QC | evidence gate + source-limited controls | explicit target/case ledger but incomplete mechanism/source coverage; no saturation evidence | evidence-limited / passive intake | closed | positive residual count 0; reality unresolved |

No row licenses:

```text
RealityHypothesis = ABSENT.
```

## 5. Papers 1–3 and Strict Technical Level 6

### Papers 1–3

Type of freeze:

```text
DEFINED ARTIFACT / SEMANTIC-BASELINE FREEZE
```

The correctness and identity of the frozen Lean theorem surfaces do not depend on searching all possible domains or theories.

The freeze means:

```text
this is the retained artifact/theorem surface;
new constructor/theorem expansion is not authorized by default.
```

It does **not** mean:

```text
all responsibility phenomena have been searched;
all stronger abstractions have been eliminated;
the formal kernel is ontologically complete.
```

Verdict:

```text
FREEZE JUSTIFICATION: UNAFFECTED
SEARCH-CLOSURE CLAIM: NOT APPLICABLE
SearchSaturation: NOT CLAIMED
REALITY HYPOTHESIS OUTSIDE FORMAL SCOPE: UNRESOLVED
```

### Strict Technical L6

Recorded bridge scope:

```text
actual serialized selected runtime transition artifact
-> Lean parser
-> Lean-owned restricted B0 projection
-> checker
-> restricted B0 contract
```

Recorded exclusions include:

```text
all runtime transitions;
RuntimeStep -> FormalStep*;
impact equivalence;
full Python runtime verification;
external-domain verification.
```

Verdict:

```text
FREEZE BASIS: BOUNDED TECHNICAL ENDPOINT
SearchExhaustion over runtime behavior: NOT CLAIMED
SearchSaturation: NOT CLAIMED
```

Strict-L6 remains a valid scope freeze. It is not a statement that no stronger runtime/formal bridge exists or could be built.

## 6. Cross-domain XDI

### SearchQuestion

Pressure-test candidate cross-domain separations before importing them into a stronger universal narrative.

### DomainOrCaseSet

Recorded discovery domains were fixed as:

```text
D1  FAA continued airworthiness / Airworthiness Directives
D2  U.S. federal acting authority / Appointments Clause defects
D3  metrological traceability / calibration / measurement-process control
```

Software was deliberately excluded from discovery and retained for later regression rather than counted as independent discovery support.

### SearchStrategiesUsed

```text
heterogeneous-domain falsification
+ native-domain interpretation
+ representation-dependence audit
+ withheld software regression
```

### Historical fields not recorded

```text
Databases/SearchEngines/QueryFamilies: UNRECORDED
BudgetOrStoppingBudget: UNRECORDED
complete domain universe: NOT DEFINED
MarginalNoveltyPattern: NOT RECORDED AS A SATURATION STUDY
```

### KnownBlindSpots

The repository does not claim coverage of all institutional, scientific, legal, technical, or organizational mechanisms.

### Verdict

```text
SearchScopeStatus: EXPLICIT / BOUNDED
SearchExhaustion: NO
SearchSaturation: NOT CLAIMED
Cross-domain strength: FORMAL SIMILARITY ONLY
Universal invariant: NOT CLAIMED
RealityHypothesis outside the sample: UNRESOLVED
```

The XDI freeze survives because its claims are already sample-relative and non-universal.

## 7. QO standing/closure lineage

### SearchQuestion

The positive standing/closure operationalization, especially generic `ChallengeStanding` and closure-defeater / `ReopenEntitled` structure.

### MechanismFamiliesSearched

`research/qo/Q_OPEN_PRIOR_ART_ATTACK.md` explicitly attacks the candidate through at least:

```text
CEGAR / abstraction refinement;
Bayesian model criticism;
assurance-case defeaters / assurance weakeners;
belief / ontology / automated theory repair;
Kuhnian anomaly / crisis / paradigm change;
Duhem-Quine underdetermination.
```

### DomainOrCaseSet

`research/qo/Q_OPEN_QO2A_PROTOCOL.md` preregistered:

```text
D1  Federal Rule of Evidence 103 / offer of proof;
D2  pharmacovigilance / adverse-event reports and safety signals;
D3  EPA participatory-science graded data use.
```

Each domain was required to contain:

```text
N1  ordinary anomaly that should not reopen;
P1  strongest inadmissible-for-ordinary-use challenge;
N2  serious-looking challenge that should still fail the burden.
```

The final synthesis also re-eliminated the D1 `PreservedErrorClaim` residual under a richer native procedural decomposition.

### SourceClassesSearched

Recorded source families include:

```text
U.S. Courts / Federal Rules and advisory materials;
FDA / EMA pharmacovigilance materials;
EPA participatory-science quality-assurance guidance;
peer-reviewed / primary prior-art sources used in the strong-neighbor attack.
```

### SearchStrategiesUsed

```text
adversarial prior-art attack
-> hostile renaming/regress/flooding attack
-> preregistered domain selection
-> use-indexed-admissibility elimination
-> native decomposition
-> cross-domain verdict
-> D1 internal re-elimination
```

### Historical fields not recorded

```text
Date/TimeBoundary: PARTIALLY RECORDED THROUGH SOURCE DATES, NOT AS A SEARCH WINDOW
Databases/SearchEngines/QueryFamilies: UNRECORDED
BudgetOrStoppingBudget: UNRECORDED
CasesScreened before deep audit: UNRECORDED
Independent search-strategy replication: NOT ESTABLISHED
MarginalNoveltyPattern: NOT RECORDED AS A SATURATION STUDY
```

### MechanismFamiliesKnownButNotSearched / KnownBlindSpots

```text
all possible institutional gate mechanisms: NOT SEARCHED;
comprehensive literature coverage: NOT CLAIMED;
post-freeze positive-example hunting: deliberately NOT performed.
```

### StopRule / WakeConditions

The preregistered sample produced zero non-eliminable generic QO residuals after native decomposition. The owning synthesis explicitly parks the track and prohibits rescue-domain hunting.

A legitimate restart requires at least two mechanism-distinct, source-backed, non-eliminable residuals after the ordinary decomposition is fixed before interpretation.

### Verdict

```text
TheoryGate: CLOSED
SearchState: DORMANT / EXTERNALLY-WAKEABLE
SearchScopeStatus: EXPLICIT BOUNDED / QUERY-DATABASE-BUDGET LOG INCOMPLETE
SearchExhaustion: NO
SearchSaturation: NOT ESTABLISHED
SearchSuspensionEntitlement: YES, RELATIVE TO THE PREREGISTERED FALSIFICATION STOP
RealityHypothesis: UNRESOLVED
```

Interpretation:

> QO earned the right to stop constructing and stop rescue-searching the tested generic object. It did not prove that no real institution can ever exhibit a mechanism-distinct residual.

## 8. QX representation-inadequacy lineage

### 8.1 Broad prior-art search scope

`research/qx/QX_PRIOR_ART_KILL.md` explicitly attacks broad QX novelty through at least:

```text
unawareness / partial-state-space models;
awareness of unawareness;
open-world / open-set recognition;
unknown-unknown discovery;
state aliasing / aggregation / POMDP representation;
CEGAR / abstraction refinement;
model criticism / misspecification;
finite candidate exhaustion.
```

This was an adversarial strong-neighbor audit, not a comprehensive literature review.

Historical search fields:

```text
Databases/SearchEngines/QueryFamilies: UNRECORDED
BudgetOrStoppingBudget: UNRECORDED
complete literature coverage: NOT CLAIMED
```

### 8.2 Candidate A — DomainOrCaseSet

The preregistered Candidate-A cycle used:

```text
A-D1  Web PKI / Symantec distrust
      role: possible pre-refinement provenance survivor;

A-D2  737 MAX / original MCAS
      role: hidden/existing-channel negative control;

A-D3  pulse oximetry / occult hypoxemia
      role: measurement/calibration negative control.
```

This set was designed to kill specific freedoms, not to represent the universe of representation-inadequacy phenomena.

The cycle established:

```text
Candidate A broad aliasing reading: eliminated/narrowed;
ignored signal -> representation insufficiency: rejected;
measurement error -> distinction-space insufficiency: rejected;
one mechanism-specific Web-PKI provenance residual remains;
no fourth rescue domain is authorized inside the completed candidate cycle.
```

It did **not** establish empirical saturation of mechanism-distinct Candidate-A-like cases, absence of a second independent provenance mechanism in reality, or adequacy of the search vocabulary for discovering unknown mechanisms.

### 8.3 Candidate B — DomainOrCaseSet

The active Candidate-B kill protocol audited:

```text
B-D1  incomplete-model diagnosis / hidden interaction faults;
B-D2  TLS 1.3 finite negotiation;
B-D3  spacecraft fault/failure catalogues.
```

An earlier beta-decay/neutrino stress case was retained as a pre-protocol negative control, but it was not part of the final frozen three-domain protocol.

The active domains killed:

```text
model-class exhaustion -> new QX object: rejected;
true finite protocol exhaustion -> representation inadequacy: rejected;
finite catalogue -> justified complete candidate universe: rejected.
```

This justifies Candidate B elimination as the preregistered candidate. It does not justify exhaustive search over all finite-exhaustion mechanisms.

### 8.4 T-WAKE theoretical scope

The theoretical-wake audit attacked the then-current family through:

```text
finite-state observability / diagnosability;
active diagnosis;
interaction-level observational / counterfactual equivalence;
model invalidation without a known replacement.
```

The one-shot survivor absorption additionally attacked Candidate A through:

```text
Nayebi-style task-conditioned representation selection;
Blackwell-Le Cam task-relative comparison / deficiency.
```

The result legitimately remains:

```text
T-WAKE: CLOSED FOR CURRENT CANDIDATE FAMILY
```

because the closure is family-relative. Exhaustive coverage of all possible theoretical wake mechanisms was not established.

### 8.5 SearchStrategiesUsed

```text
adversarial prior-art kill;
preregistered domain falsification;
mechanism-specific negative controls;
Candidate-A/B non-unification audit;
theoretical-wake elimination;
one-shot survivor absorption.
```

### 8.6 Historical fields not recorded / KnownBlindSpots

```text
Date/TimeBoundary: source/publication dates exist, but no global search window was frozen
Databases/SearchEngines/QueryFamilies: UNRECORDED
BudgetOrStoppingBudget: UNRECORDED
full literature exhaustiveness: NOT CLAIMED
E-WAKE mechanism search: OPEN BUT NOT ACTIVELY SEARCHED
second mechanism-distinct Candidate-A survivor: NOT FOUND / NOT ACTIVELY HUNTED AFTER FREEZE
all possible representation-independent theoretical mechanisms: NOT EXHAUSTED
independent search-strategy replication: NOT ESTABLISHED
MarginalNoveltyPattern: NOT RECORDED AS A SATURATION STUDY
```

### 8.7 StopRule / WakeConditions

```text
E-WAKE:
  new mechanism-distinct source-backed residual;

T-WAKE:
  materially different representation-independent, non-definitional provenance mechanism.
```

The current T-WAKE family is closed; the mother question is not.

### Verdict

```text
TheoryGate: CLOSED
SearchState: DORMANT / EXTERNALLY-WAKEABLE
SearchScopeStatus: EXPLICIT BOUNDED / QUERY-DATABASE-BUDGET LOG INCOMPLETE
SearchExhaustion: NO
SearchSaturation: NOT ESTABLISHED
SearchSuspensionEntitlement: YES, RELATIVE TO COMPLETED CANDIDATE-SPECIFIC STOP RULES
RealityHypothesis: UNRESOLVED
```

Candidate B is eliminated as a research candidate under the audited mechanism family. Candidate A remains one narrowed mechanism-specific survivor. Neither verdict establishes the frequency or absence of real-world representation-inadequacy structures outside the audited scope.

## 9. QC provisional-shared-determination lineage

### 9.1 SearchQuestion

Determine whether any source-backed case forces a non-eliminable responsibility structure beyond ordinary consensus, trust, aggregation, semantic translation, authority, delegation, versioning, revocation/revalidation, and ownership explanations.

### 9.2 MechanismFamiliesSearched

`research/qc/QC_PREFORMAL_SCOUTING.md` explicitly attacks broad novelty through at least:

```text
Byzantine consensus / federated Byzantine agreement;
heterogeneous quorum systems;
judgment aggregation;
belief merging;
semantic interoperability / ontology matching.
```

The hardened evidence protocol later requires case-specific testing of ordinary rival families including:

```text
consensus / replicated state;
quorum / trust configuration;
centralized or federated authority;
delegation contracts;
semantic mapping / units / ontology;
credential issuance and revocation;
versioning and cache invalidation;
notification / subscription;
service ownership;
workflow revalidation;
local policy composition.
```

These are rival families, not automatic explanations.

### 9.3 DomainOrCaseSet / evidence targets

Historical corpus targets:

```text
F0  Stellar 2019 halt;
F1  Mars Climate Orbiter;
F2  shared representation but no responsibility owner;
F3  agreement with incompatible local semantics;
F4  distributed evidence / asymmetric decision authority;
F5  delegation followed by orphaned revalidation;
F6  joint approval mistaken for joint discharge;
F7  shared abstraction erases real disagreement;
F8  local qualification changes after shared determination.
```

Source-backed controls actually audited to the current point:

```text
Stellar 2019 halt;
Mars Climate Orbiter;
Web PKI / Symantec distrust calibration;
RPKI F8 stress / shared-determination gate negative control;
DNSSEC delegation F5 stress / bounded-authority negative-success control.
```

Post-QC3A source priority was explicitly changed to:

```text
F8 first;
F5 second;
F7 lower priority.
```

The historical F7-first ordering remains preserved in the corpus.

### 9.4 SourceClassesSearched

Recorded source use includes:

```text
primary protocol/standards documents;
first-party incident/governance records;
official institutional/agency materials;
peer-reviewed prior-art literature;
source-backed operational reports sufficient to reconstruct actor/authority/currentness timelines.
```

Source-poor cases are not counted as negative evidence merely because a residual cannot be reconstructed.

### 9.5 SearchStrategiesUsed

```text
prior-art kill;
failure-corpus seeding;
source-viability calibration;
MaterialFactsFreeze before decomposition;
NativeDecomposition;
RivalAdmissible + four-dimensional RivalFit;
SharedDeterminationExistenceGate;
source-rich negative/success controls.
```

### 9.6 Historical fields not recorded / KnownBlindSpots

```text
Date/TimeBoundary: source dates exist, but no global search window was frozen
Databases/SearchEngines/QueryFamilies: UNRECORDED
BudgetOrStoppingBudget: UNRECORDED
CasesScreened before deep audit: UNRECORDED as a complete count
mechanism-complete domain coverage: NOT ESTABLISHED
source-inaccessible real incidents: structurally possible and not counted negative
F2 / F3 / F4 / F6 / F7: no completed source-rich audit under the final hardened protocol
independent multi-strategy saturation study: NOT PERFORMED
MarginalNoveltyPattern: NOT RECORDED AS A SATURATION STUDY
```

### 9.7 Current empirical result

```text
source-backed positive QC residuals: 0
```

This means only that no current **admitted and audited** case has forced a generic QC object.

### 9.8 StopRule / WakeConditions

Current policy:

```text
do not collect another case merely for momentum;
admit a new case only when source viability is independently high;
run the hardened evidence pipeline before any research-state change.
```

This is a governance/resource policy, not a saturation result.

A new independently source-viable event may enter the pipeline without contradicting the current freeze.

### Verdict

```text
QC TheoryGate: CLOSED
QC TrackStatus: EVIDENCE-LIMITED / PRE-FORMAL
QC SearchState: DORMANT / PASSIVE INTAKE / EXTERNALLY-WAKEABLE
QC SearchScopeStatus: EXPLICIT BUT INCOMPLETE
QC SearchExhaustion: NO
QC SearchSaturation: NOT ESTABLISHED
QC SearchSuspensionEntitlement based on saturation: NO
QC RealityHypothesis: UNRESOLVED
```

The statement "there is no obligation to collect another case for momentum" remains valid only as a governance rule against performative case accumulation. It must not be read as proof that the search is sufficiently saturated.

## 10. What the current freeze is entitled to mean

The repository-wide freeze should now be read as:

> **Under the research objects, sources, candidate families, and discrimination protocols actually audited so far, no current evidence authorizes further theory construction or formalization. The record does not establish that reality lacks positive cases, that empirical search is exhausted, or that QX/QC search is saturated.**

Equivalently:

```text
construction/formalization freeze: JUSTIFIED
search-saturation claim: NOT ESTABLISHED
ontological absence claim: NOT AUTHORIZED
RealityHypothesis: UNRESOLVED
```

This correction does not reopen QO, QX, or QC construction.

It prevents the invalid inference:

```text
no object earned under completed audits
```

therefore:

```text
sufficiently searched reality and found none.
```

## 11. Future freeze requirement

Any future research-stop/freeze document that relies on search sufficiency must include a `SearchScopeRecord` satisfying Section 3.

If no such record exists, the strongest allowed stop language is:

```text
TheoryGate: CLOSED under current evidence
SearchState: DORMANT or PAUSED for governance/resource reasons
SearchSaturation: UNASSESSED / NOT ESTABLISHED
RealityHypothesis: UNRESOLVED
```

It may not say or imply:

```text
searched enough;
no further cases likely exist;
empirical space exhausted;
negative result representative of reality;
no anomaly exists outside the audited scope.
```

Any future proposal to change a track from:

```text
ACTIVE -> SATURATED
ACTIVE -> DORMANT because search was sufficient
DORMANT -> ACTIVE
EXTERNALLY-WAKEABLE -> ACTIVE
```

must update this file with a new `SearchScopeRecord`.

A future saturation claim must specifically record evidence for:

```text
mechanism-family coverage;
source-class coverage;
multiple materially distinct search strategies;
known blind spots;
marginal novelty decline under additional search;
explicit wake conditions.
```

Case count alone is insufficient.

## 12. No new research ladder

This file is repository-level governance provenance.

It does not create:

```text
QX-6;
QC-4;
a new Q_close theory;
SearchClosure predicate;
Lean formalization;
a claim that responsible search suspension has itself been theoretically solved.
```

The meta-problem remains open. This document only corrects what the existing freezes are entitled to mean.
