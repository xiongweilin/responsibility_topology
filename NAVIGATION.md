# Responsibility Topology — Navigation

This file is the stable logical index for the repository.

`RESEARCH_STATE.md` is authoritative for current research governance. `SEARCH_SCOPE.md` is the authoritative companion for search provenance, blind spots, stopping bases, and wake conditions. Historical research documents are grouped under `research/` to keep the repository root readable while preserving their Git history and exact filenames.

## Read first

- [`README.md`](README.md) — public entry point and compact status summary.
- [`RESEARCH_STATE.md`](RESEARCH_STATE.md) — **authoritative current research-governance state**.
- [`SEARCH_SCOPE.md`](SEARCH_SCOPE.md) — **bounded search provenance and search-suspension semantics**.
- [`PROGRAM_ROADMAP.md`](PROGRAM_ROADMAP.md) — frozen architecture and global stop rules.
- [`RESEARCH_DEBT.md`](RESEARCH_DEBT.md) — evidence-gated research debt ledger.
- [`CONTRIBUTING.md`](CONTRIBUTING.md) — admissible Maintenance, Correction, Absorption, and EvidenceEvent contributions.
- [`research/README.md`](research/README.md) — grouped research-lineage index.

## Frozen formal base and papers

- [`ARTIFACT.md`](ARTIFACT.md) — Paper 1 artifact lock.
- [`PAPER_VERSIONS.md`](PAPER_VERSIONS.md) — paper-specific frozen identities.
- [`PAPER3_ARTIFACT.md`](PAPER3_ARTIFACT.md) — Paper 3 formal artifact surface.
- [`paper/README.md`](paper/README.md) — manuscript-directory guide.
- [`formal/`](formal/) — Lean formal program and audit modules.

Paper-specific claims must be read from the relevant artifact/manuscript files, not inferred from moving `main`.

The paper/formal freeze is an artifact/semantic-baseline freeze, not a claim that all external responsibility phenomena have been searched or exhausted.

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

Do not infer full runtime refinement or transition-class exhaustiveness from this bridge.

## Current research anchors

### QO — archived negative control

- [`Q_OPEN_POST_FALSIFICATION_SYNTHESIS.md`](Q_OPEN_POST_FALSIFICATION_SYNTHESIS.md) — owning archived checkpoint.
- Historical QO lineage: [`research/qo/`](research/qo/).

QO is a protocol-relative falsification stop over a recorded bounded sample. It does not claim search saturation or ontological absence.

### QX — Representation Inadequacy

Current state: **DORMANT / OPEN / PRE-FORMAL**.

- [`QX_WAKE_GOVERNANCE.md`](QX_WAKE_GOVERNANCE.md) — legal wake conditions.
- [`QX_TW_THEORETICAL_WAKE_ELIMINATION.md`](QX_TW_THEORETICAL_WAKE_ELIMINATION.md) — current T-WAKE family elimination.
- [`QX_SURVIVOR_ABSORPTION.md`](QX_SURVIVOR_ABSORPTION.md) — narrowed one-mechanism survivor audit.
- Historical QX construction/falsification lineage: [`research/qx/`](research/qx/).

No generic `InsufficiencyCertificate` or QX Lean module is currently earned. QX search exhaustion/saturation is not claimed; E-WAKE remains externally wakeable.

### QC — Provisional Shared Determination

Current state: **EVIDENCE-LIMITED / PRE-FORMAL** with zero source-backed positive residuals.

- [`QC_EVIDENCE_PROTOCOL.md`](QC_EVIDENCE_PROTOCOL.md) — current mandatory evidence pipeline.
- [`QC_RIVALFIT_FALSIFIABILITY.md`](QC_RIVALFIT_FALSIFIABILITY.md) — source-disciplined/falsifiable RivalFit method audit.
- Historical QC scouting, controls, and evidence queue: [`research/qc/`](research/qc/).

No `ProvisionalSharedReliance`, generic QC object, or QC Lean module is currently earned. QC search saturation is explicitly **not established**.

## Search-scope governance

Use [`SEARCH_SCOPE.md`](SEARCH_SCOPE.md) whenever a claim depends on negative search, search suspension, or a future wake event.

Permanent distinctions:

```text
TheoryGate = CLOSED
-/->
RealityHypothesis = ABSENT

SearchExhaustion
!= SearchSaturation
!= SearchSuspensionEntitlement
```

A search-sufficiency claim without a recorded `SearchScopeRecord` is inadmissible. Unrecorded historical query/database fields must remain marked `UNRECORDED`, not reconstructed after the fact.

## Cross-domain lineage

- [`CROSS_DOMAIN_CANDIDATE_VERDICT.md`](CROSS_DOMAIN_CANDIDATE_VERDICT.md) — current top-level verdict anchor.
- Historical protocol/matrix/D4 material: [`research/cross-domain/`](research/cross-domain/).

Cross-domain strength remains **FORMAL SIMILARITY** under explicit interpretations, not mechanism similarity or external-domain verification. The discovery sample is bounded and does not claim domain saturation.

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

When any summary conflicts with `RESEARCH_STATE.md`, treat `RESEARCH_STATE.md` as authoritative and file a documentation-drift issue. When a negative-search or stopping claim lacks a scope record, treat `SEARCH_SCOPE.md` as the governing correction surface.
