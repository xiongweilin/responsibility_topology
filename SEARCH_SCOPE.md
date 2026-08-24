# Search Scope and Suspension Governance

Status: **GOVERNANCE / CORRECTION AUDIT. NO NEW THEORY CHECKPOINT.**

Formalization: **NO**.

`RESEARCH_STATE.md` remains authoritative for research status. This file is the authoritative companion for the **search provenance and stopping basis** behind dormant/evidence-limited states.

The purpose of this file is to prevent a negative search result from being silently upgraded into an ontological claim.

## 1. Controlling distinction

Freeze the following separation:

```text
TheoryGate = CLOSED
-/->
RealityHypothesis = ABSENT
```

and:

```text
SearchExhaustion
!=
SearchSaturation
!=
SearchSuspensionEntitlement
```

Meanings:

```text
SearchExhaustion:
  a defined finite search space has actually been enumerated completely;

SearchSaturation:
  under a recorded set of sufficiently diverse search strategies and mechanism families,
  additional search is producing mainly already-known classifications rather than new residual structure;

SearchSuspensionEntitlement:
  the current research program has a defensible process-relative reason to suspend active search,
  without claiming that reality contains no counterexample or positive residual.
```

The default reality-level interpretation of a failed positive search is therefore:

```text
RealityHypothesis = UNRESOLVED
```

unless a separately justified finite-exhaustion argument proves otherwise.

## 2. Hard search-scope gate

A claim that **search sufficiency** justifies suspension is inadmissible unless a `SearchScopeRecord` exists.

Required fields are:

```text
Target:
  what candidate, residual, or wake condition was being searched or attacked;

Literature / mechanism families:
  which strong-neighbor theories or mechanism classes were actually included;

Domain / case set:
  which empirical or institutional domains/cases were actually audited;

Source classes:
  what source types were accepted (primary standards, incident records, peer-reviewed literature, etc.);

Selection / search strategies:
  e.g. adversarial prior-art attack, preregistered falsification, negative-control search,
  source-viability search, independent evidence event, regression sample;

Temporal / database / query scope:
  dates, databases, search engines, queries, or other discovery bounds when they were actually recorded;

Exclusions / blind spots:
  known mechanism families, domains, source classes, or search modes not covered;

Stop rule:
  what process-relative condition authorized stopping the current search cycle;

Wake condition:
  what future evidence or argument may legitimately reactivate the track;

Saturation evidence:
  what, if anything, supports a claim of marginal novelty decline across independent strategies.
```

If a historical field was not recorded contemporaneously, write:

```text
UNRECORDED
```

Do **not** reconstruct exact queries, database coverage, or search budgets from memory and then treat the reconstruction as contemporaneous provenance.

Therefore:

```text
missing SearchScopeRecord
-> no search-sufficiency claim;

recorded bounded SearchScopeRecord
-> only scope-relative stopping claims;

recorded SearchScopeRecord + multi-strategy saturation evidence
-> may support provisional SearchSaturation;

none of the above
-> ontological absence.
```

## 3. Negative-search interpretation

For QO/QX/QC, failure to find a positive residual is compatible with at least:

```text
H1  the relevant real-world structure is genuinely rare;
H2  search capability / mechanism coverage is insufficient;
H3  the structure exists but public evidence is insufficient to reconstruct it;
H4  the current problem formulation or discriminator is looking for the wrong feature;
H5  candidate cases exist but are correctly absorbed by stronger ordinary explanations.
```

Current repository evidence does not generally identify which `H_i` is true.

Thus:

```text
no positive residual found
-/->
H1.
```

The proper default is:

```text
H1 OR H2 OR H3 OR H4 OR H5 remains unresolved.
```

## 4. Repository-wide freeze re-audit

