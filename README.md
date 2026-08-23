# Responsibility Topology V0.1.1 — hardened executable proof kernel

Core adversarial criterion:

> Can a caller construct a license that has no canonical, context-valid,
> typed responsibility path in append-only history H?

V0.1.1 hardens V0.1 before any metatheorem is attempted.

## Hardening changes

1. **Canonical-reference integrity**
   - public proof/licensing APIs accept warrant/binding IDs;
   - every object is reloaded from canonical `History`;
   - caller-fabricated objects with reused IDs cannot alter role, claim, scope or binding scope.

2. **Context is a proof boundary**
   - root claims must belong to the context signature;
   - ordinary `INFER` is strictly intra-context;
   - current usability is indexed by `(profile_digest, context, use, warrant)`;
   - cross-context movement requires `TRANSPORT`.

3. **Immutable profile snapshots**
   - a binding points to `(profile id, version, sha256 digest)`;
   - mutating the authoring `Profile` after binding does not mutate the active calculus.

4. **Dependency-aware revalidation**
   - `History` stores reverse derivation edges;
   - challenge of an ancestor suspends descendants/pends their placement;
   - licenses depending on any impacted descendant enter `review_required`;
   - no recursive defeat is performed.

5. **Kernel strengthening gates**
   - `Act` requires authorization;
   - `Share` requires selection;
   - `Suspect/Reopen` require escalation;
   - `Adopt` requires escalation + selection;
   - normative licensing is deliberately disabled in V0.1.1.

6. **Transport target integrity**
   - bridge witness is bound to `(map, original warrant, target context, exact translated claim)`;
   - callers cannot use a valid bridge to translate into an arbitrary claim.

## Tests

The current suite has **16 passing tests**: the original four toy models, the eight requested hardening regressions, and additional regressions for canonical-context licensing, use-scoped challenge propagation, malicious action rules, and related boundary checks.

- spoofed warrant id cannot change role;
- spoofed binding id cannot widen scope;
- cross-context use requires transport;
- bound profile is immutable snapshot;
- ancestor challenge revalidates descendants and licenses;
- `TOP` cannot license `Adopt`;
- normative licensing is explicitly disabled;
- transport witness is bound to target claim/context.

Run:

```bash
python -m pytest -q
```

This is still a reference semantics, not a soundness proof. The next formal step should only begin after adversarial hardening stabilizes.


## Deliberate stopping boundaries

V0.1.1 still treats two operations as explicit external boundary events rather than internally self-justifying judgments:

- `admit_root(...)`: admits a sourced root premise into current usability;
- `bind_profile(...)`: activates an immutable profile snapshot for a scope/use.

Both are recorded and auditable. Neither asserts truth or ultimate legitimacy. A later version may make their challenge/requalification richer, but V0.1.1 does not hide them behind an internal oracle.
