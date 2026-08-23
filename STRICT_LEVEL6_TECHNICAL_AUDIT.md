# Strict Technical Level-6 Final Audit

Status: final audit for the narrow strict-extension track. This document does not replace or rewrite the earlier restricted Level-6 checkpoint in `LEVEL6_TECHNICAL_AUDIT.md`.

The historical restricted checkpoint remains:

```text
TECHNICAL LEVEL 6: PASS
scope: restricted observational-certificate bridge

responsibility_topology: b95fb82742739395e1e917aa3019199ca470ffad
portable-runtime:       08d42c1d60d40b914b32cccc27e2ea4e7d0e1293
```

The strict extension asked only whether two narrower gaps could be closed:

```text
actual serialized selected runtime transition artifact
    -> Lean-defined B0 projection/checker

source-audited finite domain semantics
    -> explicit interpretation obligations
    -> existing parametric core
```

No other theory or runtime-refinement axis is part of this audit.

---

## 1. Frozen strict evidence stack

The strict evidence stack is:

```text
DomainParametricCore
+
ExplicitDomainInterpretations
+
EndToEndB0RuntimeCorrespondence
```

`EndToEndB0RuntimeCorrespondence` has a deliberately narrow meaning here:

> end-to-end from one actual serialized selected runtime transition artifact to the verified B0 withdrawal contract.

It does **not** mean end-to-end verification of the Python runtime or a general runtime-to-formal transition refinement.

### 1.1 DomainParametricCore

Existing baseline, unchanged by the strict extension:

```text
responsibility_topology PR #72 merge
1fc8d77b31b5ab85f235f327a9e2e4fb2122c0a0
```

The reusable calculi are already parametric:

```text
ImpactDischargeCore
EvaluationLayerCore
```

`ImpactDischargeCore.requirementsCovered_and_soundRealization_imply_discharged`
is generic over arbitrary `D : ImpactDischargeCore` and still requires the explicit external premise:

```text
CoverageRealizationSufficient D
```

That premise is not a field of the core and is not silently supplied by the strict interpretation layer.

`EvaluationLayerCore` still defines no adequacy predicate and still contains countermodels / underdetermination for unconditional local-to-higher inference.

### 1.2 ExplicitDomainInterpretations

Strict Gate B baseline:

```text
responsibility_topology PR #78 merge
0044b6ba1f021dec08b2080c389023fa3913c208

Lean #269:                    PASS
Python-Lean Conformance #210: PASS
```

The new interpretation surface separates:

```text
M_D : source-audited finite domain semantics
I_D : explicit interpretation obligations
C_D : existing parametric core instance
```

For CI-2 the reusable interface is:

```text
ImpactDomainSemantics
ImpactDischargeInterpretation M C
```

with explicit maps for:

```text
subject
change
impact evidence
requirement
response
realization evidence
```

and explicit obligations for:

```text
DomainAffected        -> CoreAffected
DomainRequires        -> CoreRequires
DomainResponseCovers  -> CoreResponseCovers
DomainRealized        -> CoreRealized
CoreDischarged        -> DomainDischarged
```

The last direction is deliberately an interpretation obligation. The generic core theorem cannot manufacture a real-domain discharge conclusion without that obligation.

The generic interpretation theorem:

```text
ImpactDischargeInterpretation.interpreted_core_discharge_reads_back
```

reuses:

```text
ImpactDischargeCore.requirementsCovered_and_soundRealization_imply_discharged
```

rather than rewriting the discharge theorem separately for each case. Its `CoverageRealizationSufficient` premise remains explicit.

For CI-3 the reusable interface is:

```text
EvaluationDomainSemantics
EvaluationInterpretation M C
```

with local-conformance preservation and an explicit higher-verdict reflection obligation. No `Adequate`, `ReopenEntitled`, or Q_open predicate is introduced.

### 1.3 D1-D4 interpretation models

The four already-audited cases are now represented as source-audited finite interpretation models:

```text
M_maintenance
M_institutional-authority
M_measurement
M_software-regression
```

implemented under:

