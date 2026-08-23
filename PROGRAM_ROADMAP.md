# Responsibility Topology Research Roadmap

This roadmap is theory-level. It is not a constructor backlog.

## Unifying question

> **How can a finite system preserve historical structure while repeatedly re-establishing what may be relied on now?**

The theory sequence remains:

```text
Object -> Environment -> Change -> Regime -> Multi-agent regime
```

The execution sequence is intentionally different. After Paper 3, the program first consolidated cross-domain abstraction and the runtime/formal bridge before returning to Regime theory.

```text
Technical consolidation track
  -> Regime theory track
```

This distinction prevents “the next theory axis” from being confused with “the next engineering/research task.”

## 1. Object — Paper 1

Question:

> For one object, how are immutable historical formation and current qualification kept distinct?

Formal instance:

```text
historical warrant / parent identity
!=
state-indexed Usable
```

Core lesson: formation does not silently establish current usability; qualification does not replay all historical formation responsibility.

## 2. Environment — Paper 2

Question:

> When responsibility crosses contexts, which facts stay with historical objects and which must be re-established in the relevant environment?

Formal instances include:

```text
TRANSPORT historical formation
!=
source-indexed parent currentness
```

and:

```text
recorded Adopt provenance
!=
license BaseCurrent
!=
context Groundedness
```

Core lesson: cross-environment migration preserves some historical structure while current environment responsibility remains explicit.

## 3. Change — Paper 3

Question:

> When dependencies change, how can current responsibility be withdrawn and repaired without rewriting canonical history?

Formal instances:

```text
history continuity
!= currentness continuity
```

and:

```text
impact
!= selection
!= realization
!= represented-cut necessity
!= extraction completeness
!= execution
```

Core lesson: repair is meaningful only after separating what was affected, what is selected, what actually works, what cuts are necessary relative to a model, whether the model is complete, and how repair is executed.

---

# Technical consolidation track after Paper 3

This track does not insert a new theory axis between Change and Regime. It tests whether the existing distinctions survive heterogeneous domains and whether a restricted part can be connected to executable observations.

## T1. Cross-domain falsification

Discovery/falsification domains:

```text
D1 physical-operational
D2 normative-institutional
D3 empirical-scientific
```

Software is D4 regression, not a fourth discovery source.

The audit rejected the broad candidate:

```text
persistent relation != current responsibility
```

because historical trace persistence and persistence of the operative relation are not the same cross-domain claim.

Only two candidates were promoted, both at `FORMAL SIMILARITY`:

```text
CI-2
Affectedness does not by itself constitute sufficient discharge.

CI-3
Conformance within a represented regime does not by itself settle
higher-order adequacy / validity / fitness for the relied-upon purpose.
```

Neither mechanism similarity nor universality is claimed.

## T2. D4 software regression

D4 asks whether CI-2/CI-3 can restate the existing formal kernel and `portable-runtime` boundaries without reintroducing warrant/license/challenge/repair-specific nouns as generic primitives.

The regression passed while explicitly rejecting generic transitive impact, generic repair hypergraphs, generic recursive groundedness, universal history immutability, and an adequacy Boolean.

## T3. Minimal parametric cores

After D4, a narrow formal opening introduced two isolated calculi:

```text
ImpactDischargeCore
EvaluationLayerCore
```

They include finite countermodels showing respectively that the following universal shortcuts are not valid in the bare calculi:

```text
Affected -> Discharged
LocalConformance -> HigherAccepted
```

The calculi do not import Paper 1–3 object vocabulary and do not define Q_open adequacy.

## T4. Executable O0 / B0 bridge

REF-2 implements a neutral finite observation contract with first-class information-loss classes:

```text
EXACT-SHAPE
ABSTRACTION
PARTIAL
SEMANTIC-MISMATCH
NOT-REPRESENTED
```

The runtime/formal adapters discovered a non-empty first common fragment from fixture output:

```text
B0 = {
  historicalTrace:trace.referent-present,
  operativeStatus:qualification.current
}
```

for the first certified fragment.

The impact coordinate is excluded because:

```text
runtime direct typed impact
!=
formal transitive historical challenge impact
```

## T5. Restricted certified observational bridge

The first certified fragment is:

```text
history-retaining qualification withdrawal
```

Trust boundary:

```text
raw runtime state/events
  -> Python O0 adapter/certificate extraction
  | verified boundary begins
  -> Lean certificate checker
  -> abstract B0 transition contract
```

The verified result is about the certificate presented to the checker, not the entire Python runtime.

The formal kernel independently proves that a challenge step can realize the same B0 pattern at the challenged target: exact historical referent retained, pre-state usable, post-state not usable.

No theorem currently states:

```text
RuntimeStep -> FormalStep*
```

and no impact-semantics equivalence is claimed.

## T6. Level-6 audit

The integration target is:

```text
CrossDomainCore
+
DomainInstances
+
CertifiedRuntimeBridge
```

`LEVEL6_TECHNICAL_AUDIT.md` owns the exact evidence and trust boundary.

After this checkpoint, technical feature expansion stops by default. The next major research effort returns to Regime theory rather than adding another lifecycle constructor or broadening the runtime bridge opportunistically.

---

## 4. Regime — Q_open

This remains the next theory-level upgrade, but it was deliberately parked while technical consolidation was executed.

Question:

> **When is a finite system defeasibly entitled to reopen its current responsibility vocabulary, dependency cuts, or governing regime as itself insufficient?**

Paper 3 solves repair inside a supplied responsibility model. Cross-domain CI-3 preserves the higher-order evaluation boundary. The O0 bridge intentionally excludes an adequacy Boolean. None of those results answers the entitlement question.

A future Q_open theory must distinguish at least:

```text
anomaly / failure signal
!=
inadequacy evidence
!=
reopen entitlement
!=
replacement proposal
!=
replacement validation
```

It must address both:

```text
false reopen
```

and:

```text
closure blindness
```

without granting a system authority to rewrite its regime merely because the regime failed to produce a desired result.

Existing QO-1 formulation work remains a parked research checkpoint until Level-6 consolidation is frozen.

## 5. Multi-agent regime — Q_close

Later question:

> How can responsibility be represented and discharged across heterogeneous agents without collapsing joint representation into joint responsibility completion?

Expected distinctions include:

```text
shared representation
!= distributed evidence ownership
!= authority to decide
!= responsibility discharge
```

This stage should follow, not precede, a clearer Q_open theory.

## Remaining cross-cutting research gaps

### A. Cross-domain strength

CI-2/CI-3 currently have formal similarity and finite case-model encodings. Mechanism similarity and universal invariance remain open and should not be inferred from common notation.

### B. Stronger runtime correspondence

The current certified bridge checks a restricted observation certificate. A stronger refinement would have to reduce the unverified extraction boundary and choose additional B0 coordinates only where executable adapters show genuine semantic compatibility.

### C. Responsibility-model adequacy

This remains the deepest theoretical gap:

```text
correctness inside model
!= adequacy of model
```

and:

```text
verified correspondence
!= adequate regime
```

## Stop rule

Do not reopen or expand the formal program merely because a new constructor, optimization, algorithm, mapping, or correspondence theorem is available.

A new formal phase must address either:

- a responsibility boundary that survived falsification and cannot be expressed honestly by the current core;
- a bridge fragment discovered from executable observations rather than stipulated by analogy;
- Q_open regime-entitlement theory;
- later Q_close distributed responsibility.

The program is measured by sharper responsibility boundaries, explicit countermodels, visible trust boundaries, and stronger but narrower bridges—not theorem count.
