# Meta-Architecture P5-A — Held-Out Source Viability

Status: **BOTH PRIMARY CASES LOCKED / NO RESERVE ACTIVATED / NO ARCHITECTURE INTERPRETATION**

This gate checks only the preregistered source-viability conditions. It does not classify either case under A0/A1/A2/A_null/A_D and does not decide whether a residual exists.

## H_control — Safety digest 01/2026, Helpston

Primary source identity:

- RAIB Safety digest 01/2026: Helpston
- occurrence: near miss at Helpston manually controlled barrier level crossing
- occurrence date: 21 October 2025
- publication date: 9 March 2026
- official source: `https://www.gov.uk/raib-reports/safety-digest-01-slash-2026-helpston`
- detailed HTML: `https://www.gov.uk/government/publications/safety-digest-012026-helpston/near-miss-at-helpston-manually-controlled-barrier-level-crossing-21-october-2025`

Viability checks:

```text
source accessible: YES
report identity correct: YES
timeline reconstructible: YES
actors/evidence/action reconstructible: YES
substantive repository contamination before held-out freeze: NO IDENTIFIED
```

The official HTML provides a timestamped incident sequence, the relevant signaller/manager/infrastructure-manager roles, signalling and witness evidence, the Rule Book constraint, the sealed-release mechanism, management/assurance facts, and previous-similar-occurrence references. That is sufficient for later native reconstruction.

The RAIB source class is a safety digest. RAIB states that safety digests are used when a full investigation is not appropriate because safety learning is already covered/being addressed or mainly concerns compliance with existing rules, procedures, or standards. This remains only the preregistered control-like prior; it is not an adjudicated absorption result.

```text
H_control primary: LOCKED
reserve Manchester Piccadilly: NOT ACTIVATED
```

## H_unknown — Report 07/2026, Bookham Tunnel

Primary source identity:

- RAIB Report 07/2026: Near miss with track workers at Bookham Tunnel
- occurrence location: Bookham Tunnel, Surrey
- occurrence date: 29 April 2025
- publication date: 15 June 2026
- official report page: `https://www.gov.uk/raib-reports/report-07-slash-2026-near-miss-with-track-workers-at-bookham-tunnel`
- full RAIB report: `R072026_260615_Bookham Tunnel`, 48 pages

Viability checks:

```text
source accessible: YES
report identity correct: YES
timeline reconstructible: YES
actors/evidence/action reconstructible: YES
substantive repository contamination before held-out freeze: NO IDENTIFIED
```

The official RAIB page identifies the near miss, track-worker team, signaller, safe work pack, line-blockage mismatch, planning/checking process, underlying information-transfer/process factors, recommendations, and learning points. The 48-page investigation report is available for the later native reconstruction stage.

```text
H_unknown primary: LOCKED
reserve Nordan Farm UWC: NOT ACTIVATED
```

## Contamination note

After the preregistration PR, the case names necessarily appear in `META_ARCHITECTURE_HELDOUT_UNIVERSE.md` and experiment-navigation material. Those administrative references are not substantive case analysis and therefore do not trigger the contamination failure rule.

No reserve may be activated later because a primary is absorbed by ordinary theory, supports A_null, produces no residual, or is otherwise uninteresting.
