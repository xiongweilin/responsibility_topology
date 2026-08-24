# Lean 4 Formalization — Frozen Research Surface

This directory contains the mechanized Responsibility Topology research program. Papers 1–3 and the Strict Technical Level-6 consolidation are frozen. `RESEARCH_STATE.md` is authoritative for current research governance; this file summarizes the formal surface only.

The recurring formal discipline is separation of responsibility positions that are easy to collapse into one another. Papers 1–3 specialize that discipline around history/currentness. The post-paper consolidation adds two minimal cross-domain calculi, explicit finite-domain interpretations, and a restricted raw-runtime observational checker without changing the frozen paper semantics.

## Current status

```text
Papers 1–3:                FROZEN
Cross-domain strength:      FORMAL SIMILARITY
Strict Technical L6:        PASS / FROZEN
Runtime bridge:             raw selected transition -> Lean-owned restricted B0 projection/checker
QX:                         DORMANT / OPEN / PRE-FORMAL
QC:                         EVIDENCE-LIMITED / PRE-FORMAL
QX Lean:                    NO
QC Lean:                    NO
```

There is no default next formal theory step. QX and QC are independent evidence-gated research tracks and neither is authorized for Lean formalization at present.

The frozen Strict-L6 evidence stack is:

```text
DomainParametricCore
+
ExplicitDomainInterpretations
+
EndToEndB0RuntimeCorrespondence
```

Here `EndToEndB0RuntimeCorrespondence` is deliberately narrow: one actual serialized selected runtime transition artifact is parsed by Lean, projected by Lean into restricted B0, and checked against the restricted B0 withdrawal contract. It is not a general runtime refinement theorem.

For the authoritative technical boundary, read repository-root `STRICT_LEVEL6_TECHNICAL_AUDIT.md`.

## Paper-scale layers

### Paper 1 — Object / identity

Core distinction:

```text
historical formation / parent identity
!=
current evaluation qualification
```

Principal modules include:

- `Reachability.lean`
- `RootFormation.lean`
- `EvaluationQualification.lean`
- `InferFormation.lean`
- `InferQualification.lean`
- static entitlement / canonical-read modules

The first-paper artifact remains separately frozen in repository-root `ARTIFACT.md`.

### Paper 2 — Environment

Core distinction:

```text
cross-context historical transport
!=
source-indexed current qualification
!=
current Adopt/license/context responsibility
```

Principal modules include:

- `TransportSemantics.lean`
- TRANSPORT formation/qualification and composition modules
- `AdoptLicenseCurrentness.lean`
- `AdoptReachability.lean`
- `AdoptActivation.lean`
- `AdoptGroundedness.lean`
- `ContextCurrentness.lean`

The Paper 2 formal boundary does not establish arbitrary interoperability, arbitrary temporal persistence, or runtime refinement.

### Paper 3 — Change

Core distinctions:

```text
canonical historical continuity
!=
currentness continuity
```

and:

```text
impact detection
!= repair selection
!= repair realization
!= represented-cut necessity
!= extraction completeness
!= ordered execution
```

Principal modules:

- `ChallengeImpact.lean`
- `ChallengeInvalidation.lean`
- `ChallengeInvalidationInvariant.lean`
- `ActivationRefresh.lean`
- `RepairSemantics.lean`
- `RepairSufficiency.lean`
- `RepairMinimality.lean`
- `RevalidationLifecycle.lean`
- `Paper3Audit.lean`

Paper 3 formal semantics remain frozen at PR #48 / merge `190e24e404c864ef8f535f8dbd101c319689e4bc` unless a future independently earned research objective explicitly authorizes a new formal line. Later research does not retroactively modify the Paper 3 semantic baseline.

## Cross-domain consolidation surface

Strict-L6 does **not** replace the paper kernels with a universal `ResponsibilityDomain` typeclass. It deliberately uses two independent small calculi plus an explicit interpretation layer.

### `CrossDomain/ImpactDischargeCore.lean`

This calculus separates:

```text
impact observation
obligation / discharge requirement
selected response
realization evidence
discharged judgment
```