| Track | Freeze basis | Search-scope status | Search state | Theory gate | Reality-level interpretation |
| --- | --- | --- | --- | --- | --- |
| Papers 1–3 | artifact / semantic-baseline freeze | search closure not required for theorem identity | N/A | closed for expansion by default | external generalization unresolved |
| Strict Technical L6 | bounded technical verification scope | exact checked bridge scope recorded | N/A | closed for feature expansion by default | no claim about all runtime transitions |
| Cross-domain XDI | bounded heterogeneous falsification sample | explicit bounded discovery set; not exhaustive | dormant | no universal promotion | unresolved outside sampled domains |
| QO | preregistered falsification stop | explicit bounded literature/domain scope; exact query logs incomplete | dormant / externally wakeable | closed | generic object not earned; reality unresolved |
| QX | candidate-specific falsification + prior-art absorption | explicit bounded families/cases; exact query logs incomplete; E-WAKE not actively searched | dormant / externally wakeable | closed | generic object not earned; reality unresolved |
| QC | evidence gate + source-limited controls | explicit target/case ledger but incomplete mechanism/source coverage; no saturation evidence | evidence-limited / passive intake | closed | positive residual count 0; reality unresolved |

No row in this table licenses:

```text
RealityHypothesis = ABSENT.
```

## 5. Papers 1–3 — artifact freeze, not search closure

### Target

Frozen theorem/manuscript semantics for the Object -> Environment -> Change formal line.

### Search-scope relevance

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

### Verdict

```text
Freeze basis: ARTIFACT / SEMANTIC BASELINE
SearchExhaustion: NOT APPLICABLE
SearchSaturation: NOT CLAIMED
RealityHypothesis outside the formal scope: UNRESOLVED
```

The existing paper/formal freeze remains valid.

## 6. Strict Technical L6 — bounded verification freeze, not transition-class exhaustion

### Recorded scope

The current bridge is explicitly:

```text
actual serialized selected runtime transition artifact
-> Lean parser
-> Lean-owned restricted B0 projection
-> checker
-> restricted B0 contract
```

The repository already records the trust boundary and explicitly rejects full-runtime refinement language.

### Exclusions / blind spots

Not established:

```text
all runtime transitions;
RuntimeStep -> FormalStep*;
impact equivalence;
full Python runtime verification;
external-domain verification.
```

### Verdict

```text
Freeze basis: BOUNDED TECHNICAL ENDPOINT
SearchExhaustion over runtime behavior: NOT CLAIMED
SearchSaturation: NOT CLAIMED
```

Strict-L6 remains a valid **scope freeze**. It is not a statement that no stronger runtime/formal bridge exists or could be built.

## 7. Cross-domain XDI — explicit bounded discovery sample

### Target

Pressure-test candidate cross-domain separations before importing them into a stronger universal narrative.

### Recorded domain scope

Discovery domains were fixed as:

```text
D1  FAA continued airworthiness / Airworthiness Directives
D2  U.S. federal acting authority / Appointments Clause defects
D3  metrological traceability / calibration / measurement-process control
```

Software was deliberately excluded from discovery and retained for later regression rather than counted as independent discovery support.

### Strategy

```text
heterogeneous-domain falsification
+ native-domain interpretation
+ representation-dependence audit
+ withheld software regression
```

### Exclusions / blind spots

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

The XDI freeze remains valid because its claims are already sample-relative and non-universal.

## 8. QO — preregistered falsification stop

### Target

The positive standing/closure operationalization, especially generic `ChallengeStanding` and closure-defeater / `ReopenEntitled` structure.

### Recorded literature / mechanism families

`Q_OPEN_PRIOR_ART_ATTACK.md` explicitly attacks the candidate against at least:

```text
CEGAR / abstraction refinement;
Bayesian model criticism;
assurance-case defeaters / assurance weakeners;
belief / ontology / automated theory repair;
Kuhnian anomaly / crisis / paradigm change;
Duhem-Quine underdetermination.
```

### Recorded domain set

`Q_OPEN_QO2A_PROTOCOL.md` preregistered three deliberately different gate structures:

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

### Recorded source classes

Examples explicitly recorded in the protocol/synthesis include:

```text
U.S. Courts / Federal Rules and advisory materials;
FDA / EMA pharmacovigilance materials;
EPA participatory-science quality-assurance guidance;
peer-reviewed / primary prior-art sources for strong-neighbor attack.
```

### Selection / search strategy

```text
adversarial prior-art attack
-> hostile kill tests
-> preregistered domain selection
-> use-indexed-admissibility elimination
-> native decomposition
-> cross-domain verdict
-> D1 internal re-elimination
```

### Unrecorded / blind spots

