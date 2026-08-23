# Dependency-Sensitive Revision and Minimal Responsibility Repair in a Finite Epistemic Kernel

Working submission draft — Paper 3

## Abstract

Long-lived reasoning systems need to preserve why an object was formed without assuming that the same object remains usable after its dependencies change. This paper studies that separation in a finite state-backed epistemic kernel. Canonical warrant history is immutable across the modeled challenge and repair boundaries, while three current-responsibility layers—warrant usability, activation-license currentness, and context groundedness—may become stale. A challenge affects exactly a target warrant and its historical descendants in the represented warrant graph; the resulting currentness loss can propagate through license support and adopted-context activation.

We model restoration as a finite directed-hypergraph repair problem. Hyperedges represent unresolved responsibility cuts, and candidate repair actions hit those cuts. A repair set is therefore a hitting set of the represented cuts. Hitting-set membership alone is not sufficient for restoration: a separate `RepairRealization` certificate connects selected actions to restored obligations and the repaired dependencies to the target. Inclusion-minimal repair sets admit local private-cut witnesses: every selected action is non-removable relative to that repair set because some unresolved cut is hit by no other different selected action in the set. This is inclusion minimality only; we do not claim minimum cardinality, optimality, uniqueness, or a canonical repair frontier.

Universal restoration lower bounds require an additional premise, `EveryRepairCutNecessary`, asserting that every extracted cut is genuinely necessary for the chosen restoration predicate. Thus hypergraph minimality is exact relative to the extracted obligation model, while adequacy of that extraction remains a separate epistemic and modeling responsibility. Finally, an ordered proof-carrying revalidation trace connects the unordered repair theory back to reachable state without collapsing warrant, license, and context restoration into one validity flag. The development is mechanized in Lean.

## 1. Introduction

A historical dependency and a current permission to rely on that dependency answer different questions.

Suppose a system has recorded that a derived warrant `d` was formed from a parent warrant `p`. Later, `p` is challenged. Deleting the historical edge `p -> d` would destroy the explanation of why `d` exists. Retaining that edge while continuing to treat `d` as currently usable would ignore the challenge. A durable system needs both facts:

```text
p historically supported d
```

and, independently,

```text
d is or is not currently usable here and now.
```

This distinction becomes more consequential when currentness itself has layers. A warrant may support an activation license; that license may ground an adopted context; a context may remain historically present even when it is no longer currently grounded. A single challenge can therefore leave canonical history intact while weakening several downstream current-responsibility judgments.

The problem addressed in this paper begins after that discontinuity:

> Once current responsibility has been invalidated but canonical history is preserved, what must be repaired before a target may again count as current?

The immediate answer—"revalidate everything affected"—is too coarse. First, affectedness and restoration are different relations. An affected object may not itself require the same local repair action as another affected object. Second, a restoration problem may admit alternatives: an unresolved responsibility cut may be discharged in more than one way. Third, selecting a mathematically sufficient set of candidate responsibilities is not the same as executing those responsibilities in a valid order. Fourth, the extracted dependency model may itself be incomplete or mistaken.

We therefore separate four judgments:

```text
impact detection
!= repair selection
!= repair realization
!= extraction adequacy.
```

The paper develops this separation in a finite Lean model. The central result is not a new hitting-set algorithm. Minimal hitting sets are classical, especially in model-based diagnosis. The contribution is the placement of hitting-set repair inside a typed revision lifecycle that keeps persistent historical dependency distinct from time-indexed current responsibility.

### 1.1 Contributions

The formal development supports five contribution families.

1. **Exact historical impact in the represented warrant graph.** A challenge affects exactly the target warrant and its transitive historical descendants. This is a specialized dependency semantics, not a claim about arbitrary runtime or real-world dependency graphs.

2. **Currentness invalidation across three layers.** Challenge may suspend warrant usability while preserving historical referents; affected support can make activation licenses non-current; fixed-point refresh can then remove adopted contexts whose activation responsibility is no longer grounded. Issuer loss can cascade to downstream adopted contexts.

