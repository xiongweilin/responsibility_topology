# Responsibility Across Environment Boundaries

## Historical Transport, Source-Indexed Qualification, and Grounded Adoption in a Mechanized Epistemic Kernel

Status: Paper 2 environment-synthesis draft. Formal/kernel work remains frozen.

Formal semantic baseline:

```text
4dfa0c19e6fb40947e3fe5dd5b8600c55e1ad424
```

This manuscript supersedes the older TRANSPORT-only submission draft as the current Paper 2 writing baseline. The older `transport-*` files remain historical claim/audit records for the TRANSPORT subline and are not rewritten retroactively.

The paper has exactly two reader-facing result blocks:

```text
E1  cross-context historical transport
    != source-indexed current qualification

E2  recorded activation provenance
    != license BaseCurrent
    != context Groundedness
```

The central firewall is equally important:

```text
TRANSPORT qualification
    -/->
Adopt license recording / issuance / activation
```

No unified end-to-end theorem currently connects those two blocks, and this paper does not require one.

---

## Abstract

Crossing an environment boundary creates more than one responsibility relation. A transported judgment has an origin, a separately recorded translation witness, a target historical identity, and a later currentness question whose coordinates need not be the target coordinates. A system that activates a target environment adds a second decomposition: an activation may have historical provenance, while the license supporting that activation has its own state-backed currentness conditions, and the target environment is current only when the resulting activation chain is grounded.

We mechanize these distinctions in a state-backed epistemic kernel. The first result block studies same-profile `TRANSPORT`. Formation records an exact target-context historical child with ordered original and bridge-witness parents, while explicit qualification later checks those stored parents at their own historical formation contexts. Translation-witness ancestry is isolated under a dedicated `BRIDGE` responsibility role, and selected historical conservation properties compose across two adjacent transport formations. The second result block studies Adopt activation. A canonical Adopt-license record is distinct from its state-backed `BaseCurrent` predicate; full license currentness additionally requires a grounded issuing context; explicit Adopt activation consumes that current license and records activation provenance; and every reachable active context is proved grounded in the resulting license/activation read.

The contribution is the separation and composition of environment-indexed responsibility boundaries, not a theorem of arbitrary interoperability, entitlement, license issuance, or runtime refinement. In particular, the mechanization does not prove a unified pipeline from TRANSPORT qualification to Adopt-license issuance or target activation. That missing bridge is treated as an explicit scope boundary rather than repaired for expository convenience.

---

## 1. Environment as a responsibility axis

Paper 1 studies a relation on one object axis:

```text
historical formation / parent identity
!=
state-indexed current qualification
```

Paper 2 asks what changes when responsibility crosses an environment boundary. The environment axis introduces two distinct questions.

First, when a judgment is transported from one context to another, which relations remain attached to immutable historical objects, and where must current responsibility be discharged? The answer in the represented kernel is not “at the target because the target is where the child lives.” Historical formation records a target child, but later parent-currentness checks follow the stored parent identities back to those parents' own historical formation contexts.

Second, when a context becomes active through an Adopt relation, which part of that activity is historical provenance, which part is non-recursive license currentness, and which part is recursive environment currentness? The kernel keeps these separate as activation provenance, `AdoptLicenseBaseCurrent`, and `Grounded`.

The paper therefore treats environment crossing as two coupled but non-unified result blocks.

### E1 — transport boundary

```text
historical target formation
+
exact original / bridge-witness dependency

!=

current qualification of those parent identities
at parent-specific source coordinates
```

### E2 — adoption/currentness boundary

```text
recorded activation provenance
!=
license BaseCurrent
!=
context Groundedness
```

The point is not that every pair is accompanied by a formal non-implication countermodel. The mechanized claim is architectural and positive: these responsibilities live in distinct records, predicates, transition premises, transition effects, and theorem conclusions.

---

## 2. Model boundary and notation

The current Paper 2 formal identity is PR #41 merge `4dfa0c19...`. It includes the earlier TRANSPORT formation/qualification/conservation line plus the later Adopt-license/currentness/activation closure.

The relevant state components are deliberately heterogeneous.

Historical warrant state records canonical warrant identity, constructor, role, formation profile/context, ordered parents, scope, and lineage. Current warrant evaluation is stored separately and gives the kernel predicate `Usable` at an exact evaluation key.

