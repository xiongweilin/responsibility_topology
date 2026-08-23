# Paper 3 Related Work — Dependency-Sensitive Revision and Responsibility Repair

Status: paper-only related-work freeze for Paper 3. This document narrows novelty claims; it does not add formal semantics.

Semantic baseline: PR #51 on top of `17254fd2a9be9a884e52acacd8d845270cb434db`.

## Positioning principle

Paper 3 should not claim novelty for dependency graphs, belief revision, revocation, provenance, hitting sets, or minimal repair individually. All of those have deep prior literatures.

The defensible contribution lies in the combination of two separations inside one machine-checked state model:

```text
persistent historical dependency
!= time-indexed current responsibility
```

and

```text
impact detection
!= responsibility restoration
```

The second separation is especially important. Prior systems often identify what becomes affected, unsupported, dirty, inconsistent, revoked, or suspect after change. Paper 3 asks a distinct downstream question:

> Given an explicit currentness target and an extracted responsibility-cut model, which local repair responsibilities are sufficient to restore the target, which selected responsibilities are inclusion-minimal relative to that model, and what local cut witnesses explain their non-removability?

The paper must immediately qualify that statement:

> Hypergraph minimality is exact relative to the extracted obligation model; adequacy of that extraction is a separate epistemic/modeling responsibility.

---

## 1. Truth maintenance, assumption maintenance, and belief revision

### Doyle's Truth Maintenance System

Jon Doyle's 1979 TMS explicitly records reasons for beliefs and revises the current set of beliefs when assumptions change or contradictions are discovered. This is direct prior art against any broad claim that Paper 3 first separates stored reasons from current acceptance.

Reference:

- Jon Doyle, "A Truth Maintenance System," *Artificial Intelligence* 12(3), 1979, 231–272. DOI: `10.1016/0004-3702(79)90008-0`.

Paper 3 should credit TMS for:

- persistent justification structure;
- current belief labels that can change;
- dependency-directed revision and explanation.

The distinction is therefore **not**:

```text
prior work deletes history; we preserve it
```

That would be false as a general characterization.

The narrower Paper 3 distinction is that the current formal object model keeps several currentness judgments separate from historical warrant identity:

```text
historical warrant ancestry
warrant Usability(profile,context,use,warrant)
license BaseCurrent
context Groundedness
```

and follows challenge-induced loss across those different layers before posing restoration as an explicit responsibility-cut problem.

### de Kleer's ATMS

Johan de Kleer's 1986 ATMS manipulates assumption sets and labels to maintain multiple environments, supporting inconsistency, context switching, and alternative support structures.

References:

- Johan de Kleer, "An Assumption-Based TMS," *Artificial Intelligence* 28(2), 1986, 127–162. DOI: `10.1016/0004-3702(86)90080-9`.
- Johan de Kleer, "Problem Solving with the ATMS," *Artificial Intelligence* 28(2), 1986, 197–224. DOI: `10.1016/0004-3702(86)90082-2`.

ATMS is particularly important because it already makes support context-sensitive. Paper 3 must therefore avoid suggesting that context-indexed currentness is new in the abstract.

The paper's narrower emphasis is on a state machine where:

1. immutable historical warrant identities and parent relations survive challenge;
2. current usability is keyed by exact profile/context/use coordinates;
3. license currentness and adopted-context groundedness are separate downstream responsibility layers;
4. restoration selection is modeled separately from both impact detection and execution.

### AGM belief revision

The AGM tradition formalizes rational contraction and revision of belief sets. Its central object is a belief state/theory and the rationality conditions governing change, not the preservation of a typed operational history/currentness split with license and context responsibility layers.

Reference:

- Carlos E. Alchourrón, Peter Gärdenfors, David Makinson, "On the Logic of Theory Change: Partial Meet Contraction and Revision Functions," *Journal of Symbolic Logic* 50(2), 1985, 510–530.