```text
CrossDomain.InterpretedCaseModels
```

Each has an explicit `ImpactDischargeInterpretation` and `EvaluationInterpretation` into its previously existing `CaseModels` core instance.

The carrier maps are identities because the finite interpretation models intentionally reuse the audited carrier types. The responsibility relations are still connected through explicit preservation/reflection obligations rather than by claiming that the external domain itself is the core.

The shared integration theorems are:

```text
d1_d4_affected_interpret_through_one_interface
d1_d4_local_conformance_interpret_through_one_interface
```

They exercise the same generic interpretation lemmas across all four cases.

These are not statements of the form:

```text
FAA |= ResponsibilityDomain
U.S. public law |= ResponsibilityDomain
metrology |= ResponsibilityDomain
portable-runtime |= ResponsibilityDomain
```

No such claim is established.

### 1.4 EndToEndB0RuntimeCorrespondence

Strict Gate A runtime baseline:

```text
portable-runtime PR #12 merge
21fa75e0364b9a67d3596295e005e8052504e694

portable-runtime CI #235: PASS
```

Strict Gate A formal baseline:

```text
responsibility_topology PR #77 merge
c204ac99ad05367cced5f25581f800e4f403353b

Lean #266:                    PASS
Python-Lean Conformance #207: PASS
```

The runtime side creates a versioned raw envelope:

```text
RawWithdrawalTransitionV1
```

whose before/after snapshots are direct:

```text
Assertion.model_dump(mode="json")
```

payloads. The runtime builder checks envelope identity but deliberately does not decide whether the transition is a successful B0 withdrawal.

The committed fixture is generated from an executable selected transition:

```text
same Assertion id
supported, version 7
    ->
revalidation-required, version 8
```

and runtime tests require the committed raw JSON to equal the generated serialization exactly.

The raw artifact contains no Python-derived fields such as:

```text
historicalTraceBefore
historicalTraceAfter
qualificationBefore
qualificationAfter
B0 coordinates
bridge key/value
```

The formal side defines:

```text
rawQualificationB0
alphaB0Lean
checkProjectedB0Withdrawal
checkRawWithdrawal
```

Lean reads selected runtime-native canonical fields from the raw snapshots:

```text
id
record_type
lifecycle_status
epistemic_status
version
```

and computes the B0 historical-trace / qualification observation itself.

The main soundness theorem is:

```text
checkRawWithdrawal_sound
```

with the semantic consequence:

```text
checkRawWithdrawal t = true
->
RawB0WithdrawalHolds t
```

where `RawB0WithdrawalHolds` applies the already-existing B0 withdrawal contract to the Lean-defined projection.

The cross-repository conformance workflow pins the exact portable-runtime merge commit and downloads:

```text
tests/fixtures/o0/raw_withdrawal_transition_v1.json
```

then sends that raw JSON directly through:

```text
Lean JSON parser
-> alphaB0Lean
-> checkRawWithdrawal
-> B0 withdrawal contract
```

The Python O0/B0 semantic adapter and the REF-3 certificate extractor are not in this success path.

---

## 2. Trust boundary after REF-4

The verified boundary has moved left from semantic certificate extraction to raw serialization:

```text
actual selected Python runtime fixture
        |
        | Assertion state transition + model_dump serialization
        | TRUSTED / NOT LEAN-VERIFIED
        v
RawWithdrawalTransitionV1 JSON artifact
        |
        | exact pinned artifact fetched by cross-repo CI
        v
Lean JSON parser
        |
        v
Lean-owned selected-field projection alphaB0Lean
        |
        v
verified checkRawWithdrawal
        |
        v
restricted B0 withdrawal contract
```

The remaining trust boundary includes raw runtime execution/record construction, serialization correctness, artifact transport/I/O fidelity, and the fact that the selected fixture is representative of the path being claimed.

The checker does not verify every field in the full raw `Assertion` snapshot. It reads only the selected canonical fields required by the restricted B0 projection. Extra serialized fields remain outside the checked observation boundary.

Therefore the approved strict claim is:

> The exact pinned serialized selected runtime transition artifact, when parsed and projected by Lean, satisfies the restricted B0 qualification-withdrawal contract when `checkRawWithdrawal` accepts it.

It is not:

```text
Python runtime verified
all Assertion transitions verified
production admission path guarded by Lean
RuntimeStep -> FormalStep*
portable-runtime refines responsibility_topology
```

No production admission/commit gate was added in this strict extension.

---

## 3. Strict gates G1-G7

### G1 — raw artifact checked without trusting Python B0 extraction

**PASS.**

The runtime artifact is a direct before/after serialization of runtime-native `Assertion` records. The formal conformance job consumes that raw JSON directly. No Python B0 observation or qualification certificate is accepted as semantic input to the REF-4 checker.

### G2 — Lean projection/checker proves B0 transition soundness

**PASS.**

Lean owns the selected-field projection and proves:

```text
checkRawWithdrawal t = true
-> RawB0WithdrawalHolds t
```

The B0 semantic target remains the existing `B0QualificationWithdrawalStep` contract.

### G3 — actual executable fixture passes the exact checker path

**PASS.**

portable-runtime CI #235 proves the committed raw fixture equals the artifact generated by the executable selected transition construction. responsibility_topology Conformance #207 fetches that exact artifact from portable-runtime merge `21fa75e...` and passes it through the Lean CLI/checker.

### G4 — impact mismatch remains excluded

**PASS.**

REF-4 certifies only history-retaining qualification withdrawal. It does not add impact projection/refinement.

The frozen mismatch remains:

```text
runtime direct typed dependency impact
!=
formal transitive historical challenge impact
```

and is outside the strict B0 fragment.

### G5 — D1-D4 use an explicit interpretation interface

**PASS.**

All four audited finite source models have explicit interpretation values into the pre-existing cores. No D5 was added.

### G6 — generic theorem reused without domain-specific theorem rewriting

**PASS.**

`interpreted_core_discharge_reads_back` invokes the existing generic `requirementsCovered_and_soundRealization_imply_discharged` theorem and then uses the interpretation's explicit discharge reflection obligation.

The four case models do not receive four rewritten discharge theorems. Their shared affectedness and local-conformance integration results use generic interpretation lemmas.

This does not imply that any pre-discharge case satisfies `CoverageRealizationSufficient`; that premise remains a separate responsibility.

### G7 — external-domain verification / universal invariance remain unclaimed

**PASS.**

The source models remain finite audited interpretation models. Cross-domain strength remains:

```text
FORMAL SIMILARITY
```

not:

```text
MECHANISM SIMILARITY
UNIVERSAL INVARIANT
REAL-DOMAIN VERIFICATION
```

---

## 4. Frozen strict verdict

All seven strict gates pass.

```text
STRICT TECHNICAL LEVEL 6: PASS
```

Scope:

```text
explicit finite-domain interpretation method
+
actual serialized selected runtime transition artifact
-> Lean-computed restricted B0 contract
```

The strict result upgrades two aspects of the earlier restricted checkpoint:

1. the runtime trust boundary no longer relies on Python-side B0 semantic extraction for the selected withdrawal fragment;
2. cross-domain reuse now has an explicit source-semantics-to-core interpretation method rather than only direct finite core constructions.

It does not upgrade cross-domain migration strength beyond `FORMAL SIMILARITY`, and it does not establish full runtime refinement.

---

## 5. Permanent stop boundary

After this audit, strict technical Level 6 is closed.

Do not add technical work merely to strengthen the label further. In particular, the following remain intentionally outside this result:

```text
impact refinement
full Paper 3 runtime mapping
generic runtime repair/discharge lifecycle
production-wide Lean admission gating
universal responsibility invariant
Q_open
Q_close
full Python operational-semantics verification
```

Any future work on those topics must be justified as a new research objective, not as unfinished strict-Level-6 completion.

The technical sequence therefore terminates at:

```text
REF-4
-> XDI-Interpretation
-> Strict-L6 Final Audit
-> STOP
```
