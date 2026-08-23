# Dependency-Sensitive Revision and Minimal Responsibility Repair in a Finite Epistemic Kernel

## Abstract

Long-lived reasoning systems need to preserve why an object exists without assuming that the object remains safe to use after its dependencies change. We formalize this distinction in a finite epistemic kernel where canonical warrant history is persistent, while current responsibility is represented separately at three layers: warrant usability, Adopt-license currentness, and context groundedness. A valid challenge preserves canonical historical referents but may suspend affected warrant evaluations, mark dependent licenses for review, and—after a fixed-point refresh—remove adopted contexts whose current activation responsibility is no longer grounded.

We then model restoration as a finite directed-hypergraph repair problem. Nodes denote stale currentness obligations and hyperedges expose unresolved responsibility cuts; alternatives within an edge represent distinct candidate local repairs. A repair set is any hitting set of all unresolved cuts. Hitting a cut is not itself a restoration theorem: sufficiency additionally requires a `RepairRealization` certificate connecting selected actions to restored obligations and restored dependencies to the target. Inclusion-minimal repair sets admit local necessity witnesses: every selected action owns a private unresolved cut relative to that repair set. Universal semantic lower bounds require a separate `EveryRepairCutNecessary` premise, making adequacy of dependency-cut extraction an explicit modeling responsibility rather than a hidden consequence of the graph representation.

Finally, we connect unordered repair selection to an ordered proof-carrying lifecycle. Warrant repair must reuse an existing trusted qualification step, license repair may clear review only after its other currentness premises recover, context repair requires immutable Adopt provenance, a current license, and a grounded issuer, and a final refresh confirms grounded currentness. The resulting theorem threads challenge, refresh, repair, and final refresh through formal reachability. The contribution is not a new hitting-set algorithm or a universal theory of belief revision; it is a machine-checked separation of historical continuity, currentness invalidation, repair selection, repair realization, model adequacy, and reachable restoration.

---

## 1. Introduction

Reasoning systems routinely face a temporal mismatch between derivation and use. A conclusion may have been correctly formed from evidence that was available at one time, yet a later change can make present reliance on that conclusion inappropriate. Deleting the derivation loses audit history. Keeping the derivation and treating it as permanently usable loses currentness discipline.

This paper studies the boundary between those two failures.

Our starting point is a finite state model in which canonical historical warrant objects are distinct from current evaluation state. Historical objects record formation identity and parent relationships. Current usability is indexed by an exact evaluation key. The state also contains Adopt licenses and context activation structure. This gives three mutable currentness judgments that can fail independently:

```text
warrant Usability
license BaseCurrent
context Groundedness
```

The paper asks what happens after a valid challenge invalidates current responsibility while canonical history remains intact.

The theoretical progression is deliberately mechanical:

```text
historical/currentness discontinuity
-> exact affected closure
-> currentness loss
-> responsibility cuts
-> repair-set sufficiency
-> inclusion-minimality and private cuts
-> explicit adequacy boundary
-> ordered reachable realization
```

The central claim is:

> **When canonical history is preserved but current responsibility is invalidated, restoration is a dependency-sensitive repair problem whose sufficient repairs are hitting sets of unresolved responsibility cuts, and whose inclusion-minimal repairs admit local necessity witnesses.**

Two qualifications are part of the claim, not afterthoughts. First, a hitting set is sufficient only together with a sound semantic realization. Second, a universal statement that every true restoration must hit every represented cut requires an explicit adequacy premise connecting the extracted hypergraph to the chosen restoration predicate.

### Contributions

We make six contributions.

