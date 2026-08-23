# Responsibility Across Representation Boundaries

## A Mechanized Separation of Origin, Translation Evidence, Target History, and Current Qualification

Status: Paper 2 architecture draft. Venue formatting, bibliography style, anonymization, and final title remain unfrozen.

Formal paper result surface: `paper/transport-theorem-map.md`.

Running-example architecture: `paper/transport-running-example.md`.

Related-work boundary: `paper/transport-related-work-freeze.md`.

---

## Abstract

A judgment that crosses a representation or context boundary acquires at least two different kinds of dependency: dependency on the judgment being translated and dependency on evidence that justifies the translation. A stateful system adds a further distinction. The historical parents that explain how a target judgment was formed need not be the coordinates at which those parents are currently usable. Conflating these relations makes it difficult to state what a translation step preserves, what a later qualification step must check, and which dependencies belong to translated content rather than to translation evidence.

We study this separation in a finite mechanized kernel for **same-profile TRANSPORT**. A TRANSPORT formation creates an exact historical child at a target context from an original warrant and a `BRIDGE` witness. The child inherits the original role and records the two parent identities exactly, while the witness's ancestry may enter the child only under `BRIDGE` responsibility. Formation does not establish current usability. A separate qualification transition checks each stored parent at that parent's own historical formation context and then establishes usability of the child at its target-context key.

We prove four result families. First, TRANSPORT formation has an exact canonical historical shape and preserves modeled scope and escalation-strength restrictions. Second, qualification is source-indexed: current responsibility follows the stored parent identities back to their own formation contexts. Third, translation evidence is isolated in lineage: away from `BRIDGE`, transported ancestry is exactly the original ancestry. Fourth, these historical conservation laws compose across two adjacent TRANSPORT formation steps linked by the exact intermediate child identity: scope and canonically interpretable escalation depth do not amplify, non-`BRIDGE` ancestry remains exact, and both translation witnesses accumulate only under `BRIDGE` responsibility.

The contribution is not a new general theory of proof transfer, contextual logic, ontology mapping, provenance transformation, delegation, or relabeling. Those areas have substantial prior work. The narrower result is a machine-checked responsibility decomposition showing that representation crossing can retain separate origin identity, translation-evidence responsibility, target historical identity, and source-indexed current qualification without collapsing them into one relation.

---

## 1. Introduction

Systems that transform judgments across representations often use a single word—*translation*, *mapping*, *transport*, *conversion*—for several logically different responsibilities. Suppose a judgment `O` is expressed in context `c_A`, a bridge witness `X_1` certifies an exact translation map, and the system forms a new judgment `W_1` in context `c_B`. At least three historical facts are now present. `W_1` was formed from `O`; the formation also depended on `X_1`; and `W_1` is a distinct target historical object rather than a mutation of `O`.

A stateful system introduces a fourth responsibility. Later use of `W_1` may depend on whether its historical parents are *currently usable*. That question has coordinates. Should `O` be checked at the target context `c_B`, simply because `W_1` lives there? Or should current responsibility follow `O` back to the context in which `O` was formed? The same question applies independently to the bridge witness.

The kernel studied here takes the latter view. Historical formation and current qualification are different transition boundaries. TRANSPORT formation records an exact target-context historical child. Qualification later consults the stored original and bridge-witness identities at their respective historical formation contexts. The target context is where the child is formed and where the child becomes usable after explicit qualification; it is not silently substituted for the parents' currentness coordinates.

This distinction matters because representation crossing has more structure than ordinary same-context derivation. In an ordinary inference, all parent-currentness checks may share the child's context. Under TRANSPORT, the original, witness, and target context coordinates need not coincide. The resulting responsibility geometry is therefore not just “a derivation with a different constructor.” The translation boundary separates four roles that are easy to conflate:

- the historical identity of the source judgment;
- the historical responsibility of the translation witness;
- the historical identity of the target judgment;
- the current contexts at which the stored parents must remain usable.

