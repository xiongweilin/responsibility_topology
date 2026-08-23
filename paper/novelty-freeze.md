# PR #23 — Related Work and Novelty Freeze

Baseline: PR #22 merge commit `9e6b6d76edfd0efa71867a1dd5a4e17d5d2b227f`.

This is the final descendant-literature pass for the first-paper theorem surface. It may narrow novelty language; it does not create a theorem obligation. The kernel remains frozen.

## Frozen novelty boundary

The general claim is:

\[
\boxed{
\text{persistent historical relation}
\neq
\text{time-indexed current responsibility}
}
\]

inside one explicitly reachable, mechanized finite kernel.

The ordinary-INFER claim is narrower:

\[
\boxed{
\text{historical parent occurrence relation}
\neq
\text{current usable-parent predicate}.
}
\]

The machine-checked content behind the second statement is not merely “proof first, state check later.” It fixes the dependency object across the boundary:

```text
formation:
  ordered stored parent occurrences P
  + exact rule / typing / guard / context / scope / strength / lineage obligations
  + no parent-Usable premise

qualification:
  the same stored parent identities
  + Usable(σ_pre,(π,c,u,p)) for each stored parent identity
  + exact child LIVE/PLACED write at (π,c,u,w) in σ_post
  + no replay of formation obligations
```

Entitlement remains a third relation. `CurrentUsability` is not promoted into `Entitled`.

## Descendant pass 1 — revocable and stateful authorization

The security literature already blocks any broad claim that persistent proof/certificate material and mutable access-time state are novel.

- Proof-Carrying Authentication makes authorization depend on explicit checkable proof objects.
- PCFS separates proof/certificate verification from later state/time checks through conditional capabilities.
- Stateful Authorization Logic explicitly supports interpreted state predicates and time inside authorization reasoning.
- The revocable/use-once PCFS extension keeps proof objects while consulting mutable revocation and use-once certificate state at file access. Its use-once side also uses linear-resource ideas to count credential consumption.

Therefore the paper must not claim novelty for:

```text
proof object + mutable current state
proof verification + later state check
revocation state
use-once credentials
linear / consumable authorization resources
```

This makes the present non-linearity statement important but not itself a novelty claim: `InferParentsUsable` is an idempotent predicate over parent identities, not a use-once resource semantics.

Primary anchors for this freeze:

- Deepak Garg and Frank Pfenning, “A Proof-Carrying File System,” IEEE S&P 2010.
- Jamie Morgenstern, Deepak Garg, and Frank Pfenning, “A Proof-Carrying File System with Revocable and Use-Once Certificates,” STM 2011, DOI `10.1007/978-3-642-29963-6_5`.
- Deepak Garg and Frank Pfenning, “Stateful Authorization Logic—Proof Theory and a Case Study,” Journal of Computer Security 20(4), 2012, DOI `10.3233/JCS-2012-0456`.

Frozen comparison sentence:

> Stateful and revocable authorization already combines persistent proof or certificate material with mutable time, state, revocation, or consumption checks. Our contribution is not that separation in general; it is the machine-checked boundary in which an immutable ordered derivation-parent relation is later re-read through current usability of those same stored parent identities.

## Descendant pass 2 — dynamic justification/evidence and truth maintenance

Truth-maintenance and dynamic evidence traditions already make it unsafe to claim novelty for preserving reasons while support or evidence state changes.

- ATMS maintains explicit justification/assumption structure while supported environments change.
- Justification Logic makes justification objects explicit.
- Dynamic justification/evidence work models evidence addition, announcement, upgrade/update, admissibility, and elimination.
- Bryan Renne’s evidence-elimination work explicitly combines Justification Logic and Dynamic Epistemic Logic with removal of evidence.

Therefore the paper must not claim novelty for:

```text
explicit reasons / justification objects
support that changes while reasons remain represented
evidence introduction, update, upgrade, or elimination
retraction / belief-state change in general
```

Primary anchors for this freeze:

