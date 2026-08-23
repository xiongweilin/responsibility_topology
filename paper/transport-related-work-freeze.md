# Paper 2 Related Work and Novelty Freeze

Status: paper-only novelty boundary for the TRANSPORT manuscript.

Baseline: Paper 2 claim surface in `paper/transport-theorem-map.md` and running-example architecture in `paper/transport-running-example.md`.

This note is intentionally conservative. It identifies neighboring literatures that already cover broad notions of translation, proof/evidence transfer, contextual reasoning, schema/ontology mapping, provenance propagation, delegation, attenuation, and relabeling. Paper 2 must not claim priority over those areas.

## Frozen novelty rule

The manuscript must not frame its novelty as any of the following:

```text
first proof/evidence transport system
first cross-context reasoning system
first bridge-rule logic
first interoperability logic
first provenance-preserving transformation
first translation-certificate mechanism
first delegated/attenuated credential system
first information-flow relabeling system
first ontology/schema mapping with provenance
first system to compose representation changes
```

The paper instead studies a narrower mechanized responsibility decomposition:

```text
origin historical identity
!= translation responsibility
!= target historical identity
!= source-indexed current qualification
```

and proves a two-hop conservation result for scope, canonical-interpretable escalation strength, and BRIDGE-isolated lineage.

No novelty-priority claim is made at this checkpoint.

---

## Neighborhood A — Theorem/proof transfer across representations

### Existing territory

Proof assistants already support transporting definitions and theorems across representation relations.

Huffman and Kunčar, **“Lifting and Transfer: A Modular Design for Quotients in Isabelle/HOL”** (CPP 2013, DOI `10.1007/978-3-319-03545-1_9`) separate lifting definitions from transferring theorems and automate theorem movement between related representations. Isabelle's current Transfer infrastructure explicitly provides a generic theorem-transfer method. More recent work by Kappelmann, **“Transport via Partial Galois Connections and Equivalences”** (APLAS/AFP 2023), develops a general framework for transporting programs and results via equivalences and partial Galois connections.

Representative sources:

- Brian Huffman and Ondřej Kunčar, *Lifting and Transfer: A Modular Design for Quotients in Isabelle/HOL*, CPP 2013.
- Isabelle/HOL `Transfer` package documentation/source.
- Kevin Kappelmann, *Transport via Partial Galois Connections and Equivalences*, 2023, DOI `10.48550/arXiv.2303.05244`.

### Consequence for Paper 2

Paper 2 cannot claim novelty for transporting propositions, proofs, programs, or definitions between representations, nor for theorem transfer under a relation/equivalence.

The present TRANSPORT object is different in emphasis: it is a historical state transition that records an original identity, a distinct BRIDGE witness, a target historical identity, and later currentness checks indexed by stored parent formation contexts. The paper should present this as a responsibility decomposition, not as a new general theorem-transfer method.

---

## Neighborhood B — Institutions, logic translations, and heterogeneous specification

### Existing territory

Institution theory was explicitly designed to abstract logical systems and reason soundly under changes of notation and translations between logics.

Goguen and Burstall, **“Institutions: Abstract Model Theory for Specification and Programming”** (JACM 39(1), 1992, DOI `10.1145/147508.147524`) make satisfaction invariant under signature change central to the framework and study conditions under which theorem proving can be transported between institutions. Later work on institution morphisms/comorphisms and structured institutions treats translations between logics and heterogeneous specification systems directly.

Representative sources:

- Joseph Goguen and Rod Burstall, *Institutions: Abstract Model Theory for Specification and Programming*, JACM 1992.
- Ionuț Țuțu, *Comorphisms of Structured Institutions*, Information Processing Letters 2013.
- institution-based heterogeneous specification work such as HetCASL and related comorphism frameworks.

### Consequence for Paper 2

Paper 2 cannot claim novelty for logic translation, satisfaction-preserving notation change, or heterogeneous formal specification.

Its narrower object is not a general translation between logical systems. The current kernel is explicitly **same-profile**, and the target context remains inside the same represented profile snapshot. `CrossProfileTransport` remains frozen.

