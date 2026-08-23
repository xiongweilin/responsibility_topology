# REF-1 — Observation Algebra `O0` and the First Runtime/Formal Bridge

Status: research/interface specification only.

No refinement theorem is claimed. No Lean or Python semantics are changed by this file.

Runtime baseline inspected:

```text
xiongweilin/portable-runtime
142c6cf41467032f1e5054ad2e7d036f735d4f22
```

Formal repository baseline for this bridge audit:

```text
current research main after XDI-3
```

Paper-specific formal identities remain frozen and are not replaced by this bridge work.

---

# 1. Goal

The purpose of REF-1 is not to prove:

```text
PythonState = LeanState
```

or even:

```text
RuntimeStep -> FormalStep*
```

The first goal is narrower:

> Find a non-trivial observation algebra into which both systems can project without silently erasing their known semantic mismatches.

The working shape is therefore:

```text
Runtime observation bundle
        | alpha_R0
        v
       O0
        ^
        | alpha_F0
Formal observation bundle
```

A future observational correspondence could compare:

```text
alpha_R0(rObs)
~
alpha_F0(fObs)
```

for a deliberately chosen equivalence `~`.

No such theorem is attempted in REF-1.

---

# 2. XDI constraints carried into the bridge

The cross-domain falsification stage changes the bridge vocabulary before any mapping is written.

## 2.1 Do not assume persistent operative identity

XDI rejected the unqualified candidate:

```text
persistent relation != current responsibility
```

because historical trace/record persistence and operative-relation persistence diverged in the physical and legal domains.

Therefore `O0` must separate:

```text
historicalTrace
operativeStatus
```

and must not infer the second from the first.

## 2.2 Keep impact separate from discharge

Candidate invariant CI-2 survived:

```text
Affectedness does not by itself constitute sufficient discharge.
```

Therefore `O0` must keep at least two coordinates:

```text
impactObservation
dischargeRequirement / dischargeEvidence
```

A runtime `required_action` cannot be collapsed into an impact fact. A formal `RepairSet` cannot be collapsed into an affectedness relation.

## 2.3 Keep higher-order adequacy outside `O0`

Candidate invariant CI-3 survived only in the form:

```text
local conformance
!=
higher-order adequacy / validity / fitness
```

The current Lean kernel does not formalize higher-order regime adequacy. The runtime carries policy/environment/version metadata but does not thereby solve adequacy either.

Therefore `O0` may preserve **regime references**, but it must not contain a Boolean:

```text
modelAdequate : Bool
```

or anything semantically equivalent.

---

# 3. A state-only projection is rejected

The initially tempting signature was:

```text
alpha_0 : RuntimeState -> FormalObservation_0
```

REF-1 rejects this exact signature as underspecified for the current systems.

## 3.1 Runtime reason: current authorization depends on observation time

`portable-runtime` authorization includes:

```text
valid_from
expires_at
revoked_at
```

and `is_authorized_for` / `validate_grant` evaluate a grant relative to an explicit or current timestamp.

The runtime also materializes immutable `AuthorizationUse` evidence at a historical `authorized_at` time so later grant expiry/revocation does not rewrite the historical action.

Therefore a runtime current-authorization observation is not a pure function of timeless serialized grant fields unless the observation time is supplied or captured in the snapshot.

## 3.2 Formal reason: some responsibility evidence is transition/trace witness, not state field

The formal challenge state stores consequences such as:

```text
suspended/pending evaluation positions
reviewRequired license flags
```

but the exact challenge event/target that generated those consequences is a transition witness, not a persistent generic `lastChallenge` field in `CanonicalState`.

Likewise a `RepairProblem`, `RepairSet`, `RepairRealization`, and `RevalidationTrace` are proof/problem objects around state, not all reconstructible from the final `AdoptState` alone.

Therefore a formal observation of impact or discharge evidence may require trace/problem context beyond a raw state.

## 3.3 Revised input types

REF-1 therefore uses conceptual bundles:

