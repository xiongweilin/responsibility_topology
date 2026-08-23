# Responsibility Topology — Branch Conservativity Formal Sheet V0.1

Status: first proof-theoretic extraction from executable kernel V0.1.2.1.

Scope: this sheet proves **responsibility-branch locality relative to an admissible ambient environment**. It does **not** claim that a license is independent of binding/profile/context/use dependencies.

---

## 0. Ambient environment

Let

\[
E=(H,\sigma,b,c,u).
\]

Define the ambient index

\[
\iota(E)=
\bigl(
\operatorname{profileDigest}(b),
c,
u
\bigr).
\]

Let \(P_E\) be the immutable profile snapshot selected by \(b\).

For license type \(\tau\) and move \(m\), define

\[
\operatorname{Adm}(E,\tau,m)
\]

iff all of the following hold:

\[
\begin{aligned}
&b\in ActiveBindings_\sigma,\\
&Binding_H(b).use=u,\\
&c\in Contexts_H,\\
&ContextStatus_\sigma(b,c,u)=ACTIVE,\\
&m.scope\sqsubseteq Binding_H(b).scope,\\
&P_E=Profile_H(Binding_H(b).profileDigest),\\
&Req_{P_E}(\tau,m)=R
\quad\text{for some exact requirement }R.
\end{aligned}
\]

The last lookup is exact in

\[
(\tau,\;kind,\;args,\;revisionDepth,\;scope).
\]

`Adm` is an explicit theorem premise. In particular, context activation may itself depend on a still-current earlier `Adopt` license; that dependency is **ambient**, not part of the branch theorem.

---

## 1. Requirement and branch syntax

Requirements:

\[
R ::=
\top
\mid A
\mid R\land R
\mid R\lor R
\]

where an atomic obligation is

\[
A=(claim,role,scope).
\]

Branches:

\[
\beta ::=
\mathbf{top}
\mid \mathbf{leaf}(A,w)
\mid \mathbf{and}(\beta_1,\beta_2)
\mid \mathbf{orL}(\beta)
\mid \mathbf{orR}(\beta).
\]

Define leaf occurrences recursively:

\[
LeafOcc(\mathbf{top})=[]
\]

\[
LeafOcc(\mathbf{leaf}(A,w))=[(A,w)]
\]

\[
LeafOcc(\mathbf{and}(\beta_1,\beta_2))
=
LeafOcc(\beta_1)\mathbin{+\!\!+}LeafOcc(\beta_2)
\]

\[
LeafOcc(\mathbf{orL}(\beta))
=
LeafOcc(\mathbf{orR}(\beta))
=
LeafOcc(\beta).
\]

Define immediate support:

\[
Supp(\beta)
=
\{\,w\mid (A,w)\in LeafOcc(\beta)\,\}.
\]

`Supp` is a set of immediate licensing witnesses. It is not the full historical basis.

Let \(Parents_H(w)\) be the canonical derivation parents recorded in append-only history. Define the reflexive-transitive ancestor closure:

\[
HistSupp_H(\beta)
=
Anc_H^\ast(Supp(\beta)).
\]

Thus a derived warrant used as a branch leaf does not become an unexplained primitive: its complete historical lineage remains reconstructible through \(HistSupp\).

---

## 2. Atomic satisfaction

Write

\[
E\vdash w:A
\]

iff, for \(A=(\varphi,r,B_A)\),

\[
\begin{aligned}
&Usable_\sigma(
  P_E.digest,c,u,w
),\\
&Warrant_H(w).formationContext=c,\\
&Warrant_H(w).formationProfileDigest=P_E.digest,\\
&Warrant_H(w).claim=\varphi,\\
&Warrant_H(w).role=r,\\
&B_A\sqsubseteq Warrant_H(w).scope.
\end{aligned}
\]

This is exactly the semantic content of the executable kernel's atomic `satisfy` check.

No semantic implication relation is consulted here. If a claim must be strengthened or transformed, an explicit warrant-producing `INFER` or `TRANSPORT` node must already exist in \(H\).

---

## 3. Branch satisfaction judgment

Write

\[
E\vdash\beta:R.
\]

The rules are:

\[
\frac{}{
E\vdash\mathbf{top}:\top
}
\;[\textsc{Top}]
\]

\[
\frac{
E\vdash w:A
}{
E\vdash\mathbf{leaf}(A,w):A
}
\;[\textsc{Atom}]
\]

\[
\frac{
E\vdash\beta_1:R_1
\qquad
E\vdash\beta_2:R_2
}{
E\vdash
\mathbf{and}(\beta_1,\beta_2):
R_1\land R_2
}
\;[\land]
\]

\[
\frac{
E\vdash\beta:R_1
}{
E\vdash
\mathbf{orL}(\beta):
R_1\lor R_2
}
\;[\lor L]
\]

