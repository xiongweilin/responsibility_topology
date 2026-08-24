# Responsibility Topology — Navigation

This file is a logical index over the repository. It intentionally does **not** move historical research files.

Path stability is part of the research provenance: prior pull requests, audit documents, source reconstructions, and internal links refer to the existing paths. Repository cleanup therefore uses indexing rather than bulk relocation.

## A. Read first

- [`README.md`](README.md) — public entry point and compact status summary.
- [`RESEARCH_STATE.md`](RESEARCH_STATE.md) — **authoritative current research-governance state**.
- [`PROGRAM_ROADMAP.md`](PROGRAM_ROADMAP.md) — current architecture, frozen lines, and global stop rules.
- [`RESEARCH_DEBT.md`](RESEARCH_DEBT.md) — evidence-gated research debt ledger.
- [`CONTRIBUTING.md`](CONTRIBUTING.md) — admissible maintenance, correction, absorption, and evidence-event contributions.

## B. Frozen formal base and papers

Repository-level artifact and version locks:

- [`ARTIFACT.md`](ARTIFACT.md) — Paper 1 artifact lock.
- [`PAPER_VERSIONS.md`](PAPER_VERSIONS.md) — paper-specific frozen identities.
- [`PAPER3_ARTIFACT.md`](PAPER3_ARTIFACT.md) — Paper 3 formal artifact surface.
- [`paper/README.md`](paper/README.md) — manuscript-directory guide.

Paper 3 manuscript/audit entry points:

- [`paper/revalidation-claim-map.md`](paper/revalidation-claim-map.md) — claim firewall.
- [`paper/revalidation-running-example.md`](paper/revalidation-running-example.md) — running repair example.
- [`paper/revalidation-related-work.md`](paper/revalidation-related-work.md) — related-work positioning.
- [`paper/revalidation-paper-checkpoint.md`](paper/revalidation-paper-checkpoint.md) — manuscript-kernel checkpoint.
- [`paper/revalidation-hostile-review.md`](paper/revalidation-hostile-review.md) — hostile review.
- [`paper/revalidation-post-review-corrections.md`](paper/revalidation-post-review-corrections.md) — post-review corrections.

The `paper/` directory contains manuscript and review material. Paper-specific claims must be read from the relevant paper files and artifact locks rather than inferred from moving `main`.

## C. Strict-L6 and runtime/formal bridge

Current strict boundary:

- [`STRICT_LEVEL6_TECHNICAL_AUDIT.md`](STRICT_LEVEL6_TECHNICAL_AUDIT.md) — current Strict Technical Level-6 pass/freeze boundary.
- [`LEVEL6_TECHNICAL_AUDIT.md`](LEVEL6_TECHNICAL_AUDIT.md) — earlier Level-6 audit.
- [`CROSS_REPO_RELATION.md`](CROSS_REPO_RELATION.md) — permitted relation language between `responsibility_topology` and `portable-runtime`.
- [`OBSERVATION_BRIDGE_ALPHA0.md`](OBSERVATION_BRIDGE_ALPHA0.md) — restricted observation bridge.

The approved narrow execution chain is:

```text
selected runtime transition
-> raw serialized artifact
-> Lean parser
-> Lean-owned B0 projection
-> checker
-> restricted B0 contract
```

Do not infer full runtime refinement from this bridge.

## D. Cross-domain lineage

Core protocol, falsification, and verdict documents:

- [`CROSS_DOMAIN_FALSIFICATION_PROTOCOL.md`](CROSS_DOMAIN_FALSIFICATION_PROTOCOL.md)
- [`CROSS_DOMAIN_FALSIFICATION_MATRIX.md`](CROSS_DOMAIN_FALSIFICATION_MATRIX.md)
- [`CROSS_DOMAIN_CANDIDATE_VERDICT.md`](CROSS_DOMAIN_CANDIDATE_VERDICT.md)
- [`D4_SOFTWARE_REGRESSION.md`](D4_SOFTWARE_REGRESSION.md)

