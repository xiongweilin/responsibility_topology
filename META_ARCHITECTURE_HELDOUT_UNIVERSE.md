# Meta-Architecture P4/P5 — Held-Out Source Universe Freeze

Status: **PREREGISTERED / NOT YET ANALYZED**

Change class: meta-research only. No Lean, Python, Paper 1–3 semantics, Strict-L6 boundary, QX/QC object, or research-state promotion.

## 1. Purpose

This file freezes the held-out selection mechanism *before* any P5 case analysis. Cases are admitted by source viability and agency-native metadata, not by whether they resemble QX, QC, R-U1, R-U2, Currentness, Genesis, Revision, or any other candidate architecture.

If this universe later proves unsuitable, P5 is downgraded to an exogenous stress test rather than silently redefining the pool.

## 2. External source universe

Owning source index:

`https://www.gov.uk/government/publications/raib-investigation-reports-safety-digests-and-urgent-safety-advice-2026`

Freeze date: **2026-08-24**.

The source is the UK Rail Accident Investigation Branch (RAIB) 2026 report index. RAIB states that a full investigation report sets out occurrence facts, investigation process and evidence, analysis, conclusions, and recommendations. Safety digests and discontinuation reports are agency-native report classes rather than categories invented for this audit.

Repository contamination precheck at freeze: GitHub code search for `RAIB` in `xiongweilin/responsibility_topology` returned no result. Additional searches for the selected primary/reserve case names also returned no result.

### 2.1 Control-like stratum `U_control`

This stratum uses only 2026 RAIB **safety digests or discontinuation reports** published on the owning index by the freeze date. The reason is source-class metadata: these are the cases RAIB did not publish as full investigation reports. This is only a *control-like prior*, not an outcome label. If the selected case does not admit a strong ordinary/native explanation, it remains the selected case and the control assumption is recorded as failed.

Canonical order is by report class, then official numeric identifier:

```text
0  Discontinuation report 01/2026 — Manchester Piccadilly
1  Safety digest 01/2026 — Helpston
2  Safety digest 02/2026 — Cambridge Junction
3  Safety digest 03/2026 — Hopetown Junction
4  Safety digest 04/2026 — Millbrook
5  Safety digest 05/2026 — Grantham South Junction
```

`n_control = 6`.

### 2.2 Unknown stratum `U_unknown`

This stratum uses every 2026 RAIB **full investigation report** numbered 01/2026 through 10/2026 and published on the owning index by the freeze date.

Canonical order is official report number:

```text
0  Report 01/2026 — Ealing Broadway
1  Report 02/2026 — Ickenham
2  Report 03/2026 — Port Glasgow
3  Report 04/2026 — Denbigh Hall South Junction
4  Report 05/2026 — Pewsey
5  Report 06/2026 — Nordan Farm UWC
6  Report 07/2026 — Bookham Tunnel
7  Report 08/2026 — Talerddig
8  Report 09/2026 — Norwood Junction
9  Report 10/2026 — Staniforth Road
```

`n_unknown = 10`.

No case is included because of architecture relevance.

## 3. Deterministic selector

Frozen seed is the merge commit that completed P0–P3:

```text
ebb8baf539fc600296ce7b71a03aa2bd476c1537
```

For pool `p`, role `r`, and pool size `n`:

```text
h = SHA256(seed || "|" || p || "|" || r)
index = integer(h) mod n
```

The exact hashes are frozen below.

### Control-like case

```text
SHA256(seed|control|primary)
= 386898190b53e437072b92fa62b748577cffeb37c0f53bc7863c12c8c44d62df
index = 1
PRIMARY = Safety digest 01/2026 — Helpston

SHA256(seed|control|reserve)
= dc4b68e7a2f6461275e27071dc8b48a491f52bd5df61df22c71acea4fb81c5d4
index = 0
RESERVE = Discontinuation report 01/2026 — Manchester Piccadilly
```

### Unknown case

```text
SHA256(seed|unknown|primary)
= c0feb1d59603ad55b62151f6566545bf5db16dd1d5dcac61570b2992563a44da
index = 6
PRIMARY = Report 07/2026 — Bookham Tunnel

SHA256(seed|unknown|reserve)
= 02360e67d847ced439b1a0986d52b732f74892dc5eff6ec410b4112a33cba3c3
index = 5
RESERVE = Report 06/2026 — Nordan Farm UWC
```

## 4. Reserve activation rule

A reserve may replace a primary **only** when a preregistered source-viability condition fails, for example:

```text
primary source inaccessible or materially incomplete;
insufficient event timeline to reconstruct actors/evidence/action;
case was demonstrably analyzed in this repository before this freeze;
source identity/report status was recorded incorrectly at freeze.
```

A reserve may **not** be activated because:

```text
the primary is boring;
the primary produces no residual;
the primary favors A_null;
the primary is absorbed by ordinary prior art;
the primary is hard for a preferred architecture;
a different case looks more informative.
```

If both primary and reserve fail source viability, the P5 held-out claim is cancelled. Do not construct a third replacement pool inside this experiment.

## 5. Two-case role discipline

The two selected cases test different failure directions:

```text
H_control  -> false-positive pressure: does an architecture manufacture a deep residual?
H_unknown  -> residual-sensitivity pressure: does an architecture detect a recurring distinction without rewriting native facts?
```

The control-like designation is based on source class only. It does not predetermine absorption.

`A_null` is not a free winner. If both held-out cases repeatedly require the same research routing, prior-art neighborhood, and kill protocol, local-family treatment incurs a redundancy/complexity cost.

## 6. Contamination firewall

Before P5 adjudication:

```text
R-U1 active development: PAUSED
R-U2 active development: PAUSED
```

Allowed: preserve definitions/provenance and receive naturally occurring evidence.

Forbidden until adjudication:

```text
R-U1/R-U2 dedicated literature expansion;
new candidate objects;
new case hunting;
new architecture design;
Lean formalization.
```

## 7. Claim boundary

This freeze establishes only a deterministic held-out selection procedure over one externally indexed source universe.

It does not establish:

```text
representative sampling of reality;
domain independence;
architecture adequacy;
architecture completeness;
statistical independence;
search saturation.
```
