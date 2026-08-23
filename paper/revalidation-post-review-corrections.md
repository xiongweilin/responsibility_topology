# Paper 3 Post-Review Terminology Corrections

Status: paper-only correction checkpoint after hostile review. No Lean/Python/runtime semantics are changed or requested.

## Purpose

The hostile review correctly identified the main novelty and theorem-depth risks. A second pass against the actual Lean types exposes three narrower wording hazards that should be fixed during the next manuscript-editing pass. None requires a new theorem.

---

## C1 — Do not call the canonical state space finite

### Problem

The manuscript title and introduction currently use phrases such as:

```text
Finite Epistemic Kernel
finite Lean model
```

But `CanonicalState` is represented by function-valued maps such as:

```lean
context : String -> Option CanonicalContext
profile : String -> Option CanonicalProfile
binding : String -> Option CanonicalBinding
warrant : WarrantId -> Option HistoricalWarrant
license : ActivationLicenseId -> Option CanonicalActivationLicense
epi : EvalKey -> Option EpiStatus
placement : EvalKey -> Option Placement
```

The formal type therefore does not establish a globally finite state space or finite carrier.

What *is* explicitly finite in Paper 3 is the repair instance:

- `staleDependencies : List RepairObligation`;
- `edges : List RepairHyperedge`;
- each edge has `alternatives : List RepairAction`;
- `RevalidationTrace` is a finite `List RepairAction`.

`DescendantOf` also has finite proof paths by inductive construction, but that does not make the entire canonical state map finite.

### Required wording change

Preferred title:

> **Dependency-Sensitive Revision and Inclusion-Minimal Responsibility Repair in a State-Backed Epistemic Kernel**

Acceptable shorter title:

> **Dependency-Sensitive Revision and Responsibility Repair in a State-Backed Epistemic Kernel**

Replace generic claims such as:

> We develop this separation in a finite Lean model.

with:

> We develop this separation in a Lean state model whose Paper 3 repair problems and execution traces are finite.

The phrase **finite directed-hypergraph repair problem** remains correct.

### Formal trigger

**NO.** This is a manuscript precision correction.

---

## C2 — Use `state-indexed`, not `time-indexed`, for the Lean predicate

### Problem

The related-work and manuscript positioning sometimes summarize the central separation as:

```text
persistent historical dependency
!= time-indexed current responsibility
```

The Lean formalization does not contain an explicit clock or timestamp parameter in `Usable`, `BaseCurrent`, `Grounded`, or the challenge/revalidation state relations. Currentness is indexed by the current formal state and by exact profile/context/use/evaluation coordinates.

A transition sequence can of course be interpreted temporally, and the authorization literature cited by the paper includes explicit time. But calling the Paper 3 predicate itself **time-indexed** is stronger than the formal signature.

### Required wording change

Use:

```text
persistent historical dependency
!= state-indexed current responsibility
```

or, when exact coordinates matter:

```text
persistent historical dependency
!= state- and environment-indexed current responsibility
```

where "environment" is immediately explained by the represented profile/context/use key rather than treated as an unmodeled external environment object.

Reserve **time-indexed** for discussion of related systems that actually include explicit time, or qualify it as an interpretation of state evolution rather than a Lean parameter.

### Formal trigger

**NO.** No explicit time semantics are needed by the present paper.

---

## C3 — `EveryRepairCutNecessary` is a represented-cut necessity premise, not full extraction adequacy

### Problem

The paper often calls `EveryRepairCutNecessary` an "extraction-adequacy premise." This is useful shorthand but can be read too broadly.

The definition establishes one direction:

```text
for every represented edge e,
Restore(X) -> HitsRepairEdge(X,e).
```

So it justifies the **necessity of each represented cut** for a chosen restoration predicate.

It does *not* prove the converse modeling property that every real restoration-relevant dependency is represented by some edge. Nor does it prove that the stale-obligation vocabulary is complete, that the alternatives list is complete, or that the external domain model is correct.

Accordingly, full "extraction adequacy" has at least two conceptually different dimensions:

```text
represented-cut necessity / no spurious mandatory cuts

and

coverage / no missing restoration-relevant dependencies.
```

`EveryRepairCutNecessary` addresses the first dimension used by the universal lower-bound theorem. It does not establish the second.

### Required wording change

Preferred first use:

> Universal lower bounds require the explicit represented-cut necessity premise `EveryRepairCutNecessary`. This premise is one adequacy obligation for the extracted model; it does not establish completeness of the extraction.

Preferred discussion sentence:

> **Hypergraph minimality is exact relative to the extracted obligation model; necessity of represented cuts and completeness of the extraction remain separate modeling responsibilities.**

Avoid implying:

```text
EveryRepairCutNecessary
=
full repair-graph adequacy.
```

### Formal trigger

**NO.** A completeness theory for extraction would be a different research problem and is not indispensable to the current manuscript claim.

---

## C4 — Treat the premise-heavy theorems as interfaces, not theorem-depth claims

This was already identified in the hostile review and should survive venue compression.

`RepairRealization` contains the semantic effectiveness and target-closure obligations. `EveryRepairCutNecessary` contains the represented-cut necessity obligation. The corresponding sufficiency and lower-bound proofs are valuable because they expose and compose these responsibilities, not because they derive semantic effectiveness or model adequacy from the bare hypergraph.

Preferred framing:

```text
RepairSet             = combinatorial selection
RepairRealization     = semantic effectiveness interface
EveryRepairCutNecessary = represented-cut necessity interface
RevalidationTrace     = ordered execution interface
```

This is the paper's formal architecture.

---

## C5 — Title-level use of `minimal`

The hostile review already notes that **Minimal Responsibility Repair** can be misread as minimum-cardinality or optimal repair even though the text carefully means inclusion minimality.

Preferred title wording is therefore **Inclusion-Minimal Responsibility Repair** if minimality remains in the title.

This is a stronger firewall than relying on the abstract to repair the first impression.

---

## Post-review decision

These corrections do not change the Paper 3 mother claim:

> When canonical history is preserved but current responsibility is invalidated, restoration is a dependency-sensitive repair problem whose sufficient repairs are hitting sets of unresolved responsibility cuts, and whose inclusion-minimal repairs admit local necessity witnesses.

They sharpen its formal interpretation:

```text
canonical history: persistent state relation
current responsibility: state-indexed mutable relation
repair instance: finite directed hypergraph
sufficiency: conditional on RepairRealization
universal represented-cut necessity: conditional on EveryRepairCutNecessary
extraction completeness: not proved
execution: finite ordered proof-carrying trace
```

## Trigger verdict

```text
FORMAL REOPEN: NO
KERNEL EXPANSION: STOP
PAPER STATUS: READY FOR VENUE-SPECIFIC TIGHTENING AFTER TERMINOLOGY FIXES
```
