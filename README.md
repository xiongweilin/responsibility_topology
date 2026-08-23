# Responsibility Topology — Formal Research Program

This repository is the Lean-centered formal research line of a broader Responsibility Topology program. Its recurring question is:

> **How can a finite system preserve why something exists while separately re-establishing what may be relied on now?**

The repository is no longer a first-paper-only kernel. Current `main` contains three paper-scale formal stages, a completed cross-domain falsification/consolidation track, and a restricted certified observational bridge to `portable-runtime`.

## Program progression

The theory sequence remains:

```text
Object
  Paper 1: identity / formation
  historical relation != current qualification
        |
        v
Environment
  Paper 2: cross-context responsibility
  transported history != source/target current responsibility
        |
        v
Change
  Paper 3: invalidation / repair
  preserved history != restored current responsibility
        |
        v
Regime                    [next theory]
  Q_open: what can defeat entitlement to closure over a bounded scope?
        |
        v
Multi-agent regime         [later]
  Q_close: how is responsibility discharged across heterogeneous agents?
```

The unifying principle is not a particular constructor. It is the repeated separation of persistent structure from state-indexed current responsibility along progressively harder axes.

## Current research status

```text
Cross-domain strength:       FORMAL SIMILARITY
Runtime bridge:              restricted certified observational bridge
Technical consolidation:     FROZEN PASS
Next theory:                 Q_open
```

The Level-6 technical evidence stack is frozen as:

```text
CrossDomainCore
+
DomainInstances
+
CertifiedRuntimeBridge
```

with scope:

```text
restricted observational-certificate bridge
```

See `LEVEL6_TECHNICAL_AUDIT.md` for the audited claim surface and exclusions.

## Paper map

| Stage | Research axis | Frozen / current scope | Status |
| --- | --- | --- | --- |
| **Paper 1** | Object / identity | ROOT + INFER; canonical history vs current usability; exact current-parent qualification | frozen artifact and manuscript line |
| **Paper 2** | Environment | same-profile TRANSPORT; source-indexed current qualification; Adopt-license `BaseCurrent`; reachable Adopt activation; `Grounded` currentness | formal kernel complete; manuscript line frozen separately |
| **Paper 3** | Change | challenge impact/invalidation; grounded refresh; finite repair instances; `RepairSet`; `RepairRealization`; inclusion-minimal private cuts; reachable revalidation | formal kernel frozen at PR #48; manuscript line frozen separately |
| **Technical consolidation** | Cross-domain + runtime bridge | XDI/D4, XDC-1, executable `O0`, discovered `B0`, verified checker, D1-D4 case models | **FROZEN PASS** at restricted observational-certificate scope |
| **Next theory** | Regime / closure entitlement | `Q_open` problem formulation | active research, not formalized |
| **Later theory** | Multi-agent regime | distributed responsibility / `Q_close` | not formalized |

Paper-specific claims must be read from their own manifests and paper files, not inferred from current `main`.

## Current formal architecture

```text
static entitlement / locality
        |
canonical interpretation + exact profile semantics
        |
reachable canonical history/evaluation state
        |
ROOT / INFER formation and qualification
        |
TRANSPORT formation and source-indexed qualification
        |
Adopt license records / BaseCurrent / activation / Grounded
        |
challenge invalidation
        |
grounded refresh
        |
finite repair hypergraph
        |
selection -- realization -- represented-cut necessity
        |
ordered proof-carrying revalidation trace

CrossDomain
  ImpactDischargeCore
  EvaluationLayerCore
  finite D1-D4 case models

Bridge
  restricted B0 qualification-withdrawal checker
  formal challenge witness for the same observational pattern
```

The cross-domain calculi do not prove mechanism similarity or universal invariance. The case models are audited finite encodings of responsibility cuts, not formal verification of external domains.

## Level-6 bridge boundary

REF-2 made a neutral observation algebra `O0` executable and preserved mapping quality as first-class data:

```text
EXACT-SHAPE
ABSTRACTION
PARTIAL
SEMANTIC-MISMATCH
NOT-REPRESENTED
```

