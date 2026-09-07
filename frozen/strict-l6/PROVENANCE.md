# Strict-L6 frozen artifact provenance

This directory is a self-contained archival copy of the exact raw runtime artifact used by the frozen Strict Technical Level 6 bridge.

## Origin

- Source repository: `xiongweilin/agent-kernel` (historical compatibility repository name at the time of the original workflow: `xiongweilin/portable-runtime`)
- Source commit: `21fa75e0364b9a67d3596295e005e8052504e694`
- Source commit title: `ref4: add raw withdrawal transition artifact`
- Original path: `tests/fixtures/o0/raw_withdrawal_transition_v1.json`
- Frozen local path: `frozen/strict-l6/raw_withdrawal_transition_v1.json`
- SHA-256 of the frozen UTF-8 file, including the final newline: `61705ce6d1f2005571ba174232df3aae6d3a64b3b872029dd2156c664732b465`

The source commit remains historical provenance. The conformance workflow no longer downloads the artifact from another repository; it checks this frozen copy directly so the proof reproduction path remains stable if repository names, branches, or source layouts change.

## Scope

The artifact is one selected serialized `Assertion` transition:

```text
same Assertion id
supported, version 7
    ->
revalidation-required, version 8
```

Lean owns the restricted B0 projection and checker. This artifact does not establish full runtime refinement, verify all runtime transitions, prove external-domain adequacy, or make this repository a runtime dependency.

The authoritative research scope and trust boundary remain `RESEARCH_STATE.md`, `STRICT_LEVEL6_TECHNICAL_AUDIT.md`, and `CROSS_REPO_RELATION.md`.