Paper 3 should not present itself as a replacement for AGM. It is narrower and more operational: it assumes a finite typed responsibility model and studies how currentness loss and repair compose inside that model.

### Safe comparison sentence

> Truth-maintenance and belief-revision systems already distinguish persistent reasons or assumptions from revisable belief states. Our focus is narrower: a typed state model in which immutable historical warrant dependencies, exact-key current usability, license currentness, and context groundedness remain separate, and in which post-invalidation restoration is represented as an explicit repair-cut problem rather than as belief-state revision alone.

---

## 2. Provenance, incremental recomputation, and change-impact analysis

### Database provenance

Database provenance studies why and where results come from, including algebraic representations that preserve derivational information.

Reference:

- Todd J. Green, Grigoris Karvounarakis, Val Tannen, "Provenance Semirings," PODS 2007.

This literature is direct prior art for persistent derivational lineage. Paper 3 should not claim that recording lineage or ancestry is novel.

The distinction is that provenance answers primarily:

```text
why is / was this result derived?
```

while Paper 3 explicitly models an additional state-dependent question:

```text
may this historical object be relied on now at this exact currentness coordinate?
```

The manuscript should use this as a conceptual distinction, not a priority claim over all provenance systems; many provenance-aware systems can be extended with validity or freshness notions.

### Incremental view maintenance and self-adjusting computation

Incremental view maintenance and self-adjusting computation track dependencies so that results can be updated efficiently when inputs change.

References:

- Ashish Gupta, Inderpal Singh Mumick, "Maintenance of Materialized Views: Problems, Techniques, and Applications," 1995.
- Umut A. Acar et al., work on self-adjusting computation and change propagation; see, e.g., Umut A. Acar, Matthias Blume, Jacob Donham, "A Consistent Semantics of Self-Adjusting Computation," 2011, arXiv:1106.0478.

These systems already separate an old computation/dependency trace from propagation after mutation. Paper 3 should not claim novelty for dependency-driven recomputation.

Its different question is normative/epistemic at the kernel level: not simply which computation nodes must be recomputed to obtain a fresh value, but which explicitly represented current-responsibility obligations must be re-established before a target may again count as current.

### Software change-impact analysis

Software change-impact analysis explicitly asks which parts of a system may be affected by a change, often using static or dynamic dependency relations.

References:

- Shawn A. Bohner, Robert S. Arnold, *Software Change Impact Analysis*, IEEE Computer Society Press / Wiley, 1996.
- Barbara G. Ryder, Frank Tip, "Change Impact Analysis for Object-Oriented Programs," PASTE 2001, DOI: `10.1145/379605.379661`.

This is close prior art to Paper 3's `Affected` relation. The manuscript should say clearly that detecting descendants or affected nodes is not the novel step.

The sharper separation is:

```text
impact set
!= repair obligation model
!= sufficient repair set
!= executable repair trace
```

Paper 3's `Affected` is intentionally specialized to canonical warrant ancestry. It does not claim a superior generic change-impact algorithm.

### Safe comparison sentence

> Provenance, incremental computation, and change-impact analysis provide mature techniques for recording derivational dependencies and propagating change. We use a narrower typed dependency semantics and focus on the next question: after impact has been identified, which current-responsibility obligations must be re-established to restore a target, and how can sufficient and inclusion-minimal repair responsibilities be characterized without conflating them with dependency discovery itself?

---

## 3. Revocable authorization, dynamic trust, and stateful authorization

### Proof-carrying authorization

Proof-carrying authorization establishes that access decisions may depend on explicit logical proof objects and credentials.

Representative references include the proof-carrying authorization line associated with Appel, Felten, Bauer, and others.

Paper 3 should not claim novelty for proof-carrying access decisions or for the idea that authorization must be justified by explicit evidence.

### Stateful authorization and revocation

Dynamic authorization systems explicitly model state and revocation. This is critical prior art against a broad slogan such as:

