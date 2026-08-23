# Paper 2 Environment Claim Map

Status: paper-only synchronization against formal baseline `4dfa0c19e6fb40947e3fe5dd5b8600c55e1ad424`.

This map replaces the old reader-facing four-result TRANSPORT organization with two environment-level result blocks. It does not delete or invalidate the earlier `transport-theorem-map.md`; that file remains the historical theorem map for the TRANSPORT subline.

## Paper identity

```text
Environment
=
TRANSPORT
+
Adopt / License
+
Grounded currentness
```

Reader-facing result blocks:

```text
E1  cross-context historical transport
    != source-indexed current qualification

E2  recorded activation provenance
    != license BaseCurrent
    != context Groundedness
```

Central firewall:

```text
No current theorem composes
TRANSPORT qualification
into Adopt license issuance / activation
end to end.
```

## E1 — Environment-relative transport responsibility

### Formation side

Representative declarations:

- `TransportFormationDiscipline`
- `transportHistoricalWarrant`
- `transportStep_newWarrant_exact`
- `transportStep_newWarrant_unqualified`
- `transportStep_newWarrant_notUsable`
- `reachable_transportWarrantsWellFormed`

Safe paper claim:

> A same-profile TRANSPORT formation creates an exact target-context historical child while retaining the exact original and bridge-witness identities as ordered parents; formation itself does not establish current child usability.

### Qualification side

Representative declarations:

- `TransportParentsUsable`
- `qualifyTransport_requires_sourceCurrent`
- `qualifyTransport_sourceContexts_exact`
- `qualifyTransport_evaluation_exact`
- `qualifyTransport_makes_usable`
- `transportFormationQualification_boundary`
- `transportQualification_context_coordinates`

Safe paper claim:

> Explicit qualification checks each stored parent identity at that parent's own historical formation context and writes current usability of the child at its target-context evaluation key.

### Translation-responsibility typing

Representative declarations:

- `transportRootLineage_nonBridge_exact`
- `transportSourceLineage_nonBridge_exact`
- `transportRootLineage_witness_as_bridge`
- `transportSourceLineage_witness_as_bridge`

Safe paper claim:

> Translation-witness ancestry is isolated under `BRIDGE`; at non-BRIDGE roles the represented lineage remains exactly the original lineage.

### Two-hop historical support

Representative declarations:

- `transportTwoHop_scope_conservative`
- `transportTwoHop_strength_nonamplifying`
- two-hop root/source lineage exactness theorems
- `twoHopTransportFormationBoundary`

Safe paper claim:

> Selected represented historical conservation laws compose across exactly two adjacent TRANSPORT formation steps threaded by the exact intermediate child identity.

### E1 non-claims

Do not claim:

- cross-profile transport;
- arbitrary interoperability;
- target activation/adoption from TRANSPORT;
- semantic equivalence or truth of the bridge witness;
- arbitrary `n`-hop closure;
- qualification-chain propagation;
- `Usable -> Entitled`;
- arbitrary temporal persistence.

## E2 — Adopt/currentness responsibility layers

### Historical license record

Representative declarations:

- `CanonicalAdoptLicense`
- `AdoptLicenseRecordDiscipline`
- `AdoptRecordStep.recordAdoptLicense`
- `recordAdoptLicense_newRecord_exact`
- `recordAdoptLicense_projection_exact`
- `recordAdoptLicense_activationTopology_unchanged`
- `recordAdoptLicense_historyReferentsImmutable`
- `reachable_adoptLicensesWellFormed`

Safe paper claim:

> A reachable Adopt-license recording step creates an exact immutable canonical record and projection while leaving activation topology unchanged.

Boundary:

> Record discipline is not entitlement-backed issuance and does not itself require support warrants to be currently usable.

### License BaseCurrent

Representative declarations:

- `AdoptLicenseBaseCurrent`
- `AdoptLicenseRead.baseCurrent`
- `adoptActivationRead_baseCurrent_iff`
- `adoptLicenseBaseCurrent_coordinates`
- `adoptLicenseBaseCurrent_review_scope`
- `adoptLicenseBaseCurrent_support_usable`

