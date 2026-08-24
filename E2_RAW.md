# Analysis

## GroupId: G1 — Conditional Revalidation Under Context Drift
**MemberCases:** EXO-1, EXO-6, EXO-7

**FailureDistinction:** The recurring distinction is between *"the evaluated object/artifact itself changed"* and *"the context/basis of applicability changed while the object stayed fixed."* Each case requires separating (a) what evidentiary trigger obligates new evaluation work, (b) what scope of prior findings remains valid, and (c) what is sufficient to restore full reliance.

**PriorArtNeighborhood:** Software V&V/regression testing and configuration-management change control (EXO-1); metrology QA / ISO 17025-style measurement assurance and control-chart drift detection (EXO-6); aviation continued-airworthiness and Airworthiness Directive compliance / MRO recordkeeping (EXO-7).

**KillTest:** If each domain's existing change-control, CAPA, or AD-compliance procedure already fully and unambiguously specifies the trigger-and-scope rule, the cross-domain grouping is superficial wording similarity only, and the cases reduce to three independent, already-solved domain procedures.

**ResearchConsequence:** If retained, extract the shared formal structure (trigger detection → scope-of-validity partition → sufficiency-of-new-evidence criteria) and test whether a domain-neutral "conditional revalidation" checklist predicts real trigger thresholds better than siloed domain guidance.

**CounterexampleToGroup:** A case where the *original* evaluation is later found to have been wrong at the time it was made (fraud, calculation error, undisclosed nonconformance) rather than context changing afterward — this is a correctness-of-origin problem, not a drift/context problem, and should be excluded.

**PredictedAbsorber:** Ordinary domain-specific change-control / CAPA / AD procedures already fully answer trigger-and-scope questions; standard configuration-management theory.

**PredictedResidualIfNotAbsorbed:** A portable, non-domain-specific account of how "partial validity" (which old results remain usable, for which purposes) is scoped and evidenced consistently — something no single domain's certification law addresses generically.

**DecisionBeforeLiteratureReveal:** HOLD — plausible shared structure, but must first check whether each domain's existing standard already fully resolves the question; medium priority.

---

## GroupId: G2 — Shared-Basis Multi-Party Fitness-for-Use
**MemberCases:** EXO-2, EXO-3, EXO-8

**FailureDistinction:** Distinguishing whether a change to a shared, multiply-consumed data object requires one authoritative global re-settlement versus independent local validation/policy responses by each consumer — given that no single participant can unilaterally declare the shared basis fit for everyone's continued use.

**PriorArtNeighborhood:** DNS operations / DNSSEC key-rollover operational guidance; RPKI relying-party software and BGP origin-validation practice; distributed-systems literature on eventual consistency, federated trust, and delegated authority/consensus.

**KillTest:** If each protocol (DNSSEC, RPKI) already has a well-defined authoritative settlement mechanism (cryptographic proof chain plus deterministic TTL/expiry/caching semantics) that fully determines correct behavior, then "no one can unilaterally settle" is just normal protocol-conformance/caching semantics, and EXO-8 is a trivial restatement rather than a genuine abstraction.

**ResearchConsequence:** If retained, run a comparative study of staleness-window handling and local-override rules across DNSSEC and RPKI to derive general tolerable-inconsistency rules for federated shared-basis systems, and test whether EXO-8's abstraction adds predictive content beyond the two concrete protocols.

**CounterexampleToGroup:** A shared object with one centralized authority that can and does unilaterally invalidate it globally with immediate effect (e.g., a single-source revoked license key) — no genuine multi-authority coordination problem exists there.

**PredictedAbsorber:** Standard protocol specification semantics (DNSSEC RFC rollover procedures, RPKI RFC relying-party validation rules) already define correctness without new theory.

**PredictedResidualIfNotAbsorbed:** The cross-protocol question of how much local autonomy vs. mandatory synchronized action is appropriate when "fitness for use" is judgment-dependent rather than purely cryptographically checkable.

**DecisionBeforeLiteratureReveal:** ROUTE — to DNS-operations and RPKI operational RFC literature first; likely largely absorbed, but priority is medium-high given three convergent cases including one explicitly abstracted (EXO-8).