```text
once authorized != still authorized
```

That principle is well established.

Representative references:

- Deepak Garg, Frank Pfenning, "Stateful Authorization Logic — Proof Theory and a Case Study," STM 2010; later Journal of Computer Security version.
- Jamie Morgenstern, Deepak Garg, Frank Pfenning, "A Proof-Carrying File System with Revocable and Use-Once Certificates," STM 2011, LNCS 7170, 40–55, DOI: `10.1007/978-3-642-29963-6_5`.
- SecPAL work includes explicit revocation assertions and time-dependent authorization semantics.

The revocable/use-once PCFS line is especially important because it maintains revocation state consulted at access time while retaining persistent policy certificates. Therefore Paper 3 should not characterize prior proof-carrying systems as purely timeless.

The narrower distinction is that Paper 3 treats several kinds of present responsibility independently:

```text
warrant usability
license BaseCurrent
context Groundedness
```

and then studies dependency-sensitive restoration after these currentness judgments are invalidated.

It is not a linear-resource system: repeated historical parent occurrence does not imply multiple consumable usability resources, and `MinimalRepairSet` is set-theoretic inclusion minimality rather than certificate-use accounting.

### Safe comparison sentence

> Revocable and stateful authorization systems already make authorization depend on mutable state and can invalidate previously acceptable credentials or proofs. Our contribution is not revocation itself; it is the separation of preserved historical dependency from several downstream current-responsibility judgments and the explicit repair theory used to re-establish those judgments after invalidation.

---

## 4. Model-based diagnosis, conflict sets, repair, and hitting sets

This is the most important related-work family for Paper 3's minimality claims.

### Reiter's diagnosis theory

Raymond Reiter's classic model-based diagnosis computes diagnoses from conflict sets, with minimal diagnoses characterized through minimal hitting sets.

Reference:

- Raymond Reiter, "A Theory of Diagnosis from First Principles," *Artificial Intelligence* 32(1), 1987, 57–95. DOI: `10.1016/0004-3702(87)90062-2`.

Subsequent diagnosis work explicitly describes minimal diagnoses as minimal hitting sets of conflict sets and studies measurement, discrimination, and repair planning.

Therefore Paper 3 must **not** claim novelty for:

```text
minimal hitting sets
private necessity of selected elements in a minimal hitting set
multiple incomparable minimal hitting sets
```

as generic combinatorics.

### Where the analogy is strong

Reiter-style diagnosis:

```text
observations + system model
-> conflict sets
-> minimal hitting sets
-> diagnoses
```

Paper 3 repair theory:

```text
stale currentness + extracted responsibility model
-> unresolved repair cuts
-> hitting sets
-> repair responsibilities
```

A reviewer will immediately notice this structural similarity. The paper should acknowledge it before making any novelty claim.

### Where the object of the hitting set differs

A model-based diagnosis is typically a set of component abnormality assumptions sufficient to explain an observed inconsistency or fault.

Paper 3's hitting set instead contains **candidate repair actions** whose modeled responsibility is to re-establish stale currentness obligations. Its target is restoration of a typed currentness predicate, not explanation of why the system is faulty.

Thus:

```text
diagnosis: which components may be abnormal?

Paper 3: which repair responsibilities must be selected to discharge represented stale-currentness cuts?
```

This is a difference of semantic interpretation, not a new hitting-set theorem.

### The adequacy premise is a key point of contact

Model-based diagnosis depends on the adequacy of the system description and the correctness of extracted conflicts. Paper 3 makes an analogous boundary explicit through:

```text
EveryRepairCutNecessary problem Restore
```

The paper should frame this as disciplined modeling, not as a novelty claim that prior diagnosis ignores adequacy.

The useful formal contribution is that the lower-bound theorem refuses to infer universal cut necessity from the bare hypergraph alone.

### Repair planning

There is also a substantial literature on repair planning after diagnosis, including cost-sensitive and optimal repair sequences. That literature blocks any claim that Paper 3 first distinguishes diagnosis from repair or first studies optimal repair.

