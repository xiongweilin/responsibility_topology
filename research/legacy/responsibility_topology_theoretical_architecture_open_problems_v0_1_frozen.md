# Responsibility Topology — Theoretical Architecture and Open Problems V0.1

**Status.** Theoretical contract between the executable kernel, the current proof package, and future theory development.  
**Current formal status.** Executable kernel V0.1.2.2; Branch Conservativity proof package V0.2; hand-formal, not yet Lean/Coq mechanized.

> **Responsibility Topology studies what judgments are defeasibly entitled within explicit finite responsibility regimes, and when those regimes themselves may be revised or jointly constituted.**
>
> 责任拓扑研究：在显式、有限、可修订的责任制度中，哪些判断当前具有可撤销资格；以及这些制度本身何时有资格被修订或被多个有限系统共同构成。

---

## 1. Core Judgment

The central theoretical judgment is

\[
\boxed{
\mathbb K_0;\kappa;c;X;u\vdash_\tau^\beta m
}
\]

with:

- \(\mathbb K_0\): the current proof kernel — a thin set of formation, typing, conservation, and currentness laws;
- \(\kappa\): a finite, versioned responsibility regime/profile;
- \(c\): an immutable, versioned determination context;
- \(X\): an agent or agent set;
- \(u\): the purpose/use under which the judgment is evaluated;
- \(\tau\): the license type currently recognized by the kernel;
- \(m\): a kernel-recognized judgment move;
- \(\beta\): the recorded discharge branch for the exact profile requirement attached to \(m\).

### Current-fragment agent status

The symbol \(X\) is retained in the judgment because future work on \(Q_{\mathrm{close}}\) will make agent-indexed responsibility proof-relevant. In the current fragment, however, \(X\) is only an attribution index.

\[
oxed{
	extbf{Agent irrelevance in the current calculus}
}
\]

For fixed \(\mathbb K_0,\kappa,c,u,	au,eta,m\),

\[
oxed{
\mathbb K_0;\kappa;c;X;udash_	au^eta m
\iff
\mathbb K_0;\kappa;c;X';udash_	au^eta m.
}
\]

Thus:

> \(X\) is an attribution index in the current fragment, not yet an obligation-discharge index.

This is a deliberate limitation. Agent-indexed obligation ownership and distributed discharge remain part of \(Q_{\mathrm{close}}\).

The **entitlement judgment** is the theoretical object. A runtime `LicenseRecord` is an executable certificate that a concrete derivation of this judgment was issued at a particular historical state. Therefore:

\[
\boxed{
Entitlement\ judgment \neq LicenseRecord
}
\]

and, separately,

\[
\boxed{
Historical\ issuance \neq Current\ reusability.
}
\]

The runtime certificate may remain in append-only history after its supporting warrants, binding, or adopted context cease to be current.

---

## 2. Current Theorem Boundary

The present proof package establishes a narrow but substantive claim:

\[
\boxed{
\textbf{Proved now: no hidden branch justification under a fixed admissible regime.}
}
\]

It does **not** yet establish the stronger target:

\[
\boxed{
\textbf{Target: no implicit entitlement strengthening under the regime.}
}
\]

The current hand-formal package contains:

- **BC — Support Conservativity.** Branch satisfaction is local to the canonical and current-status projection of the warrants actually used by the branch.
- **SS — Satisfaction Soundness.** The executable `satisfy` procedure returns only proof branches valid in the extracted branch calculus.
- **SP — Support Projection / Replay.** Once a branch is recorded, deleting unselected candidate warrants preserves replay of that branch; its mechanized proof is expected to use a stronger support-preserving replay lemma.
- **KFL — Kernel-Floor Locality.** The current kernel safety floor reads only the recorded leaf view, together with the fixed move and license type.
- **RBC — Relative Branch Conservativity.** Under fixed admissible ambience and the same exact immutable profile requirement, branch-external warrants cannot become hidden profile-discharge or kernel-floor justification.

These theorems do **not** prove that the profile is adequate, that root admission is true, that the kernel floor exhausts rational responsibility, or that every ambient dependency is branch-local.

The theorem boundary is therefore:

\[
\boxed{
\text{BC concerns responsibility-branch locality, not closure of all ambient dependencies.}
}
\]

---

## 3. Entitlement Calculus

Let

\[
E=(H,\sigma,b,c,u)
\]

