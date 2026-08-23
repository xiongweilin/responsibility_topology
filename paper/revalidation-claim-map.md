# Paper 3 Theorem / Claim Firewall

Status: paper-only claim map after PR #49. No formal semantics are introduced here.

Semantic baseline: `95e4c93bc558dba93a817753d0e13439030d6229` (PR #49 merge).

## Purpose

This document is not a theorem inventory. It is the manuscript claim firewall for Paper 3. Every central sentence must remain inside the theorem surface recorded here. Abstract, Introduction, theorem exposition, discussion, and Conclusion should reuse these claim boundaries rather than paraphrasing them into stronger statements.

Working thesis:

> **When canonical history is preserved but current responsibility is invalidated, restoration is a dependency-sensitive repair problem whose sufficient repairs are hitting sets of unresolved responsibility cuts, and whose inclusion-minimal repairs admit local necessity witnesses.**

The intended exposition order is:

```text
Discontinuity
-> Affected closure
-> Currentness loss
-> Repair cuts
-> Sufficiency
-> Minimality / private cuts
-> Reachable realization
```

The reachable lifecycle is a realizability bridge, not the paper's strongest theoretical contribution.

---

## C1 — Historical continuity and currentness discontinuity

**Paper claim**

A valid challenge can weaken current responsibility while preserving canonical historical referents.

**Supporting theorem(s)**

- `challengeStep_historyReferentsImmutable`
- `challengeStep_topology_unchanged`
- `challengeEpi_live_affected`
- `challengePlacement_placed_affected`
- `challengeStep_reviewRequired_exact`
- `challengeStep_baseCurrent_stricter`
- `challengeStep_grounded_post_implies_pre`

**Necessary premises**

- a well-formed `ChallengeStep` with canonical binding/context/challenger/bridge/target;
- usable challenger and BRIDGE warrant at the exact challenge evaluation key;
- an exact BRIDGE challenge claim naming challenger and target;
- affectedness at the relevant profile/use coordinate for status changes.

**Claim boundary**

The theorem surface establishes preservation of historical referents and selective weakening of mutable currentness facts on the modeled challenge transition. It does not identify canonical well-formedness with current validity and does not say that every challenge must invalidate every currentness layer.

**Explicitly not claimed**

- `CanonicalWellFormedness -> not Currentness` as a universal theorem;
- semantic or normative adequacy of the challenge itself;
- generic invalidation of all external dependency graphs;
- end-to-end runtime refinement.

---

## C2 — Exact affected closure in the represented warrant graph

**Paper claim**

For the modeled historical warrant dependency graph, the affected set of a challenge is exactly the challenged target plus its transitive historical descendants.

**Supporting theorem(s)**

- `affected_iff_target_or_descendant`
- `challengeTarget_affected`
- `descendant_affected`
- `affected_nonTarget_iff_descendant`
- `unrelated_notAffected`
- `affected_closed_under_descendants`
- `affected_closed_under_directChildren`

**Necessary premises**

- `DirectDescendant` is the immutable parent-to-child relation induced by canonical historical warrant parent identifiers;
- `DescendantOf` is its nonempty finite transitive closure;
- `Affected` is defined in this specialized warrant-history semantics.

**Claim boundary**

`Affected(S,t,w)` is exact relative to this formal dependency vocabulary. The result is about historical warrant ancestry, not arbitrary operational, causal, organizational, or runtime relations.

**Explicitly not claimed**

- that recursive descendant invalidation is correct for every runtime dependency relation;
- that the formal warrant graph is complete for every real-world dependency;
- that affectedness itself determines the repair action or policy response.

---

## C3 — Grounded currentness loss propagates through activation responsibility

**Paper claim**

Challenge-induced currentness weakening can propagate from warrant usability to license `BaseCurrent` and then to context `Groundedness`; fixed-point refresh removes contexts whose activation responsibility is no longer grounded, and issuer loss can cascade to dependent adopted contexts.

**Supporting theorem(s)**

- `challengeInvalidate_usable_implies_pre`
- `challengeStep_baseCurrent_stricter`
- `challengeStep_baseCurrentRead_stricter`
- `refreshActiveContexts_active_iff`
- `refreshActiveContexts_contracts`
- `refresh_staleActivation_notActive`
- `refresh_activeAdopt_implies_issuerActive`
- `refresh_issuerLoss_cascades`
- `challengeRefresh_retained_implies_preGrounded`

**Necessary premises**

- the represented Adopt license and activation provenance relations;
- the exact `BaseCurrent` judgment over the stored license;
- `Grounded` currentness for activation chains;
- challenge followed by the explicit fixed-point refresh where a lifecycle statement is made.

**Claim boundary**

The formal result is a dependency-sensitive currentness cascade over the three represented layers. Refresh is contractive; it confirms grounded currentness but does not itself repair lost seed activity.

**Explicitly not claimed**

- that a second refresh alone can reactivate a removed context;
- that all currentness loss is caused only by warrant challenge;
- that `Usable`, `BaseCurrent`, and `Grounded` are one validity flag.

---

## C4 — Repair obligations form a directed-hypergraph cut problem

**Paper claim**

Once currentness obligations are stale, repair can be represented as a finite directed-hypergraph problem in which each unresolved cut must be hit by at least one selected repair action; multiple edges encode conjunctive responsibilities and multiple alternatives inside an edge encode disjunctive local repairs.

**Supporting definition/theorem(s)**

- `RepairObligation`
- `StaleDependency`
- `RepairHyperedge`
- `RepairProblem`
- `HitsRepairEdge`
- `RepairSet`
- `repairSet_hits_edge`
- `repairSet_monotone`
- `repairProblem_edge_is_stale`
- `repairProblem_stale_has_edge`

**Necessary premises**

- a well-formed state-indexed `RepairProblem`;
- every recorded stale dependency is truly stale in the indexed state;
- every edge points to a recorded stale dependency and has at least one alternative;
- every recorded stale dependency is exposed by at least one edge.

**Claim boundary**

The hypergraph is an explicit model of unresolved responsibility cuts. `RepairSet` is a hitting-set condition only. It does not by itself establish that selected actions are executable or semantically effective.

**Explicitly not claimed**

- a unique repair frontier;
- automatic completeness of the extracted hypergraph;
- that any hitting set restores the target without further premises;
- minimum-cardinality, minimum-cost, or optimal repair.

---

## C5 — Sufficiency requires a sound repair realization

**Paper claim**

A repair set is sufficient for target restoration only together with a sound `RepairRealization` that connects selected actions to restored obligations and restored stale dependencies to the target; final refresh preserves the three represented repair-obligation truth conditions.

**Supporting theorem(s)**

- `repairObligation_refresh_iff`
- `repairSet_realization_restores_edges`
- `repairSet_realization_restores_staleDependencies`
- `repairSet_sufficient_before_refresh`
- `repairSet_sufficient_after_refresh`
- `minimalRepairSet_sufficient_after_refresh`

**Necessary premises**

- `RepairSet problem X`;
- `RepairRealization problem X revalidated`;
- for post-refresh claims, the explicit semantic refresh projection.

**Claim boundary**

Sufficiency is conditional on realization. The hypergraph specifies which cuts must be hit; `RepairRealization` carries the semantic responsibility that the selected actions actually restore the modeled obligations and that restoring all declared stale dependencies closes the target.

**Explicitly not claimed**

- `RepairSet(X) -> TargetHolds` without `RepairRealization`;
- that a repair action label by itself has an operational effect;
- that semantic sufficiency proves the extraction was epistemically adequate.

---

## C6 — Inclusion-minimal repair admits local necessity witnesses

**Paper claim**

For an inclusion-minimal repair set, every selected repair action is individually non-removable relative to the represented cut problem and has a concrete private unresolved cut that no other different selected action in the same repair set hits.

**Supporting theorem(s)**

- `minimalRepairSet_is_repairSet`
- `minimalRepairSet_remove_member_insufficient`
- `minimalRepairSet_has_private_edge`
- `minimalRepairSet_every_member_necessary`
- `minimalRestoringRepairSet_has_private_cut`

**Necessary premises**

- `MinimalRepairSet problem X`;
- for `minimalRestoringRepairSet_has_private_cut`, the restoration and adequacy parameters are present, although the private-cut conclusion follows from repair-set minimality itself.

**Claim boundary**

Minimality is set inclusion minimality relative to the represented hypergraph. The local necessity witness is a private dependency cut, not a global optimality certificate.

**Explicitly not claimed — HIGH-RISK FIREWALL**

- minimum cardinality;
- minimum cost;
- Pareto optimality;
- uniqueness;
- a canonical repair frontier;
- that two different inclusion-minimal repair sets must have the same size or actions.

Preferred manuscript phrase: **inclusion-minimal repair set**. Avoid bare **minimum repair** unless immediately qualified.

---

## C7 — Universal necessity requires explicit extraction adequacy

**Paper claim**

A universal lower bound from semantic restoration to cut hitting is available only under the explicit premise `EveryRepairCutNecessary problem Restore`; adequacy of the extracted cuts is therefore a separate modeling/epistemic responsibility rather than a hidden consequence of the repair representation.

**Supporting definition/theorem(s)**

- `EveryRepairCutNecessary`
- `restoration_hits_every_unresolved_cut`
- `restoration_implies_repairSet`
- `minimalRestoringRepairSet_has_private_cut`

**Necessary premises**

- a chosen restoration predicate `Restore`;
- `EveryRepairCutNecessary problem Restore` for universal lower-bound statements;
- `Restore X` for conclusions about a concrete restoring set.

**Claim boundary — HIGH-RISK FIREWALL**

Hypergraph minimality is exact relative to the extracted obligation model. Adequacy of that extraction is not derived from the hitting-set structure; it must be justified separately.

Preferred manuscript formulation:

> **Hypergraph minimality is exact relative to the extracted obligation model; adequacy of that extraction is a separate epistemic/modeling responsibility.**

**Explicitly not claimed**

- `Restore(X) -> RepairSet(problem,X)` without `EveryRepairCutNecessary`;
- completeness of arbitrary dependency-cut extraction;
- that the formal model decides when a real-world responsibility vocabulary is adequate;
- a solution to the broader `Q_open` problem.

This limitation belongs in the main theoretical discussion, not only in Limitations.

---

## C8 — Unordered repair theory has an ordered reachable realization bridge

**Paper claim**

Unordered repair selection is kept separate from execution order. A concrete `RevalidationTrace` orders proof-carrying warrant, license, and context repair actions; the reachability-strengthened lifecycle theorem threads challenge, refresh, ordered repair, and final refresh through `RevalidationReachable` and restores the target obligation.

**Supporting theorem(s)**

- `repairActionStep_warrant_makes_usable`
- `repairActionStep_license_makes_baseCurrent`
- `repairActionStep_context_makes_grounded`
- `repairActionStep_historyReferentsImmutable`
- `revalidationTrace_preserves_reachability`
- `contextRevalidation_survives_refresh`
- `revalidation_lifecycle_restores`
- `reachable_revalidation_lifecycle_restores`

**Necessary premises**

- warrant repair reuses a trusted ROOT/INFER/TRANSPORT qualification `Step` at the exact `EvalKey`;
- license repair clears review only after the other represented `BaseCurrent` premises hold;
- context repair requires immutable Adopt provenance, recovered `BaseCurrent`, and a grounded issuer;
- the trace action set is a `RepairSet`;
- a sound `RepairRealization` exists for the concrete revalidated state;
- the strengthened theorem additionally requires `RevalidationReachable S0`.

**Claim boundary**

`revalidation_lifecycle_restores` is an adjacent conditional restoration theorem. `reachable_revalidation_lifecycle_restores` additionally concludes formal reachability of the final state. Neither theorem is a Python refinement result.

**Explicitly not claimed**

- that every unordered repair set has an executable ordering;
- that any ordering is valid;
- that the reference runtime implements this exact generic `revalidate` transition family;
- cross-repository refinement.

---

## C9 — Historical immutability across the lifecycle is compositional, not packaged as a headline conjunct

**Paper claim**

The manuscript may state that the modeled challenge/refresh/repair stages do not rewrite canonical historical referents, citing the corresponding stage-local preservation results compositionally.

**Supporting theorem(s)**

- `challengeStep_historyReferentsImmutable`
- `challengeStep_topology_unchanged`
- `refreshActiveContexts_topology_unchanged`
- `repairActionStep_historyReferentsImmutable`

**Necessary premises**

- the corresponding valid challenge, refresh, and repair transitions.

**Claim boundary — HIGH-RISK FIREWALL**

The current final lifecycle theorem does **not** syntactically conclude:

```text
HistoryReferentsImmutable S0.core S4.core
```

The preservation evidence is stage-local and compositional. That is sufficient for manuscript sentences phrased at the transition-family level.

**Explicitly not claimed**

- an already-existing end-to-end headline theorem with history immutability as an explicit conjunct;
- arbitrary temporal history preservation outside the modeled transition family.

Formal phase trigger: reopen only if an indispensable headline sentence cannot be honestly phrased using the stage-local preservation theorems and explicitly requires the end-to-end conjunct.

---

## Claim-language policy

Preferred phrases:

- **current responsibility / currentness obligation** rather than generic validity;
- **inclusion-minimal repair set** rather than minimum repair;
- **unresolved responsibility cut** rather than unique frontier;
- **sound repair realization** when claiming target restoration;
- **relative to the extracted obligation model** when discussing minimality;
- **under an explicit cut-adequacy premise** when discussing universal necessity;
- **stage-local historical preservation** unless an end-to-end theorem is later added.

Avoid without immediate qualification:

```text
minimal revalidation frontier
optimal repair
unique minimal repair
complete dependency graph
all affected dependencies
repair set restores the target
universal necessity of every represented cut
verified portable-runtime revalidation
```

---

## Abstract firewall

A defensible abstract-level result sentence is:

> We model invalidated current responsibility as a finite directed-hypergraph repair problem over warrant usability, license currentness, and context groundedness. Repair sets hit every represented unresolved cut; with a sound repair realization they restore the target currentness obligation, while inclusion-minimal repair sets give each selected action a private-cut necessity witness. Universal restoration lower bounds require an explicit adequacy premise connecting the extracted cuts to the chosen restoration predicate.

Do not shorten the last sentence away if the abstract uses words such as `necessary`, `minimal`, or `lower bound`.

---

## Introduction firewall

The Introduction may motivate the distinction:

```text
impact detection != responsibility restoration
```

but must not claim that the formalism discovers all real dependencies. The formal contribution begins after a finite responsibility-cut model has been supplied and validated to the degree required by the claim.

The paper's strongest conceptual separation is:

```text
persistent historical dependency
!= time-indexed current responsibility
```

followed by:

```text
currentness loss
!= repair selection
!= repair realization
!= extraction adequacy
```

These separations should structure the contribution list.

---

## Conclusion firewall

A defensible conclusion is:

> The results show that preservation of canonical history need not imply preservation of current responsibility, and that restoration can be organized as a dependency-sensitive cut problem without collapsing selection, execution, and model adequacy into one judgment.

Do not conclude that the project has found *the* minimal real-world revalidation frontier, proved runtime refinement, or solved dependency-extraction adequacy.

---

## Formal re-open rule

During #51–#54, a formal milestone may reopen only if all four conditions hold:

1. a concrete manuscript sentence is central and indispensable;
2. the current theorem surface cannot support it honestly;
3. deleting or weakening the sentence materially breaks the paper thesis;
4. the missing theorem can be added without broadening the semantic object model.

Otherwise fix the manuscript, not the kernel.
