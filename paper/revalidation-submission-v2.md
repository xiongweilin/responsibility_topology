# Dependency-Sensitive Revision and Inclusion-Minimal Responsibility Repair in a State-Backed Epistemic Kernel

Venue-neutral submission draft v2 — Paper 3

## Abstract

Long-lived reasoning systems need to preserve why an object was formed without assuming that it remains safe to use after its dependencies change. We mechanize this separation in a state-backed epistemic kernel. Canonical warrant history persists across the modeled challenge and repair stages, while three state-indexed current-responsibility layers—warrant usability, Adopt-license currentness, and context groundedness—may become stale. A valid challenge uses a specialized warrant-history impact semantics over the target and its transitive descendants; the resulting currentness loss can propagate through license support and adopted-context activation.

Restoration is represented by a finite directed-hypergraph repair instance. Hyperedges are unresolved responsibility cuts and their alternatives are candidate local repair actions. A `RepairSet` is a hitting set of all represented cuts, but hitting-set membership alone is not a restoration theorem: a separate `RepairRealization` certificate connects selected actions to restored obligations and restored dependencies to the target. Inclusion-minimal repair sets admit local private-cut witnesses, so every selected action is non-removable relative to that repair set. We do not claim minimum cardinality, optimality, uniqueness, or a canonical repair frontier.

Universal semantic lower bounds require the explicit premise `EveryRepairCutNecessary`: every restoring action set must hit every represented cut. This establishes necessity of represented cuts for the chosen restoration predicate; it does not establish completeness of the extracted dependency model. Finally, an ordered proof-carrying `RevalidationTrace` connects unordered repair selection back to reachable state while keeping warrant, license, and context restoration distinct. The contribution is therefore not new hitting-set mathematics, but a machine-checked separation of historical continuity, state-indexed currentness loss, repair selection, semantic effectiveness, represented-cut necessity, extraction completeness, and reachable execution.

## 1. Introduction

A historical dependency and a current permission to rely on it answer different questions. Suppose a derived warrant `d` was formed from parent warrant `p`. Later, `p` is challenged. Deleting the historical edge `p -> d` destroys the explanation of why `d` exists; keeping the edge while continuing to treat `d` as currently usable ignores the challenge.

The same distinction compounds when currentness has layers. A warrant may support an activation license; that license may ground an adopted context; the context may remain historically represented even after it ceases to be currently grounded. A durable system therefore needs separate relations for what happened historically and what may be relied on in the current state.

This paper begins after such a discontinuity:

> **When canonical history is preserved but current responsibility is invalidated, restoration is a dependency-sensitive repair problem whose sufficient repairs are hitting sets of unresolved responsibility cuts, and whose inclusion-minimal repairs admit local necessity witnesses.**

The claim is conditional in two important ways. First, a hitting set restores a target only together with a sound semantic realization. Second, a universal claim that every restoring set must hit every represented cut requires an explicit represented-cut necessity premise. The formalism does not prove that its extracted dependency model is complete.

The theoretical progression is:

```text
historical/currentness discontinuity
-> modeled affected closure
-> currentness loss
-> finite responsibility cuts
-> repair selection
-> semantic realization
-> inclusion-minimal private cuts
-> represented-cut necessity boundary
-> ordered reachable realization
```

The reachable lifecycle is deliberately last: it is a realizability bridge, not the source of the paper's combinatorial or semantic separation results.

### Contributions

The formal development supports five contribution families.

1. **Historical continuity under challenge-induced currentness loss.** Valid challenge preserves canonical warrant referents while mutable evaluation and downstream currentness may weaken.
2. **Typed currentness propagation.** The model keeps warrant `Usable`, license `BaseCurrent`, and context `Grounded` separate; challenge and fixed-point refresh can propagate loss across those layers.
3. **Finite repair instances over explicit responsibility cuts.** Stale currentness obligations induce a finite directed-hypergraph repair instance. `RepairSet` is a hitting set of the represented unresolved cuts.
4. **Selection/effectiveness/minimality separation.** `RepairSet + RepairRealization` composes to target restoration; inclusion-minimal repair sets give each selected action a private-cut witness. Universal represented-cut necessity requires `EveryRepairCutNecessary`.
5. **Reachable proof-carrying execution.** An ordered `RevalidationTrace` gives layer-specific repair transitions and reconnects the set-level repair theory to reachable state.