3. **Dependency-sensitive repair semantics.** Stale warrant usability, license `BaseCurrent`, and context `Groundedness` are represented as separate repair obligations. A finite directed hypergraph maps stale obligations to alternative repair actions. A `RepairSet` is a hitting set of all unresolved responsibility cuts.

4. **Sufficiency and local necessity without overclaiming.** A repair set restores a target only together with a sound `RepairRealization`. Inclusion-minimal repair sets give every selected action a private-cut witness. Universal lower bounds from semantic restoration to cut hitting additionally require `EveryRepairCutNecessary`, an explicit adequacy premise.

5. **Reachable restoration bridge.** Repair selection is unordered, but execution is represented by an ordered `RevalidationTrace`. Warrant repair must reuse a trusted qualification transition; license repair clears review only after its other currentness premises recover; context repair requires immutable Adopt provenance, a current license, and a grounded issuer; a final refresh confirms grounded currentness.

### 1.2 Claim discipline

The paper uses "responsibility" in a narrow formal sense: a modeled requirement that must hold or be discharged at a particular semantic boundary. It does not establish moral, legal, institutional, or professional responsibility.

Likewise, "minimal" always means **inclusion-minimal relative to the represented repair hypergraph** unless otherwise stated. We do not prove a unique frontier, minimum-cardinality repair, minimum-cost repair, or globally optimal repair plan.

Finally, the formalism does not infer that its own extracted repair cuts are complete. The premise needed for universal necessity is explicit and visible in the theorem statement.

## 2. Background and State Model

The broader kernel distinguishes canonical historical objects from mutable current evaluation. This paper begins from that existing separation and adds challenge, invalidation, repair, and revalidation.

### 2.1 Canonical history

A canonical state stores contexts, profiles, bindings, historical warrants, and related immutable referents. Historical warrants include parent identifiers. For the present paper, those parent identifiers induce the dependency graph used by challenge impact.

A direct historical child edge is:

```text
DirectDescendant(S, parent, child)
```

when `child` is a canonical historical warrant whose stored parent list contains `parent`.

The transitive descendant relation is the nonempty finite transitive closure of these edges:

```text
DescendantOf(S, ancestor, child).
```

Historical identity is intentionally not a currentness judgment. A warrant may remain a canonical object while its current evaluation changes.

### 2.2 Warrant currentness

Current warrant usability is indexed by an exact evaluation key:

```text
(profileDigest, contextId, use, warrantId).
```

In the current kernel, usability is represented by the conjunction of `LIVE` epistemic status and `PLACED` placement at that key.

This exact indexing matters. Historical parent identity is persistent, while the current judgment is time- and environment-sensitive.

### 2.3 Activation licenses and context groundedness

The Adopt layer introduces activation licenses and activation provenance. A license is `BaseCurrent` only when its represented binding, context, scope, review, and support premises hold. Support warrants are checked for current usability at exact keys.

A context is `Grounded` through either bootstrap support or an Adopt activation whose exact license is current and whose issuer is itself grounded.

Thus the modeled currentness layers are:

```text
warrant Usable
license BaseCurrent
context Grounded.
```

The three are intentionally not compressed into one `valid` predicate.

## 3. Running Counterexample

We use one counterexample throughout the paper.

Assume a reachable state `S0` with a historical warrant edge:

```text
p ----historical parent----> d
```

and an activation license `L` whose support includes `d`, issued from grounded context `c0` to adopted context `c1`:

```text
c0 --L(support=[d])--> c1.
```

Before challenge:

```text
Usable(S0, kd)
BaseCurrent(S0, L)
Grounded(S0, c0)
Grounded(S0, c1),
```

where `kd` is the exact evaluation key for `d` relevant to the license.

A valid challenge targets `p`. Because `d` is a historical descendant, both `p` and `d` are affected. The challenge leaves canonical warrants and parent relations unchanged, but an affected `LIVE` evaluation can become `SUSPENDED`, descendant placement can become `PENDING`, and an impacted license can be marked for review.

