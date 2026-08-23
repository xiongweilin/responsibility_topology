# Separating Canonical History from Current Usability in a Finite Epistemic Kernel

_Status: full working draft through the paper-facing formal exposition and INFER responsibility-cut pass. The theorem surface remains frozen at R1–R9; this pass changes no Lean or Python semantics._

## Abstract — revised working version

Finite evidence-processing systems must distinguish at least two questions: whether a warrant has a canonical formation or derivation history, and whether that warrant is currently usable in a particular evaluation environment. We mechanize this distinction in a finite kernel with immutable canonical history and a separate mutable evaluation plane. Historical warrants record formation context, profile, constructor, ordered parents, and role-indexed lineage. Current usability is instead defined by an explicit evaluation key and the conjunction of two mutable statuses. A separate static entitlement calculus then consumes usable canonical warrants together with exact requirement discharge, ambient admissibility, and kernel-floor safety.

The Lean 4 development establishes three result families. First, Relative Branch Conservativity, exact full-move requirement resolution, and canonical projection coherence locate entitlement responsibility on finite observation boundaries. Second, an explicit `InitialBoundary / Step / Reachable` system preserves one shared invariant separating immutable historical referents from mutable evaluation records. Grounded adopted-context currentness is treated as an orthogonal semantic component: it rules out purely self-supporting activation cycles, but the current reachable transition surface does not yet contain an Adopt lifecycle. Third, ROOT and ordinary INFER make the historical/current distinction transition-visible. Fresh formation creates canonical history without creating usability. For ordinary INFER, formation checks an exact rule and resolves ordered historical parent occurrences without requiring their current usability; later qualification does not replay rule, guard, scope, strength, or lineage formation, and instead requires those historical parent identities to be usable in the pre-state before making the child usable in the post-state.

The contribution is not provenance representation, staged proof checking, proof-carrying authorization, truth maintenance, revocable credential state, or dynamic epistemic/evidential update in general. Rather, it is a particular mechanized responsibility decomposition inside one finite reachable kernel: **canonical history and current usability are distinct state relations; historical formation and current qualification are distinct transitions governing those relations; and, for ordinary INFER, historical derivation and current usable-parent responsibility are distinct relations over the same parent identities.** The artifact does not prove profile adequacy, kernel-floor adequacy, source authenticity, Python operational refinement, or an end-to-end theorem from every reachable state directly to entitlement. The Python V0.1.2.2 implementation is used only for selected differential conformance tests against mechanized projection and currentness semantics.

---

# 1. Introduction

A system that stores evidence or derived judgments eventually faces two different questions about the same object. The historical question is: **under what canonical construction did this object enter the record?** The current question is: **may this object be relied on now, under this profile, context, and use?** The first concerns persistent derivation structure. The second concerns a time-indexed responsibility boundary.

The two questions are related, but they need not have the same answer. A derived object may remain part of an auditable historical graph even when it is no longer eligible for current use. Conversely, a current qualification decision should not silently rewrite the historical reason why the object exists. Collapsing these relations into one field such as `valid`, `trusted`, or `accepted` makes it difficult to tell which responsibility was discharged at which stage.

This paper studies a deliberately finite kernel in which the distinction is explicit and machine checked. The theorem-facing state thesis is:

\[
\boxed{
\text{Canonical history and current usability are distinct state relations.}
}
\]

The transitions governing those relations are likewise separated: historical formation creates or extends canonical history, while current admission/qualification changes the evaluation relation without rewriting historical identity.

For ordinary inference the result is sharper:

\[
\boxed{
\text{Historical derivation and current usable-parent responsibility are distinct relations.}
}
\]

These claims are narrower than a thesis about historical *justification* in the epistemological sense. A canonical historical warrant records what the kernel accepted as a well-formed formation event under a fixed finite regime. The mechanization does not prove that an external source was truthful, that a rule was substantively good, or that the profile and kernel floor together capture all conditions that ought to govern epistemic reliance.

## 1.1 Four responsibility layers

The development separates four layers.

The first is **canonical history**. Contexts, profiles, bindings, and warrants are immutable referents once installed under their identifiers. A historical warrant records claim, role, scope, constructor, ordered parents, formation profile, formation context, source where applicable, and separate root/source lineage relations.

The second is **current evaluation**. Current status is not a field of the historical warrant. It is indexed by

```text
(profileDigest, contextId, use, warrantId)
```

and represented on two orthogonal axes. In the current kernel,

\[
Usable(k)
\iff
Epi(k)=LIVE
\land
Placement(k)=PLACED.
\]

A historical object can therefore exist with no evaluation record at all, or with a non-usable evaluation state.

The third is **entitlement**. Usability is only one ingredient in canonical atomic satisfaction. The static entitlement judgment additionally requires an exact requirement, an admissible ambient environment, a recorded branch that discharges the requirement, and kernel-floor safety.

The fourth is **adequacy**. The formal model executes a finite regime; it does not prove that the regime is the right one. We keep two non-implications explicit:

\[
\boxed{
ProfileExecutionCorrectness
\not\Rightarrow
ProfileAdequacy
}
\]

and

\[
\boxed{
KernelCorrectness
\not\Rightarrow
KernelFloorAdequacy.
}
\]

The first paper proves properties of the first three layers and their narrow interfaces. It leaves the fourth outside the theorem regime.

## 1.2 From arbitrary observations to reachable state

A static theorem can be mathematically correct while hiding responsibility in supplied observations. If `usable(w)` or `contextActive(c)` is simply assumed, the theorem says little about why those observations should hold.

We therefore combine the static calculus with an explicit reachable canonical-state model. `Reachable` starts at an `InitialBoundary` and advances only through modeled `Step` constructors. A shared `CanonicalStateInvariant` ties bindings, profiles, contexts, warrants, parents, lineages, and evaluation records together while preserving exact historical referents.

This does not make every input endogenous. Grounded adopted-context currentness still factors out `baseCurrent`; the current `Step` surface has no Adopt or license-issuance lifecycle; and no total theorem yet assembles every reachable-state field into a complete `LicensingRead`. The point is not total closure. The point is that the remaining trust boundaries are explicit rather than hidden in unrelated Booleans.

## 1.3 The main lifecycle distinction

ROOT gives the simplest lifecycle. Formation creates a fresh historical warrant but does not write evaluation state. Explicit admission later establishes `LIVE/PLACED` at an exact key. Thus:

\[
\boxed{
ROOT\ Formation \not\Rightarrow Current\ Usability.
}
\]

Ordinary INFER makes the responsibility split more substantive. Historical formation checks an exact immutable rule and ordered historical parent occurrences, checks structural typing and guards, enforces same-context/same-profile formation, scope non-widening, and formal strength constraints, and constructs lineage. It deliberately does **not** require parent usability.

Qualification has a different contract. It starts from the already formed historical child, does not replay the formation proof, and requires every historical parent identity to be usable in the selected pre-state environment. It then establishes child usability in the post-state:

\[
\boxed{
HistoricalDerived
+
CurrentUsableParents_{pre}
+
ExplicitQualification
\Rightarrow
CurrentDerivedUsable_{post}.
}
\]

The derived object exists in the intermediate state while remaining non-usable there. This is the paper's central machine-visible boundary.

## 1.4 What is and is not new

