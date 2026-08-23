# Level-6 Technical Consolidation Audit

Status: integration audit for the technical-consolidation track. This document does not create a new theory axis and does not retroactively expand Paper 1–3 claim surfaces.

The target evidence stack is:

```text
CrossDomainCore
+
DomainInstances
+
CertifiedRuntimeBridge
```

The theory sequence remains:

```text
Object -> Environment -> Change -> Regime -> Multi-agent regime
```

but the execution sequence has deliberately completed technical consolidation before resuming `Q_open` regime theory.

---

## 1. Audited baselines

### D4 software regression

```text
responsibility_topology PR #71 merge
304e7d7e404af324aa5ae66e4f6dd60bb6484ef4
```

D4 uses the formal kernel and `portable-runtime` only as regression samples after D1–D3 discovery/falsification. It does not promote software back into the discovery set.

### Minimal cross-domain calculi — XDC-1

```text
responsibility_topology PR #72 merge
1fc8d77b31b5ab85f235f327a9e2e4fb2122c0a0
```

Machine-checked calculi:

```text
ImpactDischargeCore
EvaluationLayerCore
```

The first proves conditional composition only under explicit coverage/realization sufficiency and contains a finite countermodel to the universal shortcut:

```text
Affected -> Discharged
```

The second defines no adequacy predicate and contains finite countermodels / observational underdetermination showing that local conformance does not uniquely force the higher-order verdict.

### Executable O0 — REF-2

```text
portable-runtime PR #9 merge
8d04e01e7e16608da5ad9a17b7dc0f4d8f5c229f
```

REF-2 made `O0` executable with first-class loss classes:

```text
EXACT-SHAPE
ABSTRACTION
PARTIAL
SEMANTIC-MISMATCH
NOT-REPRESENTED
```

Six fixture families F1–F6 execute through both adapters.

`discover_b0` found a non-empty witnessed common fragment rather than receiving one by configuration. The first witnessed B0 coordinates are:

```text
historicalTrace:trace.referent-present
operativeStatus:qualification.current
```

The impact coordinate is excluded because runtime direct typed impact and formal transitive historical challenge impact remain `SEMANTIC-MISMATCH`.

### Runtime certificate extraction — REF-3 runtime side

```text
portable-runtime PR #10 merge
fd85f3041db99cf4bc12b81b2219e732827ad622
```

The runtime adapter produces a versioned certificate for the first B0 fragment:

```text
history retained as an observation
+
qualification: qualified -> withdrawn
+
accepted discharge evidence tracked separately
```

The frozen runtime fixture has no accepted discharge evidence after withdrawal.

Certificate extraction and serialization are not verified by Lean.

### Verified checker / formal-side witness — REF-3 formal side

```text
responsibility_topology PR #73 merge
26bca813ac1c1530a476dc82c24dafcc42ff982c
```

The verified checker establishes only the abstract certificate contract presented to it.

The formal-side theorem independently shows that the existing challenge semantics can realize the same B0 pattern at the challenged target:

```text
exact historical target referent retained
+
pre-state Usable
+
post-state not Usable
```

This is observational alignment, not identification of Python assertion status with formal `Usable`.

---

# 2. Cross-domain evidence layer

The source-backed XDI sequence remains authoritative for domain interpretation:

```text
D1 physical-operational
D2 normative-institutional
D3 empirical-scientific
D4 software regression
```

XDI promoted only:

```text
CI-2
Affectedness does not by itself constitute sufficient discharge.

CI-3
Conformance within a represented regime does not by itself settle
higher-order adequacy / validity / fitness for the relied-upon purpose.
```

Both remain:

```text
FORMAL SIMILARITY
```

and not:

```text
MECHANISM SIMILARITY
UNIVERSAL INVARIANT
```

The Level-6 Lean case models instantiate the same two minimal calculi for four audited case encodings:

```text
Maintenance
InstitutionalAuthority
Measurement
SoftwareRegression
```

These case models are not formalizations of the external domains. They machine-check only that the XDI responsibility cut can be encoded in the same minimal calculus without importing warrant/license/challenge/repair-hypergraph vocabulary.

This is the intended meaning of `DomainInstances` at Level 6.

---

# 3. Certified runtime bridge trust boundary

The trust boundary is deliberately asymmetric:

