# Responsibility Topology — Artifact and Reproducibility Freeze

This document freezes the first-paper artifact boundary after the submission-architecture and novelty passes. It is a packaging and audit document; it adds no kernel semantics.

## 1. Locked research artifact

The paper-facing semantic artifact is locked to commit:

```text
d0074353176fc74c11bc33adab2feae448f56bd8
```

This commit contains the submission-facing architecture and the frozen novelty boundary while retaining the formal/Python theorem and executable surfaces used by the first paper. PR #24 adds only reproducibility documentation and a pinned convenience dependency file; it does not redefine the locked semantic baseline.

When reproducing a paper claim, check out the exact commit above rather than an arbitrary later `main`.

## 2. Reproduction environment

The locked commit pins the Lean toolchain in `formal/lean-toolchain`:

```text
leanprover/lean4:v4.19.0
```

The final pre-freeze GitHub Actions run over the same formal/Python semantic tree used:

```text
Ubuntu 24.04
CPython 3.12.14
Lean 4.19.0
Lake 5.0.0
pytest 9.1.1
```

PR #24 additionally supplies `artifact-requirements.txt` as a convenience for later checkouts. Because that file is packaging added after the locked semantic commit, exact reproduction of `d0074353…` should install the tested dependency directly as shown below.

## 3. Reproduce the Lean build and theorem audit

From a clean checkout of the locked commit:

```bash
cd formal
lake build
lake env lean ResponsibilityTopology/Audit.lean
```

The repository CI additionally rejects proof placeholders in the formal core with the equivalent check:

```bash
if grep -R -nE '(^|[^[:alnum:]_])(sorry|admit)([^[:alnum:]_]|$)' \
  formal/ResponsibilityTopology formal/ResponsibilityTopology.lean; then
  echo 'Proof placeholder found in formal core.'
  exit 1
fi
```

Run that command from the repository root.

### Reading the axiom audit correctly

`formal/ResponsibilityTopology/Audit.lean` uses `#print axioms` on the paper-relevant theorem surface. The output is the authoritative declaration-by-declaration dependency report.

Do **not** summarize the artifact as “all theorems are axiom-free.” Some results report standard Lean foundational dependencies such as `propext` and `Quot.sound`. This is distinct from an unfinished proof: the CI separately rejects `sorry` and `admit` placeholders.

Representative paper-facing audit results at the locked surface are:

| Paper result | Representative Lean declaration | Reported `#print axioms` dependency |
| --- | --- | --- |
| R1 | `relativeBranchConservativity` | none |
| R2 | `requirementLookup_exactKey` | `propext`, `Quot.sound` |
| R3 | `derives_projection_coherent` | none |
| R4 | `reachable_invariant` | `propext`, `Quot.sound` |
| R5 | `grounded_has_bootstrap_chain`, `no_grounded_without_bootstrap` | none |
| R6 formation exactness | `rootStep_newWarrant_exact` | `propext` |
| R6 formation non-usability | `rootStep_newWarrant_notUsable` | `propext`, `Quot.sound` |
| R6 admission | `admitRoot_makes_usable` | `propext` |
| R7 exact formation | `inferStep_newWarrant_exact` | `propext` |
| R7 lineage | `inferStep_lineage_union` | `propext` |
| R8 parent responsibility | `qualifyInfer_requires_usableParents` | `propext` |
| R8 exact qualification | `qualifyInfer_evaluation_exact`, `qualifyInfer_makes_usable` | `propext` |
| R9 | `inferFormationQualification_boundary` | `propext`, `Quot.sound` |

The full audit, not this summary table, is authoritative if a declaration changes in a later branch.

## 4. Reproduce the Python and cross-language tests

From the repository root of the exact locked commit, with Python 3.12:

```bash
python -m venv .venv
. .venv/bin/activate
python -m pip install pytest==9.1.1
python -m pytest -q \
  test_v0122_kernel.py \
  test_v0122_currentness.py \
  test_v0122_conformance.py \
  test_v0122_currentness_conformance.py
```

On Windows, activate the virtual environment using the platform-appropriate command before installing the dependency. On a later checkout containing PR #24 packaging, `python -m pip install -r artifact-requirements.txt` is equivalent for this test dependency.

The final pre-freeze CI run over the same formal/Python semantic tree reported:

```text
63 passed
```

The count is an artifact metric, not a theorem count and not a coverage proof.

The supported implementation claim is:

```text
selected Python observations are differentially conformance-tested
against the mechanized projection/currentness semantics
```

not:

```text
Python is verified
```

Formally:

\[
\boxed{
\text{Python conformance-tested}
\neq
\text{Python verified}.
}
\]

No source-level refinement theorem proves arbitrary Python states correspond to `CanonicalState` or that every Python operation refines `Step`.

