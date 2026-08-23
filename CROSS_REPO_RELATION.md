# Cross-Repository Relation Contract

This document defines the relationship between:

- `xiongweilin/responsibility_topology` — Lean-centered formal kernels, cross-domain calculi, theorem surfaces, and the verified observational checker;
- `xiongweilin/portable-runtime` — framework documentation, record semantics, operational/runtime mechanisms, executable `O0` adapters, certificate extraction, revision/revalidation/reopen workflows, and engineering implementation.

The relation is intentionally **not** implementation equality or verified runtime refinement.

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

The current strongest bridge is a **restricted certified observational bridge** over a discovered common fragment.

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

This coordinate remains `SEMANTIC-MISMATCH`; Level-6 did not normalize it away.

Safe statement:

> Both systems separate historical/dependency records from mutable current qualification while using different propagation semantics for their own object models.

Unsafe statement:

> The Lean challenge semantics verify the runtime revalidation engine.

## 4. REF-2 executable O0

The state-only candidate

```text
alpha : RuntimeState -> FormalObservation
```

was rejected as underspecified. Observation time and finite witnesses can matter on both sides.

The executable bridge instead uses finite observation bundles:

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

REF-2 implementation lives in `portable-runtime` PR #9, merge:

```text
8d04e01e7e16608da5ad9a17b7dc0f4d8f5c229f
```

Six REF-1 fixture families F1–F6 execute through both adapters.

`discover_b0` discovered a non-empty compatible fragment from actual adapter output under explicit subject-ID mappings rather than receiving a preselected family allowlist:

```text
B0 = {
  historicalTrace:trace.referent-present,
  operativeStatus:qualification.current
}
```

The impact coordinate is excluded from `B0` because of the semantic mismatch above.

## 5. REF-3 restricted certificate fragment

The first certified fragment is deliberately narrow:

```text
history-retaining qualification withdrawal
```

### Runtime side

`portable-runtime` PR #10, merge:

```text
fd85f3041db99cf4bc12b81b2219e732827ad622
```

adds a versioned `QualificationWithdrawalCertificate` extracted from actual `B0` observations. The frozen fixture records:

```text
historical trace: present -> present
qualification:     qualified -> withdrawn
accepted discharge evidence after: false
```

Extraction refuses to infer qualification from impact/disposition data.

### Formal side

`responsibility_topology` PR #73, merge:

```text
26bca813ac1c1530a476dc82c24dafcc42ff982c
```

adds a Lean checker and proves:

```text
checker acceptance
->
restricted B0 qualification-withdrawal contract
```

and the checker-level consequence:

```text
checked qualification withdrawal
+
no accepted discharge/requalification evidence
->
certified current-use continuation rejected
```

The formal kernel separately proves that its existing challenge semantics can realize the same observational pattern at a challenged target:

```text
historical target referent retained
+
pre-state Usable
+
post-state not Usable
```

This is observational alignment, not a theorem equating runtime assertion status with formal `Usable`.

## 6. Verified-checker trust boundary

The trust boundary is intentionally asymmetric:

```text
raw runtime state / events
        |
        | ordinary Python execution
        v
alpha_r0 + certificate extraction / serialization
        |
        | UNVERIFIED EXTRACTION BOUNDARY
        v
QualificationWithdrawalCertificate
        |
        | VERIFIED CHECKER STARTS HERE
        v
Lean checkQualificationWithdrawal
        |
        v
abstract B0 transition contract
```

Therefore the approved claim is:

> A concrete certificate presented to the Lean checker satisfies the restricted `B0` contract when the checker accepts it.

The following are not approved:

```text
Python runtime verified
certificate extraction verified by Lean
portable-runtime refines responsibility_topology
RuntimeStep -> FormalStep*
```

A future stronger refinement claim would have to reduce or separately certify the extraction boundary.

## 7. Cross-domain status

Cross-domain falsification rejected the broad unqualified candidate:

```text
persistent relation != current responsibility
```

because historical trace persistence and operative-force persistence are separate questions.

Two narrower candidates survived at **FORMAL SIMILARITY** only:

```text
CI-2
Affectedness does not by itself constitute sufficient discharge.

CI-3
Conformance within a represented regime does not by itself settle
higher-order adequacy / validity / fitness for the relied-upon purpose.
```

`responsibility_topology` contains two minimal parametric calculi plus finite D1–D3 and D4 case-model encodings for these responsibility cuts. Those case models do not verify the external domains and establish neither mechanism similarity nor universality.

## 8. Level-6 technical freeze

The technical-consolidation track is frozen at:

```text
responsibility_topology PR #74 integration merge
59751542378a61dc33d372dd693ebda8627bab5a

responsibility_topology PR #75 freeze merge
b95fb82742739395e1e917aa3019199ca470ffad

Lean #256:                    PASS
Python-Lean Conformance #197: PASS
```

Frozen verdict:

```text
TECHNICAL LEVEL 6: PASS
scope: restricted observational-certificate bridge
```

The evidence stack is:

```text
CrossDomainCore
+
DomainInstances
+
CertifiedRuntimeBridge
```

It does not mean:

```text
universal responsibility invariant proved
external domains verified
Python runtime verified
full observational refinement proved
Q_open solved
```

Technical bridge expansion stops by default after this checkpoint.

## 9. Q_open handoff firewall

Level-6 completion adds a required diagnostic separation for the next theory:

```text
observation / acquisition failure
!= representation / correspondence mismatch
!= implementation / execution nonconformance
!= object / decision / repair failure inside the represented regime
!= evidence implicating the regime itself
```

In particular:

```text
O0 SEMANTIC-MISMATCH
-/-> regime inadequate

Lean checker rejects certificate
-/-> runtime regime inadequate

runtime violates represented B0 expectation
-/-> regime inadequate
```

These can be evidence of different failure classes. Q_open must not treat bridge disagreement or implementation failure as an automatic entitlement to reopen the governing regime.

## 10. Change rule

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
```

This contract changes neither repository's object semantics nor runtime behavior.