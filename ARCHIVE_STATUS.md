# Archive status

Status: **FROZEN RESEARCH ARTIFACT**.

This repository is preserved as formal-research provenance. It is not an active runtime dependency, not the current Framework definition owner, and not the canonical product-semantics owner.

## Current ownership after freeze

- `xiongweilin/ratio`, `元模型/` — current upstream conceptual / Framework definitions, responsibility cuts, semantic governance and theory-practice synthesis.
- `xiongweilin/agent-kernel`, `contracts/` — current canonical product semantics, protocol/conformance meaning, legal runtime states and transitions, responsibility, authorization, revision, recovery and execution contracts. The Python distribution / namespace retains the compatibility name `portable-runtime` / `portable_runtime`.
- `xiongweilin/responsibility_topology` — frozen Lean theorem/checker/proof artifacts, formal specializations, Strict-L6 evidence, cross-domain formal-similarity results, research governance and negative-result lineage.

No external repository is a normative dependency for `agent-kernel` product behavior. Conversely, product adoption of a distinction does not inherit the Lean proof itself or imply a whole-runtime refinement theorem.

## Frozen research result

The formal base (Papers 1–3) and Strict Technical Level 6 are frozen. QO remains an archived negative-control lineage. QX and QC remain pre-formal/evidence-gated and have no authorized Lean expansion under current evidence.

The repository remains valuable for four archival responsibilities:

1. preserving theorem and proof provenance;
2. preserving the narrow Strict-L6 certified observational bridge;
3. preserving rejected candidate families and negative controls so they are not silently reinvented;
4. preserving the exact evidence gates required before any future formal line may reopen.

## Reproduction boundary

The exact raw runtime artifact used by Strict-L6 is vendored under `frozen/strict-l6/` with origin commit and SHA-256 provenance. CI checks the local frozen artifact rather than downloading a mutable cross-repository path.

## Change policy

There is no active roadmap. Changes after this freeze should be limited to:

```text
Maintenance | Correction | Absorption | EvidenceEvent
```

A new theory or Lean line requires the evidence gates in `RESEARCH_STATE.md` and `CONTRIBUTING.md`; repository activity alone is not a reason to reopen research.

This file records the archival ownership boundary. Detailed historical correspondence remains in `CROSS_REPO_RELATION.md`.
