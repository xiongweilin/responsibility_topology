# Dependency-Sensitive Revision and Inclusion-Minimal Responsibility Repair in a State-Backed Epistemic Kernel

Conceptually normalized submission draft — Paper 3

## Abstract

Revision should be able to withdraw current responsibility without rewriting historical dependency. We study this principle in a state-backed epistemic kernel whose canonical warrant history is preserved across modeled challenge and repair boundaries while three state-indexed currentness relations—warrant usability, activation-license currentness, and context groundedness—may become stale.

A challenge is interpreted through a specialized historical impact boundary over a target warrant and its transitive warrant descendants. The substantive effect is not the impact definition itself, but the resulting separation: canonical derivational identity remains available for audit while current usability can be suspended, license `BaseCurrent` can fail, and fixed-point refresh can remove adopted contexts whose grounding responsibility no longer holds.

Given an extracted finite repair instance, we then separate four questions that are often collapsed: which local repair responsibilities are selected, whether those selected responsibilities are semantically effective, whether represented cuts are necessary for a chosen restoration predicate, and how selected repair actions are ordered into reachable execution. The finite repair instance is represented as a directed hypergraph. `RepairSet` is a hitting-set condition over unresolved responsibility cuts, but hitting-set membership alone does not establish restoration: a separate `RepairRealization` certificate supplies semantic effectiveness. Inclusion-minimal repair sets admit private-cut witnesses, giving each selected action a local explanation of non-removability relative to that repair set. Universal claims about represented-cut necessity require the explicit premise `EveryRepairCutNecessary`; completeness of the extracted responsibility model remains a separate open obligation. Finally, an ordered proof-carrying `RevalidationTrace` connects the extensional repair model to reachable state.

The contribution is therefore not new hitting-set mathematics. It is a mechanized revision architecture that keeps historical dependency, typed currentness, repair selection, semantic realization, model-bound necessity, and execution as separate responsibility boundaries.

## 1. Introduction

Long-lived reasoning systems face a basic revision problem. If an object was historically derived from some dependency, later change should not erase that derivation merely because the object is no longer safe to rely on. At the same time, preserving the derivation must not silently preserve current permission to use it.

We therefore begin from one principle:

> **Revision should withdraw current responsibility without rewriting historical dependency.**

Suppose a warrant `d` was historically formed from parent `p`:

```text
p ----historical parent----> d.
```

After `p` is challenged, two statements should remain independently expressible:

```text
p historically contributed to d
```

and

```text
d is not currently usable at this state/evaluation coordinate.
```

The distinction becomes more important when currentness has several typed layers. In the present kernel, a warrant can support an activation license, and an activation license can ground an adopted context. Revision can therefore propagate through:

```text
warrant Usability
    -> license BaseCurrent
    -> context Groundedness
```

without deleting the historical warrant or Adopt provenance that explains how the current structure arose.

This paper asks what happens after such currentness loss. The answer is deliberately decomposed:

```text
impact detection
!= repair selection
!= repair effectiveness
!= represented-cut necessity
!= extraction completeness
!= ordered execution.
```

The directed hypergraph and its hitting sets are a technical representation inside this decomposition, not the conceptual starting point.

### 1.1 Four result families

The paper is organized around four result families.

**T1 — History-preserving currentness invalidation.** A valid challenge leaves canonical historical referents intact while represented currentness can weaken across warrant, license, and context layers. Fixed-point refresh exposes groundedness loss and issuer-dependent cascades.

**T2 — Repair selection plus realization implies restoration.** For a supplied finite repair instance, `RepairSet` selects actions that hit every represented unresolved cut. Target restoration follows only together with a sound `RepairRealization` that connects selected actions to restored obligations and restored dependencies to the target.

**T3 — Inclusion-minimal repair admits private-cut witnesses.** Every selected action in an inclusion-minimal repair set has a represented unresolved cut that no other different selected action in that set hits. This is local non-redundancy relative to the represented repair problem, not minimum cardinality, cost optimality, uniqueness, or a canonical frontier.

**T4 — Proof-carrying repair has a reachable realization bridge.** Extensional repair selection is unordered, but execution is an ordered `RevalidationTrace`. Warrant, license, and context repair remain distinct transition families, and a reachable lifecycle theorem connects challenge, refresh, ordered repair, and final refresh to restored target currentness.

Two important formal boundaries are deliberately not promoted to peer headline theorems. The target-plus-descendants `Affected` relation is the **modeled impact boundary** used by T1. `EveryRepairCutNecessary` is an explicit **represented-cut necessity premise** used to state what bare hypergraph structure cannot justify on its own.

