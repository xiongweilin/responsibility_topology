# QX — Prior-Art Kill Audit

Status: **QX-2 adversarial prior-art audit. Research only.**

Formalization: **NO**.

This document attacks the QX-1 problem kernel before any theorem surface or domain protocol is preregistered.

Allowed verdicts are only:

```text
ELIMINATED
DOMAIN-SPECIFIC
SURVIVES WITH EXACT RESIDUAL
```

“Related but different” is not an allowed conclusion.

## 1. Target under attack

QX-1 asks:

> How can a finite system obtain defensible evidence that its current space of distinctions is inadequate for a relied-upon responsibility task without already knowing the correct refinement?

The audit attacks every broad reading of this question.

The only candidate worth retaining would have to concern a certificate of **current representation insufficiency relative to a task**, while avoiding all of:

```text
complete ground-truth state access;
pre-specified correct finer representation;
ordinary unknown-class detection;
ordinary model-fit rejection;
ordinary counterexample-guided refinement;
post-hoc task distinctions selected to manufacture insufficiency.
```

## 2. Strong-neighbor matrix

| Candidate QX claim | Strong neighbor | What prior art already provides | Verdict | Exact consequence for QX |
|---|---|---|---|---|
| A finite agent may be unaware of distinctions expressible in a finer space | unawareness / partial-state-space models | coarse vs finer partial specifications, refinement order, nontrivial unawareness | **ELIMINATED** | Missing distinctions and refinement-ordered awareness are not QX novelty |
| An agent may anticipate discovery of consequences it cannot currently describe | awareness of unawareness | choice models in which decision makers anticipate future discovery of currently unimaginable/indescribable consequences | **ELIMINATED** | “Knowing there may be unknown distinctions” is not novelty |
| Unknown is not the same as ordinary uncertainty | open-set / open-world recognition | explicit known/unknown discrimination and open-world/open-set methods | **ELIMINATED** | `unknown != uncertain` cannot motivate QX novelty |
| A deployed model can be confidently wrong because its represented/training world is incomplete | unknown-unknown discovery | model-blind high-confidence errors, oracle-guided discovery of unknown unknowns | **ELIMINATED** as a broad claim | QX cannot claim novelty for model incompleteness or confident blind spots |
| Coarse representation can alias states requiring different behavior | state aliasing / state aggregation / POMDPs | multiple ground states mapped to one observation/aggregate; performance loss and representation-learning responses | **ELIMINATED** | Aliasing and task loss under aggregation are established technical objects |
| A failure can justify refining an abstraction | CEGAR / abstraction refinement | spurious counterexample analysis followed by automatic abstraction refinement | **ELIMINATED** when concrete semantics/property supplies the discrimination | Counterexample-triggered refinement is not QX novelty |
| External/held-out evidence can diagnose a bad model and guide revision | model criticism / misspecification | predictive checks, holdout/split criticism, methods for detecting model departures and guiding revision | **ELIMINATED** as a broad claim | “external evidence says model is inadequate” is not enough |
| A finite represented candidate set can be exhaustively rejected relative to a fixed criterion | finite hypothesis/model testing | ordinary finite enumeration/test logic | **ELIMINATED** as mathematics | Finiteness alone does not create a new theory |
| Evidence can certify that **this current representation** is insufficient for task `T` without supplying a correct finer representation or complete concrete oracle | combined attack of all neighbors | partial coverage only | **SURVIVES WITH EXACT RESIDUAL** | This is the only candidate residual and remains unformalized |

## 3. Unawareness: coarse/fine distinction spaces are prior art

Recent and classical unawareness models directly attack the idea that QX is novel because a finite system has a coarse distinction space while finer distinctions exist.

Wesley Holliday's 2025 *A partial-state space model of unawareness* uses partial specifications ordered by further specification/refinement and explicitly models awareness of coarser-grained specifications together with unawareness of finer-grained specifications. It builds on the generalized unawareness tradition of Heifetz, Meier, and Schipper.

