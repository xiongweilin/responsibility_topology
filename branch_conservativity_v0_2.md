# Responsibility Topology — Branch Conservativity Formal Proof V0.2

This document upgrades the V0.1 inference sheet into the first hand-formal proof
package extracted from executable kernel V0.1.2.2. The arguments below are
mathematical proofs over the extracted semantics; they have not yet been
mechanized in Lean/Coq.

The theorem boundary is unchanged:

\[
\boxed{
\text{Branch Conservativity is relative to an admissible ambient environment.}
}
\]

BC proves responsibility-branch locality. It does not close the full ambient
dependency graph of a license.

---

## Proof dependency order

The proof package is organized in the dependency order

\[
\boxed{
NW\;\rightarrow\;BC\;\rightarrow\;SS\;\rightarrow\;SP\;\rightarrow\;KFL\;\rightarrow\;RBC.
}
\]

`NW` is algorithmic monotonicity under candidate deletion; `BC` is the
extensional branch-local theorem; `SS` and `SP` connect the executable search
to the proof system; `KFL` isolates the kernel floor; `RBC` composes the pieces.

## Standing assumptions

### Reachable-environment universe

All environments considered in this sheet satisfy

\[
E=(H,\sigma,b,c,u)\in Reach_{\mathbb K_0}.
\]

`Reach_{\mathbb K_0}` is the least class containing the declared external
boundary states and closed under the trusted kernel transition relation

\[
(H,\sigma)\xrightarrow{\delta_{\mathbb K_0}}(H',\sigma').
\]

Thus the proof universe excludes arbitrary incoherent states that the kernel
cannot produce, such as a manually fabricated `LIVE` derived warrant whose
required parent state has never been qualified.

This reachability assumption is not used to hide branch-external premises.
Binding/context/profile/use conditions still remain explicit in `Adm`.

### Canonical candidate sequences

Let \(\Gamma\) range over finite sequences of warrant IDs.

Define

\[
WF_H(\Gamma)
\quad\Longleftrightarrow\quad
\forall w\in\Gamma,\; w\in dom(Warrants_H).
\]

Every executable theorem about `satisfy` assumes \(WF_H(\Gamma)\).

This is necessary because unknown candidate IDs cause canonical lookup failure;
they are not interpreted as ordinary non-matching candidates.

---

## 1. Ambient admissibility

Let

\[
E=(H,\sigma,b,c,u).
\]

Define

\[
\iota(E)=
\bigl(
profileDigest_H(b),
c,
u
\bigr).
\]

Let \(P_E\) be the immutable profile snapshot selected by \(b\).

For license type \(\tau\) and move \(m\),

\[
Adm(E,\tau,m)
\]

holds iff:

\[
\begin{aligned}
&b\in ActiveBindings_\sigma,\\
&Binding_H(b).use=u,\\
&c\in Contexts_H,\\
&ContextStatus_\sigma(b,c,u)=ACTIVE,\\
&m.scope\sqsubseteq Binding_H(b).scope,\\
&P_E=Profile_H(Binding_H(b).profileDigest),\\
&Req_{P_E}(\tau,m)=R
\quad\text{for an exact }R.
\end{aligned}
\]

Requirement identity is exact in

\[
(\tau,kind,args,revisionDepth,scope).
\]

For non-bootstrap contexts, `ContextStatus=ACTIVE` may continuously depend on a
prior Adopt license. That dependency belongs to ambient admissibility.

---

## 2. Requirement and branch syntax

\[
R::=
\top
\mid A
\mid R\land R
\mid R\lor R
\]

with atomic obligation

\[
A=(claim,role,scope).
\]

\[
\beta ::=
\mathbf{top}
\mid \mathbf{leaf}(A,w)
\mid \mathbf{and}(\beta_1,\beta_2)
\mid \mathbf{orL}(\beta)
\mid \mathbf{orR}(\beta).
\]

Immediate support:

\[
Supp(\mathbf{top})=\varnothing
\]

\[
Supp(\mathbf{leaf}(A,w))=\{w\}
\]

\[
Supp(\mathbf{and}(\beta_1,\beta_2))
=
Supp(\beta_1)\cup Supp(\beta_2)
\]

\[
Supp(\mathbf{orL}(\beta))
=
Supp(\mathbf{orR}(\beta))
=
Supp(\beta).
\]

Historical support:

\[
HistSupp_H(\beta)
=
Anc_H^\ast(Supp(\beta)).
\]

BC is about `Supp`; historical auditability is recovered through `HistSupp`.

---

## 3. Atomic satisfaction

Write

\[
E\vdash w:A
\]

for \(A=(\varphi,r,B_A)\) iff:

\[
\begin{aligned}
&Usable_\sigma(P_E.digest,c,u,w),\\
&Warrant_H(w).formationContext=c,\\
&Warrant_H(w).formationProfileDigest=P_E.digest,\\
&Warrant_H(w).claim=\varphi,\\
&Warrant_H(w).role=r,\\
&B_A\sqsubseteq Warrant_H(w).scope.
\end{aligned}
\]

No semantic entailment oracle is consulted.

---

## 4. Branch proof rules

\[
\frac{}{
E\vdash\mathbf{top}:\top
}
[\textsc{Top}]
\]

\[
\frac{
E\vdash w:A
}{
E\vdash\mathbf{leaf}(A,w):A
}
[\textsc{Atom}]
\]

\[
\frac{
E\vdash\beta_1:R_1
\qquad
E\vdash\beta_2:R_2
}{
E\vdash\mathbf{and}(\beta_1,\beta_2):R_1\land R_2
}
[\land]
\]

\[
\frac{
E\vdash\beta:R_1
}{
E\vdash\mathbf{orL}(\beta):R_1\lor R_2
}
[\lor L]
\]

\[
\frac{
E\vdash\beta:R_2
}{
E\vdash\mathbf{orR}(\beta):R_1\lor R_2
}
[\lor R].
\]

The executable left-first search strategy is not a proof rule.

---

## 5. Satisfaction equivalence

Define

\[
E\equiv^{sat}_{\beta}E'
\]

iff:

1.