1. **Historical continuity under currentness invalidation.** We give a reachable challenge transition that leaves canonical warrant referents intact while weakening mutable evaluation, license, and grounded-context currentness.
2. **Exact specialized impact semantics.** For the represented warrant-history graph, challenge impact is exactly the challenged target plus its transitive historical descendants.
3. **Multi-layer repair semantics.** Stale warrant usability, license `BaseCurrent`, and context `Groundedness` become distinct repair obligations in a finite directed hypergraph whose edges represent unresolved responsibility cuts and whose alternatives represent candidate local repairs.
4. **Conditional sufficiency and local necessity.** `RepairSet + RepairRealization` restores the target; inclusion-minimal repair sets make each selected member non-removable and provide a concrete private-cut witness for that local necessity.
5. **Explicit extraction adequacy.** Universal restoration lower bounds are proved only under `EveryRepairCutNecessary`, separating combinatorial exactness relative to the extracted model from epistemic adequacy of the extraction itself.
6. **Reachable proof-carrying restoration.** An ordered `RevalidationTrace` gives layer-specific repair transitions and connects the set-level repair theory back to reachable state.

The paper does **not** claim a unique repair frontier, minimum-cardinality or minimum-cost repair, completeness of arbitrary dependency extraction, generic recursive invalidation for all runtime dependencies, or refinement of an external implementation.

---

## 2. State model and responsibility layers

### 2.1 Canonical history versus current evaluation

A canonical state contains immutable-style referents for contexts, profiles, bindings, and historical warrants, together with mutable current evaluation state. A warrant may remain a canonical historical object even when it is no longer usable at a particular evaluation coordinate.

An evaluation key has the conceptual shape

```text
(profileDigest, contextId, use, warrantId).
```

`Usable(S,key)` requires the exact key to be both epistemically `LIVE` and `PLACED`. The important point is relational: historical parenthood and current usability are different state relations.

### 2.2 Adopt licenses and grounded currentness

The state is enriched with Adopt licenses. A license is `BaseCurrent` only when its represented binding, contexts, profile/use coordinates, scope discipline, review state, and support usability satisfy the current license judgment.

Contexts are current through `Grounded`. Bootstrap contexts are grounded from appropriate seed activity; adopted contexts additionally depend on a current Adopt license and a grounded issuer. Thus currentness can propagate through context-issuer structure without becoming identical to warrant usability or license currentness.

This gives the dependency pattern:

```text
Usable(warrant support)
        |
        v
BaseCurrent(license)
        |
        v
Grounded(adopted context)
```

These arrows denote responsibility dependencies, not definitional equality.

### 2.3 Why three currentness layers matter

A single validity flag would hide where responsibility lies after change. Warrant repair may require requalification. License repair may require restored support and review clearance. Context repair may require recovered license currentness and a grounded issuer. Keeping the layers distinct lets later repair actions carry different preconditions and write different parts of state.

---

## 3. Challenge: canonical continuity with currentness discontinuity

A challenge is not a generic arbitrary mutation. Its constructor requires canonical binding/context/warrant referents, a currently usable challenger, a currently usable BRIDGE warrant, and an exact bridge claim naming challenger and target.

For a valid challenge, the formal state update is intentionally asymmetric.

Historical and activation topology are preserved:

```text
context/profile/binding/warrant maps unchanged
license records unchanged
Adopt license records unchanged
activation provenance unchanged
```

while mutable currentness may become stricter:

- affected `LIVE` evaluations become `SUSPENDED`;
- affected proper descendants with `PLACED` placement become `PENDING`;
- impacted Adopt licenses become `reviewRequired`;
- no new usability is created by challenge.

The formal support includes:

- `challengeStep_validation_exact`
- `challengeStep_topology_unchanged`
- `challengeStep_historyReferentsImmutable`
- `challengeEpi_live_affected`
- `challengePlacement_placed_affected`
- `challengeStep_reviewRequired_exact`
- `challengeStep_baseCurrent_stricter`

The paper therefore does not assert a universal formula such as "canonical well-formedness implies non-currentness." The relevant result is a witnessed transition on which exact historical preservation coexists with weakening of current relations.

This is the first discontinuity:

```text
what happened historically
        !=
what may be relied on now.
```

---