Therefore eliminate:

```text
novelty = current state space is coarse;
novelty = finer distinctions may exist outside current awareness;
novelty = refinement order can model growing awareness.
```

QX can survive only if it needs a different evidence role: not merely modeling the existence of unawareness, but certifying task-relative insufficiency of the current representation under restricted evidence.

Verdict:

```text
COARSE/FINE UNAWARENESS CLAIM: ELIMINATED
```

References:

- Wesley H. Holliday, *A partial-state space model of unawareness*, Journal of Mathematical Economics 116 (2025), 103081, DOI `10.1016/j.jmateco.2024.103081`.
- Aviad Heifetz, Martin Meier, Burkhard C. Schipper, *Interactive unawareness*, Journal of Economic Theory 130 (2006), 78–94, DOI `10.1016/j.jet.2005.02.007`.

## 4. Awareness of unawareness: anticipation of unknown distinctions is prior art

Karni and Vierø explicitly model decision makers who anticipate that they may later acquire knowledge of consequences that are currently unimaginable or indescribable.

This is a direct kill of any QX claim of the form:

```text
finite system can suspect there are unknown distinctions
```

or:

```text
system can rationally behave as if currently undescribed consequences may exist.
```

Those ideas already have a choice-theoretic treatment.

Verdict:

```text
AWARENESS-OF-UNAWARENESS CLAIM: ELIMINATED
```

Reference:

- Edi Karni, Marie-Louise Vierø, *Awareness of unawareness: A theory of decision making in the face of ignorance*, Journal of Economic Theory 168 (2017), 301–328, DOI `10.1016/j.jet.2016.12.011`.

## 5. Open-world recognition: unknown is not uncertainty

Open-world/open-set recognition already treats unknown inputs/classes as a distinct technical problem and explicitly warns that uncertainty/rejection mechanisms are insufficient proxies for unknownness.

The 2019 AAAI survey *Learning and the Unknown* states the core distinction directly: uncertain inputs and unknown inputs are not the same technical object, and open-set methods have been developed to control risk from unknown classes.

QX therefore cannot claim:

```text
uncertainty != unknown
```

or:

```text
recognizing a case as outside known classes proves representation-inadequacy novelty.
```

Open-world recognition remains more classification-centric than QX's task/accountability framing, but that difference alone does not earn a new object.

Verdict:

```text
UNKNOWN-VS-UNCERTAINTY CLAIM: ELIMINATED
```

Reference:

- T. E. Boult et al., *Learning and the Unknown: Surveying Steps toward Open World Recognition*, AAAI 33(01), 2019, DOI `10.1609/aaai.v33i01.33019801`.

## 6. Unknown unknowns: model blindness plus oracle-guided discovery is prior art

Lakkaraju, Kamar, Caruana, and Horvitz study predictive models that can make high-confidence errors because of model/data incompleteness. Their method explicitly uses oracle feedback to identify and guide discovery of unknown unknowns.

This kills a broad QX story:

```text
model is confidently wrong because represented/training space is incomplete
-> discover blind spot
```

as novelty.

However, the paper also exposes the exact pressure QX must survive: if discovery relies on an oracle that can label the error, QX has not solved its harder certificate problem.

Verdict:

```text
MODEL-BLIND-ERROR CLAIM: ELIMINATED
ORACLE-FREE CERTIFICATE QUESTION: SURVIVES WITH EXACT RESIDUAL
```

Reference:

- Himabindu Lakkaraju, Ece Kamar, Rich Caruana, Eric Horvitz, *Identifying Unknown Unknowns in the Open World: Representations and Policies for Guided Exploration*, AAAI 31(1), 2017, DOI `10.1609/aaai.v31i1.10821`.

## 7. State aliasing and aggregation: response-relevant collapse is established

State aggregation and partial-observability literature already studies what happens when multiple ground states share one represented state/observation.

The central technical pattern:

```text
multiple ground states
-> one aggregate/observation
-> policy/value loss if the aggregated states are not sufficiently equivalent
```

