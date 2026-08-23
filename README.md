# Responsibility Topology V0.1.2.2 — implementation hardening

V0.1.2.2 is a small hardening release before any metatheorem extraction.
It does not add a new abstraction layer.

The release keeps the V0.1.2 semantic-boundary model and closes five concrete
public-API bypasses, then fixes two kernel-law choices explicitly.

## Hardening changes

### 1. Canonical lineage is deeply immutable

Canonical `Warrant.root_ids_by_role` and `source_ids_by_role` are now
deep-frozen as `MappingProxyType[Role, frozenset]`.

Caller code cannot mutate a canonical warrant's internal lineage through the
public `History.warrants` view and forge distinct provenance.

### 2. TRANSPORT scope is conservative in both premises

A transported warrant must satisfy:

`out_scope <= original.scope`

and

`out_scope <= bridge_witness.scope`.

A narrow bridge cannot authorize a wider transported conclusion.

### 3. Move scope is part of profile requirement identity

Requirement keys now contain:

`(license_type, move_kind, args, revision_depth, move_scope)`.

A requirement declared for `Share(p)@NARROW` cannot silently license
`Share(p)@WIDE`.

### 4. Revision propagates through derivation dependency closure

`apply_revision(... affected_ids=A ...)` first computes:

`impacted = A union Descendants(A)`.

The declared `USE_LOCAL` / `PROFILE_GLOBAL` reach is then applied to the entire
dependency closure. Derived warrants and licenses cannot remain current merely
because the caller passed only an ancestor ID.

### 5. Distinct-source/root guards require real plurality

`distinct_content_sources` and `distinct_content_roots` require at least two
CONTENT inputs. The length-one vacuous case is rejected.

## Kernel law choices fixed in V0.1.2.2

### K-Law A — TRANSPORT is non-amplifying for revision strength

If an ESCALATION warrant carries `EscalationDepth(d)`, transport may preserve
or narrow `d`, but may not translate it into a larger depth.

A future system that wants explicit cross-context strength conversion must add
a new kernel-owned constructor/law. Bridge evidence alone is not such a
constructor in V0.1.2.2.

### K-Law B — adopted context activity is continuously current

`Adopt` is not treated as a permanently self-sufficient one-shot transition.

An activated context records the exact Adopt license that activated it.
If that license enters `review_required`, the target context becomes `PENDING`,
and new operational licenses in that context fail closed until a later explicit
requalification/reactivation path is introduced.

Bootstrap activation of the first context remains an explicit external stopping
boundary and has no adoption-license dependency.

## Syntax hygiene

Only `Suspect`, `Reopen`, and `Adopt` may carry non-`NONE` revision depth.
`Accept`, `Share`, `Act`, `Review`, etc. with nonzero revision depth are
ill-formed.

## Threat model

Canonical history/state mutations are kernel transitions. Python reflection or
direct mutation through `_private` implementation attributes remains outside
the executable threat model; all caller-facing canonical maps are read-only.

## Non-goal retained

`LicenseRecord.agents` is still attribution metadata, not agent-indexed
obligation ownership. V0.1.2.2 still does not claim genuine distributed
obligation discharge for Q_close.

## Run

```bash
python -m pytest -q
```

The suite retains the prior adversarial regressions and adds direct tests for
deep lineage immutability, transport scope, move-scope requirement identity,
revision dependency closure, non-vacuous provenance guards, transport depth
conservativity, continuously-current context adoption, and revision-depth
syntax hygiene.


## Ambient-currentness closure

V0.1.2.2 strengthens continuously-current adoption from a one-step rule to a
transitive ambient invariant:

`ACTIVE(c,u) -> Current(activation_license(c,u))`

for every non-bootstrap active context.

After challenge/revision changes license currentness, the kernel runs a
fixed-point refresh. If an upstream adopted context becomes `PENDING`, any
downstream Adopt license issued in that context becomes non-current; its target
context is then also moved to `PENDING`, and the process repeats until stable.

This is an AmbientDeps consistency law. It does not change Branch Conservativity.