After the first fixed-point refresh, the dependency chain may be:

```text
Usable(d)          no
   |
   v
BaseCurrent(L)     no
   |
   v
Grounded(c1)       no.
```

The historical plane still contains:

```text
p -> d -> support(L) -> Adopt provenance(c1).
```

This is the central discontinuity:

```text
historical dependency remains
while
current responsibility is withdrawn.
```

At the refreshed state `S2`, define stale obligations:

```text
Ow = warrantUsable(kd)
Ol = licenseBaseCurrent(L)
Oc = contextGrounded(c1)
```

with target `Oc`.

To illustrate genuine hypergraph branching, suppose the extracted repair model gives the warrant cut two candidate alternatives:

```text
e_w : Ow <- {a,b}
e_l : Ol <- {l}
e_c : Oc <- {c}
```

where:

```text
a = revalidateWarrant(kd)
b = a distinct modeled warrant-level repair candidate
l = revalidateLicense(L)
c = revalidateContext(c1).
```

Then two incomparable inclusion-minimal hitting sets are:

```text
X1 = {a,l,c}
X2 = {b,l,c}.
```

The example does not claim that the current reachable transition layer automatically executes both branches. Each sufficient branch requires its own sound `RepairRealization`; the current reachable layer directly realizes the exact-key branch represented by `a`.

For `X1`, an executable order is:

```text
revalidate warrant
-> revalidate license
-> reactivate context
-> final refresh.
```

This order is not encoded in the set-theoretic definition of `RepairSet`; it belongs to the execution layer.

## 4. Exact Historical Impact

We define challenge impact by historical identity and descendant reachability:

```text
Affected(S,target,w)
  := (w = target) or DescendantOf(S,target,w).
```

### Theorem 1 — Exact affected boundary

For every state `S`, target `t`, and warrant `w`:

```text
Affected(S,t,w)
<->
w = t or DescendantOf(S,t,w).
```

The theorem is definitional but important as a claim boundary: the affected set is exactly the target plus its represented historical descendants.

Supporting results show that the target is affected, every transitive descendant is affected, unrelated non-target warrants are not affected, and affectedness is closed under descendant edges.

### Scope of the result

The theorem does not claim that all dependency systems should recursively invalidate descendants. It applies to the canonical warrant-parent relation in this model. Operational runtime dependencies, causal dependencies, authorization relationships, and external data dependencies may require different impact policies.

This distinction matters because `portable-runtime`, for example, includes direct typed dependency-impact semantics that are not identical to this specialized transitive warrant closure. No cross-repository refinement claim is made here.

## 5. Challenge-Induced Currentness Loss

A challenge transition validates a canonical binding, context, challenger, BRIDGE warrant, and target. The challenger and BRIDGE warrant must be currently usable at the challenge key, and the BRIDGE claim must exactly identify the challenge relation.

The challenge updates mutable evaluation/currentness state while preserving historical topology.

### 5.1 Warrant evaluation

For affected keys at the challenged profile/use coordinate:

```text
LIVE -> SUSPENDED.
```

For proper affected descendants:

```text
PLACED -> PENDING.
```

The target's own placement is not changed by this rule.

Unaffected evaluation coordinates remain unchanged.

### 5.2 Historical preservation

The challenge transition leaves contexts, profiles, bindings, warrants, licenses, Adopt license records, active-context seed state, and activation provenance unchanged at the topology level.

A separate theorem establishes `HistoryReferentsImmutable` across challenge invalidation.

This is the first main paper separation:

```text
history continuity
!= currentness continuity.
```

### 5.3 License currentness

An enriched Adopt license is challenge-impacted when it has matching profile/use coordinates and some stored support warrant lies in the affected historical closure.

Challenge marks such licenses for review. The post-challenge `BaseCurrent` judgment is therefore stricter: anything `BaseCurrent` after challenge was already `BaseCurrent` before challenge.

The result is monotonic loss, not synthesis of new currentness.