We use **responsibility** narrowly: a represented formal obligation that must hold or be discharged at a semantic boundary. No moral, legal, institutional, or professional responsibility claim is made.

## 2. State model and running counterexample

### 2.1 Historical and current relations

A canonical state stores contexts, profiles, bindings, historical warrants, licenses, activation provenance, and mutable evaluation/currentness observations. The state type is function-valued; the paper does **not** claim a globally finite state space. Finiteness enters specifically at the repair-instance and trace layers.

Historical parent identity is persistent state structure. Current warrant usability is state-indexed and keyed by an exact evaluation coordinate:

```text
(profileDigest, contextId, use, warrantId).
```

`Usable(S,key)` requires `LIVE` epistemic status and `PLACED` placement at that exact key.

The Adopt layer adds two further currentness judgments. A represented license is `BaseCurrent` only when its binding/context/profile/use/scope/review/support premises currently hold. A context is `Grounded` through a bootstrap or through an Adopt activation backed by a current license and a grounded issuer.

Thus:

```text
historical warrant ancestry
!= state-indexed warrant Usability
!= license BaseCurrent
!= context Groundedness.
```

### 2.2 One running counterexample

Assume a reachable state `S0` with a historical edge

```text
p ----historical parent----> d
```

and an Adopt license `L` whose support contains `d`, issued from grounded context `c0` to adopted context `c1`:

```text
c0 --L(support=[d])--> c1.
```

Before challenge:

```text
Usable(S0,kd)
BaseCurrent(S0,L)
Grounded(S0,c0)
Grounded(S0,c1).
```

A valid challenge targets `p`. The historical edge `p -> d`, license record `L`, and Adopt provenance remain represented, while affected current evaluation may be suspended and the license may be marked for review. After fixed-point refresh, the example may exhibit:

```text
Usable(d)       no
    |
    v
BaseCurrent(L)  no
    |
    v
Grounded(c1)    no.
```

This is the paper's basic discontinuity: history persists while state-indexed current responsibility is withdrawn.

At the refreshed state `S2`, use three stale obligations:

```text
Ow = warrantUsable(kd)
Ol = licenseBaseCurrent(L)
Oc = contextGrounded(c1)

target = Oc.
```

For the extensional repair example, let:

```text
a = revalidateWarrant(kd)
b = a distinct modeled warrant-level candidate
l = revalidateLicense(L)
c = revalidateContext(c1)
```

and cuts:

```text
e_w : Ow <- {a,b}
e_l : Ol <- {l}
e_c : Oc <- {c}.
```

Then:

```text
X1 = {a,l,c}
X2 = {b,l,c}
```

are incomparable inclusion-minimal hitting sets. This demonstrates non-uniqueness at the extensional repair-model level. It does **not** establish two distinct reachable repair traces. The current reachable action semantics directly demonstrates the exact-key branch represented by `a`; any other alternative requires its own sound realization and, if an execution claim is desired, its own reachable trace argument.

## 3. Challenge impact and historical continuity

### 3.1 Modeled affected closure

The historical dependency direction is reconstructed from immutable parent identifiers. `DirectDescendant(S,p,c)` holds when canonical child `c` names parent `p`; `DescendantOf` is its nonempty transitive closure. The model chooses:

```text
Affected(S,target,w)
  := (w = target) OR DescendantOf(S,target,w).
```

Accordingly, the represented warrant-history impact set is exactly the target plus its transitive descendants. The equivalence itself is definitional; the paper does not present it as new mathematics. The relevant formal contribution is that this selected impact boundary is connected to challenge invalidation and preservation properties.

The model does not claim that arbitrary runtime, causal, software, authorization, or data dependencies should use this recursive closure. `portable-runtime`, for example, also contains direct typed dependency-impact mechanisms; no refinement theorem identifies those semantics with this Lean relation.

### 3.2 Challenge validation and effect

A challenge is not an untrusted arbitrary mutation. Its transition requires canonical binding/context/warrant referents, a currently usable challenger, a currently usable BRIDGE warrant, and an exact bridge claim naming challenger and target.

