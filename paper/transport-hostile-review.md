# Paper 2 Hostile Review and Freeze

Status: final paper-only claim audit for the TRANSPORT manuscript architecture.

Reviewed manuscript: `paper/transport-submission-draft.md`.

Claim surface: `paper/transport-theorem-map.md`.

Related-work boundary: `paper/transport-related-work-freeze.md`.

Kernel baseline remains frozen. This audit may reduce or clarify prose; it does not create formal obligations merely to make the manuscript stronger.

## Verdict

**PASS with wording corrections. Formal trigger: NOT FIRED.**

All material reviewer attacks identified in this pass can be resolved by claim narrowing, terminology correction, or explicit scope language. No indispensable central sentence requires a new Lean theorem.

The four Paper 2 contribution families remain:

```text
P2-R1  Exact Cross-Context Formation
P2-R2  Source-Context Qualification
P2-R3  Translation-Evidence Isolation
P2-R4  Two-Hop Conservation
```

No fifth headline result is required.

---

## Evidence classes

Every manuscript sentence should be readable as one of these classes:

1. **Theorem-backed** — direct statement or conservative paper-level packaging of an existing Lean theorem.
2. **Definitional** — follows from represented kernel definitions such as `transportableClaim`, `transportHistoricalWarrant`, or the lineage transforms.
3. **Mechanized architecture / artifact fact** — module/theorem mapping, CI placeholder rejection, axiom audit, or test/conformance status.
4. **Interpretation** — motivation or responsibility reading that is not itself a theorem; must not be written with theorem-looking implication/non-implication notation.
5. **Related-work positioning** — literature comparison; cannot be inferred from Lean.
6. **Future work / non-claim** — explicitly outside P2-R1–P2-R4.

Do not convert an interpretation or scope warning into a displayed `X ⇏ Y` statement unless the kernel actually proves a non-implication/counterexample theorem.

---

## Attack 1 — “Same-profile cross-context” is being sold as arbitrary interoperability

### Reviewer attack

> The title and representation-crossing language imply transport between arbitrary systems, profiles, logics, or trust domains. The formal model only constrains two contexts inside one profile digest.

### Audit

**Valid risk; corrected in manuscript.**

Machine-backed boundary:

- `TransportFormationDiscipline.originalSameProfile`
- `TransportFormationDiscipline.witnessSameProfile`
- `transportStep_newWarrant_exact`

The manuscript now repeatedly says **same-profile TRANSPORT** and explicitly states that cross-profile transport is not formalized.

### Allowed claim

> The kernel forms a target-context historical child while original and witness remain tied to the same profile snapshot as the formation binding.

### Forbidden strengthening

```text
arbitrary interoperability
cross-profile transport
translation between arbitrary logics
trust-domain interoperability
```

**Formal trigger:** NOT FIRED. The paper can state the narrower result without loss of its central thesis.

---

## Attack 2 — Two-hop composition is being written as arbitrary n-hop closure

### Reviewer attack

> “Compositional” normally suggests closure under arbitrary finite composition. You only prove two adjacent formation steps.

### Audit

**Valid risk; bounded explicitly.**

Machine-backed result:

- `twoHopTransportFormationBoundary`
- pure two-hop conservation theorems in `TransportConservation.lean`

There is no chain datatype, fold, path theorem, or induction over arbitrary `n`.

The manuscript now uses “two-hop composition” and states that “compositional” refers only to the proved two-hop boundary unless a later theorem generalizes it.

### Allowed claim

> The conservation properties hold across two adjacent TRANSPORT formation steps linked by the exact intermediate child identity.

### Forbidden strengthening

```text
for any transport chain
closed under arbitrary composition
n-hop conservation
inductive transport conservation
```

**Formal trigger:** NOT FIRED. Two-hop evidence is sufficient for the current paper thesis.

---

## Attack 3 — Historical two-hop conservation is being confused with currentness propagation

### Reviewer attack

> If `W_1` is used as the original of the second transport, does the theorem prove that usability of `O`, `X_1`, and `X_2` makes `W_2` usable?

### Audit

**No. This is a separate frozen theorem family.**