```text
RuntimeObservationBundle0 :=
  runtime state/snapshot
  + observedAt
  + relevant durable records/relations
  + optional AffectedAssessment/ReopenAssessment views

FormalObservationBundle0 :=
  formal state
  + optional event/trace witnesses
  + optional RepairProblem/RepairRealization context
```

The exact executable serialization of these bundles is future work.

The projection signatures are:

```text
alpha_R0 : RuntimeObservationBundle0 -> O0
alpha_F0 : FormalObservationBundle0  -> O0
```

---

# 4. Common observation algebra `O0`

`O0` is deliberately an **observation algebra**, not a new ontology claiming that both systems have identical internal objects.

A conceptual `O0` contains the following finite observation families.

```text
O0 = {
  observedAt,
  historicalTrace,
  historicalDependency,
  operativeStatus,
  activationUse,
  impactObservation,
  reviewInvalidation,
  dischargeRequirement,
  dischargeEvidence,
  regimeReference,
  mismatchAnnotations
}
```

Every observation carries an origin/semantics tag. Two facts with the same external shape are not automatically semantically equal.

Suggested common metadata:

```text
origin       : runtime | formal
semanticsTag : String
sourceRefs   : finite refs
coordinates  : finite key/value metadata
```

---

## 4.1 `historicalTrace`

Purpose:

> Expose a prior object/event/relationship without asserting that its operative force persists.

Conceptual shape:

```text
HistoricalTraceFact := {
  subjectRef,
  traceKind,
  versionRef?,
  historicalTime?,
  sourceRefs
}
```

Examples:

```text
runtime:
  record existed
  revision old -> new
  old object superseded but retained
  authorization use occurred at authorized_at

formal:
  HistoricalWarrant exists
  warrant constructor/formation coordinates
  canonical Adopt-license record exists
  activationProvenance records bootstrap/adopt history
```

Non-claim:

```text
historicalTrace fact
-/->
operativeStatus = current
```

---

## 4.2 `historicalDependency`

Purpose:

> Preserve typed dependency observations without pretending the relation vocabularies are identical.

Conceptual shape:

```text
DependencyFact := {
  subjectRef,
  relationTag,
  objectRef,
  occurrence?,
  scope?,
  semanticsTag
}
```

Runtime candidates come from exact `RecordRelation` types such as:

```text
derived-from
depends-on
validated-under
measured-by
authorized-under
executed-with
evaluated-by
scoped-to
supports
revises
supersedes
```

Formal candidates include:

```text
HistoricalWarrant.parents
role-indexed lineage
TRANSPORT original/witness parent identity
Adopt-license support list
activation issuer -> target edge
```

Important mismatch:

```text
runtime RecordRelation set
!=
formal parent/lineage/license-support vocabulary
```

`alpha_R0` and `alpha_F0` preserve the original relation tag rather than mapping every dependency to one generic edge and declaring equivalence.

---

## 4.3 `operativeStatus`

Purpose:

> Expose present qualification/currentness without erasing layer distinctions.

Conceptual shape:

```text
OperativeStatusFact := {
  subjectRef,
  layer,
  coordinate,
  status,
  observedAt?,
  semanticsTag
}
```

Possible runtime layers include:

```text
record lifecycle_status
Assertion/Observation epistemic_status
authorization grant currently valid/invalid at observedAt
revalidation-required state
policy disposition relevant to next use
```

Formal layers include:

```text
warrant Usable
license BaseCurrent
context Grounded
activeContext
reviewRequired
```

This is a tagged union. REF-1 does not identify:

```text
runtime lifecycle=current
=
formal Usable
```

or:

```text
runtime grant valid
=
formal BaseCurrent
```

Those would require a narrower correspondence argument.

---

## 4.4 `activationUse`

Purpose:

> Record concrete use/activation evidence where either system has it.

Runtime observations:

```text
AuthorizationUse
ActionRecord
OutcomeRecord
```

`AuthorizationUse` is especially important because it is an immutable at-time authorization proof for one exact request even if the grant later expires/revokes.

Formal observations:

```text
activeContext(key)
activationProvenance(key)
bootstrap/adopt activation edge
```