For affected evaluation coordinates at the challenged profile/use, `LIVE` may become `SUSPENDED`; affected proper descendants with `PLACED` placement may become `PENDING`. Impacted Adopt licenses are marked for review. Challenge does not create new usability.

At the same transition, canonical context/profile/binding/warrant referents, license records, Adopt records, and activation provenance are preserved. `challengeStep_historyReferentsImmutable` exposes the historical side directly.

The result is not a theorem that canonical well-formedness implies non-currentness. It is a witnessed separation on one valid transition:

```text
canonical history preserved
while
mutable currentness becomes stricter.
```

## 4. Grounded refresh and multi-layer currentness loss

Challenge updates current evaluation and license-review facts but does not itself recompute grounded active contexts. A separate fixed-point projection retains exactly contexts grounded in the invalidated activation read:

```text
RefreshActive(c) <-> Grounded(invalidatedRead,c).
```

Refresh is contractive: it cannot synthesize activity outside the pre-refresh seed. Hence a stale Adopt activation cannot survive refresh. Groundedness is also issuer-closed: if an adopted context survives, its issuer survives, so issuer loss cascades to downstream adopted contexts.

The important dependency pattern is therefore:

```text
warrant currentness loss
-> license currentness loss
-> context groundedness loss.
```

These are implications through represented responsibility dependencies, not definitional equalities.

Contractiveness also explains why refresh is not revalidation. Once an adopted context has been removed from seed activity, a second refresh alone cannot re-add it. Restoration needs explicit currentness repair followed by final refresh.

## 5. Finite repair instances

Historical well-formedness is intentionally absent from the repair vocabulary. Challenge preserves canonical history; the stale objects are mutable currentness obligations.

The repair layer has three obligation forms:

```text
warrantUsable(key)
licenseBaseCurrent(licenseId)
contextGrounded(contextKey).
```

`StaleDependency(A,o)` means that obligation `o` does not hold in state `A`.

A `RepairProblem(A)` is finite in the relevant sense: it contains finite lists of stale obligations and hyperedges, and each hyperedge contains a finite list of alternative actions. It records that every listed obligation is actually stale, every edge belongs to a listed stale obligation, every edge has at least one alternative, and every listed stale obligation is exposed by some edge.

A candidate action set `X` hits an edge if `X` contains at least one listed alternative. A repair set is:

```text
RepairSet(problem,X)
:=
forall edge in problem.edges,
  HitsRepairEdge(X,edge).
```

Multiple edges express conjunction: every unresolved cut must be hit. Alternatives within one edge express disjunction at the selection level.

`RepairSet` says nothing by itself about executability, effectiveness, ordering, target restoration, or completeness of the dependency model.

## 6. Repair selection versus semantic effectiveness

The repair hypergraph does not certify its own effects. `RepairRealization(problem,X,revalidated)` is an explicit semantic interface with two responsibilities:

1. when a selected action hits a represented edge, that edge's obligation holds in the revalidated state;
2. if every declared stale dependency holds in the revalidated state, the target holds.

From:

```text
RepairSet(problem,X)
+
RepairRealization(problem,X,A')
```

we can compose edge restoration, restoration of all declared stale dependencies, and target restoration. A final grounded refresh preserves the represented repair-obligation truth conditions, yielding target restoration after refresh as well.

The point is architectural rather than mathematically surprising. We do **not** claim that a hitting set is inherently sufficient. We expose where semantic effectiveness must be proved:

```text
RepairSet         = combinatorial selection
RepairRealization = semantic effectiveness interface.
```

This prevents the hypergraph from proving its own domain semantics by definition.

## 7. Inclusion-minimal repair and private cuts

`MinimalRepairSet(problem,X)` means inclusion minimality relative to the represented hypergraph: `X` is a repair set and no proper subset of `X` is.

The artifact proves the expected deletion property: removing any selected member from an inclusion-minimal repair set breaks repair-set validity. It also provides a local witness theorem. For every selected action `a` in an inclusion-minimal set `X`, there exists a represented unresolved edge such that:

- `a` is an alternative on the edge; and
- any selected alternative from `X` on that edge equals `a`.

That edge is a private cut for `a` relative to `X`. It explains why `a` is locally non-removable.