P2-R4 contains two `Step.transport` formation steps and no `qualifyTransport` step. It recovers historical objects and conservation facts only.

P2-R2 proves currentness at a single explicit qualification boundary. There is no theorem composing qualifications across a transport chain.

### Allowed claim

> Historical conservation composes for two transport formations.

### Forbidden strengthening

```text
Current(O) + Current(X_1) + Current(X_2) -> Current(W_2)
qualification propagates through transport chains
current validity composes with transport
```

`QualificationChainPropagation: FROZEN` remains explicit.

**Formal trigger:** NOT FIRED.

---

## Attack 4 — BRIDGE ancestry is being read as witness truth or semantic adequacy

### Reviewer attack

> Calling `X` “evidence” or saying it “justifies/certifies” a translation suggests that the formalism proves the translation is correct.

### Audit

**Valid wording risk; corrected directly.**

The kernel checks an exact semantic binding:

```text
witness.claim = transportableClaim(mapId, originalId, targetContextId, translatedClaim)
```

and requires `witness.role = BRIDGE`. This is not a semantic adequacy theorem for the map, source claim, target claim, or witness.

The manuscript changed:

```text
evidence that justifies the translation
witness certifies an exact translation map
```

to language about a **separately recorded translation witness** and an **exact binding**.

### Allowed claim

> Witness ancestry is recorded under BRIDGE responsibility and cannot appear as additional non-BRIDGE ancestry.

### Forbidden strengthening

```text
witness proves translation correctness
BRIDGE certifies semantic equivalence
BRIDGE witness is true
translation is adequate because the witness exists
```

**Formal trigger:** NOT FIRED. Adequacy remains outside the represented vocabulary.

---

## Attack 5 — Target historical formation is being read as target adoption/activation

### Reviewer attack

> If the target context “accepts” the translated claim and a child is formed there, isn't the target context active/adopted?

### Audit

**No. The represented responsibilities are distinct.**

`TransportFormationDiscipline.outputAccepted` uses the target context's modeled `accepts` predicate. Neither `Step.transport` nor `Step.qualifyTransport` requires context activation/adoption.

The manuscript now explicitly says that the `accepts` field is a formation predicate and does not mean active/adopted/licensed/entitled.

### Allowed claim

> TRANSPORT may form history in a target context whose represented formation predicate accepts the translated claim.

### Forbidden strengthening

```text
target context is adopted
target context is active
transportability authorizes use in target context
formation activates target context
```

**Formal trigger:** NOT FIRED.

---

## Attack 6 — Qualification/usability is being written as entitlement or authorization

### Reviewer attack

> “Qualified” or “usable” can sound normative. Does P2-R2 prove permission or entitlement to rely on the transported judgment?

### Audit

**No.**

`Usable` is the kernel's exact current evaluation predicate, represented by `LIVE` plus `PLACED` at an exact evaluation key. The paper has no total assembly theorem from current state to entitlement and does not prove a usability-to-entitlement implication.

The manuscript now states this directly in P2-R2 and the Boundaries section.

### Allowed claim

> Explicit `qualifyTransport` makes the child `Usable` at its exact target-context evaluation key.

### Forbidden strengthening

```text
qualification grants authorization
usable means entitled
transported child is licensed
current usability proves admissibility
```

**Formal trigger:** NOT FIRED. Assembly and licensing/adoption remain frozen.

---

## Attack 7 — “Does not replay formation” is being read as formation facts becoming irrelevant

### Reviewer attack

> If qualification does not re-check witness binding, scope, strength, and lineage, are those conditions ignored after formation?

### Audit

**No.**

The later transition omits those premises because the canonical historical object and reachable invariant carry the formation facts. Historical referents remain immutable under qualification.

The manuscript now defines “does not replay” narrowly: the premise is absent from the later transition; the historical formation fact is not declared irrelevant or invalid.

### Allowed claim

> Formation responsibilities are carried by immutable history; qualification discharges the represented current parent-usability responsibility.

### Forbidden strengthening

```text
formation conditions no longer matter
qualification supersedes formation checks
translation binding can be ignored after formation
```

**Formal trigger:** NOT FIRED.

