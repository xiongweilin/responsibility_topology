# Cross-Domain Invariant Candidates and Falsification Protocol

Status: research protocol. No claim in this file is a Lean theorem or a universal invariant.

Formal repositories remain frozen during this stage.

## Purpose

The next research question is not whether the existing epistemic kernel can be generalized by analogy. It is whether any responsibility structure survives deliberate attempts to falsify it across heterogeneous domains.

The protocol therefore begins with **candidate relations**, not invariants.

The first round tests exactly three candidates:

```text
I1:
  persistent relation
  !=
  state-indexed current responsibility

I2:
  dependency / impact
  !=
  repair / discharge responsibility

I3:
  correctness inside model
  !=
  adequacy of model
```

The symbols `!=` above are methodological shorthand for a proposed structural distinction. They do not assert a theorem of logical non-implication.

The falsification target is confirmation bias. A candidate should be weakened, split, or rejected whenever a domain forces a materially different relation rather than being renamed until it fits.

## Deliberately heterogeneous discovery domains

The first discovery round excludes software and formal authorization systems as primary samples.

The three formal samples are:

```text
D1  physical-operational
    supply-chain / industrial maintenance

D2  normative-institutional
    legal / institutional authority

D3  empirical-scientific
    experimental physics / measurement systems
```

These domains are selected precisely because they do not lie on the existing path:

```text
epistemic kernel
-> software/runtime
-> authorization
-> provenance
```

Software may later be used only as a regression sample after the candidate verdicts are formed.

## Domain-selection discipline

A domain is eligible for the first round only if all of the following hold:

1. its primary objects are not software records or formal proof objects;
2. its operative notion of current responsibility is not merely copied from the existing kernel vocabulary;
3. it has real state change, invalidation, or authority/fitness loss;
4. repair/discharge can differ materially from “re-run the same validation”;
5. there are authoritative domain sources capable of falsifying an analogy;
6. at least one plausible failure mode exists for each candidate being tested.

A sample is rejected if the mapping only works after redefining domain terms to mirror the kernel.

## Discovery domains

### D1 — physical-operational: supply-chain / industrial maintenance

Preferred concrete subcase: safety-critical maintenance with installed components, maintenance records, continuing fitness/serviceability, supplier/part dependencies, inspection, replacement, quarantine, and re-certification.

Candidate examples include:

```text
historical installation / maintenance record
!=
current airworthiness or serviceability
```

and:

```text
historical supplier / component dependency
!=
current admissibility of continued operation
```

Repair may include:

```text
replace component
isolate affected unit
inspect
rework
re-certify
restrict operating envelope
defer under an explicitly allowed regime
```

This domain is valuable because discharge may change the physical object rather than merely revalidate the same representation.

### D2 — normative-institutional: legal / institutional authority

Preferred concrete subcase: appointment, delegation, acting authority, term limits, revocation, recusal/disqualification, and procedural validity in public or institutional decision systems.

Candidate examples include:

```text
historical appointment / delegation
!=
current legal authority
```

and:

```text
procedure followed under regime R
!=
adequacy / legality / legitimacy of R itself
```

Repair/discharge may require:

```text
new appointment
renewed delegation
ratification
re-hearing
recusal
jurisdictional transfer
statutory or rule change
```

This domain is valuable because current responsibility is partly constituted by normative rules rather than only by physical or epistemic state.

### D3 — empirical-scientific: experimental physics / measurement systems

Preferred concrete subcase: measurement chains with instrument calibration, metrological traceability, uncertainty budgets, model assumptions, data reduction, and later discovery of drift or invalid calibration.

Candidate examples include:

```text
historical measurement provenance
!=
current evidential admissibility
```

and:

```text
analysis correct under calibration/model M
!=
adequacy of M
```

Repair/discharge may require:

```text
recalibration
uncertainty re-estimation
re-analysis
exclude affected runs
repeat measurement
replace model
collect independent evidence
```

This domain is valuable because historical data can remain unchanged while its current evidential weight changes under new calibration or model information.

## Excluded first-round discovery sample: software

Software is deliberately excluded from the discovery set.

Reason:

```text
existing theory is already too close to
state machines / formal kernels / runtime semantics / provenance
```

Using software to discover the candidate relations would make it too easy to recover the original vocabulary by construction.

Software may be added later as:

```text
D4 regression sample
```

with the question:

> Do the abstractions discovered outside software still explain the original software/formal cases without adding software-specific structure back into the abstraction?

## Required audit matrix

Every `I_k x D_j` cell must answer all of the following.

| Field | Required question |
| --- | --- |
| Persistent object/relation | What historical object, relation, event, or record remains after change? |
| Current qualification | What must be judged again in the present state? |
| Invalidator | What event or discovery withdraws the current qualification? |
| Repair/discharge | What responsibility must be discharged after invalidation? |
| Counterexample | What plausible case makes the candidate relation fail or become misleading? |
| Representation dependence | Does the result depend on the chosen variables, ontology, record granularity, or institutional vocabulary? |
| Failure mode | Does the candidate fail because no persistent object exists, no currentness relation exists, repair is not separable, or model adequacy is not meaningful? |
| Migration class | `common problem`, `formal similarity`, or `mechanism similarity` |
| Verdict | `survives`, `narrows`, `splits`, or `fails` |

