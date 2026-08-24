GroupId: G1_CONTEXTUAL_VALIDITY_DRIFT
MemberCases: EXO-1, EXO-6, EXO-7
FailureDistinction: A historical validation, traceability record, or maintenance record can remain factually intact while its warrant for present or future use weakens because relevant conditions have changed. The recurring distinction is historical evidentiary integrity versus current applicability or authorization.
PriorArtNeighborhood: Change-impact analysis; regression and revalidation theory; configuration management; measurement assurance and process-control theory; safety and maintenance qualification; validity-scope and assurance-case reasoning.
KillTest: Kill this grouping if ordinary domain-specific change-control rules already determine, from the changed condition alone, exactly which prior conclusions remain usable, which must be suspended, and which checks must be repeated, with no unresolved distinction between preservation of the old record and continued applicability.
ResearchConsequence: Record the dependencies between each prior conclusion and environmental/process/component conditions; distinguish retrospective use of old evidence from prospective authorization; classify changes by materiality rather than merely by chronology; and test whether targeted revalidation can replace wholesale repetition. For EXO-6 and EXO-7, explicitly identify the backward-looking affected interval or population.
CounterexampleToGroup: A test conclusion is withdrawn because the original test data were discovered to be fabricated or incorrectly computed. That is corruption of the original evidence, not loss of applicability caused by later drift.
PredictedAbsorber: Ordinary change-impact analysis combined with native qualification, calibration/nonconformance, or maintenance-safety rules.
PredictedResidualIfNotAbsorbed: The unresolved fact should be the scope boundary: why unchanged historical evidence remains valid for some propositions or uses while ceasing to warrant other current uses, and exactly which dependency on the changed condition creates that split.
DecisionBeforeLiteratureReveal: ADMIT — high priority. The distinction directly changes whether evidence is retained, scoped, quarantined, or regenerated and is present independently in three cases.

GroupId: G2_SHARED_BASIS_COORDINATION
MemberCases: EXO-2, EXO-8
FailureDistinction: A material change affecting a shared decision basis cannot necessarily be settled by each participant independently when publication, authority, or fitness of that basis spans organizational boundaries. Local evidence and local action must be distinguished from an authoritative or coordinated transition of the shared state.
PriorArtNeighborhood: Distributed consistency and coordination; replicated-state and configuration-management theory; delegation and trust-chain lifecycle management; multi-party change control; interorganizational governance; protocol authority and ownership models.
KillTest: Kill this grouping if the governing protocol or arrangement reduces the situation to one unambiguous authoritative writer whose state transition deterministically settles the matter and all other parties are merely ordinary consumers that need only refresh.
ResearchConsequence: Build an authority-and-dependency graph rather than merely inspecting data values. Collect who can publish, revoke, acknowledge, verify, and declare readiness; observe version skew and stale-state windows; distinguish local readiness from shared-basis readiness; and test partial-transition failures in which only some parties have incorporated the change.
CounterexampleToGroup: One organization owns a configuration object, updates it atomically, and all dependent systems are required only to fetch the latest version. No other participant has relevant settlement authority or evidence that can block the transition.
PredictedAbsorber: Ordinary distributed configuration management plus explicit protocol-level ownership, consistency, and delegation rules.
PredictedResidualIfNotAbsorbed: The remaining unexplained fact should be who, or what combination of evidence and acknowledgments, can legitimately establish fitness for continued shared use when a locally observed material change has consequences outside the observer's unilateral authority.
DecisionBeforeLiteratureReveal: ADMIT — high priority. Authority topology and coordination requirements change both the evidence to collect and the intervention, and EXO-8 makes the absence of unilateral settlement explicit.

GroupId: G3_SHARED_SOURCE_LOCAL_DECISION_DIVERGENCE
MemberCases: EXO-3
FailureDistinction: Sharing an authenticated source does not imply sharing one decision state when each consumer independently validates, caches, and applies policy. A common upstream change must therefore be separated from multiple downstream decision revisions.
PriorArtNeighborhood: Relying-party architecture; distributed caching and freshness; policy decision points; local trust evaluation; replicated-input/local-computation systems; eventual-consistency effects.
KillTest: Kill this grouping if the native architecture requires all conforming relying parties presented with the same source state to produce one binding common decision, and any observed divergence can only be an implementation defect.
ResearchConsequence: Collect evidence separately for source state, fetch time, cache contents, validation result, expiry handling, and local policy action for each relying party. Do not treat the ecosystem as having revised one global decision unless an actual shared decision mechanism exists.
CounterexampleToGroup: A centralized validation service issues a single authoritative verdict that all downstream routers must apply without independent validation or policy choice.
PredictedAbsorber: Ordinary relying-party semantics together with caching/freshness rules and locally configured routing policy.
PredictedResidualIfNotAbsorbed: A residual would be evidence that apparently local divergences are actually constrained by some shared state transition or coordination obligation that cannot be represented as independent consumer computations.
DecisionBeforeLiteratureReveal: ROUTE — high priority to the native relying-party architecture, because this may be completely explained by an ordinary separation of shared inputs from local validation and policy rather than requiring a broader family.