---

## Attack 8 — Scope/strength conservation is being read as delegation, IFC, or trust safety

### Reviewer attack

> Scope narrowing and non-amplifying strength resemble authority attenuation and information-flow relabeling. Are you claiming a new least-privilege or noninterference result?

### Audit

**No. Related-work collision handled by narrowing.**

The formal theorems are about:

- `ScopeNarrowerOrEqual` in the represented historical warrant vocabulary;
- `canonicalEscalationDepth` only where endpoint depths are interpretable.

They are not authorization, trust, noninterference, declassification, or general credential-attenuation theorems.

The manuscript now says so directly in the P2-R4 scope/strength subsections.

### Allowed claim

> The represented scope relation and canonically interpretable escalation depth are non-amplifying across two historical TRANSPORT formations.

### Forbidden strengthening

```text
least privilege is preserved
trust cannot increase
information-flow labels are secure
credentials are attenuated
noninterference is preserved
```

**Formal trigger:** NOT FIRED.

---

## Attack 9 — Kernel semantic identity is being confused with Python representation

### Reviewer attack

> The Python implementation uses serialized `translated_claim.key()` material. Does Lean formalize the same byte/container identity?

### Audit

**No. This was deliberately excluded at T0.**

Lean defines `transportableClaim` structurally over the kernel `Claim` vocabulary. It does not formalize Python JSON/container encoding.

The manuscript states that `transportableClaim` is a kernel-semantic binding and that Python tests are conformance evidence, not a refinement proof.

### Allowed claim

> The Lean kernel formalizes a structural semantic witness binding for TRANSPORT.

### Forbidden strengthening

```text
Lean proves Python Claim.key() correctness
Python TRANSPORT refines Lean
JSON identity is the formal semantic identity
```

`PythonRefinement: FROZEN` remains explicit.

**Formal trigger:** NOT FIRED.

---

## Attack 10 — Context-coordinate language could accidentally add equality or activation assumptions

### Reviewer attack

> Is `original.formationContext` necessarily `witness.formationContext`, or are either necessarily the target context? Must the source contexts be active?

### Audit

**No such assumptions occur in P2-R2/T3.**

`qualifyTransport_sourceContexts_exact` exposes two independent parent-specific formation contexts. `transportQualification_context_coordinates` is specifically phrased to expose the target and parent coordinates without requiring equality among them.

The manuscript now says explicitly that source contexts need not equal one another or the target and need not be active.

### Allowed claim

> Parent-currentness coordinates follow each stored historical parent's own `formationContext`.

### Forbidden strengthening

```text
both parents share one source context
source = target
source contexts are active
```

**Formal trigger:** NOT FIRED.

---

## Attack 11 — Broad provenance language could erase the responsibility-specific result

### Reviewer attack

> “Provenance preservation” is well-established. Is P2-R3 just a new name for generic transformation provenance?

### Audit

**The broad phrase is intentionally avoided.**

P2-R3's actual exact statement is role-indexed:

- for `r != BRIDGE`, final lineage iff original lineage at `r`;
- at `BRIDGE`, witness ancestry is accumulated under the dedicated responsibility role.

The manuscript now says this is more precise than the broad phrase “provenance is preserved” and avoids using that phrase as a contribution claim.

### Allowed claim

> TRANSPORT isolates translation-witness ancestry under BRIDGE while preserving exact non-BRIDGE ancestry in the represented lineage relations.

### Forbidden strengthening

```text
TRANSPORT preserves provenance generally
all provenance semantics are conserved
translation preserves meaning
```

**Formal trigger:** NOT FIRED.

---

## Attack 12 — “Mechanized separation” could be mistaken for machine-proved pairwise non-implications

### Reviewer attack

> Does the paper prove countermodels showing that origin, bridge responsibility, target history, and current qualification fail to imply one another?

### Audit

**No such pairwise non-implication theorem is claimed.**

The paper's separation language is architectural/relational: these responsibilities are represented by distinct fields, predicates, transitions, and theorem premises/conclusions. The positive machine results establish their exact boundaries.

The manuscript explicitly instructs authors to explain this in prose rather than theorem-looking `X ⇏ Y` displays.