### Major mismatch

The runtime has no direct generic equivalent of formal context `Grounded` activation topology.

The formal kernel has no direct generic equivalent of runtime Work/Run/Action execution machinery.

Therefore `activationUse` is expected to be **partial on both sides**.

A missing counterpart must be marked `notRepresented`, not synthesized through analogy.

---

## 4.5 `impactObservation`

Purpose:

> Expose what is considered affected by a change/challenge while retaining propagation semantics.

Runtime:

```text
DependencyImpact {
  change_ref,
  affected_ref,
  relation_type,
  reason_refs
}
```

Runtime detection is intentionally:

```text
direct typed relation matching
no recursive full-graph invalidation
```

Formal:

```text
Affected(S, target, warrant)
ChallengeEvalAffected
ChallengeLicenseImpacted
```

The formal challenge line uses historical warrant-descendant closure and then propagates to evaluation/license observations.

### Required semantics tags

Use distinct tags such as:

```text
runtime.direct-typed-impact
formal.transitive-historical-challenge-impact
```

### Hard prohibition

Do not write:

```text
DependencyImpact_runtime
=
Affected_formal
```

The current bridge has evidence of conceptual adjacency and evidence of semantic mismatch, not equality.

---

## 4.6 `reviewInvalidation`

Purpose:

> Expose current loss/review state after an impact has been recognized.

Runtime candidates:

```text
AffectedAssessment.revalidation_disposition
epistemic_status = revalidation-required
requires-revalidation relation
ReopenAssessment
```

Formal candidates:

```text
epi LIVE -> SUSPENDED
placement PLACED -> PENDING
reviewRequired(licenseId)
active-context removal after refresh
```

Again this is a family of typed facts, not one Boolean invalid flag.

---

## 4.7 `dischargeRequirement`

Purpose:

> Preserve what a system says must/should be done after invalidation without claiming the action has occurred or succeeded.

Runtime:

```text
RevalidationDisposition.action
policy_ref
ReopenAssessment.revision_scope
```

Examples of runtime action labels:

```text
warn
background-revalidate
block-next-use
require-human-review
reopen
```

Formal:

```text
RepairProblem edges
RepairAction alternatives
RepairSet selection
```

### Major mismatch

Runtime disposition is policy-derived from a direct impact under a named policy profile.

Formal `RepairProblem` is an externally supplied state-indexed hypergraph with explicit stale obligations and alternatives; Paper 3 does not prove complete automatic extraction from challenge.

Therefore:

```text
runtime required_action
!=
formal RepairAction
```

without an explicit translation contract.

---

## 4.8 `dischargeEvidence`

Purpose:

> Keep execution/effectiveness evidence separate from prescribed discharge.

Runtime possible evidence includes:

```text
Revision lifecycle applied/verified/accepted
ActionRecord / OutcomeRecord
new records/relations after a workflow
explicit reopen Work/handoff
```

But the inspected runtime has no single generic standalone operation corresponding to the formal Paper 3 `revalidate` lifecycle.

Formal evidence can include:

```text
RepairRealization
RepairActionStep
RevalidationTrace
final target Holds after refresh
```

### Consequence

REF-1 must allow:

```text
dischargeRequirement present
+
dischargeEvidence absent/unknown
```

This is CI-2 applied to the bridge itself.

---

## 4.9 `regimeReference`

Purpose:

> Preserve which policy/profile/environment/version supplied the local judgment without pretending that the regime is adequate.

Runtime candidates:

```text
environment_versions
policy_ref
subject_version_refs
evaluator/model/code/dataset/permission/classification/state_space/environment change type
ProcedureProfile or other explicit policy identifiers where present
```

Formal candidates:

```text
profileDigest
contextId
use
binding identity
rule/map identifiers
```

Non-claim:

```text
regimeReference present
-/->
regime adequate
```

This is the bridge-level firewall for CI-3 and Q_open.

---

# 5. Runtime projection `alpha_R0`

The runtime projection should be mechanical and provenance-preserving.