## 6. Grounded Refresh and Cascading Loss

After challenge invalidation, the model performs a fixed-point refresh of active contexts.

Define:

```text
refreshActiveContexts(A).activeContext(key)
<-> Grounded(A.toActivationRead,key).
```

### Theorem 2 — Refresh is contractive

If a context is active after refresh, it was in the pre-refresh active seed.

Therefore refresh cannot reactivate a context that has already dropped from seed activity.

### Theorem 3 — Stale activation cannot survive refresh

If a context has Adopt activation provenance through license `L`, but `L` is not `BaseCurrent`, then that context is not active after refresh.

### Theorem 4 — Issuer loss cascades

If an adopted context's groundedness depends on issuer context `i`, and `i` does not survive refresh, then the dependent context does not survive either.

The running example therefore exhibits a typed cascade:

```text
warrant currentness loss
-> license currentness loss
-> context groundedness loss.
```

These are implications through modeled dependencies, not definitional equalities between the predicates.

### Why refresh is not revalidation

Because refresh is contractive, simply running refresh a second time cannot restore a removed adopted context. Restoration requires explicit re-establishment of the relevant currentness responsibilities and then a final refresh to confirm groundedness.

This observation motivates the repair layer.

## 7. Repair Obligations and Directed Hypergraphs

The repair semantics introduces three obligation forms:

```text
warrantUsable(key)
licenseBaseCurrent(licenseId)
contextGrounded(contextKey).
```

Historical well-formedness is intentionally absent. The challenge does not make the historical warrant graph malformed; it makes current responsibilities stale.

For state `A`:

```text
StaleDependency(A,o) := not o.Holds(A).
```

A repair hyperedge contains:

```text
obligation : RepairObligation
alternatives : List RepairAction.
```

A well-formed `RepairProblem(A)` records:

- a target obligation;
- a finite list of stale dependencies, each provably stale in `A`;
- a finite list of nonempty hyperedges;
- every edge points to a listed stale dependency;
- every listed stale dependency is exposed by at least one edge.

### 7.1 Hitting a responsibility cut

A candidate action set `X` hits an edge when it contains at least one action listed among that edge's alternatives.

A repair set is:

```text
RepairSet(problem,X)
:=
forall edge in problem.edges,
  HitsRepairEdge(X,edge).
```

Multiple edges encode conjunction: all cuts must be hit.

Multiple alternatives within one edge encode disjunction: any selected alternative can hit that cut.

### 7.2 What `RepairSet` does not mean

`RepairSet` does not say:

- that the selected actions are executable;
- that they are effective;
- that they can be ordered;
- that hitting the represented cuts restores the target;
- that the represented cuts are a complete model of real restoration.

Those responsibilities are deliberately placed elsewhere.

## 8. Sufficiency Requires Repair Realization

A central design choice is that the hypergraph does not prove its own semantic adequacy.

`RepairRealization(problem,X,revalidated)` is a proof certificate with two obligations.

First, if a selected action hits an unresolved edge, that edge's obligation holds in the revalidated state.

Second, if every declared stale dependency holds in the revalidated state, the target holds.

### Theorem 5 — Edge restoration

If `X` is a repair set and `R` is a sound repair realization, then every represented repair edge's obligation holds in the revalidated state.

### Theorem 6 — Stale dependency restoration

Because every declared stale dependency is exposed by at least one edge, a repair set plus realization restores every declared stale dependency.

### Theorem 7 — Target sufficiency

```text
RepairSet(problem,X)
+
RepairRealization(problem,X,A')

=> problem.target.Holds(A').
```

The final fixed-point refresh preserves all three represented repair-obligation truth conditions. Thus:

```text
RepairSet(problem,X)
+
RepairRealization(problem,X,A')

=> problem.target.Holds(Refresh(A')).
```

### Interpretation

This theorem separates selection from effectiveness.

The hypergraph says which unresolved cuts must be hit. The realization certificate says that the chosen local responsibilities actually repair those cuts and jointly close the target.

