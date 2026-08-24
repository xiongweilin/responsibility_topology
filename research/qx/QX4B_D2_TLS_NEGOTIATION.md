# QX-4B₂ — Candidate B Audit: TLS 1.3 Finite Negotiation

Status: **SOURCE-BACKED HARD NEGATIVE CONTROL**.

Formalization: **NO**.

Parent protocol: `QX4B_DOMAIN_KILL_FREEZE.md` and `QX_KERNEL_PREREGISTRATION.md`.

Domain ID: `B-D2`.

## 1. Domain question

This domain asks whether Candidate B incorrectly promotes a genuine, protocol-defined finite exhaustion result into representation inadequacy.

Target firewall:

```text
complete finite negotiation exhaustion
-/->
representation inadequacy.
```

## 2. Source-backed protocol semantics

Normative sources:

- RFC 8446, *The Transport Layer Security (TLS) Protocol Version 1.3* (2018): https://www.rfc-editor.org/rfc/rfc8446
- Current successor RFC 9846, *The Transport Layer Security (TLS) Protocol Version 1.3* (2025): https://www.rfc-editor.org/info/rfc9846/

The relevant rule is stable across the two specifications. TLS cryptographic negotiation uses explicitly encoded supported option lists. In the non-PSK case, if there is no overlap between the client's received `supported_groups` list and groups supported by the server, the server must abort the handshake with a fatal negotiation/security alert. The current RFC additionally states the general form directly: if the server cannot negotiate a supported set of parameters because client and server parameters do not overlap, it must abort.

This makes the domain an unusually strong Candidate-B negative control:

```text
finite candidate set: operationally represented
boundary authority: protocol grammar + endpoint-advertised sets
exhaustion: exact, not sampled
failure criterion: protocol-defined compatibility/security
```

Yet the native semantics already contain a correct failure response.

## 3. Active Candidate-B audit matrix

### Finite?

```text
YES for each concrete ClientHello/server-policy negotiation instance.
```

The wire representation carries finite vectors/lists of offered/supported parameters. The candidate space relevant to one handshake instance is finite and inspectable.

### Enumeration authority

```text
E1 — protocol / grammar defines the represented option structures,
plus endpoint policy fixes the concrete offered/supported finite sets.
```

This is stronger than E2 model-relative generation and much stronger than a human convenience list.

The exhaustion claim is therefore not vulnerable to fake finitude merely because the list is finite.

### Exhaustive relative to what task position?

The finite set is exhaustive relative to:

> **the currently offered and locally supported TLS negotiation parameters for this handshake under the endpoints' policies.**

It is not exhaustive relative to:

```text
all cryptographic algorithms that could ever exist;
all future protocol extensions;
all policies the parties could adopt;
all ways the application could communicate.
```

Candidate B must respect this bounded task position.

### `V -> H_V` link

```text
STRONG AND DIRECT.
```

The handshake representation itself carries the relevant option sets. The negotiable candidate combinations are induced by those represented offers/support sets and the protocol's compatibility rules.

There is no missing representation link of the weak historical kind.

### Independent `C`

```text
YES.
```

The criterion is defined by protocol semantics and local security/support policy: a selected set must be mutually supported and meet the protocol's requirements.

This is not post-hoc rejection after observing the failure.

### Every candidate fails?

For an actual no-overlap instance:

```text
YES.
```

Every candidate in the current negotiation intersection fails because the intersection is empty. More precisely, there is no protocol-acceptable candidate to select from the currently represented offers/supports.

### Common-mode rival

No measurement or simulator error is needed. The negative control assumes the lists are correctly transmitted and interpreted.

### Unknown/defer semantics

This domain makes the response/candidate distinction explicit:

```text
abort handshake
=
Unknown/No-solution-as-response
```

It is **not** a cryptographic candidate in `H_V`.

The absence of an acceptable parameter choice does not leave the protocol without a valid action. Abort/fail-closed is itself the specified behavior.

### Task defeated?

This depends on the task definition.

If the task is:

```text
establish a TLS session using one of the current mutually acceptable parameter choices
```

then the positive connection-establishment goal fails.

If the task is:

```text
preserve TLS security semantics under incompatible offers
```

then aborting is the correct protocol behavior and the safety task succeeds.

Therefore:

```text
candidate exhaustion
!=
whole task failure.
```

## 4. B-K1 ... B-K8

### B-K1 — fake exhaustiveness

```text
PASS.
```

For the concrete negotiation instance, the relevant current offers/support sets are explicitly represented. No convenient subset is being mislabeled as complete.

### B-K2 — post-hoc criterion

```text
PASS.
```

Compatibility/security requirements are protocol/policy inputs to negotiation, not post-hoc criteria invented after failure.

### B-K3 — common-mode test failure

```text
PASS.
```

No common measurement/test fault is required to explain empty overlap.

### B-K4 — decorative finitude

```text
PASS.
```

Finiteness is operationally real. Endpoints can actually determine that no currently represented acceptable choice exists.

### B-K5 — ordinary model-class rejection

```text
SUPPORTING ABSORPTION.
```

The native interpretation is ordinary negotiation failure / policy incompatibility. No richer model-class story is required.

### B-K6 — hidden catch-all candidate

```text
KILL PRESSURE THROUGH SAFE RESPONSE SEMANTICS.
```

The protocol does not need an `unknown cryptographic parameter` candidate. It has a defined fatal response when no acceptable negotiation exists.

This matters because Candidate B asks whether exhaustion defeats a relied-upon task. For the security-preservation task, fail-closed behavior is successful responsibility discharge rather than evidence that the representation itself is inadequate.

### B-K7 — illegitimate world-level conclusion

```text
PASS AS FIREWALL.
```

The audit infers only empty current negotiation overlap, not impossibility of secure communication in principle.

### B-K8 — complete exhaustion does not establish representation inadequacy

```text
KILL — DECISIVE.
```

This is the purpose of the domain.

All of the strongest Candidate-B premises can hold:

```text
finite represented candidate class: YES
complete enumeration: YES
independent criterion: YES
all current candidates fail: YES
V -> H_V link: YES
```

and the correct conclusion is still only:

```text
no acceptable negotiation exists under the current represented offers/supports/policies.
```

No source-backed fact requires the stronger conclusion:

```text
V is an inadequate distinction space.
```

The protocol's representation is doing exactly what it is designed to do: represent supported options, detect incompatibility, and fail safely.

## 5. Exact domain verdict

```text
B-D2 TLS 1.3 finite negotiation:
ELIMINATED
```

Primary kill:

```text
B-K8 complete finite exhaustion != representation inadequacy
```

Supporting pressure:

```text
B-K6 abort/fail-closed may satisfy the relevant safety task
B-K5 native policy/negotiation incompatibility fully explains the outcome
```

## 6. Freedom deleted

This domain permanently removes:

```text
protocol-defined finite universe
+
exact complete exhaustion
+
independent acceptance criterion
+
strong V -> H_V link
-/->
representation inadequacy.
```

It also fixes the catch-all firewall:

```text
Unknown-as-response
!=
Unknown-as-candidate.
```

and:

```text
failure to identify/select a successful candidate
!=
failure to discharge a task that permits safe refusal.
```

## 7. QX status after B-D2

```text
Candidate A: FROZEN / pre-refinement discriminator-unavailability witness / mechanism-specific only
Candidate B active cycle:
  B-D1 incomplete-model diagnosis: ELIMINATED
  B-D2 TLS negotiation: ELIMINATED
  B-D3 spacecraft fault catalogue: pending
Candidate-B aggregate verdict: NOT YET WRITTEN
QX generic object: NOT EARNED
QX Lean: NO
```
