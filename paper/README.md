# First-paper workspace

Working title:

> **Separating Canonical History from Current Usability in a Finite Epistemic Kernel**

`Responsibility Topology` remains the interpretive framework and repository identity, but the paper title and theorem-facing thesis are intentionally narrower than the broader research program.

This directory is the paper-facing workspace for the first article built from the current mechanized core.

The paper-freeze rule is strict:

> **Do not expand the core semantics merely because another kernel constructor is available. Add a formal milestone only when writing exposes a theorem gap that cannot be crossed honestly.**

The theorem-facing central thesis is:

\[
\boxed{
\text{Canonical history and current usability are distinct state relations.}
}
\]

Historical formation and current qualification are distinct transitions governing those two relations.

For ordinary INFER, the stronger relation-level thesis is:

\[
\boxed{
\text{Historical derivation and current usable-parent responsibility are distinct relations.}
}
\]

A canonical warrant may exist in immutable formation/derivation history without thereby being currently usable or entitled. This statement does **not** imply that the historical object is epistemically adequate, that its source is authentic, or that the governing profile is normatively sufficient.

## Files

- `theorem-map.md` — paper-facing results R1–R9, their Lean witnesses, dependencies, and non-claims.
- `related-work-matrix.md` — comparison matrix used to discipline novelty claims before writing Section 9.
- `draft.md` — ten-section working paper. The current pass completes Section 2, the running example, Sections 7–9, and rewrites the Abstract/Introduction after related-work positioning.

## Frozen paper architecture

```text
1. Introduction
2. Problem, Relations, and Running Example
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
2. **Reachable canonical history/evaluation state.** An explicit initial boundary, kernel-owned transitions, immutable historical identity, and mutable evaluation state replace an arbitrary supplied world with a reachable one. Grounded adopted-context currentness is included as an orthogonal semantic currentness component, not as a completed reachable Adopt lifecycle.
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

> The reachable kernel establishes current usability, which is one input to the separately proved entitlement layer.

It must not yet say:

> The reachable kernel yields entitlement end-to-end.

Sections 3–6 can currently be written without an informal hidden assembly step, so the trigger condition for a State-Backed Licensing Read Assembly theorem has **not** fired.

## Running example contract

Fix one evaluation environment

\[
q=(\pi,c,u),
\]

and exact evaluation keys

\[
k_{p_1}=(\pi,c,u,p_1),\qquad
k_{p_2}=(\pi,c,u,p_2),\qquad
k_d=(\pi,c,u,d).
\]

The paper uses one minimal trace throughout Sections 2, 5, and 6:

```text
S0
 │ form ROOT p1
 │ form ROOT p2
 ▼
S1    p1,p2 historical; neither usable at k_p1,k_p2
 │ admit p1 at k_p1
 │ admit p2 at k_p2
 ▼
S2    Usable(S2,k_p1) and Usable(S2,k_p2)
 │ INFER d from [p1,p2]
 ▼
S3    d historical; NOT Usable(S3,k_d)
 │ qualifyInfer d at k_d
 │ requires Usable(S3,k_p1) and Usable(S3,k_p2)
 ▼
S4    Usable(S4,k_d)
```

The historical edges `p1,p2 → d` are persistent. The usable-parent condition is a time-indexed pre-state obligation at `S3` over the same parent identities. The example stops before suspension/invalidation because those transition semantics are future work.

## Related-work discipline

The first paper does **not** claim novelty for:

- storing provenance or justification structure;
- proof-relevant evidence objects;
- dynamically revisable explicit evidence;
- truth maintenance, retraction, or context switching in general;
- authorization depending on mutable state or time;
- staged or proof-carrying authorization, including revocable credential state;
- belief revision or dynamic epistemic state change.

The narrower positioning claim is that this mechanized kernel separates immutable warrant history, mutable current qualification, and branch-local entitlement observations, and proves a lifecycle in which ordinary INFER formation permanently records ordered historical parent identities without consuming parent usability, while later qualification evaluates current usability over those same historical parent identities in the pre-state without replaying historical formation obligations.

See `related-work-matrix.md` for the comparison matrix and bibliographic anchors.

## Permanent claim discipline

### Machine proved

- Branch Conservativity and Relative Branch Conservativity;
- Kernel-Floor Locality;
- exact full-move requirement resolution, including `none ≠ some top`;
- canonical projection coherence;
- reachable canonical-state invariance and historical referent immutability;
- grounded adopted-context currentness and absence of pure self-support as a semantic currentness component;
- ROOT formation/admission separation;
- ordinary INFER historical formation discipline and lineage preservation;
- INFER current-parent qualification and lifecycle separation.

### Differentially conformance tested

Selected Python V0.1.2.2 projection and context-currentness behavior is tested against mechanized projection semantics on finite fixtures.

### Not claimed

- Python operational refinement or a verified Python kernel;
- total `CanonicalState → LicensingRead → Entitled` assembly;
- reachable Adopt lifecycle;
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
