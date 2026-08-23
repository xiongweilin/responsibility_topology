# Paper 3 Running Counterexample — Three-Layer Currentness Failure and Non-Unique Repair

Status: paper-only running example. This document introduces no new formal semantics and does not claim that every illustrative repair alternative is realized by the current reachable transition layer.

Semantic baseline: PR #50 claim firewall on top of `4e9f56f7a8ab6b80f7489cb5f5879495601e7186`.

## Purpose

The paper should use one example, not a sequence of unrelated toys. The example below is designed to carry the reader through the entire Paper 3 argument:

```text
historical dependency remains
-> warrant currentness is suspended
-> license BaseCurrent is lost
-> adopted context loses Groundedness
-> repair obligations are extracted
-> one cut has alternative repairs
-> multiple inclusion-minimal repair sets exist
-> each selected member has a private-cut witness
-> one selected repair set is ordered into a proof-carrying trace
-> final refresh confirms restored currentness
```

The example deliberately separates three questions:

1. what history says happened;
2. what may be used now;
3. what must be repaired before a target currentness judgment can be restored.

---

## 1. Initial reachable situation

Assume a reachable state `S0` with the following canonical history.

There is a warrant `p` and a derived warrant `d`:

```text
p ----historical parent----> d
```

so `d` is a historical descendant of `p`.

There is also an Adopt license `L` whose represented support contains `d`, issued from grounded context `c0` to adopted context `c1`:

```text
c0 --L(support = [d])--> c1
```

The relevant currentness layers all hold before challenge:

```text
Usable(S0, kd)
BaseCurrent(S0, L)
Grounded(S0, c0)
Grounded(S0, c1)
```

where `kd` is the exact evaluation key for `d` at the profile/context/use coordinate used by the license.

The important structural fact is that these are different relations. The historical parent edge `p -> d`, the stored license support relation, warrant usability, license BaseCurrent, and context Groundedness are not one status.

---

## 2. Challenge preserves history but breaks current responsibility

A valid challenge targets `p`.

By the modeled historical affected relation:

```text
Affected(S0, p, p)
Affected(S0, p, d)
```

because the target itself is affected and `d` is a transitive historical descendant.

After the challenge transition `S0 -> S1`:

```text
historical warrant p: still present
historical warrant d: still present
historical parent edge p -> d: still present
license record L: still present
activation provenance c0 --L--> c1: still present
```

but mutable currentness changes.

At the challenged profile/use coordinate, an affected `LIVE` evaluation can become `SUSPENDED`; affected descendant placement can become `PENDING`. Since `L` stores affected support, it is marked `reviewRequired`.

Thus the key distinction is visible in one state transition:

```text
HistoricalDependency(p,d) remains true

while

CurrentResponsibility(S1, kd) may be lost.
```

This is not deletion of the derivation. It is withdrawal of present permission to rely on it.

Formal families used in the manuscript:

- `affected_iff_target_or_descendant`
- `challengeEpi_live_affected`
- `challengePlacement_placed_affected`
- `challengeStep_reviewRequired_exact`
- `challengeStep_historyReferentsImmutable`

---

## 3. First refresh exposes the three-layer cascade

Now apply the fixed-point refresh:

```text
S1 --refresh--> S2
```

The refresh does not repair anything. It retains exactly those contexts that are `Grounded` in the invalidated state-backed activation read.

The failure chain is:

```text
warrant d no longer usable
        |
        v
license L fails BaseCurrent
        |
        v
adopted context c1 is no longer Grounded
        |
        v
c1 is removed from refreshed active currentness
```

This is the running example's first central diagram:

```text
             immutable / historical plane

        p  ---------------------->  d
                                     |
                                     | stored support
                                     v
                                     L
                                     |
                                     | immutable Adopt provenance
                                     v
                                     c1

             mutable / current plane

       Usable(d)  --->  BaseCurrent(L)  --->  Grounded(c1)
           X                 X                    X
        challenge          review +            refresh
        suspension         stale support        removes c1
```

The arrows on the lower row are responsibility dependencies, not claims that the predicates are definitionally identical.

Theorem families:

- `challengeStep_baseCurrent_stricter`
- `refreshActiveContexts_active_iff`
- `refresh_staleActivation_notActive`
- `refresh_activeAdopt_implies_issuerActive`
- `refresh_issuerLoss_cascades`

A second refresh without repair cannot restore `c1`, because refresh is contractive. Once `c1` is no longer in the seed-active set, a dedicated context-reactivation responsibility is required after its dependencies recover.

---

## 4. Extracted repair obligations

At `S2`, represent the stale currentness responsibilities as three obligations:

```text
Ow = warrantUsable(kd)
Ol = licenseBaseCurrent(L)
Oc = contextGrounded(c1)
```

