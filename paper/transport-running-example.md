# Paper 2 Running Example and Figure/Table Architecture

Status: paper-only architecture frozen against `paper/transport-theorem-map.md`.

This note defines one minimal three-context running example and assigns each paper result to a visual surface. It introduces no new theorem claim.

## Running example

Use one same-profile chain:

```text
c_A --chi_1 / m_1--> c_B --chi_2 / m_2--> c_C
```

with historical identities:

```text
O    original historical warrant formed in c_A
X_1  BRIDGE witness for map m_1 and target c_B
W_1  transported historical child formed in c_B
X_2  BRIDGE witness for map m_2 and target c_C
W_2  transported historical child formed in c_C
```

The first transport is:

```text
O + X_1 --TRANSPORT(m_1)--> W_1@c_B
```

and the second is:

```text
W_1 + X_2 --TRANSPORT(m_2)--> W_2@c_C
```

All five historical objects are within one profile snapshot. The example must never suggest cross-profile interoperability.

For current qualification, retain three distinct context coordinates rather than collapsing them:

```text
current(O)   is read at O.formationContext
current(X_1) is read at X_1.formationContext
current(W_1) is written/read at c_B when W_1 is explicitly qualified
```

The first-hop qualification picture is sufficient to explain P2-R2. The two-hop formation picture is then used separately for P2-R4. Do not add qualification of W_1 or W_2 to the two-hop composition figure; qualification-chain propagation remains frozen.

## Four relations the reader must distinguish

Every visual should preserve these as different graphical encodings:

1. **Origin history** — immutable historical ancestry of O and, after transport, W_1/W_2.
2. **BRIDGE evidence** — translation witness responsibility contributed by X_1/X_2.
3. **Target history** — new child identity formed at c_B or c_C.
4. **Source-context currentness** — time-indexed usability lookup at each stored parent object's own formation context.

The paper should never use a single undifferentiated arrow for all four relations.

---

## Figure 1 — Single-Hop Responsibility Decomposition

Purpose: explain P2-R1, P2-R2, and the single-hop part of P2-R3 before any composition theorem appears.

Recommended geometry:

```text
Historical layer

c_A                         c_B

  O -----------------------> W_1
   \                         ^
    \                       /
     X_1 -- BRIDGE --------/

Current-responsibility layer at qualification pre-state

  Usable(O @ O.formationContext)
  Usable(X_1 @ X_1.formationContext)
              |
              | explicit qualifyTransport
              v
  Usable(W_1 @ c_B) in post-state
```

The horizontal O-to-W_1 relation is historical transport parentage, not current usability. The X_1-to-W_1 relation must be visually marked `BRIDGE`, not shown as ordinary content ancestry.

Figure caption should state:

> TRANSPORT forms a new target-context historical identity from an original and BRIDGE witness. Later qualification reads each stored parent at its own formation-context currentness coordinate and writes the child at the target-context key.

Required callouts:

- `same profile snapshot`;
- `parents = [O, X_1]`;
- `role(W_1) = role(O)`;
- `target activation not required`;
- `formation != qualification`;
- `usability != entitlement`.

Avoid:

- arrows labeled `valid` or `authorized`;
- any indication that c_B must be active/adopted;
- any statement that X_1 proves truth/equivalence;
- cross-profile labels.

Result mapping:

```text
P2-R1 -> historical formation portion
P2-R2 -> current-responsibility portion
P2-R3 -> BRIDGE-isolated ancestry portion
```

---

## Table 1 — TRANSPORT Responsibility Cut

Purpose: make the formation/qualification boundary explicit without restating implementation detail.

Recommended columns:

| Boundary | Reads / checks now | Establishes | Carries forward without re-check | Explicitly not established |
|---|---|---|---|---|
| TRANSPORT formation | canonical binding; target context; original/witness history; same-profile membership; BRIDGE role; exact semantic witness binding; target claim acceptance; scope narrowing; strength non-amplification | exact target historical child; exact `[original,witness]`; original role; transport lineage transform | historical formation facts in immutable child history | child usability; target activation/adoption; entitlement |
| TRANSPORT qualification | historical child identity; exact stored parents; parent-specific current usability at each formation context | exact child `LIVE/PLACED` target key | formation discipline remains historical and is not replayed | truth/adequacy; entitlement; chain propagation |

The phrase `carries forward without re-check` must be explained as: the later transition does not repeat the premise; it does not mean the formation fact is irrelevant or invalid.

