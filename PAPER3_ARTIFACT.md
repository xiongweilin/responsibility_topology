# Paper 3 Artifact and Version Freeze

This file belongs only to Paper 3: dependency-sensitive revision and responsibility repair.

It does **not** replace repository-root `ARTIFACT.md`, which remains the Paper 1 artifact lock.

## Frozen identities

### Formal semantic baseline

```text
190e24e404c864ef8f535f8dbd101c319689e4bc
```

This is PR #48's merge commit. It contains the final Paper 3 formal semantics used by the manuscript:

```text
Challenge impact / invalidation
-> grounded refresh
-> RepairProblem / RepairSet
-> RepairRealization sufficiency
-> inclusion-minimal/private-cut results
-> ordered RevalidationTrace
-> reachable restoration bridge
```

No later paper, documentation, venue, or artifact commit changes this semantic identity.

### Manuscript baseline

```text
44605d00d66921aebc6279fc11270d1e58d7867f
```

This is PR #60's merge commit. It integrates:

- the four-result-family hierarchy T1–T4;
- the conceptual mother claim that revision can withdraw current responsibility without rewriting historical dependency;
- demotion of `Affected` to a modeled impact boundary;
- treatment of `EveryRepairCutNecessary` as represented-cut necessity rather than extraction completeness;
- the two-figure architecture separating persistent history / typed currentness and selection / realization / execution.

Later citation/formatting changes may create a newer submission baseline, but they do not change the frozen formal semantic baseline.

## Paper 3 result families

The artifact should be evaluated through four paper-facing families.

### T1 — History-preserving currentness invalidation

Representative machine surfaces include:

```text
challengeStep_historyReferentsImmutable
challengeStep_baseCurrent_stricter
challengeStep_grounded_post_implies_pre
refreshActiveContexts_contracts
refresh_staleActivation_notActive
refresh_issuerLoss_cascades
```

The exact `Affected = target or descendant` equivalence is a modeled impact boundary. It should not be treated as the principal mathematical result.

### T2 — Repair selection + realization implies restoration

Representative surfaces:

```text
repairSet_realization_restores_edges
repairSet_realization_restores_staleDependencies
repairSet_sufficient_before_refresh
repairSet_sufficient_after_refresh
minimalRepairSet_sufficient_after_refresh
```

Required claim boundary:

```text
RepairSet
!= restoration by itself
```

A `RepairRealization` premise carries semantic effectiveness.

### T3 — Inclusion-minimal repair admits private-cut witnesses

Representative surfaces:

```text
minimalRepairSet_remove_member_insufficient
minimalRepairSet_has_private_edge
minimalRepairSet_every_member_necessary
minimalRestoringRepairSet_has_private_cut
```

`MinimalRepairSet` means inclusion-minimal only.

Not claimed:

```text
minimum cardinality
minimum cost
optimality
uniqueness
canonical frontier
```

### T4 — Proof-carrying repair has a reachable realization bridge

Representative surfaces:

```text
repairActionStep_warrant_makes_usable
repairActionStep_license_makes_baseCurrent
repairActionStep_context_makes_grounded
repairActionStep_historyReferentsImmutable
revalidationTrace_preserves_reachability
revalidation_lifecycle_restores
reachable_revalidation_lifecycle_restores
```

The reachable theorem is conditional on a valid ordered trace, `RepairSet`, `RepairRealization`, and final refresh. It is not a completeness theorem for all abstract repair sets.

## Represented-cut necessity boundary

The formal surface includes:

```text
EveryRepairCutNecessary
restoration_hits_every_unresolved_cut
restoration_implies_repairSet
```

Interpretation:

> Under an explicit premise that each represented cut is necessary for the chosen restoration predicate, every restoring set hits each represented cut.

Do not interpret this as:

```text
complete dependency extraction
no missing necessary cut
solution of responsibility-model adequacy / Q_open
```

Those remain outside Paper 3.

## Reproduction

Checkout the formal semantic baseline:

```bash
git checkout 190e24e404c864ef8f535f8dbd101c319689e4bc
cd formal
lake build
lake env lean ResponsibilityTopology/Paper3Audit.lean
```