This avoids a circular definition in which a "repair set" simply means "whatever restores the target."

## 9. Inclusion-Minimal Repair and Private Cuts

Define pointwise subset and proper subset relations on repair-action predicate sets.

`MinimalRepairSet(problem,X)` means:

1. `X` is a repair set;
2. every proper subset of `X` fails to be a repair set.

This is inclusion minimality only.

### Theorem 8 — Removing a selected member breaks repair-set validity

For any selected action `a` in an inclusion-minimal repair set `X`:

```text
not RepairSet(problem, X \ {a}).
```

### Theorem 9 — Every minimal member has a private cut

For every selected `a` in an inclusion-minimal repair set `X`, there exists an edge `e` such that:

1. `e` is an unresolved edge of the repair problem;
2. `a` is an alternative on `e`;
3. among actions selected by `X`, any selected alternative on `e` is equal to `a`.

Thus `e` is a local witness of why `a` cannot be removed from that repair set.

### Why the witness is local

The theorem does not say that `a` is globally necessary across all repairs.

In the running example:

```text
X1 = {a,l,c}
X2 = {b,l,c}
```

`a` has a private cut relative to `X1`, while `b` has the corresponding private cut relative to `X2`.

The existence of alternatives is therefore compatible with local necessity.

### What is not proved

No theorem establishes:

```text
minimum cardinality
minimum cost
unique minimal repair
canonical frontier
optimal action order.
```

Those are separate optimization problems.

## 10. Universal Necessity and the Adequacy Boundary

The previous minimality results are exact relative to a supplied `RepairProblem`.

A stronger question is:

> If some arbitrary action set really restores the target, must it hit every represented cut?

The answer is not derivable from the hypergraph representation alone.

Define:

```text
EveryRepairCutNecessary(problem,Restore)
```

to mean that for every action set `X` and every represented edge `e`:

```text
Restore(X) and e in problem.edges
=> HitsRepairEdge(X,e).
```

### Theorem 10 — Universal lower bound under adequacy

Under `EveryRepairCutNecessary(problem,Restore)`:

```text
forall X,
  Restore(X)
  -> X hits every represented cut.
```

Equivalently:

```text
Restore(X) -> RepairSet(problem,X).
```

### Why the premise is central

Without the adequacy premise, an extracted edge might be unnecessary for the chosen restoration predicate. The formalism refuses to infer universal necessity merely because an edge has been placed in the model.

We therefore treat the following statement as part of the main theory, not as a footnote:

> **Hypergraph minimality is exact relative to the extracted obligation model; adequacy of that extraction is a separate epistemic/modeling responsibility.**

This boundary is also the interface to a broader open problem. The present paper answers:

```text
given a finite responsibility-cut model,
how should repair be characterized?
```

It does not answer:

```text
when is a finite system entitled to believe
that its current responsibility vocabulary and extracted cuts
are adequate to the real problem?
```

The latter belongs to a deeper revision/opening theory.

## 11. From Unordered Repair to Reachable Execution

The hypergraph theory is intentionally unordered. A repair set is a predicate over actions, not a schedule.

Actual repair can have dependencies. In the running example, license repair cannot validly clear review until the other represented `BaseCurrent` premises are restored. Context reactivation cannot validly occur until its Adopt license is current and its issuer is grounded.

We therefore introduce:

```text
RevalidationTrace : List RepairAction.
```

The trace records an ordered sequence of proof-carrying repair transitions.

### 11.1 Warrant repair

Warrant revalidation does not introduce a generic write that marks an arbitrary warrant `LIVE/PLACED`.

Instead, it must be witnessed by one of the already trusted qualification transitions—ROOT admission, INFER qualification, or TRANSPORT qualification—for the exact evaluation key.

Thus warrant repair reuses existing formation/qualification responsibility boundaries.

### 11.2 License repair

License repair changes only the review-required predicate for the selected license.

It is permitted only when every other represented `BaseCurrent` premise already holds, including canonical binding/context relationships, scope discipline, and usability of all stored support warrants.