## 4. Exact affected closure for the represented warrant graph

The historical dependency direction is reconstructed from immutable parent identifiers.

`DirectDescendant(S,p,c)` holds when canonical child `c` names parent `p`. `DescendantOf` is its nonempty transitive closure. Challenge affectedness is then:

```text
Affected(S,target,w)
  := (w = target) OR DescendantOf(S,target,w).
```

Hence:

```text
Affected(target) = {target} union Descendants(target)
```

for this represented warrant graph.

The artifact proves direct inclusion, transitivity, non-target equivalence, unrelated non-affectedness, and downward closure along descendants. The central names are:

- `affected_iff_target_or_descendant`
- `challengeTarget_affected`
- `descendant_affected`
- `affected_nonTarget_iff_descendant`
- `unrelated_notAffected`
- `affected_closed_under_descendants`

This is an exact theorem because `Affected` is the chosen canonical-warrant impact semantics. It is **not** a claim that arbitrary software, provenance, authorization, or runtime dependency graphs should use recursive descendant invalidation. External dependency extraction remains outside this theorem.

The distinction between impact and restoration begins here:

```text
Affected(w)
```

answers which represented historical warrants fall inside the challenge closure. It does not yet say which repairs are sufficient to restore a selected currentness target.

---

## 5. Fixed-point refresh and currentness loss

Challenge invalidation changes evaluation and license-currentness conditions but does not itself recompute the set of grounded active contexts. A separate refresh projection does so.

The refresh boundary is:

```text
RefreshActive(c) <-> Grounded(invalidatedRead,c).
```

`refreshActiveContexts` changes only active-context membership; canonical history, activation provenance, licenses, review state, evaluation status, and placement are preserved by the projection.

Refresh is contractive: it cannot manufacture an active context outside the pre-refresh seed. This matters after invalidation. A stale Adopt license means a context activated through that license cannot survive refresh. Moreover, retention is issuer-closed: an adopted context that survives has a grounded issuer, so loss of the issuer cascades to its dependents.

Key results include:

- `refreshActiveContexts_active_iff`
- `refreshActiveContexts_contracts`
- `challengeStep_grounded_post_implies_pre`
- `refresh_staleActivation_notActive`
- `refresh_activeAdopt_implies_issuerActive`
- `refresh_issuerLoss_cascades`
- `challengeRefresh_retained_implies_preGrounded`

This establishes a three-layer failure pattern:

```text
support warrant loses Usability
        |
        v
Adopt license loses BaseCurrent
        |
        v
adopted context loses Groundedness
        |
        v
refresh removes current activity
```

A second refresh alone cannot reverse this loss. Because refresh is contractive, restoration requires explicit reactivation after the relevant dependencies recover.

---

## 6. Running counterexample

We use one example throughout the paper.

Assume a reachable state `S0` with a historical warrant parent `p`, a descendant warrant `d`, and an Adopt license `L` whose support includes `d`. The license is issued from grounded context `c0` to adopted context `c1`.

Historical structure:

```text
p ----historical parent----> d ----stored support----> L ----Adopt provenance----> c1
```

Initially:

```text
Usable(S0,kd)
BaseCurrent(S0,L)
Grounded(S0,c0)
Grounded(S0,c1).
```

### 6.1 Challenge

A valid challenge targets `p`. Since `d` is a historical descendant,

```text
Affected(S0,p,p)
Affected(S0,p,d).
```

After challenge `S0 -> S1`, `p`, `d`, their historical edge, `L`, and activation provenance remain. But affected evaluation may be suspended and the license is marked for review because its stored support intersects the affected closure.

Thus:

```text
HistoricalDependency(p,d) remains
```

while exact-key current usability may be lost.

### 6.2 First refresh

Applying refresh gives `S1 -> S2`. If `d` is no longer usable, `L` fails its current support/review requirements; if `L` is no longer current, `c1` is no longer grounded and is removed from active currentness.