The second issue is conservation. If a judgment is transported from `c_A` to `c_B`, and the resulting historical child is transported again from `c_B` to `c_C`, what properties can be shown to survive both crossings? We focus on three represented properties. Scope may only narrow. Canonically interpretable escalation depth may not increase. Most importantly, translation evidence must not masquerade as the original content/source ancestry: non-`BRIDGE` lineage remains exact, while witness ancestry accumulates only under `BRIDGE` responsibility.

### 1.1 Running example

We use one same-profile chain throughout:

```text
c_A -- X_1 / m_1 --> c_B -- X_2 / m_2 --> c_C
```

`O` is the original historical warrant. `X_1` is the `BRIDGE` witness for the first map and target. Formation produces `W_1` at `c_B`. A second witness `X_2` supports formation of `W_2` at `c_C`, with `W_1` used as the exact original identity of the second TRANSPORT event.

Figure 1 presents one hop and separates the historical layer from the current-responsibility layer. Figure 2 later presents the two-hop historical composition without adding a qualification chain. This separation is deliberate: current qualification propagation across multiple transported children is outside the present theorem surface.

### 1.2 Results

The paper has four headline result families.

**P2-R1 — Exact Cross-Context Formation.** A TRANSPORT step recovers the exact canonical binding, target context, original, witness, formation discipline, and target historical child. The child is formed in the target context, inherits the original role, and has parents exactly `[original,witness]`. Formation itself writes no current evaluation; reachable fresh-child results show the new child is not usable merely because it was formed.

**P2-R2 — Source-Context Qualification.** A `qualifyTransport` step requires the exact stored original and bridge-witness identities to be currently usable at their own historical formation contexts. The step writes `LIVE/PLACED` at the transported child's exact target-context key. An adjacent formation/qualification theorem witnesses the separation: after formation the historical child exists but is not usable at the target key; at qualification pre-state the two stored parents are usable at their own source coordinates; after explicit qualification the child is usable at the target coordinate.

**P2-R3 — Translation-Evidence Isolation.** TRANSPORT preserves the original role-indexed root and external-source ancestry. Any ancestry supplied by the translation witness may enter only under `BRIDGE`. Consequently, for every non-`BRIDGE` role, transported lineage is exactly the original lineage at that role. For two hops, witness ancestry from both translations accumulates exactly under `BRIDGE`, while non-`BRIDGE` ancestry remains exactly that of the initial original.

**P2-R4 — Two-Hop Conservation.** Two adjacent historical TRANSPORT formation steps compose through the exact intermediate child identity. The final scope is no wider than the initial original scope. When endpoint escalation depths are canonically interpretable, the final depth is no greater than the original. Root and source lineage obey the two-hop exactness laws of P2-R3. The theorem is intentionally two-hop rather than an arbitrary-length path result.

### 1.3 Scope of the contribution

The paper is deliberately narrower than several neighboring areas. Theorem provers already transfer results across related representations. Institution theory and heterogeneous specification already formalize translations between logical systems. Distributed description logics and contextual ontologies already use mappings and bridge rules. Database systems already propagate provenance through transformations and schema mappings. Authorization systems already support proof-carrying requests, delegation, attenuation, and chained credentials. Information-flow systems already formalize safe relabeling and controlled downgrading.

We therefore do not claim novelty for representation crossing, bridge rules, proof transport, provenance-preserving transformation, attenuation, or interoperability in general. The contribution is the represented responsibility cut and its mechanized conservation results inside this kernel.

### 1.4 Non-goals

The current paper does not formalize or prove:

- cross-profile TRANSPORT;
- target-context activation, adoption, licensing, or entitlement;
- arbitrary temporal persistence;
- current qualification propagation through a multi-hop transport chain;
- arbitrary `n`-hop transport closure;
- challenge, invalidation, revision, or revalidation semantics;
- a refinement theorem from the Python reference implementation to Lean;
- semantic adequacy of translation maps or bridge witnesses.