Clearing review after those conditions recover makes the exact represented license `BaseCurrent` again.

### 11.3 Context repair

A context removed by contractive refresh requires explicit reactivation.

Context repair requires:

- the context is currently inactive;
- immutable Adopt activation provenance still points to the exact license;
- the exact Adopt license is present and `BaseCurrent`;
- the license target is the context being repaired;
- the issuer context is grounded.

The repair restores seed activity. A final refresh then confirms groundedness.

### 11.4 Historical preservation

Each repair action preserves canonical historical referents. Refresh changes only active-context membership and preserves the historical/evaluation structures listed by its topology theorem.

The final lifecycle theorem does not package an explicit end-to-end `HistoryReferentsImmutable(S0,S4)` conjunct. We therefore state history preservation compositionally at the stage level rather than claiming a stronger packaged theorem.

## 12. Reachable Revalidation Lifecycle

The adjacent lifecycle is:

```text
S0 --challenge--> S1
   --refresh--> S2
   --revalidate(actions)--> S3
   --refresh--> S4.
```

The theory distinguishes two theorem strengths.

### Theorem 11 — Conditional adjacent restoration

Given:

- a valid challenge `S0 -> S1`;
- first refresh `S1 -> S2`;
- ordered repair trace `S2 -> S3`;
- `RepairSet(problem, TraceActionSet(actions))`;
- a sound `RepairRealization` for `S3`;
- final refresh `S3 -> S4`;

then:

```text
problem.target.Holds(S4).
```

The challenge, first refresh, and trace witness the lifecycle shape, while the restoration proof itself is supplied by repair-set sufficiency plus realization and final-refresh preservation.

### Theorem 12 — Reachability-strengthened restoration

If, additionally:

```text
RevalidationReachable(S0),
```

then the lifecycle remains inside the formal reachable relation and concludes:

```text
RevalidationReachable(S4)
and
problem.target.Holds(S4).
```

### Role of the lifecycle theorem

This theorem is a realizability bridge. It is not the main source of minimality or necessity.

The theoretical center of the paper remains the sequence:

```text
currentness discontinuity
-> explicit repair cuts
-> conditional sufficiency
-> inclusion-minimal private-cut necessity
-> explicit adequacy boundary.
```

## 13. Mechanization and Artifact Boundary

The development is implemented in Lean under the `ResponsibilityTopology` namespace.

The Paper 3 line is separated from the frozen Paper 1/2 audit surface. `Paper3Audit.lean` prints axiom dependencies for the central challenge, refresh, repair, minimality, and revalidation theorems.

Relevant modules include:

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

The artifact is not a refinement proof for `portable-runtime`. The formal model and runtime are conceptually related but have different dependency-propagation surfaces. In particular, the formal challenge relation uses transitive canonical warrant descendants, while the runtime also contains direct typed dependency-impact mechanisms. This paper makes no claim that one implements or refines the other.

## 14. Related Work

### 14.1 Truth maintenance and belief revision

Doyle's Truth Maintenance System records reasons for program beliefs and revises the current belief set when assumptions or discoveries change. de Kleer's ATMS further manipulates assumption sets and labels across multiple environments. These systems are direct prior art for retaining justification structure while current support changes. AGM belief revision provides a broad rationality framework for contraction and revision of belief sets.

Our contribution is therefore not the abstract idea that stored reasons may outlive current acceptance. We study a narrower typed state model in which historical warrant ancestry, exact-key warrant usability, activation-license currentness, and context groundedness remain distinct, and then formulate repair over those explicit current-responsibility layers.

### 14.2 Provenance and incremental change propagation

Database provenance records derivational lineage; incremental view maintenance and self-adjusting computation propagate input changes through dependency structures; software change-impact analysis predicts which program elements may be affected by edits.

These traditions are close to our historical dependency and `Affected` relations. We do not claim novelty for provenance or dependency-driven impact detection.

Our emphasis is the next boundary:

```text
impact detection
!= responsibility restoration.
```