Paper 3 intentionally does **not** optimize cost or cardinality. Its result is inclusion-minimality plus local private-cut witnesses, while execution order is carried separately by `RevalidationTrace`.

### Safe comparison sentence

> Our repair hypergraph deliberately inherits familiar hitting-set structure from model-based diagnosis: minimal hitting sets and non-uniqueness are not new combinatorics. The difference is the modeled object and the theorem boundary. Hyperedges are stale current-responsibility cuts, selected elements are repair actions rather than abnormal components, sufficiency additionally requires a `RepairRealization`, and semantic lower bounds require an explicit cut-adequacy premise.

---

## 5. Cross-family comparison matrix

| Prior-work family | What it already provides | Closest Paper 3 object | Paper 3 must not claim | Narrow Paper 3 emphasis |
|---|---|---|---|---|
| TMS / JTMS / ATMS | reasons/justifications, current belief revision, assumptions/environments | history vs currentness | first persistent justification/current-belief separation | typed warrant/license/context currentness plus repair-cut restoration |
| AGM belief revision | rational change of belief sets | revision after challenge | universal belief-revision theory | finite state-backed responsibility restoration |
| provenance | derivational lineage / why-provenance | canonical historical dependencies | first provenance representation | historical dependency distinct from exact-key current responsibility |
| incremental computation / view maintenance | dependency tracking and change propagation | affectedness / refresh | first dependency-driven recomputation | restoration obligations are explicit semantic responsibilities |
| software change-impact analysis | affected-node discovery | `Affected` | first impact propagation | impact detection separated from restoration selection |
| revocable/stateful authorization | mutable authorization state, revocation, use-once credentials | `BaseCurrent`, current usability | once-authorized/still-authorized distinction | layered currentness plus dependency-sensitive restoration |
| model-based diagnosis | conflicts, minimal hitting-set diagnoses | repair hypergraph | minimal hitting sets / non-uniqueness | actions hit stale-responsibility cuts; sufficiency and adequacy remain separate |
| repair planning | repair actions, sequencing, cost optimization | `RevalidationTrace` | first repair sequencing or optimal repair | unordered inclusion-minimal selection separated from proof-carrying reachable execution |

---

## 6. Novelty sentence candidates

### Too broad — reject

> We introduce dependency-sensitive revision.

Reason: truth maintenance, belief revision, incremental computation, change-impact analysis, diagnosis, and revocation all study dependency-sensitive change.

### Too broad — reject

> We are the first to preserve history while invalidating current conclusions.

Reason: TMS/ATMS, provenance-aware systems, stateful authorization, and other systems already retain reasons or credentials while changing current status.

### Too broad — reject

> We compute minimal revalidation using hitting sets.

Reason: hitting-set diagnosis and repair literatures are extensive; current formalization also does not compute a unique or optimal frontier.

### Defensible

> We formalize a typed revision boundary in which canonical warrant dependencies remain immutable while warrant usability, license currentness, and context groundedness can become stale, and we represent restoration as a repair-action hitting-set problem whose semantic sufficiency and lower-bound necessity remain explicitly separated from dependency extraction.

### Stronger but still defensible

> The contribution is not dependency discovery or hitting-set minimality in isolation, but their placement inside a state-backed responsibility lifecycle: exact historical dependencies determine a specialized impact closure; invalidation weakens multiple currentness layers without rewriting those dependencies; repair selection is modeled as hitting unresolved responsibility cuts; sound realization is required for restoration; and universal necessity is conditional on explicit cut adequacy.

---

## 7. Related-work structure for the manuscript

The final paper should organize Related Work by reviewer-recognizable research traditions, not by repository terminology:

1. **Truth maintenance and belief revision.** Lead with Doyle, de Kleer, AGM. Concede persistent reasons/current-state revision immediately.
2. **Provenance and change propagation.** Cover provenance, incremental recomputation, software change-impact analysis. Concede dependency tracing and affectedness.
3. **Revocable authorization and dynamic trust.** Cover stateful authorization, revocable/use-once PCFS, SecPAL-style revocation. Concede mutable authorization/current checks.
4. **Diagnosis and repair.** Lead with Reiter and minimal hitting-set diagnosis. Concede the combinatorics and distinguish diagnosis objects from repair-responsibility objects.

The final paragraph should then state the paper's two organizing distinctions:

```text
persistent historical dependency
!= time-indexed current responsibility

impact detection
!= minimal responsibility restoration
```

with the second line immediately qualified as **inclusion-minimal relative to an extracted obligation model**, not global optimum.

---

## 8. Citation candidates for the manuscript bibliography

Core references to retain unless a later venue-specific review replaces them with more precise sources:

1. Doyle, J. 1979. A Truth Maintenance System. *Artificial Intelligence* 12(3):231–272. DOI `10.1016/0004-3702(79)90008-0`.
2. de Kleer, J. 1986. An Assumption-Based TMS. *Artificial Intelligence* 28(2):127–162. DOI `10.1016/0004-3702(86)90080-9`.
3. de Kleer, J. 1986. Problem Solving with the ATMS. *Artificial Intelligence* 28(2):197–224. DOI `10.1016/0004-3702(86)90082-2`.
4. Alchourrón, C. E.; Gärdenfors, P.; Makinson, D. 1985. On the Logic of Theory Change: Partial Meet Contraction and Revision Functions. *Journal of Symbolic Logic* 50(2):510–530.
5. Reiter, R. 1987. A Theory of Diagnosis from First Principles. *Artificial Intelligence* 32(1):57–95. DOI `10.1016/0004-3702(87)90062-2`.
6. Green, T. J.; Karvounarakis, G.; Tannen, V. 2007. Provenance Semirings. PODS 2007.
7. Gupta, A.; Mumick, I. S. 1995. Maintenance of Materialized Views: Problems, Techniques, and Applications.
8. Bohner, S. A.; Arnold, R. S. 1996. *Software Change Impact Analysis*. IEEE Computer Society Press / Wiley.
9. Ryder, B. G.; Tip, F. 2001. Change Impact Analysis for Object-Oriented Programs. PASTE 2001. DOI `10.1145/379605.379661`.
10. Garg, D.; Pfenning, F. 2010. Stateful Authorization Logic — Proof Theory and a Case Study. STM 2010.
11. Morgenstern, J.; Garg, D.; Pfenning, F. 2011. A Proof-Carrying File System with Revocable and Use-Once Certificates. STM 2011. DOI `10.1007/978-3-642-29963-6_5`.
12. Acar, U. A.; Blume, M.; Donham, J. 2011. A Consistent Semantics of Self-Adjusting Computation. arXiv:1106.0478.

A venue-specific bibliography pass should verify final bibliographic metadata before submission.

---

## 9. Claim firewall after related-work review

After comparison with these literatures, the Paper 3 mother claim remains defensible only in its scoped form:

> **When canonical history is preserved but current responsibility is invalidated, restoration is a dependency-sensitive repair problem whose sufficient repairs are hitting sets of unresolved responsibility cuts, and whose inclusion-minimal repairs admit local necessity witnesses.**

Interpretation constraints:

- `canonical history` means the represented warrant history, not all provenance in all systems;
- `current responsibility` means the modeled warrant/license/context currentness predicates;
- `repair problem` is relative to an extracted finite `RepairProblem`;
- `sufficient` requires `RepairRealization`;
- `inclusion-minimal` is not minimum-cardinality, optimal, or unique;
- universal necessity requires `EveryRepairCutNecessary`;
- reachable execution is supplied by a separate ordered trace layer;
- no Python or cross-repository refinement is claimed.

No new formal milestone is triggered by this related-work pass.