Adopt extends the stable canonical state with enriched immutable license records:

```text
CanonicalAdoptLicense
  issuer
  target
  profileDigest
  moveScope
  support
```

The record is not itself a theorem that the license is currently valid. Currentness is read from the present canonical state.

For a license record `L` and license identifier `ell`, `AdoptLicenseBaseCurrent` requires represented non-recursive current conditions including canonical binding/context coordinates, profile/use agreement, absence of a review flag, scope compatibility, and current usability of each recorded support warrant at the issuer coordinate.

Full currentness is separate:

```text
AdoptLicenseCurrent(R, ell)
  := record exists
     + AdoptLicenseBaseCurrent
     + Grounded(issuer)
```

The recursive issuer edge is therefore not hidden inside `BaseCurrent`.

`Grounded` is a least, bootstrap-rooted activation relation. A context may be grounded directly by bootstrap provenance, or through an Adopt activation whose exact license is base-current and whose issuer is itself grounded.

Throughout the paper, `Usable`, `BaseCurrent`, and `Grounded` are kernel predicates. They are not synonyms for legal authorization, normative permission, truth, or end-to-end entitlement.

---

# Part I — E1: Historical transport is not source-indexed current qualification

## 3. Exact same-profile TRANSPORT formation

A TRANSPORT formation consumes an exact original historical warrant, an exact `BRIDGE` witness, a target context, a map identifier, and a translated claim. The represented formation discipline includes:

```text
original in the selected profile snapshot
witness in the same profile snapshot
witness role = BRIDGE
exact transportableClaim binding
target modeled-accepts predicate
output scope <= original scope
output scope <= witness scope
output role = original role
canonically interpretable escalation strength does not amplify
parents = [original, witness]
```

The resulting child is a new immutable historical object in the target context. Formation does not itself write a current evaluation fact for that child.

Representative Lean surfaces include:

```text
transportHistoricalWarrant
TransportFormationDiscipline
transportStep_newWarrant_exact
transportStep_newWarrant_unqualified
transportStep_newWarrant_notUsable
reachable_transportWarrantsWellFormed
```

The target context's modeled `accepts` predicate is a formation predicate only. It does not imply that the target is active, adopted, licensed, or entitled.

The witness's exact binding is likewise a represented historical responsibility. It does not establish semantic equivalence, truth, or adequacy of the translation.

## 4. Current responsibility follows stored parent identities

TRANSPORT qualification is a separate transition. It recovers the historical transport child and its exact stored parents, then checks current usability of those same parent identities at each parent's own historical formation context.

For original historical object `O`, witness `X`, profile `pi`, use `u`, and identifiers `o,x`:

```text
Usable(S, (pi, O.formationContext, u, o))
Usable(S, (pi, X.formationContext, u, x))
```

are the current premises.

The post-state write is instead at the transported child's target-context key:

```text
(pi, child.formationContext, u, childId)
```

Representative Lean surfaces include:

```text
TransportParentsUsable
qualifyTransport_requires_sourceCurrent
qualifyTransport_sourceContexts_exact
qualifyTransport_evaluation_exact
qualifyTransport_makes_usable
transportFormationQualification_boundary
transportQualification_context_coordinates
```

The original, witness, and target contexts are not required to be equal. Nor does qualification require those source contexts to be active.

The key Paper 2 environment result is therefore not merely “formation precedes qualification.” It is that environment coordinates split:

```text
where the child is historically formed
!=
where each historical parent is currently checked
```

The same stored parent identities participate in both relations, but the relations are different.

## 5. Historical translation responsibility remains typed

TRANSPORT also preserves a role-indexed distinction between original ancestry and translation-witness ancestry.

For root lineage, the represented transform has the shape:

```text
L_child(r,z)
  iff
  L_original(r,z)
  or
  (r = BRIDGE and exists r'. L_witness(r',z))
```

and analogously for source lineage.

Thus for every `r != BRIDGE`:

```text
L_child(r,z) iff L_original(r,z)
```

while witness ancestry may enter under `BRIDGE`.

Representative Lean surfaces include:

```text
transportRootLineage_nonBridge_exact
transportSourceLineage_nonBridge_exact
transportRootLineage_witness_as_bridge
transportSourceLineage_witness_as_bridge
```

This should not be summarized as a generic theorem that “provenance is preserved.” The exact result is narrower: translation-specific dependency is typed under `BRIDGE`, preventing it from silently appearing as additional non-BRIDGE ancestry.

## 6. Two-hop historical conservation

The historical transport laws compose across two adjacent formation steps when the second step uses the exact first child as its original identity:

```text
O + X1 -> W1@cB
W1 + X2 -> W2@cC
```

The represented results include:

```text
Scope(W2) <= Scope(O)
```

and, when endpoint escalation depths are canonically interpretable:

```text
Depth(W2) <= Depth(O)
```

For non-BRIDGE roles, final lineage remains exactly the original lineage. Under BRIDGE, translation-witness ancestry from both hops is accumulated according to the represented lineage transform.

Representative Lean surfaces include:

```text
transportTwoHop_scope_conservative
transportTwoHop_strength_nonamplifying
transportRootLineageTwoHop_nonBridge_exact
transportRootLineageTwoHop_bridge_exact
transportSourceLineageTwoHop_nonBridge_exact
transportSourceLineageTwoHop_bridge_exact
twoHopTransportFormationBoundary
```

This is exactly a two-hop historical theorem. It is not an arbitrary `n`-hop closure result and contains no multi-hop qualification conclusion.

## 7. E1 result block

The older Paper 2 theorem map exposed four TRANSPORT result families. The environment synthesis preserves their machine content but compresses their reader-facing role into one result block:

```text
E1 — Cross-context historical transport
     is distinct from source-indexed current qualification.
```

Its internal support is:

```text
exact target historical formation
+
source-context qualification
+
typed translation-witness lineage
+
two-hop historical conservation
```

The paper should not present these as four independent conceptual contributions. Together they establish one environment-boundary decomposition.

---

# Part II — E2: Activation provenance, license currentness, and grounded context currentness

## 8. Recording an Adopt license is not establishing its currentness

The Adopt extension first introduces a canonical immutable license record. `AdoptLicenseRecordDiscipline` checks the narrow record shape: canonical issuer/target coordinates under the represented binding/use, scope compatibility, and existence of each historical support warrant.

A reachable `recordAdoptLicense` step inserts the enriched record and its canonical two-field activation-license projection. It does not activate the target context.

Representative Lean surfaces include:

```text
CanonicalAdoptLicense
AdoptLicenseRecordDiscipline
AdoptRecordStep.recordAdoptLicense
recordAdoptLicense_newRecord_exact
recordAdoptLicense_projection_exact
recordAdoptLicense_activationTopology_unchanged
recordAdoptLicense_historyReferentsImmutable
reachable_adoptLicensesWellFormed
```

This is deliberately a record boundary, not entitlement-backed issuance. In particular, record discipline requires historical support referents to exist, but does not itself require those supports to be currently usable.

Therefore:

```text
recorded license provenance
```

and

```text
current license responsibility
```

are different layers.

## 9. BaseCurrent is a state-backed non-recursive currentness layer

`AdoptLicenseBaseCurrent` reads current state. For the exact recorded license it requires, among other represented conditions:

```text
canonical issuer / target / binding coordinates
profile/use agreement
not reviewRequired(licenseId)
move scope remains within binding scope
all recorded support warrants currently Usable at issuer coordinate
```

Representative Lean surfaces include:

```text
AdoptLicenseBaseCurrent
AdoptLicenseRead.baseCurrent
adoptActivationRead_baseCurrent_iff
adoptLicenseBaseCurrent_coordinates
adoptLicenseBaseCurrent_review_scope
adoptLicenseBaseCurrent_support_usable
```

The issuing context's own grounded currentness is intentionally absent from this predicate. This is a responsibility boundary, not an omission to be patched.

At the Paper 2 formal baseline, the currently modeled core transition surface contains no review/invalidation transition. As a consequence, existing `BaseCurrent` facts are monotone across that particular surface. This is not an arbitrary temporal-persistence claim. Paper 3 later introduces invalidation and refresh, but those later semantics must not be imported backward into the Paper 2 theorem identity.

