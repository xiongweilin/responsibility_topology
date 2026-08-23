# Paper 2 TRANSPORT Theorem Map

Status: claim surface frozen for Paper 2.

Formal baseline: `b000dd5c9029d57e69add09abe0691d6c5d98175`.

This note replaces the development labels T0–T4b with a paper-facing result surface. It records what the manuscript may state, the exact Lean support, and the corresponding non-claims. Later Paper 2 work may narrow or reorganize these claims; it may not broaden them by prose.

## Global paper boundary

Paper 2 studies same-profile TRANSPORT across context / representation boundaries. The paper-facing decomposition is:

```text
origin historical identity
!= translation-evidence responsibility
!= target historical identity
!= source-indexed current qualification
```

The central positive thesis is:

> Responsibility can cross a representation boundary without collapsing origin identity, translation evidence, target historical identity, and source-indexed current qualification into one relation.

This is a mechanized kernel result about the represented TRANSPORT vocabulary. It is not a claim of arbitrary interoperability, target adoption, entitlement, empirical adequacy, executable refinement, arbitrary temporal persistence, or arbitrary-length transport-chain closure.

---

## P2-R1 — Exact Cross-Context Formation

### Paper claim

A TRANSPORT formation step creates an exact immutable historical child at the target context while retaining the exact original and bridge-witness identities as ordered historical parents. The child remains in the same profile snapshot as the formation binding, inherits the original role, and has parents exactly `[original,witness]`.

Formation additionally records the modeled transport discipline: the original and witness are in the current profile snapshot; the witness has role `BRIDGE`; the witness binds the exact map/original/target/translated-claim tuple under the kernel-semantic `transportableClaim`; the target context accepts the translated claim; output scope is no wider than either parent scope; and canonical escalation strength is not amplified.

Target-context activation/adoption is not a formation premise. Formation does not itself make the child usable.

### Formal statement surface

The headline local theorem is `transportStep_newWarrant_exact` in `formal/ResponsibilityTopology/TransportFormation.lean`:

```text
Step S
  (transport child binding target map original witness translatedClaim outScope)
  S'
```

implies existence of canonical `binding`, `targetContext`, `original`, and `witness` such that:

```text
S.binding bindingId = some binding
S.context targetContextId = some targetContext
S.warrant originalId = some original
S.warrant witnessId = some witness
TransportFormationDiscipline ...
S'.warrant child = some
  (transportHistoricalWarrant
    map binding.profileDigest target
    originalId witnessId original witness translatedClaim outScope)
```

The exact historical constructor is `transportHistoricalWarrant` in `TransportSemantics.lean`. Its direct shape facts include:

- `transportHistoricalWarrant_parents_exact`
- `transportHistoricalWarrant_role_exact`
- `transportHistoricalWarrant_formation_exact`

Reachable-state support is `reachable_transportWarrantsWellFormed`, backed by `TransportWarrantWellFormed` in the shared canonical-state invariant.

Supporting currentness boundary:

- `transportStep_newWarrant_unqualified`
- `transportStep_newWarrant_notUsable`

The exact formation theorem is a local single-`Step` result. Fresh-child non-usability uses `Reachable` because it relies on the global evaluation-referent invariant.

### Lean correspondence

| Paper concept | Lean declaration | Module |
|---|---|---|
| Semantic transport witness | `transportableClaim` | `TransportSemantics.lean` |
| Formation discipline | `TransportFormationDiscipline` | `TransportSemantics.lean` |
| Canonical child history | `transportHistoricalWarrant` | `TransportSemantics.lean` |
| Exact parents | `transportHistoricalWarrant_parents_exact` | `TransportSemantics.lean` |
| Exact role | `transportHistoricalWarrant_role_exact` | `TransportSemantics.lean` |
| Exact formation shape | `transportHistoricalWarrant_formation_exact` | `TransportSemantics.lean` |
| Exact reachable-step formation | `transportStep_newWarrant_exact` | `TransportFormation.lean` |
| Reachable transport history well-formedness | `reachable_transportWarrantsWellFormed` | `Reachability.lean` |
| Fresh child has no evaluation | `transportStep_newWarrant_unqualified` | `TransportFormation.lean` |
| Fresh child not usable | `transportStep_newWarrant_notUsable` | `TransportFormation.lean` |