Cross-domain strength is frozen at **FORMAL SIMILARITY** under explicit interpretations, not mechanism similarity or external-domain verification.

## E. QO — archived negative-control lineage

QO is not an active theory track. The archived lineage preserves failed constructions and the firewalls they earned.

Start with:

- [`Q_OPEN_PROBLEM_FORMULATION.md`](Q_OPEN_PROBLEM_FORMULATION.md)
- [`Q_OPEN_PROBLEM_KERNEL.md`](Q_OPEN_PROBLEM_KERNEL.md)
- [`Q_OPEN_PRIOR_ART_ATTACK.md`](Q_OPEN_PRIOR_ART_ATTACK.md)
- [`Q_OPEN_QO2A_PROTOCOL.md`](Q_OPEN_QO2A_PROTOCOL.md)
- [`Q_OPEN_QO2B_D1_RULE103.md`](Q_OPEN_QO2B_D1_RULE103.md)
- [`Q_OPEN_QO2B_D2_PHARMACOVIGILANCE.md`](Q_OPEN_QO2B_D2_PHARMACOVIGILANCE.md)
- [`Q_OPEN_QO2B_D3_EPA_PARTICIPATORY_SCIENCE.md`](Q_OPEN_QO2B_D3_EPA_PARTICIPATORY_SCIENCE.md)
- [`Q_OPEN_QO2C_ELIMINATION_VERDICT.md`](Q_OPEN_QO2C_ELIMINATION_VERDICT.md)
- [`Q_OPEN_POST_FALSIFICATION_SYNTHESIS.md`](Q_OPEN_POST_FALSIFICATION_SYNTHESIS.md)
- [`Q_OPEN_HOSTILE_AUDIT.md`](Q_OPEN_HOSTILE_AUDIT.md)

Durable result: review is not standing; reviewability is not closure qualification; generic standing/closure-defeater objects were not earned.

## F. QX — Representation Inadequacy

Current state: **DORMANT / OPEN / PRE-FORMAL**. Candidate A is frozen and narrowed; Candidate B is eliminated; the current T-WAKE family is closed; E-WAKE is open but not actively searched.

Problem and prior-art boundary:

- [`QX_PROBLEM_KERNEL.md`](QX_PROBLEM_KERNEL.md)
- [`QX_PRIOR_ART_KILL.md`](QX_PRIOR_ART_KILL.md)
- [`QX_KERNEL_PREREGISTRATION.md`](QX_KERNEL_PREREGISTRATION.md)

Candidate A:

- [`QX4A_DOMAIN_FREEZE.md`](QX4A_DOMAIN_FREEZE.md)
- [`QX4A_WEBPKI_AUDIT.md`](QX4A_WEBPKI_AUDIT.md)
- [`QX4A_737MAX_AUDIT.md`](QX4A_737MAX_AUDIT.md)
- [`QX4A_PULSEOX_AUDIT.md`](QX4A_PULSEOX_AUDIT.md)
- [`QX4A_CANDIDATE_A_VERDICT.md`](QX4A_CANDIDATE_A_VERDICT.md)
- [`QX_SURVIVOR_ABSORPTION.md`](QX_SURVIVOR_ABSORPTION.md) — one-shot survivor-absorption audit; exact survivor narrowed.

Candidate B and non-unification:

- [`QX4B_DOMAIN_KILL_FREEZE.md`](QX4B_DOMAIN_KILL_FREEZE.md)
- [`QX4B_D1_INCOMPLETE_MODEL_DIAGNOSIS.md`](QX4B_D1_INCOMPLETE_MODEL_DIAGNOSIS.md)
- [`QX4B_D2_TLS_NEGOTIATION.md`](QX4B_D2_TLS_NEGOTIATION.md)
- [`QX4B_D3_SPACECRAFT_FAULT_CATALOGUE.md`](QX4B_D3_SPACECRAFT_FAULT_CATALOGUE.md)
- [`QX4B_CANDIDATE_B_VERDICT.md`](QX4B_CANDIDATE_B_VERDICT.md)
- [`QX5_CERTIFICATE_PROVENANCE_NON_UNIFICATION.md`](QX5_CERTIFICATE_PROVENANCE_NON_UNIFICATION.md)