Its positive composition theorem requires explicit coverage and sound-realization sufficiency. Its countermodel demonstrates that the bare calculus does not validate the shortcut:

```text
Affected -> Discharged
```

### `CrossDomain/EvaluationLayerCore.lean`

This calculus separates:

```text
LocalConformance evidence
HigherAccepted judgment
Purpose
HigherInput
```

It deliberately defines no adequacy predicate. Countermodels and observational underdetermination demonstrate that local conformance does not by itself determine the higher-order verdict.

### `CrossDomain/Interpretation.lean`

The strict interpretation surface separates:

```text
M_D : source-audited finite domain semantics
I_D : explicit interpretation obligations
C_D : existing parametric core instance
```

For impact/discharge, the interpretation carries explicit preservation obligations for affectedness, requirements, coverage, and realization, plus an explicit discharge read-back obligation. The generic core theorem does not manufacture real-domain discharge and still requires the external `CoverageRealizationSufficient` premise.

For evaluation, local conformance is preserved into the core and any positive higher-order core verdict can be read back only through an explicit reflection obligation. No `Adequate`, `ReopenEntitled`, QX, or QO predicate is introduced.

### `CrossDomain/InterpretedCaseModels.lean`

Four already-audited finite case models are interpreted through the same interfaces:

```text
Maintenance
InstitutionalAuthority
Measurement
SoftwareRegression
```

These are finite source-audited interpretation models, not formalizations or verification of FAA regulation, U.S. public law, metrology institutions, or the `portable-runtime` implementation. Their shared integration theorems establish reuse of one interpretation method across the selected finite models.

Therefore the strongest approved cross-domain claim remains:

```text
FORMAL SIMILARITY
```

not mechanism similarity, external-domain verification, or universal invariance.

`CrossDomainAudit.lean`, `Level6Audit.lean`, and `StrictLevel6Audit.lean` audit this surface.

## Frozen restricted observational bridge

### Historical REF-3 checkpoint

`Bridge/CertifiedObservation.lean` and `Bridge/FormalWithdrawalBridge.lean` established the earlier restricted B0 certificate/checker line around history-retaining qualification withdrawal. That checkpoint remains part of the provenance but is no longer the leftmost verified boundary of the strict bridge.

### Strict REF-4 raw-runtime checker

`Bridge/RawRuntimeWithdrawal.lean` moves the checked boundary left from a Python-derived semantic certificate to selected raw runtime record fields.

The strict path is:

```text
actual selected Python runtime transition
        |
        | Assertion construction + model_dump serialization
        | TRUSTED / NOT LEAN-VERIFIED
        v
RawWithdrawalTransitionV1 JSON artifact
        |
        | exact pinned artifact transferred by cross-repo CI
        v
Lean JSON parser
        |
        v
Lean-owned alphaB0Lean projection
        |
        v
checkRawWithdrawal
        |
        v
restricted B0 withdrawal contract
```

Lean reads selected runtime-native fields:

```text
id
record_type
lifecycle_status
epistemic_status
version
```

and computes the restricted B0 historical-trace/current-qualification observation itself. The raw success path does not trust Python-side B0 coordinates or the earlier REF-3 certificate extractor.

The principal strict theorem is:

```text
checkRawWithdrawal t = true
->
RawB0WithdrawalHolds t
```

where `RawB0WithdrawalHolds` applies the existing B0 qualification-withdrawal contract to the Lean-defined projection.

The remaining trust boundary includes runtime execution/record construction, serialization correctness, artifact transport/I/O fidelity, and representativeness of the selected transition path. The checker observes only the selected canonical fields needed by B0; it does not verify every field in the full `Assertion` snapshot.

Therefore the approved strict claim is narrow:

> The exact pinned serialized selected runtime transition artifact, when parsed and projected by Lean, satisfies the restricted B0 qualification-withdrawal contract when `checkRawWithdrawal` accepts it.

It is not a theorem that the Python runtime is verified or that every runtime transition refines the formal transition system.

## Known bridge mismatch

Runtime direct typed dependency impact and formal transitive historical challenge impact remain intentionally distinct:

```text
runtime.directTypedImpact
!=
formal.transitiveHistoricalImpact
```