The same historical object graph therefore coexists with a changed current responsibility graph.

### 6.3 Repair obligations

At `S2`, define three stale obligations:

```text
Ow = warrantUsable(kd)
Ol = licenseBaseCurrent(L)
Oc = contextGrounded(c1)

target = Oc.
```

Canonical historical well-formedness is deliberately not a repair obligation: history has not been erased.

### 6.4 A genuine hypergraph branch

Let candidate actions be:

```text
a = revalidateWarrant(kd)
b = revalidateWarrant(kalt)
l = revalidateLicense(L)
c = revalidateContext(c1).
```

The direct action `a` corresponds to the reachable exact-key warrant repair path. The alternative `b` is illustrative at the extensional hypergraph layer; the paper does not claim that #48 automatically realizes it.

Use cuts:

```text
e_w : Ow <- {a,b}
e_l : Ol <- {l}
e_c : Oc <- {c}.
```

Then two incomparable inclusion-minimal hitting sets are:

```text
X1 = {a,l,c}
X2 = {b,l,c}.
```

This single branch demonstrates why the model does not define *the* repair frontier. Inclusion-minimal repair need not be unique.

For `X1`, action `a` has private cut `e_w`, `l` has `e_l`, and `c` has `e_c`. For `X2`, `b` owns `e_w`. Local necessity does not mean global necessity: `a` is necessary relative to `X1` but absent from `X2`.

### 6.5 Semantic effectiveness remains separate

Neither hitting set restores anything merely by being a hitting set. `X1` is sufficient only if there is a sound realization `rho1` connecting its selected actions to restored obligations and closing the target. `X2` requires its own realization `rho2`.

Thus:

```text
candidate alternative
!= selected hitting set
!= sound realization
!= reachable execution trace.
```

That separation is central to the paper.

---

## 7. Repair as a finite directed-hypergraph problem

### 7.1 Repair obligations

The formal repair vocabulary has exactly three mutable/current responsibility layers:

```text
RepairObligation.warrantUsable(key)
RepairObligation.licenseBaseCurrent(licenseId)
RepairObligation.contextGrounded(key).
```

`StaleDependency(A,o)` means simply that obligation `o` no longer holds in state `A`.

The exact truth conditions are state-backed:

- warrant staleness iff non-usability;
- license staleness iff loss of identifier-level `BaseCurrent`;
- context staleness iff loss of `Grounded`.

### 7.2 Repair actions

Candidate local responsibilities are:

```text
revalidateWarrant(key)
revalidateLicense(licenseId)
revalidateContext(key).
```

At this semantic level they are labels, not state mutations.

### 7.3 Hyperedges and repair sets

A `RepairHyperedge` pairs a stale obligation with a nonempty list of alternative actions. A `RepairProblem` records:

- a target obligation;
- a finite list of stale dependencies, each known to be stale;
- a finite list of edges;
- proof that every edge points to a declared stale obligation;
- proof that every declared stale obligation is exposed by some edge.

Multiple edges are conjunctive cuts: every edge must be hit. Alternatives inside an edge are disjunctive at the selection layer: one selected action is enough to hit that edge.

A candidate action predicate `X` is a repair set when:

```text
forall edge in problem.edges,
  exists action in edge.alternatives,
    X(action).
```

This is ordinary hitting-set structure. The paper makes no novelty claim for the combinatorics.

---

## 8. Sufficiency requires a sound repair realization

A bare repair set only says that every represented unresolved cut has been selected against. It does not prove that selected action labels actually work.

`RepairRealization(problem,X,revalidated)` carries two semantic responsibilities:

1. whenever a selected action hits an unresolved edge, that edge's obligation holds in `revalidated`;
2. if every declared stale dependency holds in `revalidated`, then the target obligation holds there.

From these premises the artifact proves:

```text
RepairSet(problem,X)
+
RepairRealization(problem,X,revalidated)

=> every edge obligation restored
=> every declared stale dependency restored
=> target holds in revalidated
=> target holds after final refresh.
```

