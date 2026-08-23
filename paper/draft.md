# Responsibility Topology for Finite Epistemic Kernels: Separating Historical Derivation from Current Usability

_Status: first paper skeleton; Sections 1 and 3–6 are substantive first drafts. Sections 2 and 7–10 are scoped placeholders._

## Abstract — working version

Finite epistemic systems often collapse two different questions: whether a judgment has a valid historical derivation and whether that judgment may be used now. This paper develops a small mechanized kernel in which those questions are represented by different state relations. Immutable canonical history records warrant formation, parent structure, rule provenance, and lineage. A separate mutable evaluation plane records current qualification, with usability defined by a pair of evaluation statuses rather than by historical existence. The static entitlement layer then requires, in addition to usability of supporting warrants, exact requirement discharge, ambient admissibility, and kernel-floor safety.

We formalize three result families in Lean 4. First, a branch-local entitlement calculus establishes Relative Branch Conservativity, exact full-move requirement resolution, and canonical projection coherence. Second, an explicit transition system generates reachable canonical states while preserving immutable historical identity and shared evaluation invariants; adopted-context currentness is grounded at bootstrap boundaries rather than allowing self-supporting cycles. Third, ROOT and ordinary INFER expose a formation/qualification separation. Fresh formation creates canonical historical warrants without making them usable. ROOT admission establishes current usability explicitly. For INFER, historical formation consumes exact rules and historical parents but not parent usability, whereas later qualification requires those same historical parents to be currently usable in the pre-state before making the child usable in the post-state. Thus historical derivation and current responsibility are distinct relations even when they concern the same warrant graph.

The mechanization proves correct execution inside a finite responsibility regime. It does not prove profile adequacy, kernel-floor adequacy, source authenticity, Python operational refinement, or an end-to-end theorem from every reachable state directly to entitlement. A Python V0.1.2.2 reference implementation is used only for selected differential conformance tests against the mechanized projection semantics.

---

# 1. Introduction

A finite epistemic system must answer at least two questions about any piece of evidence or derived judgment. The first is historical: **how did this object come to exist?** The second is current: **may this object be relied on now, in this context, for this use?** These questions are related, but they are not identical.

The distinction is easy to state informally and easy to erase in implementation. A database entry may record that a conclusion was once derived from two warrants under a registered rule. If the system later suspends one parent, changes the active context, or otherwise changes the current evaluation state, the historical fact of derivation does not disappear. Conversely, the mere persistence of a historical derivation should not silently preserve current permission to use the conclusion. Systems that encode both facts in one Boolean such as `valid`, `accepted`, or `trusted` make it difficult to identify which responsibility boundary justified a later decision.

This paper studies a deliberately finite setting in which the distinction can be made explicit and machine checked. Its central claim is:

\[
\boxed{
\text{Historical justification and current epistemic responsibility are distinct state relations.}
}
\]

More concretely:

\[
\boxed{
\text{A judgment may be canonically derivable in immutable history without being currently usable or entitled.}
}
\]

The contribution is not a general theory of epistemic adequacy. We do not attempt to prove that a profile contains good rules, that a recorded source is trustworthy, or that a kernel floor captures every normatively necessary condition. Instead, we formalize what correct execution inside a finite responsibility regime can guarantee once the regime has been fixed. This restriction is essential. The work establishes structural non-shortcut properties and explicit state boundaries; it does not turn those boundaries into a universal epistemology.

## 1.1 From one judgment to several responsibility layers

The mechanized architecture separates four layers that are often conflated.

First, an **immutable historical layer** stores canonical contexts, profiles, bindings, and warrants. A historical warrant records its claim, role, scope, constructor, ordered parents, formation profile, formation context, external source where applicable, and two distinct lineage relations. Once a warrant identifier refers to such an object, later transitions preserve that exact referent.

Second, a **mutable evaluation layer** records current status under an explicit evaluation key. Current usability is not a field of the historical warrant. It is defined from two orthogonal evaluation axes: epistemic status and placement. In the current kernel,

\[
Usable(k)
\iff
Epi(k)=LIVE
\land
Placement(k)=PLACED.
\]

Third, a **static entitlement layer** asks whether a concrete branch discharges the exact requirement for a licensing move under an admissible ambient environment and satisfies a kernel floor. Usability is therefore necessary for a canonical warrant to satisfy an atomic branch obligation, but usability is not itself entitlement.

Fourth, **adequacy questions** remain outside the theorem regime. A profile can be executed exactly without being a good profile; a floor can be enforced correctly without being an adequate floor. We keep these non-implications explicit:

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

The paper is about the first three layers and the interfaces between them.

## 1.2 Why reachability matters

