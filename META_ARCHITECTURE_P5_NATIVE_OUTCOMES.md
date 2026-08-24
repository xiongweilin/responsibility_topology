# Meta-Architecture P5-C — Native Held-Out Outcomes

Status: **MATERIAL FACTS + STRONGEST ORDINARY EXPLANATIONS FROZEN / ARCHITECTURE ADJUDICATION NOT YET APPLIED**

This document reconstructs the two locked RAIB primary cases in railway-native terms. It does not score A0/A1/A2/A_null/A_D.

## H_control — Helpston

### Primary sources

- RAIB Safety digest 01/2026: Helpston, published 9 March 2026.
- Detailed HTML: `https://www.gov.uk/government/publications/safety-digest-012026-helpston/near-miss-at-helpston-manually-controlled-barrier-level-crossing-21-october-2025`
- RAIB management-assurance summary: `https://www.gov.uk/government/publications/summary-of-learning-10-management-assurance-v1-may-2024/summary-of-learning-10-management-assurance-v1-may-2024`

### Actors

```text
Helpston signaller
local operations manager (LOM)
Network Rail infrastructure/operations management
maintenance staff responsible for seal replacement
train drivers and road users exposed to the crossing state
```

### Event timeline

- The signaller lowered the crossing for three approaching trains.
- After two passenger trains passed, the controls were placed in manual mode while a freight train was still approaching on the Stamford line.
- The signaller attempted to raise the barriers, was prevented by the interlocking, and inferred an equipment fault after forgetting the approaching freight train.
- The signaller used the sealed release, bypassing the engineered safeguard; the barriers rose while the freight train was approaching/passing.
- The signaller saw the freight train and immediately commanded the barriers to lower.
- A road vehicle had begun to move toward the crossing; no collision, injury, or damage occurred.

### Evidence

RAIB's account uses signalling data, witness evidence, the physical condition and history of the sealed release, training/Rule Book evidence, and management-assurance evidence.

Material facts include:

- the sealed release existed to permit exceptional operation when engineered safeguards may need to be overridden;
- the applicable Rule Book restricted its use and required explicit safety checks/reporting;
- a local practice had developed in which the sealed release was routinely used during possessions;
- that practice was not documented in local instructions and managers were unaware of it;
- the signaller did not clearly understand the permitted circumstances/requirements;
- the plunger had been used 183 times over roughly eight months;
- the seal had remained broken for about four months;
- assurance activity had not detected the variance between documented rules and actual practice.

### Authority and existing duties

The railway already had an operative Rule Book constraint, engineered interlocking safeguards, reporting/seal-replacement requirements, management/competence responsibilities, and local-instruction/assurance responsibilities. The problem was not absence of all governing structure.

### Causal/native mechanism

The immediate unsafe act combined memory/attention error and a mistaken fault diagnosis with access to an exceptional override. The deeper native mechanism was normalization of a non-compliant local practice, incomplete understanding/training, and ineffective management assurance.

RAIB's management-assurance guidance explicitly treats the difference between documented controls and actual practice ('work as imagined' versus 'work as done') as a known safety-management mechanism, and warns that ineffective assurance can leave such variance hidden until an incident occurs.

### Change / correction path

The native corrective path is to restore rule-conformant use of the sealed release, ensure appropriate training/local instructions, and improve assurance so exceptional/out-of-course controls do not become routine undetected practice. The safety digest itself frames the learning in those terms.

### Counterfactual/material consequence

The incident path depends on bypassing the engineered safeguard while a train was approaching. Effective adherence to the sealed-release rule and/or effective assurance that prevented routine normalization of the override would have interrupted the observed path.

### Strongest ordinary absorber

```text
railway Rule Book compliance
+ human-factors/operational-error analysis
+ local-instruction/competence management
+ management assurance / work-as-done monitoring
```

This absorber preserves the descriptive, causal, normative, and practical-intervention facts above.

### Unabsorbed material fact

```text
NONE IDENTIFIED on the frozen source surface.
```

