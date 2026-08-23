# Related-work positioning matrix

This matrix is a drafting aid for the first paper. It is intentionally comparative rather than adversarial: the point is to identify the precise theorem-level distinction of the present work without claiming that prior systems ignored provenance, current state, retraction, revocation, or proof-relevant evidence.

The comparison axes are:

1. **persistent derivation / provenance** — whether the cited result explicitly preserves reasons, assumptions, proofs, or derivation annotations;
2. **mutable current state** — whether authorization, belief, or validity can depend on state that changes over time;
3. **explicit qualification / revalidation** — whether a separate check or transition establishes present validity after historical/proof construction;
4. **reachable-state semantics** — whether the cited result centers an explicit transition-generated state space rather than only a static judgment or abstract update operator;
5. **formation responsibility ≠ current responsibility** — whether the cited result explicitly separates obligations consumed when a derivation object is formed from obligations consumed later when that object becomes currently usable.

The last column is the narrowest and is the intended positioning axis for this paper. Every comparison is relative to the cited core result, not an exhaustive statement about an entire research tradition.

| Line of work | Persistent derivation / provenance | Mutable current state | Explicit qualification / revalidation | Reachable-state semantics | Formation responsibility ≠ current responsibility |
| --- | --- | --- | --- | --- | --- |
| Assumption-Based Truth Maintenance Systems (de Kleer 1986) | **Central.** Nodes are associated with assumption environments / justification structure. | **Yes, in a broad belief-maintenance sense.** Context switching, inconsistency management, and retraction are core concerns. | **Partial analogue.** Maintenance of supported environments determines what is currently supported, but not through this paper's historical-warrant / evaluation-key split. | **Different formal center.** The cited architecture maintains changing assumption environments rather than this kernel's `InitialBoundary / Step / Reachable` invariant package. | **Related but not identical.** ATMS is a major predecessor for separating stored justification structure from changing support conditions; the present theorem is specifically about immutable warrant history versus a later `LIVE/PLACED` qualification transition. |
| Database provenance / provenance semirings (Green, Karvounarakis, Tannen 2007) | **Central.** Provenance annotations represent how query results depend on input data. | **Not the primary theorem axis in the cited semiring result.** Later provenance work studies updates, but the 2007 core result is mainly derivational explanation. | **The cited core result does not focus on a separate current-usability transition.** | **Different formal center.** Query/provenance semantics rather than this kernel's reachable canonical-state invariant. | **The cited core result does not establish this lifecycle decomposition.** The present novelty is not storing provenance; it is separating a persistent derivation relation from a distinct current qualification relation and proving the two-step lifecycle. |
| Justification Logic (Artemov 2008) | **Central, proof-relevant.** Assertions `t : F` put justification objects in the logical language. | **Not the principal focus of the cited core framework.** | **Different object.** Justification terms witness formulas; the current artifact instead stores historical warrant objects separately from mutable evaluation qualification. | **The cited core result does not center kernel reachability.** | **The cited result is not a lifecycle theorem of the present form.** The present work should not claim novelty for proof-relevant evidence; its narrower result is the transition-level separation of historical obligations from current usable-parent obligations. |
| Dynamic justification/evidence logics (Bucheli, Kuznets, Studer 2014; Baltag, Renne, Smets 2012/2014) | **Yes.** Explicit reasons/evidence remain part of the logical account. | **Central.** Public announcements, evidence introduction, evidential upgrade/update, availability, admissibility, and defeasible belief/knowledge make evidence state dynamic. | **Strong conceptual neighbor.** These systems explicitly combine reasons with epistemic/evidential change. | **Dynamic semantics is central**, though expressed through logical/model update rather than this kernel's immutable lookup plane plus evaluation setter transitions. | **The cited results do not focus on the same dependency-object decomposition.** Our claim is not novelty for dynamically revisable explicit evidence; it is that one persistent ordered parent relation is later re-read by a current `Usable(S_pre,k_parent)` premise while historical formation obligations remain carried by immutable history. |
| Proof-Carrying Authentication (Appel & Felten 1999) | **Central.** Requests carry checkable logical proofs/certificates. | **Policy and credential environments may vary, but the cited contribution centers proof-carrying authorization rather than this paper's historical/evaluation split.** | **Yes, as request-time proof checking.** | **Different formal center.** | **Strong neighbor.** PCA already makes authorization responsibility explicit in proof objects. The present distinction is not proof carrying itself; it is a persistent historical parent relation plus a later current predicate over those same parent identities. |
| Explicit-time / stateful authorization logic and PCFS (DeYoung, Garg, Pfenning 2008; Garg & Pfenning 2010, 2012) | **Yes.** Authorization proofs and certificates are explicit objects. | **Central.** Policy consequences may depend on time and external system state. | **Central analogue.** PCFS separates proof verification from later checking of time/state conditions through conditional capabilities. | **State is explicit, but the formal center is authorization proof theory/enforcement rather than this paper's immutable warrant history plus evaluation transition system.** | **Closest security neighbor.** The paper must not claim to be the first to separate proof construction from current-state checking. The present result instead fixes which persistent parent identities belong to the historical child and later evaluates a time-indexed usability predicate over those same identities. |
| Revocable/use-once PCFS (Morgenstern, Garg, Pfenning 2011) | **Yes.** Authorization still requires explicit proof objects and policy certificates. | **Central.** Revocation lists and use-once certificate state are maintained in a database consulted during file access. | **Central analogue.** Mutable credential state is checked at access time. | **Operational state is explicit at enforcement time**, but the cited contribution centers revocable/use-once authorization rather than the present historical-warrant/evaluation-key invariant. | **Very strong neighbor.** The cited result shows that persistent proof material can coexist with mutable credential state. Our narrower claim is the machine-checked separation between an immutable ordered derivation-parent relation and a later qualification premise applying current usability to those same parent identities. |
| AGM belief revision and Dynamic Epistemic Logic (Alchourrón, Gärdenfors, Makinson 1985; van Ditmarsch, van der Hoek, Kooi 2007) | **Varies.** Classical AGM belief sets generally abstract away explicit derivation reasons; richer epistemic/evidential models may retain more structure. | **Central.** Belief states/models change under revision or epistemic actions. | **State update is central, but not as this historical-warrant qualification API.** | **Dynamic semantics is central**, though usually as belief/model transformers rather than this kernel's canonical referent/evaluation invariant. | **Different question in the cited core results.** The present work freezes canonical derivation history and asks which current evaluation transition may make an already formed object usable. |