Impact remains outside restricted B0. Strict-L6 did not normalize or erase this semantic mismatch.

Do not infer a generic impact-refinement theorem from the qualification-withdrawal bridge.

## Current state layers

The paper kernels retain several related reachability layers rather than one monolithic transition type:

```text
CanonicalState / Step / Reachable
        |
        +-- ROOT / INFER / TRANSPORT
        |
AdoptState / AdoptReachable / AdoptActivationReachable
        |
        +-- enriched Adopt license records
        +-- BaseCurrent
        +-- Adopt activation
        +-- Grounded
        |
ChallengeReachable / RefreshReachable
        |
        +-- challenge invalidation
        +-- fixed-point refresh
        |
RevalidationReachable
        |
        +-- proof-carrying RepairActionStep
        +-- ordered RevalidationTrace
```

The cross-domain and bridge namespaces sit beside these frozen layers; they do not retroactively redefine them.

## Paper 3 theorem hierarchy

### T1 — History-preserving currentness invalidation

A valid challenge preserves canonical historical referents while mutable current responsibility can weaken. `Affected = target ∪ descendants` is the represented warrant-history impact boundary, not a generic runtime dependency rule.

### T2 — Repair selection + realization implies restoration

`RepairSet` is a hitting-set condition over represented unresolved cuts. Restoration additionally requires `RepairRealization`; selection alone is not semantic effectiveness.

### T3 — Inclusion-minimal repair admits private-cut witnesses

`MinimalRepairSet` means inclusion-minimal only. Universal semantic necessity requires the explicit `EveryRepairCutNecessary` premise and still does not establish extraction completeness.

### T4 — Ordered proof-carrying repair reaches restoration

`reachable_revalidation_lifecycle_restores` threads challenge, refresh, ordered repair trace, and final refresh through `RevalidationReachable`. It is a realizability/reachability result, not a generic runtime lifecycle refinement.

## Historical preservation boundary

Challenge, refresh, and repair transitions have stage-local historical/topology preservation results. The final Paper 3 lifecycle theorem does not syntactically package one end-to-end `HistoryReferentsImmutable S0.core S4.core` conjunct; paper claims should use the stage-local preservation surface compositionally.

## Current formal non-claims

Current `main` does **not** prove:

- that `portable-runtime` refines this Lean model or vice versa;
- that Python runtime execution, record construction, or serialization is verified;
- a total `RuntimeStep -> FormalStep*` simulation;
- runtime/formal impact equivalence;
- production-wide Lean admission gating;
- automatic or complete `Challenge -> RepairProblem` extraction;
- that every abstract repair set has an executable ordering;
- minimum-cost/cardinality repair or a unique repair frontier;
- mechanism similarity or universal invariance across external domains;
- a generic representation-inadequacy certificate (QX);
- a generic provisional-shared-determination/reliance object (QC);
- QX or QC Lean formalization.

A Lean theorem is evidence only for its explicit statement and premises. It is not evidence of external-domain truth, model adequacy, full runtime refinement, QX, or QC.

## Post-freeze research governance

Strict-L6 is closed. No additional bridge fragment, runtime-refinement theorem, or cross-domain universal claim is owed to complete that milestone.

Current research status is governed by repository-root `RESEARCH_STATE.md`:

```text
QO: archived negative control
QX: dormant / open / pre-formal
QC: evidence-limited / pre-formal
```

QX and QC formalization remain closed unless the relevant evidence gates are independently satisfied. A clean predicate, constructor, theorem statement, or additional example is not sufficient reason to reopen Lean work.

## Build and audit

```bash
lake build
lake env lean ResponsibilityTopology/Audit.lean
lake env lean ResponsibilityTopology/Paper3Audit.lean
lake env lean ResponsibilityTopology/CrossDomainAudit.lean
lake env lean ResponsibilityTopology/BridgeAudit.lean
lake env lean ResponsibilityTopology/Level6Audit.lean
lake env lean ResponsibilityTopology/StrictLevel6Audit.lean
```

Repository CI rejects `sorry` / `admit` placeholders in the formal core.