The final step relies on `repairObligation_refresh_iff`: the fixed-point refresh preserves all three represented repair-obligation truth conditions. Warrant usability and license `BaseCurrent` do not depend on active-context membership, and context `Groundedness` is refresh-idempotent.

Principal theorem:

```text
repairSet_sufficient_after_refresh
```

with the schematic form:

```text
RepairSet(problem,X)
∧ RepairRealization(problem,X,S')
=> problem.target.Holds(RefreshAfterRevalidation(S')).
```

Minimality is not necessary for sufficiency. `minimalRepairSet_sufficient_after_refresh` holds because every minimal repair set is first of all a repair set.

This gives a second major separation:

```text
selection sufficiency at the cut level
        !=
semantic effectiveness of selected repairs.
```

---

## 9. Inclusion-minimal repair and private-cut witnesses

`MinimalRepairSet(problem,X)` means inclusion minimality:

```text
RepairSet(problem,X)
```

and no proper pointwise subset of `X` remains a repair set.

The artifact proves two useful forms.

First, deletion form:

```text
x in X
∧ MinimalRepairSet(problem,X)
=> not RepairSet(problem, X \ {x}).
```

Second, a local witness form:

```text
x in X
∧ MinimalRepairSet(problem,X)
=> exists edge e,
     e is unresolved
     ∧ x is an alternative on e
     ∧ every selected alternative on e equals x.
```

The second theorem (`minimalRepairSet_has_private_edge`) explains non-removability locally. Every selected repair action in an inclusion-minimal set owns some unresolved cut that no different selected member hits.

This is intentionally **not** a global optimality theorem. The paper does not claim:

- minimum cardinality;
- minimum cost;
- Pareto optimality;
- uniqueness;
- canonicality;
- equal size of all minimal repair sets.

The running example's `X1` and `X2` make this limitation concrete.

The private-cut theorem should also not be advertised as new hypergraph theory. Its contribution is that the finite responsibility-repair model exposes a machine-checked local necessity witness in exactly the form needed by the paper's interpretation.

---

## 10. Universal necessity and the extraction-adequacy boundary

A natural reviewer question is stronger:

> If an arbitrary action set really restores the target, must it hit every represented unresolved cut?

The answer cannot follow from the bare hypergraph representation. A malformed or incomplete extraction could contain a cut that real restoration bypasses, or omit a dependency that matters.

The formalization therefore introduces:

```text
EveryRepairCutNecessary(problem, Restore)
```

meaning that for the chosen semantic restoration predicate `Restore`, every restoring set must hit every edge in `problem`.

Only under that premise do we obtain:

```text
forall X,
  Restore(X)
  -> X hits every unresolved dependency cut
```

and hence:

```text
Restore(X) -> RepairSet(problem,X).
```

This is not a technical nuisance to hide in limitations. It is the location of a distinct responsibility:

> **Hypergraph minimality is exact relative to the extracted obligation model; adequacy of that extraction is a separate epistemic/modeling responsibility.**

The paper solves the conditional problem:

```text
given a responsibility-cut model,
which selected responsibilities hit all represented cuts,
and which are inclusion-minimal?
```

It does not solve the broader question:

```text
when is the system entitled to believe
that its extracted responsibility vocabulary and cuts
are adequate to the real revision problem?
```

That broader question is intentionally left open.

---

## 11. Ordered proof-carrying realization

The hypergraph is unordered. Real repair is not.

After the first refresh, the example requires the dependency order:

```text
WarrantRevalidation
-> LicenseRevalidation
-> ContextReactivation
-> FinalRefresh.
```

The formal lifecycle therefore uses:

```text
RevalidationTrace : List RepairAction
```

and separately converts its members to the predicate-set `TraceActionSet` for the set-level repair theory.

### 11.1 Warrant repair

