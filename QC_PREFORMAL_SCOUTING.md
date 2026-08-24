# QC — Pre-Formal Scouting and Prior-Art Kill

Status: **QC-0/QC-1 pre-formal scouting. Research only.**

Formalization: **NO**.

This document defines the minimum conceptual firewalls for the Provisional Shared Determination track and attacks the broad problem against strong neighboring literatures before any calculus is proposed.

## 1. Mother question

QC asks:

> **How can multiple finite systems provisionally share a bounded determination across heterogeneous representations while evidence, qualification, and authority remain distributed and no final arbiter is assumed?**

The question is deliberately not:

```text
How do distributed nodes reach consensus without a central server?
```

That problem has mature theories and systems.

## 2. QC-0 conceptual firewalls

Freeze the following analytical distinctions:

```text
local determination
!=
provisional shared determination
!=
shared reliance
!=
global truth
!=
final authority
```

Also freeze:

```text
agreement
!=
semantic identity
```

and:

```text
shared representation
!=
shared evidence ownership
!=
shared decision authority
!=
shared responsibility discharge
```

These are problem-discipline statements, not formal theorems.

### 2.1 Local determination

A local system may make a determination under its own representation, evidence, qualification, and authority rules.

QC does not assume local determinations are globally comparable.

### 2.2 Provisional shared determination

A provisional shared determination is a candidate state in which multiple systems coordinate on a bounded proposition/decision for a limited purpose while retaining some local differences, conditions, or revalidation burdens.

This term is not yet a predicate or data structure.

### 2.3 Shared reliance

Shared reliance concerns whether the participants may act on the shared determination for a stated purpose.

Agreement on a value does not automatically establish shared reliance.

### 2.4 Global truth

QC does not treat shared determination as proof that all participants have represented the same truth conditions or that the determination is globally correct.

### 2.5 Final authority

QC does not assume a final arbiter. But the absence of a final arbiter is not itself a novelty claim.

## 3. Strong-neighbor matrix

| Broad QC claim | Strong neighbor | What is already established | Verdict for QC |
|---|---|---|---|
| multiple systems can reach agreement without central arbitration | Byzantine consensus / FBA | decentralized agreement under failures; FBA permits nodes to choose local quorum slices | **ELIMINATED as novelty** |
| different participants may have personalized/heterogeneous trust assumptions | heterogeneous quorum systems | each process may define its own quorums; conditions for reliable broadcast/consensus under heterogeneous trust | **ELIMINATED as novelty** |
| local judgments can be aggregated into a collective judgment | judgment aggregation | extensive aggregation theory plus impossibility/possibility results | **ELIMINATED as novelty** |
| conflicting beliefs/knowledge bases can be merged | belief merging | methods for aggregating information from different sources under integrity constraints | **ELIMINATED as novelty** |
| systems with heterogeneous ontologies can be translated/aligned | semantic interoperability / ontology matching | mature alignment, mediation, background-knowledge, and interoperability literature | **ELIMINATED as novelty** |
| consensus plus heterogeneous semantics automatically yields justified shared reliance | combined attack | not supplied by the above merely from agreement/translation | **RESIDUAL CANDIDATE ONLY** |
| a bounded shared determination may remain revocable because evidence/qualification/authority are locally owned | combined attack | partially covered by reconfiguration, dynamic aggregation, authority/delegation, and revision literatures | **RESIDUAL CANDIDATE ONLY** |

The residual candidates are not yet QC claims. They are targets for the failure corpus and native decomposition.

## 4. FBA kills “no final arbiter” as novelty

The Stellar Consensus Protocol introduced federated Byzantine agreement in which each node chooses its own quorum slices. System-wide quorums arise from these local trust choices rather than from one central membership authority.

Therefore QC must not claim novelty for:

```text
no central arbiter;
open/decentralized membership;
local trust choices;
distributed agreement despite Byzantine behavior.
```

Stellar's own conceptual distinction between voting, accepting, confirming, and externalizing also shows that distributed protocols already separate intermediate local opinions from a state considered safe to act on.

QC cannot treat “provisional before final” as automatically novel either.

Verdict:

```text
NO-FINAL-ARBITER NOVELTY: ELIMINATED
```

Reference:

- David Mazières, *The Stellar Consensus Protocol: A Federated Model for Internet-level Consensus*.

## 5. Heterogeneous quorum systems kill personalized-trust novelty

Heterogeneous quorum-system research goes beyond uniform Byzantine quorums and allows each process to have personal quorum assumptions.

Li, Chan, and Lesani show that quorum intersection and availability are not sufficient for reliable broadcast/consensus in the heterogeneous setting and introduce quorum subsumption as an additional condition. Their later practical work develops consensus protocols for heterogeneous quorum systems.

Therefore QC must not claim novelty for:

```text
heterogeneous trust;
subjective local quorum structure;
consensus under personalized trust assumptions;
need for additional compatibility conditions beyond pairwise overlap.
```

This is a particularly strong warning: apparently reasonable local trust conditions can still be insufficient for a distributed abstraction.

QC must therefore test shared-reliance conditions with the same hostility rather than assuming that pairwise compatibility composes.

Verdict:

```text
HETEROGENEOUS-TRUST NOVELTY: ELIMINATED
```

References:

- Xiao Li, Eric Chan, Mohsen Lesani, *Quorum Subsumption for Heterogeneous Quorum Systems*, DISC 2023.
- Xiao Li, Eric M. Chan, Mohsen Lesani, *Satrapy: From abstract to practical consensus for heterogeneous quorum systems*, Distributed Computing 39 (2026), article 16.

## 6. Judgment aggregation kills broad collective-determination novelty