A purely static read model can state locality theorems, but it can also hide responsibility in supplied observations. If a theorem assumes an arbitrary Boolean saying that a warrant is usable or that a context is active, the theorem does not yet explain why that Boolean may be trusted. We therefore move from an arbitrary read to an explicit reachable-state model.

The reachable kernel starts from an `InitialBoundary`, advances by a finite set of kernel-owned `Step` transitions, and preserves one shared `CanonicalStateInvariant`. This invariant separates append-only historical referents from mutable current evaluation. It also ties evaluation positions back to canonical historical warrants and prevents partially created evaluation records.

Adopted-context currentness is treated similarly. Instead of accepting an unconstrained currentness flag, the formal model defines a grounded relation in which every retained adopted context has a finite activation chain ending at a bootstrap boundary. A pure cycle cannot manufacture its own currentness.

Reachability does not make every observation endogenous. Some boundaries remain explicit, most notably base license currentness inside the grounded-currentness layer and the absence of a total state-backed assembly theorem for the complete licensing read. The difference is that these remaining boundaries are now named rather than silently distributed across the model.

## 1.3 The two lifecycle examples

The paper's main distinguishing argument comes from two lifecycle families.

**ROOT** is the simpler case. Historical formation creates a fresh canonical root warrant. Formation checks canonical binding and context referents plus context signature acceptance, but it does not create an evaluation position. The newly formed warrant is therefore machine-proved non-usable. A later explicit admission transition writes `LIVE/PLACED` at the exact evaluation key and thereby makes the root usable.

The result is the first boundary:

\[
\boxed{
ROOT\ Formation \not\Rightarrow Current\ Usability.
}
\]

**INFER** strengthens the argument. Historical INFER consumes an exact immutable rule and ordered historical parents. It checks the rule discipline, same-context and same-profile formation environment, scope non-widening, the relevant lineage guards, and formal escalation-strength constraints. Crucially, it does **not** ask whether the parents are currently usable. The derived historical warrant can therefore exist even when no current responsibility chain licenses its use.

Later qualification has a different responsibility. It does not replay rule lookup, guard checking, context acceptance, scope checking, or historical lineage construction. Instead, it requires every historical parent to be currently usable in one selected pre-state evaluation environment. Only then does it establish child usability in the post-state.

This yields the stronger distinction:

\[
\boxed{
\text{historical parent relation}
\neq
\text{current usable-parent responsibility}
}
\]

and a machine-checked lifecycle theorem of the form:

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

The intermediate state still contains the derived historical object, but the child is not usable there.

## 1.4 Contributions

The paper makes three contributions.

**(1) Static entitlement locality.** We define a finite branch-based entitlement calculus and prove Relative Branch Conservativity: for a fixed exact requirement and admissible ambient boundary, entitlement is invariant under changes that preserve the branch-local satisfaction and kernel-floor observations. Exact requirement resolution uses full move identity rather than a weakened projection, and missing requirement declarations remain distinct from explicit `top`. A canonical read model also proves that the satisfaction and floor projections of a derived branch refer to the same canonical warrant objects.

**(2) Reachable canonical state.** We define an explicit reachable-state skeleton with immutable context/profile/binding/warrant referents and a separate mutable evaluation plane. Every modeled step preserves one shared canonical-state invariant. Adopted-context currentness is grounded by finite bootstrap-rooted activation chains, ruling out purely self-supporting currentness.

**(3) Historical formation/current qualification separation.** ROOT and INFER instantiate the central thesis in two different ways. ROOT separates historical existence from explicit admission. INFER further separates historical derivability from current-parent responsibility: formation consumes historical parents without consuming their usability, while qualification consumes their current pre-state usability without replaying formation.

A Python V0.1.2.2 implementation accompanies the mechanization, but we treat it as an executable reference and conformance target rather than as a fourth theoretical contribution. Selected observations are differentially conformance-tested against mechanized projections. We do **not** claim that the Python kernel is verified.

## 1.5 Scope and paper organization

Section 2 states the no-shortcut and regime-boundary design principles. Section 3 presents the static entitlement calculus, exact requirement resolution, and canonical projection coherence. Section 4 introduces reachable canonical state and grounded context currentness. Section 5 proves that ROOT historical formation does not establish current qualification. Section 6 develops ordinary INFER and the distinction between historical parents and current responsible parents. Section 7 describes the executable reference and conformance boundary. Section 8 collects limits and non-theorems. Section 9 positions the work relative to proof-carrying authorization, provenance, dynamic epistemic systems, and mechanized reference monitors. Section 10 discusses TRANSPORT, revision/revalidation, license lifecycle, and the open problem of regime revision.