Warrant repair cannot write arbitrary `LIVE/PLACED` state. `WarrantRevalidationAllowed` requires a pre-existing trusted ROOT, INFER, or TRANSPORT qualification `Step` that names the exact evaluation key and compatible binding/profile. The repair state is the ordinary qualification result.

### 11.2 License repair

License repair changes only the review-required predicate. It may clear review only after every other represented `BaseCurrent` premise has recovered, including canonical referents, profile/use consistency, scope discipline, and support usability.

### 11.3 Context repair

Context repair does not invent new provenance. It requires:

- the context currently inactive;
- immutable existing Adopt activation provenance;
- the exact stored Adopt license;
- target consistency;
- recovered `BaseCurrent`;
- a grounded issuer.

It then restores seed activity. A final refresh confirms the fixed point.

### 11.4 Reachability

`RevalidationReachable` embeds the earlier refresh/challenge reachability layer and adds repair events. A concrete trace preserves reachability.

The final strengthened lifecycle theorem has the schematic form:

```text
RevalidationReachable(S0)
∧ ChallengeStep(S0,S1)
∧ RefreshStep(S1,S2)
∧ RevalidationTrace(S2,actions,S3)
∧ RepairSet(problem,TraceActionSet(actions))
∧ RepairRealization(problem,TraceActionSet(actions),S3)
∧ RefreshStep(S3,S4)

=> RevalidationReachable(S4)
   ∧ problem.target.Holds(S4).
```

This theorem is a realizability bridge. It is not the source of hitting-set minimality, and it does not claim that every abstract repair set has an executable ordering.

---

## 12. Historical preservation across restoration

The challenge transition proves exact historical referent immutability. Refresh changes only active-context membership. Each repair action proves `HistoryReferentsImmutable` across that action.

The manuscript may therefore state compositionally:

> the modeled challenge/refresh/repair stages restore current responsibility without requiring canonical historical referents to be rewritten.

The final lifecycle theorem itself does **not** package

```text
HistoryReferentsImmutable(S0.core,S4.core)
```

as an explicit conjunct. We do not add a packaging theorem merely for aesthetics. If a future indispensable headline claim syntactically requires that conjunct, that would be a narrow presentation trigger; it is not needed by the current thesis.

---

## 13. Related work

### Truth maintenance and belief revision

Doyle's Truth Maintenance System records reasons for beliefs and revises current belief status as assumptions or contradictions change. De Kleer's ATMS maintains assumption environments and context-sensitive support. These systems are direct prior art against any claim that persistent reasons and revisable status are newly separated here. AGM-style belief revision likewise provides a mature theory of rational change to belief sets.

Our distinction is narrower: immutable warrant ancestry, exact-key warrant usability, license `BaseCurrent`, and context `Groundedness` are separate state relations, and post-challenge restoration is explicitly decomposed into repair selection, semantic realization, and reachable execution.

### Provenance, incremental recomputation, and change impact

Database provenance records why and where outputs arise; semiring provenance gives algebraic accounts of derivational influence. Incremental view maintenance, self-adjusting computation, and software change-impact analysis record dependencies and propagate changes without full recomputation.

We do not claim novelty for lineage or affectedness. Our `Affected` relation is specialized to the warrant-history graph. The paper focuses on the downstream distinction:

```text
impact set
!= repair obligation model
!= sufficient repair set
!= executable repair trace.
```

Related database causality, view-update, and repair work further narrows any broad distinction between provenance and intervention.

### Stateful and revocable authorization

Stateful authorization logics and proof-carrying systems already show that authorization may depend on current state, time, revocation, and use-once resources. Revocable/use-once PCFS is especially relevant: persistent policy certificates can remain while current database state changes whether they authorize access.

Our contribution is not revocation itself and not linear resource semantics. Instead we keep warrant, license, and context currentness separate and study dependency-sensitive restoration after challenge.

### Model-based diagnosis and repair