No cell may be marked `survives` without a stated counterexample boundary.

## Candidate I1 protocol

Candidate:

```text
persistent relation
!=
state-indexed current responsibility
```

### What would support I1

Evidence for I1 requires a domain to contain both:

1. a relation or record whose historical truth/identity remains meaningful after later change; and
2. a separate present-state predicate governing whether action/reliance/authority/fitness remains acceptable now.

The present-state predicate must not simply be another name for historical existence.

### What would falsify or narrow I1

I1 narrows or fails if any of the following occur:

- the historical relation itself is legally/physically/semantically erased rather than preserved;
- current qualification is constitutive of historical identity, so no independent historical layer exists;
- the domain treats supersession by replacement rather than retained historical relation;
- the apparent distinction appears only because the analyst chose event-sourced records;
- “current responsibility” has no domain-native meaning independent of the imported framework.

### Strongest representation-dependence attack

Ask:

> If the domain were modeled without append-only history, would I1 still describe the domain, or only the chosen record architecture?

If the answer is “only the record architecture,” the verdict cannot exceed `formal similarity`.

## Candidate I2 protocol

Candidate:

```text
dependency / impact
!=
repair / discharge responsibility
```

### What would support I2

Evidence for I2 requires a distinction between:

- identifying what is affected by a change/failure; and
- determining what action, review, replacement, reauthorization, or other discharge is sufficient.

The same impacted object must permit more than one possible discharge, or at minimum the discharge must depend on facts not contained in the impact relation itself.

### What would falsify or narrow I2

I2 narrows or fails if:

- impact mechanically determines exactly one mandatory repair by definition;
- the domain's “dependency” relation already includes the complete recovery prescription;
- repair is impossible or meaningless, leaving only abandonment;
- the apparent distinction is an artifact of splitting one domain rule into two tables;
- there is no meaningful affectedness relation prior to the repair decision.

### Strongest mechanism attack

Ask:

> Could two systems with the same dependency/impact graph legitimately require different repairs because of physical state, law, uncertainty, authority, cost, or risk?

If yes, I2 gains support. If no because the repair is already encoded in dependency semantics, the candidate narrows.

## Candidate I3 protocol

Candidate:

```text
correctness inside model
!=
adequacy of model
```

### What would support I3

Evidence for I3 requires a domain where:

1. a procedure, calculation, decision, or action can be correct relative to a stated rule/model/regime; and
2. the rule/model/regime can still be inadequate for the external purpose or reality it is meant to address.

### What would falsify or narrow I3

I3 fails as stated if:

- the “model” is merely a complete stipulative rule whose adequacy is not a meaningful internal or external question;
- correctness is itself defined to include external adequacy;
- there is no independent evidence surface from which inadequacy could be judged;
- the domain is purely formal and has no intended-world or normative adequacy relation;
- adequacy is not defeasible or is settled only by authority without an independent evaluation concept.

### Strongest self-reference attack

Ask:

> By what evidence or authority can the domain say the governing model is inadequate without presupposing the same model's admissibility rules?

This question is not solved by I3. It is the bridge toward `Q_open`.

## Migration classes

The protocol uses three migration classes.

### 1. Common problem

Use when domains share only a question shape, such as:

```text
something was acceptable before;
is it still acceptable now?
```

No structural preservation is claimed.

### 2. Formal similarity

Use only when there is an explicit structure-preserving mapping between domain relations.

A minimal claim must identify:

```text
source objects
source relations
mapped objects
mapped relations
what is preserved
what is lost
```

A diagrammatic resemblance is insufficient.

### 3. Mechanism similarity

Use only when not only the relation shape but also the generation/invalidation/repair mechanism corresponds at the chosen abstraction level.

Required evidence includes meaningful correspondence of:

```text
formation/generation
current qualification
invalidator
repair/discharge
```

Mechanism similarity is the strongest class and should be rare.

## Verdict vocabulary

Each cell receives one of four verdicts.

### survives

The candidate distinction remains materially the same after domain-native terminology, counterexample attack, and representation-dependence analysis.

### narrows

A weaker version survives, but one or more terms need qualification.

Example:

```text
persistent relation
```

may need to become:

```text
persistent audit/historical relation under regimes that retain prior acts
```

### splits

The candidate conflates multiple domain-native distinctions and should be decomposed.

Example:

```text
current responsibility
```

may split into:

```text
legal authority
technical fitness
procedural admissibility
risk acceptance
```

### fails

The candidate relation is not a useful structural description of the domain without importing the original framework vocabulary.

Failure is a successful research outcome.

## Upgrade rule: from candidate to candidate invariant

No candidate becomes a `candidate invariant` merely because all three domains admit analogous wording.

