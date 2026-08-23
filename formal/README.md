# Lean 4 Formalization — Current Research Surface

This directory contains the current mechanized Responsibility Topology research program. It is **not** limited to the first-paper `Step` surface.

The recurring formal discipline is separation of responsibilities that are easy to collapse into one another. Papers 1–3 specialize this discipline around history/currentness; Level-6 technical consolidation adds two minimal cross-domain calculi and a restricted observational checker without changing the frozen paper semantics.

## Current status

```text
Papers 1–3:                frozen semantic lines
Cross-domain strength:      FORMAL SIMILARITY
Technical consolidation:    FROZEN PASS
Runtime bridge:             restricted certified observational bridge
Next theory:                Q_open, not yet formalized
```

The technical evidence stack frozen by `LEVEL6_TECHNICAL_AUDIT.md` is:

```text
CrossDomainCore
+
DomainInstances
+
CertifiedRuntimeBridge
```

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

Paper 3 formal semantics remain frozen at PR #48 / merge `190e24e404c864ef8f535f8dbd101c319689e4bc` unless an explicit manuscript trigger is fired.

## Cross-domain consolidation surface

Level-6 does **not** replace the paper kernels with a universal `ResponsibilityDomain` typeclass. It deliberately uses two independent small calculi.

### `CrossDomain/ImpactDischargeCore.lean`

This calculus separates:

```text
impact observation
obligation / discharge requirement
selected response
realization evidence
discharged judgment
```

Its positive composition theorem requires explicit coverage and sound realization premises. Its countermodel demonstrates that the bare calculus does not validate the shortcut:

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

It deliberately does not define “adequacy”. Countermodels and observational underdetermination demonstrate that local conformance does not by itself determine the higher-order verdict.

### `CrossDomain/CaseModels.lean`

Finite audited case-model encodings instantiate the two calculi for:

```text
Maintenance
InstitutionalAuthority
Measurement
SoftwareRegression
```

These are not formalizations of FAA regulation, constitutional/public law, metrology standards, or the Python runtime. They machine-check only that the audited responsibility cut can be represented in the same minimal calculus without importing Paper 1–3 vocabulary.

Therefore the cross-domain claim remains:

```text
FORMAL SIMILARITY
```

not mechanism similarity and not universality.

`CrossDomainAudit.lean` and `Level6Audit.lean` audit this surface.

## Restricted certified observational bridge

### Formal checker

`Bridge/CertifiedObservation.lean` defines the first certified `B0` fragment around history-retaining qualification withdrawal.

The checker proves only the abstract certificate presented to it. Its main consequence is:

```text
checked qualification withdrawal
+
no accepted discharge/requalification evidence
->
certified current-use continuation rejected
```

### Formal-side witness

`Bridge/FormalWithdrawalBridge.lean` proves that an existing challenge transition can realize the same observational pattern at the challenged target when it was previously usable:

```text
historical target referent retained
+
pre-state Usable
+
post-state not Usable
```

This theorem does not identify runtime assertion status with formal `Usable`.

### Trust boundary

The current bridge trust boundary is:

```text
raw runtime state / events
        |
        | ordinary Python execution
        v
O0 adapter + certificate extraction / serialization
        |
        | UNVERIFIED EXTRACTION BOUNDARY
        v
QualificationWithdrawalCertificate
        |
        | VERIFIED CHECKER STARTS HERE
        v
Lean checker
        |
        v
restricted B0 contract
```

Therefore `BridgeAudit.lean` establishes checker/formal facts only. It does not verify Python extraction or the runtime transition system.

## Known bridge mismatch

Runtime direct typed dependency impact and formal transitive historical challenge impact are intentionally not equated:

```text
runtime.directTypedImpact
!=
formal.transitiveHistoricalImpact
```

REF-2 classifies this as `SEMANTIC-MISMATCH`, so impact is excluded from the certified `B0` fragment.

Do not add a generic impact-refinement theorem merely to close this mismatch.

## Current state layers

The paper kernels still contain several related reachability layers rather than one monolithic transition type:

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

The cross-domain and bridge namespaces sit beside these layers; they do not retroactively redefine them.

## Paper 3 theorem hierarchy

### T1 — History-preserving currentness invalidation

A valid challenge preserves canonical historical referents while mutable current responsibility can weaken. `Affected = target ∪ descendants` is the represented warrant-history impact boundary, not a generic runtime dependency rule.

### T2 — Repair selection + realization implies restoration

`RepairSet` is a hitting-set condition over represented unresolved cuts. Restoration additionally requires `RepairRealization`; selection alone is not semantic effectiveness.

### T3 — Inclusion-minimal repair admits private-cut witnesses

`MinimalRepairSet` means inclusion-minimal only. Universal semantic necessity requires the explicit `EveryRepairCutNecessary` adequacy premise and still does not establish extraction completeness.

### T4 — Ordered proof-carrying repair reaches restoration

`reachable_revalidation_lifecycle_restores` threads challenge, refresh, ordered repair trace, and final refresh through `RevalidationReachable`. It is a realizability/reachability result, not a generic runtime lifecycle refinement.

## Historical preservation boundary

Challenge, refresh, and repair transitions have stage-local historical/topology preservation results. The final Paper 3 lifecycle theorem does not syntactically package one end-to-end `HistoryReferentsImmutable S0.core S4.core` conjunct; paper claims should use the stage-local preservation surface compositionally unless a narrow manuscript trigger requires otherwise.

## Current formal non-claims

Current `main` does **not** prove:

- that `portable-runtime` refines this Lean model or vice versa;
- that Python certificate extraction/serialization is verified;
- a total `RuntimeStep -> FormalStep*` simulation;
- runtime/formal impact equivalence;
- automatic or complete `Challenge -> RepairProblem` extraction;
- that every abstract repair set has an executable ordering;
- minimum-cost/cardinality repair or unique repair frontier;
- mechanism similarity or universal invariance across external domains;
- responsibility-vocabulary/regime adequacy (`Q_open`);
- distributed responsibility closure (`Q_close`).

## Q_open handoff

Level-6 technical consolidation is closed. No additional Lean work is currently authorized by that track.

The next theory starts from the narrower question:

```text
What evidence has standing to defeat entitlement to closure
over a bounded scope without already being accepted by
that challenged regime?
```

The next formulation must distinguish at least:

```text
observation/acquisition failure
!= representation/correspondence mismatch
!= implementation/execution nonconformance
!= object/decision/repair failure inside K
!= evidence implicating K itself
```

and must not infer regime inadequacy directly from an `O0` semantic mismatch or a checker rejection.

No `RegimeChallengeCore` or other Q_open calculus exists yet. A Lean phase should begin only after prior-art attack and new-domain falsification earn a minimal formal surface.

## Build and audit

```bash
lake build
lake env lean ResponsibilityTopology/Audit.lean
lake env lean ResponsibilityTopology/Paper3Audit.lean
lake env lean ResponsibilityTopology/CrossDomainAudit.lean
lake env lean ResponsibilityTopology/BridgeAudit.lean
lake env lean ResponsibilityTopology/Level6Audit.lean
```

Repository CI rejects `sorry` / `admit` placeholders in the formal core. A theorem is evidence only for its explicit statement and premises; it is not evidence of external-domain truth, model adequacy, full runtime refinement, or Q_open.