One interface remains intentionally incomplete in the current artifact. We have narrow state-backed interpretations for historical warrant projection, usability, profile requirement snapshots, and activation-read structure, but no single total theorem constructing a complete `LicensingRead` from every reachable `CanonicalState`. Accordingly, this paper does not claim that the reachable kernel yields entitlement end-to-end. It claims that the kernel establishes current usability and other canonical observations that the previously proved entitlement layer consumes.

---

# 2. Problem and Design Principles

_TODO: full prose after Sections 3–6 stabilize. The section is structurally frozen to the following four principles._

## 2.1 No-shortcut discipline

A later decision must not silently acquire support from observations outside the recorded responsibility boundary.

## 2.2 Immutable history versus mutable evaluation

Historical identity persists; current qualification may change. The model must permit suspension, pending placement, requalification, and future invalidation without rewriting the historical derivation object.

## 2.3 Exact regime execution versus regime adequacy

Correct lookup, formation, qualification, and floor enforcement do not imply that the selected regime is adequate.

## 2.4 Audit metadata versus proof-bearing authority

Recorded actor, basis, source, digest, and other identifiers are audit data unless a theorem explicitly gives them stronger semantics.

---

# 3. Static Entitlement Calculus

The dynamic lifecycle results in Sections 5 and 6 explain how warrants become currently usable. They do not by themselves define entitlement. Entitlement belongs to a smaller static calculus that isolates exactly which observations a fixed licensing judgment consumes.

This separation serves two purposes. First, it gives a compact theorem surface for locality. Second, it prevents later dynamic-state extensions from silently changing what the entitlement theorem means.

## 3.1 Requirements, branches, and derivability

The static calculus distinguishes a requirement from the branch that discharges it. A requirement is a finite obligation expression; a branch is the recorded witness of one concrete discharge path. Declarative derivability has the form

\[
E \vdash \beta : R,
\]

where `E` supplies atomic satisfaction observations, `R` is the exact requirement, and `β` is the recorded branch.

The branch matters because the calculus is intentionally local. For a disjunctive requirement, successful discharge chooses one side; for a conjunction, it records both subbranches. The support of `β` is therefore not an arbitrary candidate set but the concrete evidence responsibility actually used by that derivation.

Branch Conservativity states that if two environments agree on the atomic observations read by a fixed branch, then derivability of that branch is invariant between them. The theorem does not say that all candidate lists or all possible alternative branches are invariant. It says that once the system records `β` as the justification path, facts outside the observation footprint of `β` cannot retroactively become hidden reasons why `β` works.

This is the first locality boundary.

## 3.2 Kernel-floor locality

Derivability alone is insufficient. Some moves are forbidden unless the selected branch satisfies a kernel floor that cannot be weakened by profile requirements. The floor reads a deliberately small projection of each supporting warrant and a deliberately small projection of the move.

Kernel-Floor Locality states that safety of a fixed branch and move is invariant whenever the floor views agree on that branch. Importantly, the floor move is narrower than the full move identity used by requirement resolution. The formal model preserves that firewall: adding ordered move arguments for exact requirement lookup does not enlarge the observation surface of the floor theorem.

This produces a second locality boundary independent of declarative satisfaction.

## 3.3 Relative Branch Conservativity

The abstract entitlement judgment combines three components:

\[
Entitled(S,A,E,F,\beta,\tau,m)
\equiv
Admissible(A)
\land
Derives(E,\beta,A.requirement)
\land
Safe(S,F,\beta,\tau,m).
\]

Here `A` contains the ambient observations required by the current abstract layer, including whether the binding and context are active, whether the use matches, whether the move is within binding scope, and the already resolved exact requirement.

Relative Branch Conservativity (R1) composes the two locality results. For fixed branch, license type, move, floor semantics, and exact requirement `R`, if both ambient views are admissible and resolve to `R`, and if their branch-local satisfaction and floor observations agree, then entitlement is equivalent in the two worlds.

The theorem is deliberately **relative**. It does not establish that `R` is a good requirement or that the ambient regime is normatively sufficient. Its statement is closer to an audit property:

> given this fixed admissible regime and this recorded branch, observations outside the branch-local satisfaction and floor boundary cannot be the hidden reason the entitlement judgment succeeds.

That distinction is important for the later reachable-state model. Dynamic semantics may explain where some ambient observations come from, but R1 remains a theorem about a fixed invocation boundary.

## 3.4 Exact requirement resolution

The early abstract calculus treated `AmbientView.requirement` as already resolved. The mechanization now includes the exact static resolution layer that can supply that field.

A full canonical move contains a move kind, ordered argument list, scope, and revision depth. Ordered arguments are semantic identity:

```text
["a", "b"] ≠ ["b", "a"]
["a"]      ≠ ["a", "a"]
```

Scope is different. Its list representation is a transport encoding of a finite set, so scope identity is extensional and ignores ordering and duplicate transport artifacts.

A requirement key combines license type with this full move identity. A finite immutable snapshot contains unique keys. Lookup is exact: no subsumption, near-match, or priority fallback is available. Soundness and completeness connect executable lookup to the propositional key relation, determinism rules out ambiguous exact keys, and permutation invariance shows that table order cannot become a hidden policy priority.

The most important anti-shortcut result is not merely uniqueness but the treatment of absence:

\[
\boxed{
lookup(k)=none
\not\equiv
lookup(k)=some\;top.
}
\]

An undeclared move is not silently interpreted as an explicit no-obligation move. This matters because otherwise a missing policy entry could be converted into permissiveness by an implementation convention rather than by a declared responsibility rule.

## 3.5 Canonical projection coherence

A second early abstraction separated the satisfaction environment from the floor environment. That is convenient for the two locality theorems, but a concrete licensing interpretation should not allow them to disagree about what warrant an identifier denotes.

`LicensingRead` provides one shared partial canonical warrant lookup and projects it into the declarative environment, executable satisfaction oracle, ambient view, and floor environment. A canonical warrant contains the claim, role, scope, formation profile digest, and formation context needed by the static projections.

The principal coherence result (R3) states that every leaf selected by a derivation over the canonical environment is projection-coherent: the satisfaction fields and the floor leaf come from the same looked-up canonical warrant. This is a modest theorem, but it fixes an important interface responsibility. The static proof does not rely on one object for satisfaction and a different object with the same identifier for floor safety.

## 3.6 What the static layer does not yet assemble

The current artifact has several bridges from reachable state toward this canonical read. A historical warrant has a narrow projection to the read-level canonical warrant. The evaluation plane has a Boolean `usableFromState` interpretation. A canonical profile projects to an exact requirement snapshot. Grounded currentness supplies a non-arbitrary interpretation of context activity for a dynamic read.

What is missing is one total assembly theorem that chooses a binding/context/use/move in a reachable state, resolves every field of `LicensingRead`, and then invokes the entitlement layer. We therefore keep the paper's wording asymmetric:

> the dynamic kernel establishes current usability and canonical historical observations used by the entitlement layer;

not:

> every reachable kernel state yields an entitlement judgment end-to-end.

This boundary will be revisited only if the exposition cannot remain precise without a narrow assembly result.

---

# 4. Reachable Canonical Kernel

The static results of Section 3 are deliberately insensitive to how their observations were produced. That is appropriate for locality, but insufficient for the paper's main dynamic claim. To distinguish historical existence from current usability, we need states and transitions that make the two relations separately visible.

## 4.1 Canonical state

`CanonicalState` contains two planes.

The **historical plane** stores partial immutable lookups for canonical contexts, profiles, bindings, warrants, and activation licenses. These are identity-bearing referents. In particular, a warrant identifier maps to an optional `HistoricalWarrant`, not merely to a presence predicate.

The **evaluation plane** stores active-context facts, activation provenance, review-required facts, and two warrant-evaluation maps:

```text
epi       : EvalKey → Option EpiStatus
placement : EvalKey → Option Placement
```

An evaluation key contains profile digest, context identifier, use, and warrant identifier. The two axes remain independent because they represent different responsibilities. `LIVE/PENDING` and `SUSPENDED/PLACED` are conceptually different failure modes even if both are currently unusable.

Current usability is defined by the conjunction:

\[
Usable(S,k)
\iff
S.epi(k)=LIVE
\land
S.placement(k)=PLACED.
\]

Missing evaluation records are therefore unusable by construction.

## 4.2 Initial boundary, steps, and reachability

The trusted starting point is explicit: every canonical lookup is empty and every evaluation fact is absent. `Reachable` is the inductive closure of this boundary under modeled `Step` transitions.

The current first-paper transition surface includes registration of contexts and profiles, profile binding, bootstrap context activation, ROOT formation and admission, and ordinary INFER formation and qualification. It does not include TRANSPORT, license issuance, challenge/revision/revalidation, or a full operational semantics for the Python implementation.

The point of this finite transition surface is not completeness. It is to ensure that the two lifecycle families used in the paper are generated by an explicit state machine rather than assumed as arbitrary snapshots.

## 4.3 Shared canonical-state invariant

Every reachable state satisfies one shared invariant (R4). The invariant includes referent coherence for bindings, active contexts, historical warrants, parents, and root lineage; exact shape conditions for ROOT history; well-formedness conditions for INFER history; evaluation referent coherence; paired evaluation-axis coherence; and profile/use binding backing for populated evaluation positions.

