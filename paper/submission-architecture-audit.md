# PR #22 — Submission Architecture Audit

Baseline: PR #21 merge commit `c7f2737dbe85cdffee4108b34f771a8c838d3b99`.

This pass is paper-only and creates a submission-facing manuscript without changing the frozen research draft or any formal/Python/CI semantics.

## Fixed architecture

- Figure 1: ROOT/INFER running trace plus historical/current relation layers only.
- Table 1: formation/qualification responsibility cut only.
- Contribution 1 anchor: R1.
- Contribution 2 anchor: R4.
- Contribution 3 anchor: Figure 1 + Table 1 + R6–R9.
- R2/R3 remain supporting; R5 remains orthogonal/supporting.

## Compression rule

The submission-facing Sections 3–6 use the pattern:

```text
motivation / boundary
→ exact theorem statement
→ one consequence paragraph
```

Repeated full restatements of `formation ≠ qualification` and `usability ≠ entitlement` are removed. The distinction is stated once in the introduction, visualized once in Figure 1/Table 1, and then instantiated by theorem statements.

## Semantic preservation checks

- No new theorem claim.
- No new transition.
- No `→*` / reflexive-transitive-closure notation.
- R6a retains `Reachable` for fresh ROOT non-usability.
- R7 remains a local one-step result with no `Reachable` premise.
- `P` remains ordered parent IDs; `W̄` remains ordered resolved objects.
- R8 reads parent usability in the qualification pre-state and writes the child at the exact post-state key.
- R9 remains an adjacent two-step theorem with separately quantified formation and qualification call-site identifiers.
- `Usable` remains a predicate, not a consumable resource.
- No suspension/revalidation, Adopt, TRANSPORT, Assembly, license lifecycle, or future temporal path appears in Figure 1.

## Exit condition

Satisfied when the submission-facing manuscript has one primary anchor per contribution family and no longer relies on repeated prose to make the central distinction legible.