---

## Neighborhood C — Contextual logics, distributed ontologies, and bridge rules

### Existing territory

Multi-context and distributed-ontology formalisms have long represented independent local contexts connected by explicit mappings or bridge rules.

Borgida and Serafini, **“Distributed Description Logics: Assimilating Information from Peer Sources”** (2003, DOI `10.1007/978-3-540-39733-5_7`) extend description logics with mappings between independent information sources using bridge rules. Bouquet, Giunchiglia, van Harmelen, Serafini, and Stuckenschmidt, **“C-OWL: Contextualizing Ontologies”** (ISWC 2003), keep ontology contents local and connect contextual ontologies through explicit mappings. DRAGO and later distributed/contextual reasoning work similarly reason across semantically mapped local ontologies.

Representative sources:

- Alex Borgida and Luciano Serafini, *Distributed Description Logics: Assimilating Information from Peer Sources*, 2003.
- Paolo Bouquet et al., *C-OWL: Contextualizing Ontologies*, ISWC 2003.
- later distributed/contextual ontology reasoning systems such as DRAGO.

### Consequence for Paper 2

Paper 2 cannot claim novelty for multiple contexts, context-local knowledge, bridge rules, ontology mappings, or inference across contextual boundaries.

The paper's BRIDGE role is a responsibility category in historical lineage; it must not be equated with the technical `bridge rule` constructs of distributed description logics. The comparison should be explicit to avoid terminological overreach.

---

## Neighborhood D — Provenance under transformations and mappings

### Existing territory

Database provenance has extensive results for tracking source contribution through transformations, views, schema mappings, data exchange, and update exchange.

Green, Karvounarakis, and Tannen, **“Provenance Semirings”** (PODS 2007, DOI `10.1145/1265530.1265535`) give a general algebraic account of provenance propagation. Green, Karvounarakis, Ives, and Tannen, **“Update Exchange with Mappings and Provenance”** (VLDB 2007), explicitly study heterogeneous peers connected by schema mappings and attach provenance to propagated updates. Tannen's **“Provenance for Database Transformations”** survey/talk emphasizes that queries, views, and mappings transform data while provenance tracks relationships between source pieces and outputs; semiring methods extend to GLAV schema mappings and tuple-generating dependencies.

Representative sources:

- Todd J. Green, Grigoris Karvounarakis, Val Tannen, *Provenance Semirings*, PODS 2007.
- Todd J. Green, Grigoris Karvounarakis, Zachary G. Ives, Val Tannen, *Update Exchange with Mappings and Provenance*, VLDB 2007.
- Val Tannen, *Provenance for Database Transformations*, EDBT 2010.

### Consequence for Paper 2

Paper 2 cannot claim novelty for provenance preservation across transformations, mappings, heterogeneous peers, data exchange, or update propagation.

The paper's narrow distinction is not “provenance survives mapping.” It is that original role-indexed ancestry remains exact away from BRIDGE while **translation-witness ancestry is forced into a separate BRIDGE responsibility channel**, and that this exact separation composes for two historical TRANSPORT formation steps.

That is a much narrower statement than general provenance transformation.

---

## Neighborhood E — Ontology/schema mapping and provenance-aware alignment

### Existing territory

Ontology and schema mapping already treat explicit correspondences between heterogeneous representations; provenance is also used to document mappings and alignment decisions.

C-OWL and distributed description logics already supply explicit contextual mappings. Database schema-mapping work studies composition, data exchange, and mapping provenance. Recent ontology interoperability work continues to align provenance vocabularies themselves—for example mappings between W3C PROV-O and Basic Formal Ontology explicitly aim at structural/semantic interoperability.

Representative sources:

- C-OWL and Distributed Description Logics, above.
- schema-mapping composition/data-exchange literature, including provenance-aware update exchange.
- Tim Prudhomme et al., *Mapping the Provenance Ontology to Basic Formal Ontology*, 2024, arXiv `2408.03866`.

### Consequence for Paper 2

Paper 2 cannot claim novelty for schema translation, ontology alignment, mapping composition, or preservation/documentation of provenance during ontology mapping.

