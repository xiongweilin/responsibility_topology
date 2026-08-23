# Paper 3 Language Precision Pass

Status: paper-only wording firewall after conceptual v3 and artifact freeze. No formal semantics.

This document records the final venue-neutral language rules that should survive any later page-limit compression.

## 1. Mother claim

Lead with:

> **Revision should withdraw current responsibility without rewriting historical dependency.**

Use the technical expansion only after the reader understands that principle:

```text
persistent historical dependency
!= state-indexed current responsibility
```

Do not lead with hitting sets.

## 2. Responsibility terminology

On the first page define:

> In this paper, responsibility means a represented proof/currentness obligation assigned to a formal semantic boundary; it carries no moral, legal, institutional, or professional conclusion.

Preferred compounds:

```text
current-responsibility obligation
repair responsibility
responsibility cut
responsibility model
```

Avoid anthropomorphic formulations such as “the warrant knows,” “the context decides,” or “the system realizes it was wrong” unless immediately translated to a formal relation.

For the future `Q_open` discussion, use:

```text
is entitled to reopen
has evidence that the represented regime is inadequate
```

rather than:

```text
knows its model is wrong.
```

## 3. State/time terminology

Paper 3 formal currentness is **state-indexed**, not explicitly time-indexed.

Use:

```text
state-indexed current responsibility
pre-state currentness obligation
post-challenge state
later reachable state
```

Avoid in theorem-facing prose:

```text
time-indexed predicate
at time t
permanent temporal persistence
```

unless time is only an informal lifecycle reading and the absence of a formal time parameter is clear.

## 4. Finiteness terminology

The whole `CanonicalState` type is not a type-level finite state space.

Use:

```text
state-backed epistemic kernel
finite repair instance
finite edge/alternative lists
finite concrete repair trace
```

Avoid:

```text
finite epistemic kernel
finite Lean model
finite-state system
```

unless a later formalization actually establishes the relevant finiteness property.

## 5. Impact language

Treat `Affected(S,t,w) := (w=t) or DescendantOf(S,t,w)` as a **modeled impact boundary**.

Preferred:

> We choose a specialized historical impact semantics in which a challenge ranges over the target and its transitive canonical warrant descendants, and then prove the corresponding invalidation, preservation, and refresh consequences.

Avoid:

> We prove that the affected set is exactly target plus descendants.

as a standalone novelty/result claim, because the exact equivalence is substantially definitional.

Do not generalize the specialized impact relation to all runtime/domain dependencies.

## 6. Currentness cascade language

Keep the three layers visible:

```text
warrant Usability
-> license BaseCurrent
-> context Groundedness
```

Say:

> loss of one represented premise can make the downstream currentness judgment fail.

Do not imply the predicates are definitionally identical or that every loss occurs in every challenge.

Use “may become stale,” “can fail,” or theorem-specific conditions where appropriate.

## 7. Repair selection and effectiveness

Never write:

```text
RepairSet restores the target.
```

Use:

> Under a sound `RepairRealization`, a `RepairSet` that hits every represented unresolved cut composes to target restoration.

Keep visible:

```text
RepairSet
!= RepairRealization.
```

`RepairSet` is combinatorial selection. `RepairRealization` is the semantic-effectiveness interface.

## 8. Minimality language

Always prefer:

```text
inclusion-minimal repair set
```

At first use, state explicitly that the result does not imply:

```text
minimum cardinality
minimum cost
optimality
uniqueness
canonical frontier
```

Use “private-cut witness” or “local non-removability witness” for T3.

Avoid:

```text
globally necessary action
the minimal frontier
minimum repair
optimal repair
```

unless the stronger property is actually supplied.

## 9. Necessity and adequacy language

This is the most important wording boundary after `RepairRealization`.

Use:

```text
represented-cut necessity
```

for what `EveryRepairCutNecessary(problem, Restore)` supplies.

Use:

```text
extraction completeness
responsibility-model adequacy
```

for the stronger unproved question of whether the represented cuts/vocabulary omit a decisive dependency.

Required sentence:

> **Hypergraph minimality is exact relative to the represented obligation model; necessity of represented cuts requires an explicit premise, while completeness of the extracted responsibility model remains a separate epistemic/modeling responsibility.**