Wake governance:

- [`QX_WAKE_GOVERNANCE.md`](QX_WAKE_GOVERNANCE.md)
- [`QX_TW_THEORETICAL_WAKE_ELIMINATION.md`](QX_TW_THEORETICAL_WAKE_ELIMINATION.md)

No generic `InsufficiencyCertificate` or QX Lean module is currently earned.

## G. QC — Provisional Shared Determination

Current state: **EVIDENCE-LIMITED / PRE-FORMAL** with zero source-backed positive residuals.

Methods and queue:

- [`QC_PREFORMAL_SCOUTING.md`](QC_PREFORMAL_SCOUTING.md)
- [`QC_FAILURE_CORPUS.md`](QC_FAILURE_CORPUS.md) — historical corpus ordering.
- [`QC3A_SOURCE_VIABILITY_AUDIT.md`](QC3A_SOURCE_VIABILITY_AUDIT.md)
- [`QC_EVIDENCE_PROTOCOL.md`](QC_EVIDENCE_PROTOCOL.md) — current mandatory evidence pipeline.
- [`QC_SOURCE_QUEUE.md`](QC_SOURCE_QUEUE.md) — post-QC3A source priorities; does not rewrite historical ordering.
- [`QC_EVIDENCE_REAUDIT.md`](QC_EVIDENCE_REAUDIT.md)
- [`QC_RIVALFIT_FALSIFIABILITY.md`](QC_RIVALFIT_FALSIFIABILITY.md) — one-shot method audit; RivalFit is explicitly source-disciplined and falsifiable at the evidence-method level.

Source-rich controls:

- [`QC_NEG_RPKI.md`](QC_NEG_RPKI.md) — distributed source/currentness does not establish one shared determination.
- [`QC_SRC_F5_DNSSEC_DELEGATION.md`](QC_SRC_F5_DNSSEC_DELEGATION.md) — a plausible common bounded basis still yields no QC residual when bounded authority and revalidation ownership are explicit.

No `ProvisionalSharedReliance`, generic QC object, or QC Lean module is currently earned.

## H. Reproducibility and implementation surfaces

- [`formal/`](formal/) — Lean formal program and audits.
- [`.github/workflows/lean.yml`](.github/workflows/lean.yml) — Lean build/check workflow.
- [`.github/workflows/conformance.yml`](.github/workflows/conformance.yml) — Python–Lean conformance and raw-artifact bridge workflow.
- [`v0122_kernel.py`](v0122_kernel.py) / [`v0122_conformance.py`](v0122_conformance.py) — executable reference/conformance surfaces.
- [`test_v0122_kernel.py`](test_v0122_kernel.py) / [`test_v0122_conformance.py`](test_v0122_conformance.py) — tests.

## I. Citation, licensing, and contributions

- [`CITATION.cff`](CITATION.cff) — repository-level citation metadata.
- [`LICENSE`](LICENSE) — Apache-2.0 source-code license.
- [`LICENSE-DOCS`](LICENSE-DOCS) — documentation licensing and manuscript exception.
- [`CONTRIBUTING.md`](CONTRIBUTING.md) — evidence-gated contribution policy.

## Provenance rule

Do not reorganize historical research files merely to improve directory aesthetics. A path move is justified only by an independent maintenance requirement that outweighs citation/link/provenance churn.

When a status summary conflicts with `RESEARCH_STATE.md`, treat `RESEARCH_STATE.md` as authoritative and file a documentation-drift issue.