These are not hidden prerequisites of P2-R1–P2-R4.

---

## 2. Model and Responsibility Decomposition

### 2.1 Historical warrants and current evaluation

[Section skeleton]

Introduce only the vocabulary needed by Paper 2: historical warrant identity, role, scope, constructor, ordered parents, formation profile digest, formation context, root/source lineage, evaluation key, and `Usable`.

State the inherited state principle from the preceding work: canonical historical identity and current usability are represented separately. Avoid re-presenting the full Paper 1 result catalog.

### 2.2 Same-profile TRANSPORT

Define the semantic translation witness `transportableClaim(map, original, target, translatedClaim)` at the level of structured claims. Explicitly state that this is a kernel-semantic binding and not Python's JSON `Claim.key()` encoding.

Present `TransportFormationDiscipline` as the formation responsibility surface:

```text
same-profile original
same-profile witness
witness role = BRIDGE
exact semantic witness binding
target accepts translated claim
scope <= original scope
scope <= witness scope
output role = original role
canonical escalation strength non-amplifying
parents = [original,witness]
```

No current usability or target activation premise appears here.

### 2.3 Why four relations are kept distinct

Use Figure 1 and Table 1.

Explain in prose rather than theorem-looking non-implication notation:

- source parentage is a historical relation;
- BRIDGE contribution is a lineage-responsibility relation;
- target formation creates a new historical identity;
- qualification later evaluates stored parent identities at parent-specific context coordinates.

---

## 3. Exact Cross-Context Historical Formation — P2-R1

### 3.1 Exact formation theorem

State `transportStep_newWarrant_exact` in paper notation.

Suggested compact statement:

Let

```text
sigma -- transport(d,b,c_t,m,o,x,q,s) --> sigma'
```

be one kernel step. Then there exist canonical binding `B`, target context `C_t`, original `O`, and witness `X` such that the pre-state contains those exact referents, the transport formation discipline holds, and:

```text
Hist_sigma'(d) =
  transportHistoricalWarrant(m,B.profile,c_t,o,x,O,X,q,s).
```

Immediately unpack only the paper-relevant consequences: target formation context, same profile digest, original role, exact ordered parents, scope restrictions, strength restriction, and lineage transform.

### 3.2 Formation is not qualification

Use `transportStep_evaluationTopology_unchanged` and the reachable supporting results `transportStep_newWarrant_unqualified` / `transportStep_newWarrant_notUsable`.

Preserve the scope distinction:

- exact formation: local single-step theorem;
- fresh-child non-usability: reachable theorem.

### 3.3 Responsibility consequence

Formation decides the historical explanation of the transported judgment. It does not decide whether the target judgment is currently usable, adopted, or entitled.

---

## 4. Source-Context Current Qualification — P2-R2

### 4.1 Dedicated currentness predicate

Define the paper reading of `TransportParentsUsable`:

```text
Usable(sigma,(pi,O.formationContext,u,o))
and
Usable(sigma,(pi,X.formationContext,u,x)).
```

Emphasize that these coordinates come from the historical parent objects, not from the target child context.

### 4.2 Qualification theorem

State `qualifyTransport_requires_sourceCurrent`, `qualifyTransport_sourceContexts_exact`, and `qualifyTransport_evaluation_exact` as one paper result family rather than three contributions.

Qualification reads immutable child history only far enough to identify the TRANSPORT constructor, exact two stored parents, profile, and target context. It does not replay formation checks such as exact translation binding, target acceptance, scope, strength, or lineage.

### 4.3 Adjacent lifecycle boundary

State `transportFormationQualification_boundary` over exactly two adjacent steps:

```text
sigma_0 --TRANSPORT formation--> sigma_1
sigma_1 --TRANSPORT qualification--> sigma_2
```

The paper conclusion is:

```text
historical child exists in sigma_1
child not usable at target key in sigma_1
original usable at original.formationContext in sigma_1
witness usable at witness.formationContext in sigma_1
child usable at target key in sigma_2
```

