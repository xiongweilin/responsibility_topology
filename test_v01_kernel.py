import pytest

from v01_kernel import (
    And, Atom, Binding, Claim, Context, EpiStatus, EvaluationState,
    FormationError, History, LicenseError, LicenseType, Move, Placement,
    Profile, ProofKernel, Role, RootToken, Rule, Scope, SatisfactionError,
    TOP, atom, conj,
)


B = Scope.of("shared")
WIDE = Scope.of("shared", "extra")


def admitted_root(kernel, history, state, profile, context, token_id, claim, role, source):
    w = kernel.root(
        history, profile, context,
        RootToken(token_id, claim, role, B, source)
    )
    kernel.admit_root(history, state, w, actor="tester", basis="toy-fixture")
    return w


def setup_env(profile_id="k0"):
    k = ProofKernel("K0")
    h = History()
    s = EvaluationState()
    c = Context("c0", frozenset({"base"}))
    p = Profile(profile_id)
    binding = k.bind_profile(h, s, p, B, "u", source="project-owner")
    return k, h, s, c, p, binding


def test_toy1_suspect_but_not_reopen_or_adopt():
    k, h, s, c, p, binding = setup_env()

    z = admitted_root(k, h, s, p, c, "a-z",
        Claim("PersistentResidual", ("z",)), Role.CONTENT, "sensor-z")
    repair = admitted_root(k, h, s, p, c, "a-r",
        Claim("RepairCoverage", ("z", "O2")), Role.COVERAGE, "audit-r")
    attribution = admitted_root(k, h, s, p, c, "a-a",
        Claim("Attribution", ("z", "O2")), Role.ESCALATION, "analyst-a")

    suspect = Move("Suspect", ("O2",), B)
    p.set_requirement(
        LicenseType.EPISTEMIC, suspect,
        conj(
            atom(z.claim, Role.CONTENT, B),
            atom(repair.claim, Role.COVERAGE, B),
            atom(attribution.claim, Role.ESCALATION, B),
        )
    )

    lic = k.license(
        h, s, p, c, ["i"], "u", binding,
        LicenseType.EPISTEMIC, suspect, [z, repair, attribution]
    )
    assert lic.move == suspect

    reopen = Move("Reopen", ("O3",), B)
    p.set_requirement(
        LicenseType.EPISTEMIC, reopen,
        conj(
            atom(z.claim, Role.CONTENT, B),
            atom(repair.claim, Role.COVERAGE, B),
            atom(attribution.claim, Role.ESCALATION, B),
            atom(Claim("Escalate", ("O2", "O3")), Role.ESCALATION, B),
        )
    )

    with pytest.raises(SatisfactionError):
        k.license(
            h, s, p, c, ["i"], "u", binding,
            LicenseType.EPISTEMIC, reopen, [z, repair, attribution]
        )

    adopt = Move("Adopt", ("SigmaPrime",), B)
    with pytest.raises(LicenseError):
        k.license(
            h, s, p, c, ["i"], "u", binding,
            LicenseType.EPISTEMIC, adopt, [z, repair, attribution]
        )


def test_toy2_three_votes_one_root_no_distinct_provenance_no_share():
    k, h, s, c, p, binding = setup_env()

    # Three submitted observations, all trace to the same actual content source.
    a = admitted_root(k, h, s, p, c, "a1", Claim("p"), Role.CONTENT, "db:S")
    b = admitted_root(k, h, s, p, c, "a2", Claim("p"), Role.CONTENT, "db:S")
    cc = admitted_root(k, h, s, p, c, "a3", Claim("p"), Role.CONTENT, "db:S")

    p.rules["joint"] = Rule(
        "joint",
        (Role.CONTENT, Role.CONTENT, Role.CONTENT),
        Role.SELECTION,
        Claim("DescentCandidate", ("p",)),
    )
    descent = k.infer(h, p, c, "joint", [a, b, cc], B)
    k.qualify_derived(h, s, descent, actor="tester", basis="derived-selection-current")

    # Kernel-recognized audit rule: it can only form if content roots are disjoint.
    p.rules["distinct"] = Rule(
        "distinct",
        (Role.CONTENT, Role.CONTENT, Role.CONTENT),
        Role.PROVENANCE,
        Claim("AuditedDistinctRoots", ("p",)),
        kernel_guard="distinct_content_roots",
    )
    with pytest.raises(FormationError):
        k.infer(h, p, c, "distinct", [a, b, cc], B)

    share = Move("Share", ("p",), B)
    p.set_requirement(
        LicenseType.EPISTEMIC, share,
        conj(
            atom(descent.claim, Role.SELECTION, B),
            atom(Claim("AuditedDistinctRoots", ("p",)), Role.PROVENANCE, B),
        )
    )

    with pytest.raises(SatisfactionError):
        k.license(
            h, s, p, c, ["A", "B", "C"], "u", binding,
            LicenseType.EPISTEMIC, share, [descent, a, b, cc]
        )