Reiter's diagnosis theory and de Kleer/Williams-style diagnosis are the strongest combinatorial neighbors. Minimal hitting sets of conflict sets are classical, and diagnosis/repair systems couple fault hypotheses to corrective actions.

Accordingly, we do not claim to introduce hitting-set repair or non-unique inclusion-minimal solutions. We reuse that classical combinatorial shape with different semantics: the cuts are stale current-responsibility obligations, the actions are typed warrant/license/context responsibilities, a separate `RepairRealization` proves effectiveness, `EveryRepairCutNecessary` marks the extraction-adequacy boundary, and `RevalidationTrace` provides an ordered proof-carrying reachable bridge.

### Safe positioning

The contribution is best summarized as:

> Existing fields supply strong precedents for the individual mechanisms. We assign those mechanisms to separate responsibility judgments, make the proof obligations between them explicit, and connect them in a machine-checked finite-state revision lifecycle without treating model adequacy as a theorem of the repair graph itself.

---

## 14. Scope and limitations

The formal model is intentionally finite and selective.

First, challenge affectedness is exact only for the represented canonical warrant-parent graph. It is not a generic propagation semantics for every runtime relation.

Second, the repair hypergraph is supplied as a well-formed state-indexed model. The artifact does not synthesize the unique correct repair graph from arbitrary observations.

Third, `RepairRealization` is a semantic certificate. The sufficiency theorem therefore does not prove that arbitrary action labels work.

Fourth, universal semantic necessity depends on `EveryRepairCutNecessary`. The model does not infer its own extraction adequacy.

Fifth, minimality is inclusion minimality only.

Sixth, the reachable repair layer gives a narrow execution semantics. It does not prove that every abstract alternative in every repair hypergraph has a corresponding reachable action trace.

Seventh, historical preservation across the entire lifecycle is supported compositionally by stage-local theorems rather than by a single final theorem conjunct.

Eighth, the paper does not prove operational refinement of an external runtime. The correspondence is architectural, not a verified cross-repository refinement.

These limitations are deliberate boundaries between different responsibility judgments, not hidden assumptions to be erased by adding a stronger theorem name.

---

## 15. Artifact and proof audit

The machine-checked development is organized so that the Paper 3 proof audit is separate from the earlier paper surfaces. `Paper3Audit.lean` prints axiom dependencies for the main challenge, refresh, repair, minimality, and lifecycle results.

The paper-facing theorem families are:

| Claim family | Representative artifact results |
| --- | --- |
| historical/currentness discontinuity | `challengeStep_historyReferentsImmutable`, `challengeEpi_live_affected`, `challengeStep_baseCurrent_stricter` |
| exact affected closure | `affected_iff_target_or_descendant`, `affected_closed_under_descendants` |
| grounded loss | `refresh_staleActivation_notActive`, `refresh_issuerLoss_cascades` |
| repair cuts | `RepairProblem`, `RepairSet`, `repairSet_hits_edge` |
| sufficiency | `repairSet_sufficient_after_refresh` |
| inclusion minimality | `minimalRepairSet_remove_member_insufficient`, `minimalRepairSet_has_private_edge` |
| universal lower bound | `EveryRepairCutNecessary`, `restoration_implies_repairSet` |
| reachable realization | `revalidationTrace_preserves_reachability`, `reachable_revalidation_lifecycle_restores` |

The claim map accompanying the artifact records necessary premises and explicit non-claims for each family. In particular, the manuscript treats `EveryRepairCutNecessary`, inclusion-versus-cardinality minimality, and stage-local history preservation as high-risk claim boundaries.

---

## 16. Discussion: where the real responsibility lies

The development suggests a useful decomposition for revision systems.

A dependency graph can tell us what depends on what. That is not yet a judgment that every dependency is currently relevant. An impact rule can tell us what becomes suspect after a challenge. That is not yet a repair plan. A hitting set can select actions against every represented cut. That is not yet proof that the actions work. A sound realization can prove restoration in a state. That is not yet proof that the extracted cuts were complete relative to the external problem. Finally, a semantic restoration need not by itself specify an admissible execution order.

