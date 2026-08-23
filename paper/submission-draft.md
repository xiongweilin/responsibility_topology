# Separating Canonical History from Current Usability in a Finite Epistemic Kernel

_Status: submission-facing architecture draft. The theorem surface is frozen at R1–R9. This document reorganizes and compresses the #21 research draft; it introduces no new formal claim, transition, or temporal closure._

## Abstract

Finite evidence-processing systems must distinguish two questions about the same object: whether it has a canonical historical formation, and whether it is currently usable in a particular evaluation environment. We mechanize that distinction in Lean 4 for a finite kernel with immutable canonical history and a separate mutable evaluation plane. Historical warrants record formation context, profile, constructor, ordered parents, and lineage. Current usability is indexed by an exact `(profile, context, use, warrant)` key and requires `LIVE` together with `PLACED`. A separate static entitlement calculus then consumes usable canonical warrants together with exact requirement discharge, ambient admissibility, and kernel-floor safety.

The paper has three contribution families. First, Relative Branch Conservativity and supporting exact-resolution/projection results localize static entitlement responsibility. Second, an explicit `InitialBoundary / Step / Reachable` model preserves a shared invariant separating immutable historical referents from mutable evaluation state. Third, ROOT and ordinary INFER make the historical/current distinction transition-visible. ROOT formation creates history without usability; admission later qualifies an exact key. Ordinary INFER formation resolves an exact rule and ordered historical parent occurrences without requiring current parent usability. Later qualification has a different premise set: it preserves the historical referent, does not re-check the rule/typing/guard/context/scope/strength/lineage premises of formation, requires the same historical parent identities to be usable in the qualification pre-state, and establishes child usability in the post-state.

The contribution is deliberately narrower than provenance, truth maintenance, dynamic evidence, or stateful authorization in general. It is a machine-checked decomposition in one reachable finite kernel between persistent historical relations, time-indexed current responsibility, and branch-local entitlement observations. The artifact does not prove profile adequacy, kernel-floor adequacy, source authenticity, Python operational refinement, a reachable Adopt/license lifecycle, TRANSPORT, temporal revalidation closure, or an end-to-end theorem from arbitrary reachable state directly to entitlement.

# 1. Introduction

A persistent derivation record and the kernel's current usability predicate are different semantic objects. A system may need to preserve exactly how a warrant was formed while separately changing whether that same warrant satisfies the current evaluation predicate under a particular profile, context, and use. Collapsing those questions into a single field such as `valid`, `trusted`, or `accepted` hides which modeled responsibility was checked at which boundary.

This paper studies a deliberately finite kernel in which the split is explicit and machine checked. The state-level thesis is:

\[
\boxed{
\text{canonical history} \neq \text{current usability}
}
\]

and the transition-level thesis is:

\[
\boxed{
\text{historical formation} \neq \text{current qualification}.
}
\]

For ordinary INFER, the result is more specific:

\[
\boxed{
\text{historical parent occurrence relation}
\neq
\text{current usable-parent predicate}.
}
\]

The same parent identities participate at different responsibility boundaries. Formation records ordered parent occurrences and checks the modeled rule, typing, guard, context, scope, strength, and lineage conditions. Qualification later evaluates a time-indexed usability predicate over those stored parent identities. The qualification transition preserves the historical referent and does not re-check the formation premises; those formation facts remain part of immutable reachable history rather than becoming irrelevant.

The paper keeps four layers separate. **Canonical history** records immutable referents and formation structure. **Current evaluation** records time-indexed usability at exact evaluation keys. **Entitlement** additionally requires exact requirement discharge, ambient admissibility, and kernel-floor safety. **Adequacy**—whether the finite regime itself is substantively sufficient—remains outside the theorem surface.

Accordingly, this paper does not claim that current usability alone yields entitlement: the definition of entitlement additionally requires ambient admissibility, exact requirement derivability, and kernel-floor safety. Nor does correct execution of the modeled profile or kernel establish substantive profile or kernel-floor adequacy; those adequacy questions lie outside the present formal vocabulary.

