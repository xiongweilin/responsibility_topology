# Cross-Repository Relation Contract

This document defines the relationship between:

- `xiongweilin/responsibility_topology` — Lean-centered formal kernels and paper-specific theorem surfaces;
- `xiongweilin/portable-runtime` — framework documentation, record semantics, operational/runtime mechanisms, revision/revalidation/reopen workflows, and engineering implementation.

The relation is intentionally **not** stated as implementation equality or verified refinement.

## Vocabulary

The contract reuses the Framework V1.0 call relations from `portable-runtime/docs/responsibility-topology-overview.md`:

| Relation | Meaning here |
| --- | --- |
| `reference` | use an upstream concept without changing its meaning |
| `boundary-reference` | import only a responsibility boundary or handoff condition |
| `specialize` | make an upstream concept precise for the formal kernel's narrower object model |
| `operationalize` | turn a theoretical responsibility into a runtime/procedural responsibility without redefining the theory |
| `represent` | encode theory/practice facts into record structures without making the record schema the theory definition |
| `handoff` | explicitly transfer responsibility to another layer, module, or procedure |

The governing rule is:

```text
call != redefinition
```

Definition ownership, evidence ownership, and operational-fact ownership remain separate.

## Current relation

### Theory/framework to formal kernel

```text
portable-runtime framework/theory documents
    --reference / boundary-reference / specialize-->
responsibility_topology formal objects and relations
```

The Lean repository may specialize a broad responsibility idea into a finite, typed theorem object. A theorem about that specialization does not automatically prove the upstream framework concept in every domain.

### Theory/practice to runtime

```text
portable-runtime theory/practice
    --operationalize / represent-->
portable-runtime records, authorization, revision, revalidation, reopen, recovery
```

Runtime facts are evidence about implemented behavior. They do not redefine the theoretical concepts they represent.

### Formal kernel to runtime

There is currently **no** declared refinement relation:

```text
responsibility_topology
    -/-> verified refinement of portable-runtime
```

and no reverse refinement claim either.

The repositories are presently related by conceptual specialization, selected conformance evidence, and shared responsibility boundaries—not by a theorem equating their state spaces or transition systems.

## Known semantic non-identity

A concrete example is dependency propagation after change.

Paper 3 formal challenge semantics use a specialized historical warrant graph:

```text
Affected(S,t,w)
:=
(w = t) or DescendantOf(S,t,w)
```

where `DescendantOf` is transitive closure over canonical warrant-parent history.

`portable-runtime` also has direct typed dependency-impact mechanisms whose generic policy is not “recursively invalidate the entire graph.” Therefore these should never be documented as the same transition semantics.

Safe statement:

> Both systems preserve a separation between recorded/historical dependency and mutable current qualification, but they instantiate dependency propagation differently.

Unsafe statement:

> The Lean challenge semantics verify the runtime revalidation engine.

## Future refinement shape

If a formal bridge is attempted later, the default target should be observational abstraction/refinement rather than state equality.

Preferred shape:

```text
alpha : RuntimeState -> FormalObservation
```

with a theorem family such as:

```text
RuntimeStep(r, r')
->
FormalStep* (alpha r) (alpha r')
```

or a weaker observational correspondence over a selected interface.

The bridge should specify explicitly:

1. which runtime records/states are observed;
2. which Lean objects those observations map to;
3. which runtime transitions are covered;
4. whether one runtime step maps to zero, one, or many formal steps;
5. which observations are preserved, reflected, or merely simulated;
6. what is intentionally abstracted away;
7. which dependency policy differences require separate formal models rather than forced alignment.

Do **not** target literal:

```text
LeanState = PythonState
```

unless the models are first redesigned to make that identity meaningful.

## Responsibility boundaries

The cross-repository bridge must keep at least these responsibilities separate:

```text
definition ownership
!= specialization ownership
!= evidence ownership
!= operational fact ownership
```

and:

```text
historical/provenance record
!= current qualification
!= authorization/action
```

The runtime can provide executable evidence for a mechanism; the Lean kernel can prove properties of a formal abstraction; neither alone establishes empirical truth, normative adequacy, or responsibility-model adequacy.

## Program-level open questions

This contract deliberately leaves three future research lines open:

1. **Cross-domain invariance** — which formal responsibility structures survive specialization into other domains?
2. **Runtime/refinement bridge** — which runtime observations admit a useful formal correspondence?
3. **Q_open / responsibility-model adequacy** — when is the system entitled to reopen the vocabulary or cut model used by both theory and runtime?

The third cannot be solved merely by proving a stronger implementation relation. A perfectly refined implementation can still implement an inadequate responsibility model.

## Change rule

Any future document claiming `refines`, `implements exactly`, `verified runtime`, `complete dependency extraction`, or an equivalent strong relation must cite a concrete theorem/artifact establishing that relation. Until then, the permitted vocabulary is `reference`, `boundary-reference`, `specialize`, `operationalize`, `represent`, `handoff`, conceptual alignment, and selected conformance.