### Explicit non-claims

P2-R1 does **not** claim:

- cross-profile TRANSPORT;
- target context is active, adopted, licensed, or entitled;
- the witness claim is true, adequate, or epistemically sufficient;
- Python `Claim.key()` JSON encoding is the kernel identity;
- formation establishes current usability;
- arbitrary temporal persistence of the child or its currentness;
- arbitrary parent lists or arbitrary output roles.

---

## P2-R2 — Source-Context Qualification

### Paper claim

Qualification of a historical TRANSPORT child discharges current responsibility by checking each stored parent identity at that parent's own historical formation context, not at the target child context. The qualification step then writes the transported child as usable at its own target-context evaluation key.

For profile digest `pi`, use `u`, original historical object `O`, bridge witness `X`, and stored parent identities `o` and `x`, the current premises are:

```text
Usable(S, (pi, O.formationContext, u, o))
Usable(S, (pi, X.formationContext, u, x))
```

while the post-state child key is:

```text
(pi, child.formationContext, u, childId)
```

Qualification does not replay the formation discipline. Exact witness binding, target acceptance, scope narrowing, strength non-amplification, and lineage transformation remain immutable historical formation responsibilities.

### Formal statement surface

`TransportParentsUsable` is the dedicated source-context currentness predicate.

`qualifyTransport_requires_sourceCurrent` in `TransportQualification.lean` proves constructor inversion for a `qualifyTransport` step: it recovers the historical transport child, its exact two stored parents, their canonical historical objects, the child's formation profile/context, and `TransportParentsUsable` in the pre-state.

`qualifyTransport_sourceContexts_exact` exposes the exact parent currentness coordinates:

```text
Usable S
  <binding.profileDigest, original.formationContext, use, originalId>

Usable S
  <binding.profileDigest, witness.formationContext, use, witnessId>
```

`qualifyTransport_evaluation_exact` proves the exact `LIVE/PLACED` post-state write at the target child key, and `qualifyTransport_makes_usable` packages that write as `Usable`.

The adjacent lifecycle theorem `transportFormationQualification_boundary` proves, from:

```text
Reachable S0
S0 --transport--> S1
S1 --qualifyTransport--> S2
```

that the exact historical child exists in `S1`, is not usable at the target child key in `S1`, both stored parents are usable in `S1` at their own formation contexts, and the child is usable at the target key in `S2`.

`transportQualification_context_coordinates` makes the three stored context coordinates explicit without assuming equality among original, witness, and target contexts.

### Lean correspondence

| Paper concept | Lean declaration | Module |
|---|---|---|
| Parent-specific source currentness | `TransportParentsUsable` | `Reachability.lean` |
| Qualification requires source currentness | `qualifyTransport_requires_sourceCurrent` | `TransportQualification.lean` |
| Exact parent currentness coordinates | `qualifyTransport_sourceContexts_exact` | `TransportQualification.lean` |
| Exact child evaluation write | `qualifyTransport_evaluation_exact` | `TransportQualification.lean` |
| Child becomes usable | `qualifyTransport_makes_usable` | `TransportQualification.lean` |
| Historical referents immutable | `qualifyTransport_historyReferentsImmutable` | `TransportQualification.lean` |
| Adjacent formation/qualification boundary | `transportFormationQualification_boundary` | `TransportLifecycle.lean` |
| Independent source/witness/target coordinates | `transportQualification_context_coordinates` | `TransportLifecycle.lean` |

### Explicit non-claims

P2-R2 does **not** claim:

- source contexts are active or adopted;
- original and witness formation contexts are equal;
- source contexts equal the target context;
- usability is entitlement or authorization;
- qualification validates truth or adequacy of the witness;
- qualification rechecks the formation discipline;
- currentness propagates automatically through a chain of transported children;
- arbitrary temporal persistence after the adjacent qualification boundary.

`QualificationChainPropagation` remains frozen and is not required by P2-R2.

---

## P2-R3 — Translation-Evidence Isolation

### Paper claim

TRANSPORT preserves the original warrant's role-indexed ancestry while isolating translation evidence under `BRIDGE` responsibility. A translation witness cannot masquerade as original content/source ancestry at a non-BRIDGE role.