### Contributions and anchors

The submission uses one primary anchor for each contribution family.

1. **Static entitlement locality — Theorem R1.** Relative Branch Conservativity fixes the branch, exact requirement boundary, floor semantics, license type, and move, and shows that observations outside the branch-local satisfaction and floor footprint cannot change entitlement under the stated ambient premises. R2 and R3 support exact requirement identity and coherent canonical projection but are not separate headline contributions.

2. **Reachable canonical-state coherence — Theorem R4.** Every state generated from the explicit initial boundary by the modeled `Step` relation satisfies one shared invariant separating immutable historical referents from mutable evaluation records. R5 is an orthogonal currentness result; it is not presented as a completed reachable Adopt lifecycle.

3. **Formation/qualification separation — Figure 1, Table 1, and R6–R9.** ROOT exposes the minimal history/usability split. INFER then shows that historical parent occurrence and current usable-parent responsibility are distinct relations over the same stored parent identities.

The Python implementation is an executable reference and differential-conformance target, not a fourth theoretical contribution and not a verified implementation.

# 2. Model and Running Trace

## 2.1 Paper notation

We write canonical states as \(\sigma,\sigma',\sigma_0,\sigma_1,\sigma_2\); a profile digest as \(\pi\); context as \(c\); use as \(u\); warrant identifiers as \(w,p,d\); a historical warrant object as \(W\); an ordered parent-ID list as \(P\); ordered resolved parent objects as \(\bar W\); ambient view as \(A\); satisfaction environment as \(E\); floor environment as \(F\); floor semantics as \(\Phi\); and a discharge branch as \(\beta\).

One transition arrow denotes exactly one `Step`:

\[
\boxed{
\sigma \xrightarrow{e} \sigma'
\;:\!\iff\;
Step(\sigma,e,\sigma').
}
\]

No arrow in this paper denotes reflexive-transitive closure.

Historical existence is written informally as

\[
Hist_{\sigma}(w,W)
\quad\text{iff}\quad
\sigma.warrant(w)=some\;W.
\]

Current usability is keyed by

\[
k=(\pi,c,u,w)
\]

and is exactly

\[
Usable(\sigma,k)
\iff
\sigma.epi(k)=LIVE
\land
\sigma.placement(k)=PLACED.
\]

## 2.2 Figure 1 — running lifecycle and two relation layers

```text
                         canonical historical layer

σ0 ── form ROOT p1,p2 ──▶ σ1 ── admit p1,p2 ──▶ σ2 ── INFER d from [p1,p2] ──▶ σ3 ── qualify d ──▶ σ4
                               │                         │                              │
                               │                         │                              │
                               │                         └── historical edges: p1,p2 ─▶ d
                               │                                                (persist)
                               │
                               └── p1,p2 historical

                         current evaluation layer

σ1:  ¬Usable(k_p1) ∧ ¬Usable(k_p2)
σ2:   Usable(k_p1) ∧  Usable(k_p2)
σ3:   Hist(d,W_d) ∧ ¬Usable(k_d)
      qualification premise reads: Usable(σ3,k_p1) ∧ Usable(σ3,k_p2)
σ4:   Usable(σ4,k_d)
```

**Figure 1.** The historical child appears at \(\sigma_3\) before it becomes usable. The parent edges are persistent historical relations. Parent usability is a predicate of the qualification pre-state and exact evaluation environment. The trace stops at \(\sigma_4\); no suspension, invalidation, revalidation, Adopt, TRANSPORT, or arbitrary temporal path is represented.

The trace admits the roots before INFER only for readability. That ordering is not a formation premise: R7 does not require current parent usability. Current usable-parent responsibility begins at qualification.

## 2.3 Table 1 — transition responsibility cut

| Boundary | Requires / checks now | Establishes | Does not re-check |
| --- | --- | --- | --- |
| **ROOT formation** | fresh warrant; canonical binding/context; context acceptance | exact immutable ROOT history | current usability; admission metadata |
| **ROOT admission** | existing ROOT; exact formation profile/context relation; requested use agreement | child `LIVE/PLACED` at the exact key | ROOT formation acceptance |
| **INFER formation** | fresh child; exact binding/profile/rule; canonical context; ordered canonical parent occurrences; `InferFormationDiscipline` | exact immutable historical child; ordered parent identities; root/source lineage | current parent usability |
| **INFER qualification** | existing historical INFER child; recorded formation profile/context; pre-state usability of the stored parent identities | exact child `LIVE/PLACED` at `(profile,context,use,warrant)` | rule lookup; typing; guard; output acceptance; scope/strength checks; lineage construction |

**Table 1.** The table states responsibility boundaries, not resource consumption. `Usable` is an idempotent predicate at an evaluation key; repeated parent occurrences do not create use-once or linear consumption semantics. “Does not re-check” means only that those premises are absent from the later transition; the corresponding formation facts remain encoded in immutable history and are not declared unimportant or invalid.

# 3. Static Entitlement Locality

The dynamic lifecycle explains how current usability can arise. It does not by itself establish entitlement. The static layer isolates the observations consumed by one fixed licensing judgment.

For floor semantics \(\Phi\), ambient view \(A\), satisfaction environment \(E\), floor environment \(F\), branch \(\beta\), license type \(\tau\), and move \(m\):

\[
Entitled(\Phi,A,E,F,\beta,\tau,m)
\;:\!\iff\;
Admissible(A)
\land
Derives(E,\beta,A.requirement)
\land
Safe(\Phi,F,\beta,\tau,m).
\]

### Theorem R1 — Relative Branch Conservativity

For fixed \(\Phi,\beta,\tau,m,R\), if both ambient views are admissible and resolve to the same exact requirement \(R\), the satisfaction environments agree on observations read by \(\beta\), and the floor environments agree on floor observations read by \(\beta\), then:

\[
\boxed{
Entitled(\Phi,A,E,F,\beta,\tau,m)
\iff
Entitled(\Phi,A',E',F',\beta,\tau,m).
}
\]

R1 is branch-relative and exact-requirement-relative. It does not establish that the requirement, ambient regime, profile, or floor is adequate.

R2 fixes requirement identity by exact license type plus full move identity; missing declaration is distinct from explicitly declaring `top`. R3 proves that satisfaction and floor projections of a canonical licensing read use the same underlying warrant object. These results prevent hidden broadening of the observation boundary but remain supporting results in the submission hierarchy.

# 4. Reachable Canonical Kernel

The dynamic state has immutable lookup families for contexts, profiles, bindings, historical warrants, and represented licenses, together with mutable currentness/evaluation structures. `Reachable` begins at an explicit empty `InitialBoundary` and advances only through the modeled event surface:

```text
registerContext
registerProfile
bindProfile
bootstrapContext
root
admitRoot
infer
qualifyInfer
```

### Theorem R4 — Reachable canonical-state invariance

\[
\boxed{
Reachable(\sigma)
\Rightarrow
CanonicalStateInvariant(\sigma).
}
\]

The invariant packages canonical binding/profile/context referents, historical warrant referent coherence, canonical parents and lineages, ROOT/INFER historical well-formedness, evaluation referent coherence, paired evaluation axes, and profile/use binding backing.

The historical identity law has object-level content: if a warrant identifier denotes \(W\) before one modeled step, it denotes the same \(W\) afterward. Qualification can therefore change evaluation without changing the historical referent being evaluated.

R5 supplies an orthogonal grounded-currentness semantics in which grounded adopted contexts terminate in an explicit bootstrap chain and a pure activation cycle cannot generate its own currentness. The current `Step` relation does not, however, contain a reachable Adopt/license issuance lifecycle. R5 is therefore supporting semantic closure, not a second dynamic lifecycle claim.

# 5. ROOT: Minimal Formation/Qualification Separation

ROOT gives the smallest theorem-visible witness of the state split.

### R6a — fresh ROOT formation is non-usable

If \(\sigma\) is reachable and

\[
\sigma\xrightarrow{\operatorname{root}(w,b,c,x)}\sigma',
\]

then the fresh warrant has no evaluation record at any observed profile/context/use key and therefore is not usable at any such key. Reachability matters here because evaluation-referent coherence plus warrant freshness rules out a pre-existing evaluation entry for the new identifier; ROOT formation then preserves the evaluation plane.

### R6b — explicit admission establishes exact-key usability

If

\[
\sigma\xrightarrow{\operatorname{admitRoot}(w,b,c,u,meta)}\sigma',
\]

then the canonical binding witness fixes the exact profile digest and the post-state has `LIVE/PLACED` at the exact `(profileDigest,c,u,w)` key. Admission does not re-check the formation-time context acceptance premise.

The theorem-backed boundary used by the paper is therefore scoped as follows: reachable fresh ROOT formation yields non-usability of the fresh identifier at every evaluation key, while a valid explicit admission transition establishes usability at its exact post-state key. Recorded actor or basis metadata is not promoted into authentication or adequacy.

# 6. INFER: Historical Parents and Current Parent Responsibility

INFER is the central lifecycle result because one parent graph participates in two different relations.

### R7 — exact historical INFER formation

A single local formation step

\[
\sigma\xrightarrow{\operatorname{infer}(w,b,c,r,P,s)}\sigma'
\]

recovers a canonical binding, profile, context, exact rule, and ordered resolved parent objects \(\bar W\), together with exact rule lookup, `ResolvesParents(\sigma,P,\bar W)`, and `InferFormationDiscipline`. The post-state contains the exact historical child constructed from those inputs. R7 is deliberately local: it does **not** require `Reachable(\sigma)`.

`P` is an ordered parent-ID list; \(\bar W\) is the ordered list of resolved parent objects. Formation is occurrence-sensitive: order and duplicate occurrences remain part of derivational identity and rule-role checking. Root and source lineages are constructed by their separate role-wise unions.

R7 has no current parent-usability premise. A stronger fresh-child non-usability statement does require reachability, for the same evaluation-referent reason as ROOT.

### R8 — exact INFER qualification boundary

For a qualification step

\[
\sigma\xrightarrow{\operatorname{qualifyInfer}(w,b,c,u,meta)}\sigma',
\]

the pre-state contains the historical INFER warrant and binding witnesses with exact formation context/profile relations, and qualification requires

\[
InferParentsUsable(\sigma,B.profileDigest,c,u,W),
\]

where

\[
InferParentsUsable(\sigma,\pi,c,u,W)
\;:\!\iff\;
\forall p\in W.parents,\;Usable(\sigma,(\pi,c,u,p)).
\]

The selected child key is

\[
k_w=(B.profileDigest,c,u,w),
\]

and the post-state establishes

\[
\sigma'.epi(k_w)=LIVE
\land
\sigma'.placement(k_w)=PLACED,
\]

hence `Usable(\sigma',k_w)`.

Qualification is identity-sensitive with respect to currentness. If a parent identifier appears twice in the historical list, the current predicate asks for the same proposition twice; it does not model a linear or use-once credential.

### R9 — adjacent lifecycle separation

Let the formation and qualification call-site identifiers remain separately quantified. If

\[
Reachable(\sigma_0)
\]

and

\[
\sigma_0
\xrightarrow{\operatorname{infer}(w,b_f,c_f,r,P,s)}
\sigma_1
\xrightarrow{\operatorname{qualifyInfer}(w,b_q,c_q,u,meta)}
\sigma_2,
\]

then the historical child exists in \(\sigma_1\), the qualification pre-state requires current usability of its stored parent identities, the child is not usable at the exact child key in \(\sigma_1\), and the same key is usable in \(\sigma_2\).

Thus:

\[
\boxed{
Hist_{\sigma_1}(w,W)
\land
\neg Usable(\sigma_1,k_w)
\land
Usable(\sigma_2,k_w).
}
\]

R9 is an **adjacent two-step theorem**. It does not quantify over arbitrary intervening transitions and therefore does not establish temporal persistence. A future invalidation/revalidation theory would be required before such a statement could be made.

The contribution-level comparison is exactly:

\[
\underbrace{ParentOf(p,d)}_{\text{persistent historical relation}}
\qquad\text{versus}\qquad
\underbrace{Usable(\sigma_{pre},k_p)}_{\text{time-indexed current predicate}}.
\]

# 7. Executable Reference and Conformance Boundary

The repository includes a Python reference implementation and cross-language adapters. The executable path is used to compare selected Python observations with mechanized projection/currentness semantics. It is not a source-level refinement proof.

The supported claim is:

> Selected Python observations are differentially conformance-tested against the mechanized projection/currentness semantics.

The unsupported claim is:

> Python is verified.

No theorem shows that arbitrary Python runtime states refine `CanonicalState` or that every Python operation refines `Step` for all inputs.

# 8. Limits and Non-Theorems

The theorem regime is intentionally explicit.

| Boundary | Established | Not established |
| --- | --- | --- |
| Historical warrant | exact modeled formation shape; referent immutability; parent/lineage discipline | source authenticity; truth; epistemic adequacy |
| Rule/profile | exact lookup and structural discipline | rule/profile adequacy or completeness |
| Evaluation | exact-key `LIVE/PLACED`; referent coherence; binding backing | normative adequacy of use/admission basis |
| INFER qualification | pre-state usable-parent obligation and post-state child usability | permanent dependency invariant; later invalidation propagation |
| Grounded currentness | bootstrap-rooted semantic grounding; no pure self-support | reachable Adopt/license lifecycle; full Python refresh refinement |
| Entitlement | branch locality, exact requirement identity, coherent canonical projection | total `CanonicalState → LicensingRead → Entitled` assembly |
| Python | selected differential conformance | verified implementation / general operational refinement |
| Regime | correct execution of modeled finite rules | profile adequacy; kernel-floor adequacy |

The first-paper artifact does not include a total state-backed licensing-read assembly theorem, TRANSPORT, reachable Adopt/license issuance, challenge/revision/revalidation transitions, or temporal closure. Those absences are boundaries of the artifact, not implicit premises.

# 9. Related Work — submission baseline

Neighboring literatures already establish substantial parts of the surrounding conceptual landscape. Assumption-based truth maintenance preserves explicit justification/assumption structure while support conditions change. Database provenance explains dependency of derived results on inputs and has descendants that treat updates and transactional histories. Justification Logic and dynamic justification/evidence logics make reasons explicit and model evidence change. Proof-carrying and stateful authorization systems combine persistent proof/certificate material with mutable time, state, revocation, or use-once credential checks. Belief revision and dynamic epistemic logic study transformations of epistemic states.

The paper therefore does not claim novelty for provenance, explicit reasons, dynamically changing evidence, retraction, state-dependent authorization, staged proof/state checking, or revocable credentials. The narrower claim is the theorem-level decomposition inside one finite reachable kernel between:

\[
\boxed{
\text{persistent historical relation}
\neq
\text{time-indexed current responsibility}
}
\]

and, for ordinary INFER:

\[
\boxed{
\text{historical parent occurrence relation}
\neq
\text{current usable-parent predicate}.
}
\]

The descendant-literature boundary is frozen in `paper/novelty-freeze.md`. Later discoveries may force narrower wording, but they are not answered by broadening the R1–R9 theorem surface.

# 10. Conclusion and Frozen Extensions

The paper mechanizes a finite responsibility decomposition rather than a universal account of epistemic validity. Static entitlement has a branch-local observation boundary; reachable state separates immutable history from mutable evaluation; ROOT and INFER expose distinct formation and qualification transitions. INFER is the central case because the same stored parent identities participate first in a persistent historical relation and later in a time-indexed current-usability predicate.

The kernel remains frozen for the submission sequence. No total state-backed licensing-read assembly theorem, TRANSPORT, temporal-closure, or reachable Adopt/license semantics is added unless a hostile-review audit identifies an indispensable core sentence that cannot be honestly supported by the current theorem surface and cannot instead be removed or narrowed.