Do not generalize this to arbitrary intervening transitions.

---

## 5. Translation-Evidence Isolation — P2-R3

### 5.1 Single-hop lineage transform

Present the root-lineage definition:

```text
L_child(r,z)
  iff L_original(r,z)
      or (r = BRIDGE and exists r'. L_witness(r',z)).
```

Present source lineage analogously.

Interpretation: translation evidence is recorded, but its responsibility category is not allowed to masquerade as the original role-indexed ancestry.

### 5.2 Exact non-BRIDGE conservation

State the exact theorem for `r != BRIDGE`:

```text
L_child(r,z) iff L_original(r,z).
```

This is stronger and more precise than saying vaguely that “provenance is preserved.”

### 5.3 BRIDGE is responsibility, not truth

Clarify that BRIDGE ancestry records dependency on translation evidence. It does not establish truth, semantic equivalence, authorization, or adequacy of the witness.

---

## 6. Two-Hop Historical Conservation — P2-R4

### 6.1 Composition joint

Introduce Figure 2 only here:

```text
O + X_1 -> W_1@c_B
W_1 + X_2 -> W_2@c_C
```

The crucial reachable connection is exact identity threading: the `originalId` of the second TRANSPORT event is the `childId` produced by the first.

### 6.2 Scope conservation

From one-hop narrowing:

```text
Scope(W_1) <= Scope(O)
Scope(W_2) <= Scope(W_1)
```

prove:

```text
Scope(W_2) <= Scope(O).
```

Avoid authorization/least-privilege interpretations beyond the represented scope relation.

### 6.3 Canonical-interpretable strength conservation

State only the actual conditional result: when the original and final escalation depths are canonically interpretable, final depth is no greater than original depth.

Do not describe this as a total numeric semantics for all claims.

### 6.4 Two-hop lineage conservation

For each non-`BRIDGE` role, final root/source lineage is exactly the initial original lineage. At `BRIDGE`, final lineage consists exactly of original BRIDGE ancestry plus all ancestry of `X_1` and `X_2`.

### 6.5 Reachable lifting

State `twoHopTransportFormationBoundary` and explain its proof architecture:

```text
Step
-> exact historical objects
-> exact intermediate identity
-> pure conservation.
```

The reachable theorem does not re-expand the formation discipline into a second theorem surface.

### 6.6 Why two hops are the stopping point

Two hops show that the conservation laws compose and are not merely a one-step artifact. The current manuscript does not need an arbitrary-length chain datatype, fold, witness sequence, or induction theorem. Those would be reopened only if a concrete paper argument requires arbitrary `n`.

---

## 7. Related Work

[Section skeleton tied to `paper/transport-related-work-freeze.md`.]

### 7.1 Proof/theorem transfer and institutions

Acknowledge Isabelle Lifting/Transfer, recent transport-via-equivalence work, and institution/comorphism approaches. Distinguish theorem/specification translation from the stateful historical/current responsibility decomposition studied here.

### 7.2 Contextual reasoning, bridge rules, and ontology mappings

Acknowledge Distributed Description Logics, C-OWL, and related mapped-context systems. Make explicit that this paper's `BRIDGE` is a lineage responsibility role, not a claim to invent bridge-rule reasoning.

### 7.3 Provenance through transformations

Acknowledge provenance semirings, mapping/update-exchange provenance, and schema-mapping literature. Position P2-R3 as exact responsibility isolation rather than generic provenance preservation.

### 7.4 Authorization delegation and information-flow relabeling

Acknowledge proof-carrying authentication, SPKI/SDSI/trust management, Macaroons/WAVE, and decentralized-label/relabeling work. Keep `Usable`, scope narrowing, and escalation depth within their kernel meanings.

### 7.5 Narrow positioning

Conclude related work with the four-way responsibility decomposition and the two-hop conservation theorem; make no priority claim.

---

## 8. Boundaries and Non-Theorems

Use Table 2 to prevent over-generalization.