### 1.2 Claim discipline

In this paper, **responsibility** means a represented formal obligation that must hold or be discharged at a particular semantic boundary. It carries no moral, legal, institutional, or professional conclusion.

Currentness is **state-indexed**. Warrant usability is additionally keyed by exact profile/context/use/warrant coordinates. The model contains no primitive global time parameter.

The whole canonical state is not claimed to be a finite state space. The explicitly finite objects used by the repair theory are repair-instance lists, hyperedges/alternatives, and concrete execution traces.

The paper does not claim:

```text
new hitting-set theory
minimum-cardinality or minimum-cost repair
unique minimal repair
complete Challenge -> RepairProblem extraction
all abstract repair alternatives are reachable
portable-runtime refinement
responsibility-model adequacy / Q_open
```

## 2. State Model and the Central Visual Separation

The broader kernel stores immutable canonical history alongside mutable evaluation/currentness relations. Paper 3 uses three mutable currentness layers.

### 2.1 Historical warrant identity

Historical warrants record immutable constructor/parent information. A direct historical descendant edge is induced by stored parent identifiers, and `DescendantOf` is the nonempty transitive closure over that relation.

Historical identity answers:

```text
Why does this object exist in the canonical derivation history?
```

It does not answer:

```text
May this object be relied on now?
```

### 2.2 Warrant usability

A warrant is usable at exact evaluation key

```text
(profileDigest, contextId, use, warrantId)
```

when its evaluation state is `LIVE` and its placement is `PLACED` at that key.

Thus the same historical warrant identity can have different currentness judgments across states or evaluation coordinates.

### 2.3 License BaseCurrent

An enriched Adopt license is `BaseCurrent` only if its represented immutable referents and mutable currentness premises hold, including review status, scope/binding relationships, and current usability of stored support warrants.

A license record can therefore remain present while `BaseCurrent` becomes false.

### 2.4 Context Groundedness

A context is `Grounded` either through explicit bootstrap support or through an Adopt activation whose exact license is current and whose issuer is itself grounded.

This is a recursive currentness relation, not historical identity.

### 2.5 Figure 1 — history and three currentness planes

The paper's primary figure should be read as a two-dimensional separation, not a simple state machine:

```text
                         formation/         challenge       refresh          repair          final refresh
                         qualification

HISTORICAL PLANE         ======== canonical identities / parenthood / Adopt provenance preserved ========

WARRANT CURRENTNESS      LIVE / PLACED  -> SUSPENDED / PENDING          -> qualification restored
                                      \
LICENSE CURRENTNESS      BaseCurrent     -> review/stale                 -> BaseCurrent restored
                                           \
CONTEXT CURRENTNESS      Grounded        -> grounding loss -> inactive  -> reactivated -> Grounded
```

The diagonal arrows are dependency implications between typed currentness layers, not equalities between predicates.

The point of the figure is:

```text
persistent history
+
typed, non-monotone current responsibility.
```

## 3. Running Counterexample

Use one example throughout.

Assume reachable state `S0` containing historical dependency:

```text
p ----historical parent----> d
```

and an Adopt license `L` whose represented support includes `d`, issued from grounded context `c0` to adopted context `c1`:

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

A valid challenge targets `p`. Historical warrant `p`, historical warrant `d`, the edge `p -> d`, license record `L`, and Adopt provenance remain recorded. Mutable currentness can change.

After challenge and the first fixed-point refresh, the running chain can be:

```text
Usable(d)          false
   |
   v
BaseCurrent(L)     false
   |
   v
Grounded(c1)       false
   |
   v
active(c1)         false after refresh.
```

The counterexample therefore witnesses the paper's mother separation:

```text
HistoricalDependency(p,d) remains represented
while
CurrentResponsibility(S,d) is withdrawn.
```

At the refreshed state `S2`, define three stale obligations:

```text
Ow = warrantUsable(kd)
Ol = licenseBaseCurrent(L)
Oc = contextGrounded(c1)
```

with target `Oc`.

For the repair layer, suppose the extracted finite model contains:

```text
e_w : Ow <- {a,b}
e_l : Ol <- {l}
e_c : Oc <- {c}
```

with

```text
a = direct exact-key warrant revalidation
b = another represented warrant-level repair candidate
l = license revalidation
c = context reactivation.
```

Then two incomparable inclusion-minimal hitting sets are:

```text
X1 = {a,l,c}
X2 = {b,l,c}.
```

The example intentionally keeps three levels distinct:

```text
candidate repair alternative
!= sound semantic realization
!= reachable execution trace.
```