```text
exact search-engine/database query log: UNRECORDED;
comprehensive literature coverage: NOT CLAIMED;
all possible institutional gate mechanisms: NOT SEARCHED;
post-freeze positive-example hunting: deliberately NOT performed.
```

### Stop rule

The preregistered sample produced zero non-eliminable generic QO residuals after native decomposition. The owning synthesis explicitly parks the track and prohibits rescue-domain hunting.

### Wake condition

A legitimate restart requires at least two mechanism-distinct, source-backed, non-eliminable residuals after the ordinary decomposition is fixed before interpretation.

### Re-audit verdict

```text
TheoryGate: CLOSED
SearchState: DORMANT / EXTERNALLY WAKEABLE
SearchScopeStatus: EXPLICIT BOUNDED / QUERY LOG INCOMPLETE
SearchExhaustion: NO
SearchSaturation: NOT CLAIMED
SearchSuspensionEntitlement: YES, RELATIVE TO THE PREREGISTERED FALSIFICATION STOP
RealityHypothesis: UNRESOLVED
```

Interpretation:

> QO earned the right to stop constructing and stop rescue-searching the tested generic object. It did not prove that no real institution can ever exhibit a mechanism-distinct residual.

## 9. QX — candidate-specific falsification and absorption scope

### Target

The mother question remains open, but positive construction is blocked unless a legal wake condition occurs.

### Recorded prior-art families

`QX_PRIOR_ART_KILL.md` explicitly attacks broad QX novelty through at least:

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

### Recorded Candidate-A domain scope

The preregistered active Candidate-A domain cycle used:

```text
Web PKI / Symantec distrust;
737 MAX / MCAS existing-channel negative control;
pulse oximetry measurement/calibration negative control.
```

No fourth rescue domain is authorized.

### Recorded Candidate-B domain scope

The active preregistered Candidate-B cycle used:

```text
incomplete-model diagnosis;
TLS 1.3 finite negotiation;
spacecraft fault-protection catalogue.
```

The earlier beta-decay audit is retained as historical/pre-protocol negative-control material and is not counted as an additional active-cycle success condition.

### Recorded T-WAKE theoretical scope

`QX_TW_THEORETICAL_WAKE_ELIMINATION.md` attacks the current theoretical-wake family against:

```text
finite-state observability / diagnosability;
active diagnosis;
interaction-level observational / counterfactual equivalence;
model invalidation without a known replacement.
```

`QX_SURVIVOR_ABSORPTION.md` additionally attacks the sole Candidate-A survivor with:

```text
Nayebi-style task-conditioned representation selection;
Blackwell-Le Cam task-relative comparison / deficiency.
```

### Selection / search strategies

```text
adversarial prior-art kill;
preregistered domain falsification;
mechanism-specific negative controls;
Candidate-A/B non-unification audit;
theoretical-wake elimination;
one-shot survivor absorption.
```

### Unrecorded / blind spots

```text
exact search-engine/database query log: UNRECORDED;
full literature exhaustiveness: NOT CLAIMED;
E-WAKE mechanism search: OPEN BUT NOT ACTIVELY SEARCHED;
second mechanism-distinct Candidate-A survivor: NOT FOUND / NOT ACTIVELY HUNTED AFTER FREEZE;
all possible representation-independent theoretical mechanisms: NOT EXHAUSTED.
```

### Stop / wake rule

Current governance permits only:

```text
E-WAKE:
  new mechanism-distinct source-backed residual;

T-WAKE:
  materially different representation-independent, non-definitional provenance mechanism.
```

The current T-WAKE family is closed; the mother question is not.

### Re-audit verdict

```text
TheoryGate: CLOSED
SearchState: DORMANT / EXTERNALLY WAKEABLE
SearchScopeStatus: EXPLICIT BOUNDED / QUERY LOG INCOMPLETE
SearchExhaustion: NO
SearchSaturation: NOT CLAIMED
SearchSuspensionEntitlement: YES, RELATIVE TO CANDIDATE-SPECIFIC STOP RULES
RealityHypothesis: UNRESOLVED
```

Interpretation:

> Candidate B is eliminated as a research candidate under the audited mechanism family; Candidate A remains one narrowed mechanism-specific survivor; neither verdict establishes the frequency or absence of real-world representation-inadequacy structures outside the audited scope.