def test_toy3_heterogeneous_languages_only_bridgeable_content_can_be_shared():
    k = ProofKernel("K0")
    h = History()
    s = EvaluationState()
    p = Profile("k0")
    cA = Context("cA", frozenset({"pA", "qA"}))
    cB = Context("cB", frozenset({"pB"}))
    cI = Context("cI", frozenset({"pI"}))
    binding = k.bind_profile(h, s, p, B, "u", source="joint-procedure")

    pA = admitted_root(k, h, s, p, cA, "pA",
        Claim("pA"), Role.CONTENT, "sensor-A")
    pB = admitted_root(k, h, s, p, cB, "pB",
        Claim("pB"), Role.CONTENT, "sensor-B")
    qA = admitted_root(k, h, s, p, cA, "qA",
        Claim("qA"), Role.CONTENT, "sensor-Aq")

    chiA = admitted_root(k, h, s, p, cA, "chiA",
        Claim("Transportable", ("A_to_I", pA.id)), Role.BRIDGE, "bridge-audit-A")
    chiB = admitted_root(k, h, s, p, cB, "chiB",
        Claim("Transportable", ("B_to_I", pB.id)), Role.BRIDGE, "bridge-audit-B")

    pAi = k.transport(h, p, cI, "A_to_I", chiA, pA, Claim("pI"), B)
    pBi = k.transport(h, p, cI, "B_to_I", chiB, pB, Claim("pI"), B)
    k.qualify_derived(h, s, pAi, actor="joint", basis="transport-qualified")
    k.qualify_derived(h, s, pBi, actor="joint", basis="transport-qualified")

    p.rules["joint-I"] = Rule(
        "joint-I",
        (Role.CONTENT, Role.CONTENT),
        Role.SELECTION,
        Claim("JointCandidate", ("pI",)),
    )
    joint = k.infer(h, p, cI, "joint-I", [pAi, pBi], B)
    k.qualify_derived(h, s, joint, actor="joint", basis="derived-selection-current")

    share_p = Move("Share", ("pI",), B)
    p.set_requirement(
        LicenseType.EPISTEMIC, share_p,
        atom(joint.claim, Role.SELECTION, B)
    )
    k.license(
        h, s, p, cI, ["A", "B"], "u", binding,
        LicenseType.EPISTEMIC, share_p, [joint, pAi, pBi]
    )

    # qA has no bridge witness, so no qI warrant can be constructed.
    share_pq = Move("Share", ("pI&qI",), B)
    p.set_requirement(
        LicenseType.EPISTEMIC, share_pq,
        atom(Claim("JointCandidate", ("pI&qI",)), Role.SELECTION, B)
    )
    with pytest.raises(SatisfactionError):
        k.license(
            h, s, p, cI, ["A", "B"], "u", binding,
            LicenseType.EPISTEMIC, share_pq, [joint, pAi, pBi, qA]
        )

    # Transport preserved content roots; bridge sources did not become content roots.
    assert pAi.roots_by_role[Role.CONTENT] == frozenset({"sensor-A"})
    assert "bridge-audit-A" in pAi.roots_by_role[Role.BRIDGE]