\[
\frac{
E\vdash\beta:R_2
}{
E\vdash
\mathbf{orR}(\beta):
R_1\lor R_2
}
\;[\lor R].
\]

These are proof rules. The executable implementation's left-first search order for `Or` is **not** part of the logic; it is only a deterministic witness-search strategy.

---

## 4. Satisfaction-equivalence of ambient environments

The branch theorem must not allow the ambient indices read by atomic satisfaction to drift silently.

Define

\[
E\equiv^{sat}_{\beta}E'
\]

iff:

1. the atomic evaluation index is the same,

\[
\iota(E)=\iota(E');
\]

2. for every \(w\in Supp(\beta)\), the canonical fields inspected by atomic satisfaction are equal:

\[
\begin{aligned}
&claim_H(w)=claim_{H'}(w),\\
&role_H(w)=role_{H'}(w),\\
&scope_H(w)=scope_{H'}(w),\\
&formationContext_H(w)=formationContext_{H'}(w),\\
&formationProfileDigest_H(w)
=
formationProfileDigest_{H'}(w);
\end{aligned}
\]

3. for every \(w\in Supp(\beta)\),

\[
Usable_E(w)\iff Usable_{E'}(w).
\]

This equivalence is deliberately shallow: it captures exactly what branch satisfaction queries directly.

For later whole-responsibility tracing, a stronger historical equivalence can separately require preservation of all canonical nodes and parent edges in \(HistSupp_H(\beta)\).

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

- `top`: immediate.
- `leaf(A,w)`: follows directly from the definition of \(E\equiv^{sat}_{\beta}E'\).
- `and`: apply the induction hypothesis independently to both children.
- `orL`, `orR`: apply the induction hypothesis to the unique child.

Therefore branch discharge is local to the canonical/status projection of its actual immediate support.

---

## 5. Executable witness-search semantics

Let

\[
satisfy(E,R,\Gamma)
\]

denote the deterministic executable search, where \(\Gamma\) is a sequence of canonical warrant IDs.

For a branch \(\beta\), define the order-preserving support projection

\[
\Gamma\!\upharpoonright_\beta
=
[w\in\Gamma\mid w\in Supp(\beta)].
\]

This is a sequence filter, not a set conversion; duplicate occurrences, if any, retain their original order.

A small algorithmic helper is needed.

### Lemma NW — No-New-Witness Under Deletion

If

\[
satisfy(E,R,\Gamma)
\]

fails and \(\Gamma'\) is an order-preserving subsequence of \(\Gamma\), then

\[
satisfy(E,R,\Gamma')
\]

also fails.

### Proof sketch

By induction on \(R\).

- `Top` never fails.
- `Atom`: failure means no candidate in \(\Gamma\) satisfies the atomic predicate. A subsequence cannot introduce one.
- `And`: failure of at least one conjunct remains failure after deletion by induction.
- `Or`: failure means both sides fail; both remain failed after deletion.

This lemma is the only property needed to handle executable `or-right`. The left-first search order itself is not a logical rule.

---

# Theorem SS — Satisfaction Soundness

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

By structural induction on \(R\), following the executable cases.

- `Top`: returns `top`.
- `Atom`: the algorithm returns a leaf only after exactly the checks in the atomic satisfaction definition.
- `And`: both recursive calls succeed; apply induction hypotheses and rule \([\land]\).
- `Or-left`: left recursive call succeeds; apply \([\lor L]\).
- `Or-right`: left failed and right succeeded; soundness of the returned branch uses only the right induction hypothesis and \([\lor R]\).

---

# Theorem SP — Support Projection / Replay

If

\[
satisfy(E,R,\Gamma)=\beta,
\]

then

\[
\boxed{
satisfy
\left(
E,
R,
\Gamma\!\upharpoonright_\beta
\right)
=
\beta.
}
\]

### Proof sketch

By induction on \(R\).

- `Top`: trivial.
- `Atom`: the originally selected warrant remains in the projected sequence. Any earlier projected warrant that could replace it would also have appeared earlier in the original sequence and would therefore have been selected originally.
- `And`: use induction hypotheses for both subbranches. The global projection preserves the original order of all support IDs; deleting non-support candidates cannot introduce an earlier matching witness.
- `Or-left`: apply the induction hypothesis to the chosen left branch.
- `Or-right`: the right support is preserved by induction. The left branch failed on the original \(\Gamma\); by Lemma NW it still fails after candidate deletion, so the executable search still reaches and returns the same right branch.

Thus all candidates not selected into the recorded branch can be deleted without destroying replay of that branch.

---

## 6. Kernel floor

Define

\[
FloorView_H(\beta)
\]

as the ordered list of the canonical fields currently inspected by `license_safe` for each leaf occurrence:

\[
FloorView_H(\beta)
=
[
(claim_H(w),role_H(w),scope_H(w))
\mid
(A,w)\in LeafOcc(\beta)
].
\]

Current V0.1.2.1 `license_safe` additionally receives fixed \(\tau\) and \(m\), and computes only from this leaf view:

- every leaf scope covers \(m.scope\);
- action/`Act` has an `authorization` leaf;
- `Share` has a `selection` leaf;
- `Suspect/Reopen/Adopt` has an `escalation` leaf;
- the maximum explicit `EscalationDepth` in escalation leaf claims is at least \(m.revisionDepth\);
- `Adopt` has a `selection` leaf;
- `ResolveStatus` has `selection` or `authorization`;
- normative licensing fails closed.

Write

\[
H\vdash_{\mathbb K_0}
Safe(\beta,\tau,m).
\]

---

# Lemma KFL — Kernel-Floor Locality

If

\[
FloorView_H(\beta)=FloorView_{H'}(\beta),
\]

then, for fixed \(\tau,m\),

\[
\boxed{
H\vdash_{\mathbb K_0}Safe(\beta,\tau,m)
\iff
H'\vdash_{\mathbb K_0}Safe(\beta,\tau,m).
}
\]

In particular, current V0.1.2.1 floor checking does not query any warrant outside \(Supp(\beta)\).

### Proof

Inspection of the closed kernel-floor clauses above. Each clause is a predicate of \(\tau,m\) and the leaf claim/role/scope projection only.

---

## 7. Licensing rule

Let \(P_E\) be the profile snapshot fixed by admissible environment \(E\).

\[
\frac{
\operatorname{Adm}(E,\tau,m)
\qquad
Req_{P_E}(\tau,m)=R
\qquad
E\vdash\beta:R
\qquad
H\vdash_{\mathbb K_0}Safe(\beta,\tau,m)
}{
E\vdash License(\tau,m,\beta)
}
\;[\textsc{License}]
\]

This separates three sources of responsibility:

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

Fix \(\tau,m,R\). Let environments \(E,E'\) satisfy:

1. \(\operatorname{Adm}(E,\tau,m)\) and \(\operatorname{Adm}(E',\tau,m)\);
2. both resolve the same exact immutable profile requirement:

\[
Req_{P_E}(\tau,m)
=
Req_{P_{E'}}(\tau,m)
=
R;
\]

3.

\[
E\equiv^{sat}_{\beta}E';
\]

4.

\[
FloorView_H(\beta)=FloorView_{H'}(\beta).
\]

Then:

\[
\boxed{
E\vdash License(\tau,m,\beta)
\iff
E'\vdash License(\tau,m,\beta).
}
\]

### Interpretation

Once ambient admissibility and the exact profile requirement are fixed, a recorded branch cannot secretly acquire licensing force from warrants outside its immediate support.

This does **not** say that the total license is independent of all branch-external facts. In particular, the theorem deliberately leaves explicit:

\[
BindingActive,\quad
ContextActive,\quad
ProfileSnapshot,\quad
Use,\quad
BindingScope.
\]

For a non-bootstrap context, `ContextActive` may itself continuously depend on a prior `Adopt` license.

Hence:

\[
\boxed{
\text{BC concerns responsibility-branch locality,
not closure of all ambient dependencies.}
}
\]

---

## 8. Historical responsibility support

For auditability, immediate branch locality and full historical responsibility should remain distinct.

Define:

\[
ImmediateDeps(L)=Supp(branch(L)).
\]

Define:

\[
HistoricalBranchDeps(L)
=
Anc_H^\ast(ImmediateDeps(L)).
\]

A future whole-system dependency theorem may define

\[
RespDeps(L)
=
HistoricalBranchDeps(L)
\cup
AmbientDeps(L),
\]

where `AmbientDeps` can include:

- binding/profile activation lineage;
- adopted-context activation license;
- recursively, the branch/history dependencies of that activation license.

That is a stronger responsibility-graph theorem and is intentionally outside BC V0.1.

---

## 9. First proof package

The first formal package should contain only:

1. **Satisfaction Soundness**
   \[
   satisfy(E,R,\Gamma)=\beta
   \Rightarrow
   E\vdash\beta:R.
   \]

2. **Support Projection**
   \[
   satisfy(E,R,\Gamma)=\beta
   \Rightarrow
   satisfy(E,R,\Gamma\!\upharpoonright_\beta)=\beta.
   \]

3. **Kernel-Floor Locality**
   \[
   Safe
   \text{ inspects only }FloorView_H(\beta).
   \]

4. **Relative Branch Conservativity**
   derived from the branch theorem, exact profile requirement, ambient admissibility, and kernel-floor locality.

No authority lattice, agent-indexed discharge, move-strength partial order, or full \(Q_{\mathrm{close}}\) semantics is required for this sheet.