## 10. QC — evidence-limited scope, not saturation

### Target

Determine whether any source-backed case forces a non-eliminable responsibility structure beyond ordinary consensus, trust, aggregation, semantic translation, authority, delegation, versioning, revocation/revalidation, and ownership explanations.

### Recorded prior-art / ordinary-neighbor scope

`QC_PREFORMAL_SCOUTING.md` explicitly attacks broad novelty through at least:

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

### Recorded empirical corpus / target scope

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

Source-backed controls actually audited to the current point include:

```text
Stellar 2019 halt;
Mars Climate Orbiter;
Web PKI / Symantec distrust calibration;
RPKI F8 stress / shared-determination gate negative control;
DNSSEC delegation F5 stress / bounded-authority negative-success control.
```

Post-QC3A the active source priority was explicitly changed to:

```text
F8 first;
F5 second;
F7 lower priority.
```

The historical F7-first ordering remains preserved in the corpus.

### Recorded source / selection strategies

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

### Unrecorded / blind spots

```text
exact search-engine/database query log: UNRECORDED;
mechanism-complete domain coverage: NOT ESTABLISHED;
source-inaccessible real incidents: structurally possible and not counted negative;
F2 / F3 / F4 / F6 / F7: no completed source-rich positive/negative audit under the final hardened protocol;
independent multi-strategy saturation study: NOT PERFORMED;
marginal novelty curve / case-count saturation evidence: NOT RECORDED.
```

### Current empirical result

```text
source-backed positive QC residuals: 0
```

This result means only that no current **admitted and audited** case has forced a generic QC object.

### Re-audit verdict

```text
TheoryGate: CLOSED
TrackStatus: EVIDENCE-LIMITED / PRE-FORMAL
SearchState: DORMANT / PASSIVE INTAKE / EXTERNALLY WAKEABLE
SearchScopeStatus: EXPLICIT BUT INCOMPLETE
SearchExhaustion: NO
SearchSaturation: NOT ESTABLISHED
SearchSuspensionEntitlement from saturation: NO
RealityHypothesis: UNRESOLVED
```

The current policy of not collecting cases merely for momentum remains legitimate as a **governance/resource rule**, but it must not be described as evidence that QC search coverage is sufficient or saturated.

A new independently viable source event may still enter the hardened pipeline without contradicting the current freeze.

## 11. Consequences for frozen language

The following language is permitted:

```text
not earned under the current evidence;
rejected at current evidence level;
eliminated as the current candidate formulation;
no positive residual in the audited sample;
dormant / externally wakeable;
evidence-limited;
formalization blocked;
construction frozen by default.
```

The following language is prohibited unless separately proved:

```text
no such real-world structure exists;
all relevant mechanisms were searched;
the search space was exhausted;
search saturation was established;
no future positive case can exist;
the mother question is closed by negative case search.
```

## 12. Future search-state changes

Any future proposal to change a track from:

```text
ACTIVE -> SATURATED
ACTIVE -> DORMANT because search was sufficient
DORMANT -> ACTIVE
EXTERNALLY WAKEABLE -> ACTIVE
```

must update this file with a new `SearchScopeRecord`.

In particular, a future saturation claim must record evidence for all of:

```text
mechanism-family coverage;
source-class coverage;
multiple materially distinct search strategies;
known blind spots;
marginal novelty decline under additional search;
explicit wake conditions.
```

Case count alone is insufficient.

## 13. Final re-audit result

The repository-wide freeze survives this audit, but with a stricter interpretation:

```text
Formal/Paper freeze:
  artifact/scope freeze;

Strict-L6 freeze:
  bounded technical freeze;

QO:
  protocol-relative falsification stop;
  reality unresolved;

QX:
  candidate-relative falsification/absorption stop;
  reality unresolved;

QC:
  theory construction blocked by current evidence;
  search saturation NOT established;
  reality unresolved.
```

The durable governance sentence is:

> **The current repository records entitlement to stop constructing, and in some tracks to suspend a preregistered search cycle, under explicitly bounded evidence. It does not record entitlement to infer that reality contains no further qualifying structure.**