def test_toy4_novel_language_challenge_suspends_old_support_without_rewriting_history():
    k, h, s, c0, p, binding = setup_env()

    coverage = admitted_root(k, h, s, p, c0, "cov",
        Claim("CoverageAdequate", ("d",)), Role.COVERAGE, "coverage-audit")
    selection = admitted_root(k, h, s, p, c0, "sel",
        Claim("Selected", ("d",)), Role.SELECTION, "selection-board")

    share = Move("Share", ("d",), B)
    req = conj(
        atom(coverage.claim, Role.COVERAGE, B),
        atom(selection.claim, Role.SELECTION, B),
    )
    p.set_requirement(LicenseType.EPISTEMIC, share, req)

    L0 = k.license(
        h, s, p, c0, ["G"], "u", binding,
        LicenseType.EPISTEMIC, share, [coverage, selection]
    )
    historical_warrant_ids = set(h.warrants)
    historical_license_ids = set(h.licenses)

    # New language/context contains a distinction q absent from Sigma_0.
    c1 = Context("c1", frozenset({"base", "q"}))
    q = admitted_root(k, h, s, p, c1, "q-new",
        Claim("q"), Role.CONTENT, "new-sensor")

    bridge = admitted_root(k, h, s, p, c1, "bridge-ch",
        Claim("BridgeForChallenge", ("q",)), Role.BRIDGE, "cross-context-reviewer")

    p.rules["challenge"] = Rule(
        "challenge",
        (Role.CONTENT, Role.BRIDGE),
        Role.BRIDGE,
        Claim("Challenges", (q.id, coverage.id)),
    )
    beta = k.infer(h, p, c1, "challenge", [q, bridge], B)
    k.qualify_derived(h, s, beta, actor="reviewer", basis="cross-context-bridge")

    k.challenge(h, s, challenger=q, challenge_bridge=beta, target=coverage)

    assert s.epi[coverage.id] == EpiStatus.SUSPENDED
    assert L0.id in s.review_required

    # Historical derivations/licenses are still present.
    assert historical_warrant_ids <= set(h.warrants)
    assert historical_license_ids <= set(h.licenses)
    assert L0.id in h.licenses

    # Current reuse fails because one branch leaf is no longer usable.
    with pytest.raises(SatisfactionError):
        k.license(
            h, s, p, c1, ["G"], "u", binding,
            LicenseType.EPISTEMIC, share, [coverage, selection, q, beta]
        )

    debt = k.residual(h, s, req, [coverage, selection, q, beta])
    assert debt != TOP

    # No profile rule/requirement exists for deeper conclusions, so they cannot be licensed.
    for move in [
        Move("Reopen", ("Sigma0",), B),
        Move("Adopt", ("Sigma1",), B),
    ]:
        with pytest.raises(LicenseError):
            k.license(
                h, s, p, c1, ["G"], "u", binding,
                LicenseType.EPISTEMIC, move, [coverage, selection, q, beta]
            )


def test_bad_profile_cannot_turn_top_into_action_license():
    k, h, s, c, p, binding = setup_env()
    act = Move("Act", ("dangerous-change",), B)
    p.set_requirement(LicenseType.ACTION, act, TOP)

    with pytest.raises(LicenseError):
        k.license(
            h, s, p, c, ["i"], "u", binding,
            LicenseType.ACTION, act, []
        )


def test_bad_profile_cannot_define_content_to_authorization_rule():
    k, h, s, c, p, binding = setup_env()
    x = admitted_root(k, h, s, p, c, "x", Claim("Evidence", ("p",)),
                      Role.CONTENT, "sensor")
    p.rules["bad"] = Rule(
        "bad",
        (Role.CONTENT,),
        Role.AUTHORIZATION,
        Claim("Authorized", ("a",)),
    )
    with pytest.raises(FormationError):
        k.infer(h, p, c, "bad", [x], B)


def test_external_admission_boundary_rejects_derived_warrant():
    k, h, s, c, p, binding = setup_env()
    x = admitted_root(k, h, s, p, c, "x2", Claim("p"), Role.CONTENT, "sensor")
    p.rules["id"] = Rule("id", (Role.CONTENT,), Role.CONTENT, Claim("p2"))
    y = k.infer(h, p, c, "id", [x], B)

    with pytest.raises(Exception):
        k.admit_root(h, s, y, actor="tester", basis="must-not-launder-derived")

    k.qualify_derived(h, s, y, actor="tester", basis="parents-currently-usable")
    assert s.usable(y.id)