Do not say:

```text
EveryRepairCutNecessary proves extraction adequacy.
```

It does not establish the absence of missing dependencies.

## 10. Reachability language

T4 is a **reachable realization bridge**.

Use:

> Given a valid ordered proof-carrying repair trace, the repair-set and realization premises compose with challenge/refresh reachability to restore the target in a reachable post-state.

Avoid:

```text
every repair set is executable
every minimal repair has a trace
repair execution is complete
any action order works.
```

For the running example, state:

> The extensional repair model exhibits two incomparable inclusion-minimal selections; the current reachable lifecycle directly demonstrates one proof-carrying branch.

Do not call both branches reachable.

## 11. Historical preservation language

Preferred:

> Each modeled challenge, refresh, and repair stage preserves the relevant canonical historical referents/topology.

Avoid:

> The final lifecycle theorem proves end-to-end history immutability.

The final theorem does not syntactically include the packaged `HistoryReferentsImmutable(S0,S4)` conjunct.

## 12. Runtime relationship language

Use the cross-repository call vocabulary:

```text
reference
boundary-reference
specialize
operationalize
represent
handoff
```

Preferred:

> `responsibility_topology` is a formal specialization within the same research program; `portable-runtime` operationalizes/represents related responsibilities, but no verified refinement currently connects the transition systems.

Avoid:

```text
verified runtime
Lean implementation of portable-runtime
portable-runtime implements the Lean model
semantic equivalence
```

unless a future theorem establishes the relation.

The dependency-policy mismatch must remain visible: Paper 3 uses transitive canonical warrant-descendant impact; the runtime also uses direct typed dependency-impact semantics with no generic recursive invalidation.

## 13. Cross-domain language

Do not promote repeated terminology to an invariant.

Use:

```text
candidate cross-domain invariant
structure to test under specialization
```

until a comparison theorem or multiple independent formal specializations exist.

Avoid:

```text
universal responsibility law
all domains share this topology
cross-domain invariant
```

as a proved statement.

## 14. Q_open language

The clean transition from Paper 3 is:

```text
correct repair inside a supplied responsibility model
!=
entitlement to treat the responsibility model as adequate.
```

Paper 3 should say that `Q_open` is open, not partially solved by `EveryRepairCutNecessary`.

Future conceptual decomposition:

```text
anomaly/failure signal
!= evidence of model inadequacy
!= entitlement to reopen
!= replacement vocabulary
!= validation of reopened regime.
```

This is research-program framing, not a Paper 3 theorem.

## 15. Related-work language

Concede mechanisms generously and compare exact relations narrowly.

Preferred pattern:

> Prior work X already provides Y. Paper 3 therefore does not claim Y as new. Our narrower focus is Z.

Required concessions:

- TMS/ATMS: persistent reasons/support plus revisable/current labels;
- provenance: derivational lineage;
- incremental maintenance/change impact: dependency propagation after change;
- stateful/revocable authorization: current authorization depends on mutable state;
- model-based diagnosis: minimal hitting sets and non-unique minimal solutions.

Avoid straw-man comparisons such as “prior work deletes history” or “authorization is timeless.”

## 16. Four-result hierarchy

Use only four peer-level remembered result families in title/abstract/introduction/conclusion exposition:

```text
T1 history-preserving currentness invalidation
T2 selection + realization -> restoration
T3 inclusion-minimal repair -> private-cut witnesses
T4 proof-carrying repair -> reachable realization bridge
```

Treat as definitions/lemmas/boundaries:

```text
Affected exact boundary
refresh contractiveness
represented-cut necessity premise
stage-local preservation lemmas.
```

This hierarchy should survive page-limit compression.

## 17. Compression stop rule

When shortening the paper, remove examples, repeated explanation, or secondary theorem signatures before removing a premise from a central claim.

Never compress:

```text
RepairSet + RepairRealization
```

into:

```text
RepairSet.
```

Never compress:

```text
represented-cut necessity under EveryRepairCutNecessary
```

into:

```text
universal necessity.
```

Never compress:

```text
one reachable example branch
```

into:

```text
all minimal repairs are reachable.
```

Claim precision has priority over rhetorical brevity.