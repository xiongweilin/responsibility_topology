# Related-work positioning matrix

This matrix is a drafting aid for the first paper. It is intentionally comparative rather than adversarial: the point is to identify the precise theorem-level distinction of the present work without claiming that prior systems ignored provenance, current state, retraction, or proof-relevant evidence.

The comparison axes are:

1. **persistent derivation / provenance** — whether the approach explicitly preserves reasons, assumptions, proofs, or derivation annotations;
2. **mutable current state** — whether authorization, belief, or validity can depend on state that changes over time;
3. **explicit qualification / revalidation** — whether a separate check or transition establishes present validity after historical/proof construction;
4. **reachable-state semantics** — whether the work centers an explicit transition-generated state space rather than only a static judgment or abstract update operator;
5. **formation responsibility ≠ current responsibility** — whether the formal result explicitly separates obligations consumed when a derivation object is formed from obligations consumed later when that object becomes currently usable.

The last column is the narrowest and is the intended positioning axis for this paper.

| Line of work | Persistent derivation / provenance | Mutable current state | Explicit qualification / revalidation | Reachable-state semantics | Formation responsibility ≠ current responsibility |
| --- | --- | --- | --- | --- | --- |
| Assumption-Based Truth Maintenance Systems (de Kleer 1986) | **Central.** Nodes are associated with assumption environments / justification structure. | **Yes, in a broad belief-maintenance sense.** Context switching, inconsistency management, and retraction are core concerns. | **Partial analogue.** Maintenance of supported environments determines what is currently supported, but not through this paper's historical-warrant / evaluation-key split. | **Not the same object.** The architecture maintains changing assumption environments rather than this kernel's `InitialBoundary / Step / Reachable` invariant package. | **Related but not identical.** ATMS is a major predecessor for separating stored justification structure from changing support conditions; the present theorem is specifically about immutable warrant formation versus a later `LIVE/PLACED` qualification transition. |
| Database provenance / provenance semirings (Green, Karvounarakis, Tannen 2007) | **Central.** Provenance annotations represent how query results depend on input data. | **Not the primary theorem axis in the seminal semiring result.** Later provenance work studies updates, but provenance itself is mainly derivational explanation. | **No direct analogue in the core result.** Provenance describes derivation/dependency rather than a separate current-usability transition. | **Usually query/update semantics rather than this kernel's reachable operational state invariant.** | **No direct lifecycle theorem of this form.** The present novelty is not storing provenance; it is separating derivation provenance from a distinct current qualification relation and proving the two-step lifecycle. |
| Justification Logic (Artemov 2008) | **Central, proof-relevant.** Assertions `t : F` put justification objects in the logical language. | **Not the principal focus of the core framework.** | **Not the same separation.** Justification terms witness formulas; the current artifact instead stores historical warrant objects separately from mutable evaluation qualification. | **No corresponding kernel reachability claim is needed for the core justification-logic results.** | **No direct analogue claimed.** The present work should not claim novelty for proof-relevant evidence; its narrower result is the transition-level separation of formation obligations from current usable-parent obligations. |
| Proof-Carrying Authentication (Appel & Felten 1999) | **Central.** Requests carry checkable logical proofs/certificates. | **Policy and credential environments may vary, but the original contribution centers proof-carrying authorization rather than this paper's historical/evaluation split.** | **Yes, as request-time proof checking.** | **Not the same reachable canonical-history model.** | **Strong neighbor.** PCA already makes authorization responsibility explicit in proof objects. The present distinction is that an immutable historical derivation may exist without current usability, and current qualification consumes a different pre-state responsibility without replaying formation. |
| Explicit-time / stateful authorization logic and PCFS (DeYoung, Garg, Pfenning 2008; Garg & Pfenning 2010, 2012) | **Yes.** Authorization proofs and certificates are explicit objects. | **Central.** Policy consequences may depend on time and external system state. | **Central analogue.** PCFS separates proof verification from later checking of time/state conditions through conditional capabilities. | **State is explicit, but the formal center is authorization proof theory/enforcement rather than this paper's immutable warrant history plus evaluation transition system.** | **Closest security neighbor.** The paper must not claim to be the first to separate proof construction from current-state checking. Its narrower result is the machine-checked ROOT/INFER lifecycle in which formation and qualification consume different predicates, with INFER qualification requiring current usable parents while not replaying rule/guard/lineage formation. |
| AGM belief revision and dynamic epistemic logic (Alchourrón, Gärdenfors, Makinson 1985; van Ditmarsch, van der Hoek, Kooi 2007) | **Varies.** Classical AGM belief sets generally abstract away explicit derivation reasons; foundational approaches and richer epistemic models may retain more structure. | **Central.** Belief states/models change under revision or epistemic actions. | **State update is central, but not as a historical-warrant qualification API.** | **Dynamic semantics is central**, though usually as belief/model transformers rather than this kernel's canonical referent/evaluation invariant. | **Different question.** Belief revision studies rational change of epistemic state; the present work freezes canonical derivation history and asks which current evaluation transition may make an already formed object usable. |