## 10. Full license currentness additionally requires a grounded issuer

The full currentness predicate is:

```text
AdoptLicenseCurrent(R, ell)
  iff
  exists L,
    R.license ell = some L
    and AdoptLicenseBaseCurrent(R.state, ell, L)
    and Grounded(R.toActivationRead, L.issuer)
```

Representative Lean surfaces include:

```text
AdoptLicenseCurrent
adoptLicenseCurrent_iff
adoptLicenseCurrent_issuer_grounded
adoptActivationRead_issuer_exact
```

Thus the paper's second environment cut is explicit:

```text
license BaseCurrent
!=
issuer-context Groundedness
```

The first is non-recursive state-backed currentness of the license. The second is a recursive activation-chain responsibility.

## 11. Adopt activation consumes current license responsibility

The explicit Adopt transition does not replay license recording. It consumes:

```text
exact canonical Adopt-license record
exact target identity
AdoptLicenseBaseCurrent
Grounded issuing context
target currently inactive
fresh activation provenance slot
```

and writes only:

```text
target active
activationProvenance(target) = adopt(licenseId)
```

Representative Lean surfaces include:

```text
AdoptActivationStep.adoptContext
adoptContext_requires_currentLicense
adoptContext_activation_exact
adoptContext_historyReferentsImmutable
adoptContext_evaluationTopology_unchanged
adoptContext_enrichedLicenses_unchanged
```

This separates historical activation provenance from the currentness obligations that justify using that provenance as a grounded activation edge.

In particular:

```text
activationProvenance(target) = adopt(ell)
```

is not itself the definition of `Grounded(target)`.

## 12. Reachability closes the active-context side with Groundedness

The final Paper 2 formal stage connects reachable activation to the previously semantic `Grounded` relation.

The state-level invariant is:

```text
ActiveContextsGrounded(A)
  := every active context in A is Grounded
     in A's exact Adopt-license activation read.
```

One-step preservation distinguishes three cases:

```text
old active context
  -> preserve prior Grounded derivation

new core activation
  -> exact bootstrap boundary

new Adopt activation
  -> exact current license + grounded issuer
```

The main reachable theorem is:

```text
reachable_activeContext_grounded
```

which proves that every active context in an `AdoptActivationReachable` state is grounded in the exact state-backed read.

Consequences include:

```text
reachable_activeContext_has_bootstrap_chain
reachable_no_active_without_bootstrap
```

Therefore a reachable active context cannot be supported solely by a cycle of adopted activations with no finite bootstrap-rooted chain.

This is the closure result needed by Paper 2. It does not prove target entitlement, normative authorization, or arbitrary persistence under future invalidation transitions.

## 13. E2 result block

The second reader-facing result is:

```text
E2 — Recorded activation provenance,
     license BaseCurrent,
     and context Groundedness
     are distinct responsibility layers.
```

Its positive structure is:

```text
historical license record
    |
    | current state observations
    v
license BaseCurrent
    |
    | grounded issuer
    v
full AdoptLicenseCurrent
    |
    | explicit Adopt activation
    v
recorded active target + provenance
    |
    | reachable closure theorem
    v
Grounded target context
```

This is not a single primitive “validity” bit. It is a typed currentness stack over immutable records and explicit activation history.

---

# Part III — The environment synthesis and its firewall

## 14. What E1 and E2 jointly establish

E1 and E2 are related because both concern responsibility across environments, but they solve different cuts.

E1 concerns a transported historical judgment:

```text
origin / witness / target history
vs
parent-specific current qualification coordinates
```

E2 concerns environment activation:

```text
license record / license currentness / issuer grounding / target grounding
```

Together they justify the Paper 2 research identity:

```text
Environment
=
TRANSPORT
+
Adopt / License
+
Grounded currentness
```

At the conceptual level the shared principle is:

> Crossing an environment boundary should not collapse persistent historical responsibility into current responsibility at the destination environment.

The transport child can be historical at the target while its stored parents are checked elsewhere. An Adopt activation can be historically recorded while its license currentness and recursive groundedness remain separate responsibilities.

## 15. The missing end-to-end bridge is explicit

The formal development does not prove a theorem of the form:

```text
TRANSPORT qualification
+
transported child Usable at target
    ->
canonical Adopt-license issuance
    ->
Adopt activation of target
    ->
Grounded target
```

Nor does it prove that a transported warrant automatically appears in the support list of an Adopt license.

The reasons are structural:

1. TRANSPORT qualification writes current warrant evaluation state.
2. Adopt license recording is a separate extension transition with its own record discipline.
3. The record layer is explicitly not entitlement-backed issuance.
4. Adopt activation consumes a current license but does not prove where that license ought to have come from.
5. No theorem assembles transported usability, entitlement, license issuance, and activation into one pipeline.

This is the central Paper 2 firewall:

```text
E1 and E2 are compatible adjacent responsibility layers,
but they are not currently connected by an end-to-end theorem.
```

The paper should not reopen Lean merely to make a cleaner diagram.

## 16. Claim boundaries

Paper 2 does not claim:

- cross-profile TRANSPORT;
- arbitrary interoperability between logics, organizations, or trust domains;
- semantic adequacy or truth of translation witnesses;
- arbitrary-length transport-chain closure;
- multi-hop qualification propagation;
- target entitlement from `Usable`;
- entitlement-backed Adopt-license issuance;
- a theorem deriving an Adopt license from a transported child;
- a theorem deriving Adopt activation from TRANSPORT qualification;
- a total `CanonicalState -> LicensingRead -> Entitled` assembly;
- Python/runtime operational refinement;
- challenge, invalidation, repair, or revalidation semantics as part of the Paper 2 identity;
- arbitrary temporal persistence after future invalidation is added;
- adequacy of the represented profile, translation map, license regime, or activation regime;
- `Q_open` or `Q_close`.

The absence of these results is not concealed by the synthesis.

## 17. Relationship to Papers 1 and 3

The three papers can now be compared on one research axis.

```text
Paper 1 — Object / identity
  persistent historical relation
  != state-indexed current qualification

Paper 2 — Environment
  target historical transport
  != source-indexed current qualification

  activation provenance
  != license BaseCurrent
  != context Groundedness

Paper 3 — Change
  preserved canonical history
  != invalidated / restored current responsibility
```

Thus:

```text
Object -> Environment -> Change
```

is a better description of the research progression than:

```text
INFER -> TRANSPORT -> challenge
```

Paper 3 later changes the transition surface by adding invalidation and repair. Those later theorems should not be used to retroactively strengthen Paper 2. Paper 2's monotonicity lemmas are explicitly local to its pre-invalidation transition surface.

## 18. Artifact and theorem organization

The reader-facing theorem hierarchy is only E1 and E2.

The older P2-R1–P2-R4 names remain useful as an artifact map for the TRANSPORT half. Adopt-side theorem names should likewise stay in artifact tables rather than becoming additional headline contributions.

A compact mapping is:

| Result block | Representative formal support |
| --- | --- |
| E1 | `transportStep_newWarrant_exact`; `transportFormationQualification_boundary`; `qualifyTransport_sourceContexts_exact`; non-BRIDGE lineage exactness; `twoHopTransportFormationBoundary` |
| E2 | `recordAdoptLicense_activationTopology_unchanged`; `adoptLicenseCurrent_iff`; `adoptContext_requires_currentLicense`; `adoptContext_activation_exact`; `reachable_activeContext_grounded`; bootstrap-chain/no-self-support consequences |

Formal semantic baseline remains `4dfa0c19...` unless an explicit new-paper theorem need appears. This environment synthesis is paper work only.

---

## Conclusion

Responsibility across an environment boundary cannot be represented faithfully by moving a single “valid” flag from source to target.

The mechanized TRANSPORT line separates target historical formation from source-indexed current qualification over the same stored parent identities, while keeping translation-witness ancestry typed under `BRIDGE`. The Adopt line separately distinguishes historical license/activation provenance, non-recursive license `BaseCurrent`, recursive issuer grounding, and reachable target `Groundedness`.

The resulting Paper 2 claim is intentionally incomplete in one place: no theorem connects TRANSPORT qualification to entitlement-backed license issuance and Adopt activation end to end. Preserving that gap is part of the contribution discipline. The paper identifies which environment responsibilities are mechanized and which handoff remains external, rather than using prose to manufacture a pipeline that the formal model does not contain.