with target:

```text
target = Oc
```

All three are currentness obligations; canonical historical well-formedness is intentionally absent from the repair vocabulary.

The sequential dependency intuition is:

```text
repair warrant currentness
-> clear/re-establish license currentness
-> reactivate context
-> final refresh
```

However, the repair semantics does not force the dependency model to be a simple chain. It admits directed hyperedges so that a responsibility cut can have alternative local discharges.

---

## 5. A genuine hypergraph branch

To expose the difference between impact detection and repair choice, enrich the repair model with one explicitly modeled alternative way to discharge the warrant-level responsibility cut.

Let the candidate repair actions be:

```text
a = revalidateWarrant(kd)
b = revalidateWarrant(kalt)
l = revalidateLicense(L)
c = revalidateContext(c1)
```

`a` is the direct exact-key requalification path used by the current reachable revalidation layer.

`b` denotes a distinct warrant-level repair candidate at another represented key `kalt`. The hypergraph layer alone does not claim that `b` restores `Ow`; that fact must be supplied by a sound `RepairRealization`. This is deliberate: alternatives belong to the extracted responsibility model, while their semantic effectiveness is a separate proof responsibility.

Use three unresolved cuts:

```text
e_w : Ow <- {a, b}
e_l : Ol <- {l}
e_c : Oc <- {c}
```

Graphically:

```text
                 a
                /
Ow  <-----------
                \
                 b

Ol  <----------- l

Oc  <----------- c
```

Multiple edges are conjunctive: every edge must be hit.

Alternatives inside `e_w` are disjunctive: either `a` or `b` may hit that cut, provided the selected alternative has a sound realization.

Therefore two incomparable inclusion-minimal hitting sets are:

```text
X1 = {a, l, c}
X2 = {b, l, c}
```

Neither contains the other.

Neither is called *the* minimal frontier.

No claim is made that they are globally optimal, minimum-cardinality among some larger action universe, or equal in cost.

---

## 6. Why both sets are only conditionally sufficient

The example must not silently turn hitting-set membership into restoration.

For `X1`, suppose we have a sound realization certificate `rho1` showing:

```text
selected a restores Ow
selected l restores Ol
selected c restores Oc
restoring all declared stale dependencies closes target Oc
```

Then:

```text
RepairSet(problem, X1)
+
RepairRealization(problem, X1, S3a)

=> TargetHolds(Refresh(S3a)).
```

For `X2`, sufficiency is a separate claim requiring a separate certificate `rho2`:

```text
RepairSet(problem, X2)
+
RepairRealization(problem, X2, S3b)

=> TargetHolds(Refresh(S3b)).
```

The paper must not imply that the current executable transition layer automatically supplies `rho2`. The formal repair combinatorics permits alternative cuts; semantic effectiveness is carried by `RepairRealization`; reachable execution in PR #48 is narrower again.

This separation is pedagogically useful because it prevents three layers from collapsing:

```text
candidate alternative
!= sound semantic realization
!= reachable execution trace
```

---

## 7. Inclusion-minimality and private-cut witnesses

For `X1 = {a,l,c}`:

- removing `a` misses `e_w`;
- removing `l` misses `e_l`;
- removing `c` misses `e_c`.

Thus each selected member has a private cut:

```text
a owns e_w relative to X1
l owns e_l relative to X1
c owns e_c relative to X1
```

For `X2 = {b,l,c}` the same structure holds, with `b` owning `e_w`.

This illustrates the theorem:

```text
MinimalRepairSet(X)
and x in X
=> exists private edge e for x.
```

The witness is local and combinatorial. It says why the selected member is non-removable in that repair set. It does not prove that the member is uniquely necessary across all possible repair sets.

Indeed the branch itself demonstrates the opposite:

```text
a is necessary inside X1
but not selected in X2.

b is necessary inside X2
but not selected in X1.
```

This is exactly why the paper should say **local necessity witness**, not **globally necessary repair action**.

---

## 8. Universal necessity needs the adequacy premise

Suppose a reviewer asks:

> If some action set `Y` really restores `c1`, must it hit `e_w`, `e_l`, and `e_c`?

The answer is not unconditional.

The paper may conclude:

```text
Restore(Y) -> Y hits every represented cut
```

only after assuming:

```text
EveryRepairCutNecessary(problem, Restore).
```

That premise asserts that each extracted edge is genuinely necessary for the chosen restoration predicate.

Without it, the hypergraph might contain a modeling mistake: an edge could have been extracted even though real restoration can bypass it.

This running example should therefore place the adequacy boundary directly next to the first discussion of necessity:

> **Hypergraph minimality is exact relative to the extracted obligation model; adequacy of that extraction is a separate epistemic/modeling responsibility.**