The witness is not global necessity. In the running example, `a` is necessary relative to `X1`, while `b` replaces it in `X2`. The model therefore does not claim:

```text
minimum cardinality
minimum cost
Pareto optimality
unique minimal repair
canonical repair frontier
optimal action order.
```

The hitting-set combinatorics is classical, especially in model-based diagnosis. The contribution is the responsibility interpretation and the machine-checked boundary between cut selection and the other judgments in the lifecycle.

## 8. Represented-cut necessity and extraction completeness

A stronger reviewer question is:

> If an arbitrary action set really restores the target, must it hit every represented cut?

The bare hypergraph does not imply this. The formalization introduces:

```text
EveryRepairCutNecessary(problem,Restore)
```

which states that for the chosen restoration predicate `Restore`, every restoring action set hits every represented edge.

Under this premise:

```text
Restore(X) -> RepairSet(problem,X).
```

The theorem should be read as an explicit proof boundary, not as a deep lower-bound result: the represented-cut necessity is supplied as a premise and then exposed in repair-set form.

Crucially, `EveryRepairCutNecessary` is only **one** adequacy obligation. It addresses spurious mandatory represented cuts: if a cut is listed, a true restoration must hit it. It does not establish the converse completeness property that every restoration-relevant dependency, obligation, or alternative has been represented.

Therefore the paper distinguishes:

```text
represented-cut necessity
!= extraction completeness.
```

A safe statement is:

> **Hypergraph minimality is exact relative to the extracted obligation model; necessity of represented cuts and completeness of the extraction remain separate modeling responsibilities.**

This is also the interface to a broader revision question. Paper 3 studies repair **given** a finite responsibility-cut model. It does not decide when a system is entitled to believe that its current dependency vocabulary is adequate to the real problem.

## 9. From unordered repair to reachable execution

A `RepairSet` is an unordered predicate over actions. Actual repair may have dependency order, so the execution layer uses a finite list:

```text
RevalidationTrace : List RepairAction.
```

`TraceActionSet` forgets order when connecting the trace back to the set-level repair theory.

The three action families keep their responsibilities separate.

**Warrant repair.** No generic transition may arbitrarily mark a warrant `LIVE/PLACED`. Warrant revalidation must be witnessed by an already trusted ROOT admission, INFER qualification, or TRANSPORT qualification for the exact evaluation key.

**License repair.** Review may be cleared only when every other represented `BaseCurrent` premise has recovered, including canonical referents, profile/use consistency, scope discipline, and support usability.

**Context repair.** A removed context may be reactivated only with immutable existing Adopt provenance, the exact recovered `BaseCurrent` license, target consistency, and a grounded issuer. The action restores seed activity; final refresh confirms groundedness.

Each repair action preserves historical referents. Refresh changes active-context membership without rewriting canonical history. The manuscript states this compositionally; the final lifecycle theorem does not package an explicit end-to-end `HistoryReferentsImmutable(S0,S4)` conjunct.

### Reachable restoration theorem

The lifecycle is:

```text
S0 --challenge--> S1
   --refresh--> S2
   --revalidate(actions)--> S3
   --refresh--> S4.
```

The strengthened theorem consumes:

```text
RevalidationReachable(S0)
ChallengeStep(S0,S1)
RefreshStep(S1,S2)
RevalidationTrace(S2,actions,S3)
RepairSet(problem,TraceActionSet(actions))
RepairRealization(problem,TraceActionSet(actions),S3)
RefreshStep(S3,S4)
```

and concludes:

```text
RevalidationReachable(S4)
and
problem.target.Holds(S4).
```

This is a conditional realizability/reachability bridge. It does not prove that every abstract repair set admits a valid ordering or reachable trace.

## 10. Related work

### Truth maintenance and belief revision

Doyle's TMS records reasons for beliefs while allowing current belief status to change. De Kleer's ATMS maintains support across multiple assumption environments. AGM belief revision provides a broad theory of rational theory change. These are direct prior art against any claim that persistent reasons and revisable status are new here.

Our narrower contribution is a typed state decomposition across historical warrant ancestry, exact-key warrant usability, license currentness, and grounded context currentness, followed by explicit repair selection, realization, and reachable execution boundaries.