The invariant is intentionally shared rather than constructor-specific. ROOT and INFER preservation lemmas are proof tools, but the paper-facing claim is that reachability establishes one state contract that later sections may rely on without replaying the transition history.

The historical plane also satisfies an exact referent-preservation law. If a warrant identifier denotes historical object `W` before a modeled transition, it denotes exactly `W` afterwards:

\[
S.warrant(w)=some\;W
\land
Step(S,e,S')
\Rightarrow
S'.warrant(w)=some\;W.
\]

This law is stronger than monotone presence. It makes historical identity stable enough for parent references, lineage, challenge targets, future descendant closure, and branch support to use warrant identifiers as persistent names.

By contrast, evaluation maps are deliberately mutable. Qualification uses an overwrite setter rather than an append-only insertion operation. This permits first qualification, repeated qualification, and future requalification after suspension or pending placement without rewriting the historical object.

## 4.4 Evaluation coherence

Two invariant clauses matter particularly for Sections 5 and 6.

`EvaluationReferentsCanonical` requires any populated evaluation position to point to an existing canonical historical warrant, with evaluation profile/context equal to the warrant's formation profile/context. Thus a reachable state cannot contain `LIVE` for an unknown warrant or for the right warrant under the wrong formation identity.

`EvaluationPairCoherent` rules out half-created evaluation records: epistemic status is absent exactly when placement is absent. This matches the modeled setter discipline, where qualification writes both axes together.

A further invariant, `EvaluationProfileUseBackedByBinding`, requires every populated `(profile,use)` evaluation environment to have canonical binding backing. This is a provenance result, not a use-adequacy result. It says that qualification cannot invent an evaluation use with no binding history somewhere in the state; it does not say that the use is normatively correct.

These invariants allow fresh historical formation to imply non-qualification without storing a special “unqualified” flag. If a warrant identifier is fresh in a reachable pre-state, evaluation referent coherence implies that no evaluation record for that identifier can already exist under any profile/context/use key.

## 4.5 Grounded adopted-context currentness

Context activity is another potential source of hidden responsibility. An adopted context may depend on the currentness of an activation license, whose issuing context may itself depend on another activation license. Treating the resulting dependency relation coinductively would permit a cycle to justify itself.

The formal model instead defines `Grounded` inductively. A context is grounded either because it is seed-active with explicit bootstrap provenance, or because it is seed-active with Adopt provenance whose activation license is base-current, whose issuing context is known, and whose issuing context is itself grounded.

The principal theorem (R5) shows that every grounded context has a finite current activation chain ending at an explicit bootstrap activation. Therefore a world with no bootstrap boundary cannot derive any grounded current context:

\[
\boxed{
\text{pure activation self-support does not create currentness.}
}
\]

The model deliberately leaves `baseCurrent` external. It packages all license-currentness conditions other than issuing-context activity. This prevents the grounded theorem from overclaiming a complete license lifecycle while still closing the recursion responsible for self-support.

## 4.6 From arbitrary worlds to reachable responsibility

The effect of Section 4 is not that every static observation is now derived from state. Rather, the world in which the lifecycle theorems run is no longer arbitrary. Historical identity, evaluation coherence, profile/use backing, and part of context currentness are justified by reachability and groundedness.

This is enough for the central distinction. We can now ask whether a newly formed historical object has any current evaluation position, and the answer is constrained by the state invariant rather than supplied as a Boolean assumption.

---

# 5. Historical Formation Is Not Current Qualification

ROOT provides the simplest lifecycle in which historical existence and current usability diverge.

## 5.1 Historical ROOT objects

A historical root warrant records a claim, role, scope, root constructor, empty ordered parent list, formation profile digest, formation context, external source identity, and two separate role-indexed lineage relations.

The lineage distinction is intentional. Root lineage records historical root-warrant identifiers; source lineage records external source identifiers. For a newly formed ROOT of role `r`, root lineage at `r` contains the new warrant itself while source lineage at `r` contains the external source. Other role buckets are empty.

These relations are extensional sets rather than serialized Python container layouts. The distinction later becomes machine-relevant because ordinary INFER supports different kernel guards over distinct content roots and distinct content sources.

## 5.2 Formation responsibility

A ROOT formation step has a narrow historical responsibility. It requires a fresh warrant identifier, a canonical binding, a canonical context, and acceptance of the input claim by that context's signature. It then inserts the exact historical root object.

Formation deliberately does not require context activity, evaluation-active binding status, or a scope-within-binding condition that the executable ROOT path does not impose. It also does not read or write warrant evaluation state.

The exact-object theorem records these premises and the resulting immutable warrant. Separate preservation results show that all previously existing historical referents remain unchanged and that the evaluation/currentness topology is untouched.

The important point is not merely “ROOT does not call the qualification setter.” In a reachable state, freshness plus evaluation referent coherence yields a stronger theorem: the new warrant identifier has **no evaluation record under any profile/context/use key** in the post-state.

Therefore:

\[
\boxed{
ROOT\ Formation \not\Rightarrow Usable.
}
\]

The conclusion is semantic, not a documentation convention. A newly formed root warrant exists canonically and is machine-proved non-usable.

## 5.3 Explicit admission

ROOT admission is a distinct transition. It requires canonical binding, context, and warrant lookup; the warrant must be a root; its formation context must match the requested context; its formation profile must match the binding profile; and the binding use must match the requested use. The transition then writes `LIVE/PLACED` at the exact evaluation key.

Admission does **not** repeat the formation-time context-signature acceptance check. That responsibility is already carried by the immutable historical object plus reachability invariant. Replaying the check would blur the distinction between formation validity and current admission.

Admission also has no evaluation freshness premise. The shared setter overwrites an existing position. This leaves room for first admission, repeated admission, and future re-admission after evaluation changes.

The resulting theorem is:

\[
\boxed{
Valid\ RootAdmission
\Rightarrow
LIVE \land PLACED
\Rightarrow
Usable.
}
\]

Historical referents remain immutable across this transition.

## 5.4 Recorded metadata is not adequate authority

Admission records actor and basis metadata. The mechanization intentionally gives these strings no authentication or adequacy theorem. They are audit fields.

Accordingly:

\[
RecordedActor
\not\Rightarrow
AuthenticatedPrincipal
\]

and

\[
RecordedBasis
\not\Rightarrow
AdequateBasis.
\]

The lifecycle theorem family therefore proves a declared responsibility boundary: an explicit event changed current qualification. It does not prove that an external normative system was right to authorize that event.

## 5.5 ROOT as the minimal separation theorem

ROOT yields a simple three-state story:

```text
before formation
    warrant absent

        ↓ ROOT formation

after formation
    historical warrant present
    no evaluation record
    not usable

        ↓ explicit admission

after admission
    historical warrant unchanged
    LIVE + PLACED
    usable
```

This already refutes a common collapse:

\[
HistoricalExistence
\Rightarrow
CurrentUsability.
\]

But ROOT does not yet distinguish historical dependencies from current dependencies, because a root has no parents. Ordinary INFER provides that stronger result.

---

# 6. Current-Parent Responsibility

INFER is the central lifecycle of the paper because it separates two relations over the same derivation graph: historical parenthood and current usable-parent responsibility.

## 6.1 Canonical profiles and exact rule lookup

A binding points to an immutable canonical profile by digest. The profile contains both a rule snapshot and the requirement entries used by Section 3. This unifies two previously separate responsibilities under one canonical profile referent:

```text
binding
  ↓ profile digest
CanonicalProfile
  ├── exact rule lookup       → historical INFER
  └── requirement projection  → exact licensing requirement
```

Rule lookup is exact by rule identifier and unique within the snapshot. A missing rule identifier cannot fall back to another rule.

The rule discipline is structural rather than adequacy-bearing. `WellTypedRule` constrains the finite role vocabulary and recognizes only known kernel guards. Protected output roles cannot be generated without the corresponding input responsibility, CONTENT output requires CONTENT input, SELECTION requires nonempty input, and the special audited `CONTENT^n → PROVENANCE` case requires at least two content inputs plus an approved distinctness guard.

These checks justify the statement that the rule follows the current K0 structural discipline. They do not establish `RuleAdequacy`.

## 6.2 Ordered parents versus extensional lineage

Historical parent lists preserve both order and duplicate occurrences. This is necessary because rule application checks the exact ordered sequence of parent roles. Thus

```text
[parentA, parentB] ≠ [parentB, parentA]
```

as an application input, and duplicate identifiers are not silently deduplicated.

Lineage has different semantics. Root lineage and source lineage are role-indexed extensional relations. The output INFER warrant obtains each lineage by role-wise union of all parent lineage buckets. The construction does not filter lineage by the output role.

The distinction is therefore:

```text
parents  = ordered derivational input
lineage  = extensional historical ancestry
```

This makes the two distinctness guards meaningful. `distinct_content_roots` consumes content root lineage; `distinct_content_sources` consumes content source lineage. The fact that #12 represented these as separate relations is therefore not provenance bookkeeping: the two relations are inputs to different kernel guards.

## 6.3 Historical formation discipline

An ordinary INFER formation step requires a fresh child identifier, canonical binding and profile, exact rule lookup, canonical context, ordered canonical parent resolution, and the `InferFormationDiscipline`.

The discipline establishes that every parent was formed under the same context and the same profile snapshot as the child. Parent roles match the rule's ordered input roles exactly. The output claim and role are fixed by the rule. The context accepts the output claim. The output scope cannot widen any parent scope. The kernel guard is satisfied. If the output carries a formally interpreted escalation depth, the step cannot amplify it beyond the available parent escalation strength.

Thus ordinary INFER is machine-fixed as both intra-context and intra-profile-snapshot:

\[
\boxed{
INFER\ is\ intra\text{-}context
}
\]

and

\[
\boxed{
INFER\ is\ intra\text{-}profile\text{-}snapshot.
}
\]

This matters for future TRANSPORT. Cross-context movement will require a different constructor family rather than being an accidental relaxation of INFER.

The formal escalation interpretation currently covers a small canonical spelling of depths rather than proving correspondence with every Python integer-parsing behavior. The theorem should therefore be read as no amplification under the formal canonical depth interpretation, not as a complete Python refinement result.

## 6.4 Formation does not consume parent usability

The most important omission from `InferFormationDiscipline` is deliberate: it contains no current-parent usability premise.

Historical INFER asks whether the parent identifiers resolve canonically, whether they belong to the right formation environment, and whether the rule-governed historical step is structurally valid. It does not inspect the evaluation plane.

Consequently, current parent status cannot prevent the historical fact of derivation from being recorded. A system may have historical parents that are suspended, pending, or never admitted; if the historical formation premises hold, INFER may still create the derived historical warrant.

As with ROOT, formation leaves the evaluation topology unchanged. In a reachable pre-state, freshness implies that the child has no evaluation record anywhere after formation. Therefore:

\[
\boxed{
INFER\ Formation
\not\Rightarrow
Current\ Usability.
}
\]

This is already stronger than the ROOT result. The historical object can encode a nontrivial derivation graph while remaining outside current responsibility.

## 6.5 Qualification consumes current parents, not formation again

INFER qualification is a separate transition over an already formed historical child. It requires a canonical binding and child warrant, verifies that the child constructor is `infer`, and checks exact formation context/profile agreement with the selected environment.

It then imposes its new responsibility:

\[
InferParentsUsable(S,p,c,u,w)
\equiv
\forall parentId\in w.parents,
Usable(S,\langle p,c,u,parentId\rangle).
\]

This predicate is explicitly indexed by the **pre-state**.

Qualification does not re-run exact rule lookup, rule typing, kernel guards, context acceptance, scope non-widening, lineage construction, or escalation-strength checks. Those are historical formation responsibilities already carried by the immutable warrant and the shared reachable invariant.

This is a deliberate anti-replay principle:

\[
\boxed{
HistoricalFormationValidity
\text{ is carried by immutable history, not re-proved at every qualification.}
}
\]

After the parent-usability obligation is met, the shared qualification setter writes `LIVE/PLACED` at the exact child evaluation key, so the child becomes usable in the post-state.

The direction is temporal:

\[
\boxed{
ParentsUsable_{pre}
+
ExplicitQualification
\Rightarrow
ChildUsable_{post}.
}
\]

We do not assert the converse invariant that every currently usable child must have currently usable parents in all future states. Later challenge, revision, and invalidation transitions may change currentness. Synchronizing those changes is a future lifecycle problem, not part of the formation/qualification theorem.

## 6.6 Nonempty current-parent responsibility

A universal parent-usability condition would be vacuous for an empty parent list. The formal rule discipline closes this hole.

Every well-typed rule in the current finite role vocabulary has a nonempty input-role list. Combined with exact ordered parent-role agreement in reachable INFER history, any well-formed INFER warrant has nonempty parents.

This result also explains an asymmetry in the executable qualification API. ROOT admission explicitly checks `binding.use = use`; derived qualification currently does not repeat that check. The formal model does not silently add it.

Instead, the shared invariant requires every populated evaluation `(profile,use)` to have canonical binding backing. Because a well-formed INFER has at least one parent, and qualification requires every parent to be usable in the exact selected `(profile,context,use)` environment, at least one pre-existing usable parent carries binding-backed profile/use provenance. The child inherits the same `(profile,use)` evaluation environment.

Hence the formal model proves the structural property:

\[
\boxed{
\text{INFER qualification does not originate an unbacked use.}
}
\]

This is not equivalent to requiring that the binding argument supplied to qualification itself has matching use, and it is not a use-adequacy theorem. The result identifies where the responsibility actually comes from: the current predecessor chain.

## 6.7 Lifecycle separation theorem

The two milestones compose into one paper-facing lifecycle theorem (R9). Suppose a reachable state `S_0` takes a historical INFER formation step to `S_1`, then an explicit INFER qualification step to `S_2`. The theorem recovers a canonical derived warrant in `S_1`, establishes that its historical parents are currently usable in the qualification environment of `S_1`, proves that the child is **not** usable in `S_1`, and proves that it **is** usable at the exact child key in `S_2`.

The state trace is therefore:

```text
historical parent warrants
        │
        │ rule-governed INFER formation
        │ does not consume parent usability
        ▼
derived historical warrant
        │
        ├── historical object exists
        └── child not usable
                  │
                  │ explicit qualification
                  │ consumes parent usability NOW
                  ▼
             child usable
```

The conceptual result is not merely that the implementation has two functions. It is that the model supports two formally distinct relations over one history graph:

\[
\boxed{
\text{historical derivation relation}
\neq
\text{current responsibility chain}.
}
\]

Historical parenthood answers where the child came from. Current usable-parent responsibility answers whether the system may presently qualify that child in a particular evaluation environment. The former is immutable history; the latter is a pre-state condition that may change.

## 6.8 Usability still is not entitlement

After qualification, the child is usable. Nothing in R8 or R9 implies that a licensing move is entitled.

The static entitlement layer additionally requires an admissible ambient environment, exact requirement discharge by a branch, and kernel-floor safety. A usable child may fail to match the required claim or role, may be outside the relevant branch scope, may exist under a context that is not currently grounded-active, or may be insufficient for the exact move requirement.

Therefore:

\[
\boxed{
CurrentDerivedUsable
\not\Rightarrow
Entitled.
}
\]

This boundary is also the point at which the present artifact stops short of an end-to-end reachable-state entitlement theorem. Sections 3–6 together establish the semantic separation needed by such a theorem, but they do not yet assemble every `LicensingRead` field directly from reachable state.

---

# 7. Executable Reference and Conformance

_TODO: write after Sections 1 and 3–6 stabilize._

Frozen scope:

- describe Python V0.1.2.2 as an executable reference kernel;
- explain the canonical-read fixture adapter and grounded-currentness fixtures;
- report selected differential conformance results;
- distinguish pre-refresh seed/provenance observations from post-transition `BaseCurrent` and active-context observations;
- state prominently that 63 passing tests are conformance evidence and non-regression, not Python operational refinement;
- do not claim ROOT/INFER transition refinement unless a new explicit conformance milestone is added.

Preferred wording:

> Selected executable observations are differentially conformance-tested against the mechanized projection semantics.

Forbidden wording:

> The Python kernel is verified.

---

# 8. Limits and Non-Theorems

_TODO: expand into prose; keep the list stable._

The current paper does not prove:

```text
ProfileAdequacy
KernelFloorAdequacy
RuleAdequacy
RootAdmissionAdequacy
UseAdequacy
source authenticity
actor authentication
Python operational refinement
TRANSPORT lifecycle
license issuance lifecycle
challenge/revision/revalidation
complete BaseCurrent adequacy
CanonicalState → LicensingRead → Entitled end-to-end assembly
Q_open
Q_close
```

These boundaries should be framed as theorem-regime delimiters, not buried as implementation caveats.

---

# 9. Related Work

_TODO: literature pass required before prose._

Comparison axes to develop:

```text
proof-carrying authorization / trust management
reference-monitor and security-kernel verification
provenance and lineage systems
truth-maintenance / belief-revision systems
dynamic epistemic logic and justification logic
dataflow / dependency invalidation
proof-relevant semantics and audit logs
capability systems and policy snapshots
```

The distinctive comparison question is whether a system explicitly separates immutable derivational existence from mutable current qualification and then connects both to a finite entitlement boundary.

---

# 10. Discussion and Future Work

_TODO: prose after theorem-gap review._

Priority order during the paper freeze:

1. add no new core semantics unless Sections 3–6 expose a theorem gap that cannot be stated honestly;
2. if needed, prefer a narrow **State-Backed Licensing Read Assembly** theorem over constructor expansion;
3. treat TRANSPORT as a cross-context strengthening result;
4. later add challenge/revision/revalidation and license lifecycle;
5. keep Q_open and Q_close as separate theoretical programs.

The main conceptual future boundary is regime revision. The present work proves correct execution inside a finite responsibility regime. It does not prove when the regime itself should be reopened or revised.

A future Q_open result should therefore be anti-circular rather than universal: changes to the regime that defines sufficiency should require responsibility not reducible to the very regime under challenge. That question is intentionally outside the first paper.
