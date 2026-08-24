# Meta-Architecture Audit — P0 Informativeness Gate

Status: **AUDIT-WORTHY / NO ARCHITECTURE VERDICT**

Change class: meta-research only. No Lean, Python, Paper 1–3 semantic, Strict-L6, QX, or QC object change.

This file tests whether research-architecture competition has information value at all. It does **not** assume that the open research space admits a small global decomposition.

## 1. Kill-first question

The only P0 question is:

> If the same unresolved problem is viewed under different research architectures, do admission, prior-art neighborhood, kill condition, or research priority change in a testable way?

Define the research decision profile

```text
DecisionProfile(A, q)
= (
    admission,
    prior_art_neighborhood,
    kill_condition,
    research_priority
  )
```

and research-equivalence on the frozen probe set `Q0`:

```text
Ai ~=research Aj
iff
for every q in Q0,
DecisionProfile(Ai,q) and DecisionProfile(Aj,q)
lead to the same research action up to renaming.
```

Global P0 kill:

```text
if every candidate pair is ~=research,
STOP Architecture Audit.
```

P0 is passed only by finding at least one stable action difference that is not a vocabulary change.

## 2. Candidate architectures tested at P0

These are experimental partitions, not promoted theory objects.

### A0 — current working decomposition

```text
{ QX Representation Inadequacy,
  QC Provisional Shared Determination }
```

Problems outside QX/QC are not automatically retained as a third track.

### A1 — current decomposition plus an unowned pool

```text
{ QX,
  QC,
  UnownedResidualPool }
```

`UnownedResidualPool` is a holding area only. Membership does not authorize a new theory track.

### A2 — lifecycle-position candidate

```text
{ Genesis,
  Currentness,
  Revision/Constitution }
```

This is a test partition. It is not assumed to be exhaustive, disjoint, or better than QX/QC.

### A_null — null architecture

```text
No small stable global decomposition.
Use overlapping local problem families and explicit provenance instead.
```

`A_null` must be allowed to win.

## 3. Frozen P0 probe set

The probe set is intentionally small and uses already-recorded unresolved or boundary questions. It is sufficient only for the informativeness gate, not for architecture selection.

### Q0-1 — runtime/formal impact mismatch

The frozen Strict-L6 bridge checks a restricted qualification-withdrawal observation, while runtime direct typed impact and formal transitive historical impact remain intentionally non-equivalent.

### Q0-2 — repair-model adequacy boundary

Paper 3 proves repair results relative to represented cuts, `RepairRealization`, and represented-cut necessity premises, while automatic/complete `Challenge -> RepairProblem` extraction remains outside the theorem surface.

### Q0-3 — pre-refinement discriminator-unavailability survivor

QX retains one narrowed Web-PKI mechanism-specific survivor but has not earned a generic insufficiency certificate.

### Q0-4 — provisional shared-determination evidence problem

QC has source-backed negative controls but no surviving positive residual and no generic shared-reliance object.

### Q0-5 — gate/review/reopen residue after QO falsification

Generic `ChallengeStanding` and closure-defeater objects were not earned; use-indexed admissibility and ordinary review/procedural state absorbed the tested cases.

### Q0-6 — search-stop entitlement

The repository distinguishes construction freeze, search state, search saturation, and unresolved reality. Search suspension is not licensed by absence of positive residuals alone.

## 4. Decision-profile comparison

The following are research-action differences, not claims that one action is correct.

| Probe | A0 `{QX,QC}` | A1 `+ unowned` | A2 lifecycle-position | A_null |
|---|---|---|---|---|
| Q0-1 impact mismatch | outside active QX/QC; no default promotion | retain as unowned bridge/impact residual | route primarily to Currentness/Revision and change-impact/refinement neighbors | keep as local bridge problem; no global owner |
| Q0-2 repair-model adequacy | possible QX-adjacent only if representation-inadequacy evidence appears; otherwise outside | retain explicitly as unowned extraction/adequacy debt | route to Revision/Constitution; test dependency-extraction and model-selection neighbors | keep as Paper-3 modeling boundary only |
| Q0-3 discriminator-unavailability | QX | QX | Genesis first; representation/observation prior art dominates | retain mechanism-specific Web-PKI family unless cross-case structure appears |
| Q0-4 shared determination | QC | QC | no natural single owner; likely overlap between Genesis and Revision/Constitution | retain multi-party trust/authority family without forcing a global axis |
| Q0-5 gate/reopen residue | archived QO negative result; no QX/QC owner by default | preserved as eliminated generic form plus possible unowned native residues | Revision/Constitution would admit the generic question earlier, then face prior-art/ordinary-process kill tests | retain only native legal/procedural families unless a new residual survives |
| Q0-6 search-stop entitlement | repository governance, not QX/QC theory | governance, not unowned theory | risk of misrouting into Constitution unless explicitly firewalled | governance only |

## 5. P0 result

The candidate architectures are **not** research-equivalent on the frozen probes.

At least four non-lexical differences occur:

1. **Admission:** A1 preserves otherwise ownerless residuals that A0 may leave outside the working research architecture.
2. **Prior-art neighborhood:** A2 sends Q0-3 first toward representation/observation/genesis neighbors, while A0 sends it through the frozen QX provenance machinery.
3. **Kill path:** A_null treats Q0-1/Q0-2 as local bridge/modeling boundaries unless additional cross-case structure survives; A2 admits them into a global lifecycle partition earlier and therefore bears an extra anti-overgeneralization burden.
4. **Priority/governance:** Q0-6 exposes a failure mode in which an architecture can incorrectly absorb research-governance questions as object theory; A0/A_null currently keep this outside theory.

Therefore:

```text
P0 ArchitectureCompetition: AUDIT-WORTHY
```

This means only that architecture choice can change research behavior. It does **not** establish:

```text
A0 inadequate;
A1 superior;
A2 coherent globally;
A_null false;
small global decomposition exists;
architecture adequacy;
architecture completeness.
```

## 6. Authorization after P0

P0 authorizes only:

```text
P1 corpus freeze
P2 historical narrowing provenance audit
P3 competing-architecture freeze
P4 blind-test packet preparation
```

It does not authorize an architecture winner, a new Q-track, Lean formalization, or an empirical saturation claim.

The next global kill remains active:

> If P1–P5 fail to show stable out-of-sample discriminative consequences beyond taxonomy, accept `A_null` or `No architecture dominance established` and stop the meta-audit.