### Provenance, incremental computation, and change impact

Database provenance records derivational lineage; incremental view maintenance and self-adjusting computation propagate changes through dependency structures; software change-impact analysis identifies potentially affected program elements. We therefore do not claim novelty for lineage, dependency graphs, or affectedness.

Paper 3 focuses downstream:

```text
impact detection
!= repair selection
!= semantic realization.
```

A set of affected historical objects is not itself a sufficient currentness repair plan.

### Stateful and revocable authorization

Stateful authorization and revocable/use-once proof-carrying systems already establish that persistent credentials or proofs need not remain currently authorizing. The present work does not claim novelty for revocation or explicit mutable currentness.

Its contribution is the separation of several downstream currentness layers and their dependency-sensitive restoration after challenge.

### Model-based diagnosis and hitting sets

Reiter-style model-based diagnosis and de Kleer/Williams multiple-fault diagnosis are the strongest combinatorial neighbors. Minimal hitting sets, non-uniqueness, and local non-removability are classical territory. We deliberately reuse that shape.

The semantic distinction is that our hyperedges are stale current-responsibility cuts and our selected elements are typed repair actions. `RepairRealization` carries effectiveness, `EveryRepairCutNecessary` carries represented-cut necessity for universal lower bounds, extraction completeness remains external, and `RevalidationTrace` carries execution order and reachability.

The novelty claim is therefore architectural and formal, not a priority claim over hitting-set mathematics.

## 11. Limitations and artifact boundary

The model has several deliberate boundaries.

First, `Affected` is a specialized transitive closure over canonical warrant parents, not a generic dependency policy.

Second, the formalism does not derive a canonical `RepairProblem` automatically from a challenged state. Repair extraction is a separate modeling step.

Third, `RepairRealization` is a premise carrying semantic effectiveness; the sufficiency theorem does not discover action effects from labels.

Fourth, `EveryRepairCutNecessary` establishes necessity of represented cuts but not completeness of dependency extraction.

Fifth, minimality is inclusion minimality only.

Sixth, the extensional repair model may contain alternatives that the current reachable action layer does not independently realize. No execution-completeness theorem is claimed.

Seventh, historical preservation is supported stage-locally rather than packaged as a final end-to-end conjunct.

Eighth, the Lean artifact does not refine `portable-runtime` and `portable-runtime` does not refine the Lean semantics in any proved sense.

Ninth, no algorithmic or complexity contribution is claimed for extracting cuts, enumerating minimal sets, optimizing cost, constructing realizations, or selecting traces. Classical hitting-set algorithms may operate over a finite repair instance, but algorithm design is outside scope.

Finally, no empirical claim is made that this decomposition reduces revalidation cost or improves safety in a deployed system. A systems-oriented paper would require additional runtime correspondence and evaluation.

## 12. Mechanization

The Paper 3 Lean development is separated from the earlier paper audit surfaces. The relevant modules include:

```text
ChallengeImpact.lean
ChallengeInvalidation.lean
ChallengeInvalidationInvariant.lean
ActivationRefresh.lean
RepairSemantics.lean
RepairSufficiency.lean
RepairMinimality.lean
RevalidationLifecycle.lean
Paper3Audit.lean
```

`Paper3Audit.lean` exposes axiom dependencies for the central challenge, refresh, repair, minimality, and lifecycle results. The paper-facing claim map separately records theorem support, required premises, and explicit non-claims.

The main theorem families are:

| Family | Representative results |
| --- | --- |
| challenge preservation/invalidation | `challengeStep_historyReferentsImmutable`, `challengeEpi_live_affected`, `challengeStep_baseCurrent_stricter` |
| grounded loss | `refresh_staleActivation_notActive`, `refresh_issuerLoss_cascades` |
| repair selection | `RepairSet`, `repairSet_hits_edge` |
| conditional sufficiency | `repairSet_sufficient_after_refresh` |
| inclusion minimality | `minimalRepairSet_remove_member_insufficient`, `minimalRepairSet_has_private_edge` |
| represented-cut necessity | `EveryRepairCutNecessary`, `restoration_implies_repairSet` |
| reachable realization | `revalidationTrace_preserves_reachability`, `reachable_revalidation_lifecycle_restores` |