The current reachable transition layer directly demonstrates the exact-key branch `X1`; it does not prove that every abstract alternative such as `b` has a reachable trace.

## 4. Modeled Impact Boundary and T1: History-Preserving Currentness Invalidation

### 4.1 Definition — modeled historical impact

For the specialized warrant-history dependency semantics:

```text
Affected(S,target,w)
:= (w = target) or DescendantOf(S,target,w).
```

This is a modeling choice. The equivalence

```text
Affected(S,t,w) <-> w=t or DescendantOf(S,t,w)
```

is not presented as a deep theorem. It states the exact boundary that subsequent invalidation results use.

The model does not claim that every runtime or domain dependency should use transitive descendant invalidation.

### 4.2 Challenge invalidation

At matching challenged profile/use coordinates, an affected `LIVE` evaluation may become `SUSPENDED`. Proper affected descendants may move from `PLACED` to `PENDING`. The challenged target's placement is retained by the modeled rule.

Impacted Adopt licenses can be marked `reviewRequired`, making post-challenge `BaseCurrent` strictly harder rather than silently generating new currentness.

### 4.3 Historical preservation

The challenge transition preserves canonical warrant identities and historical referents. Thus invalidation changes the current plane without rewriting why the objects exist.

### 4.4 Fixed-point refresh

Refresh defines active context currentness extensionally through `Grounded`. It is contractive with respect to the current active seed: refresh does not invent a previously inactive context.

Consequences include:

- an Adopt activation whose exact license is not `BaseCurrent` cannot survive refresh;
- retained adopted contexts require their represented issuer support;
- issuer loss can cascade to downstream adopted contexts.

### T1 — result family

The substantive result is therefore the composition:

```text
valid challenge
+
historical preservation
+
warrant currentness loss
+
license currentness loss
+
grounded refresh / issuer cascade
```

not the definitional `Affected` equivalence by itself.

## 5. Repair Instances: From Currentness Loss to Responsibility Cuts

Paper 3 begins repair **after** a finite responsibility model has been supplied.

A `RepairProblem(A)` contains:

- one target currentness obligation;
- a finite list of stale dependencies, each false in `A`;
- a finite list of nonempty hyperedges;
- each edge tied to one represented stale obligation;
- each stale dependency exposed by at least one edge.

The repair vocabulary contains:

```text
warrantUsable(key)
licenseBaseCurrent(licenseId)
contextGrounded(contextKey).
```

Historical well-formedness is intentionally not a repair obligation. The history did not become malformed merely because current responsibility was withdrawn.

A repair set is:

```text
RepairSet(problem,X)
:= every represented unresolved edge is hit by X.
```

Multiple edges are conjunctive cuts. Multiple alternatives inside one edge are disjunctive candidates.

This representation answers only:

```text
Which represented cuts are selected for discharge?
```

It does not answer effectiveness, execution order, or model completeness.

## 6. T2: Selection + Realization Implies Restoration

A hitting set is not a restoration theorem.

`RepairRealization(problem,X,A')` carries the semantic bridge. It requires, at minimum, that selected alternatives actually restore the represented obligations they are used to discharge, and that restoration of the declared stale dependencies suffices for the chosen target in the revalidated state.

The core composition is:

```text
RepairSet(problem,X)
+
RepairRealization(problem,X,A')
=> target.Holds(A').
```

The represented repair-obligation truth conditions are preserved by the final refresh in the formal model, yielding the post-refresh restoration form.

### T2 — interpretation

The result is intentionally premise-visible:

```text
selection != effectiveness.
```

`RepairSet` provides combinatorial coverage. `RepairRealization` carries domain/transition-specific semantic responsibility.

The paper therefore should not say:

```text
hitting sets are sufficient for restoration.
```

It should say:

> **Under a sound repair realization, a repair set that hits all represented unresolved cuts composes to target restoration.**

## 7. T3: Inclusion-Minimal Repair and Private-Cut Witnesses

`MinimalRepairSet(problem,X)` means:

1. `X` is a repair set;
2. no proper subset of `X` remains a repair set.

For any selected action `x` in such a set, removing `x` breaks repair-set validity. More informatively, there exists a represented unresolved hyperedge hit by `x` for which no other distinct selected action in `X` is an alternative.

That edge is a **private-cut witness** for `x` relative to `X`.

In the running example:

```text
X1 = {a,l,c}
X2 = {b,l,c}
```

`a` is locally non-removable inside `X1`, while `b` occupies the analogous role inside `X2`. Therefore private-cut necessity is local to a selected repair set; it does not make `a` globally necessary across all repairs.

### T3 — explicit non-claims

The theorem establishes none of:

```text
minimum cardinality
minimum cost
optimality
uniqueness
canonical repair frontier
optimal execution order.
```

The combinatorics is classical. The contribution is its typed semantic placement inside the revision architecture and the proof-visible local witness carried into the paper's responsibility interpretation.

## 8. Boundary Proposition: Represented-Cut Necessity Is Not Model Completeness

A stronger question asks:

> If an arbitrary action set really restores the chosen target, must it hit every represented cut?

Bare hypergraph structure cannot justify that statement.

The explicit premise

```text
EveryRepairCutNecessary(problem,Restore)
```

requires that any set satisfying the chosen `Restore` predicate hits every represented edge.

Under that premise, a restoring set is a `RepairSet` for the represented problem.

This should be read as a **boundary proposition**, not as a fifth headline result family or as deep lower-bound mathematics. Its importance is where the proof responsibility is placed:

> **Hypergraph minimality is exact relative to the represented obligation model. Necessity of represented cuts requires an explicit premise; completeness of the extraction remains a separate modeling/epistemic responsibility.**

In particular:

```text
EveryRepairCutNecessary
!=
proof that no necessary dependency was omitted.
```

This is the direct interface to the program's deeper `Q_open` problem. Paper 3 answers:

```text
given a supplied responsibility-cut model,
how is repair selected, realized, and executed?
```

It does not answer:

```text
when is the system entitled to believe
that its current responsibility vocabulary and cuts are adequate?
```

## 9. Figure 2 — Selection, Effectiveness, and Execution

The second primary figure should emphasize interfaces, not graph aesthetics:

```text
EXTRACTED REPAIR MODEL

RepairProblem
     |
     | represented unresolved cuts
     v
RepairSet
     |
     | unordered selection only
     v
RepairRealization
     |
     | semantic effectiveness certificate
     v
RevalidationTrace
     |
     | ordered proof-carrying execution
     v
reachable restored state
```

Side annotation:

```text
selection
!= effectiveness
!= executability/order
!= extraction completeness.
```

The hypergraph branch from the running example can be shown as an inset rather than the main visual identity of the paper.

## 10. T4: Reachable Proof-Carrying Realization

Set-level repair theory is intentionally unordered. Actual repair has dependencies.

The reachable layer provides three typed repair actions.

### 10.1 Warrant repair

Warrant revalidation cannot arbitrarily write `LIVE/PLACED`. It must reuse an already trusted ROOT, INFER, or TRANSPORT qualification `Step` at the exact evaluation key.

### 10.2 License repair

License revalidation may clear review only after the other represented `BaseCurrent` premises hold again.

### 10.3 Context repair

Context reactivation requires preserved Adopt provenance, the exact recovered `BaseCurrent` license, target identity, and a grounded issuer. It restores seed activity; final refresh confirms groundedness.

### 10.4 Ordered trace and reachability

`RevalidationTrace` is a list of repair actions. The adjacent lifecycle is:

```text
S0 --challenge--> S1
   --refresh--> S2
   --revalidate(actions)--> S3
   --refresh--> S4.
```

The reachability-strengthened theorem consumes `RevalidationReachable S0`, the valid lifecycle steps, a `RepairSet` over the trace action set, and a sound `RepairRealization`, then concludes:

```text
RevalidationReachable S4
and
target.Holds S4.
```

### T4 — interpretation

This is a realizability bridge. It does not prove:

```text
every RepairSet is executable
every MinimalRepairSet has an execution order
any order works
two abstract minimal alternatives are both reachable
```

The distinction between candidate, realizable, and reachable repair is retained rather than collapsed.

## 11. Historical Preservation Across the Lifecycle

The modeled challenge, refresh, and repair transitions have stage-local preservation results for the relevant canonical referents/topology.

The final reachable restoration theorem does not syntactically package an explicit end-to-end:

```text
HistoryReferentsImmutable(S0.core,S4.core)
```

conjunct.

Accordingly, the paper states the precise compositional claim:

> Each modeled challenge, refresh, and repair stage preserves the relevant canonical historical referents; restoration therefore does not require rewriting the canonical derivation history.

No new theorem is required merely to package those existing stage-local results aesthetically.

## 12. Mechanization and Artifact Boundary

The Paper 3 semantic baseline is PR #48 merge commit:

```text
190e24e404c864ef8f535f8dbd101c319689e4bc
```

Relevant Lean modules include:

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

Later manuscript and repository-management commits do not retroactively change this formal semantic baseline.

The formal artifact does not verify `portable-runtime`. The two repositories are related by framework reference/specialization and operationalization boundaries, while their dependency-propagation semantics are not identical. A future bridge should be stated as observational abstraction/refinement over selected observations if and when such a theorem is built.