For root lineage, one hop is defined by:

```text
transportRootLineage original witness r x
  := original.rootLineage r x
     OR
     (r = BRIDGE AND exists r'. witness.rootLineage r' x)
```

with an analogous definition for external-source lineage.

Therefore, for every `r != BRIDGE`, transported lineage is exactly the original lineage at `r`. At `BRIDGE`, all witness ancestry may be exposed under bridge responsibility in addition to any original BRIDGE ancestry.

### Formal statement surface

Single-hop root-lineage results:

- `transportRootLineage_preserves_original`
- `transportRootLineage_witness_as_bridge`
- `transportRootLineage_nonBridge_exact`

Single-hop source-lineage results:

- `transportSourceLineage_preserves_original`
- `transportSourceLineage_witness_as_bridge`
- `transportSourceLineage_nonBridge_exact`

The exact two-hop strengthening is part of the same paper result family:

- `transportRootLineageTwoHop_nonBridge_exact`
- `transportRootLineageTwoHop_bridge_exact`
- `transportSourceLineageTwoHop_nonBridge_exact`
- `transportSourceLineageTwoHop_bridge_exact`

For two hops, non-BRIDGE lineage remains exactly the original lineage. BRIDGE lineage is exactly the original BRIDGE ancestry plus all ancestry contributed by witness 1 and witness 2.

### Lean correspondence

| Paper concept | Lean declaration | Module |
|---|---|---|
| Root translation transform | `transportRootLineage` | `TransportSemantics.lean` |
| Source translation transform | `transportSourceLineage` | `TransportSemantics.lean` |
| Root original preservation | `transportRootLineage_preserves_original` | `TransportSemantics.lean` |
| Root witness enters as BRIDGE | `transportRootLineage_witness_as_bridge` | `TransportSemantics.lean` |
| Root non-BRIDGE exactness | `transportRootLineage_nonBridge_exact` | `TransportSemantics.lean` |
| Source original preservation | `transportSourceLineage_preserves_original` | `TransportSemantics.lean` |
| Source witness enters as BRIDGE | `transportSourceLineage_witness_as_bridge` | `TransportSemantics.lean` |
| Source non-BRIDGE exactness | `transportSourceLineage_nonBridge_exact` | `TransportSemantics.lean` |
| Two-hop root non-BRIDGE exactness | `transportRootLineageTwoHop_nonBridge_exact` | `TransportConservation.lean` |
| Two-hop root BRIDGE exactness | `transportRootLineageTwoHop_bridge_exact` | `TransportConservation.lean` |
| Two-hop source non-BRIDGE exactness | `transportSourceLineageTwoHop_nonBridge_exact` | `TransportConservation.lean` |
| Two-hop source BRIDGE exactness | `transportSourceLineageTwoHop_bridge_exact` | `TransportConservation.lean` |

### Explicit non-claims

P2-R3 does **not** claim:

- witness ancestry is true or justified merely because it is recorded;
- BRIDGE lineage is a proof of semantic equivalence between contexts;
- BRIDGE is a linear, consumable, use-once, or exclusive resource;
- original lineage is the only possible ancestry under BRIDGE;
- lineage preservation establishes current usability, entitlement, adoption, or adequacy.

---

## P2-R4 — Two-Hop Conservation

### Paper claim

The represented historical conservation laws compose across two consecutive TRANSPORT formation steps when the second step uses the first transported child as its exact original identity.

The boundary is:

```text
S0 --transport(child1, originalId = original)--> S1
S1 --transport(child2, originalId = child1)--> S2
```

The result recovers both exact historical children and proves three conservation families from the original historical object to the second child.

Scope:

```text
Scope(child2) <= Scope(original)
```

Canonical escalation strength, when both endpoint depths are interpretable:

```text
Depth(child2) <= Depth(original)
```

Lineage:

```text
r != BRIDGE
  -> Lineage_child2(r) = Lineage_original(r)
```

and BRIDGE lineage is exactly original BRIDGE ancestry plus the ancestry of both translation witnesses, separately for root lineage and external-source lineage.

The two-hop result is evidence of compositional conservation; it is not an arbitrary-length chain theorem.

### Formal statement surface