### Allowed claim

> The kernel represents and reasons about these responsibilities separately.

### Forbidden strengthening

```text
Lean proves Origin ⇏ TranslationResponsibility
Lean proves Usable ⇏ Entitled
Lean proves HistoricalTransport ⇏ CurrentTransport
```

unless a future explicit counterexample/non-implication theorem is added.

**Formal trigger:** NOT FIRED.

---

## Headline theorem audit

### P2-R1

Status: **SUPPORTED at stated scope.**

Must retain:

- local exact `Step.transport` theorem;
- same-profile formation discipline;
- target historical context;
- exact `[original,witness]` parents;
- role inherited from original;
- fresh-child non-usability only with `Reachable` support.

Must not add activation/adoption/adequacy claims.

### P2-R2

Status: **SUPPORTED at stated scope.**

Must retain:

- parent currentness in pre-state;
- each parent's own `formationContext`;
- exact child target key in post-state;
- adjacent lifecycle only;
- no entitlement or temporal persistence.

### P2-R3

Status: **SUPPORTED at stated scope.**

Must retain:

- root and source lineage separately;
- non-BRIDGE exactness;
- witness ancestry under BRIDGE only;
- no truth/equivalence/adequacy interpretation.

### P2-R4

Status: **SUPPORTED at stated scope.**

Must retain:

- exactly two adjacent historical TRANSPORT formation steps;
- second `originalId = first childId`;
- scope relation only;
- conditional canonical escalation-depth result;
- exact two-hop root/source lineage results;
- no qualification-chain or arbitrary n-hop claim.

---

## Related-work audit

The following broad areas are treated as prior art, not novelty claims:

```text
proof/theorem transfer
institution/logical translation
contextual logic / ontology bridge rules
schema/ontology mapping
provenance under transformations
proof-carrying authentication
delegation and attenuation
information-flow relabeling/downgrading
trust/interoperability mechanisms
```

The manuscript's novelty language must stay at the narrow P2-R1–P2-R4 conjunction. It must not claim “first” for any broad representation-crossing category.

---

## Freeze table

```text
Paper 2 P2-R1–P2-R4:             FROZEN CLAIM SURFACE
Paper 2 manuscript architecture: FROZEN AFTER HOSTILE REVIEW
CrossProfileTransport:           FROZEN
TargetAdoption/Activation:       FROZEN
ArbitraryTemporalClosure:        FROZEN
QualificationChainPropagation:   FROZEN
NHopTransportChain:              FROZEN
PythonRefinement:                FROZEN
Assembly:                        FROZEN
License/Adopt:                   FROZEN
Challenge/Revalidation:          FROZEN
```

The next paper work may include venue formatting, bibliography completion, visual rendering, compression, anonymization, and artifact packaging. Those tasks may narrow wording but may not broaden P2-R1–P2-R4.

---

## Formal-trigger policy after freeze

A formal phase may reopen only if a concrete manuscript sentence is all of:

1. central to the paper's thesis;
2. currently unsupported by P2-R1–P2-R4;
3. impossible to remove or safely narrow;
4. not merely an aesthetically stronger generalization.

Current audit result:

```text
Cross-profile trigger:              NOT FIRED
Activation/adoption trigger:        NOT FIRED
Temporal-closure trigger:           NOT FIRED
Qualification-chain trigger:        NOT FIRED
n-hop trigger:                      NOT FIRED
Python-refinement trigger:          NOT FIRED
Assembly/license trigger:           NOT FIRED
Challenge/revalidation trigger:     NOT FIRED
New Lean theorem trigger:           NOT FIRED
```

## Final paper-freeze verdict

**Kernel decision:** remain stopped.

**Claim decision:** P2-R1–P2-R4 are sufficient for the current manuscript thesis.

**Writing decision:** proceed only with venue-specific presentation work, completed bibliography, rendered figures/tables, artifact packaging, and final compression.

**Research decision:** qualification-chain propagation, n-hop transport, cross-profile transport, activation/adoption, temporal closure, and executable refinement remain independent future theorem families rather than defects of Paper 2.