## 5. Paper result → Lean declaration → source module

| Result | Representative declaration(s) | Source module | Submission role |
| --- | --- | --- | --- |
| R1 Relative Branch Conservativity | `relativeBranchConservativity` | `Entitlement.lean` | primary contribution anchor |
| R2 Exact Requirement Resolution | `requirementLookup_exactKey`, `requirementLookup_deterministic`, `missingRequirement_notTop` | `RequirementResolution.lean` | supporting |
| R3 Canonical Projection Coherence | `derives_projection_coherent` | `CanonicalRead.lean` | supporting |
| R4 Reachable Canonical-State Invariance | `reachable_invariant` | `Reachability.lean` | primary contribution anchor |
| R5 Grounded Currentness | `grounded_has_bootstrap_chain`, `no_grounded_without_bootstrap` | `ContextCurrentness.lean` | orthogonal/supporting |
| R6 ROOT separation | `rootStep_newWarrant_exact`, `rootStep_newWarrant_notUsable`, `admitRoot_evaluation_exact`, `admitRoot_makes_usable` | `RootFormation.lean`, `EvaluationQualification.lean` | contribution 3 |
| R7 INFER historical formation | `inferStep_newWarrant_exact`, `inferStep_orderedParentRoles_exact`, `inferStep_lineage_union` | `InferFormation.lean` | contribution 3 |
| R8 INFER current-parent qualification | `qualifyInfer_requires_usableParents`, `qualifyInfer_evaluation_exact`, `qualifyInfer_makes_usable` | `InferQualification.lean` | contribution 3 |
| R9 INFER lifecycle separation | `inferFormationQualification_boundary` | `InferQualification.lean` | contribution 3 |

`paper/theorem-map.md` contains the broader paper-facing family map. `paper/submission-draft.md` is the compressed submission-facing exposition. `paper/novelty-freeze.md` records the final first-paper novelty boundary.

## 6. Proved / tested / not claimed

| Status | Artifact boundary |
| --- | --- |
| **Machine checked in Lean 4** | branch/floor locality and R1; exact requirement semantics; canonical projection coherence; reachable-state invariant; grounded currentness semantics; ROOT formation/admission separation; ordinary INFER historical formation; current-parent qualification; adjacent lifecycle separation |
| **Differentially conformance-tested** | selected Python V0.1.2.2 static projection, satisfaction, floor, ambient, and adopted-context-currentness observations |
| **Definitional/model boundary** | exact `Usable = LIVE ∧ PLACED`; immutable historical lookup plane versus mutable evaluation plane; current `Step` constructor surface |
| **Not proved** | full Python operational refinement; total state-backed licensing-read assembly; reachable Adopt/license lifecycle; TRANSPORT; challenge/revision/revalidation transitions; arbitrary temporal persistence/closure; profile adequacy; kernel-floor adequacy; source authenticity; use/admission adequacy; Q_open; Q_close |

The following non-implications are part of the artifact boundary:

```text
HistoricalWarrant      ⇏ historical truth / justification
CurrentUsability       ⇏ Entitlement
FormationDiscipline    ⇏ adequacy
RecordedActor          ⇏ authenticated principal
RecordedBasis          ⇏ adequate basis
ProfileExecutionCorrectness ⇏ ProfileAdequacy
KernelCorrectness      ⇏ KernelFloorAdequacy
```

## 7. Explicitly frozen non-theorems

The first-paper artifact does not contain, and PR #24 does not add:

1. a total `CanonicalState → LicensingRead → Entitled` assembly theorem;
2. TRANSPORT lifecycle semantics;
3. reachable Adopt or license-issuance semantics;
4. challenge, revision, invalidation, or revalidation transitions;
5. an arbitrary-intervening-transition persistence theorem for R9;
6. a formal Python operational semantics or end-to-end refinement proof;
7. profile, rule, source, use, admission, or kernel-floor adequacy results.

These are not presumed by the paper. They remain future milestones only if a later submission claim makes one indispensable.

## 8. Artifact evaluation checklist

A third-party evaluator should be able to establish all of the following without interpreting project history:

- the exact semantic baseline commit is stated;
- the Lean version is pinned;
- `lake build` succeeds;
- the formal core contains no `sorry`/`admit` placeholders under the CI check;
- `Audit.lean` prints the declaration-level axiom dependencies;
- the four Python/conformance test files run in a clean Python environment;
- the expected locked-baseline test count is stated as an artifact metric;
- every paper result R1–R9 has an artifact locator;
- the distinction between theorem-backed, conformance-tested, definitional, and not-claimed surfaces is explicit;
- no reader needs to infer that Python conformance means verification or that R9 means temporal persistence.

If a future commit changes formal or executable semantics, this document must not be silently reused as its artifact lock; a new lock commit and audit are required.