## Positioning conclusion

The paper should **not** claim any of the following as novelty:

- preserving derivation provenance;
- representing justification objects explicitly;
- allowing authorization to depend on mutable state or time;
- performing request-time proof checking;
- modeling belief/state change;
- supporting retraction or context switching in general.

A defensible novelty statement is narrower:

> **Within one mechanized finite kernel, immutable canonical warrant formation, mutable current qualification, and branch-local entitlement observations are separate interfaces. ROOT and INFER make the separation transition-visible. In particular, ordinary INFER formation consumes exact rules and historical parents but not their current usability, whereas later qualification consumes the pre-state usability of those same historical parents without replaying rule lookup, typing, guards, context acceptance, scope, strength, or lineage formation.**

This supports the theorem-facing slogans:

```text
Canonical historical formation ≠ current usability
```

and, for ordinary INFER:

```text
historical derivation relation ≠ current usable-parent responsibility
```

The paper should describe this as a particular responsibility decomposition, not as a claim that neighboring literatures conflate history and current validity.

## Bibliographic anchors

- Johan de Kleer. **An assumption-based TMS.** *Artificial Intelligence* 28(2):127–162, 1986. DOI: `10.1016/0004-3702(86)90080-9`.
- Todd J. Green, Grigoris Karvounarakis, Val Tannen. **Provenance Semirings.** *PODS 2007*, pp. 31–40. DOI: `10.1145/1265530.1265535`.
- Sergei Artemov. **The Logic of Justification.** *The Review of Symbolic Logic* 1(4):477–513, 2008. DOI: `10.1017/S1755020308090060`.
- Andrew W. Appel, Edward W. Felten. **Proof-Carrying Authentication.** *CCS 1999*, pp. 52–62. DOI: `10.1145/319709.319718`.
- Henry DeYoung, Deepak Garg, Frank Pfenning. **An Authorization Logic with Explicit Time.** *CSF 2008*. DOI: `10.1109/CSF.2008.15`.
- Deepak Garg, Frank Pfenning. **A Proof-Carrying File System.** *IEEE Symposium on Security and Privacy 2010*, pp. 349–364. DOI: `10.1109/SP.2010.28`.
- Deepak Garg, Frank Pfenning. **Stateful Authorization Logic—Proof Theory and a Case Study.** *Journal of Computer Security* 20(4):353–391, 2012.
- Carlos E. Alchourrón, Peter Gärdenfors, David Makinson. **On the Logic of Theory Change: Partial Meet Contraction and Revision Functions.** *Journal of Symbolic Logic* 50(2):510–530, 1985. DOI: `10.2307/2274239`.
- Hans van Ditmarsch, Wiebe van der Hoek, Barteld Kooi. **Dynamic Epistemic Logic.** Springer, 2007. DOI: `10.1007/978-1-4020-5839-4`.

## Source-reading notes

The matrix is based on the original/authoritative descriptions above, not on a claim of exhaustive coverage. Before submission, the bibliography should be expanded to include the most directly relevant descendant work on truth maintenance, provenance under updates, revocable proof-carrying authorization, and evidential/dynamic epistemic logics. The comparison wording should be revisited against those papers rather than strengthened by absence-of-evidence arguments.