Several mature literatures already cover neighboring ideas. Assumption-based truth maintenance preserves justification/assumption structure while supporting context-sensitive reasoning. Database provenance records how results depend on inputs. Justification Logic places justification objects inside the object language, and dynamic justification/evidence logics combine explicit reasons with epistemic change. Proof-carrying authentication makes authorization depend on checkable proofs. Stateful and explicit-time authorization logics, including the Proof-Carrying File System and its revocable/use-once extension, combine persistent proof/certificate material with mutable time, system, revocation, or certificate-use state. Belief revision and dynamic epistemic logic study transformations of epistemic states.

Accordingly, this paper does **not** claim novelty for provenance, proof-relevant evidence, dynamically revisable explicit evidence, staged proof/state checking, revocable credential state, retraction, state-dependent authorization, or epistemic update in general. Its narrower contribution is the combination of three interfaces in one mechanized finite kernel:

```text
immutable canonical history
        ≠
mutable current qualification
        ≠
branch-local entitlement observation
```

and, specifically for ordinary INFER, a theorem-level split over the same ordered parent identities: formation permanently records `ParentOf(p,d)` and discharges rule/guard/context/scope/strength/lineage obligations, while later qualification applies the time-indexed predicate `Usable(S_pre,k_p)` to those historical parents.

## 1.5 Contributions

The paper has three contribution families.

**(1) Static entitlement locality.** We prove Relative Branch Conservativity for a fixed branch and exact ambient requirement, formalize exact full-move requirement resolution, distinguish missing declarations from explicit `top`, and prove that satisfaction and floor projections of a derived branch read the same canonical warrant objects.

**(2) Reachable canonical history/evaluation state.** We define an explicit transition-generated state space and prove preservation of a shared canonical invariant that separates immutable historical referents from mutable evaluation. Grounded adopted-context currentness is included as a separate semantic component that rules out purely self-supporting activation cycles, without claiming a completed reachable Adopt lifecycle.

**(3) Historical formation/current qualification separation.** ROOT formation produces history without usability and admission later establishes usability. Ordinary INFER goes further: formation resolves and records ordered historical parent occurrences without requiring their current usability; qualification later requires pre-state parent usability over those parent identities without replaying historical formation obligations. The composed lifecycle theorem exposes the intermediate state in which the child is historically present but non-usable.

A Python V0.1.2.2 implementation accompanies the formalization as an executable reference and differential conformance target. It is not a fourth theoretical contribution and is not claimed to be verified.

## 1.6 Organization and current assembly boundary

Section 2 defines the four relations and introduces one running trace. Section 3 presents the static entitlement calculus. Section 4 introduces reachable state and the orthogonal grounded-currentness component. Sections 5 and 6 prove the ROOT and INFER lifecycle results. Section 7 states the executable conformance boundary. Section 8 collects non-theorems. Section 9 positions the contribution against neighboring literatures. Section 10 discusses extensions deliberately frozen during the first-paper window.

The artifact currently has narrow state-backed bridges for historical-warrant projection, usability, requirement snapshots, and activation reads, but no single total theorem

```text
CanonicalState → LicensingRead → Entitled.
```

The paper therefore does not claim that reachable state yields entitlement end-to-end. It claims that reachable state establishes historical and current-evaluation observations consumed by the separately proved entitlement layer.

---

# 2. Problem, Relations, and Running Example

The formal problem is easiest to state by separating four predicates that a single implementation field could otherwise collapse.

## 2.1 Historical existence

For a state `S`, a historical warrant identifier `w`, and a historical object `W`, write informally

\[
Hist_S(w,W)
\quad\text{for}\quad
S.warrant(w)=some\;W.
\]

This is an identity relation, not a current validity flag. The shared immutability theorem says that once a historical identifier denotes `W`, later modeled steps preserve that exact referent.

Historical formation therefore answers:

> What canonical object was formed, from which rule or source, under which formation context/profile, with which ordered parents and lineage?

It does not answer whether the object is currently usable.

## 2.2 Current evaluation and usability

Current evaluation is keyed by

\[
k=(profileDigest,contextId,use,warrantId).
\]

`Evaluated(S,k)` means both evaluation axes have records. `Usable(S,k)` is stronger:

\[
Usable(S,k)
\iff
S.epi(k)=LIVE
\land
S.placement(k)=PLACED.
\]

Thus:

\[
Usable \Rightarrow Evaluated,
\]

but neither

\[
Evaluated \Rightarrow Usable
\]

nor

\[
HistoricalExistence \Rightarrow Evaluated
\]

holds in general.

Current qualification answers:

> Under which exact profile/context/use evaluation environment may this historical object be used now?

## 2.3 Entitlement

The static entitlement judgment is a separate relation. In simplified form:

\[
Entitled
\equiv
Admissible(A)
\land
Derives(E,\beta,A.requirement)
\land
Safe(S,F,\beta,\tau,m).
\]

Canonical atomic satisfaction requires the selected warrant to be usable, but usability alone is not enough. Exact requirement discharge, ambient admissibility, and floor safety remain independent obligations.

Accordingly:

\[
\boxed{CurrentUsability \not\Rightarrow Entitlement.}
\]

## 2.4 Adequacy

Adequacy is intentionally outside the theorem relation. A source string is recorded provenance, not authenticated truth. A rule may be structurally well typed without being a good epistemic rule. A use may have canonical binding backing without being normatively appropriate. An exact profile may execute correctly without being adequate.

This layer separation prevents the formal results from being misread as a universal epistemology.

## 2.5 Running trace

Fix one evaluation environment

\[
q=(\pi,c,u),
\]

with exact warrant-indexed keys

\[
k_{p_1}=(\pi,c,u,p_1),\qquad
k_{p_2}=(\pi,c,u,p_2),\qquad
k_d=(\pi,c,u,d).
\]

The paper uses one minimal trace throughout Sections 5 and 6.

```text
S0
 │ form ROOT p1
 │ form ROOT p2
 ▼
S1    p1,p2 historical; neither usable at k_p1,k_p2
 │ admit p1 at k_p1
 │ admit p2 at k_p2
 ▼
S2    Usable(S2,k_p1) ∧ Usable(S2,k_p2)
 │ INFER d from [p1,p2]
 ▼
S3    d historical; ¬Usable(S3,k_d)
 │ qualifyInfer d at k_d
 │ requires Usable(S3,k_p1) ∧ Usable(S3,k_p2)
 ▼
S4    Usable(S4,k_d)
```

At `S3` the crucial conjunction is:

\[
\boxed{
Hist_{S_3}(d,W_d)
\land
\neg Usable(S_3,k_d).
}
\]

The historical graph and current qualification relation should be read differently:

```text
persistent historical edges

p1 ─────┐
        ├──> d
p2 ─────┘

pre-state qualification condition at S3

Usable(S3,k_p1) ∧ Usable(S3,k_p2)
```

The edges `p1,p2 → d` are part of immutable history. The usability condition is a predicate of a particular state and the exact evaluation environment `q`; usability is not a warrant-global property.

The chosen trace admits the parents before forming `d` because it is easy to read. That ordering is **not** a formation premise. Ordinary INFER formation has no parent-usability requirement, so a different legal trace can form the historical child while the parents are themselves still unqualified. The later `qualifyInfer` transition is where current parent usability becomes a responsibility obligation.

We intentionally stop the running example at `S4`. A later suspension or invalidation of a parent raises the separate question of dependency invalidation/revalidation, which is not yet part of the first-paper transition surface.

## 2.6 No-shortcut discipline

Across the four layers we use one design rule: a later judgment should not silently acquire support from observations outside its declared responsibility boundary.