Actual adapter output discovered a non-empty `B0` fragment containing historical-referent presence and current qualification. Runtime direct typed impact and formal transitive historical challenge impact remain a deliberate `SEMANTIC-MISMATCH` and are excluded from the certified fragment.

REF-3 adds a versioned qualification-withdrawal certificate and a Lean checker. The trust boundary is:

```text
raw runtime state/events
        |
        | ordinary Python extraction / serialization
        v
QualificationWithdrawalCertificate
        |
        | VERIFIED CHECKER STARTS HERE
        v
Lean checker
        |
        v
restricted B0 transition contract
```

Therefore the supported claim is checker-level:

```text
checked qualification withdrawal
+
no accepted discharge/requalification evidence
->
certified current-use continuation rejected
```

Unsupported upgrades include:

```text
Python runtime verified
RuntimeStep -> FormalStep*
impact equivalence
external-domain verification
universal responsibility invariant
Q_open solved
```

## Relationship to `portable-runtime`

`xiongweilin/portable-runtime` and this repository are related but not in a verified implementation relation.

The two repositories now share a synchronized Level-6 relationship contract:

- executable `O0` adapters and fixtures live in `portable-runtime`;
- the non-empty `B0` fragment is discovered from actual adapter output;
- certificate extraction remains ordinary Python and outside the Lean trusted checker boundary;
- the Lean checker proves only the abstract certificate contract presented to it;
- the formal kernel independently proves that one existing challenge transition realizes the same restricted observational pattern;
- no direct runtime-step-to-formal-step refinement theorem exists.

See `CROSS_REPO_RELATION.md` and `portable-runtime/docs/formal-kernel-relationship.md`.

## Next theory: Q_open

Technical consolidation is closed by default. The next research question is narrower than “what is model adequacy?”:

> **What evidence has standing to defeasibly defeat entitlement to closure over a bounded scope without already having been accepted by the challenged regime?**

The next theory must keep at least these distinctions explicit:

```text
observation/acquisition failure
!= representation/correspondence mismatch
!= implementation/execution nonconformance
!= object/decision/repair failure inside a regime
!= evidence implicating the regime itself
```

and:

```text
anomaly
!= inadequacy evidence
!= reopen entitlement
```

No current Lean module formalizes `Q_open`.

## Versioning and artifact identity

`main` is a moving research branch and must not be used as a paper identity.

- `ARTIFACT.md` remains the immutable **Paper 1** artifact freeze.
- `PAPER_VERSIONS.md` records paper-specific semantic/manuscript baselines and versioning policy.
- `LEVEL6_TECHNICAL_AUDIT.md` freezes the technical-consolidation claim surface.
- `paper/` contains paper workspaces; its README is a navigation index, not a claim source.
- `formal/README.md` describes the current formal research surface.

## Formal freeze rule

Formal work is frozen by default. A new Lean phase should open only after the research question survives falsification and a concrete theorem/countermodel surface is earned. In particular, Level-6 completion does not authorize additional bridge fragments, generic repair adapters, or broader correspondence claims by default.

## Repository layout

- `formal/` — current Lean 4 research program, cross-domain calculi, bridge checker, and audit surfaces.
- `paper/` — Paper 1, Paper 2, and Paper 3 writing/audit material.
- `ARTIFACT.md` — Paper 1 artifact lock only.
- `PAPER_VERSIONS.md` — paper-specific frozen commit identities.
- `LEVEL6_TECHNICAL_AUDIT.md` — frozen Level-6 technical audit.
- `CROSS_REPO_RELATION.md` — synchronized relation contract with `portable-runtime`.
- `PROGRAM_ROADMAP.md` — theory sequence and execution-track separation.

## Build and audit

```bash
cd formal
lake build
lake env lean ResponsibilityTopology/Audit.lean
lake env lean ResponsibilityTopology/Paper3Audit.lean
lake env lean ResponsibilityTopology/CrossDomainAudit.lean
lake env lean ResponsibilityTopology/BridgeAudit.lean
lake env lean ResponsibilityTopology/Level6Audit.lean
```

A Lean theorem is evidence only for its explicit formal statement and premises. It is not evidence of external-domain truth, model adequacy, full runtime refinement, or `Q_open`.