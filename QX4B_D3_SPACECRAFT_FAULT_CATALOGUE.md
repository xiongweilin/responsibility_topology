# QX-4B₃ — Candidate B Audit: Spacecraft Fault-Protection Catalogues

Status: **SOURCE-BACKED NEGATIVE CONTROL**.

Formalization: **NO**.

Parent protocol: `QX4B_DOMAIN_KILL_FREEZE.md` and `QX_KERNEL_PREREGISTRATION.md`.

Domain ID: `B-D3`.

## 1. Domain question

This domain tests the opposite failure mode from TLS.

TLS showed that genuine complete finite exhaustion still need not imply representation inadequacy.

Here the question is:

> **When engineers enumerate identified / likely / credible fault modes, who is entitled to treat that finite list as the complete represented task universe?**

The target firewall is:

```text
finite operational catalogue
-/->
justified finite universe.
```

## 2. Source-backed evidence

Primary sources:

- NASA, *Flight Software Complexity* final report (2009), Appendix G, fault-protection discussion:
  https://www.nasa.gov/wp-content/uploads/2015/04/418878main_fswc_final_report.pdf

  The report explicitly warns that after exhausting all likely suspects, engineers should still consider unlikely possibilities; it states that fault responses are not exhausted merely because all identified failure modes have been addressed. The operational objective is preserving functionality when the unexpected occurs.

- JPL, *New Approaches for Solving the Diagnosis Problem*, TMO Progress Report 42-149:
  https://tda.jpl.nasa.gov/2000-2009/progress_report/42-149/149K.pdf

  The report describes the common practice of constructing fault-protection modes / symptom-to-cause rules by predicting possible faults, then identifies a core limitation: it is impossible to predict all possible faults in advance. It contrasts hand-enumerated fault modes with model-based diagnosis approaches.

These sources are unusually direct evidence against treating a finite engineering fault list as an epistemically complete fault universe.

## 3. Active Candidate-B audit matrix

### Finite?

```text
YES for a concrete engineered catalogue.
```

A project can have a finite list of identified fault modes, monitors, response rules, or credible failure cases.

### Enumeration authority

Typical classification:

```text
E3 or E4, not E1/E2.
```

A formally maintained institutional fault catalogue may have operational authority over which cases receive predefined responses (`E3`).

But the cited NASA/JPL material explicitly denies the stronger semantic claim that such a catalogue exhausts all faults that may occur. In many cases it is simply the set engineers currently know, deem credible, or choose to protect against (`E4`).

Therefore:

```text
operational completeness for predefined response coverage
!=
semantic completeness of possible fault states.
```

### Exhaustive relative to what task position?

At most, a catalogue may be exhaustive relative to a bounded engineering artifact such as:

```text
all identified failure modes with dedicated fault-protection responses;
all faults included in a particular analysis baseline;
all catalogued symptoms-to-cause rules.
```

The NASA source expressly rejects upgrading this into:

```text
all relevant failures the spacecraft may encounter.
```

### `V -> H_V` link

```text
WEAK / TASK-ARTIFACT RELATIVE ONLY.
```

The system's current engineering vocabulary may induce a finite set of named fault modes, but the cited guidance treats the world-facing failure space as open to unanticipated interactions, low-probability cases, and states deemed not credible.

Thus a finite catalogue is not shown to be the complete candidate class induced by the whole task-relevant distinction space `V`.

### Independent `C`

A project may have independent safety/mission criteria for determining whether a fault response succeeded.

That does not repair the exhaustiveness problem. Independent failure criteria can show:

```text
none of the catalogued responses resolved the problem
```

without showing:

```text
all candidates in the true represented task universe were exhausted.
```

### Every candidate fails?

This can occur operationally:

```text
all likely / identified suspects tried
+
problem unresolved.
```

The NASA guidance explicitly discusses this condition.

But the condition is evidence that the catalogue was not sufficient to resolve the event, not evidence that the catalogue was semantically exhaustive.

### Common-mode rival

No special common-mode measurement bug is required. The decisive problem is enumeration authority.

### Unknown/defer semantics

The spacecraft/operations system may continue searching, improvise a workaround, safe the vehicle, or classify the event as unexplained.