`Paper3Audit.lean` is the Paper 3 declaration-level axiom audit surface. At the frozen baseline it prints axiom dependencies for challenge/refresh, repair semantics, sufficiency, minimality/necessity, and revalidation lifecycle results.

The repository CI policy also rejects `sorry` / `admit` placeholders in the formal core. A successful build/audit establishes only the mechanized statements and their explicit premises.

## Formal theorem audit list

The frozen `Paper3Audit.lean` includes audit entries for, among others:

```text
refreshActiveContexts_active_iff
refreshActiveContexts_contracts
grounded_adopt_requires_baseCurrent
challengeStep_baseCurrent_stricter
challengeStep_grounded_post_implies_pre
refresh_staleActivation_notActive
refresh_issuerLoss_cascades
staleDependency_warrant_iff
staleDependency_license_iff
staleDependency_context_iff
repairSet_hits_edge
repairProblem_edge_is_stale
repairProblem_stale_has_edge
repairObligation_refresh_iff
repairSet_realization_restores_edges
repairSet_realization_restores_staleDependencies
repairSet_sufficient_after_refresh
minimalRepairSet_remove_member_insufficient
minimalRepairSet_has_private_edge
restoration_hits_every_unresolved_cut
restoration_implies_repairSet
repairActionStep_warrant_makes_usable
repairActionStep_license_makes_baseCurrent
repairActionStep_context_makes_grounded
repairActionStep_historyReferentsImmutable
revalidationTrace_preserves_reachability
revalidation_lifecycle_restores
reachable_revalidation_lifecycle_restores
```

The audit file, not this abbreviated list, is authoritative.

## Historical preservation claim boundary

Paper 3 may state compositionally that the modeled challenge, refresh, and repair stages preserve relevant canonical referents/topology.

The frozen final reachable restoration theorem does **not** package an explicit conclusion of the form:

```text
HistoryReferentsImmutable S0.core S4.core
```

Therefore do not claim that the final lifecycle theorem itself has that conjunct. No new proof is required merely to package existing stage-local preservation results aesthetically.

## Runtime relation

Paper 3 does not verify `xiongweilin/portable-runtime`.

The repositories share framework/specialization relationships documented in `CROSS_REPO_RELATION.md`, but their dependency-propagation semantics are not identical. In particular:

```text
formal Paper 3:
  transitive historical warrant-descendant challenge impact

portable-runtime:
  typed dependency impact with generic no-recursive-invalidation policy
```

A future bridge should use explicit observational abstraction/refinement if developed.

## Frozen non-theorems

Paper 3 does not prove:

- automatic or complete `Challenge -> RepairProblem` extraction;
- that every abstract repair alternative is semantically realizable;
- that every inclusion-minimal repair set has a reachable execution trace;
- minimum-cardinality, minimum-cost, or optimal repair;
- unique/canonical repair frontier;
- arbitrary all-domain change impact;
- cross-domain invariance;
- runtime/Python refinement;
- extraction completeness;
- responsibility-model adequacy or `Q_open`;
- distributed responsibility or `Q_close`.

## Artifact evidence classes

Use the following language precisely:

| Evidence | Safe claim |
| --- | --- |
| Lean theorem at formal baseline | machine-checked relative to its explicit definitions/premises and reported axioms |
| `Paper3Audit.lean` | declaration-level axiom audit for listed Paper 3 results |
| repository documentation/manuscript | paper interpretation/claim organization; not new formal evidence |
| `portable-runtime` tests/runtime | implementation evidence for that repository; not a refinement proof for Paper 3 |

## Freeze rule

Paper 3 formal semantics remain frozen at `190e24e4...`.

A future formal change belongs to a new research milestone unless all manuscript-trigger conditions are satisfied. Citation repair, wording, figure rendering, venue formatting, artifact instructions, and version manifests are paper/packaging work and do not alter the Paper 3 semantic identity.

## Packaging identity

The artifact packaging identity is the merge commit of the PR that introduces this file. Record that exact merge SHA in `PAPER_VERSIONS.md` immediately after merge. That packaging commit is allowed to contain artifact/version metadata only; the formal semantic baseline remains `190e24e4...`.