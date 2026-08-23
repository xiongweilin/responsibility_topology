# Responsibility Topology — V0.1 proof-kernel prototype

This is a deliberately small executable reference model for the V0.1 design discussed in the conversation.

Core invariant:

> No judgmental strengthening without an explicit, typed, auditable responsibility path.

The implementation separates:

- `History`: append-only warrant and license lineage;
- `EvaluationState`: mutable `live/suspended/defeated` and `placed/pending/orphaned` status;
- `Profile`: versionable declared requirements and inference rules;
- `ProofKernel`: non-profile safety invariants for role, scope, provenance, authorization and revision-strengthening.

The external reality/admission boundary is explicit. A `RootToken` can be recorded without being usable. `admit(...)` is a separate audited state event and does **not** assert truth.

The kernel has only three warrant constructors:

1. `root`
2. `infer`
3. `transport`

`Suspect`, `Reopen`, `Adopt`, `Share`, and status resolution are moves, not warrant constructors.

## Run

```bash
python -m pytest -q
```

The tests include:

1. persistent residual → `Suspect(O2)` but not `Reopen(O3)` or `Adopt`;
2. three agreeing warrants with one content root → no independent-provenance closure;
3. heterogeneous signatures → only explicitly bridgeable content enters a common determination;
4. a novel-language defeater suspends support for an old closure without rewriting history;
5. a malicious profile cannot license action from `⊤`;
6. a malicious profile cannot infer authorization from content alone.

## Deliberate non-goals

This is not yet Lean/Coq and it does not claim the kernel is final. It is a reference operationalization intended to expose hidden judges and make shortcut failures executable.