This is not a weakness to hide. It is the formal location of the question the model does not decide for itself.

---

## 9. One reachable repair trace

The current reachable lifecycle gives a narrow, proof-carrying execution path for the direct branch `X1`.

The intended order is:

```text
S2
  -- revalidateWarrant(kd) --> S2a
  -- revalidateLicense(L)  --> S2b
  -- revalidateContext(c1) --> S3
  -- final refresh          --> S4
```

Why this order matters:

1. warrant repair must reuse an already trusted ROOT/INFER/TRANSPORT qualification step at the exact evaluation key;
2. license repair may clear review only after all other represented `BaseCurrent` premises are restored, including support usability;
3. context repair requires immutable Adopt provenance, recovered BaseCurrent, and a grounded issuer;
4. final refresh confirms grounded currentness.

Thus:

```text
RepairSet / MinimalRepairSet
```

remain unordered mathematical predicates, while:

```text
RevalidationTrace : List RepairAction
```

carries dependency-sensitive execution order.

The reachable theorem then supports:

```text
RevalidationReachable(S0)
+
challenge
+
first refresh
+
ordered repair trace
+
RepairSet
+
RepairRealization
+
final refresh

=> RevalidationReachable(S4)
   and TargetHolds(S4).
```

The lifecycle theorem is the bridge back to executable/reachable state. It is not the theorem that establishes hypergraph minimality.

---

## 10. History after restoration

Nothing in the running example requires rewriting the old derivation:

```text
p -> d
```

or replacing the old Adopt provenance:

```text
c0 --L--> c1.
```

The modeled challenge preserves historical referents; refresh changes active currentness only; each repair action preserves historical referents.

The manuscript may therefore say:

> the repair lifecycle restores current responsibility without requiring canonical history to be rewritten.

It should cite stage-local preservation theorems compositionally.

It should **not** claim that the final lifecycle theorem already contains an explicit end-to-end

```text
HistoryReferentsImmutable(S0.core, S4.core)
```

conjunct.

---

## 11. What this one example establishes pedagogically

The same counterexample exposes all major distinctions:

| Question | Example answer |
|---|---|
| Did the historical derivation disappear? | No. `p -> d` remains canonical history. |
| Is `d` still usable after challenge? | Not necessarily; affected `LIVE` currentness can be suspended. |
| Can the old Adopt license still be current? | Not if its represented support/review premises fail. |
| Can the adopted context remain grounded? | Not when its activation responsibility becomes stale. |
| Does refresh repair the context? | No. Refresh is contractive. |
| Is repair a single Boolean operation? | No. Warrant, license, and context responsibilities remain separate. |
| Is there necessarily one repair frontier? | No. A hyperedge may have alternatives, giving incomparable inclusion-minimal sets. |
| Does a hitting set automatically restore the target? | No. A sound `RepairRealization` is required. |
| Is every represented cut universally necessary? | Only under `EveryRepairCutNecessary`. |
| Does execution order matter? | Yes. `RevalidationTrace` is ordered even though `RepairSet` is not. |
| Must history be rewritten during repair? | No; preservation is supported stage-locally. |

---

## 12. Figure-ready compressed version

A paper figure can compress the full example to:

```text
HISTORY (preserved)

p ----> d ----support----> L ----adopt----> c1

CURRENTNESS BEFORE

Usable(d) ----> BaseCurrent(L) ----> Grounded(c1)
     yes               yes                 yes

CHALLENGE + REFRESH

Usable(d) ----> BaseCurrent(L) ----> Grounded(c1)
      no                no                  no

REPAIR CUTS

Ow <- {a,b}
Ol <- {l}
Oc <- {c}

minimal repair sets:
X1={a,l,c}       X2={b,l,c}

reachable direct branch:
a -> l -> c -> refresh
```

Caption firewall:

> A challenge preserves canonical history while invalidating current responsibility. The extracted repair problem may admit multiple inclusion-minimal hitting sets; sufficiency of a selected set requires a sound repair realization. The current reachable lifecycle realizes a proof-carrying ordered branch and does not imply that every abstract alternative has an executable trace.

---

## 13. Formal-trigger check

This running example does **not** trigger a new formal milestone.

The non-unique hypergraph branch is illustrative relative to the already defined `RepairProblem` / `MinimalRepairSet` semantics. The paper does not claim a theorem that the current concrete challenge instance necessarily generates two executable minimal repair traces.

If the manuscript later insists on the stronger sentence:

> "There exist two distinct reachable inclusion-minimal repair traces for one concrete challenged state in the current kernel,"

that sentence is **not** supported by the present theorem surface and would constitute a formal trigger only if it remains indispensable after attempted weakening or deletion.

The current paper does not need that stronger claim.