Result mapping:

```text
P2-R1 -> formation row
P2-R2 -> qualification row
P2-R3 -> lineage item in formation row
```

---

## Figure 2 — Two-Hop Historical Conservation

Purpose: isolate P2-R4 from qualification and show that compositionality is a historical conservation property.

Recommended geometry:

```text
c_A                  c_B                  c_C

 O ---- T_1 ---->    W_1 ---- T_2 ---->   W_2
  \                   ^ \                  ^
   X_1 --BRIDGE------/   X_2 --BRIDGE------/
```

The second TRANSPORT event must explicitly identify `W_1` as its `originalId`. This is the composition joint proved by `twoHopTransportFormationBoundary`.

Under the chain, show three separate conservation bands:

```text
Scope:
  Scope(W_2) <= Scope(W_1) <= Scope(O)
  therefore Scope(W_2) <= Scope(O)

Canonical escalation depth, when interpretable:
  Depth(W_2) <= Depth(W_1) <= Depth(O)
  therefore Depth(W_2) <= Depth(O)

Lineage:
  r != BRIDGE: Lineage_W2(r) = Lineage_O(r)
  BRIDGE: original BRIDGE ancestry + all ancestry(X_1) + all ancestry(X_2)
```

Root lineage and source lineage should be described in the caption/text as two instances of the same responsibility pattern; Figure 2 need not duplicate them visually.

Figure caption should state:

> Two adjacent historical TRANSPORT formations compose through the exact intermediate child identity. Scope and canonical-interpretable escalation strength do not amplify, non-BRIDGE ancestry remains exact, and translation-witness ancestry accumulates only under BRIDGE responsibility.

Explicit exclusion box:

```text
Not shown / not proved here:
- qualification of W_1 or W_2
- currentness propagation
- n-hop induction
- target activation/adoption
```

---

## Table 2 — One-Hop vs Two-Hop Result Surface

Purpose: prevent readers from inferring that all one-hop lifecycle results were lifted to a two-hop currentness theorem.

| Property | One hop | Two hops | Paper status |
|---|---|---|---|
| exact target historical child | proved | proved for both W_1 and W_2 | P2-R1 / P2-R4 |
| source-context parent usability at qualification | proved | not propagated across chain | P2-R2 only |
| non-BRIDGE lineage exactness | proved | proved | P2-R3 / P2-R4 |
| BRIDGE evidence isolation/accumulation | proved | proved exactly for two witnesses | P2-R3 / P2-R4 |
| scope non-amplification | proved | proved compositionally | P2-R1 / P2-R4 |
| canonical-interpretable strength non-amplification | proved | proved compositionally | P2-R1 / P2-R4 |
| child current usability after explicit qualification | proved | no chain theorem | P2-R2 only |
| arbitrary n-hop closure | not claimed | not claimed | frozen |

---

## Narrative order around the visuals

Recommended manuscript sequence:

1. Introduce O, X_1, c_A, c_B and Figure 1.
2. State P2-R1 immediately after the historical half of Figure 1.
3. Introduce source-context qualification and state P2-R2 using the lower/currentness half of Figure 1.
4. Isolate the lineage rule and state P2-R3; use Table 1 to show that lineage belongs to formation responsibility.
5. Extend the running example with X_2 and c_C only after the single-hop boundary is stable.
6. Present Figure 2 and P2-R4.
7. Use Table 2 to state exactly what does not compose in the current paper.

This order prevents P2-R4 from being read as a current qualification-chain theorem.

## Visual notation freeze

Use these visual conventions consistently in the final manuscript:

```text
solid historical arrow       = historical formation/parent relation
BRIDGE-labeled witness edge  = translation-evidence responsibility
dashed/currentness marker    = time-indexed Usable lookup/write
context boxes c_A,c_B,c_C    = formation/evaluation coordinates, not activation state
```

Do not encode activation state by box color or fill because activation is outside Paper 2.

Do not use `proof`, `certificate of truth`, `authorization`, `adoption`, or `equivalence` as labels for the bridge edge.

## Claim-surface check

Figure 1 + Table 1 must be fully supportable by P2-R1–P2-R3.

Figure 2 + Table 2 must be fully supportable by P2-R4 plus the two-hop lineage facts grouped under P2-R3.

If a proposed visual requires a fifth headline theorem family, a qualification-chain claim, n-hop closure, cross-profile semantics, or activation/adoption semantics, the visual must be narrowed rather than the kernel expanded.
