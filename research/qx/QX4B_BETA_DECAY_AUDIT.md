# QX-4B₁ — Candidate B Audit: Historical Beta Decay / Pauli Neutrino

Status: **SOURCE-BACKED NEGATIVE-CONTROL DOMAIN AUDIT**.

Formalization: **NO**.

Parent protocol: `QX_KERNEL_PREREGISTRATION.md`.

Frozen domain: `QX4B_FIRST_DOMAIN_FREEZE.md`.

Domain ID: `B-D1`.

This audit tests whether the historical beta-decay anomaly genuinely supplied a finite, complete represented candidate set `H_V` whose members were all rejected by an independently fixed criterion `C` before Pauli's neutrino proposal.

The burden is historical exhaustiveness. A retrospective textbook menu is not enough.

## 1. Primary sources

### S1 — Ellis and Wooster, 1927

C. D. Ellis and W. A. Wooster, *The Continuous Spectrum of β-Rays*, Nature 119 (1927):

https://www.nature.com/articles/119563c0

The experiment addressed whether the observed beta-spectrum heterogeneity could be attributed to specified secondary effects and reported no satisfactory explanation from those effects. It established pressure on existing explanations; it did not publish a finite complete catalogue of all scientifically available hypotheses.

### S2 — Pauli's 1930 letter

Wolfgang Pauli, 4 December 1930 letter to the Tübingen meeting:

https://www.pp.rhul.ac.uk/~ptd/TEACHING/PH2510/pauli-letter.html

Pauli describes his neutral-particle proposal as a "desperate remedy" intended to preserve the statistical rule and the law of conservation of energy in the face of the continuous beta spectrum and nuclear-statistics problem.

The letter proposes a new possibility; it does not certify that an enumerated finite pre-existing hypothesis set had been exhausted.

### S3 — ETH historical account

ETH Library, *The neutrino*:

https://library.ethz.ch/en/collections-and-archives/platforms/virtual-exhibitions/wolfgang-pauli-and-modern-physics/the-neutrino.html

The historical account records that Bohr attempted to explain the anomaly by restricting the validity of energy conservation, whereas Pauli sought to preserve conservation by postulating an additional neutral particle.

This matters because a condition such as "preserve energy conservation" was not an uncontested fixed rejection criterion shared by the live hypothesis space.

### S4 — historical hypothesis-formation scholarship

Historical scholarship on the beta-spectrum episode describes it as generating **diverse hypotheses** among Rutherford, G. P. Thomson, Bohr, Heisenberg, Pauli, and others rather than as the exhaustion of one documented finite complete candidate list.

Representative reference:

*To envision a new particle or change an existing law? Hypothesis formation and anomaly resolution for the curious case of the β decay spectrum*, Studies in History and Philosophy of Modern Physics 45 (2014), 27–45.

The evidential use here is narrow: the historical record does not support reconstructing `H_V` as a small exhaustive set after the fact.

## 2. Timing discipline

### `E_pre`

Historically available before / around Pauli's proposal:

```text
continuous beta spectrum;
experimental pressure against simple secondary-effect explanations;
statistics / conservation-law tensions;
multiple competing explanatory directions;
Bohr's willingness to question strict microscopic energy conservation;
Pauli's desire to preserve conservation by adding a neutral particle.
```

### `E_post`

Later information includes:

```text
Fermi's beta-decay theory;
the modern neutrino concept;
direct neutrino detection;
retrospective textbook organization of the anomaly into a small set of named alternatives.
```

`E_post` may explain why Pauli's proposal was fruitful. It may not be used to prove that the 1930 represented candidate set was finite and complete.

## 3. Candidate B observables

### B-OBS1 — definition of `V` and how it induces `H_V`

```text
NOT ESTABLISHED STRONGLY ENOUGH FOR CANDIDATE B.
```

One can retrospectively describe the scientific vocabulary as containing ideas about secondary effects, conservation-law modification, nuclear structure, and additional particles. But the sources do not establish a formal or operational distinction space `V` whose expressible task candidates are exactly some finite list `H_V`.

Any neat mapping

```text
V -> {known finite candidate classes}
```

would be a historical reconstruction, not an observed contemporary enumeration boundary.

### B-OBS2 — complete enumeration argument for `H_V`

```text
FAIL.
```

No source establishes a finite complete set of all hypotheses available to the relevant scientific community at the anomaly stage.

The 1927 experiment rejected specified secondary-effect explanations, not every candidate expressible in a closed model class. Historical scholarship instead reports diverse hypothesis formation across multiple theorists.

Therefore a retrospective set such as

```text
H_V = {
  secondary-effect explanation,
  violate energy conservation,
  new neutral particle
}
```

is not earned as an exhaustive historical candidate space.

### B-OBS3 — provenance and precommitment of `C`

```text
NOT STABLE ENOUGH FOR THE REQUIRED EXHAUSTION CLAIM.
```

Possible constraints include:

```text
fit the continuous beta spectrum;
preserve observed nuclear statistics;
preserve energy conservation;
remain compatible with then-known experimental facts.
```

But energy conservation itself was disputed as a universal microscopic constraint in the live debate. Bohr's proposal precisely considered relaxing it.

Thus one cannot simply choose

```text
C = preserve energy conservation + fit beta spectrum
```

and then claim all contemporary candidates were tested against one independently fixed criterion family. That would remove a historically live response by definition.

### B-OBS4 — failure evidence for each `h in H_V`

```text
NOT AVAILABLE BECAUSE H_V IS NOT EXHAUSTIVELY ESTABLISHED.
```

There is source-backed failure pressure against specified secondary-effect accounts. There is no source-backed universal test covering every member of a proven complete finite set.