The repair problem is not merely a set of dirty nodes to recompute; it is a typed set of currentness obligations whose restoration requires explicit local responsibilities and, for semantic sufficiency, a realization certificate.

### 14.3 Revocable and stateful authorization

Proof-carrying and stateful authorization systems already make access depend on mutable state. Revocable and use-once proof-carrying file systems are particularly strong prior art: a historical certificate or proof can remain available while current authorization depends on revocation/consumption state checked at access time.

We therefore do not claim novelty for "once authorized does not imply still authorized."

The present formalism instead studies how several downstream currentness layers interact under invalidation and restoration, while keeping the historical dependency objects intact.

### 14.4 Model-based diagnosis and hitting sets

Reiter's model-based diagnosis is the closest combinatorial neighbor. Conflict sets lead to minimal hitting sets representing diagnoses; later diagnosis work develops related minimality, measurement, and repair methods.

Minimal hitting sets, non-uniqueness, and private combinatorial necessity are therefore not new mathematics here.

Our hypergraph has a different semantic interpretation. Its edges are stale current-responsibility cuts and its selected elements are repair actions, not abnormal components. More importantly for the theorem boundary, a hitting set alone does not establish restoration: `RepairRealization` supplies semantic effectiveness, while universal restoration lower bounds require the separate `EveryRepairCutNecessary` adequacy premise.

### 14.5 Summary of positioning

The two organizing distinctions are:

```text
persistent historical dependency
!= time-indexed current responsibility
```

and:

```text
impact detection
!= minimal responsibility restoration.
```

The second statement always means inclusion-minimal restoration relative to an extracted obligation model; it is not an optimality or completeness claim.

## 15. Limitations and Open Boundaries

The formal model is deliberately finite and narrow.

### 15.1 Extraction adequacy is assumed where needed

The model does not prove that a `RepairProblem` completely captures all real conditions for restoration. Universal necessity is conditional on `EveryRepairCutNecessary`.

This is the most important limitation and also an intentional responsibility boundary.

### 15.2 No unique or optimal frontier

Multiple incomparable inclusion-minimal repair sets may exist. We do not optimize cardinality, cost, latency, risk, or policy preference.

### 15.3 Alternative repair realizability is not complete

The extensional hypergraph semantics permits alternative actions on a cut. The current reachable revalidation layer gives narrow proof-carrying transitions for warrant, license, and context repair, but does not prove that every abstract repair alternative has an executable trace.

### 15.4 Specialized affected closure

`Affected` is transitive descendant closure over canonical warrant parents. This is not a generic theory of change impact for all dependency kinds.

### 15.5 Stage-local history preservation

Historical preservation is proved at the modeled challenge, refresh, and repair stages. The final lifecycle theorem does not contain an explicit end-to-end history-immutability conjunct.

### 15.6 No runtime refinement

No theorem states that `portable-runtime` refines the Lean model or vice versa.

### 15.7 No universal belief-revision or normative theory

The system does not decide moral responsibility, legal authority, truth, empirical adequacy, or the legitimacy of a challenge. It formalizes only the stated finite responsibility boundaries.

## 16. Discussion

### 16.1 Why separate impact from repair?

An impact relation is descriptive: it says which historical objects lie downstream of a challenged target under a particular dependency semantics.

A repair relation is prescriptive inside the model: it says which represented currentness responsibilities must be re-established before a target can count as restored.

Conflating the two can over-revalidate. Every affected historical descendant need not correspond one-to-one with a local repair action, and higher-level currentness obligations such as license or context currentness may introduce additional restoration responsibilities.

### 16.2 Why separate repair selection from realization?

A hitting set is a combinatorial object. Without a realization premise, it may contain candidate actions that do not actually establish the desired post-state.

The separate `RepairRealization` structure makes the proof obligation visible:

```text
selected responsibility
-> restored obligation
```

and:

```text
all declared stale obligations restored
-> target restored.
```

This is analogous to separating a plan skeleton from a proof that its steps achieve their contracts.