The control-like prior therefore succeeds: this case does not require a deeper cross-domain residual to preserve the material facts.

---

## H_unknown — Bookham Tunnel

### Primary/native sources

- RAIB Report 07/2026: Near miss with track workers at Bookham Tunnel, published 15 June 2026: `https://www.gov.uk/raib-reports/report-07-slash-2026-near-miss-with-track-workers-at-bookham-tunnel`
- RAIB summary of learning on protection of track workers from moving trains: `https://www.gov.uk/government/publications/summary-of-learning-2-protection-of-track-workers-from-moving-trains-v6-may-2025/summary-of-learning-2-protection-of-track-workers-from-moving-trains`
- Network Rail safe-work-pack guidance was consulted only as native process context for creation/verification/authorisation/acceptance responsibilities.

### Actors

```text
team of three track workers
signaller granting the line blockage
safe-work-pack planner/checking/authorising roles
person(s) in charge delivering the work
Network Rail management and assurance functions
```

### Event/timeline reconstruction

- Work was planned around Bookham Tunnel.
- The safe work pack that formally detailed the safety arrangements contained line-blockage arrangements for nearby Mickleham Tunnel rather than Bookham Tunnel.
- The error was introduced during planning and survived multiple checks across the safe-work process.
- A line blockage was granted on the wrong basis; neither the workers nor the signaller realised that the workers were in a different location from the blocked line.
- At about 11:42 on 29 April 2025, a passenger train travelling about 33 mph passed the three workers in Bookham Tunnel; they moved to refuges or against the tunnel wall.

### Evidence

RAIB identifies the safe work pack, line-blockage arrangement, planning/checking history, the relationship among multiple information systems, staff process performance, and safety-critical communications as the relevant evidence surface.

### Authority and existing duties

The railway already had a safe-work-pack process intended to state task/location risks and protection arrangements and a line-blockage mechanism implemented through the signaller. Native process guidance separates creation, verification, authorisation, final acceptance, and operational implementation, with location/protection information expected to be checked.

The case therefore does not begin from absence of any settlement or safety-planning authority. It begins from a malformed safety basis that passed existing process stages.

### Causal/native mechanism

RAIB identifies:

1. lack of a specific process for managing transfer of information between Network Rail asset-management systems and the system used to produce safe work packs, which allowed the wrong information to enter the pack;
2. required steps in the safe-work-pack process were either not routinely performed or not performed effectively.

The final safety-critical communication also failed to expose the location mismatch.

### Change / correction path

RAIB's three recommendations target ordinary railway mechanisms:

```text
reduce transfer errors when multiple systems feed a safe work pack;
improve implementation of the process for work on/near operational lines;
improve assurance using information from safe-system-of-work planning software.
```

Its learning points additionally target clear safety-critical communication and a shared understanding of walking/working arrangements.

### Counterfactual/material consequence

A work pack containing the correct Bookham protection/location information, an effective verification/acceptance step that detected the Mickleham/Bookham mismatch, or a safety-critical communication that exposed the different location would have interrupted the observed near-miss path.

### Strongest ordinary absorber

```text
safe-system-of-work / safe-work-pack formation
+ cross-system information-transfer and configuration control
+ verification/authorisation/acceptance discipline
+ safety-critical communication
+ management assurance
```

RAIB's findings and recommendations already instantiate this mechanism-specific decomposition.

### Unabsorbed material fact

```text
NONE IDENTIFIED on the frozen source surface.
```

The evidence shows an incorrect location/protection basis introduced and propagated through existing planning/checking processes. On the present record, the material distinction between Bookham and Mickleham was not absent from the world or inherently unrepresentable; rather, the wrong basis was transferred into the work pack and not caught by verification/assurance.

This conclusion is a native-outcome statement, not yet an architecture score.

---

## P5-C outcome

```text
Residual(H_control) = empty on frozen evidence
Residual(H_unknown) = empty on frozen evidence
ControlAssumptionFailed = NO
```

No reserve case is activated. The next and only next experiment step is the single P5 adjudication against the already-frozen prediction matrix and failure-mode rules.