The present `transportableClaim` is intentionally a kernel-semantic binding for one exact map/original/target/translated-claim tuple, not a general ontology mapping formalism.

---

## Neighborhood F — Proof-carrying authentication and evidence-bearing authorization

### Existing territory

Authorization systems have long carried proofs or evidence with requests.

Appel and Felten, **“Proof-Carrying Authentication”** (CCS 1999, DOI `10.1145/319709.319718`), present a distributed authentication framework in which users submit higher-order-logic proofs with requests. Related proof-carrying authorization and logic-based trust-management work separates evidence/proofs from authorization checking in various ways.

### Consequence for Paper 2

Paper 2 cannot claim novelty for carrying proof/evidence across administrative boundaries, checking a proof at use time, or combining evidence with authorization logic.

TRANSPORT qualification in this kernel is also **not entitlement**. `Usable` is a represented currentness predicate; no manuscript sentence may silently upgrade it to authorization.

---

## Neighborhood G — Delegation and attenuation of credentials

### Existing territory

Delegation systems already preserve or restrict authority as credentials are passed along chains.

Macaroons (Birgisson et al., NDSS 2014, DOI `10.14722/NDSS.2014.23212`) support decentralized delegation with caveats that attenuate and contextually confine authority. WAVE (Andersen et al., USENIX Security 2019) provides decentralized authorization with transitive delegation and explicitly supports delegating portions of permissions. SPKI/SDSI and trust-management systems predate both and provide rich delegation/name/authorization mechanisms.

Representative sources:

- Arnar Birgisson et al., *Macaroons: Cookies with Contextual Caveats for Decentralized Authorization in the Cloud*, NDSS 2014.
- Michael P. Andersen et al., *WAVE: A Decentralized Authorization Framework with Transitive Delegation*, USENIX Security 2019.
- SPKI/SDSI and trust-management delegation literature.

### Consequence for Paper 2

Paper 2 cannot claim novelty for attenuation, transitive delegation, monotonically narrowing authority, or chained credentials.

The scope theorem should therefore be described as **scope conservation/non-widening in the represented historical TRANSPORT discipline**, not as a new least-authority or delegation result. Likewise, canonical escalation-depth non-amplification is not a general credential-attenuation theorem.

---

## Neighborhood H — Information-flow relabeling and controlled downgrading

### Existing territory

Information-flow security has long studied labels, relabeling, declassification, endorsement, and preservation of policy constraints under label changes.

Myers and Liskov's decentralized label model gives a formal semantics for decentralized labels and sound/complete safe relabeling rules, including controlled declassification while preserving other principals' policies. Later IFC work develops constrained downgrading, integrity/confidentiality label transformations, and decentralized authority models.

Representative source:

- Andrew C. Myers and Barbara Liskov, *Complete, Safe Information Flow with Decentralized Labels*, IEEE Security & Privacy 1998.

### Consequence for Paper 2

Paper 2 cannot claim novelty for safe relabeling, monotone label change, or controlled weakening/strengthening of information-flow policy.

TRANSPORT's `ScopeNarrowerOrEqual` is a modeled scope relation in this kernel, not an information-flow noninterference theorem. The manuscript must not use IFC terminology such as declassification or endorsement unless making a direct comparison rather than an equivalence claim.

---

## Neighborhood I — Trust translation and interoperability

### Existing territory

Distributed trust and authorization systems already cross administrative or naming boundaries, combine credentials from multiple principals, translate local policy facts, and reason under heterogeneous trust assumptions. Institution/ontology work likewise studies explicit translations between independently modeled contexts.

### Consequence for Paper 2

The phrase **“trust translation”** should not be used as a novelty label. The current formal object does not establish that a target context should trust a source, that a translation is semantically adequate, or that policies are interoperable.

The kernel only checks its represented formation discipline and later parent-specific current usability.

---

## What remains defensible

After subtracting the neighborhoods above, the paper's defensible contribution is the conjunction and mechanized separation of four responsibility relations within one finite reachable kernel:

```text
(1) exact same-profile target historical formation,
(2) source-indexed current qualification of the stored parent identities,
(3) exact isolation of translation-witness ancestry under BRIDGE,
(4) two-hop conservation of scope, interpretable strength, and lineage.
```

The narrowest useful central formulation is:

> In the represented same-profile TRANSPORT kernel, crossing a context/representation boundary need not collapse the identity of the source judgment, the responsibility of the translation witness, the identity of the target historical judgment, and the current contexts at which the stored parents must remain usable.

The two-hop result adds:

> For two adjacent historical TRANSPORT formations linked by the exact intermediate child identity, scope and canonical-interpretable escalation strength remain non-amplifying, non-BRIDGE ancestry remains exactly the original ancestry, and both translation witnesses accumulate only under BRIDGE responsibility.

These are machine-backed claims. Whether the particular four-way decomposition is novel enough for a venue remains a literature/reviewer judgment, not a Lean theorem.

---

## Forbidden novelty phrases

Do not use the following in the Abstract, Introduction, Contributions, or Conclusion:

```text
first to transport proofs across contexts
first formalism for cross-context provenance
first representation-crossing logic
first system for bridge evidence
first provenance-preserving translation
first compositional translation framework
first safe cross-context mapping
first attenuating transport mechanism
first trust-translation system
first ontology transport system
```

Also avoid broad unqualified phrases such as:

```text
TRANSPORT preserves provenance
TRANSPORT preserves meaning
TRANSPORT preserves trust
TRANSPORT preserves validity
TRANSPORT preserves authorization
```

Prefer exact statements tied to P2-R1–P2-R4.

---

## Related-work comparison matrix

| Neighborhood | Already established broadly in prior work | Paper 2 must not claim | Narrow Paper 2 distinction |
|---|---|---|---|
| theorem/proof transfer | theorem movement across related representations | invention of proof transport | historical responsibility decomposition, not theorem-transfer automation |
| institutions/logic translations | translations between logical systems with satisfaction discipline | invention of logic interoperability | same-profile state/history relation only |
| contextual/ontology bridge rules | local contexts connected by explicit mappings | invention of bridge rules or contextual reasoning | BRIDGE is lineage responsibility, not mapping semantics |
| database provenance | provenance through queries, transformations, mappings, updates | invention of provenance-preserving transformation | witness ancestry isolated under BRIDGE; non-BRIDGE exactness |
| ontology/schema mappings | mappings/composition/alignment across representations | invention of schema/ontology transport | exact kernel-semantic witness binding only |
| proof-carrying authorization | requests accompanied by proofs/evidence | invention of evidence-bearing authorization | usability is distinct from entitlement |
| delegation/attenuation | chained credentials and restricted authority | invention of attenuation/composable delegation | scope/strength conservation for historical transport objects |
| IFC relabeling | sound relabeling/declassification under policy | invention of safe label transformation | scope relation is not IFC/noninterference |
| trust/interoperability | credentials/policies crossing administrative boundaries | invention of trust translation | no trust/adequacy/adoption conclusion |

---

## Paper-facing related-work structure

The final manuscript should group related work by **problem distinction**, not by trying to find one direct predecessor:

1. Representation/proof translation and institutions — establishes that transport/translation itself is old.
2. Contextual reasoning and ontology/schema mappings — establishes that cross-context mappings and bridge rules are old.
3. Provenance through transformations — establishes that ancestry/provenance preservation is old.
4. Delegation, attenuation, and information-flow relabeling — establishes that monotone restriction/conservation ideas are old.
5. Proof-carrying authorization — establishes that evidence plus later checking is old.
6. Paper 2 boundary — the contribution is the exact mechanized separation of origin identity, translation responsibility, target history, and source-indexed currentness, plus the two-hop conservation theorem.

This structure should make the non-priority posture visible rather than burying it in a disclaimer.

## Formal-trigger result

No formal trigger is fired by this literature pass.

Every collision found here can be handled by narrowing terminology and positioning. No indispensable P2-R1–P2-R4 sentence currently requires cross-profile TRANSPORT, target activation/adoption, n-hop closure, qualification-chain propagation, temporal closure, or Python refinement.