## 13. Discussion

The formalization is useful because it refuses several tempting collapses.

A persistent dependency says how a historical object was related to another object. It does not by itself grant current permission to use either object. An affectedness relation identifies a represented region that may have lost currentness. It does not by itself specify a repair. A hitting set selects actions against every represented cut. It does not prove those actions work. A realization certificate proves effects in a modeled state. It does not prove that the extracted dependency vocabulary is complete. Finally, a successful semantic repair does not by itself supply a valid execution order.

The corresponding interfaces are:

```text
canonical history          historical explanation
state-indexed currentness  present permission/qualification
Affected                   modeled impact boundary
RepairSet                  combinatorial cut selection
RepairRealization          semantic effectiveness
EveryRepairCutNecessary    represented-cut necessity
extraction completeness    external modeling responsibility
RevalidationTrace          ordered proof-carrying execution
```

The deeper research question therefore remains outside this paper: when may a finite reasoner trust that its current responsibility vocabulary is adequate, or decide that the vocabulary itself must be reopened? Paper 3 intentionally does not answer that question by pretending that its repair graph is complete.

## 14. Conclusion

Canonical history and current responsibility should not be collapsed into one state relation. In the modeled kernel, challenge can preserve historical warrant referents while warrant usability, license currentness, and context groundedness become stale. Fixed-point refresh exposes downstream currentness loss without deleting the historical structures that explain how the state arose.

Restoration is represented by a finite directed-hypergraph repair instance. Repair sets hit every represented unresolved cut; with a sound `RepairRealization` they restore the target. Inclusion-minimal repair sets provide private-cut witnesses explaining why each selected responsibility is locally non-removable. Universal lower bounds are conditional on `EveryRepairCutNecessary`, which establishes necessity of represented cuts for the chosen restoration predicate but not completeness of the extracted model. An ordered proof-carrying trace then connects the unordered repair theory to reachable state.

The result is not a unique minimal revalidation frontier, a new hitting-set theory, or a complete theory of revision. It is a narrower formal claim:

> **When canonical history is preserved but state-indexed current responsibility is invalidated, restoration can be organized as a dependency-sensitive repair problem without conflating historical dependency, currentness loss, repair selection, semantic effectiveness, represented-cut necessity, extraction completeness, and execution order.**

## References

Alchourrón, C. E., Gärdenfors, P., and Makinson, D. 1985. On the Logic of Theory Change: Partial Meet Contraction and Revision Functions. *Journal of Symbolic Logic* 50(2):510–530.

Acar, U. A., Blume, M., and Donham, J. 2011. A Consistent Semantics of Self-Adjusting Computation. arXiv:1106.0478.

Bohner, S. A., and Arnold, R. S. 1996. *Software Change Impact Analysis*. IEEE Computer Society Press / Wiley.

de Kleer, J. 1986. An Assumption-Based TMS. *Artificial Intelligence* 28(2):127–162. DOI: 10.1016/0004-3702(86)90080-9.

de Kleer, J. and Williams, B. C. 1987. Diagnosing Multiple Faults. *Artificial Intelligence* 32(1):97–130. DOI: 10.1016/0004-3702(87)90063-4.

Doyle, J. 1979. A Truth Maintenance System. *Artificial Intelligence* 12(3):231–272. DOI: 10.1016/0004-3702(79)90008-0.

Garg, D. and Pfenning, F. 2012. Stateful Authorization Logic — Proof Theory and a Case Study. *Journal of Computer Security* 20(4):353–391.

Green, T. J., Karvounarakis, G., and Tannen, V. 2007. Provenance Semirings. PODS 2007:31–40.

Morgenstern, J., Garg, D., and Pfenning, F. 2011. A Proof-Carrying File System with Revocable and Use-Once Certificates. STM 2011, LNCS 7170:40–55. DOI: 10.1007/978-3-642-29963-6_5.

Reiter, R. 1987. A Theory of Diagnosis from First Principles. *Artificial Intelligence* 32(1):57–95. DOI: 10.1016/0004-3702(87)90062-2.

Ryder, B. G. and Tip, F. 2001. Change Impact Analysis for Object-Oriented Programs. PASTE 2001. DOI: 10.1145/379605.379661.
