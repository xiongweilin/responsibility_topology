# First-paper workspace

Working title:

> **Responsibility Topology for Finite Epistemic Kernels: Separating Historical Derivation from Current Usability**

This directory is the paper-facing workspace for the first article built from the current mechanized core.

The paper-freeze rule is strict:

> **Do not expand the core semantics merely because another kernel constructor is available. Add a formal milestone only when writing exposes a theorem gap that cannot be crossed honestly.**

The current central thesis is:

\[
\boxed{
\text{Historical justification and current epistemic responsibility are distinct state relations.}
}
\]

A canonical judgment may exist in immutable derivation history without thereby being currently usable or entitled.

## Files

- `theorem-map.md` — paper-facing results R1–R9, their Lean witnesses, dependencies, and non-claims.
- `draft.md` — fixed ten-section paper skeleton. Sections 1 and 3–6 are substantive first drafts; the remaining sections are scoped placeholders.

## Frozen paper architecture

```text
1. Introduction
2. Problem and Design Principles
3. Static Entitlement Calculus
4. Reachable Canonical Kernel
5. Historical Formation Is Not Current Qualification
6. Current-Parent Responsibility
7. Executable Reference and Conformance
8. Limits and Non-Theorems
9. Related Work
10. Discussion and Future Work
```

The first paper has three contribution families.

1. **Static entitlement locality.** Branch-local derivability, kernel-floor locality, Relative Branch Conservativity, exact full-move requirement resolution, and canonical projection coherence locate entitlement responsibility on explicit finite observation boundaries.
2. **Reachable canonical state.** An explicit initial boundary, kernel-owned transitions, immutable historical identity, mutable evaluation state, and grounded adopted-context currentness replace an arbitrary supplied world with a reachable one.
3. **Historical formation/current qualification separation.** ROOT and INFER provide two lifecycle instances showing that historical existence or derivability does not silently establish current usability. INFER further separates historical parenthood from current usable-parent responsibility.

The third contribution is the center of the paper. Python differential conformance is evidence about an executable reference implementation, not a fourth metatheoretical contribution.

## Paper-facing state pipeline

```text
immutable canonical history
        │
        │ formation
        ▼
historical warrant
        │
        │ explicit evaluation boundary
        ▼
current qualification
        │
        ▼
usable warrant
        │
        │ exact requirement + ambient admissibility + floor safety
        ▼
entitlement
```

The current mechanization does **not** contain one total theorem assembling every `CanonicalState` observation into a `LicensingRead` and then deriving `Entitled`. Existing narrow bridges include:

```text
HistoricalWarrant
    → CanonicalRead.CanonicalWarrant

epi + placement
    → usableFromState

CanonicalProfile
    → RequirementSnapshot

reachable state
    → ActivationRead structural well-formedness
```

Accordingly, the paper may say:

> The reachable kernel establishes current usability, which is one input to the previously proved entitlement layer.

It must not yet say:

> The reachable kernel yields entitlement end-to-end.

If Sections 3–6 cannot be written without an informal “we then feed these fields into the licensing read” step, the next formal milestone should be a narrow **State-Backed Licensing Read Assembly** result. TRANSPORT is not the default next milestone.

## Permanent claim discipline

### Machine proved

- Branch Conservativity and Relative Branch Conservativity;
- Kernel-Floor Locality;
- exact full-move requirement resolution, including `none ≠ some top`;
- canonical projection coherence;
- reachable canonical-state invariance and historical referent immutability;
- grounded adopted-context currentness and absence of pure self-support;
- ROOT formation/admission separation;
- ordinary INFER historical formation discipline and lineage preservation;
- INFER current-parent qualification and lifecycle separation.

### Differentially conformance tested

Selected Python V0.1.2.2 projection and context-currentness behavior is tested against mechanized projection semantics on finite fixtures.

### Not claimed

- Python operational refinement or a verified Python kernel;
- total `CanonicalState → LicensingRead → Entitled` assembly;
- TRANSPORT lifecycle;
- license issuance lifecycle;
- challenge/revision/revalidation transitions;
- source authenticity;
- admission, use, profile, or rule adequacy;
- `ProfileExecutionCorrectness → ProfileAdequacy`;
- `KernelCorrectness → KernelFloorAdequacy`;
- Q_open or Q_close.

Two non-theorems should remain visible throughout the paper:

\[
\boxed{
\text{ProfileExecutionCorrectness}
\not\Rightarrow
\text{ProfileAdequacy}
}
\]

and

\[
\boxed{
\text{KernelCorrectness}
\not\Rightarrow
\text{KernelFloorAdequacy}.
}
\]

The paper studies correct execution inside a finite responsibility regime. It does not establish that the regime itself is epistemically or normatively adequate.