A conceptual implementation is:

```text
alpha_R0(bundle):
  capture bundle.observedAt

  for every canonical BaseRecord:
    emit HistoricalTraceFact(id, record_type, version, created_at)
    emit tagged lifecycle/epistemic OperativeStatusFacts
    preserve environment_versions as regime references

  for every RecordRelation:
    emit exact typed DependencyFact

  for every RevisionRecord / supersedes relation:
    emit revision/supersession trace

  for every AuthorizationUse:
    emit historical at-time activation/use fact

  for every AuthorizationGrant relevant to the observation:
    evaluate current validity at observedAt
    emit tagged authorization operative-status fact

  for every DependencyImpact / AffectedAssessment supplied in bundle:
    emit direct-typed ImpactObservation
    emit RiskAssessment separately if retained
    emit RevalidationDisposition as DischargeRequirement, not as impact

  for every ReopenAssessment supplied in bundle:
    emit review/reopen observation and revision-scope discharge requirement

  for every durable execution/revision record:
    emit only the discharge evidence actually represented
```

## Runtime projection non-claims

`alpha_R0` must not infer:

```text
recursive affected closure
formal Groundedness
formal RepairSet
formal RepairRealization
model adequacy
```

from runtime data merely because analogous words exist.

---

# 6. Formal projection `alpha_F0`

A conceptual projection from formal observation bundles is:

```text
alpha_F0(bundle):
  for every canonical historical warrant supplied by finite observation boundary:
    emit HistoricalTraceFact
    emit exact ordered parent DependencyFacts
    emit selected lineage facts with exact role tags

  for every enriched Adopt-license observation:
    emit license historical trace
    emit exact support DependencyFacts

  for selected EvalKeys:
    emit Usable operative-status facts

  for selected license IDs:
    emit BaseCurrent operative-status facts
    emit reviewRequired status

  for selected ContextKeys:
    emit activeContext and Grounded operative-status facts
    emit activation provenance/use facts

  when a ChallengeEvent/target witness is supplied:
    emit formal transitive-historical impact facts
    emit suspension/pending/review consequences

  when a RepairProblem is supplied:
    emit discharge requirements/cuts without claiming extraction completeness

  when RepairRealization/RevalidationTrace evidence is supplied:
    emit discharge evidence with exact theorem/witness references

  preserve profile/context/use/rule/map identifiers as regime references
```

## Finite-observation requirement

The Lean state uses functional maps over IDs and propositions rather than an intrinsically finite serialized database. `alpha_F0` therefore requires an explicit finite observation boundary/list of keys.

This is not a weakness to hide. It is part of the abstraction contract.

---

# 7. Mapping table

| `O0` coordinate | `portable-runtime` source | Lean/formal analogue | Mapping quality | Information loss / mismatch |
| --- | --- | --- | --- | --- |
| historicalTrace | `BaseRecord`, `RevisionRecord`, retained superseded records, `AuthorizationUse` | `HistoricalWarrant`, canonical Adopt license, activation provenance | partial/formal similarity | runtime records are not warrants; formal history has stronger constructor discipline |
| historicalDependency | `RecordRelation` exact typed edges | warrant parents/lineage, license support, activation issuer edge | partial/formal similarity | relation vocabularies and occurrence semantics differ |
| operativeStatus | lifecycle/epistemic status, grant validity at `observedAt` | `Usable`, `BaseCurrent`, `Grounded`, `activeContext`, `reviewRequired` | partial | no one-to-one status algebra; runtime clock dependence vs formal state indexing |
| activationUse | `AuthorizationUse`, Action/Outcome | activeContext + activationProvenance | weak/partial | runtime execution semantics != formal context activation topology |
| impactObservation | direct `DependencyImpact` | transitive `Affected` / challenge impact | semantic conflict unless tagged | direct typed matching vs historical transitive closure |
| reviewInvalidation | revalidation-required/disposition/reopen views | suspended/pending/reviewRequired/refresh loss | partial | different update and propagation semantics |
| dischargeRequirement | `RevalidationDisposition`, `revision_scope` | `RepairProblem`, `RepairAction`, `RepairSet` | weak/partial | policy prescription != repair hypergraph; no extraction theorem |
| dischargeEvidence | Revision/Action/Outcome/handoff evidence | `RepairRealization`, `RepairActionStep`, `RevalidationTrace` | weak | runtime lacks one generic Paper-3-style revalidate lifecycle |
| regimeReference | environment/policy/version refs | profile/context/use/binding/rule/map IDs | partial | different authority/meaning; adequacy absent on both sides |

