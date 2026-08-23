# PR #25 — Hostile Reviewer Claim Audit

Baseline: PR #24 merge commit `295a6911c739221ae87b262e234f706bd2fb3e96`.

This pass audits claim strength, not style. Every strong sentence in the submission-facing argument is assigned one of five evidence classes:

```text
theorem-backed
tested
definitional
interpretation
future work / not claimed
```

A sentence may mention several layers; the weakest relevant evidence class governs how strongly it may be worded.

## 1. Trigger rule

The only permitted reason to unfreeze Lean during this pass is:

> an indispensable first-paper core sentence cannot be honestly supported by the current theorem surface, and cannot instead be removed or narrowed without destroying the paper's core contribution.

Result of this audit:

```text
FORMAL TRIGGER: NOT FIRED
```

Every issue found below is resolved by existing theorem scope, definitional clarification, or claim narrowing. No new theorem or transition is required.

## 2. Claim-by-claim hostile audit

| Claim surface | Evidence class | Hostile reading | Audit disposition |
| --- | --- | --- | --- |
| canonical history and current usability are distinct state relations | theorem-backed + definitional | merely different fields, not a meaningful boundary | retain; R4 supplies reachable coherence and R6/R9 provide transition-visible witnesses |
| historical formation and current qualification are distinct transitions | definitional + theorem-backed | syntactic constructor split only | retain only with R6–R9 consequences; do not present constructor names alone as contribution |
| ordinary INFER historical parent occurrence relation differs from current usable-parent predicate | theorem-backed + definitional | generic proof/state separation already known | retain at the narrow same-parent-identity responsibility boundary; novelty wording frozen in #23 |
| `HistoricalWarrant` records canonical history | definitional | historical truth, historical validity, or epistemological justification | explicitly reject that reading; use “modeled formation/provenance” or “canonical historical object” |
| current `Usable` means `LIVE ∧ PLACED` at an exact key | definitional | permission, authorization, truth, or entitlement | retain exact definition; avoid normative synonyms such as “permission to rely” |
| usable warrant participates in entitlement | definitional/theorem-layer composition | usability alone implies entitlement | rewrite as “one input”; entitlement additionally requires ambient admissibility, derivability, and floor safety |
| R1 localizes entitlement observations | theorem-backed | all facts outside the branch can never matter to entitlement | retain only with fixed branch, fixed floor semantics/license/move, exact requirement, and `FixedAmbient` premises |
| exact requirement lookup distinguishes missing from `top` | theorem-backed | policy completeness or adequacy follows | retain; explicitly no adequacy conclusion |
| R3 uses the same canonical warrant object for satisfaction/floor projection | theorem-backed | every reachable state already yields a full `LicensingRead` | retain; total assembly remains absent |
| R4: every reachable state satisfies `CanonicalStateInvariant` | theorem-backed | all Python states or all conceivable transitions satisfy the invariant | retain only for explicit `InitialBoundary/Step/Reachable` surface |
| immutable historical referent identity across a modeled step | theorem-backed | all fields/history concepts are globally immutable | retain object-level lookup claim only; evaluation is intentionally mutable |
| R5 bootstrap-rooted grounded currentness | theorem-backed | reachable Adopt/license lifecycle is proved | explicitly reject; R5 is an orthogonal semantic component and the current `Step` surface lacks Adopt/license issuance |
| pure activation cycle cannot self-ground | theorem-backed | no cycles may exist structurally | retain only as no pure self-support for `Grounded`; do not claim graph acyclicity |
| fresh ROOT formation is non-usable | theorem-backed | any ROOT formation in any arbitrary state implies no usability | narrowed in manuscript: the global no-evaluation/non-usability result retains the `Reachable(pre)` premise |
| ROOT admission makes the child usable | theorem-backed | admission authenticates actor/basis or establishes entitlement | retain exact-key `LIVE/PLACED` result only; actor/basis adequacy remains outside model |
| admission “does not re-check” formation acceptance | definitional/constructor inversion | formation acceptance ceases to matter | narrowed: premise is absent from admission transition, while immutable history remains the object being admitted |
| R7 exact historical INFER formation | theorem-backed | requires reachability or current parent usability | retain: local one-`Step` theorem, no `Reachable` and no parent-`Usable` premise |
| `P` and `W̄` carry parent structure | theorem-backed + definitional | IDs and resolved objects can be conflated | retain distinct notation and existential structure |
| formation is occurrence-sensitive | definitional + theorem-backed | qualification must consume duplicate resources repeatedly | retain only for ordered derivational positions/role checking; no resource interpretation |
| qualification currentness is identity-sensitive | definitional | duplicate parent IDs imply use-once/linear semantics | explicitly reject; repeated occurrence asks for the same proposition, not a multiplicity-sensitive capability |
| `InferFormationDiscipline` checks rule/typing/guard/context/scope/strength conditions | theorem-backed/definitional | those checks prove rule/profile adequacy | manuscript narrowed from “discharges adequacy-like obligations” to “checks modeled conditions”; no adequacy claim |
| R8 requires current usable parents in qualification pre-state | theorem-backed | parent currentness is permanently frozen into child | retain pre-state indexing; no permanent dependency invariant claimed |
| R8 writes child `LIVE/PLACED` at exact post-state key | theorem-backed | all evaluation keys or all uses become usable | retain exact key `(B.profileDigest,c,u,w)` only |
| qualification does not replay formation | theorem-backed by constructor premise shape + history preservation | rule/guard/context/scope/lineage facts are irrelevant | manuscript now states they remain encoded in immutable history; “does not re-check” describes responsibility placement only |
| R9 shows child historical-but-not-usable then usable | theorem-backed | temporal persistence over arbitrary intervening traces | retain adjacent two-step theorem only; no `→*`, invalidation, or revalidation semantics |
| R9 formation and qualification call-site environments | theorem-backed | `(b_f,c_f)` and `(b_q,c_q)` are syntactically identified | retain separate quantification and recovered formation profile/context relation |
| Python observations conform to Lean projections/currentness | tested | Python kernel is verified | retain only “selected observations are differentially conformance-tested” |
| Python test count = 63 | tested artifact metric | 63 theorems / full coverage | keep only as reproducibility metric, never coverage evidence |
| `Audit.lean` reports axiom dependencies | tested/build artifact | every theorem has no axioms | explicitly reject; R4/R9 and other results report `propext`/`Quot.sound`; placeholder rejection is a separate CI property |
| novelty: persistent historical relation vs time-indexed current responsibility | interpretation grounded by theorem-backed interfaces | first proof/state or history/status separation in literature | retain only as project-specific mechanized decomposition; #23 forbids broad priority claims |
| adequacy boundaries | future work / not claimed | symbolic `X ⇏ Y` is a proved counterexample theorem | removed theorem-looking notation from submission/artifact; state instead that no implication is claimed and the stronger property is outside formal vocabulary |
| Assembly / TRANSPORT / temporal closure / reachable Adopt-license | future work / not claimed | implied by diagrams or prose | remain visually and formally absent from first-paper contribution surface |