In the static calculus this produces branch locality and exact requirement lookup. In historical formation it produces explicit canonical parents, rules, and lineage. In qualification it produces pre-state usable-parent obligations rather than implicit replay of formation. In adequacy it appears negatively: correctness inside the declared regime is not promoted into a claim that the regime is sufficient.

---

# 3. Static Entitlement Calculus

The dynamic lifecycle results explain how warrants become currently usable. They do not by themselves define entitlement. Entitlement belongs to a smaller static calculus that isolates exactly which observations a fixed licensing judgment consumes.

## 3.1 Requirements, branches, and derivability

A requirement is a finite obligation expression. A branch is the recorded witness of one concrete discharge path. Declarative derivability has the form

\[
E \vdash \beta : R,
\]

where `E` supplies atomic satisfaction observations, `R` is the exact requirement, and `β` is the recorded branch.

Branch Conservativity says that if two environments agree on the atomic observations read by a fixed branch, derivability of that branch is invariant. The theorem is branch-relative: it does not say that every alternative candidate set or every possible branch is preserved.

The audit interpretation is important. Once `β` is the recorded discharge path, facts outside the observation footprint of `β` cannot become hidden reasons why that same branch succeeds.

## 3.2 Kernel-floor locality

A separate kernel floor protects conditions that profiles cannot remove. The floor reads only a narrow projection of supporting warrants and a narrow `FloorMove` projection.

Kernel-Floor Locality says safety of a fixed branch and move is invariant when floor observations agree on that branch. Full move arguments introduced later for exact requirement identity do not enlarge this floor interface.

## 3.3 Relative Branch Conservativity — R1

The abstract entitlement judgment combines ambient admissibility, exact requirement discharge, and floor safety.

**Definition 3.1 (Entitlement and fixed ambient boundary).** For floor semantics `S`, ambient view `A`, declarative environment `E`, floor environment `F`, branch `β`, license type `τ`, and floor move `m`, define

\[
Entitled(S,A,E,F,\beta,\tau,m)
\;:\!\iff\;
Admissible(A)
\land
Derives(E,\beta,A.requirement)
\land
Safe(S,F,\beta,\tau,m).
\]

For ambient views `A,A'` and exact requirement `R`, write