Safe paper claim:

> `BaseCurrent` is a non-recursive state-backed predicate over current binding/profile/use, review, scope, and support-usability observations.

Boundary:

> Issuer-context groundedness is intentionally not included in `BaseCurrent`.

### Full license currentness

Representative declarations:

- `AdoptLicenseCurrent`
- `adoptLicenseCurrent_iff`
- `adoptLicenseCurrent_issuer_grounded`

Safe paper claim:

> Full currentness combines the exact stored record, `BaseCurrent`, and `Grounded` currentness of the issuing context.

### Explicit activation

Representative declarations:

- `AdoptActivationStep.adoptContext`
- `adoptContext_requires_currentLicense`
- `adoptContext_activation_exact`
- `adoptContext_historyReferentsImmutable`
- `adoptContext_evaluationTopology_unchanged`
- `adoptContext_enrichedLicenses_unchanged`

Safe paper claim:

> Explicit Adopt activation consumes a current license and records exact target activity/provenance without rewriting warrant evaluation or enriched license history.

### Reachable Grounded closure

Representative declarations:

- `ActiveContextsGrounded`
- `adoptActivationStep_preserves_activeContextsGrounded`
- `reachable_activeContext_grounded`
- `reachable_activeContext_has_bootstrap_chain`
- `reachable_no_active_without_bootstrap`

Safe paper claim:

> Every active context in an activation-reachable state is grounded in the exact state-backed Adopt read and therefore has a finite bootstrap-rooted current activation chain.

### E2 non-claims

Do not claim:

- license record existence implies `BaseCurrent`;
- `BaseCurrent` alone implies full license currentness;
- recorded activation provenance alone implies `Grounded`;
- entitlement-backed license issuance;
- legal/normative authorization;
- arbitrary persistence once invalidation transitions are added;
- challenge/revalidation as part of the Paper 2 formal identity.

## Cross-block firewall

No declaration at the Paper 2 baseline proves:

```text
qualifyTransport(...)
  -> create/issue CanonicalAdoptLicense
```

or:

```text
Usable(transportedChild@Target)
  -> AdoptLicenseCurrent(...)
```

or:

```text
TRANSPORT qualification
  -> adoptContext
  -> Grounded target
```

The two result blocks share the environment theme but remain formally adjacent rather than end-to-end composed.

This is not a theorem gap to fill for expository symmetry.

## Baseline-local monotonicity warning

At formal baseline `4dfa0c19...`, the modeled core transition surface has no challenge/review invalidation transition that destroys existing support usability or marks an existing license stale. Hence Paper 2 proves preservation/monotonicity lemmas for existing `BaseCurrent` and `Grounded` facts over that surface.

These are transition-surface-local results.

Do not write:

```text
BaseCurrent persists forever.
Grounded activation is temporally permanent.
```

Paper 3 later expands the transition surface with invalidation and refresh; those later semantics confirm why the Paper 2 preservation claims must remain scoped.

## Relationship to old P2-R1–P2-R4

The old theorem map remains correct for its TRANSPORT baseline. The environment synthesis changes exposition, not theorem truth.

Mapping:

```text
P2-R1 Exact Cross-Context Formation       \
P2-R2 Source-Context Qualification         >  E1
P2-R3 Translation-Evidence Isolation      /
P2-R4 Two-Hop Conservation               /

Adopt-license record/currentness
+ Adopt activation
+ reachable Grounded closure              -> E2
```

Do not present P2-R1–P2-R4 plus E1/E2 as six headline contributions. E1 and E2 are the current paper-level organization; the P2-R labels remain artifact-level decomposition of E1.

## Permanent Paper 2 firewall

Paper 2 proves responsibility separation inside the represented environment model. It does not prove that the environment model, translation regime, activation-license regime, or profile is adequate.

Therefore:

```text
correct environment-relative execution
!=
adequacy of the represented environment regime
```

is a conceptual boundary, not a new Lean non-implication theorem.

`Q_open` remains outside Paper 2.