# Responsibility Topology — Navigation

This file is the stable logical index for the repository.

`RESEARCH_STATE.md` is authoritative for current research governance. Historical research documents are grouped under `research/` to keep the repository root readable while preserving their Git history and exact filenames.

## Read first

- [`README.md`](README.md) — public entry point and compact status summary.
- [`RESEARCH_STATE.md`](RESEARCH_STATE.md) — **authoritative current research-governance state**.
- [`PROGRAM_ROADMAP.md`](PROGRAM_ROADMAP.md) — frozen architecture and global stop rules.
- [`RESEARCH_DEBT.md`](RESEARCH_DEBT.md) — evidence-gated research debt ledger.
- [`SEARCH_SCOPE_PROVENANCE.md`](SEARCH_SCOPE_PROVENANCE.md) — recorded search scope, blind spots, and corrected freeze semantics.
- [`SEARCH_SUSPENSION_ENTITLEMENT_AUDIT.md`](SEARCH_SUSPENSION_ENTITLEMENT_AUDIT.md) — exact entitlement audit for construction freeze, candidate-family closure, and search dormancy.
- [`THEORY_GATE_SEMANTICS.md`](THEORY_GATE_SEMANTICS.md) — clarifies that `TheoryGate: CLOSED` blocks positive theory promotion/formalization, not theoretical inquiry itself.
- [`FREEZE_GOVERNANCE.md`](FREEZE_GOVERNANCE.md) — current interpretation of `FROZEN/STOP`: baseline lock, milestone closure, and default no-expansion do not establish architecture optimality/canonicality/path uniqueness.
- [`SUCCESSOR_FORMAL_LINE_GATE.md`](SUCCESSOR_FORMAL_LINE_GATE.md) — evidence and `SelectionProvenance` gate for any future formal lineage; no successor line is currently authorized.
- [`CONTRIBUTING.md`](CONTRIBUTING.md) — admissible Maintenance, Correction, Absorption, and EvidenceEvent contributions.
- [`research/README.md`](research/README.md) — grouped research-lineage index.

## Frozen formal base and papers

- [`ARTIFACT.md`](ARTIFACT.md) — Paper 1 artifact lock.
- [`PAPER_VERSIONS.md`](PAPER_VERSIONS.md) — paper-specific frozen identities.
- [`PAPER3_ARTIFACT.md`](PAPER3_ARTIFACT.md) — Paper 3 formal artifact surface.
- [`paper/README.md`](paper/README.md) — manuscript-directory guide.
- [`formal/`](formal/) — Lean formal program and audit modules.

Paper-specific claims must be read from the relevant artifact/manuscript files, not inferred from moving `main`.

## Strict-L6 and runtime/formal bridge

Current top-level anchors remain stable:

- [`STRICT_LEVEL6_TECHNICAL_AUDIT.md`](STRICT_LEVEL6_TECHNICAL_AUDIT.md) — current Strict Technical Level-6 pass/freeze boundary.
- [`LEVEL6_TECHNICAL_AUDIT.md`](LEVEL6_TECHNICAL_AUDIT.md) — earlier restricted checkpoint.
- [`CROSS_REPO_RELATION.md`](CROSS_REPO_RELATION.md) — permitted relation language between `responsibility_topology` and `portable-runtime`.
- [`OBSERVATION_BRIDGE_ALPHA0.md`](OBSERVATION_BRIDGE_ALPHA0.md) — restricted observation bridge.

Approved narrow chain:

```text
selected runtime transition
-> raw serialized artifact
-> Lean parser
-> Lean-owned B0 projection
-> checker
-> restricted B0 contract
```

Do not infer full runtime refinement from this bridge.

## Current research anchors

### QO — archived negative control

- [`Q_OPEN_POST_FALSIFICATION_SYNTHESIS.md`](Q_OPEN_POST_FALSIFICATION_SYNTHESIS.md) — owning archived checkpoint.
- Historical QO lineage: [`research/qo/`](research/qo/).