Upgrade requires all of the following:

1. it survives or narrows consistently across all three heterogeneous discovery domains;
2. at least one explicit counterexample boundary is known in every domain;
3. the surviving relation is stated without kernel-specific terms;
4. representation dependence is documented and does not fully explain the similarity;
5. at least `formal similarity` exists across the three domains;
6. the abstraction does not require software-specific state-machine machinery;
7. there is no unresolved domain in which the relation collapses by definition.

Even then, call it only:

```text
candidate invariant
```

not:

```text
universal invariant
law of responsibility
cross-domain theorem
```

## Falsification-first procedure

For each domain:

### Step 1 — domain-native reconstruction

Describe the domain without using these framework terms unless the source itself uses them:

```text
warrant
currentness
Grounded
BaseCurrent
repair cut
responsibility topology
```

### Step 2 — identify native objects and transitions

Record actual domain-native notions first.

### Step 3 — construct the strongest plausible mapping to I1–I3

State what maps and what does not.

### Step 4 — attack the mapping

Search specifically for:

- cases where history is erased or legally nullified;
- cases where current qualification retroactively changes the relevant relation;
- cases where impact uniquely determines remedy;
- cases where no repair is possible;
- cases where model adequacy is not a meaningful question;
- cases where the mapping depends entirely on chosen record granularity.

### Step 5 — classify migration strength

Choose common problem, formal similarity, or mechanism similarity.

### Step 6 — issue verdict

Choose survives/narrows/splits/fails and record the failure boundary.

## Anti-confirmation-bias rules

The following are prohibited during the first round.

### Prohibited move 1 — renaming until it fits

Do not call every historical record a `warrant`, every validity rule `currentness`, and every remedy `repair` merely to recover the kernel vocabulary.

### Prohibited move 2 — selecting only append-only systems

At least one domain attack must consider whether the historical object can be voided, superseded, physically destroyed, or legally treated as never effective.

### Prohibited move 3 — equating auditability with persistence

A record may remain available for audit while the legal/physical/scientific relation it records no longer has the same status. Distinguish record persistence from relation persistence.

### Prohibited move 4 — treating any post-change action as repair

A replacement, abandonment, compensation, re-hearing, recalibration, or statutory change may differ fundamentally. Record those differences rather than forcing one repair mechanism.

### Prohibited move 5 — upgrading question similarity into mechanism similarity

Shared language such as “valid then, invalid now” earns at most `common problem` until a preserved structure is shown.

### Prohibited move 6 — using the existing formal kernel as the ontology judge

The audit is allowed to conclude that the kernel vocabulary is too narrow.

## Evidence discipline

Every domain result must distinguish:

```text
normative/domain rule
empirical fact
interpretive mapping
counterexample
research verdict
```

Authoritative sources should be preferred for the domain-native rules:

- regulator / maintenance standard / continuing-airworthiness material for D1;
- constitution/statute/regulation/case law or authoritative institutional rules for D2;
- BIPM/NIST or primary experimental methodology sources for D3.

Secondary literature may be used to identify attacks, but should not silently become the authority for domain rules.

## Output artifacts

The XDI stage should produce three separate artifacts.

### XDI-1 — protocol

This file.

### XDI-2 — domain matrix

A source-backed `3 candidates x 3 domains` audit with all required fields completed.

### XDI-3 — candidate verdict

A short synthesis that states for I1/I2/I3:

```text
survives / narrows / splits / fails
migration strength
known counterexample boundary
representation dependence
whether candidate-invariant promotion is allowed
```

## Stop conditions

Stop and do not proceed to runtime refinement if:

- all candidates collapse into framework-specific vocabulary;
- no non-trivial common observation boundary survives;
- the three domains require mutually incompatible meanings of “current responsibility”;
- representation choices explain essentially all apparent similarity.

If that occurs, the correct conclusion is not that cross-domain invariance failed as a project. The correct conclusion is that the current abstraction is not yet domain-independent enough to serve as a refinement target.

## Relationship to REF-1

Only after XDI-3 should the runtime bridge define:

```text
alpha_0 : RuntimeState -> FormalObservation_0
```

The initial observation surface should be informed by what survives falsification, not copied wholesale from the Lean state.

The default candidate observation dimensions are:

```text
persistent identity
historical dependency
current qualification
current activation/use
invalidation/review
repair/requalification
```

but XDI is allowed to remove, split, or rename them before REF-1.

## Relationship to Q_open

XDI does not solve `Q_open`.

It may, however, expose a sharper problem:

```text
when a candidate representation repeatedly fails to preserve
important domain distinctions,
what evidence upgrades those failures into defeasible entitlement
to reopen the responsibility vocabulary itself?
```

That question belongs to QO-1 and remains non-formal in this stage.

## Current decision

```text
I1, I2, I3: CANDIDATES ONLY
D1: physical-operational
D2: normative-institutional
D3: empirical-scientific
software: excluded from first-round discovery
formal kernel: frozen
next step: source-backed 3 x 3 falsification run
```