### 8.1 Same profile only

Both original and witness must match the current binding's profile digest. Cross-profile transport would require a new explicit responsibility mechanism and is outside this paper.

### 8.2 Transportability is not target adoption

The kernel does not require target context activation/adoption during formation or qualification. A candidate target context can therefore participate in historical exploration without the paper asserting that the context is actionably adopted.

### 8.3 Qualification is not entitlement

Current `Usable` is a kernel currentness predicate. The paper makes no implication from usability to entitlement/authorization.

### 8.4 Adjacent lifecycle is not temporal closure

P2-R2 uses a witnessed adjacent formation/qualification boundary. It does not state persistence across arbitrary future transitions.

### 8.5 Historical composition is not qualification-chain propagation

P2-R4 composes formation histories only. It does not prove that current usability of `O`, `X_1`, and `X_2` is sufficient to make `W_2` currently usable through a chain of implicit qualifications.

### 8.6 Two hops are not arbitrary n hops

No path datatype or `n`-hop induction result is claimed.

### 8.7 Semantic kernel is not executable refinement

The Python reference implementation motivates and tests related behavior, but the paper does not claim a formal refinement theorem connecting Python's container/serialization semantics to the Lean transition system.

---

## 9. Mechanized Artifact

The formal development is in Lean 4.19.0. The artifact exposes the exact theorem declarations mapped in `paper/transport-theorem-map.md`; the CI build rejects `sorry`/`admit` placeholders and prints theorem axiom dependencies.

The Paper 2 headline theorem surface is:

```text
P2-R1 -> transportStep_newWarrant_exact
P2-R2 -> qualifyTransport_requires_sourceCurrent
         qualifyTransport_sourceContexts_exact
         qualifyTransport_evaluation_exact
         transportFormationQualification_boundary
P2-R3 -> transportRootLineage_nonBridge_exact
         transportSourceLineage_nonBridge_exact
         two-hop BRIDGE/non-BRIDGE exact lineage laws
P2-R4 -> twoHopTransportFormationBoundary
```

Supporting declarations remain artifact-level support rather than additional headline contributions.

The Python tests remain conformance evidence for the repository artifact; they are not a machine-checked Python-to-Lean refinement proof.

---

## 10. Conclusion

Representation crossing introduces responsibilities that should not be collapsed merely because they participate in one operational transition. In the kernel studied here, TRANSPORT records an exact target historical judgment while retaining the original and bridge-witness identities. A later qualification step returns to those stored historical parents' own formation contexts to discharge current responsibility. The lineage semantics separately preserve original non-`BRIDGE` ancestry and confine translation-witness ancestry to `BRIDGE` responsibility.

These distinctions remain stable under two consecutive historical TRANSPORT formations: scope and canonically interpretable escalation strength do not amplify, non-`BRIDGE` ancestry remains exact, and each translation witness contributes only to BRIDGE ancestry. The result is a finite mechanized account of responsibility preservation across representation boundaries—not a general interoperability theory, and not a claim that translation, provenance transformation, delegation, or proof transport are new.

The current theorem surface deliberately stops at same-profile transport, adjacent qualification, and two-hop historical composition. Cross-profile transport, target adoption, arbitrary temporal closure, qualification-chain propagation, arbitrary `n`-hop transport, revision/revalidation, and executable refinement remain separate future theorem families rather than implicit obligations of the present paper.

---

## Architecture freeze for the next pass

The hostile-review pass may reduce or rewrite claims but should preserve this high-level order unless a concrete ambiguity requires reorganization:

```text
Problem
-> responsibility decomposition
-> single-hop TRANSPORT formation
-> source-context qualification
-> translation-evidence isolation
-> two-hop historical conservation
-> related-work subtraction
-> explicit boundaries
-> artifact
```

Paper 1 should occupy only the minimum background needed to explain why historical state and current usability are represented separately. Paper 2's independent question is how that separation behaves when a judgment crosses a context/representation boundary.