\[
FixedAmbient(A,A',R)
\;:\!\iff\;
Admissible(A)\land Admissible(A')
\land A.requirement=R
\land A'.requirement=R.
\]

`SatEqOn(E,E',β)` means that the two declarative environments agree on the atomic observations read by the fixed branch `β`; `FloorEqOn(F,F',β)` is the corresponding equality on floor observations.

**Theorem R1 (Relative Branch Conservativity).** For all

\[
S,A,A',E,E',F,F',\beta,\tau,m,R,
\]

if

\[
FixedAmbient(A,A',R),\qquad
SatEqOn(E,E',\beta),\qquad
FloorEqOn(F,F',\beta),
\]

then

\[
\boxed{
Entitled(S,A,E,F,\beta,\tau,m)
\iff
Entitled(S,A',E',F',\beta,\tau,m).
}
\]

The Lean witness is `relativeBranchConservativity`.

**Proof sketch.** `FixedAmbient` rewrites both ambient requirements to the same exact `R` and supplies admissibility on both sides. Branch Conservativity turns `SatEqOn(E,E',β)` into

\[
Derives(E,\beta,R)\iff Derives(E',\beta,R),
\]

while Kernel-Floor Locality turns `FloorEqOn(F,F',β)` into

\[
Safe(S,F,\beta,\tau,m)
\iff
Safe(S,F',\beta,\tau,m).
\]

Combining the two equivalences with ambient admissibility proves the entitlement equivalence. No executable satisfaction theorem and no support-projection theorem is a premise of R1.

The theorem is deliberately relative. It does not establish that the exact requirement is adequate or that the ambient regime contains every condition that ought to matter.

## 3.4 Exact requirement resolution — R2

The formal model no longer treats requirement lookup as an unspecified external function. A full canonical move contains kind, ordered arguments, scope, and revision depth. Ordered arguments are semantic identity:

```text
["a", "b"] ≠ ["b", "a"]
["a"]      ≠ ["a", "a"]
```

Scope identity is extensional because its list is only a finite-set transport representation.

A requirement key combines license type with full move identity. Unique exact keys make table order semantically irrelevant. Successful lookup is sound and complete for the exact key relation; no subsumption or fuzzy fallback exists.

The main anti-shortcut boundary is:

\[
\boxed{
lookup(k)=none
\not\equiv
lookup(k)=some\;top.
}
\]

An undeclared move does not become an explicit no-obligation move by implementation convention.

## 3.5 Canonical projection coherence — R3

`LicensingRead` supplies one shared partial warrant lookup and projects it into the satisfaction environment, executable oracle, ambient view, and floor environment.

`derives_projection_coherent` proves that every leaf selected by a derivation over the canonical environment reads satisfaction-relevant fields and the floor leaf from the same canonical warrant object. The theorem prevents internal drift in which one identifier could silently denote one object for requirement discharge and another for floor safety.

## 3.6 Static/dynamic assembly boundary

The reachable model already supplies several narrow bridges:

```text
HistoricalWarrant → CanonicalRead.CanonicalWarrant
epi + placement  → usableFromState
CanonicalProfile → RequirementSnapshot
```

Grounded currentness also has a structural state projection. These pieces are enough to state Sections 5 and 6 precisely, but the artifact does not contain one total state-backed `LicensingRead` assembly theorem.

No step in the present argument requires the stronger claim. We therefore leave the boundary explicit instead of adding a theorem merely for architectural completeness.

---

# 4. Reachable Canonical Kernel

The static calculus accepts a licensing read. The dynamic layer asks which historical and evaluation observations can arise from an explicit kernel transition system.

## 4.1 State factorization

`CanonicalState` contains immutable lookup families for contexts, profiles, bindings, historical warrants, and represented licenses, plus mutable evaluation/currentness structures. Historical warrants and current evaluation records are separate fields.

This factorization is the semantic basis for the paper's main distinction: historical identity can persist while evaluation changes.

## 4.2 Reachability — R4

The system begins at an explicit empty `InitialBoundary`. `Reachable` is inductively generated by modeled `Step` transitions.

**Definition 4.1 (Reachability).** `InitialBoundary(S)` means `S` is the empty canonical state. The least predicate `Reachable` is generated by

\[
\frac{InitialBoundary(S)}{Reachable(S)}
\qquad
\frac{Reachable(S)\qquad Step(S,e,S')}{Reachable(S')}.
\]

The first-paper event surface is

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

and no other constructor is implicitly admitted.

`CanonicalStateInvariant(S)` packages the shared coherence conditions for canonical binding/profile/context referents, immutable warrant and parent/lineage referents, ROOT and INFER historical well-formedness, evaluation referent coherence, paired evaluation axes, and profile/use binding backing.

**Theorem R4 (Reachable canonical-state invariance).** For every canonical state `S`,

\[
\boxed{
Reachable(S)
\Rightarrow
CanonicalStateInvariant(S).
}
\]

The Lean witness is `reachable_invariant`.

**Proof sketch.** Induct on the derivation of `Reachable(S)`. At the initial boundary, every lookup and evaluation relation is empty, so the invariant follows from `initialBoundary_invariant`. For an inductive step, apply `step_preserves_invariant` to the induction hypothesis and the concrete `Step(S,e,S')`. The theorem is therefore only as broad as the explicit `Step` constructors above; it is not a claim about unmodeled Python operations or future TRANSPORT/Adopt/revision events.

The transition surface deliberately excludes reachable Adopt, license issuance, TRANSPORT, challenge, revision, and revalidation transitions.

## 4.3 Historical identity

Historical lookup immutability has object-level content. For a warrant:

\[
S.warrant(w)=some\;W
\land
Step(S,e,S')
\Rightarrow
S'.warrant(w)=some\;W.
\]

The same style of preservation applies to other immutable history-plane referents. This law is what makes later branch support, lineage, and challenge targets meaningful: an identifier does not change historical referent between states.

## 4.4 Evaluation coherence

Evaluation positions must point to canonical historical warrants with matching formation profile/context. The two evaluation axes are paired rather than half-created. Populated `(profile,use)` evaluation environments must also have canonical binding backing.

These invariants are structural provenance properties. They do not prove that the use is normatively adequate.

## 4.5 Grounded currentness — R5 as an orthogonal semantic component

Adopted-context currentness is formalized separately through `ActivationRead` and an inductive `Grounded` relation. A grounded adopted context requires a base-current activation license whose issuing context is itself grounded. Every grounding derivation therefore terminates at an explicit bootstrap activation.

The key result is:

\[
Grounded(c)
\Rightarrow
\text{finite activation chain from }c\text{ to bootstrap}.
\]

Consequently, a world containing only cyclic Adopt dependencies and no bootstrap boundary cannot derive grounded currentness.

R5 should not be confused with the ROOT/INFER lifecycle results. The current reachable `Step` relation contains bootstrap activation but not Adopt or license issuance. The bridge from reachable state to `ActivationRead` is structural, and `baseCurrent` remains an external factor. R5 is therefore a semantic closure result connected to the kernel, not a completed reachable Adopt lifecycle.

---

# 5. Historical Formation Is Not Current Qualification

ROOT provides the minimal witness that historical existence and current usability are separate state relations.

## 5.1 Canonical ROOT formation

A ROOT formation step requires a fresh warrant identifier, a canonical binding, a canonical context, and context acceptance of the input claim. It creates one `HistoricalWarrant` with exact formation profile/context, root constructor, empty parents, external source, and distinct root/source lineage initialization.

The transition deliberately does not require active context, evaluation-active binding, or a scope-within-binding check because those are not part of the represented ROOT formation boundary.

The exact constructor-level postcondition is exposed by `rootStep_newWarrant_exact`: any successful ROOT step yields canonical pre-state binding/context witnesses, context acceptance of the claim, and the exact `rootHistoricalWarrant` at the new identifier in the post-state.

## 5.2 Formation preserves evaluation — R6a

ROOT formation writes the historical warrant lookup and leaves the represented evaluation/currentness topology unchanged.

Combined with the reachable invariant and warrant-ID freshness, this yields a stronger result than mere field non-update: no pre-existing evaluation record can refer to the fresh warrant identifier.

**Theorem R6a (Fresh ROOT formation is non-usable).** Let `S,S'` be canonical states, `w` a warrant identifier, `b,c` identifiers, and `x` a root input. If

\[
Reachable(S)
\]

and

\[
Step(S,\operatorname{root}(w,b,c,x),S'),
\]

then for **every** observed profile digest `π'`, context `c'`, and use `u`,

\[
S'.epi(\pi',c',u,w)=none
\quad\land\quad
S'.placement(\pi',c',u,w)=none,
\]

and therefore

\[
\boxed{
\neg Usable(S',(\pi',c',u,w)).
}
\]

The Lean witnesses are `rootStep_newWarrant_unqualified` and `rootStep_newWarrant_notUsable`.

**Proof sketch.** `Reachable(S)` gives `EvaluationReferentsCanonical(S)` through R4. Freshness of `w` means `S.warrant(w)=none`; referent coherence therefore rules out any pre-existing evaluation record at a key ending in `w`. `rootStep_evaluationTopology_unchanged` shows that ROOT formation copies both evaluation axes pointwise into `S'`. Hence no evaluation pair exists for the newly formed identifier at any environment, so usability is impossible.

In the running example, this is the state of `p1` and `p2` at `S1`: neither `Usable(S_1,k_{p_1})` nor `Usable(S_1,k_{p_2})` holds.

## 5.3 Explicit admission — R6b

ROOT admission is a separate evaluation transition. It checks the canonical binding/context/warrant relation, ROOT constructor, exact formation context/profile, and requested use agreement. It does not replay context signature acceptance from formation.

**Theorem R6b (ROOT admission establishes exact-key usability).** If

\[
Step(S,\operatorname{admitRoot}(w,b,c,u,meta),S'),
\]

then there exists a canonical binding `B` such that

\[
S.binding(b)=some\;B
\]

and

\[
\boxed{
Usable(S',(B.profileDigest,c,u,w)).
}
\]

The stronger exact postcondition `admitRoot_evaluation_exact` additionally recovers the canonical context and historical ROOT warrant, the exact formation-context/profile equalities, `B.use=u`, and the two post-state facts

\[
S'.epi(B.profileDigest,c,u,w)=LIVE,
\qquad
S'.placement(B.profileDigest,c,u,w)=PLACED.
\]

The Lean usability witness is `admitRoot_makes_usable`.

**Proof sketch.** Inverting the admission `Step` yields the canonical binding/warrant witnesses and exact formation/use equalities. The post-state is definitionally `qualifyEvaluation` at the selected key. `qualifyEvaluation_exact` writes `LIVE` and `PLACED` there, which is exactly the definition of `Usable`.

Admission has no evaluation freshness premise. Re-admission and overwrite semantics remain representable.

## 5.4 Audit metadata is not adequacy

Admission records actor and basis strings. The kernel does not prove that the actor is authenticated or that the basis is sufficient. Thus:

\[
RecordedActor \not\Rightarrow AuthenticatedPrincipal
\]

and

\[
RecordedBasis \not\Rightarrow AdequateBasis.
\]

This is another instance of the paper's discipline: record what the transition actually establishes, and do not silently promote audit metadata into stronger authority.

---

# 6. Current-Parent Responsibility

INFER separates historical derivation from current responsibility more sharply than ROOT because the same parent graph participates in two different relations.

## 6.1 Exact historical formation — R7

A canonical profile contains an immutable rule table. Ordinary INFER resolves the exact profile selected by the binding, performs exact `ruleId` lookup, resolves ordered historical parent occurrences, and checks one `InferFormationDiscipline`. Rule-table order is not a priority mechanism.

The paper-facing formation result is deliberately a **local `Step` theorem**. Unlike the later fresh-child non-usability result, it does not require the pre-state to be reachable.

**Theorem R7 (Exact historical INFER formation).** Let `S,S'` be canonical states, `w` a fresh child identifier, `b,c,r` the formation binding/context/rule identifiers, `P` the ordered parent-ID list, and `s` the output scope. If

\[
Step(S,\operatorname{infer}(w,b,c,r,P,s),S'),
\]

then there exist a canonical binding `B`, profile `\Pi`, context `C`, exact rule `R`, and ordered resolved parent objects `\bar W` such that

\[
S.binding(b)=some\;B,
\qquad
S.profile(B.profileDigest)=some\;\Pi,
\]

\[
lookupRule(\Pi,r)=some\;R,
\qquad
S.context(c)=some\;C,
\]

\[
ResolvesParents(S,P,\bar W),
\]

\[
InferFormationDiscipline(C,B.profileDigest,c,R,\bar W,s),
\]

and

\[
\boxed{
S'.warrant(w)
=
some\;\operatorname{inferHistoricalWarrant}
(r,B.profileDigest,c,P,\bar W,s,R).
}
\]

The Lean witness is `inferStep_newWarrant_exact`.

**Proof sketch.** Invert the single `Step.infer` constructor. Its premises directly provide the canonical binding, profile, exact rule lookup, canonical context, ordered parent resolution, and formation discipline. The post-state updates the historical warrant lookup with `putCanonical`, so the fresh child identifier denotes exactly the displayed `inferHistoricalWarrant`. No reachability invariant is used in this proof.

At the paper level we unfold only the formation obligations needed for the contribution claim. `InferFormationDiscipline` fixes: (i) ordered parent roles against the exact rule inputs; (ii) the parents' formation context/profile identity; (iii) scope non-widening and escalation-strength non-amplification; and (iv) structural typing, output acceptance, and the selected kernel guard. These are formation responsibilities, not qualification-time checks.

Formation is occurrence-sensitive. `ResolvesParents(S,P,\bar W)` preserves list order and duplicate occurrences, and `inferStep_orderedParentRoles_exact` compares the resulting ordered parent-role list with the rule's ordered input-role list.

**Corollary (Exact lineage construction).** Under the same formation step, the new historical object's root lineage and source lineage are the independent role-wise unions of the resolved parents' corresponding lineage relations. This is the paper-facing role of `inferStep_lineage_union`; it is supporting structure for R7 rather than a separate headline result.

## 6.2 Why two lineage relations matter

The model keeps root lineage and source lineage distinct. This is not decorative provenance metadata. Different kernel guards inspect the two relations: `distinct_content_roots` reasons about root ancestry, while `distinct_content_sources` reasons about external-source ancestry.

The INFER formation theorem shows that both are preserved by independent role-wise union rather than collapsed into one generic provenance set.

## 6.3 Formation does not require parent usability

The ordinary INFER constructor has no `Usable` premise for parents. Formation requires canonical historical parent objects and the formation discipline above; current parent qualification is a different boundary.

This yields:

\[
\boxed{
HistoricalParentExistence
\text{ may support formation without }
CurrentParentUsability.
}
\]

In the main running trace the parents happen to satisfy `Usable(S_2,k_{p_1})` and `Usable(S_2,k_{p_2})` before `d` is formed. That is not required by R7. The steps can be reordered so that `d` is historically formed before either root is admitted, provided the historical formation premises hold.

This is the first half of the distinction:

```text
historical derivation relation
    ≠
current usable-parent responsibility
```

## 6.4 Transition responsibility cut

The two INFER transitions expose different responsibility boundaries. The distinction is better stated in terms of what each boundary checks and establishes than in terms of resource consumption.

| Boundary | Requires / checks now | Establishes | Does not re-check |
| --- | --- | --- | --- |
| **INFER formation** | fresh child ID; exact binding/profile/rule; canonical context; ordered canonical parent occurrences; `InferFormationDiscipline` | exact immutable historical child; ordered parent identities; root/source lineage | current parent usability |
| **INFER qualification** | existing historical INFER child; recorded formation context/profile identity; pre-state current usability of the historical parent identities | exact child `LIVE/PLACED` evaluation at the selected profile/context/use key | rule lookup; structural typing; formation guard; output acceptance; scope/strength discipline; lineage construction |

“Does not re-check” does not mean that the historical obligations are irrelevant. In the reachable-state interpretation they are carried by the immutable historical warrant and the shared invariant. Qualification's responsibility is not to discharge formation a second time.

The machine-checked write sets make the cut visible. `inferStep_evaluationTopology_unchanged` proves that ordinary INFER formation preserves, pointwise, active-context facts, activation provenance, review requirements, represented licenses, and both evaluation axes. Conversely, `qualifyInfer_historyReferentsImmutable` proves that qualification preserves every immutable historical referent, while `qualifyInfer_evaluation_exact` writes the selected child evaluation key.

Thus the transition cut can be summarized as

\[
\boxed{
\begin{array}{rcl}
INFER\ formation
&:&
History\ changes,\ represented\ evaluation/currentness\ topology\ unchanged,
\\[2mm]
INFER\ qualification
&:&
Historical\ referents\ unchanged,\ exact\ evaluation\ qualification\ changes.
\end{array}
}
\]

This is stronger than observing that formation happens not to make the fresh child usable: the formation transition does not write the represented evaluation/currentness plane at all.

## 6.5 Fresh INFER history is non-usable

R7 itself needs only one formation `Step`. The stronger statement that the fresh child has **no** evaluation position at any profile/context/use key needs reachability.

Like ROOT formation, INFER formation leaves evaluation unchanged. Reachability supplies `EvaluationReferentsCanonical(S)`; together with warrant-ID freshness this rules out a pre-existing evaluation record referring to the fresh child, and `inferStep_evaluationTopology_unchanged` carries that absence into the post-state.

Thus, from

\[
Reachable(S)
\land
Step(S,\operatorname{infer}(w,b,c,r,P,s),S'),
\]

we obtain for every profile/context/use environment

\[
\boxed{\neg Usable(S',(\pi,c',u,w)).}
\]

through `inferStep_newWarrant_unqualified` and `inferStep_newWarrant_notUsable`.

The proof-responsibility split is therefore:

\[
\boxed{
\text{exact historical formation is a local Step theorem;}
\quad
\text{fresh-child non-usability additionally uses reachable-state coherence.}
}
\]

In the running trace this is the defining fact of `S3`:

\[
Hist_{S_3}(d,W_d)
\land
\neg Usable(S_3,k_d).
\]

## 6.6 Qualification requires a different responsibility — R8

The current-parent predicate used by qualification is explicit.

**Definition 6.1 (Current usable parents).** For state `S`, profile digest `π`, context `c`, use `u`, and historical warrant `W`, define

\[
InferParentsUsable(S,\pi,c,u,W)
\;:\!\iff\;
\forall p\in W.parents,\;Usable(S,(\pi,c,u,p)).
\]

The membership relation is over the warrant's stored parent-ID list; the universal predicate is evaluated in the qualification **pre-state**.

There is an intentional occurrence/identity asymmetry between formation and qualification:

\[
\boxed{
\text{formation is occurrence-sensitive;}
\qquad
\text{qualification currentness is identity-sensitive.}
}
\]

Formation preserves ordered parent occurrences and duplicates because they occupy ordered derivational input positions and participate in occurrence-sensitive formation checks. Qualification instead asks whether each parent identifier appearing in that stored list is currently usable at one exact evaluation key. If the same identifier occurs repeatedly, the present `InferParentsUsable` predicate does not create a multiplicity-sensitive or use-once obligation: propositionally it asks for the same `Usable(S,(\pi,c,u,p))` fact. Current usability in this kernel is therefore an idempotent predicate of a warrant identity at an exact evaluation key, **not** a linear, consumable, or use-once capability resource.

**Theorem R8 (Exact INFER qualification boundary).** Suppose

\[
Step(S,\operatorname{qualifyInfer}(w,b,c,u,meta),S').
\]

Then there exist a binding `B`, a historical warrant `W`, and a rule identifier `r` such that

\[
S.binding(b)=some\;B,
\]

\[
S.warrant(w)=some\;W,
\]

\[
W.constructor=\operatorname{infer}(r),
\qquad
W.formationContext=c,
\qquad
W.formationProfileDigest=B.profileDigest,
\]

and

\[
InferParentsUsable(S,B.profileDigest,c,u,W).
\]

Moreover the exact child key

\[
k_w=(B.profileDigest,c,u,w)
\]

satisfies

\[
S'.epi(k_w)=LIVE
\qquad\land\qquad
S'.placement(k_w)=PLACED,
\]

hence

\[
\boxed{Usable(S',k_w).}
\]

The exact Lean witness for the preconditions and two-axis postcondition is `qualifyInfer_evaluation_exact`; `qualifyInfer_requires_usableParents` exposes the pre-state responsibility directly, and `qualifyInfer_makes_usable` gives the usability corollary.

**Proof sketch.** Invert the `qualifyInfer` constructor. Its premises already contain the canonical binding/warrant lookup, INFER constructor witness, exact historical formation context/profile, and `InferParentsUsable` in `S`. No rule lookup, typing, guard, context-acceptance, scope, strength, or lineage-construction premise occurs in this transition. Those obligations belong to historical formation; qualification does not discharge them a second time. The post-state is `qualifyEvaluation` at `k_w`, so the generic exact-setter theorem yields `LIVE/PLACED` and therefore usability.

For the running example, the pre-state obligation is exactly

\[
Usable(S_3,k_{p_1})
\land
Usable(S_3,k_{p_2}).
\]

## 6.7 Pre-state, not permanent, responsibility

The parent-usability obligation is explicitly indexed by the qualification pre-state:

\[
ParentsUsable(S_{pre})
+
QualifyInfer(S_{pre},S_{post})
\Rightarrow
ChildUsable(S_{post}).
\]

The current model does not assert the converse as a permanent invariant. A future revision/invalidation transition may change a parent's current status after the child was qualified. How such dependency invalidation should propagate is deliberately left to later work.

## 6.8 Qualification does not invent an unbacked use

The executable `qualify_derived()` boundary does not repeat the ROOT-style check `binding.use = use`. The formalization does not silently add one.

Instead, two facts close the structural gap. First, a well-typed ordinary INFER rule has nonempty inputs, so a well-formed INFER warrant has at least one parent. Second, every usable parent evaluation position has profile/use binding backing by the shared reachable invariant. Since qualification uses the same `(profile,use)` environment for child and parents, the child cannot originate a wholly unbacked use.

This is only a provenance result:

\[
EvaluationProfileUseBackedByBinding
\not\Rightarrow
UseAdequacy.
\]

## 6.9 Lifecycle separation — R9

R9 composes the historical formation boundary with the current qualification boundary, but its exact temporal scope matters.

**Theorem R9 (Adjacent INFER formation/qualification lifecycle).** Let

\[
S_0,S_1,S_2
\]

be canonical states. Let `w` be the child warrant identifier; let

\[
b_f,c_f,r,P,s
\]

be the formation binding identifier, formation context identifier, rule identifier, ordered parent-ID list, and output scope; and let

\[
b_q,c_q,u,meta
\]

be the qualification binding identifier, qualification context identifier, use, and audit metadata. Assume

\[
Reachable(S_0),
\]

\[
Step(S_0,
\operatorname{infer}(w,b_f,c_f,r,P,s),
S_1),
\]

and the **adjacent** qualification step

\[
Step(S_1,
\operatorname{qualifyInfer}(w,b_q,c_q,u,meta),
S_2).
\]

Then there exist a binding `B`, historical warrant `W`, and actual rule identifier `r'` such that

\[
S_1.binding(b_q)=some\;B,
\qquad
S_1.warrant(w)=some\;W,
\]

\[
W.constructor=\operatorname{infer}(r'),
\qquad
W.formationContext=c_q,
\qquad
W.formationProfileDigest=B.profileDigest,
\]

\[
InferParentsUsable(S_1,B.profileDigest,c_q,u,W),
\]

and, for the exact child key

\[
k_w=(B.profileDigest,c_q,u,w),
\]

both

\[
\boxed{\neg Usable(S_1,k_w)}
\]

and

\[
\boxed{Usable(S_2,k_w)}
\]

hold.

The Lean witness is `inferFormationQualification_boundary`.

**Proof sketch.** Invert the qualification step using `qualifyInfer_requires_usableParents` to obtain `B`, `W`, the INFER constructor witness, the historical formation context/profile equalities, and the pre-state parent-usability obligation. Because `S_0` is reachable and the immediately preceding step is a fresh INFER formation of `w`, `inferStep_newWarrant_notUsable` gives non-usability of `w` in `S_1` at **every** profile/context/use key, hence at `k_w`. Finally, `qualifyInfer_makes_usable` gives usability at the same exact key in `S_2`; functional lookups identify its binding and warrant witnesses with those already recovered from the qualification step.

Two scope points are important. First, the formation call-site identifiers `(b_f,c_f)` and qualification call-site identifiers `(b_q,c_q)` are quantified separately; the theorem recovers the qualification environment through the immutable warrant's recorded formation context/profile and the qualification premises rather than by assuming syntactic equality of the two calls. Second, R9 is a **two-step adjacent trace theorem**. It does not state that the same conclusion holds after an arbitrary sequence of intervening transitions.

**Remark 6.2 (Separation is weaker than persistence, and deliberately so).** The adjacent theorem discharges a separation obligation: it exhibits a machine-checked boundary in which the same historical child is present but non-usable in `S_1`, and becomes usable only after the explicit qualification transition to `S_2`. Schematically,

\[
\begin{aligned}
\textbf{Separation:}\quad
&Hist_{S_1}(w,W)
\land
\neg Usable(S_1,k_w)
\land
Usable(S_2,k_w).
\end{aligned}
\]

A stronger temporal-persistence theorem would quantify over states reached through arbitrary intervening transitions and would have to state which historical/current properties are preserved, which transitions may suspend or invalidate them, and under what revalidation obligations they can be restored. Schematically,

\[
\begin{aligned}
\textbf{Temporal persistence:}\quad
&\text{for arbitrary admissible intervening transitions,}\
&\text{specified properties persist until an explicit invalidator, subject to stated preservation rules.}
\end{aligned}
\]

The current `Step` surface has no challenge/revision/invalidation theory from which those premises could be derived. The stronger statement is therefore not silently assumed and is not required to establish relation-level separation:

\[
\boxed{
\text{A witnessed boundary proves separability;}
\quad
\text{arbitrary temporal persistence requires an invalidation theory.}
}
\]

The machine-checked distinction is therefore not merely that history and status are stored in different fields, nor merely that one phase checks proofs while another checks mutable state. The same persistent parent identities participate in two relations at different responsibility boundaries:

\[
\underbrace{ParentOf(p,d)}_{\text{persistent historical relation}}
\qquad\text{and}\qquad
\underbrace{Usable(S_{pre},k_p)}_{\text{time-indexed evaluation predicate}}.
\]

Formation establishes and preserves the first relation while carrying the already-discharged rule/guard/context/scope/strength/lineage obligations. Qualification later evaluates the second relation without replaying the first set of obligations.

## 6.10 Stopping before entitlement

At `S4`, the running example establishes `Usable(S_4,k_d)`. It does not establish that any particular licensing move is entitled.

The static layer still requires exact requirement resolution, branch discharge, ambient admissibility, and floor safety. This is why the paper's title stops at current usability rather than claiming a complete transition from historical formation to entitlement.

---

# 7. Executable Reference and Conformance

The repository includes a Python V0.1.2.2 reference implementation and cross-language adapters. Their purpose is to test selected executable observations against the mechanized projection semantics, not to serve as a formal operational semantics for Python.

## 7.1 What is compared

The static conformance path executes the Python kernel, extracts canonical snapshots, encodes them deterministically, and generates Lean-consumable fixtures. Lean then evaluates the already mechanized projection functions for ambient observations, atomic satisfaction, floor observations, and related static behavior.

The currentness conformance path preserves a pre-refresh active/provenance boundary and compares selected post-transition Python activity against proof-carrying grounded/ungrounded certificates. It does not use post-refresh activity as its own seed.

## 7.2 What is deliberately not duplicated

The Python adapters do not implement a second copy of Lean's branch satisfaction or floor semantics merely to make two hand-written models agree. Similarly, the Lean side does not pretend to reproduce Python's general integer parser for escalation-depth strings.

This design keeps the adapter boundary visible: executable parsing, transition execution, and snapshot extraction remain Python responsibilities; finite semantic checking remains on the mechanized side where modeled.

## 7.3 Current empirical boundary

At the artifact commit accompanying this draft, the repository regression and differential-conformance suite contains 63 tests alongside the Lean build and theorem audit. The exact count is an artifact metric that may change; it is not a theorem count and not a coverage proof. A submission version may move the numeric count to the artifact appendix while retaining the qualitative claim here.

The defensible implementation claim is:

> **Selected Python V0.1.2.2 observations are differentially conformance-tested against the mechanized projection/currentness semantics.**

The following claim is not supported:

> **Python V0.1.2.2 is verified.**

No source-level refinement theorem shows that arbitrary Python runtime states correspond to `CanonicalState`, that every Python operation refines `Step`, or that `root()`, `infer()`, `admit_root()`, or `qualify_derived()` exactly implement the Lean transitions for all inputs.

## 7.4 Why the conformance section is secondary

The first paper's theoretical contribution is the responsibility decomposition and its metatheory. The executable reference matters because it shows that selected implementation observations can be aligned with the formal projections and because previous adapter work exposed real state-boundary issues. But conformance testing remains evaluation evidence, not a fourth proof contribution.

---

# 8. Limits and Non-Theorems

The artifact is intentionally explicit about what its names do not entail.

| Boundary | What is proved/tested | What is not proved |
| --- | --- | --- |
| Historical warrant | Canonical formation shape, referent immutability, ROOT/INFER parent and lineage discipline | Source authenticity, truth of claim, epistemic adequacy |
| Rule/profile | Exact immutable lookup and structural rule discipline | Rule adequacy, profile adequacy, completeness of policy |
| Evaluation | `LIVE/PLACED` usability, referent coherence, binding backing | Normative adequacy of use or admission basis |
| INFER qualification | Pre-state usable parents imply post-state child usability under explicit qualification | Permanent child dependency invariant; later invalidation propagation |
| Grounded currentness | Bootstrap-rooted semantic grounding, no pure self-support | Reachable Adopt lifecycle; adequacy of `baseCurrent`; full Python refresh refinement |
| Entitlement | BC/KFL/RBC and canonical projection coherence for a supplied/resolved licensing read | Total `CanonicalState → LicensingRead → Entitled` assembly |
| Python | Selected differential conformance fixtures | Verified implementation or general operational refinement |
| Regime | Correct execution of modeled finite rules | `ProfileExecutionCorrectness → ProfileAdequacy`; `KernelCorrectness → KernelFloorAdequacy` |

Several non-implications should remain visible:

\[
HistoricalExistence \not\Rightarrow CurrentUsability,
\]

\[
CurrentUsability \not\Rightarrow Entitlement,
\]

\[
RecordedBasis \not\Rightarrow AdequateBasis,
\]

\[
RecordedActor \not\Rightarrow AuthenticatedPrincipal,
\]

\[
ProfileExecutionCorrectness \not\Rightarrow ProfileAdequacy,
\]

\[
KernelCorrectness \not\Rightarrow KernelFloorAdequacy.
\]

These are not caveats appended after the fact. They define the theorem regime.

---

# 9. Related Work

The closest neighboring areas already provide substantial parts of the conceptual landscape. Our positioning therefore depends on a narrow comparison, not on a claim that previous systems fail to distinguish history from change in general.

## 9.1 Truth maintenance

Assumption-Based Truth Maintenance Systems (ATMS) preserve explicit assumption environments and justification structure while supporting inconsistent information, context switching, and reasoning without destructive retraction of all alternatives [de Kleer 1986]. This is an important predecessor for any architecture that distinguishes stored reasons from currently supported contexts.

Our result is not that such a distinction had never been represented. The narrower difference is the object and transition boundary: a `HistoricalWarrant` is an immutable canonical referent, current usability is a separate evaluation relation keyed by profile/context/use, and R9 proves a concrete two-step lifecycle in which ordinary INFER formation omits current parent usability while qualification later requires it as a pre-state obligation.

## 9.2 Database provenance

Database provenance, especially provenance semirings, provides a systematic algebraic account of how query outputs depend on inputs [Green, Karvounarakis, Tannen 2007]. That literature makes it untenable to present “recording derivation provenance” as the novelty of this work.

Our historical parents and lineage play a provenance-like role, but the central theorem concerns a second relation: whether an already formed historical object is currently qualified for use. The paper's contribution is the explicit separation and transition contract between these relations, not the existence of provenance annotations. The comparison is intentionally limited to the cited core provenance result; it is not an absence claim about the broader provenance literature.

## 9.3 Justification Logic and dynamic evidence logics

Justification Logic internalizes proof/evidence objects through assertions such as `t : F`, read as “t is a justification for F” [Artemov 2008]. It therefore provides a mature proof-relevant epistemic framework. Dynamic descendants go further. Bucheli, Kuznets, and Studer combine public-announcement dynamics with explicit justifications [2014]. Baltag, Renne, and Smets combine tools from Dynamic Epistemic Logic, Justification Logic, and Belief Revision to model evidence introduction, inference, evidential upgrade/update, and defeasible justified belief; related work treats evidence availability, admissibility, goodness, explicit knowledge, and conclusive evidence [2012; 2014].

Our warrants should therefore not be presented as the first explicit justification objects, nor should the paper claim novelty for dynamically revisable explicit evidence. The narrower object is a kernel invariant separating immutable historical warrant identities from a mutable evaluation relation over those same identities. The main result concerns how one formation transition and one later qualification transition have distinct responsibility premises over a persistent parent graph.

## 9.4 Proof-carrying and stateful authorization

Proof-Carrying Authentication requires clients to submit checkable proofs with requests [Appel & Felten 1999]. Later authorization work moves even closer to our current-state boundary. Explicit-time authorization logic reasons about time and mutable state [DeYoung, Garg, Pfenning 2008]. The Proof-Carrying File System supports policies whose consequences depend on time and system state and separates proof/certificate verification from later checks of extracted time/state conditions through conditional capabilities [Garg & Pfenning 2010]. Stateful Authorization Logic gives a proof-theoretic treatment of policies depending on externally verified state predicates [Garg & Pfenning 2012].

The 2011 revocable/use-once PCFS extension strengthens this neighboring pattern further: authorization still uses explicit proof objects, while revocation lists and use-once certificate state are stored in a database consulted during file access [Morgenstern, Garg, Pfenning 2011]. Persistent proof material combined with mutable access-time credential state is therefore not a novelty claim available to this paper.

Nor is the claimed distinction merely staged proof checking. PCFS already gives a close example of proof/certificate verification separated from later state/time checks. The narrower theorem-level distinction here is the **dependency object to which the later state predicate is applied**. Ordinary INFER permanently records an ordered historical parent relation. Later qualification evaluates `Usable` over those same parent identities in a particular pre-state, while immutable reachable history carries the already-discharged rule lookup, typing, guard, context acceptance, scope, strength, and lineage obligations.

In schematic form:

\[
\underbrace{ParentOf(p,d)}_{\text{persistent historical relation}}
\qquad\text{versus}\qquad
\underbrace{Usable(S_{pre},k_p)}_{\text{time-indexed evaluation predicate}}.
\]

The present claim is thus not that proof material has never coexisted with mutable authorization state. It is the specific machine-checked separation between immutable derivation-parent structure and a later qualification transition whose premise is current usability of those same historical parents. The current usability predicate is not a use-once or multiplicity-sensitive credential resource; repeated historical parent occurrences remain an occurrence-sensitive formation fact rather than repeated consumption rights at qualification time.

## 9.5 Belief revision and dynamic epistemic logic

AGM belief revision studies rational transformations of belief sets under contraction, expansion, and revision [Alchourrón, Gärdenfors, Makinson 1985]. Classical belief-set presentations often abstract away explicit derivational reasons, although foundational approaches and truth-maintenance traditions retain richer support structure. Dynamic Epistemic Logic studies model-transforming epistemic actions and broader belief change [van Ditmarsch, van der Hoek, Kooi 2007]. As §9.3 notes, dynamic justification/evidence logics already connect explicit reasons with such change.

Our problem is complementary. The first-paper kernel does not yet model general revision of the historical/evaluation graph. Instead it deliberately keeps canonical formation history immutable and asks which current evaluation transition may qualify an already formed object. Challenge/revision/revalidation will eventually connect the work more directly to belief-change semantics, but those transitions are outside the present theorem surface.

## 9.6 Positioning summary

The novelty claim should therefore be phrased positively and narrowly:

> **We mechanize a finite reachable kernel in which canonical history, current qualification, and branch-local entitlement observations are separate interfaces. ROOT and INFER make the split transition-visible. Ordinary INFER formation permanently records exact ordered historical parent occurrences and discharges rule/typing/guard/context/scope/strength/lineage obligations without requiring parent usability; later qualification applies pre-state current usability to those parent identities without replaying formation.**

This is not a priority claim over provenance, truth maintenance, justification logic, dynamic evidence logics, proof-carrying/stateful authorization, revocable credentials, or belief dynamics. It is a specific machine-checked decomposition of responsibilities inside one finite kernel.

### Bibliographic anchors for this draft

- Johan de Kleer. “An assumption-based TMS.” *Artificial Intelligence* 28(2):127–162, 1986. DOI `10.1016/0004-3702(86)90080-9`.
- Todd J. Green, Grigoris Karvounarakis, Val Tannen. “Provenance Semirings.” *PODS 2007*, 31–40. DOI `10.1145/1265530.1265535`.
- Sergei Artemov. “The Logic of Justification.” *The Review of Symbolic Logic* 1(4):477–513, 2008. DOI `10.1017/S1755020308090060`.
- Samuel Bucheli, Roman Kuznets, Thomas Studer. “Realizing Public Announcements by Justifications.” *Journal of Computer and System Sciences* 80(6):1046–1066, 2014. DOI `10.1016/j.jcss.2014.04.001`.
- Alexandru Baltag, Bryan Renne, Sonja Smets. “The Logic of Justified Belief Change, Soft Evidence and Defeasible Knowledge.” *WoLLIC 2012*, LNCS 7456, 168–190. DOI `10.1007/978-3-642-32621-9_13`.
- Alexandru Baltag, Bryan Renne, Sonja Smets. “The Logic of Justified Belief, Explicit Knowledge, and Conclusive Evidence.” *Annals of Pure and Applied Logic* 165(1):49–81, 2014. DOI `10.1016/j.apal.2013.07.005`.
- Andrew W. Appel, Edward W. Felten. “Proof-Carrying Authentication.” *CCS 1999*, 52–62. DOI `10.1145/319709.319718`.
- Henry DeYoung, Deepak Garg, Frank Pfenning. “An Authorization Logic with Explicit Time.” *CSF 2008*. DOI `10.1109/CSF.2008.15`.
- Deepak Garg, Frank Pfenning. “A Proof-Carrying File System.” *IEEE Symposium on Security and Privacy 2010*, 349–364. DOI `10.1109/SP.2010.28`.
- Jamie Morgenstern, Deepak Garg, Frank Pfenning. “A Proof-Carrying File System with Revocable and Use-Once Certificates.” *STM 2011*, LNCS.
- Deepak Garg, Frank Pfenning. “Stateful Authorization Logic—Proof Theory and a Case Study.” *Journal of Computer Security* 20(4):353–391, 2012.
- Carlos E. Alchourrón, Peter Gärdenfors, David Makinson. “On the Logic of Theory Change: Partial Meet Contraction and Revision Functions.” *Journal of Symbolic Logic* 50(2):510–530, 1985. DOI `10.2307/2274239`.
- Hans van Ditmarsch, Wiebe van der Hoek, Barteld Kooi. *Dynamic Epistemic Logic*. Springer, 2007. DOI `10.1007/978-1-4020-5839-4`.

The submission bibliography may still expand descendant work where needed; the current matrix is a positioning baseline, not an exhaustive literature survey. Negative comparisons in this section are scoped to the cited results rather than to entire research traditions.

---

# 10. Discussion and Future Work

The first-paper freeze changes the default burden of proof for new semantics. A new constructor is not justified because it would make the kernel feel more complete; it must close a concrete gap in the paper's argument.

## 10.1 State-backed licensing-read assembly

The current draft does not require a total `CanonicalState → LicensingRead` theorem. If a later abstract, reviewer request, or stronger end-to-end claim requires one, the appropriate milestone is a narrow assembly result that combines historical-warrant projection, state-backed usability, exact requirement resolution, selected binding/context/use observations, and grounded currentness into the existing canonical read.

Until such a claim is necessary, the gap should remain explicit.

## 10.2 TRANSPORT

TRANSPORT is the natural next constructor family for cross-context responsibility. Ordinary INFER is already machine-fixed as intra-context and intra-profile-snapshot. A future TRANSPORT lifecycle could therefore make the cross-context boundary theorem-visible rather than treating transport as a convenience operation.

It is strengthening material, not a prerequisite for the first paper's core argument.

## 10.3 Challenge, revision, and revalidation

The present lifecycle theorems stop once an object becomes usable. They do not specify what should happen when a parent later becomes suspended or pending, when a context loses currentness, or when a challenge targets a historical descendant.

This is where the distinction between persistent historical edges and time-indexed current responsibility becomes operationally consequential. Future work should model dependency invalidation and explicit revalidation without rewriting historical formation.

## 10.4 License lifecycle and verified execution

The reachable transition system does not yet model license issuance, Adopt activation, or full operational refinement of the Python kernel. These are engineering/formalization extensions rather than hidden assumptions of the current lifecycle theorem.

A verified execution path would require a source or operational semantics for the executable kernel and a refinement relation to the canonical state/step model. Differential conformance tests do not substitute for that proof.

## 10.5 Regime reopening: Q_open and Q_close

The current paper studies correct execution inside a fixed finite regime. It does not answer when the system may revise the regime that defines sufficiency, nor how heterogeneous systems jointly establish or discharge a shared regime.

Those questions—informally Q_open and Q_close—belong to a broader Responsibility Topology research program. They should not become a second main line of the first paper. Their role here is to mark the boundary:

\[
\boxed{
CorrectExecutionInsideRegime
\not\Rightarrow
AdequacyOfRegime.
}
\]

That non-theorem is not a weakness to erase. It is the reason the paper can make a precise finite claim without pretending to solve general epistemology.