This table is the core REF-1 result.

---

# 8. Explicit semantic mismatches

REF-1 identifies at least eight mismatches that must survive into any future refinement proposal.

## M1 — historical object vocabulary

```text
runtime BaseRecord / RecordRelation graph
!=
formal HistoricalWarrant / canonical license topology
```

There is no total natural map from every runtime record type to a formal warrant.

## M2 — relation occurrence semantics

Formal warrant parents are ordered and duplicate-preserving at formation. Runtime `RecordRelation` is an edge-object collection and does not by itself encode the same ordered occurrence semantics.

## M3 — currentness index

Formal Paper 1–3 currentness is state-indexed.

Runtime authorization validity is partly time-indexed through `valid_from`, `expires_at`, `revoked_at`, while durable `AuthorizationUse` intentionally freezes at-time evidence.

Therefore observed time must be explicit in the bridge input.

## M4 — impact propagation

```text
runtime: direct typed dependency matching
formal: transitive historical warrant-descendant challenge closure
```

This is a genuine semantic difference, not an implementation detail.

## M5 — impact vs policy

Runtime explicitly separates:

```text
DependencyImpact
RiskAssessment
RevalidationDisposition
```

The formal Paper 3 challenge semantics does not use the same three-layer policy pipeline.

## M6 — repair extraction

Formal Paper 3 accepts a finite `RepairProblem` with explicit stale dependencies and edges. It does not prove a complete `Challenge -> RepairProblem` extractor.

Runtime computes direct impacts and policy dispositions, but this is not equivalent to formal repair-graph extraction.

## M7 — activation topology

Formal `Grounded` is a bootstrap-rooted recursive activation relation.

The runtime inspected here has durable authorization/action evidence but no identical generic context-grounding relation.

## M8 — reopen depth

Runtime `ReopenAssessment` explicitly includes deep scopes such as:

```text
representation
goal
problem-definition
```

and deep reopen routes to reframing rather than auto-rerunning original work.

The current formal kernel has no theorem that judges when its own vocabulary/problem definition should be reopened.

This mismatch points toward Q_open rather than toward a missing ordinary refinement lemma.

---

# 9. Information-loss classification

Each bridge coordinate should be classified by one of:

```text
EXACT-SHAPE
  same external observation shape and semantics under explicit key mapping

ABSTRACTION
  source has strictly more detail but retained observation has defensible meaning

PARTIAL
  only some source objects have counterparts

SEMANTIC-MISMATCH
  superficially similar observations have materially different meaning

NOT-REPRESENTED
  no counterpart currently exists
```

REF-1 initial classification:

```text
historicalTrace       PARTIAL / ABSTRACTION
historicalDependency  PARTIAL / ABSTRACTION
operativeStatus       PARTIAL
activationUse         PARTIAL / NOT-REPRESENTED in subregions
impactObservation     SEMANTIC-MISMATCH unless propagation tag retained
reviewInvalidation    PARTIAL
 dischargeRequirement PARTIAL / SEMANTIC-MISMATCH at policy-vs-repair boundary
 dischargeEvidence    PARTIAL / NOT-REPRESENTED for generic runtime revalidation
regimeReference       PARTIAL / ABSTRACTION
```

There is currently no broad coordinate classified as unconditionally `EXACT-SHAPE` across both systems.

This is a reason **not** to start transition refinement yet.

---

# 10. First common boundary that does survive

Despite the mismatches, REF-1 finds a non-trivial shared observation boundary:

```text
1. prior/historical trace can be observed separately from present operative status;
2. typed dependency observations can be retained without collapsing relation vocabulary;
3. current qualification/status must remain layer-tagged;
4. invalidation/review observations can be represented without rewriting historical trace;
5. impact observations and required discharge must remain separate;
6. required discharge and evidence of successful discharge must remain separate;
7. every local judgment can carry the regime/version/policy coordinates under which it was made.
```

This boundary is weaker than either implementation's full semantics, but it is not trivial.

It is also directly informed by the cross-domain falsification results rather than copied from Lean constructors.

---

# 11. Proposed observational correspondence shape

A future first correspondence should be about a **small fixture family**, not all states.

Candidate shape:

```text
Given:
  explicit runtime fixture R
  explicit formal fixture F
  explicit ID/key correspondence mu
  explicit observation time t
  explicit finite observation boundary B

compare:
  normalize_mu(alpha_R0(R,t,B))
  normalize_mu(alpha_F0(F,B))
```

The comparison should be coordinate-specific.

For example:

```text
historicalTrace correspondence
qualification-status correspondence
review-state correspondence
```

may be attempted independently.

The impact coordinate must not be compared until a deliberate translation between:

```text
runtime direct typed impact
formal transitive challenge closure
```

is specified.

---

# 12. No transition refinement yet

Do not open a theorem of the form:

```text
RuntimeStep(r,r')
->
FormalStep*(alpha(r), alpha(r'))
```

until all of the following hold:

1. `alpha_R0` and `alpha_F0` can be implemented for finite fixtures without large ad hoc case distinctions;
2. observation time has an explicit semantics;
3. impact-propagation translation is either restricted to an agreed fragment or explicitly excluded;
4. runtime disposition is not confused with formal repair execution;
5. runtime deep reopen is excluded from the formal correspondence or separately modeled;
6. ID/key correspondence is explicit rather than inferred from string resemblance;
7. information loss for each coordinate is mechanically visible in the fixture output.

If these conditions cannot be met, the correct verdict is:

```text
no useful refinement boundary at this abstraction
```

rather than a larger simulation relation patched by exceptions.

---

# 13. Suggested REF-2, if REF-1 is accepted

The next bridge task should still not be a theorem.

It should be a **finite observational fixture adapter** producing a neutral serialized `O0` snapshot from each repository.

Minimal fixtures should test:

```text
F1 historical trace retained while operative status changes
F2 typed dependency retained
F3 current qualification layer distinction
F4 invalidation/review without historical rewrite
F5 impact observation separated from disposition
F6 discharge requirement separated from discharge evidence
```

A fixture should fail visibly when a coordinate is `NOT-REPRESENTED` or `SEMANTIC-MISMATCH`.

Only after that should observational/refinement theorem design be reconsidered.

---

# 14. Relationship to Q_open

REF-1 exposes a bridge boundary that should not be repaired by adding more mapping code.

Both systems can record:

```text
which regime/version/policy was used
what changed
what became non-current
what action/review is indicated
```

Neither current bridge establishes:

```text
that the regime vocabulary itself is adequate
or
that a failure provides entitlement to replace that vocabulary
```

Runtime deep reopen is an operational representation of a chosen revision scope, not a proof that the scope judgment is correct.

Formal Paper 3 repair adequacy is premise-explicit inside a supplied repair ontology, not a theorem that the ontology should be reopened.

Therefore the next theory problem remains Q_open rather than “finish alpha by adding an adequacy flag.”

---

# REF-1 decision

```text
state-only alpha_0 signature: REJECTED AS UNDERSPECIFIED

common observation algebra O0: FOUND, NON-TRIVIAL BUT PARTIAL

alpha_R0: SPECIFIED CONCEPTUALLY
alpha_F0: SPECIFIED CONCEPTUALLY

exact runtime/formal state equality: REJECTED
transition refinement theorem: NOT STARTED
impact semantic equality: REJECTED
higher-order adequacy in O0: EXCLUDED

next bridge step if desired:
  finite O0 fixture adapters before any refinement theorem

formal reopen: NO
```