Judgment aggregation asks how individual judgments on logically connected propositions can be combined into collective judgments while preserving rationality conditions. The literature contains both impossibility and possibility results.

Therefore QC cannot claim novelty for:

```text
individual judgments -> collective judgment;
collective consistency constraints;
trade-offs between local rationality and collective rationality;
dynamic revision of collective judgments after new information.
```

The current Stanford Encyclopedia treatment also connects judgment aggregation to belief merging and notes recent work on dynamically rational judgment aggregation.

QC's residual, if any, must depend on a structure not captured by ordinary aggregation over a shared agenda.

Verdict:

```text
COLLECTIVE-JUDGMENT NOVELTY: ELIMINATED
```

References:

- Christian List, Ben Polak, *Introduction to judgment aggregation*, Journal of Economic Theory 145(2), 2010, 441–466, DOI `10.1016/j.jet.2010.02.001`.
- Stanford Encyclopedia of Philosophy, *Belief Merging and Judgment Aggregation*.

## 7. Belief merging kills broad multi-source-fusion novelty

Belief merging explicitly studies the aggregation of possibly conflicting information from multiple sources into a collective base, often under integrity constraints.

This means QC cannot claim novelty for:

```text
multiple sources have inconsistent beliefs;
combine them into one usable collective knowledge state;
source information differs;
integrity constraints govern the merged result.
```

Any QC residual must preserve local responsibility facts that ordinary belief merging is permitted to erase.

Verdict:

```text
MULTI-SOURCE-MERGING NOVELTY: ELIMINATED
```

## 8. Semantic interoperability kills heterogeneous-semantics novelty

Ontology matching and semantic mediation directly address semantic heterogeneity between information systems.

The literature includes mappings/alignment between different domain ontologies, use of background knowledge, and semantic mediators for interoperability.

Therefore QC cannot claim novelty for:

```text
different systems use different vocabularies;
semantic mappings are partial or difficult;
common ontology or mediation can support interoperability;
semantic heterogeneity complicates integration.
```

Recent reviews continue to treat semantic heterogeneity as a central interoperability problem.

Verdict:

```text
HETEROGENEOUS-SEMANTICS NOVELTY: ELIMINATED
```

Representative references:

- B. Orgun et al., *Approaches for semantic interoperability between domain ontologies*, Expert Systems 25 (2008), 179–196, DOI `10.1111/j.1468-0394.2008.00461.x`.
- Jan Portisch, Michael Hladik, Heiko Paulheim, *Background knowledge in ontology matching: A survey*, Semantic Web, 2024.
- *Semantic Mediation: a literature review on semantic interoperability through ontologies*, Procedia Computer Science 263 (2025), 734–743, DOI `10.1016/j.procs.2025.07.088`.

## 9. What the strong neighbors jointly remove

QC may no longer use any of the following as its research contribution:

```text
consensus without a central authority;
open/federated membership;
personalized trust;
heterogeneous quorums;
collective judgment aggregation;
belief merging;
semantic heterogeneity;
ontology mapping;
partial semantic translation by itself;
dynamic collective revision by itself.
```

The research question must survive after these are modeled honestly.

## 10. Candidate residual pressure

One narrow combined pressure remains plausible but unearned:

```text
heterogeneous finite representations
+
partial semantic interpretation
+
local qualification/currentness
+
distributed evidence ownership
+
distributed or asymmetric authority
+
revocable bounded shared reliance
```

The key word is **combined**.

Each ingredient separately has substantial prior art.

QC earns a new object only if a real failure cannot be expressed without loss after ordinary consensus, quorum/trust, judgment aggregation, authority/delegation, and semantic translation have all been modeled.

## 11. Elimination questions for every future QC case

Before using QC vocabulary, ask:

```text
1. Is this only a consensus/safety/liveness problem?
2. Is this only heterogeneous quorum/trust configuration?
3. Is this only judgment aggregation over a shared agenda?
4. Is this only belief merging under integrity constraints?
5. Is this only ontology alignment or semantic mediation?
6. Is this only authority/delegation routing?
7. Is this only evidence provenance/ownership?
8. Is this only reconfiguration/revalidation of an existing distributed protocol?
```

If the answer is yes, the case does not support a new QC relation.

## 12. Prohibited shortcuts

Do not infer:

```text
agreement -> shared reliance
agreement -> semantic identity
quorum confirmation -> responsibility discharge
joint approval -> joint discharge
shared data -> shared evidence ownership
translation -> equivalence
no final arbiter -> novelty
revocability -> new consensus theory
```

## 13. QC-1 verdict

The broad QC problem is substantially narrowed.

```text
QC consensus novelty: KILLED
QC no-final-arbiter novelty: KILLED
QC heterogeneous-trust novelty: KILLED
QC collective-judgment novelty: KILLED
QC semantic-interoperability novelty: KILLED
```

A residual candidate survives only as a question:

> **After consensus/trust, authority, evidence ownership, and semantic translation have been explicitly modeled, are there native failures in which multiple systems still cannot represent the conditions under which a bounded common determination may be relied upon and later withdrawn/revalidated?**

This is not yet a problem kernel.

## 14. Next gate: failure corpus, not calculus

The next legitimate QC step is a failure corpus.

It must prioritize cases in which ordinary decomposition may fail, including:

```text
shared representation but no responsibility owner;
agreement while semantics remain incompatible;
distributed evidence separated from decision authority;
delegation followed by orphaned revalidation;
joint approval mistaken for joint discharge;
agreement caused by a shared abstraction that erased the real disagreement.
```

For each case, record native facts before proposing QC terminology.

Current status:

```text
QC-0 firewalls: FROZEN FOR SCOUTING
QC-1 broad prior-art claims: ELIMINATED
QC residual candidate: UNPROVEN
QC formalization: NO
```
