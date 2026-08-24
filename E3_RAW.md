GroupId: G-SHARED-SETTLEMENT
MemberCases: EXO-2, EXO-3, EXO-8
FailureDistinction: Several parties act on one bounded shared object. After a source, key, or local-authority change, it is unsettled whether continued fitness is a single closable published fact or only a bundle of independent local conclusions. Stale replicas and unilateral updates can leave parties on inconsistent bases with no agreed closer.
PriorArtNeighborhood: Delegation and key-rollover publication; signed-object repositories, caches, and expiry; relying-party validation versus local policy; multi-party change notification, hold-down, and dual-publication windows; shared-register governance.
KillTest: If each native regime already either names a unique settlement authority and liveness rule, or expressly makes divergence local and harmless, with no leftover coordination question, the grouping is unnecessary.
ResearchConsequence: Collect write/attest authority, replica and cache behavior, whether local policy is allowed to differ, and what a dependent must see before continuing. Intervention targets coordination, notification, and closing artifacts rather than one party’s private retest.
CounterexampleToGroup: A mere distribution channel (mirror, CDN, package feed) where consumers are expected to apply private policy to the same bits and no joint decision is required.
PredictedAbsorber: Ordinary publisher–subscriber consistency plus each domain’s existing state machine (parent publication, object expiry, contractual amendment).
PredictedResidualIfNotAbsorbed: After native protocol steps, still no participant can emit a closing artifact that others are obliged to treat as settling continued fitness for all.
DecisionBeforeLiteratureReveal: HOLD — strongest local family, but EXO-3 may be local-by-design and then drop. High priority: first decide common-versus-local in each setting before designing coordination.

GroupId: G-RESIDUAL-DEMONSTRATION
MemberCases: EXO-1, EXO-6
FailureDistinction: A prior successful demonstration still has intact artifacts, but the conditions that licensed it (fixed interface/environment, or an in-control procedure) no longer obtain. The cut is which old conclusions may still be used, and what new evidence is required—not whether the artifacts were lost or forged.
PriorArtNeighborhood: Recertification and regression-test selection after environment or configuration change; measurement quality control; out-of-control / out-of-specification investigation; method revalidation; retrospective usability of traceable results.
KillTest: If software environment-change revalidation and measurement loss-of-control handling are complete native procedures whose remaining questions do not match (prospective component reuse versus retrospective result usability), the pair is a false analogy.
ResearchConsequence: Reconstruct the original claim’s scoped conditions, characterize the change, and partition reusable artifacts/results from mandatory new runs. Do not default to full redo, and do not treat intact records as still valid.
CounterexampleToGroup: A planned replacement of the artifact itself, where nobody claims the old demonstration still speaks to the new object.
PredictedAbsorber: Ordinary change-control and revalidation-after-change practice in each domain.
PredictedResidualIfNotAbsorbed: A principled rule for partial residual force of unchanged proof, test, or traceability artifacts when only the licensing conditions moved.
DecisionBeforeLiteratureReveal: HOLD — useful only if residual-force rules are thin; likely partly absorbed. Medium priority.

GroupId: G-POST-FINDING-GROUNDING
MemberCases: EXO-7
FailureDistinction: A later unsafe-condition finding prescribes corrective action. Intact historical compliance records do not keep the item in service. Operative status changes immediately; return requires new closing evidence of the prescribed action, not re-litigation of the old record.
PriorArtNeighborhood: Mandatory safety directives and return-to-service closure; recall / corrective-action verification; in-service unsafe-condition processes.
KillTest: If native directive/recall procedures already specify immediate status, required evidence, and return-to-service closure with no remainder, treating this as a novel or cross-case mechanism is unnecessary.
ResearchConsequence: Separate immediate restriction from historical-record integrity. Collect compliance-with-directive evidence rather than re-auditing past maintenance for its original purpose.
CounterexampleToGroup: A later advisory improvement with no unsafe condition and no prescribed removal from service.
PredictedAbsorber: Ordinary mandatory corrective-action / airworthiness-directive regime.
PredictedResidualIfNotAbsorbed: How the intact prior-acceptance record should be indexed after a superseding unsafe-condition finding, for non-service uses.
DecisionBeforeLiteratureReveal: ROUTE — send first to native safety-directive practice; do not fold into process-drift revalidation. Medium priority.

GroupId: G-GRANULARITY-GAP
MemberCases: EXO-4
FailureDistinction: Adverse evidence exists at a coarse grouping, but the deployed representation lacks a reliable per-instance discriminator, so the justified selective action cannot be implemented. Coarser (blanket or staged) action remains available. The failure is shown-versus-addressable, not absence of any remedy.
PriorArtNeighborhood: Trust-store and distrust mechanisms; revocation and blocklist design; identifier granularity and aliasing; staged operational distrust.
KillTest: If a stable per-instance discriminator already exists in the deployed representation, or if the evidence only ever supported class-level action, the gap disappears.
ResearchConsequence: Separate what the investigation established about which objects from which client-side fields can name those objects. Remediation either adds discriminators or explicitly accepts blanket/staged scope.
CounterexampleToGroup: A complete, reliable enumeration of bad instances already present in the client representation, where selectivity is only a policy choice.
PredictedAbsorber: Ordinary trust-anchor removal, revocation lists, and client-update distrust tooling.
PredictedResidualIfNotAbsorbed: A justified instance-level claim that no stable field already-deployed clients expose can name.
DecisionBeforeLiteratureReveal: ADMIT as a one-off representation-granularity mechanism. Medium-high priority so it is not misread as “all those instances were individually shown bad.”

GroupId: G-OPERATIVE-VS-PRESERVED
MemberCases: EXO-5
FailureDistinction: A decision remains the governing rule for current use, while a parallel record only opens a later review path. Creating that record does not change present operative force.
PriorArtNeighborhood: Appellate preservation and contemporaneous-objection rules; stay versus mere exception; dual-status actions that are effective now and reviewable later.
KillTest: If, in the relevant procedure, the preservation act itself stays, suspends, or modifies present force, the distinction fails.
ResearchConsequence: Treat preservation artifacts only as predicates for later review, not as evidence that current use rules have changed. Changing the operative layer still requires stay, reconsideration, or a new ruling.
CounterexampleToGroup: A filing that is itself a stay or automatic interlocutory halt, where the later-path act does change present force.
PredictedAbsorber: Ordinary preservation / appellate-procedure doctrine.
PredictedResidualIfNotAbsorbed: None expected from the stated facts; residual only if some regimes treat preservation as tacit modification.
DecisionBeforeLiteratureReveal: ROUTE — native procedure likely answers it; keep separate so it is not read as invalidation or shared settlement. Low priority as a cross-case object.

UngroupedCases: none
Overlaps: EXO-2 also has residual-validity of stale published delegation data (adjacent to G-RESIDUAL-DEMONSTRATION) but the distinctive question is who can close the published state. EXO-8 is a residual-fitness question about a shared object, but the blocker is lack of unilateral settlement, so it stays primarily in G-SHARED-SETTLEMENT. EXO-7 shares with G-RESIDUAL-DEMONSTRATION the intact-record versus current-use cut; it is not a member because the trigger is a prescribed unsafe-condition finding, not drift of the conditions that licensed the old demonstration. EXO-4 involves many relying parties, but the stated failure is discriminator granularity, not settlement authority.
GlobalDecompositionVerdict: OVERLAPPING_LOCAL_FAMILIES_PREFERRED