The formal model therefore keeps five questions separate:

```text
1. What canonical history persists?
2. What current responsibility became stale?
3. Which represented cuts must a selected repair hit?
4. Do the selected actions actually restore the modeled obligations?
5. Why should the extracted cuts be trusted as adequate to the intended restoration problem?
```

Paper 3 answers questions 1–4 inside a finite model and exposes question 5 as an explicit premise for universal necessity.

This boundary is also the natural interface to a broader theory of revision. A future system may reason about when its own responsibility vocabulary is insufficient or when a deeper reopen is warranted. That problem should not be solved by silently asserting that the present repair hypergraph is complete.

---

## 17. Conclusion

Canonical history and current responsibility should not be collapsed. In the formal kernel studied here, a valid challenge can preserve historical warrant referents while making exact-key warrant usability, Adopt-license currentness, and context groundedness stale. Currentness loss follows an explicit specialized dependency structure; fixed-point refresh exposes downstream groundedness failure without deleting the historical objects that explain how the state arose.

Restoration is then separated into distinct obligations. A finite directed hypergraph exposes unresolved responsibility cuts. Repair sets are hitting sets of those cuts. With a sound repair realization, they restore the target. Inclusion-minimal repair sets make every selected action locally non-removable and provide a private-cut witness explaining that local necessity. Universal restoration lower bounds are deliberately conditional on an explicit adequacy premise, because combinatorial exactness relative to a supplied graph does not establish that the graph adequately represents the world.

An ordered proof-carrying revalidation trace connects this set-level theory back to reachable state while keeping warrant, license, and context repair responsibilities distinct.

The resulting lesson is not that there is one minimal revalidation frontier. It is that preservation, invalidation, impact, repair selection, semantic effectiveness, model adequacy, and execution order are different responsibilities and should be proved at different boundaries.

---

## References

Alchourrón, C. E., Gärdenfors, P., and Makinson, D. 1985. On the Logic of Theory Change: Partial Meet Contraction and Revision Functions. *Journal of Symbolic Logic* 50(2):510–530.

Acar, U. A., Blelloch, G. E., Blume, M., Harper, R., and Tangwongsan, K. 2006. A Library for Self-Adjusting Computation. *Electronic Notes in Theoretical Computer Science* 148(2):127–154.

Bohner, S. A. and Arnold, R. S. 1996. *Software Change Impact Analysis*. IEEE Computer Society Press.

Buneman, P., Khanna, S., and Tan, W.-C. 2001. Why and Where: A Characterization of Data Provenance. ICDT 2001:316–330.

de Kleer, J. 1986. An Assumption-Based TMS. *Artificial Intelligence* 28(2):127–162.

de Kleer, J. and Williams, B. C. 1987. Diagnosing Multiple Faults. *Artificial Intelligence* 32(1):97–130.

Doyle, J. 1979. A Truth Maintenance System. *Artificial Intelligence* 12(3):231–272.

Friedrich, G. 1993. Model-Based Diagnosis and Repair. *AI Communications* 6(3–4):187–206.

Garg, D. and Pfenning, F. 2012. Stateful Authorization Logic — Proof Theory and a Case Study. *Journal of Computer Security* 20(4):353–391.

Green, T. J., Karvounarakis, G., and Tannen, V. 2007. Provenance Semirings. PODS 2007:31–40.

Morgenstern, J., Garg, D., and Pfenning, F. 2011. A Proof-Carrying File System with Revocable and Use-Once Certificates. STM 2011, LNCS 7170:40–55.

Reiter, R. 1987. A Theory of Diagnosis from First Principles. *Artificial Intelligence* 32(1):57–95.

Ryder, B. G. and Tip, F. 2001. Change Impact Analysis for Object-Oriented Programs. PASTE 2001.