\[
\iota(E)=\iota(E');
\]

2. for every \(w\in Supp(\beta)\), the canonical fields queried by atomic
satisfaction are equal across the two environments:

\[
claim,\ role,\ scope,\ formationContext,\ formationProfileDigest;
\]

3. for every \(w\in Supp(\beta)\),

\[
Usable_E(w)\iff Usable_{E'}(w).
\]

### Lemma EQ-Restrict

If

\[
E\equiv^{sat}_{\beta}E'
\]

and

\[
Supp(\beta_i)\subseteq Supp(\beta),
\]

then

\[
\boxed{
E\equiv^{sat}_{\beta_i}E'.
}
\]

#### Proof

The ambient index equality is unchanged. All canonical/status equalities
required for \(\beta_i\) quantify over a subset of those already required for
\(\beta\). ∎

---

# Lemma NW — No-New-Witness Under Deletion

Assume

\[
E\in Reach_{\mathbb K_0},
\qquad
WF_H(\Gamma),
\qquad
WF_H(\Gamma'),
\]

and \(\Gamma'\) is an order-preserving subsequence of \(\Gamma\).

If

\[
satisfy(E,R,\Gamma)
\]

fails by ordinary requirement unsatisfaction, then

\[
\boxed{
satisfy(E,R,\Gamma')
\text{ also fails.}
}
\]

### Proof

By structural induction on \(R\).

**Case \(\top\).**
Impossible premise: `Top` always succeeds.

**Case \(A\).**
Failure means no \(w\in\Gamma\) satisfies the atomic predicate. Since
\(\Gamma'\) contains only elements of \(\Gamma\), no \(w\in\Gamma'\) satisfies
it either.

**Case \(R_1\land R_2\).**
Executable conjunction fails because at least one recursive call fails on
\(\Gamma\). Apply the induction hypothesis to that failing conjunct.

**Case \(R_1\lor R_2\).**
Executable disjunction fails only if both recursive calls fail on \(\Gamma\).
By the induction hypotheses both remain failed on \(\Gamma'\). Hence the
disjunction still fails.

Canonical well-formedness excludes lookup exceptions from the meaning of
ordinary satisfaction failure. ∎

---


# Theorem BC — Support Conservativity

If

\[
E\equiv^{sat}_{\beta}E',
\]

then for every requirement \(R\),

\[
\boxed{
E\vdash\beta:R
\iff
E'\vdash\beta:R.
}
\]

### Proof

By structural induction on \(\beta\).

**Case \(\mathbf{top}\).**
Both directions follow from \([\textsc{Top}]\).

**Case \(\mathbf{leaf}(A,w)\).**
Here \(Supp(\beta)=\{w\}\). By satisfaction equivalence, all fields and current
usability queried by the atomic judgment agree. Hence

\[
E\vdash w:A
\iff
E'\vdash w:A,
\]

and therefore by \([\textsc{Atom}]\),

\[
E\vdash\mathbf{leaf}(A,w):A
\iff
E'\vdash\mathbf{leaf}(A,w):A.
\]

**Case \(\mathbf{and}(\beta_1,\beta_2)\).**
From

\[
Supp(\beta_i)\subseteq Supp(\beta)
\]

and EQ-Restrict,

\[
E\equiv^{sat}_{\beta_i}E'
\]

for \(i=1,2\). Apply the induction hypotheses to each child and then the
\([\land]\) rule in both directions.

**Case \(\mathbf{orL}(\beta_0)\).**
By EQ-Restrict and the induction hypothesis,

\[
E\vdash\beta_0:R_1
\iff
E'\vdash\beta_0:R_1.
\]

Apply \([\lor L]\).

**Case \(\mathbf{orR}(\beta_0)\).**
Identical, using \([\lor R]\).

Thus branch satisfaction is invariant under changes outside the branch's
direct satisfaction projection. ∎

---

## 6. Executable witness search

Write

\[
satisfy(E,R,\Gamma)=\beta
\]

for the deterministic executable search on canonical candidate sequence
\(\Gamma\).

For branch \(\beta\), define order-preserving projection

\[
\Gamma\!\upharpoonright_\beta
=
[w\in\Gamma\mid w\in Supp(\beta)].
\]

---

# Theorem SS — Satisfaction Soundness

Assume

\[
E\in Reach_{\mathbb K_0},
\qquad
WF_H(\Gamma).
\]

If

\[
satisfy(E,R,\Gamma)=\beta,
\]

then

\[
\boxed{
E\vdash\beta:R.
}
\]

### Proof

By induction on \(R\).

**Case \(\top\).**
The executable returns `top`; apply \([\textsc{Top}]\).

**Case \(A\).**
The executable returns `leaf(A,w)` only after canonical lookup and exactly the
checks defining \(E\vdash w:A\). Apply \([\textsc{Atom}]\).

**Case \(R_1\land R_2\).**
The executable recursively returns \(\beta_1,\beta_2\). By the induction
hypotheses,

\[
E\vdash\beta_1:R_1
\quad\text{and}\quad
E\vdash\beta_2:R_2.
\]

Apply \([\land]\).

**Case \(R_1\lor R_2\), left success.**
By induction, the returned left branch proves \(R_1\). Apply \([\lor L]\).

**Case \(R_1\lor R_2\), left failure and right success.**
By induction, the returned right branch proves \(R_2\). Apply \([\lor R]\).
The fact that the implementation searched left first is irrelevant to the
validity of the returned proof branch.

∎

---

# Theorem SP — Support Projection / Exact Replay

Assume

\[
E\in Reach_{\mathbb K_0},
\qquad
WF_H(\Gamma),
\]

and

\[
satisfy(E,R,\Gamma)=\beta.
\]

Then

\[
\boxed{
satisfy(
E,
R,
\Gamma\!\upharpoonright_\beta
)
=
\beta.
}
\]

### Proof

By induction on \(R\).

**Case \(\top\).**
Projection is irrelevant; both runs return `top`.

**Case \(A\).**
Suppose the original run selected warrant \(w\), hence

\[
\beta=\mathbf{leaf}(A,w).
\]

The projection retains \(w\). Any projected candidate occurring before \(w\)
also occurred before \(w\) in the original sequence. If such a candidate
satisfied \(A\), the original deterministic search would have selected it
instead. Therefore \(w\) remains the first matching witness and the same leaf
is returned.

**Case \(R_1\land R_2\).**
Suppose

\[
\beta=\mathbf{and}(\beta_1,\beta_2).
\]

The projected candidate sequence retains all support used by each child:

\[
Supp(\beta_i)\subseteq Supp(\beta).
\]

The global projection may additionally retain warrants used by the other child,
but every retained warrant preserves its original relative order. Such extra
retained warrants cannot become a new earlier witness for a child: if they
matched that child's atomic search earlier than its recorded witness, they
already appeared in the original \(\Gamma\) and would have changed the original
branch.

Equivalently, apply the induction hypotheses together with order preservation
to each recursive call. Both child calls replay \(\beta_1,\beta_2\), hence the
conjunction returns the same `and` branch.

**Case \(R_1\lor R_2\), left branch.**
Apply the induction hypothesis to the selected left branch. The projected
sequence retains exactly the recorded support plus possibly duplicates already
present in the original order; the left call returns the same branch, so the
outer call returns the same `orL`.

**Case \(R_1\lor R_2\), right branch.**
Suppose the original result is

\[
\mathbf{orR}(\beta_2).
\]

Then the left recursive search failed on \(\Gamma\), while the right search
returned \(\beta_2\).

The projection is an order-preserving subsequence of \(\Gamma\), so by NW the
left search still fails. By the induction hypothesis, the right search replays
\(\beta_2\). Therefore the executable again returns exactly

\[
\mathbf{orR}(\beta_2).
\]

∎

---

## 7. Kernel-floor locality

Let

\[
LeafOcc(\beta)
\]

be the ordered leaf occurrences of \(\beta\).

Define

\[
FloorView_H(\beta)
=
[
(claim_H(w),role_H(w),scope_H(w))
\mid
(A,w)\in LeafOcc(\beta)
].
\]

For fixed \(\tau,m\), write

\[
H\vdash_{\mathbb K_0}Safe(\beta,\tau,m)
\]

for the V0.1.2.2 kernel floor check.

Current floor clauses inspect only \(\tau,m\) and this leaf view:

- move scope is covered by every used leaf;
- action requires authorization;
- share requires selection;
- suspect/reopen/adopt require escalation;
- escalation depth must cover move revision depth;
- adopt additionally requires selection;
- resolve-status requires selection or authorization;
- normative licensing fails closed.

---

# Lemma KFL — Kernel-Floor Locality

If

\[
FloorView_H(\beta)=FloorView_{H'}(\beta),
\]

then for fixed \(\tau,m\),

\[
\boxed{
H\vdash_{\mathbb K_0}Safe(\beta,\tau,m)
\iff
H'\vdash_{\mathbb K_0}Safe(\beta,\tau,m).
}
\]

### Proof

Each closed floor clause is a function only of:

\[
\tau,\quad m,\quad FloorView(\beta).
\]

No clause queries a warrant outside the recorded leaf occurrences, their
ancestors, candidate IDs not selected into the branch, or ambient context
activation dependencies.

Therefore equal floor views yield identical floor-check results. ∎

---

## 8. Licensing

\[
\frac{
Adm(E,\tau,m)
\qquad
Req_{P_E}(\tau,m)=R
\qquad
E\vdash\beta:R
\qquad
H\vdash_{\mathbb K_0}Safe(\beta,\tau,m)
}{
E\vdash License(\tau,m,\beta)
}
[\textsc{License}]
\]

The rule separates:

\[
\boxed{
Ambient\ admissibility
+
Profile\ obligation
+
Kernel\ floor.
}
\]

---

# Corollary RBC — Relative Branch Conservativity

Let \(E,E'\in Reach_{\mathbb K_0}\). Fix \(\tau,m,R,\beta\). Assume:

\[
Adm(E,\tau,m),
\qquad
Adm(E',\tau,m),
\]

\[
Req_{P_E}(\tau,m)
=
Req_{P_{E'}}(\tau,m)
=
R,
\]

\[
E\equiv^{sat}_{\beta}E',
\]

and

\[
FloorView_H(\beta)=FloorView_{H'}(\beta).
\]

Then

\[
\boxed{
E\vdash License(\tau,m,\beta)
\iff
E'\vdash License(\tau,m,\beta).
}
\]

### Proof

By BC,

\[
E\vdash\beta:R
\iff
E'\vdash\beta:R.
\]

By KFL,

\[
Safe_H(\beta,\tau,m)
\iff
Safe_{H'}(\beta,\tau,m).
\]

The two ambient admissibility premises and exact profile requirement are
assumed on both sides. Apply \([\textsc{License}]\) in each direction. ∎

### Meaning

Under fixed admissible ambience and the same exact immutable requirement, no
warrant outside the recorded branch can become hidden profile-discharge or
kernel-floor justification for that license derivation.

RBC does **not** state that the total license is independent of all
branch-external facts.

The following remain explicit ambient premises:

\[
BindingActive,\quad
ContextActive,\quad
ProfileSnapshot,\quad
Use,\quad
BindingScope.
\]

For adopted contexts, `ContextActive` may recursively depend on current Adopt
licenses. V0.1.2.2 enforces that dependency by fixed-point ambient-currentness
refresh.

Hence:

\[
\boxed{
\text{BC concerns responsibility-branch locality,
not closure of all ambient dependencies.}
}
\]

---

## 9. What has now been proved

Within the formal abstraction above:

\[
\boxed{
\textbf{BC: branch satisfaction is support-local.}
}
\]

\[
\boxed{
\textbf{SS: executable satisfaction returns a valid proof branch.}
}
\]

\[
\boxed{
\textbf{SP: the recorded branch is exactly replayable after deleting
unselected candidates.}
}
\]

\[
\boxed{
\textbf{KFL: the kernel licensing floor is leaf-view local.}
}
\]

\[
\boxed{
\textbf{RBC: under fixed admissible ambience and exact requirement,
branch-external warrants provide no hidden branch licensing justification.}
}
\]

These are not yet whole-kernel soundness theorems.

They do not prove:

- that the active profile exhausts all possible responsibilities;
- that external root admission is true;
- that ambient activation dependencies are branch-local;
- agent-indexed distributed obligation discharge;
- a total ordering of move strength;
- full correctness of Q_open or Q_close.

They are the first narrow metatheorems whose claims match the executable
reference semantics without crossing those boundaries.
