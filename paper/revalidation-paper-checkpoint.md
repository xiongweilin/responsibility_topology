# Dependency-Sensitive Revision Paper Checkpoint

Status: Paper 3 kernel expansion paused after PR #48.

Semantic baseline for this checkpoint: `190e24e404c864ef8f535f8dbd101c319689e4bc` (PR #48 merge).

This note evaluates whether the challenge / invalidation / repair / revalidation line forms a coherent independent manuscript kernel. It is paper-only: it adds no semantics, theorem, transition, Python claim, or refinement claim.

## Checkpoint verdict

**Pass for an independent manuscript kernel; stop kernel feature expansion by default.**

The current result surface supports a thesis materially stronger than constructor completion:

> **When canonical history is preserved but current responsibility is invalidated, restoration can be represented as a dependency-sensitive repair problem whose sufficient repairs hit every unresolved responsibility cut, and whose inclusion-minimal repairs admit concrete local necessity witnesses.**

The repair surface intentionally ranges over three currentness layers:

```text
warrant usability
license BaseCurrent
context Groundedness
```

It therefore should not be presented as a warrant-only “minimal revalidation frontier” result.

No uniqueness of a repair frontier is claimed. No theorem says that an arbitrary extracted hypergraph is automatically adequate for real restoration.

## Audit 1 — Canonical continuity versus currentness discontinuity

Paper-facing claim:

> Challenge may invalidate current responsibility while preserving canonical historical referents.

Formal support includes:

- `challengeStep_historyReferentsImmutable`
- `challengeStep_topology_unchanged`
- `challengeEpi_live_affected`
- `challengePlacement_placed_affected`
- `challengeStep_baseCurrent_stricter`
- `challengeStep_grounded_post_implies_pre`

The important separation is not a universal implication of the form

```text
CanonicalWellFormedness -> not Currentness
```

but the coexistence, on the same challenge transition, of exact historical preservation with loss or weakening of mutable evaluation/currentness facts.

This preserves the Paper 1 distinction under actual revision pressure rather than only at formation time.

## Audit 2 — Exact historical impact boundary

The impact relation is exact by definition:

```text
Affected(S, target, w)
  := (w = target) OR DescendantOf(S, target, w)
```

Formal support:

- `affected_iff_target_or_descendant`
- `challengeTarget_affected`
- `descendant_affected`
- `affected_nonTarget_iff_descendant`
- `unrelated_notAffected`
- `affected_closed_under_descendants`

Thus the represented warrant-history impact set is exactly the challenged target plus its finite transitive historical descendants:

```text
Affected(target) = {target} union Descendants(target)
```

This is a specialized canonical-warrant dependency semantics. It is not a claim that every external dependency graph, runtime relation graph, or real-world causal dependency should use recursive descendant invalidation.

## Audit 3 — Grounded currentness loss propagates through issuer responsibility

After challenge invalidation, activation refresh is stated extensionally:

```text
RefreshActive(c) <-> Grounded(invalidatedRead, c)
```

Formal support:

- `refreshActiveContexts_active_iff`
- `refreshActiveContexts_contracts`
- `challengeStep_grounded_post_implies_pre`
- `refresh_staleActivation_notActive`
- `refresh_activeAdopt_implies_issuerActive`
- `refresh_issuerLoss_cascades`
- `challengeRefresh_retained_implies_preGrounded`

This establishes the required dependency-sensitive currentness behavior:

```text
stale activation responsibility
  -> direct adopted-context loss

issuer loss
  -> dependent adopted-context loss
```

Refresh cannot synthesize activity. A context removed from the active seed therefore requires explicit context reactivation after its dependency conditions recover; a second contractive refresh alone cannot restore it.

That lifecycle fact is why PR #48 separates:

```text
WarrantRevalidation
-> LicenseRevalidation
-> ContextReactivation
-> FinalRefresh
```

rather than treating “refresh again” as revalidation.

## Audit 4 — Repair is a directed-hypergraph hitting-set problem

The repair semantics does not define a unique frontier.

Current obligations:

```text
RepairObligation.warrantUsable
RepairObligation.licenseBaseCurrent
RepairObligation.contextGrounded
```

Candidate actions:

```text
RepairAction.revalidateWarrant
RepairAction.revalidateLicense
RepairAction.revalidateContext
```

A `RepairProblem` is a finite state-indexed directed hypergraph. Multiple edges encode conjunctive unresolved cuts; alternatives inside one edge encode disjunctive local repairs.

The central combinatorial definition is:

```text
RepairSet(problem, X)
  <-> X hits every unresolved dependency cut
```

and:

```text
MinimalRepairSet(problem, X)
```

means inclusion-minimal only.

Formal support:

- `repairSet_hits_edge`
- `repairSet_monotone`
- `minimalRepairSet_is_repairSet`
- `minimalRepairSet_remove_member_insufficient`
- `minimalRepairSet_has_private_edge`
- `minimalRepairSet_every_member_necessary`

The strongest unconditional local necessity result is the private-cut theorem:

> Every selected member of an inclusion-minimal repair set hits some concrete unresolved edge for which no other different selected action is an alternative hit.

This is stronger and more informative than merely restating set-theoretic minimality.

## Audit 5 — Necessity is conditional on extraction adequacy

The paper must make the following limitation central rather than bury it as a technical caveat.

From the bare hypergraph representation alone, the project does **not** prove:

```text
Restore(X) -> X hits every represented cut.
```

The semantic lower bound requires the explicit premise:

```text
EveryRepairCutNecessary problem Restore
```

Only under that adequacy premise do we obtain:

```text
forall X,
  Restore(X)
  -> X hits every unresolved dependency cut
```

and hence:

```text
Restore(X) -> RepairSet(problem, X).
```

Formal support:

- `restoration_hits_every_unresolved_cut`
- `restoration_implies_repairSet`
- `minimalRestoringRepairSet_has_private_cut`

This is a positive claim-discipline result: dependency extraction adequacy remains an explicit responsibility rather than being hidden inside the definition of repair.

Accordingly, Paper 3 should avoid phrases such as “the unique minimal revalidation frontier” or “the extracted repair graph is necessarily complete.”

## Audit 6 — Unordered repair theory connects to ordered reachable restoration

PR #48 deliberately separates mathematical selection from execution order.

Set-level theory:

```text
RepairSet / MinimalRepairSet
```

Execution-level theory:

```text
RevalidationTrace : List RepairAction
TraceActionSet(actions)
```

The ordered action families remain responsibility-specific:

- warrant revalidation must reuse an existing trusted ROOT / INFER / TRANSPORT qualification `Step` for the exact evaluation key;
- license revalidation may clear review only after every other represented BaseCurrent premise is restored;
- context revalidation requires immutable Adopt provenance, recovered BaseCurrent, and a Grounded issuer before seed activity is restored;
- final refresh confirms grounded currentness.

Formal support:

- `repairActionStep_warrant_makes_usable`
- `repairActionStep_license_makes_baseCurrent`
- `repairActionStep_context_makes_grounded`
- `repairActionStep_historyReferentsImmutable`
- `revalidationTrace_preserves_reachability`
- `contextRevalidation_survives_refresh`
- `revalidation_lifecycle_restores`
- `reachable_revalidation_lifecycle_restores`

The theorem surface now distinguishes two claims explicitly.

`revalidation_lifecycle_restores` is the adjacent conditional restoration theorem. It does not claim formal reachability merely from the lifecycle-shaped premises.

`reachable_revalidation_lifecycle_restores` additionally consumes:

```text
RevalidationReachable(S0)
```

and concludes:

```text
RevalidationReachable(S4)
and
TargetHolds(S4).
```

This closes the “decorated lifecycle theorem” ambiguity without changing repair semantics.

### Historical-immutability presentation boundary

The current artifact proves historical-referent immutability at the challenge boundary and at every individual repair action, while refresh changes only active-context membership. The reachable restoration theorem itself concludes reachability plus target restoration; it does not package a separate end-to-end `HistoryReferentsImmutable S0.core S4.core` conjunct.

Therefore the manuscript may state historical preservation by citing the stage-local preservation theorems compositionally. If a final headline theorem is later required to contain the end-to-end history conjunct syntactically, that is a narrowly scoped theorem-presentation trigger, not a reason to reopen semantic feature development.

## Paper 3 contribution kernel

The current results organize naturally into five paper-facing families:

1. **Exact dependency impact.** Challenge affects the target and exactly its historical descendants in the represented warrant graph.
2. **Currentness invalidation and grounded cascade.** Historical structure is preserved while evaluation, license currentness, and context groundedness may become stale.
3. **Dependency-sensitive repair semantics.** Stale currentness obligations induce a finite directed-hypergraph repair problem; repairs are hitting sets, not a unique frontier.
4. **Sufficiency and local necessity.** Sound repair realizations establish target restoration; minimal repair members have concrete private-cut witnesses; semantic lower bounds require explicit cut-adequacy premises.
5. **Reachable restoration lifecycle.** Ordered proof-carrying repair actions connect the unordered repair theory back to reachable state while keeping warrant, license, and context restoration distinct.

A defensible working paper title is:

> **Dependency-Sensitive Revision and Minimal Responsibility Repair in a Finite Epistemic Kernel**

A defensible central formulation is:

> **When immutable canonical dependencies outlive their current qualifications, invalidation and restoration should be tracked separately: currentness loss follows explicit dependency structure, while restoration is a non-unique hitting-set problem over unresolved responsibility cuts and requires ordered proof-carrying execution to re-establish current state.**

The term “minimal responsibility repair” is preferable to “minimal revalidation frontier” because the modeled obligations include warrant usability, license BaseCurrent, and context Groundedness and because no unique frontier is proved.

## What is not claimed

This checkpoint does not establish:

- uniqueness of a minimal repair set;
- minimum-cardinality or minimum-cost repair;
- completeness or adequacy of arbitrary dependency-cut extraction;
- that `RepairSet` alone restores anything without a sound `RepairRealization`;
- that every restoration must hit every cut without `EveryRepairCutNecessary`;
- generic recursive invalidation for all runtime dependency relations;
- Python operational refinement of challenge, refresh, or revalidation;
- end-to-end `portable-runtime -> Lean` refinement;
- epistemic or normative adequacy of the challenged profile, dependency graph, repair alternatives, or reauthorization decision;
- a universal theory of belief revision or truth maintenance.

## Freeze after checkpoint

After this checkpoint the default status is:

```text
NewRepairObligationKinds:          FROZEN
NewRepairActionKinds:              FROZEN
UniqueRevalidationFrontier:        REJECTED BY DEFAULT
MinimumCardinalityOptimization:    FROZEN
CostOptimization:                  FROZEN
GenericRuntimeDependencyClosure:   FROZEN
PythonRefinement:                  FROZEN
CrossRepositoryRefinement:         FROZEN
AdditionalKernelConstructors:      FROZEN
```

The following are manuscript-triggered only:

```text
EndToEndHistoryConjunctTheorem:    TRIGGER ONLY IF HEADLINE CLAIM REQUIRES IT
AdditionalAdequacyLemma:           TRIGGER ONLY IF AN INDISPENSABLE PAPER CLAIM REQUIRES IT
```

No formal phase should reopen merely because a stronger generalization or optimization is available.

## Trigger policy

A new formal change is permitted only when all of the following hold:

1. a concrete manuscript sentence is central to the Paper 3 thesis;
2. the sentence cannot be supported honestly by the current theorem surface;
3. narrowing or removing the sentence would materially damage the paper;
4. the missing result can be added without broadening the semantic object model unnecessarily.

Otherwise the next work is paper-only.

## Checkpoint decision

**Kernel decision:** stop after PR #48.

**Paper decision:** proceed to theorem/claim map, running counterexample, related-work narrowing, manuscript architecture, and hostile review.

**Research decision:** treat dependency-extraction adequacy, cost-sensitive repair, generic runtime correspondence, and broader revision theory as explicit future work rather than prerequisites for this manuscript.

**Default next PR:** none. Do not open a kernel PR #50 automatically. Any later PR numbering is manuscript work unless the formal trigger above fires.