### B-OBS5 — common-mode failures ruled out

```text
PARTIAL ONLY.
```

Ellis and Wooster strengthened the case that the continuous spectrum was a real physical feature rather than a simple experimental artifact. That is valuable anomaly evidence.

It does not create a finite exhaustive hypothesis catalogue.

### B-OBS6 — hidden `other/unknown/defer` candidate

```text
FAILS THE EXHAUSTION READING.
```

Open-ended hypothesis formation was itself part of the scientific situation. Pauli introduced a new particle not supplied by a demonstrated closed finite candidate set.

The very ability to form such a new hypothesis is evidence against treating the pre-Pauli space as an operationally complete finite enumeration.

### B-OBS7 — exact conclusion supported

The evidence supports only:

> **Several then-considered explanatory routes were under serious pressure, and a new hypothesis was introduced to preserve important principles while explaining the anomaly.**

It does not support:

```text
all members of the current represented candidate space H_V were exhausted relative to C.
```

### B-OBS8 — why this would be representation/candidate-space insufficiency rather than model-class rejection

```text
NOT ESTABLISHED.
```

Without a proven `V -> H_V` enumeration boundary, failure of several known hypotheses is ordinary anomaly / model-class pressure, not a certificate that the current distinction space is exhausted.

## 4. Kill-test audit

### B-K1 — fake exhaustiveness

```text
KILL.
```

This is decisive.

The historical evidence does not establish that the named alternatives form the complete current represented candidate set. A small retrospective list would be a convenience reconstruction.

### B-K2 — post-hoc criterion

```text
STRONG KILL PRESSURE / SUPPORTING REASON.
```

A criterion requiring preservation of energy conservation cannot be treated as an uncontested precommitted test over all live alternatives because abandoning or restricting energy conservation was itself a historically serious candidate response.

The audit does not claim there was no stable empirical criterion at all. It claims only that no independently fixed `C` is evidenced that both (i) defines the proposed finite exhaustion and (ii) does not pre-exclude a live historical alternative.

### B-K3 — common-mode test failure

```text
NOT DECISIVE.
```

The continuous spectrum was experimentally real enough to generate genuine theoretical pressure. The domain fails for exhaustiveness, not because the anomaly was merely a measurement bug.

### B-K4 — decorative finitude

```text
KILL.
```

Any finitude here would be imposed retrospectively. The evidential argument remains essentially unchanged if the live hypothesis space is open-ended:

```text
several existing explanations fail -> seek another explanation.
```

Therefore finiteness is not doing the exhaustive-certificate work Candidate B requires.

### B-K5 — ordinary model-class rejection

```text
KILL / ABSORPTION.
```

To the extent the case establishes anything like exhaustion, it establishes rejection or inadequacy of particular then-considered explanatory models, not exhaustion of the system's whole representation-induced candidate space.

Ordinary anomaly-driven model revision / hypothesis formation preserves the material facts.

### B-K6 — hidden catch-all candidate

```text
KILL PRESSURE.
```

The open scientific posture effectively contains `other/new hypothesis` even if not encoded as a literal formal catch-all. Pauli's new-particle proposal demonstrates that the candidate boundary was not operationally closed.

### B-K7 — illegitimate world-level conclusion

```text
PASS AS A FIREWALL.
```

This audit does not infer that reality had no explanation or that a specific missing distinction was already known.

### B-K8 — no link from `H_V` to `V`

```text
KILL.
```

No source-backed representation `V` is shown to induce a finite complete historical `H_V`. The exhausted candidates are at most a subset of scientific models under discussion.

## 5. Why the neutrino story is not Candidate B evidence

The historical episode is compelling precisely because a scientist proposed a new ontology when existing explanations were strained.

That narrative is **not** enough for Candidate B.

Candidate B needs:

```text
closed finite represented set
+
justified complete enumeration
+
independently fixed C
+
failure of every represented candidate
```

The beta-decay record instead gives:

```text
serious anomaly
+
multiple/diverse live hypotheses
+
disagreement over governing principles
+
open-ended hypothesis formation.
```

The latter may motivate representation revision philosophically, but it does not constitute the preregistered finite-exhaustion certificate.

## 6. Domain verdict

```text
B-D1 historical beta decay / Pauli neutrino:
ELIMINATED
```

Primary kills:

```text
B-K1 fake exhaustiveness
B-K4 decorative finitude
B-K5 ordinary model-class rejection
B-K8 no demonstrated H_V-to-V boundary
```

Supporting pressure:

```text
B-K2 criterion instability / retrospective criterion risk
B-K6 open-ended other/new-hypothesis possibility
```

This verdict eliminates **the beta-decay story as Candidate B evidence**. It does not eliminate Candidate B globally.

## 7. Degrees of freedom deleted

This audit permanently removes the shortcut:

```text
historically known list of failed ideas
=
finite exhaustive represented candidate set.
```

It also removes:

```text
retrospective textbook alternatives
-> historical H_V completeness;

new hypothesis appeared after anomaly
-> prior represented space was finitely exhausted;

preserve principle P
-> P was an independently fixed criterion for all live candidate responses.
```

## 8. QX status after B-D1

```text
Candidate A: SURVIVES WITH EXACT RESIDUAL / mechanism-specific only
Candidate B: PREREGISTERED / first domain ELIMINATED / aggregate verdict NOT EARNED
B-D1 beta-decay evidence: REJECTED
QX generic object: NOT EARNED
QX Lean: NO
```

A later Candidate B domain must make finiteness operationally real. It should not be another historical story reconstructed from a handful of named hypotheses.
