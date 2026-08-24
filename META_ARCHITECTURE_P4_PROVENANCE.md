# Meta-Architecture P4 — Evaluator Provenance and Freeze

Status: **P4 RAW OUTPUTS FROZEN / PROVENANCE RECONSTRUCTED POST-HOC**

This record is written after the three raw evaluator artifacts were committed at `3771e6319e14361030ef6d323ca662338c9e7fc8`. The evaluator sources themselves are user-attested to have followed the preregistered P4 blindness/provenance requirements. The fact that this ledger was not written before the raw-output commit is retained as a provenance limitation; this file does not rewrite that history.

## Frozen raw artifacts

| Evaluator | Raw artifact | Git blob SHA | Model/family |
|---|---|---|---|
| E1 | `E1_RAW.md` | `b64969b0b53a14d2b3c840a08bdca2804cb4c5d4` | GPT-5.6 Sol |
| E2 | `E2_RAW.md` | `62ad0fd874f9582e4985d5045268926910f16a3b` | Sonnet 5 |
| E3 | `E3_RAW.md` | `0eb3882fa02a6c639959423325c7fb14d2c105e5` | Grok 4.6 |

All three artifacts first enter repository history in commit `3771e6319e14361030ef6d323ca662338c9e7fc8`. That commit is the raw-output freeze boundary.

## Provenance ledger

The following fields distinguish facts present in repository history from facts supplied by the experiment owner after the raw outputs were frozen.

| Field | E1 | E2 | E3 |
|---|---|---|---|
| evaluator ID | E1 | E2 | E3 |
| model/family | GPT-5.6 Sol | Sonnet 5 | Grok 4.6 |
| investigator/process | user-attested compliant; exact pre-run identifier not separately recorded | same | same |
| prompt derivation | user-attested use of the frozen P4 packet; exact session transport metadata not separately recorded | same | same |
| repository exposure during blind stage | `none` — user attestation | `none` — user attestation | `none` — user attestation |
| architecture labels visible | `no` — user attestation | `no` — user attestation | `no` — user attestation |
| other evaluator outputs visible before freeze | `no` — user attestation | `no` — user attestation | `no` — user attestation |
| domain expertise | not separately recorded before freeze | not separately recorded before freeze | not separately recorded before freeze |
| evaluator run timestamp | not separately recorded before freeze | not separately recorded before freeze | not separately recorded before freeze |
| repository freeze timestamp | raw commit authored/committed 2026-08-24T09:59Z | same | same |
| raw output hash | Git blob SHA above | Git blob SHA above | Git blob SHA above |

No missing pre-run metadata is reconstructed as though it had been contemporaneously logged.

## Schema compliance

The three raw artifacts contain the required structural fields needed for P4/P4.5 comparison: `GroupId`, `MemberCases`, `FailureDistinction`, `PriorArtNeighborhood`, `KillTest`, `ResearchConsequence`, `CounterexampleToGroup`, plus the preregistered pre-literature fields `PredictedAbsorber`, `PredictedResidualIfNotAbsorbed`, and `DecisionBeforeLiteratureReveal`.

The artifacts are materially non-identical in grouping granularity: E1 produces six groups, E2 four groups, and E3 five groups. All three nevertheless independently prefer overlapping local families over a forced small mutually exclusive global decomposition.

## P4 verdicts

```text
DistinctEvaluatorLineages: YES
```

Basis: three different model/family lineages are frozen, and the experiment owner attests that repository exposure, architecture-label exposure, and cross-output visibility complied with the preregistered blind protocol.

This is **not** a claim of statistical independence.

```text
AntiPathDependenceEvidence: ESTABLISHED (QUALIFIED)
```

The qualification is twofold:

1. the evidence is only anti-path-dependence evidence, not external-reality evidence;
2. some provenance fields were reconstructed after the raw-output freeze rather than recorded contemporaneously.

The recurring structural distinctions are frozen more precisely in `META_ARCHITECTURE_AD_FREEZE.md`. No architecture winner is inferred at P4.