## Positioning conclusion

The paper should **not** claim any of the following as novelty:

- preserving derivation provenance;
- representing justification objects explicitly;
- dynamically revising explicit evidence;
- allowing authorization to depend on mutable state or time;
- performing staged or request-time proof checking;
- combining persistent proof material with revocation/use-once credential state;
- modeling belief/state change;
- supporting retraction or context switching in general.

A defensible novelty statement is narrower:

> **Within one mechanized finite kernel, immutable canonical warrant history, mutable current qualification, and branch-local entitlement observations are separate interfaces. ROOT and INFER make the separation transition-visible. In particular, ordinary INFER formation permanently records an ordered historical parent relation and discharges exact rule/typing/guard/context/scope/strength/lineage obligations without consuming parent usability. Later qualification applies the time-indexed predicate `Usable(S_pre,k_parent)` to those same historical parent identities and establishes child usability without replaying formation.**

The key comparison object is therefore not merely “proof now, state check later.” It is:

\[
\underbrace{ParentOf(p,d)}_{\text{persistent historical relation}}
\qquad\text{versus}\qquad
\underbrace{Usable(S_{pre},k_p)}_{\text{time-indexed current predicate}}
\]

applied to the same parent identities but at different responsibility boundaries.

This supports the theorem-facing slogans:

```text
canonical history ≠ current usability
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
- Samuel Bucheli, Roman Kuznets, Thomas Studer. **Realizing Public Announcements by Justifications.** *Journal of Computer and System Sciences* 80(6):1046–1066, 2014. DOI: `10.1016/j.jcss.2014.04.001`.
- Alexandru Baltag, Bryan Renne, Sonja Smets. **The Logic of Justified Belief Change, Soft Evidence and Defeasible Knowledge.** *WoLLIC 2012*, LNCS 7456, pp. 168–190. DOI: `10.1007/978-3-642-32621-9_13`.
- Alexandru Baltag, Bryan Renne, Sonja Smets. **The Logic of Justified Belief, Explicit Knowledge, and Conclusive Evidence.** *Annals of Pure and Applied Logic* 165(1):49–81, 2014. DOI: `10.1016/j.apal.2013.07.005`.
- Andrew W. Appel, Edward W. Felten. **Proof-Carrying Authentication.** *CCS 1999*, pp. 52–62. DOI: `10.1145/319709.319718`.
- Henry DeYoung, Deepak Garg, Frank Pfenning. **An Authorization Logic with Explicit Time.** *CSF 2008*. DOI: `10.1109/CSF.2008.15`.
- Deepak Garg, Frank Pfenning. **A Proof-Carrying File System.** *IEEE Symposium on Security and Privacy 2010*, pp. 349–364. DOI: `10.1109/SP.2010.28`.
- Jamie Morgenstern, Deepak Garg, Frank Pfenning. **A Proof-Carrying File System with Revocable and Use-Once Certificates.** *STM 2011*, LNCS. Revocation lists and use-once certificates are maintained in a database consulted during file access.
- Deepak Garg, Frank Pfenning. **Stateful Authorization Logic—Proof Theory and a Case Study.** *Journal of Computer Security* 20(4):353–391, 2012.
- Carlos E. Alchourrón, Peter Gärdenfors, David Makinson. **On the Logic of Theory Change: Partial Meet Contraction and Revision Functions.** *Journal of Symbolic Logic* 50(2):510–530, 1985. DOI: `10.2307/2274239`.
- Hans van Ditmarsch, Wiebe van der Hoek, Barteld Kooi. **Dynamic Epistemic Logic.** Springer, 2007. DOI: `10.1007/978-1-4020-5839-4`.

## Source-reading notes

The matrix is based on the cited original/authoritative descriptions above, not on a claim of exhaustive coverage. Negative comparisons are intentionally scoped to the cited result: phrases such as “the cited core result does not focus on this lifecycle decomposition” should not be strengthened into claims about an entire research tradition without a broader survey. Before submission, the bibliography may still be expanded where a descendant result directly bears on the theorem-level distinction.
