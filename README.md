# Responsibility Topology V0.1.2 — semantic-boundary hardening

V0.1.2 is deliberately not a metatheorem release. It hardens the executable
reference semantics around the four boundaries that must be stable before a
formal inference sheet is extracted.

Core adversarial criterion:

> Can an adversarial caller construct or reuse a license that has no canonical,
> context-valid, typed responsibility path in append-only history H?

## Release invariants

### G1 — Trusted transition state

`History` and `EvaluationState` expose read-only views. Canonical stores,
warrant status, active bindings, active contexts and review sets are mutated
only through kernel transitions. Python reflection/private-field hacking is
explicitly outside the V0.1.2 threat model.

### G2 — Candidate context != active context

A context is first registered as a candidate. Candidate contexts may host
exploratory roots, derived warrants and challenges. Operational `license(...)`
requires an active context.

The first active context for a binding/use is an explicit bootstrap boundary.
Any later context activation must consume a currently reusable `Adopt` license.

This permits exploration of a new distinction space without silently changing
the map used for operational determination.

### G3 — Closed move strength

`Move.kind` is a kernel-owned `MoveKind` enum. Unknown move kinds fail closed.
Profiles may add requirements but cannot introduce a new semantic move by
renaming `Adopt`, `Act`, `Reopen`, etc.

### G4 — Typed revision depth

`Suspect`, `Reopen`, and `Adopt` carry a kernel-owned `RevisionDepth`.
Licensing requires a live escalation warrant whose explicit
`EscalationDepth(n)` is at least the move depth.

Profile inference cannot silently amplify escalation depth.

### G5 — Use-local invalidation

Challenge propagation is use-indexed for both warrant status and affected
licenses. A challenge in use `u1` does not put a `u2` license into review merely
because it shares the same historical warrant.

### G6 — Explicit revision reach

Revision transitions declare their reach:

- `USE_LOCAL(use)`
- `PROFILE_GLOBAL`

There is no ambiguous revision function whose propagation scope depends on an
omitted condition.

### G7 — Historical license != current capability

`LicenseRecord` is an append-only historical issuance record and now records
its exact `binding_id`.

`check_license_current(L)` separately checks:

- exact binding still active;
- profile digest still matches;
- license context is active for that binding/use;
- license is not under review;
- every branch leaf is currently usable.

Any effectful transition that consumes an old license (currently context
activation) rechecks current reusability first.

### G8 — Provenance guard semantics

V0.1.2 stores both:

- canonical root warrant IDs;
- external source identities.

They are not conflated.

`distinct_content_sources` is the guard used for evidence-source diversity.
`distinct_content_roots` is separately available for historical-root identity.
Both are kernel-known typed transitions from `CONTENT^n` to `PROVENANCE`.
Unknown kernel guards fail closed.

## Trusted external stopping boundaries

V0.1.2 makes the following external boundaries explicit rather than pretending
to derive them internally:

- candidate context registration;
- profile binding;
- bootstrap activation of the first determination context for a binding/use;
- root admission.

None of these events asserts truth or ultimate legitimacy. They are auditable
boundary roots for the executable reference semantics.

## Deliberate non-goal

`LicenseRecord.agents` is still metadata. V0.1.2 does **not** yet claim
agent-indexed obligation ownership or genuine distributed obligation discharge.
It only supports licenses whose warrant lineage may come from multiple sources.

## Run

```bash
python -m pytest -q
```

The suite includes the V0.1.1 regressions plus V0.1.2 semantic-boundary attacks.
The next formal step should begin only after this adversarial gate remains
stable.
