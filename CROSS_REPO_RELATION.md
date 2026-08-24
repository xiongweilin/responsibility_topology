# Cross-Repository Relation Contract

This document defines the current relationship between:

- `xiongweilin/responsibility_topology` — Lean-centered formal kernels, cross-domain calculi, explicit interpretation obligations, theorem surfaces, and the frozen restricted observational checker;
- `xiongweilin/portable-runtime` — Framework V1.0 documentation, record semantics, operational/runtime mechanisms, revision/revalidation/reopen workflows, and engineering implementation.

`RESEARCH_STATE.md` is authoritative for current research governance. `STRICT_LEVEL6_TECHNICAL_AUDIT.md` is authoritative for the frozen strict technical bridge boundary.

The relation is intentionally **not** implementation equality and **not** verified whole-runtime refinement.

## 1. Vocabulary and ownership

The contract reuses the Framework V1.0 call relations:

| Relation | Meaning here |
| --- | --- |
| `reference` | use an upstream concept without changing its meaning |
| `boundary-reference` | import only a responsibility boundary or handoff condition |
| `specialize` | make an upstream concept precise for a narrower formal object model |
| `operationalize` | turn a theoretical responsibility into a runtime/procedural responsibility without redefining the theory |
| `represent` | encode theory/practice facts into records without making the record schema the theory definition |
| `handoff` | explicitly transfer responsibility to another layer, module, or procedure |

The governing rule remains:

```text
call != redefinition
```

Definition ownership, specialization ownership, evidence ownership, operational-fact ownership, and verification ownership remain distinct.

## 2. Current relation

### Framework/theory -> Lean specialization

```text
portable-runtime framework/theory documents
    --reference / boundary-reference / specialize-->
responsibility_topology formal objects and relations
```

A Lean theorem proves a property of its explicit formal specialization. It does not automatically prove the broader framework concept for every domain.

### Framework/practice -> runtime

```text
portable-runtime theory/practice
    --operationalize / represent-->
portable-runtime records, authorization, revision,
revalidation, reopen, recovery, execution
```

Executable behavior is evidence about the implementation. It does not redefine the theoretical concepts represented by its records.

### Lean kernel <-> runtime implementation

No full refinement relation is established:

```text
responsibility_topology
    -/-> verified refinement of portable-runtime

portable-runtime
    -/-> verified implementation of responsibility_topology
```

The current strongest bridge is a **restricted certified observational bridge** for one selected qualification-withdrawal fragment.

## 3. Known semantic non-identity

Dependency propagation after change remains the canonical mismatch example.

Paper 3 formal challenge semantics use a specialized historical warrant graph:

```text
Affected(S,t,w)
:=
(w = t) or DescendantOf(S,t,w)
```

where `DescendantOf` is transitive closure over canonical warrant-parent history.

The runtime uses direct typed dependency relations for structural impact assessment and explicitly does not make generic dependency impact recursive full-graph invalidation.

Therefore:

```text
runtime direct typed dependency impact
!=
formal transitive historical challenge impact
```

This coordinate remains outside the certified B0 fragment. Strict-L6 did not normalize it away.

Safe statement:

> Both systems separate historical/dependency records from mutable current qualification while using different propagation semantics for their own object models.

Unsafe statement:

> The Lean challenge semantics verify the runtime revalidation engine.

## 4. REF-1 / REF-2 observation discovery

The state-only candidate:

```text
alpha : RuntimeState -> FormalObservation
```

was rejected as underspecified. Observation time and finite witnesses can matter on both sides.

The executable bridge therefore used finite observation bundles:

```text
RuntimeObservationBundle0
        | alpha_r0
        v
       O0
        ^
        | alpha_f0
FormalObservationBundle0
```

`O0` keeps distinct families for:

```text
historicalTrace
historicalDependency
operativeStatus
activationUse
impactObservation
reviewInvalidation
dischargeRequirement
dischargeEvidence
regimeReference
```

Mapping quality is first-class data:

```text
EXACT-SHAPE
ABSTRACTION
PARTIAL
SEMANTIC-MISMATCH
NOT-REPRESENTED
```

The discovered compatible fragment was:

```text
B0 = {
  historicalTrace:trace.referent-present,
  operativeStatus:qualification.current
}
```

Impact was excluded because of the semantic mismatch above.

`OBSERVATION_BRIDGE_ALPHA0.md` remains the historical REF-1 interface specification and should not be read as the final strict bridge boundary.

## 5. REF-3 restricted certificate checkpoint

REF-3 established a deliberately narrow certificate/checker fragment around:

```text
history-retaining qualification withdrawal
```

The runtime extracted a `QualificationWithdrawalCertificate` from actual B0 observations, and the formal side checked that a presented certificate satisfied the restricted B0 contract.

That checkpoint remains valid provenance, but its trust boundary still began **after** Python-side semantic extraction. It is therefore not the final strict bridge endpoint.

Approved REF-3-style claim:

> A concrete certificate presented to the Lean checker satisfies the restricted B0 contract when the checker accepts it.

Not approved:

```text
Python runtime verified
certificate extraction verified by Lean
portable-runtime refines responsibility_topology
RuntimeStep -> FormalStep*
```

## 6. REF-4 strict raw-runtime bridge

Strict-L6 moves the checked boundary left from a Python-derived B0 certificate to selected raw runtime-native record fields.

### Runtime artifact

`portable-runtime` produces a versioned raw envelope:

```text
RawWithdrawalTransitionV1
```

whose before/after snapshots are direct serialized `Assertion` records from the selected executable transition path.

The selected frozen transition is:

```text
same Assertion id
supported, version 7
    ->
revalidation-required, version 8
```

The raw artifact deliberately contains no Python-derived B0 semantic coordinates such as:

```text
historicalTraceBefore
historicalTraceAfter
qualificationBefore
qualificationAfter
B0 key/value
```

### Lean-owned projection and checker

`responsibility_topology` defines:

```text
rawQualificationB0
alphaB0Lean
checkProjectedB0Withdrawal
checkRawWithdrawal
```

Lean reads selected runtime-native canonical fields:

```text
id
record_type
lifecycle_status
epistemic_status
version
```

and computes the restricted B0 historical-trace/current-qualification observation itself.

The main strict theorem is:

```text
checkRawWithdrawal t = true
->
RawB0WithdrawalHolds t
```

where `RawB0WithdrawalHolds` applies the already-existing restricted B0 qualification-withdrawal contract to the Lean-defined projection.

The cross-repository conformance workflow pins the exact `portable-runtime` merge commit, fetches the committed raw JSON fixture, and sends it directly through:

```text
Lean JSON parser
-> alphaB0Lean
-> checkRawWithdrawal
-> restricted B0 contract
```

The Python O0/B0 semantic adapter and REF-3 certificate extractor are not part of this strict success path.

## 7. Strict bridge trust boundary

The current frozen boundary is:

```text
actual selected Python runtime transition
        |
        | runtime execution / Assertion construction / model_dump serialization
        | TRUSTED / NOT LEAN-VERIFIED
        v
RawWithdrawalTransitionV1 JSON artifact
        |
        | pinned artifact transport / I/O
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

The remaining trust boundary includes:

- raw runtime execution and record construction;
- serialization correctness;
- artifact transport/I/O fidelity;
- representativeness of the selected fixture/path;
- all runtime fields and behaviors outside the selected B0 observation surface.

The checker does not verify every field in the full raw `Assertion` snapshot.

Therefore the strongest approved strict claim is:

> The exact pinned serialized selected runtime transition artifact, when parsed and projected by Lean, satisfies the restricted B0 qualification-withdrawal contract when `checkRawWithdrawal` accepts it.

It is **not**:

```text
Python runtime verified
all Assertion transitions verified
production admission path guarded by Lean
RuntimeStep -> FormalStep*
portable-runtime refines responsibility_topology
```

## 8. Cross-domain interpretation status

Cross-domain falsification rejected the broad unqualified candidate:

```text
persistent relation != current responsibility
```

because historical trace persistence and operative-force persistence are separate questions.

Two narrower candidates survived only at **FORMAL SIMILARITY**:

```text
CI-2
Affectedness does not by itself constitute sufficient discharge.

CI-3
Conformance within a represented regime does not by itself settle
higher-order adequacy / validity / fitness for the relied-upon purpose.
```

The strict interpretation layer separates:

```text
M_D : source-audited finite domain semantics
I_D : explicit interpretation obligations
C_D : existing parametric core instance
```

The interpretation obligations make preservation/reflection responsibilities explicit. They do not certify that the real external institution has been fully formalized, and they do not discharge the external adequacy premises required by the generic core.

Four already-audited finite case models are interpreted through the common interfaces:

```text
Maintenance
InstitutionalAuthority
Measurement
SoftwareRegression
```

These results establish reuse of a formal interpretation method across selected finite models. They establish neither mechanism similarity nor external-domain verification nor a universal responsibility invariant.

## 9. Frozen Strict Technical Level 6

The final strict technical evidence stack is:

```text
DomainParametricCore
+
ExplicitDomainInterpretations
+
EndToEndB0RuntimeCorrespondence
```

with the narrow meaning defined above.

Frozen verdict:

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

This strict result does **not** establish:

```text
universal responsibility invariant
external-domain verification
mechanism similarity across domains
full Python runtime verification
full observational/runtime refinement
runtime/formal impact equivalence
production-wide Lean admission gating
QX solved or formalized
QC solved or formalized
```

Strict-L6 is closed. Future work on any excluded axis is a new research objective, not unfinished Level-6 completion.

## 10. Post-freeze research firewall

Current research governance is:

```text
QO: ARCHIVED NEGATIVE CONTROL
QX: DORMANT / OPEN / PRE-FORMAL
QC: EVIDENCE-LIMITED / PRE-FORMAL
QX Lean: NO
QC Lean: NO
```

No default dependency is assumed between QX and QC.

The frozen technical bridge also preserves an important diagnostic separation:

```text
observation / acquisition failure
!= representation / correspondence mismatch
!= implementation / execution nonconformance
!= object / decision / repair failure inside the represented regime
!= evidence implicating the regime itself
```

In particular:

```text
O0 semantic mismatch
-/-> regime inadequate

Lean checker rejection
-/-> runtime regime inadequate

runtime violation of represented B0 expectation
-/-> regime inadequate
```

A future QX or QC formal line must be independently earned under `RESEARCH_STATE.md` and `CONTRIBUTING.md`; bridge disagreement or an easy-to-write predicate is not sufficient evidence.

## 11. Change rule

Any future document claiming `refines`, `implements exactly`, `verified runtime`, `semantically equivalent`, `complete dependency extraction`, `universal responsibility invariant`, or an equivalent strong relation must cite a concrete theorem/artifact establishing that relation.

Until then, approved relationship language includes:

```text
reference
boundary-reference
specialize
operationalize
represent
handoff
conceptual alignment
partial observational boundary
restricted certified observational bridge
selected conformance / observational evidence
formal similarity under explicit interpretation
```

This contract changes neither repository's object semantics nor runtime behavior.