be the current ambient environment. Current licensing decomposes into four explicit conditions:

\[
\boxed{
\operatorname{Adm}(E,\tau,m)
\;+\;
Req_\kappa(\tau,m)=R
\;+\;
E\vdash\beta:R
\;+\;
Safe_{\mathbb K_0}(\beta,\tau,m).
}
\]

Equivalently, the core judgment is derived only when:

1. **Ambient admissibility** holds: the binding is active, the exact profile snapshot is fixed, the context is active for the use, and the move is within binding scope.
2. **Profile obligation** is explicit: the current regime declares the exact finite requirement \(R\) for the exact move identity, including type, kind, arguments, revision depth, and scope.
3. **Requirement discharge** is proof-relevant: \(\beta\) records the actual positive branch and its immediate warrant support.
4. **Kernel licensing floor** passes: kernel-owned licensing constraints on type, scope, authorization/selection, and revision strength hold independently of profile generosity. Additional kernel-owned **formation discipline** — including provenance guards, transport conservation, scope preservation, and revision-depth non-amplification — has already constrained which warrants can enter the branch.

Thus the current system implements

\[
\boxed{
\textbf{profile-relative entitlement formation}
}
\]

rather than unconditional entitlement genesis.

A profile may declare what it currently demands for a move, but the present calculus does not infer that those demands exhaust every responsibility that a better regime, future evidence, or a revised kernel might reveal.

---

## 4. Responsibility Topology

The entitlement calculus and responsibility topology are distinct but coupled.

> **Calculus studies derivability; topology studies the dependency and currentness of derivability under challenge and revision.**

The calculus asks whether

\[
\mathbb K_0;\kappa;c;X;u\vdash_\tau^\beta m
\]

is derivable in the current environment.

The topology tracks where that derivability depends on other responsibility-bearing objects and how those dependencies change. Its present structural vocabulary includes:

- \(Supp(\beta)\): the immediate warrants selected into a discharge branch;
- \(HistSupp(\beta)=Anc^\ast(Supp(\beta))\): the append-only historical warrant lineage supporting those leaves;
- \(Descendants(w)\): downstream derived warrants affected when an ancestor requires revalidation;
- \(AmbientDeps(L)\): branch-external dependencies such as active binding, active context, immutable profile snapshot, and use;
- \(activationLicense(c,u)\): the Adopt license whose currentness sustains a non-bootstrap active context;
- **invalidation / suspension / pending**: conservative loss of current usability without historical erasure;
- **revalidation**: the obligation to establish current usability again after challenge or revision.

The topology therefore studies the geometry of current responsibility:

\[
\boxed{
\text{which derivations depend on which responsibility positions,
and which judgments reopen when those positions cease to be current.}
}
\]

It is not presently a Grothendieck topology, sheaf, fibration, or other imposed categorical container. Any such structure would have to emerge as a theorem about a restricted fragment, not be assumed as the source of entitlement.

---

## 5. The Adequacy Boundary

The deepest external premise of the current calculus is:

\[
\boxed{
Why\ is\ Req_\kappa(\tau,m)\ sufficient?
}
\]

The kernel can enforce that the declared requirement is discharged conservatively. It cannot, from inside the same derivation, establish that the declared requirement contains every responsibility that ought to matter.

Three adequacy questions remain outside the current metatheorems:

\[
\boxed{
RootAdmissionAdequacy
}
\]

Why should an admitted root premise have the current evidential force assigned to it? Admission is explicit, sourced, scoped, and auditable, but it is not a truth oracle.

\[
\boxed{
ProfileAdequacy
}
\]

Why should the active finite regime require exactly these obligations for this move? An immutable profile is a declared responsibility regime, not a proof that no responsibility position is missing.

\[
\boxed{
KernelFloorAdequacy
}
\]

Why should the current kernel-owned no-shortcut laws be the correct minimal structural commitments? \(\mathbb K_0\) is an explicit finite proof starting point, not a self-proving final rationality.

Therefore:

\[
\boxed{
\text{Correct execution of a profile}
\not\Rightarrow
\text{epistemic or normative adequacy of that profile.}
}
\]

This boundary is deliberate. Without it, profile-relative derivability would be mistaken for a proof that the responsibility regime itself is sufficient.

---

## 6. \(Q_{\mathrm{open}}\): Regime Revision

The first foundational open problem is:

\[
\boxed{
\textbf{
When may a finite system become entitled to reopen
the responsibility regime that defines sufficiency?
}
}
\]

The central non-implication is:

\[
\boxed{
Failure(R)\not\Rightarrow Failure(\kappa).
}
\]

A failed obligation, failed prediction, persistent residual, or suspended license may have an ordinary explanation within the current regime. It does not by itself show that the responsibility architecture is inadequate.

The problem is to characterize when a finite system may legitimately escalate attribution:

\[
\boxed{
ordinary\ failure
\;\longrightarrow\;
missing\ responsibility\ position
\;\longrightarrow\;
inadequate\ responsibility\ architecture.
}
\]

The desired theory must preserve the anti-shortcuts already enforced by the kernel:

\[
Suspect_k
\not\Rightarrow
Reopen_{k+1}
\not\Rightarrow
Adopt(\kappa').
\]

The hard question is **entitlement genesis at the regime level**: what finite, auditable pattern of unresolved responsibility, repair search, boundary sensitivity, counterfactual failure, provenance failure, or requalification debt can itself justify moving from “the current judgment failed” to “the regime that defines sufficient responsibility may be missing a responsibility position”?

Thus \(Q_{\mathrm{open}}\) is not merely belief revision or ontology change. It is a higher-order entitlement problem about revision of the sufficiency regime itself.

---

## 7. \(Q_{\mathrm{close}}\): Joint Regime Constitution

The second foundational open problem is:

\[
\boxed{
\textbf{
When may heterogeneous finite systems jointly constitute
and discharge a shared responsibility regime?
}
}
\]

The current kernel can issue a collective-labelled license whose warrant lineage has multiple sources, but the `agents` field is presently metadata. It does not yet represent distributed ownership of proof obligations.

A future formalization must at minimum distinguish individual discharge judgments such as

\[
\boxed{
E;i\vdash\beta_i:o_i
}
\]

from a collective obligation assignment

\[
\boxed{
\alpha:Obl(R_G)\rightharpoonup G,
}
\]

together with a coherence condition

\[
\boxed{
JointlyCoherent(\alpha,\{\beta_i\}).
}
\]

Only then can a collective move be derived from genuinely distributed responsibility rather than from a centrally checked proof labelled with several agent names.

The core difficulties include:

- heterogeneous contexts \(\Sigma_i\) and possibly heterogeneous profiles \(\kappa_i\);
- which obligations are delegable and which are agent- or authority-specific;
- whether apparently independent discharges share a common provenance cause;
- how a group constitutes its finite shared requirement \(R_G\) without presupposing a final arbiter;
- how disagreement about the responsibility regime itself can remain explicit while still permitting provisional joint determination.

Thus \(Q_{\mathrm{close}}\) is not a theory of agreement or voting. It is a higher-order entitlement problem about **joint constitution plus distributed discharge of a finite responsibility regime**.

---

## Architecture

\[
\boxed{
\begin{array}{cc}
\textbf{Entitlement Calculus}
&
\textbf{Responsibility Topology}
\\[2mm]
\multicolumn{2}{c}{
\mathbb K_0;\kappa;c;X;u\vdash_\tau^\beta m
}
\\[4mm]
\swarrow
&
\searrow
\\[-1mm]
\textbf{Q}_{open}
&
\textbf{Q}_{close}
\\
\text{regime revision}
&
\text{joint regime constitution}
\end{array}
}
\]

The two open problems are not later layers in a pipeline. They are higher-order entitlement problems located at the boundary of the current calculus and its dependency topology:

\[
\boxed{
Q_{\mathrm{open}}:
\text{when may the regime itself be reopened?}
}
\]

\[
\boxed{
Q_{\mathrm{close}}:
\text{when may a shared regime itself be jointly constituted?}
}
\]

---

## Contract Summary

The present theory may claim:

\[
\boxed{
\textbf{
Given an explicit finite responsibility regime,
a current entitlement must have an explicit,
typed, auditable responsibility branch recognized by that regime and kernel.
}
}
\]

The present theory may **not** yet claim:

\[
\boxed{
\textbf{
the active regime is itself adequate,
or that heterogeneous finite systems already possess a formal rule
for revising or jointly constituting such regimes.
}
}
\]

Those two missing claims are precisely \(Q_{\mathrm{open}}\) and \(Q_{\mathrm{close}}\).