- Johan de Kleer, “An assumption-based TMS,” Artificial Intelligence 28(2), 1986.
- Bryan Renne, “Multi-agent Justification Logic: communication and evidence elimination,” Synthese 185(S1), 2012, DOI `10.1007/s11229-011-9968-7`.
- Alexandru Baltag, Bryan Renne, and Sonja Smets, dynamic justified-belief/evidence work (2012; 2014).
- Samuel Bucheli, Roman Kuznets, and Thomas Studer, dynamic/public-announcement justification work.

Frozen comparison sentence:

> Dynamic justification/evidence logics and truth-maintenance systems already preserve or manipulate explicit reasons under changing support or evidence conditions. The present theorem claim is narrower: one kernel permanently records ordered INFER parent occurrences and later applies a distinct pre-state `Usable` predicate to those same stored parent identities without replaying formation.

## Descendant pass 3 — provenance and dependency under updates

The provenance literature also blocks any broad claim that derivation history under updates, transaction history, or undo is novel.

- Semiring provenance gives algebraic dependency information for query results.
- GProM descendants extend provenance to updates and transactions through multi-version semiring ideas and reenactment; transactional history can be replayed to recover how tuple versions were derived.
- Recent ProvSQL work extends provenance tracking to `INSERT`, `UPDATE`, and `DELETE`, and uses update provenance for time travel, history tracking, and undo.

Therefore the paper must not claim novelty for:

```text
recording dependency / provenance
preserving derivation history across updates
transaction-history provenance
time travel / historical reconstruction
undo or replay as such
```

Primary anchors for this freeze:

- Todd J. Green, Grigoris Karvounarakis, and Val Tannen, “Provenance Semirings,” PODS 2007.
- Bahareh Arab, “Provenance For Transactional Updates,” PhD thesis, Illinois Institute of Technology, 2019; MV-semirings and reenactment for update/transaction provenance.
- Albert Ariel Widiaatmaja, Belkis Djeffal, Ashish Dandekar, and Pierre Senellart, “Demonstration of ProvSQL Update Provenance through Temporal Databases,” ProvenanceWeek 2025, DOI `10.1145/3736229.3736253`.

Frozen comparison sentence:

> Provenance systems already represent dependency histories and descendants support updates, transactions, replay, temporal history, and undo. The present result is not historical dependency representation under change; it is the explicit separation between a persistent historical parent relation and a distinct time-indexed current-usability responsibility over the same parent identities.

## Abstract / Introduction / Related Work wording audit

The submission-facing manuscript created in PR #22 already uses the same boundary language in all three locations:

```text
Abstract:
  persistent historical relations
  versus time-indexed current responsibility

Introduction:
  historical parent occurrence relation
  versus current usable-parent predicate

Related Work:
  persistent historical relation
  versus time-indexed current responsibility
  with the narrower ordinary-INFER version repeated explicitly
```

No theorem expansion is required to align them. This PR therefore freezes the wording rather than strengthening it.

The final manuscript should use the following positive novelty paragraph, modulo venue-level compression:

> **We mechanize a finite reachable kernel in which canonical historical relations, current evaluation responsibility, and branch-local entitlement observations are separate interfaces. ROOT and INFER make the historical/current split transition-visible. In ordinary INFER, formation records exact ordered historical parent occurrences and discharges rule, typing, guard, context, scope, strength, and lineage obligations without requiring parent usability. Later qualification applies the pre-state predicate `Usable(σ_pre,(π,c,u,p))` to those same stored parent identities and establishes child usability at the exact post-state key without replaying formation.**

## Forbidden novelty formulations

Do not write any of the following:

```text
first system to separate proof from state
first system to preserve history while validity changes
first explicit evidence system with updates
first revocable proof-carrying system
first provenance system for changing data
first system to distinguish derivation from current validity
```

Do not infer an absence claim about an entire research tradition from absence in one cited paper.

Do not replace `historical warrant` with `historically true`, `historically valid`, or `historically justified`.

Do not replace `current usability` with `entitlement`, `truth`, or `authorization` without the corresponding theorem premises.

## Freeze result

Novelty is now frozen at the dependency-object / responsibility-boundary level. Any later literature discovery may force narrower wording, but may not be answered by broadening R1–R9 or adding a new kernel transition during the first-paper sequence.