---

## GroupId: G3 — Representational Granularity Gap (one-off)
**MemberCases:** EXO-4

**FailureDistinction:** Distinguishing "sufficient evidence exists to justify a differentiated response" from "the deployed representation/data model has the resolution needed to execute that differentiated response" — an evidence-vs-actionability gap, not a revalidation or coordination-authority gap.

**PriorArtNeighborhood:** Web PKI / CA-Browser Forum policy, browser root-store distrust incident history (mass and staged distrust events), certificate transparency and X.509 data-model design.

**KillTest:** If browser distrust mechanisms already possess (or can trivially acquire) per-certificate/per-issuance discriminators (via CT-log linkage, intermediate-level distrust, precertificate binding), this is a solved engineering problem, not a distinct research case.

**ResearchConsequence:** If a genuine gap exists, catalog what discriminators are structurally possible/impossible under the current X.509/CT model to determine whether the limitation is fundamental or merely an implementation lag.

**CounterexampleToGroup:** A vendor with full technical granularity available who nonetheless chooses blanket distrust for policy/political reasons — a policy choice, not a representational limitation.

**PredictedAbsorber:** Existing Web PKI incident-response playbooks (historical staged/blanket distrust responses) likely already cover this without new theory.

**PredictedResidualIfNotAbsorbed:** The specific structural reason the data model cannot currently bind "provider" identity to individual certificates beyond the issuer field would remain an open standards gap.

**DecisionBeforeLiteratureReveal:** ADMIT as distinct; ROUTE to Web PKI incident-history record; lower priority — likely mirrors a known past event.

---

## GroupId: G4 — Operative-Status vs. Preserved-Path Bifurcation (one-off)
**MemberCases:** EXO-5

**FailureDistinction:** Distinguishing an act that preserves a future procedural opportunity from an act that alters the present operative effect of a decision — a temporal bifurcation of legal/administrative effect, not a revalidation-trigger or coordination-authority question.

**PriorArtNeighborhood:** Civil/criminal procedure doctrine on preservation of error, evidentiary and interlocutory ruling standards, appellate review scope.

**KillTest:** If procedural doctrine already unambiguously holds that preservation never alters trial-court operative effect (near-universal expectation), this is fully settled and contributes no residual research content.

**ResearchConsequence:** If ambiguity exists in some jurisdiction (e.g., preservation triggering an automatic stay/reconsideration), a narrow comparative doctrinal survey would be warranted; otherwise none.

**CounterexampleToGroup:** A motion for reconsideration or interlocutory appeal that actually stays enforcement — that does change operative status and does not belong here.

**PredictedAbsorber:** Standard procedural doctrine on preservation of error fully explains this with no residual mystery.

**PredictedResidualIfNotAbsorbed:** Any jurisdiction-specific quirk where preservation mechanics unexpectedly affect trial-level enforceability.

**DecisionBeforeLiteratureReveal:** KILL — almost certainly fully absorbed by settled procedural doctrine; low priority.

---

## UngroupedCases
None outright unassigned — EXO-4 and EXO-5 are retained as deliberate one-off (singleton) groups rather than forced into G1/G2, since their failure distinctions (representational granularity; temporal operative/preserved bifurcation) are structurally different from both larger clusters.

## Overlaps
- EXO-3 and EXO-8 substantially overlap (EXO-8 reads as the abstracted generalization of EXO-2/EXO-3); kept together in G2 rather than split.
- EXO-4 has partial surface overlap with G2 (many downstream consumers relying on shared CA/trust infrastructure) but is excluded from G2 because its core failure is representational granularity, not coordination authority — flagged as a soft overlap, not shared membership.
- EXO-1 has partial conceptual overlap with G2's "shared basis" framing (a single-party version of "does context change invalidate prior conclusion") but lacks the multi-party unilateral-settlement problem, so it stays in G1 only.
- EXO-6 and EXO-7 could be read as an even tighter sub-pair (both regulatory-record/return-to-service framing) inside G1; noted but not split out, since KillTest/ResearchConsequence are currently identical across all three G1 members.

## GlobalDecompositionVerdict
OVERLAPPING_LOCAL_FAMILIES_PREFERRED