### QX — Representation Inadequacy

Current state: **DORMANT / OPEN / PRE-FORMAL**.

- [`QX_WAKE_GOVERNANCE.md`](QX_WAKE_GOVERNANCE.md) — legal wake conditions.
- [`QX_TW_THEORETICAL_WAKE_ELIMINATION.md`](QX_TW_THEORETICAL_WAKE_ELIMINATION.md) — current T-WAKE family elimination.
- [`QX_SURVIVOR_ABSORPTION.md`](QX_SURVIVOR_ABSORPTION.md) — narrowed one-mechanism survivor audit.
- Historical QX construction/falsification lineage: [`research/qx/`](research/qx/).

No generic `InsufficiencyCertificate` or QX Lean module is currently earned.

### QC — Provisional Shared Determination

Current state: **EVIDENCE-LIMITED / PRE-FORMAL** with zero source-backed positive residuals.

- [`QC_EVIDENCE_PROTOCOL.md`](QC_EVIDENCE_PROTOCOL.md) — current mandatory evidence pipeline.
- [`QC_RIVALFIT_FALSIFIABILITY.md`](QC_RIVALFIT_FALSIFIABILITY.md) — source-disciplined/falsifiable RivalFit method audit.
- Historical QC scouting, controls, and evidence queue: [`research/qc/`](research/qc/).

No `ProvisionalSharedReliance`, generic QC object, or QC Lean module is currently earned.

## Kill-first meta-architecture audit

This was theoretical inquiry under the existing closed promotion gate; it was **not** a new positive theory track and did not alter the authoritative QX/QC states above.

Protocol/preregistration:

- [`META_ARCHITECTURE_P0_AUDIT.md`](META_ARCHITECTURE_P0_AUDIT.md) — P0 `AUDIT-WORTHY`, not architecture adequacy.
- [`META_ARCHITECTURE_P1_CORPUS.md`](META_ARCHITECTURE_P1_CORPUS.md) — endogenous/native-language exogenous corpus freeze.
- [`META_ARCHITECTURE_P2_NARROWING_PROVENANCE.md`](META_ARCHITECTURE_P2_NARROWING_PROVENANCE.md) — `ELIMINATED / ABSORBED / BRACKETED / UNOWNED / UNKNOWN` narrowing audit.
- [`META_ARCHITECTURE_P3_P7_PROTOCOL.md`](META_ARCHITECTURE_P3_P7_PROTOCOL.md) — A0/A1/A2/null competition, hostile partial order, promotion gate, and stop rules.
- [`META_ARCHITECTURE_HELDOUT_UNIVERSE.md`](META_ARCHITECTURE_HELDOUT_UNIVERSE.md) — deterministic RAIB held-out source universe and primary/reserve selection.
- [`META_ARCHITECTURE_EVALUATOR_PROTOCOL.md`](META_ARCHITECTURE_EVALUATOR_PROTOCOL.md) — evaluator blindness/provenance, prediction freeze, neutral `A_D`, and failure modes.
- [`META_ARCHITECTURE_EXPERIMENT_BUDGET.md`](META_ARCHITECTURE_EXPERIMENT_BUDGET.md) — fixed `3 evaluator lineages + 2 held-out cases + 1 adjudication` budget.

Frozen P4/P5 results:

- `E1_RAW.md`, `E2_RAW.md`, `E3_RAW.md` — frozen blind raw outputs.
- [`META_ARCHITECTURE_P4_PROVENANCE.md`](META_ARCHITECTURE_P4_PROVENANCE.md) — distinct-lineage verdict and qualified post-hoc provenance reconstruction.
- [`META_ARCHITECTURE_AD_FREEZE.md`](META_ARCHITECTURE_AD_FREEZE.md) — neutral D1-D5 data-driven architecture freeze before held-out adjudication.
- [`META_ARCHITECTURE_P5_VIABILITY.md`](META_ARCHITECTURE_P5_VIABILITY.md) — Helpston and Bookham Tunnel primary cases locked; no reserve activation.
- [`META_ARCHITECTURE_P5_PREDICTIONS.md`](META_ARCHITECTURE_P5_PREDICTIONS.md) — frozen architecture × held-out pre-literature prediction matrix.
- [`META_ARCHITECTURE_P5_NATIVE_OUTCOMES.md`](META_ARCHITECTURE_P5_NATIVE_OUTCOMES.md) — railway-native reconstruction; both locked held-outs absorbed by ordinary mechanisms on the frozen source surface.
- [`META_ARCHITECTURE_P5_ADJUDICATION.md`](META_ARCHITECTURE_P5_ADJUDICATION.md) — single authorized adjudication and STOP.

Final meta-audit checkpoint:

```text
P0: AUDIT-WORTHY
P1: CORPORA FROZEN
P2: PROVENANCE AUDITED
P3: CANDIDATES FROZEN
P4: COMPLETE; DistinctEvaluatorLineages = YES
    AntiPathDependenceEvidence = ESTABLISHED (QUALIFIED)
P4.5: A_D = D1-D5 FROZEN
P5-A: BOTH PRIMARY CASES LOCKED
P5-B: PREDICTION MATRIX FROZEN
P5-C: BOTH HELD-OUT RESIDUAL SETS EMPTY ON FROZEN SOURCE SURFACE
P5-D: COMPLETE / STOP
VERDICT: No architecture dominance established
GlobalPartition: NOT EARNED
```

The experiment budget is exhausted. No fourth evaluator, third held-out case, A3, or repeated adjudication is authorized. The only experiment wake condition remains the preregistered naturally occurring high-cost architecture-conflict case.

Do not infer a third Q-track, a small global partition, architecture completeness, architecture optimality, or a formalization entitlement from this meta-audit.

## Cross-domain lineage

- [`CROSS_DOMAIN_CANDIDATE_VERDICT.md`](CROSS_DOMAIN_CANDIDATE_VERDICT.md) — current top-level verdict anchor.
- Historical protocol/matrix/D4 material: [`research/cross-domain/`](research/cross-domain/).

Cross-domain strength remains **FORMAL SIMILARITY** under explicit interpretations, not mechanism similarity or external-domain verification.

## Legacy pre-Lean / hand-formal documents

Earlier theoretical and hand-formal design documents are preserved under [`research/legacy/`](research/legacy/). They are historical provenance, not current formal authority.

## Reproducibility and implementation surfaces

- [`.github/workflows/lean.yml`](.github/workflows/lean.yml) — Lean build/check workflow.
- [`.github/workflows/conformance.yml`](.github/workflows/conformance.yml) — Python–Lean conformance/raw-artifact workflow.
- [`v0122_kernel.py`](v0122_kernel.py), [`v0122_conformance.py`](v0122_conformance.py), [`v0122_currentness_conformance.py`](v0122_currentness_conformance.py) — executable reference/conformance surfaces.
- `test_v0122_*.py` — frozen regression/conformance tests.

## Citation, licensing, and contributions

- [`CITATION.cff`](CITATION.cff) — repository-level citation metadata.
- [`LICENSE`](LICENSE) — Apache-2.0 source-code license.
- [`LICENSE-DOCS`](LICENSE-DOCS) — documentation licensing and manuscript exception.
- [`CONTRIBUTING.md`](CONTRIBUTING.md) — evidence-gated contribution policy.

## Provenance rule after this reorganization

The `research/` grouping is a repository-maintenance move only. It does not change any research result, checkpoint identity, theorem, evidence verdict, or formalization gate. Historical filenames are preserved, and Git history remains the provenance record for their former root paths.

Future path moves require an independent maintenance reason; directory aesthetics alone are not sufficient.

When any summary conflicts with `RESEARCH_STATE.md`, treat `RESEARCH_STATE.md` as authoritative and file a documentation-drift issue.