```text
raw runtime state / events
        |
        |  ordinary Python execution, not Lean-verified
        v
alpha_r0 + certificate extraction / serialization
        |
        |  unverified extraction boundary
        v
QualificationWithdrawalCertificate
        |
        |  VERIFIED CHECKER STARTS HERE
        v
Lean checkQualificationWithdrawal
        |
        v
abstract B0 qualification-withdrawal contract
```

The formal system separately proves that one existing formal transition family realizes the same abstract pattern.

Therefore the certified statement is:

> A concrete certificate presented to the Lean checker satisfies the restricted B0 withdrawal contract when the checker accepts it.

It is **not**:

```text
Python runtime verified
portable-runtime refines responsibility_topology
RuntimeStep -> FormalStep*
```

A future stronger claim must reduce or separately certify the extraction boundary.

---

# 4. Restricted executable result

The strongest current executable statement is intentionally checker-level:

```text
checked qualification withdrawal
+
no accepted discharge/requalification evidence
->
certified current-use continuation rejected
```

The Lean theorem is:

```text
checked_withdrawal_without_discharge_rejects_current_use
```

This does not state that the Python runtime is physically incapable of using an object. It states that the certified observational checker rejects continuation under the represented B0 contract.

The companion formal-side theorem is:

```text
challenge_target_realizes_formal_withdrawal_pattern
```

Together they give a restricted observational correspondence story:

```text
actual runtime fixture
  -> O0 snapshots
  -> B0 certificate
  -> verified certificate check

formal challenge transition
  -> independently proved B0 pattern
```

There is still no theorem directly connecting the raw runtime transition to the formal challenge transition.

---

# 5. What Level 6 deliberately excludes

## 5.1 No impact refinement

Do not compare:

```text
runtime.directTypedImpact
=
formal.transitiveHistoricalImpact
```

REF-2 correctly keeps this coordinate outside B0.

## 5.2 No generic repair/discharge runtime refinement

The runtime does not expose a generic lifecycle isomorphic to Paper 3 `RepairProblem / RepairRealization / RevalidationTrace`.

The first certified fragment therefore stops at qualification withdrawal/current-use rejection. Restoration/discharge can be added only when an actually represented runtime evidence surface supports it.

## 5.3 No cross-domain history invariant

The formal kernel and runtime happen to preserve substantial history. XDI already rejected promotion of universal persistent historical relation as a cross-domain invariant.

`historicalTrace` remains an observation family, not a universal domain law.

## 5.4 No Q_open formalization

CI-3 preserves the interface to higher-order regime evaluation but defines neither adequacy nor entitlement to reopen.

The parked QO-1 work is not imported into this Level-6 result.

---

# 6. Integration criteria

Level-6 technical consolidation passes only if all of the following are true:

```text
[D4] software regression does not force generic vocabulary leakage
[XDC] two minimal calculi elaborate and their countermodels are machine checked
[DomainInstances] D1-D3 and D4 case encodings instantiate those calculi
[REF-2] executable adapters pass F1-F6
[REF-2] actual adapter output discovers non-empty B0
[REF-2] semantic-mismatch coordinates remain excluded
[REF-3 runtime] actual fixture produces a frozen certificate
[REF-3 formal] Lean checker proves certificate soundness
[REF-3 formal] existing formal semantics realizes the selected B0 pattern
[Trust] extraction remains explicitly outside the verified checker TCB
```

No criterion requires mechanism similarity, universal cross-domain invariance, full runtime refinement, or Q_open closure.

---

# 7. Level-6 verdict boundary

If the integration branch elaborates and CI remains green, the appropriate verdict is:

```text
TECHNICAL LEVEL 6: PASS
scope: restricted observational-certificate bridge
```

Meaning:

1. heterogeneous-domain falsification produced a minimal abstraction that survived software regression;
2. that abstraction has a machine-checked parametric core and explicit countermodels;
3. the runtime/formal bridge has an executable neutral observation boundary discovered from fixtures;
4. a non-empty fragment of that boundary has a verified checker;
5. an existing formal transition family realizes the same abstract pattern;
6. all known semantic mismatches and trust boundaries remain visible.

It does **not** mean:

```text
universal responsibility invariant proved
external domains verified
Python runtime verified
full observational refinement proved
Q_open solved
```

After this audit, technical feature expansion should stop by default. The next main research track may return to `Q_open`, now with a cleaner separation between abstraction mismatch, implementation correspondence, and regime inadequacy.