## 3. Seven required attack cases

### 3.1 Historical warrant ≠ historical truth/justification

**Attack.** “Canonical historical warrant” could be read as a previously justified or previously true proposition.

**Finding.** The Lean object records modeled formation context/profile, constructor, parents, source/lineage, and other structural fields. It does not authenticate the source or prove external truth.

**Disposition.** Keep `historical`, `canonical`, `formation`, `provenance`; avoid `historically valid`, `historically justified`, and `historically true`.

Evidence class: **definitional + interpretation boundary**.

### 3.2 Usability ≠ entitlement

**Attack.** A reader may interpret `Usable` as authorization/entitlement.

**Finding.** `Usable` is exactly the evaluation predicate `LIVE ∧ PLACED` at a key. `Entitled` has additional ambient, derivability, exact-requirement, and floor-safety conjuncts.

**Disposition.** The main manuscript no longer presents `CurrentUsability \not\Rightarrow Entitlement` as if it were an independent mechanized counterexample theorem. It states the positive definitional fact: usability alone does not discharge the additional entitlement premises, and no stronger implication is claimed.

Evidence class: **definitional**.

### 3.3 Formation discipline ≠ adequacy

**Attack.** “Discharges rule/guard/context/scope/strength obligations” can sound as though the rule/profile regime is epistemically adequate.

**Finding.** `InferFormationDiscipline` checks only the modeled structural predicates.

**Disposition.** Submission wording now says formation **checks the modeled conditions**. Adequacy remains outside the theorem vocabulary.

Evidence class: **theorem-backed checks + interpretation boundary**.