GroupId: G4_SELECTIVE_REMEDIATION_REPRESENTATION_GAP
MemberCases: EXO-4
FailureDistinction: Evidence can justify distinguishing a problematic subset more finely than the deployed enforcement representation can identify that subset. What has been epistemically distinguished is therefore not necessarily what can be operationally selected for remediation.
PriorArtNeighborhood: Security-policy enforcement; PKI distrust mechanisms; trust-store constraints; policy expressiveness; classification and feature identifiability; safe deployment and staged remediation; false-positive/false-negative tradeoffs.
KillTest: Kill this grouping if an already-deployed, stable discriminator identifies the evidence-supported certificate subset with operationally acceptable error, or if the evidence itself supports only provider-wide treatment so that no finer distinction is actually justified.
ResearchConsequence: Evaluate candidate discriminators independently of the underlying evidence against the provider; measure false inclusion and false exclusion; determine which selectors exist in deployed clients rather than only in idealized models; and compare blanket, staged, and selective interventions under the available representation.
CounterexampleToGroup: Every affected certificate carries an existing, reliably parsed identifier that uniquely selects exactly the population implicated by the evidence. Selective remediation is then an ordinary policy update.
PredictedAbsorber: Native certificate-policy and trust-store constraint mechanisms, including ordinary staged distrust procedures.
PredictedResidualIfNotAbsorbed: The material residual should be a demonstrable gap between the subset for which differential treatment is justified and the subset that any deployable predicate can actually select without unacceptable collateral effects.
DecisionBeforeLiteratureReveal: ADMIT — high priority. This is a distinct evidence-to-action bottleneck; treating it merely as "distrust" would obscure the missing operational discriminator.

GroupId: G5_PRESERVATION_WITHOUT_OPERATIVE_CHANGE
MemberCases: EXO-5
FailureDistinction: An act can preserve the ability to challenge a decision later without altering the present operative force of that decision. Future reviewability and current governing status are separate state variables.
PriorArtNeighborhood: Evidentiary preservation; appellate procedure; preservation of error; definitive evidentiary rulings; stays; reconsideration; interlocutory review; finality and reviewability doctrines.
KillTest: Kill this grouping if the applicable procedural rule makes the preservation act itself suspend, modify, or supersede the ruling, or if the court has separately entered an order that changes the ruling's current effect.
ResearchConsequence: Encode procedural events on at least two axes: current operative status and preservation/review status. Collect evidence showing that the objection was adequately preserved separately from evidence of any stay, reconsideration, modification, or superseding ruling.
CounterexampleToGroup: The court grants reconsideration and changes its evidentiary ruling, or an authorized stay suspends the ruling's effect. Those events alter operative status rather than merely preserving a later challenge.
PredictedAbsorber: Ordinary preservation-of-error and appellate-procedure doctrine.
PredictedResidualIfNotAbsorbed: The expected residual is small: it would have to be a procedural state that native doctrine cannot represent as "present ruling remains controlling while later review remains available."
DecisionBeforeLiteratureReveal: ROUTE — high priority for native doctrinal checking, but low priority as a proposed deeper cross-domain family because ordinary procedural doctrine is a strong predicted absorber.

GroupId: G6_REMEDIATION_CLOSURE_AND_RETURN_TO_USE
MemberCases: EXO-6, EXO-7
FailureDistinction: Detecting an adverse condition, preserving the preexisting record, performing corrective work, and establishing fitness for renewed use are distinct steps. Corrective action is not necessarily equivalent to evidentiary closure or release.
PriorArtNeighborhood: Corrective and preventive action; nonconformance control; calibration and measurement-system recovery; process-control restoration; maintenance release; return-to-service criteria; safety assurance and recertification.
KillTest: Kill this grouping if the ordinary governing procedure already specifies a complete deterministic chain from detected condition through affected-scope determination, corrective action, verification, and release, leaving no uncertainty about old results or the evidence required for resumed use.
ResearchConsequence: Collect detection time, suspected affected interval/population, causal diagnosis, corrective-action records, verification results, recurrence checks, and explicit release criteria as separate evidence. Test whether restoration of the underlying condition is sufficient or whether independent verification is required before use resumes.
CounterexampleToGroup: A purely administrative authorization expires on a fixed date even though no adverse condition or loss of control has occurred, and renewal requires only a predetermined clerical step.
PredictedAbsorber: Ordinary nonconformance/CAPA procedures and native return-to-service or restoration-of-control rules.
PredictedResidualIfNotAbsorbed: Two scope questions should remain: how far backward the detected condition contaminates prior outputs or prior periods of operation, and what incremental evidence—beyond completion of corrective work—is sufficient to establish regained control or safety.
DecisionBeforeLiteratureReveal: ADMIT — high priority. EXO-6 and EXO-7 both require evidence about affected scope and closure, not merely recognition that a previous record remains intact.

UngroupedCases: None. This does not imply that all cases participate in a common taxonomy: EXO-3, EXO-4, and EXO-5 are retained as mechanism-specific singleton groups because merging them would change or dilute the appropriate evidence and prior-art search.

Overlaps: EXO-6 and EXO-7 belong to both G1 and G6. G1 concerns whether prior evidence continues to warrant use after a changed condition; G6 concerns what remediation and closure evidence permits resumed use. Those are separable research questions. EXO-2 is boundary-adjacent to G3 because downstream validators may also have local state, but I would not place it in G3 initially: its parent/child publication and settlement problem makes authority and coordinated transition central in a way that EXO-3 does not establish. EXO-5 has an abstract resemblance to G1—an old record remains intact while operative consequences differ—but combining them would not direct researchers to the same evidence or neighboring literature.

GlobalDecompositionVerdict: OVERLAPPING_LOCAL_FAMILIES_PREFERRED. The cases support at least two recurring local mechanisms, G1 and G2, plus the narrower G6 overlap, but the remaining cases are better treated through native mechanism-specific explanations until literature review shows a stronger common structure. A small mutually exclusive global decomposition would currently erase distinctions that materially change evidence collection, falsification tests, and intervention.