is not new.

Modern work continues to quantify the performance consequences of state aggregation, while POMDP representation-learning work studies learning compact latent representations from observations for planning.

Therefore eliminate:

```text
novelty = alpha(x)=alpha(y) can be harmful;
novelty = an aggregate should preserve task/policy-relevant distinctions;
novelty = representation may need refinement for planning/control.
```

This also attacks the proposed QX aliasing kernel. The elementary theorem that a `V`-factored policy cannot distinguish two aliased situations is not a research contribution.

The only residual is evidential:

```text
how is the responsibility-relevant non-equivalence certified
without already having the ground-state representation or correct finer decoder?
```

Verdict:

```text
ALIASING/POLICY-LOSS CLAIM: ELIMINATED
INDEPENDENT ACCOUNTABILITY-WITNESS PROVENANCE: SURVIVES WITH EXACT RESIDUAL
```

Representative references:

- Daniel Russo, *Approximation Benefits of Policy Gradient Methods with Aggregated States*, Management Science 69(11), 2023, DOI `10.1287/mnsc.2023.4788`.
- Ruo Yu Tao et al., *Benchmarking Partial Observability in Reinforcement Learning with a Suite of Memory-Improvable Domains*, Reinforcement Learning Journal 6 (2025), 1412–1439.
- Jiacheng Guo et al., *Provably Efficient Representation Learning with Tractable Planning in Low-Rank POMDP*, ICML 2023, PMLR 202:11967–11997.

## 8. CEGAR: counterexample-driven refinement is prior art

Classic CEGAR already supplies:

```text
abstract model
-> counterexample
-> determine spuriousness using concrete semantics/property
-> refine abstraction
-> repeat
```

Therefore eliminate:

```text
novelty = failure can trigger abstraction refinement;
novelty = one can add distinctions after a spurious counterexample;
novelty = refinement can be driven by a task/property violation.
```

The exact QX residual appears only when the discrimination source used by CEGAR is unavailable or itself incomplete:

```text
no assumed complete concrete semantics
+
no already-known correct finer abstraction
+
need evidence only that current V is insufficient for T.
```

This residual must be attacked again during QX-3 preregistration. It may collapse under more general abstraction/refinement frameworks.

Verdict:

```text
COUNTEREXAMPLE-TO-REFINEMENT CLAIM: ELIMINATED
NO-COMPLETE-CONCRETE-ORACLE CERTIFICATE: SURVIVES WITH EXACT RESIDUAL
```

Reference:

- Edmund Clarke, Orna Grumberg, Somesh Jha, Yuan Lu, Helmut Veith, *Counterexample-Guided Abstraction Refinement*, CAV 2000.

## 9. Model criticism and misspecification: detecting bad models is prior art

Modern model criticism provides calibrated methods to detect when a fitted model does not match held-out/population data and to identify aspects that require revision.

Holdout predictive checks explicitly target model criticism and ask whether a model needs to change. Split predictive checks likewise target detection of model misspecification and predictive-generalization failures.

Broader misspecification literature treats inference and decision-making when analysts do not accept the working model as correct.

Therefore eliminate:

```text
novelty = held-out evidence can show a model is wrong;
novelty = a diagnostic can reveal misspecification;
novelty = model criticism can guide revision.
```

QX cannot simply relabel model rejection as `SuspectInadequacy`.

The residual question is narrower:

> Does evidence establish that the **distinction space itself** is insufficient for task `T`, rather than merely showing that parameters, distributions, dynamics, likelihoods, diagnostics, or model-class assumptions are wrong?

Even this distinction may be domain-specific unless QX can formulate a non-circular certificate source.

Verdict:

```text
GENERAL MODEL-CRITICISM CLAIM: ELIMINATED
REPRESENTATION-SPECIFIC CERTIFICATE ROLE: SURVIVES WITH EXACT RESIDUAL
```

Representative references:

- L. Moran, R. Blei et al., *Holdout predictive checks for Bayesian model criticism*, JRSS Series B 86(1), 2024, 194–214, DOI `10.1093/jrsssb/qkad105`.
- *Calibrated Model Criticism Using Split Predictive Checks*, Journal of the American Statistical Association, 2026, DOI `10.1080/01621459.2026.2649585`.
- *Bayesian Inference for Misspecified Generative Models*, Annual Review of Statistics and Its Application, 2024, DOI `10.1146/annurev-statistics-040522-015915`.

## 10. Finiteness: exhaustive candidate rejection is not novelty

Suppose:

```text
H_V = {h1,...,hn}
forall h in H_V, Fail(h,C)
```

Then exhaustive failure of the represented finite candidate set relative to `C` is elementary.

QX cannot claim novelty for finite enumeration or finite exhaustion.

The only possible research burden is epistemic/representational:

```text
what makes C an adequate independent test;
what exactly is concluded when H_V is exhausted;
why exhaustion indicts the represented candidate space rather than data, test, implementation, or task specification.
```

Safe conclusion remains:

```text
current represented candidate space exhausted relative to C
```

Verdict:

```text
FINITE-EXHAUSTION MATHEMATICS: ELIMINATED
CERTIFICATE INTERPRETATION/PROVENANCE: SURVIVES WITH EXACT RESIDUAL
```

## 11. Aggregate freedom deletion

After the attack, QX may no longer claim novelty for:

```text
coarse representations;
missing distinctions;
unawareness;
awareness of possible unknowns;
unknown != uncertain;
open-world unknown-class detection;
confident model blind spots;
state aliasing;
aggregation-induced policy loss;
POMDP representation learning;
counterexample-guided abstraction refinement;
held-out model criticism;
model misspecification;
finite candidate exhaustion.
```

These freedoms are deleted.

## 12. Exact surviving residual

One narrow research question survives the combined attack:

> **Can a finite system obtain a task-relative certificate that its current distinction space is insufficient when it does not already possess a correct finer representation, a complete concrete-state oracle, or a diagnostic that simply defines the desired refinement?**

The residual contains three obligations.

### R1 — certificate source

The evidence source must not be generated solely by the candidate refinement whose necessity it is supposed to prove.

### R2 — localization discipline

The certificate must distinguish at least:

```text
representation insufficiency
```

from:

```text
observation error
implementation error
parameter/dynamics error
ordinary partial observability
unknown-class encounter
model-class misspecification
task-specification error.
```

It need not uniquely diagnose the cause, but it cannot call every unexplained failure “representation inadequacy.”

### R3 — weak conclusion

The certificate may establish only something like:

```text
current V is insufficient for task T under stated evidence C
```

It must not by itself establish:

```text
which new distinction is needed;
which refinement is correct;
that revision is authorized;
that the broader regime failed.
```

## 13. Novelty status

The prior-art residual is **nonempty but narrow**.

```text
QX broad novelty: KILLED
QX aliasing novelty: KILLED
QX unawareness novelty: KILLED
QX unknown-world novelty: KILLED
QX model-criticism novelty: KILLED
QX counterexample-refinement novelty: KILLED

QX certificate-provenance problem:
SURVIVES WITH EXACT RESIDUAL
```

This result does **not** establish that the residual is novel in the full literature. It establishes only that the audited strong neighbors do not, on their face, eliminate the specific certificate-provenance problem under QX's no-correct-refinement/no-complete-oracle restriction.

## 14. Next gate

QX-3 may now preregister candidate kernels because the residual is nonempty, but it must not open Lean.

QX-3 must attack, not assume, the two candidate shapes:

```text
A. aliasing + independently sourced accountability incompatibility
B. finite represented-candidate exhaustion + independently justified criterion
```

The first item in each preregistration must be the provenance of the independent witness/criterion.

Current status:

```text
QX-2 prior-art kill: PASS AS FALSIFICATION
QX broad theory: NOT ESTABLISHED
QX exact residual: NONEMPTY
QX formalization: NO
```