These are responses, not necessarily explanatory candidates inside the fault catalogue.

This again enforces:

```text
Unknown-as-response
!=
Unknown-as-candidate.
```

### Task defeated?

If the task is:

```text
select one of the pre-specified fault responses
```

then exhaustion defeats that narrow mechanism.

If the task is:

```text
preserve safety / functionality / communication under faults
```

then the NASA guidance explicitly recommends going outside the initially identified/likely catalogue rather than treating the task universe as exhausted.

Therefore the catalogue boundary is not the task boundary.

## 4. B-K1 ... B-K8

### B-K1 — fake exhaustiveness

```text
KILL — DECISIVE.
```

The sources directly deny the inference that addressing all identified failure modes exhausts fault responses or all possible faults.

A finite identified list can be complete as a document while incomplete as a representation of the relevant failure universe.

### B-K2 — post-hoc criterion

```text
NOT DECISIVE.
```

Safety/mission objectives may be independently specified. Candidate B fails even granting a stable criterion.

### B-K3 — common-mode test failure

```text
NOT DECISIVE.
```

The domain is not killed by measurement/test error.

### B-K4 — decorative finitude

```text
KILL.
```

Finiteness of the catalogue contributes no justified exhaustive certificate if the enumeration boundary is only `currently identified/credible faults`.

The argument remains:

```text
all listed cases fail
->
continue looking outside the list.
```

The fact that the list is finite does not establish the candidate universe.

### B-K5 — ordinary model-class rejection

```text
SUPPORTING ABSORPTION.
```

Failure of all predefined modes/responses is naturally interpreted as failure of the current fault catalogue, response library, or fault model. No distinct QX object is needed.

### B-K6 — hidden catch-all candidate

```text
KILL PRESSURE.
```

Operations often retain an implicit or explicit `unexpected/unmodeled` possibility. Even where that is not a concrete explanatory hypothesis, the ability to leave the predefined catalogue and improvise means the named finite set is not the whole task universe.

### B-K7 — illegitimate world-level conclusion

```text
PASS AS FIREWALL.
```

The audit does not infer that reality has no fault explanation. It infers the opposite: exhausting the identified list gives no entitlement to such a claim.

### B-K8 — no justified `H_V -> V` completeness link

```text
KILL.
```

The critical missing fact is not the existence of a finite list. It is authority for the statement:

```text
this list is complete for the task-relevant represented distinction space.
```

The NASA/JPL guidance explicitly undermines that claim for real fault-management practice.

## 5. Exact domain verdict

```text
B-D3 spacecraft fault-protection catalogue:
ELIMINATED
```

Primary kills:

```text
B-K1 fake exhaustiveness
B-K4 decorative finitude
B-K8 no justified catalogue-to-representation completeness link
```

Supporting pressure:

```text
B-K5 ordinary fault-model / response-library insufficiency
B-K6 unexpected/unmodeled possibility remains outside the named catalogue
```

## 6. Enumeration-authority result

This domain fixes the following hierarchy:

```text
E1 protocol-defined complete option set
>
E2 formally generated set relative to model assumptions
>
E3 institutional operational catalogue
>
E4 analyst list of known/credible candidates
```

But even this ordering is task-relative.

`E3` can be authoritative for:

```text
which faults have predefined responses
```

without being authoritative for:

```text
which faults can occur.
```

That distinction is mandatory in future finite-exhaustion arguments.

## 7. Freedom deleted

This domain permanently removes:

```text
finite list
-/->
justified finite universe;

all identified failure modes addressed
-/->
all relevant fault responses exhausted;

institutional catalogue authority
-/->
world/task-space completeness;

all named suspects fail
-/->
representation inadequacy certificate.
```

## 8. QX status after B-D3

```text
Candidate A: FROZEN / pre-refinement discriminator-unavailability witness / mechanism-specific only
Candidate B active cycle:
  B-D1 incomplete-model diagnosis: ELIMINATED
  B-D2 TLS negotiation: ELIMINATED
  B-D3 spacecraft fault catalogue: ELIMINATED
Candidate-B aggregate verdict: READY
QX generic object: NOT EARNED
QX Lean: NO
```

The active three-domain protocol is complete. No fourth domain may be added to rescue Candidate B.
