# TRANSPORT Paper Checkpoint

Status: kernel expansion paused after T4b.

Semantic baseline for this checkpoint: `3f33addab8c19ecb154c076d77afd7586a1da485` (PR #31 merge).

This note evaluates whether the completed TRANSPORT results form a coherent paper-facing theoretical core. It does not add or imply new formal obligations.

## Checkpoint verdict

**Pass for an independent manuscript kernel; no-go for further kernel expansion by default.**

The current TRANSPORT surface already supports a distinct thesis from Paper 1:

> Representation crossing can preserve origin identity, isolate translation responsibility, and establish a distinct target historical identity without collapsing those relations into target current usability.

The machine-checked results support four separable contribution families:

1. exact same-profile cross-context historical formation;
2. source-context current qualification;
3. BRIDGE-isolated translation lineage;
4. two-hop scope/strength/lineage conservation.

Two-hop composition is sufficient evidence that the conservation laws are compositional rather than a one-step accident. An arbitrary-length transport-chain development is therefore not a prerequisite for the paper thesis.

This checkpoint does **not** claim venue acceptance, empirical validity, or novelty priority. Those remain paper/review questions, not consequences of the Lean theorems.

## Contribution 1 — Exact cross-context formation

Paper-facing claim:

> A TRANSPORT child is formed at a target context while preserving the exact original and translation-witness identities as historical parents.

Formal support:

- `transportHistoricalWarrant_parents_exact`
- `transportHistoricalWarrant_role_exact`
- `transportHistoricalWarrant_formation_exact`
- `transportStep_newWarrant_exact`
- `reachable_transportWarrantsWellFormed`

The event surface exposes only genuine free variables. Child role is inherited from the original and parents are canonically `[original,witness]`; neither an arbitrary output role nor arbitrary parent list is supplied by the event.

Formation is same-profile. Target-context activation/adoption is not a premise. Formation checks modeled transport discipline and writes immutable historical state; it does not grant current usability.

Supporting boundary:

- `transportStep_newWarrant_unqualified`
- `transportStep_newWarrant_notUsable`

The exact-formation theorem is local `Step`-level. Fresh-child non-usability uses `Reachable`, matching the existing ROOT/INFER distinction.

## Contribution 2 — Source-context current responsibility

Paper-facing claim:

> Qualification of a target-context transported child checks each stored parent identity at that parent's own historical formation context.

Formal support:

- `TransportParentsUsable`
- `qualifyTransport_requires_sourceCurrent`
- `qualifyTransport_sourceContexts_exact`
- `qualifyTransport_evaluation_exact`
- `qualifyTransport_makes_usable`
- `qualifyTransport_historyReferentsImmutable`
- `transportFormationQualification_boundary`
- `transportQualification_context_coordinates`

The currentness coordinates are:

```text
Usable(S, (profileDigest, original.formationContext, use, originalId))
Usable(S, (profileDigest, witness.formationContext,  use, witnessId))
```

The child is written at its own target-context evaluation key.

Qualification does not replay translation binding, target acceptance, scope narrowing, strength non-amplification, or lineage transformation. Those are immutable formation responsibilities carried by history.

The lifecycle theorem is adjacent only:

```text
S0 --transport--> S1 --qualifyTransport--> S2
```

It does not imply arbitrary temporal persistence and does not require the original, witness, and target contexts to coincide or be active.

## Contribution 3 — Translation-evidence isolation

Paper-facing claim:

> Translation evidence may contribute ancestry only through BRIDGE responsibility; away from BRIDGE, the original role-indexed ancestry is exact.

Single-hop formal support:

- `transportRootLineage_preserves_original`
- `transportRootLineage_witness_as_bridge`
- `transportRootLineage_nonBridge_exact`
- `transportSourceLineage_preserves_original`
- `transportSourceLineage_witness_as_bridge`
- `transportSourceLineage_nonBridge_exact`

Two-hop formal support:

- `transportRootLineageTwoHop_nonBridge_exact`
- `transportSourceLineageTwoHop_nonBridge_exact`
- `transportRootLineageTwoHop_bridge_exact`
- `transportSourceLineageTwoHop_bridge_exact`

For any `role ≠ BRIDGE`, final two-hop lineage is exactly the original lineage at that role. At BRIDGE, final lineage is exactly the original BRIDGE ancestry plus ancestry contributed by the first and second translation witnesses.

This is responsibility isolation, not a linear/use-once resource interpretation.

## Contribution 4 — Two-hop conservation

Paper-facing claim:

> Historical TRANSPORT conservation composes across two consecutive representation crossings.

Pure semantic support:

- `transportTwoHop_scope_conservative`
- `transportTwoHop_strength_nonamplifying`
- `transportRootLineage_twoHop_unfold`
- `transportSourceLineage_twoHop_unfold`
- the two-hop non-BRIDGE/BRIDGE exact theorems above

Reachable lifting:

- `twoHopTransportFormationBoundary`

The reachable theorem has exactly the intended architecture:

```text
Step.transport
  -> transportStep_newWarrant_exact
  -> exact intermediate child identity
  -> pure T4a conservation
```

The second step's `originalId` is the first step's child ID. The proof does not restate or replay the full T0 formation discipline as a new theorem premise surface.

The theorem recovers the historical child after each hop and establishes:

- final scope is bounded by the original scope;
- when canonical escalation depths are interpretable, final depth is no greater than original depth;
- root/source non-BRIDGE lineage is exactly conserved;
- root/source BRIDGE lineage accumulates exactly the original BRIDGE ancestry and both translation witnesses.

`twoHopTransportFormationBoundary` is included in `formal/ResponsibilityTopology/Audit.lean`; the final PR #31 audit reports axiom dependencies `[propext, Quot.sound]`. CI also independently rejects `sorry`/`admit` proof placeholders.

## Why this is distinct from Paper 1

Paper 1's core separation is:

```text
historical relation != current usability relation
```

The TRANSPORT paper adds a representation-boundary dimension:

```text
source historical identity
!= translation-evidence responsibility
!= target historical identity
!= source-context current qualification
```

The narrow paper thesis should therefore be framed around responsibility preservation across representation boundaries, not merely around another historical constructor.

A defensible central formulation is:

> Responsibility can cross a representation boundary without collapsing origin identity, translation evidence, and target usability into one relation.

The strongest machine-backed refinement is:

> Same-profile TRANSPORT forms an exact target-context historical child from an original and BRIDGE witness, later qualifies that child by checking the stored parent identities at their own formation contexts, and composes scope/strength/lineage conservation across two consecutive formation steps.

## Frozen after checkpoint

The following are explicitly frozen and are not prerequisites for the current paper kernel:

```text
CrossProfileTransport:           FROZEN
TargetAdoption/Activation:       FROZEN
ArbitraryTemporalClosure:        FROZEN
QualificationChainPropagation:   FROZEN
NHopTransportChain:              FROZEN
PythonRefinement:                FROZEN
Assembly:                        FROZEN
Challenge/Revalidation:          FROZEN
```

`QualificationChainPropagation` is a separate theorem family. In particular, this checkpoint does not prove:

```text
Current(original) + Current(witness1) + Current(witness2)
  -> Current(finalTransportChild)
```

across a multi-hop qualification chain.

Likewise, two-hop historical conservation does not imply an arbitrary `n`-hop theorem. An `n`-hop path/fold development should be opened only if a concrete paper argument requires it.

## Trigger policy after checkpoint

Do not resume kernel expansion merely because a stronger generalization is available.

A new formal phase should open only if a concrete manuscript sentence is both indispensable and unsupported by the current theorem surface, and cannot be narrowed without damaging the paper thesis.

In particular:

- an `n`-hop trigger requires the paper to need arbitrary-length composition rather than two-hop compositional evidence;
- a qualification-chain trigger requires the paper to make a currentness-propagation claim across multiple transported children;
- an activation/adoption trigger requires a target-currentness claim not expressible with the existing qualification boundary;
- a Python-refinement trigger requires an explicit executable/refinement claim rather than artifact conformance evidence.

## Checkpoint decision

**Kernel decision:** stop.

**Paper decision:** proceed to paper-facing theorem map, running example, related-work narrowing, and manuscript architecture using the four contribution families above.

**Research decision:** treat arbitrary-length transport composition and qualification-chain propagation as optional future work until the manuscript demonstrates that either is necessary.