Pure semantic closure in `TransportConservation.lean`:

- `transportTwoHop_scope_conservative`
- `transportTwoHop_strength_nonamplifying`
- `transportRootLineage_twoHop_unfold`
- `transportSourceLineage_twoHop_unfold`
- `transportRootLineageTwoHop_nonBridge_exact`
- `transportRootLineageTwoHop_bridge_exact`
- `transportSourceLineageTwoHop_nonBridge_exact`
- `transportSourceLineageTwoHop_bridge_exact`

Reachable lifting in `TransportComposition.lean`:

- `twoHopTransportFormationBoundary`

The reachable theorem assumes `Reachable S0` and exactly two adjacent TRANSPORT formation steps, with the second event's `originalId` syntactically equal to `child1`. It proves `Reachable S1`, `Reachable S2`, recovers exact `W1` and `W2`, and delegates scope/strength/lineage conclusions to the pure semantic laws.

The proof architecture is deliberately:

```text
Step.transport
  -> transportStep_newWarrant_exact
  -> exact intermediate historical identity
  -> pure two-hop conservation
```

not a restatement of every T0 formation premise as a new theorem premise surface.

The final audit for `twoHopTransportFormationBoundary` reports axiom dependencies `[propext, Quot.sound]`; CI independently rejects `sorry`/`admit` placeholders.

### Lean correspondence

| Paper concept | Lean declaration | Module |
|---|---|---|
| Scope transitivity | `transportTwoHop_scope_conservative` | `TransportConservation.lean` |
| Interpretable strength conservation | `transportTwoHop_strength_nonamplifying` | `TransportConservation.lean` |
| Two-hop root transform | `transportRootLineage_twoHop_unfold` | `TransportConservation.lean` |
| Two-hop source transform | `transportSourceLineage_twoHop_unfold` | `TransportConservation.lean` |
| Reachable two-hop boundary | `twoHopTransportFormationBoundary` | `TransportComposition.lean` |

### Explicit non-claims

P2-R4 does **not** claim:

- an arbitrary `n`-hop theorem;
- a transport-chain datatype or fold semantics;
- qualification of either intermediate or final child;
- currentness propagation through transport chains;
- arbitrary temporal closure;
- scope/strength conservation implies semantic adequacy of translation;
- cross-profile composition.

`NHopTransportChain` and `QualificationChainPropagation` remain frozen.

---

## Paper 2 result hierarchy

The manuscript should use exactly four headline result labels:

```text
P2-R1  Exact Cross-Context Formation
P2-R2  Source-Context Qualification
P2-R3  Translation-Evidence Isolation
P2-R4  Two-Hop Conservation
```

Supporting theorems may be named in artifact/theorem tables but should not be promoted into additional headline contributions without a later claim-surface review.

The intended logical progression is:

```text
P2-R1: exact target history with preserved parent identities
  ->
P2-R2: current responsibility follows those stored parent identities
       back to their own formation contexts
  ->
P2-R3: translation evidence remains isolated under BRIDGE lineage
  ->
P2-R4: the represented historical conservation laws compose for two hops
```

## Frozen vocabulary after this map

The following expressions are not permitted as theorem-level Paper 2 claims without reopening the claim-surface review:

```text
arbitrary interoperability
cross-profile transport
transport proves equivalence
transported child is adopted
transported child is entitled
target context is active
BRIDGE witness is true
currentness propagates through a transport chain
arbitrary-length transport conservation
transport history persists under arbitrary future transitions
Python TRANSPORT refines the Lean transition system
```

Safe narrower formulations should refer explicitly to:

- same-profile TRANSPORT;
- exact historical formation;
- parent-specific formation-context usability;
- BRIDGE-isolated lineage;
- adjacent lifecycle boundary;
- two-hop historical conservation;
- canonical-interpretable escalation depth.

## Formal-trigger policy

No new formal phase is opened by this theorem map.

A later paper sentence may trigger formal work only if it is all of:

1. central to the manuscript thesis;
2. unsupported by P2-R1–P2-R4;
3. not removable or safely narrowable;
4. not merely a stronger generalization chosen for elegance.

Until such a sentence exists, the kernel remains frozen and all Paper 2 work must remain inside this claim surface.