## 13. Related Work Positioning

Paper 3 deliberately concedes four mature prior-art families.

**Truth maintenance and belief revision.** TMS/ATMS and belief-revision systems already retain reasons/assumptions while current belief status changes. The contribution here is not the generic idea of persistent support plus mutable acceptance, but a typed state model that keeps historical warrant identity, exact-key usability, license currentness, and context groundedness separate through invalidation and repair.

**Provenance, incremental recomputation, and change-impact analysis.** These traditions already represent derivational dependencies and identify affected computations or program elements. Paper 3 does not claim novelty for lineage or affectedness. Its downstream question is how typed current-responsibility obligations are selected and re-established after impact has been modeled.

**Revocable/stateful authorization.** Prior systems already establish that past credentials or proofs need not imply current authorization. The contribution here is not revocation itself, but the separation and repair of multiple downstream currentness layers while historical referents remain preserved.

**Model-based diagnosis and hitting sets.** Reiter-style diagnosis is the strongest combinatorial neighbor. Minimal hitting sets and non-unique solutions are classical. Paper 3's novelty claim therefore does not rest on the hitting-set construction; it rests on the formal placement of selection between typed currentness loss, semantic realization, represented-cut necessity, and proof-carrying reachable execution.

The two program-level distinctions remain:

```text
persistent historical dependency
!= state-indexed current responsibility
```

and:

```text
impact detection
!= responsibility restoration.
```

## 14. Limitations and Open Boundaries

The central limitations are intentional responsibility boundaries.

**No automatic repair-model extraction.** A `RepairProblem` is supplied and checked for its represented well-formedness. Paper 3 does not derive a complete repair hypergraph from every challenged state.

**Represented-cut necessity is not extraction completeness.** `EveryRepairCutNecessary` concerns represented edges relative to a chosen restoration predicate. It does not prove that no real dependency is missing.

**No repair optimization.** Inclusion-minimality is sufficient for local non-redundancy; cost/cardinality/latency/risk objectives are outside scope.

**No execution completeness.** Abstract alternatives need not all have reachable traces.

**Specialized impact semantics.** Warrant-parent transitive closure is a model-specific impact policy, not a universal dependency algorithm.

**No runtime refinement.** `portable-runtime` is related architecture/implementation, not a proved implementation of this Lean transition system.

**No cross-domain invariance theorem.** Similar responsibility structures in other domains remain candidates until separately formalized and compared.

**No Q_open solution.** The formalism studies correct repair inside a supplied responsibility vocabulary. It does not determine when that vocabulary itself should be reopened.

## 15. Discussion: From Paper 3 to the Research Program

The first three paper lines can be read as one progression:

```text
Paper 1 — Object
  history vs current qualification

Paper 2 — Environment
  migrated history vs current environment responsibility

Paper 3 — Change
  preserved history vs invalidated/restored current responsibility
```

or more compactly:

```text
identity -> environment -> change.
```

The next theory-level axis is not another lifecycle constructor. It is **regime adequacy**:

```text
correct action inside a responsibility topology
!=
entitlement to conclude that the topology itself is adequate.
```

This is the `Q_open` problem. A later multi-agent theory (`Q_close`) asks how responsibility is represented and discharged across heterogeneous agents without equating joint representation with distributed responsibility completion.

## 16. Conclusion

Paper 3 begins from a simple revision requirement: current responsibility must be withdrawable without erasing historical dependency. The mechanized kernel demonstrates this separation across warrant usability, license `BaseCurrent`, and context `Groundedness`; challenge and refresh can weaken those currentness layers while canonical referents remain recorded.

Given a finite repair instance, the paper then keeps repair selection, semantic effectiveness, represented-cut necessity, extraction completeness, and ordered execution distinct. A repair set covers represented unresolved cuts; restoration additionally requires a sound `RepairRealization`; inclusion-minimal repair sets admit local private-cut witnesses; and a proof-carrying ordered trace reconnects the extensional repair model to reachable state. The bare hypergraph does not certify the completeness of its own responsibility model.

The resulting contribution is a scoped revision architecture rather than a new hitting-set theory:

> **Preserve the history of why a responsibility structure exists; withdraw and explicitly re-establish the current responsibilities that no longer hold.**

The next theoretical question is therefore not how to add one more repair constructor, but when a finite system is entitled to decide that the responsibility model being repaired is itself no longer sufficient.

## References

Bibliographic entries are inherited from the verified Paper 3 related-work baseline and should be normalized in the dedicated citation-polish pass. No new priority claim is introduced by this conceptual compression.