### 16.3 Why separate realization from adequacy?

Even a perfectly executed repair plan can be inadequate if the dependency model omitted a necessary cut.

`EveryRepairCutNecessary` addresses one direction—whether each represented cut is necessary for the selected restoration predicate—but does not establish that the model includes every real dependency.

The broader epistemic question remains open:

> When is a finite system entitled to treat its current dependency vocabulary as adequate?

Keeping that question explicit is preferable to hiding it inside a definition of repair.

### 16.4 Why not optimize yet?

Once repair is represented as a hitting-set problem, cost optimization is a natural next step. It is intentionally outside this paper.

Introducing weights would immediately raise questions about the meaning, provenance, and comparability of costs across warrant, license, and context repair. Those are not necessary to establish the current thesis.

The inclusion-minimal result is sufficient to show local non-redundancy without importing an unjustified scalar objective.

## 17. Conclusion

Canonical history and current responsibility should not be collapsed into one state relation. In the modeled kernel, challenge preserves historical warrant referents while weakening warrant usability, license currentness, and context groundedness. The affected historical closure is explicit, but impact detection alone does not determine restoration.

We represent stale current-responsibility obligations as a finite directed-hypergraph repair problem. Repair sets hit every represented unresolved cut; with a sound repair realization they restore the target. Inclusion-minimal repair sets admit private-cut witnesses explaining why each selected responsibility is locally non-removable. Universal lower bounds are deliberately conditional on an explicit cut-adequacy premise, making extraction adequacy a visible modeling responsibility rather than a hidden assumption. An ordered proof-carrying trace then connects the unordered repair theory to reachable revalidation while preserving the separation between warrant, license, and context repair.

The result is not a unique minimal revalidation frontier and not a generic theory of belief revision. It is a narrower formal claim:

> **When canonical history is preserved but current responsibility is invalidated, restoration can be treated as a dependency-sensitive repair problem without conflating historical dependency, currentness loss, repair selection, repair realization, and model adequacy.**

## References

Alchourrón, C. E., Gärdenfors, P., and Makinson, D. 1985. On the Logic of Theory Change: Partial Meet Contraction and Revision Functions. *Journal of Symbolic Logic* 50(2):510–530.

Acar, U. A., Blume, M., and Donham, J. 2011. A Consistent Semantics of Self-Adjusting Computation. arXiv:1106.0478.

Bohner, S. A., and Arnold, R. S. 1996. *Software Change Impact Analysis*. IEEE Computer Society Press / Wiley.

de Kleer, J. 1986. An Assumption-Based TMS. *Artificial Intelligence* 28(2):127–162. DOI: 10.1016/0004-3702(86)90080-9.

de Kleer, J. 1986. Problem Solving with the ATMS. *Artificial Intelligence* 28(2):197–224. DOI: 10.1016/0004-3702(86)90082-2.

Doyle, J. 1979. A Truth Maintenance System. *Artificial Intelligence* 12(3):231–272. DOI: 10.1016/0004-3702(79)90008-0.

Garg, D., and Pfenning, F. 2010. Stateful Authorization Logic — Proof Theory and a Case Study. *Security and Trust Management*.

Green, T. J., Karvounarakis, G., and Tannen, V. 2007. Provenance Semirings. *PODS 2007*.

Gupta, A., and Mumick, I. S. 1995. Maintenance of Materialized Views: Problems, Techniques, and Applications.

Morgenstern, J., Garg, D., and Pfenning, F. 2011. A Proof-Carrying File System with Revocable and Use-Once Certificates. *Security and Trust Management*, LNCS 7170:40–55. DOI: 10.1007/978-3-642-29963-6_5.

Reiter, R. 1987. A Theory of Diagnosis from First Principles. *Artificial Intelligence* 32(1):57–95. DOI: 10.1016/0004-3702(87)90062-2.

Ryder, B. G., and Tip, F. 2001. Change Impact Analysis for Object-Oriented Programs. *PASTE 2001*. DOI: 10.1145/379605.379661.