### 3.4 R5 ≠ reachable Adopt lifecycle

**Attack.** Because `Grounded` is connected to reachable state, a reviewer may assume Adopt/license issuance is modeled dynamically.

**Finding.** The current `Step` surface contains bootstrap activation but no Adopt or license-issuance transition.

**Disposition.** R5 remains explicitly “orthogonal/supporting semantic currentness,” never a contribution-2 dynamic lifecycle.

Evidence class: **theorem-backed semantic component + not-claimed reachable lifecycle**.

### 3.5 R9 adjacency ≠ temporal persistence

**Attack.** A two-arrow figure may be read as representative of arbitrary future paths.

**Finding.** R9 consumes exactly adjacent formation and qualification steps. No invalidation/revalidation transition theory exists.

**Disposition.** Every paper arrow is defined as one `Step`; Figure 1 stops at qualification; R9 explicitly says no arbitrary intervening trace.

Evidence class: **theorem-backed with exact temporal scope**.

### 3.6 “Does not re-check” ≠ formation facts unimportant

**Attack.** The phrase could imply qualification ignores whether formation was legitimate.

**Finding.** Qualification operates on the already formed historical warrant. Reachable history preserves the formation referent and its well-formedness obligations; the later constructor simply has a different premise set.

**Disposition.** Added an explicit sentence to the Introduction and Table 1 caption: absence of a repeated premise locates responsibility; it does not erase the historical fact.

Evidence class: **constructor/definition + theorem-backed history preservation**.

### 3.7 Occurrence-sensitive parents ≠ linear/use-once resources

**Attack.** Duplicate parent occurrences might be interpreted as repeated credential consumption.

**Finding.** Formation list structure is occurrence-sensitive, but `InferParentsUsable` is a proposition over each parent ID membership at one exact key. Repetition does not create a linear accounting state.

**Disposition.** Keep “occurrence-sensitive formation / identity-sensitive currentness”; explicitly deny multiplicity-sensitive, consumable, and use-once semantics.

Evidence class: **definitional**.

## 4. Theorem-looking notation audit

Hostile review found that several `X \not\Rightarrow Y` displays were useful as conceptual warnings but could be read as theorem-backed counterexample results. The current artifact does not need those stronger syntactic forms to state its scope.

Changes made in #25:

- replaced `CurrentUsability \not\Rightarrow Entitlement` in the submission introduction with the exact positive statement that entitlement has additional premises;
- replaced profile/kernel adequacy non-implication displays with the statement that adequacy lies outside the formal vocabulary and no such implication is claimed;
- replaced the compressed unconditional-looking `ROOT Formation \not\Rightarrow Usable` display with the actual scoped R6a/R6b prose, preserving the `Reachable` premise for fresh ROOT non-usability;
- changed artifact `⇏` lines into explicit claim-classification prose rather than presenting them as mechanized non-implication theorems;
- changed “Formally, Python conformance-tested ≠ Python verified” to an artifact evidence-level distinction and explicitly states it is not a Lean theorem.

No contribution is weakened by these changes; only the evidence class becomes harder to misread.

## 5. Submission-surface residuals

Two residuals are intentionally left for venue-specific #26 formatting rather than treated as theorem gaps:

1. Figure 1 is currently a text figure and will need venue-quality rendering/layout.
2. Bibliographic references in the submission-facing Related Work remain a compact baseline; #23 freezes the novelty boundary, while #26 will format the final bibliography for the selected venue.

Neither residual creates a formal obligation.

## 6. Final hostile-review verdict

The current first-paper core survives the attack without kernel expansion.

```text
R1: supported at stated fixed-branch/fixed-boundary scope
R4: supported for explicit Reachable/Step surface
R6: supported with reachable fresh-formation scope preserved
R7: supported as local one-step historical formation
R8: supported at qualification pre-state / exact post-state key
R9: supported as adjacent two-step separation only
Python: tested, not verified
Adequacy: outside theorem surface
Novelty: narrow, non-priority, same-parent-identity responsibility decomposition
```

Therefore:

```text
Assembly trigger: NOT FIRED
TRANSPORT trigger: NOT FIRED
temporal-closure trigger: NOT FIRED
reachable Adopt/license trigger: NOT FIRED
new Lean theorem trigger: NOT FIRED
```

The next step is venue-specific PR #26, not a kernel milestone.
