import copy
import pytest

from v011_kernel import (
    Claim, Context, EpiStatus, EvaluationState, FormationError, History,
    KernelError, LicenseError, LicenseType, Move, Placement, Profile,
    ProofKernel, Role, RootToken, Rule, Scope, SatisfactionError, TOP,
    Warrant, atom, conj,
)

B = Scope.of("shared")
WIDE = Scope.of("shared", "extra")


def make_env(profile: Profile, context: Context, use="u"):
    k = ProofKernel("K0")
    h = History()
    s = EvaluationState()
    h.register_context(context)
    bid = k.bind_profile(h, s, profile, B, use, source="project-owner")
    return k, h, s, bid


def add_admitted_root(k, h, s, bid, c, token_id, claim, role, source, use="u"):
    wid = k.root(
        h, bid, c, RootToken(token_id, claim, role, B, source)
    )
    k.admit_root(
        h, s, bid, c.id, use, wid, actor="fixture", basis="toy-admission"
    )
    return wid


# ------------------------------------------------------------
# Original four toy models, hardened
# ------------------------------------------------------------

def test_toy1_suspect_but_not_reopen_or_adopt():
    c = Context("c0", frozenset({
        "PersistentResidual", "RepairCoverage", "Attribution", "Escalate",
        "SelectedRevision",
    }))
    p = Profile("k0", "1")

    suspect = Move("Suspect", ("O2",), B)
    reopen = Move("Reopen", ("O3",), B)
    adopt = Move("Adopt", ("SigmaPrime",), B)

    p.set_requirement(
        LicenseType.EPISTEMIC, suspect,
        conj(
            atom(Claim("PersistentResidual", ("z",)), Role.CONTENT, B),
            atom(Claim("RepairCoverage", ("z", "O2")), Role.COVERAGE, B),
            atom(Claim("Attribution", ("z", "O2")), Role.ESCALATION, B),
        )
    )
    p.set_requirement(
        LicenseType.EPISTEMIC, reopen,
        conj(
            p.requirements[(LicenseType.EPISTEMIC.value, suspect.kind, suspect.args)],
            atom(Claim("Escalate", ("O2", "O3")), Role.ESCALATION, B),
        )
    )
    # Deliberately maliciously weak profile requirement for Adopt.
    p.set_requirement(LicenseType.EPISTEMIC, adopt, TOP)

    k, h, s, bid = make_env(p, c)
    z = add_admitted_root(k, h, s, bid, c, "z", Claim("PersistentResidual", ("z",)), Role.CONTENT, "sensor")
    r = add_admitted_root(k, h, s, bid, c, "r", Claim("RepairCoverage", ("z", "O2")), Role.COVERAGE, "repair-audit")
    a = add_admitted_root(k, h, s, bid, c, "a", Claim("Attribution", ("z", "O2")), Role.ESCALATION, "analyst")

    k.license(h, s, bid, c.id, ["i"], "u", LicenseType.EPISTEMIC, suspect, [z, r, a])

    with pytest.raises(SatisfactionError):
        k.license(h, s, bid, c.id, ["i"], "u", LicenseType.EPISTEMIC, reopen, [z, r, a])

    # Now fails because of kernel Adopt gate, not because requirement is absent.
    with pytest.raises(LicenseError):
        k.license(h, s, bid, c.id, ["i"], "u", LicenseType.EPISTEMIC, adopt, [])


def test_toy2_three_votes_one_root_no_distinct_provenance_no_share():
    c = Context("c0", frozenset({"p", "DescentCandidate", "AuditedDistinctRoots"}))
    p = Profile("k0", "1")
    p.add_rule(Rule(
        "joint",
        (Role.CONTENT, Role.CONTENT, Role.CONTENT),
        Role.SELECTION,
        Claim("DescentCandidate", ("p",)),
    ))
    p.add_rule(Rule(
        "distinct",
        (Role.CONTENT, Role.CONTENT, Role.CONTENT),
        Role.PROVENANCE,
        Claim("AuditedDistinctRoots", ("p",)),
        kernel_guard="distinct_content_roots",
    ))
    share = Move("Share", ("p",), B)
    p.set_requirement(
        LicenseType.EPISTEMIC, share,
        conj(
            atom(Claim("DescentCandidate", ("p",)), Role.SELECTION, B),
            atom(Claim("AuditedDistinctRoots", ("p",)), Role.PROVENANCE, B),
        )
    )

    k, h, s, bid = make_env(p, c)
    a = add_admitted_root(k, h, s, bid, c, "a", Claim("p"), Role.CONTENT, "db:S")
    b = add_admitted_root(k, h, s, bid, c, "b", Claim("p"), Role.CONTENT, "db:S")
    d = add_admitted_root(k, h, s, bid, c, "d", Claim("p"), Role.CONTENT, "db:S")

    descent = k.infer(h, bid, c.id, "joint", [a, b, d], B)
    k.qualify_derived(h, s, bid, c.id, "u", descent, actor="fixture", basis="derived")

    with pytest.raises(FormationError):
        k.infer(h, bid, c.id, "distinct", [a, b, d], B)

    with pytest.raises(SatisfactionError):
        k.license(h, s, bid, c.id, ["A", "B", "C"], "u",
                  LicenseType.EPISTEMIC, share, [descent, a, b, d])


def test_toy3_heterogeneous_languages_only_explicit_bridge_content_can_be_shared():
    cA = Context("cA", frozenset({"pA", "qA", "Transportable"}))
    cB = Context("cB", frozenset({"pB", "Transportable"}))
    cI = Context("cI", frozenset({"pI", "JointCandidate"}))

    p = Profile("k0", "1")
    p.add_rule(Rule(
        "jointI", (Role.CONTENT, Role.CONTENT), Role.SELECTION,
        Claim("JointCandidate", ("pI",))
    ))
    share = Move("Share", ("pI",), B)
    p.set_requirement(
        LicenseType.EPISTEMIC, share,
        atom(Claim("JointCandidate", ("pI",)), Role.SELECTION, B)
    )

    k = ProofKernel("K0")
    h = History()
    s = EvaluationState()
    for c in (cA, cB, cI):
        h.register_context(c)
    bid = k.bind_profile(h, s, p, B, "u", source="joint-procedure")

    pA = add_admitted_root(k, h, s, bid, cA, "pA", Claim("pA"), Role.CONTENT, "sensor-A")
    pB = add_admitted_root(k, h, s, bid, cB, "pB", Claim("pB"), Role.CONTENT, "sensor-B")
    qA = add_admitted_root(k, h, s, bid, cA, "qA", Claim("qA"), Role.CONTENT, "sensor-Aq")

    # Direct cross-context inference is forbidden.
    with pytest.raises(FormationError):
        k.infer(h, bid, cI.id, "jointI", [pA, pB], B)

    target_key = Claim("pI").key()
    chiA = add_admitted_root(
        k, h, s, bid, cA, "chiA",
        Claim("Transportable", ("A_to_I", pA, cI.id, target_key)),
        Role.BRIDGE, "bridge-A"
    )
    chiB = add_admitted_root(
        k, h, s, bid, cB, "chiB",
        Claim("Transportable", ("B_to_I", pB, cI.id, target_key)),
        Role.BRIDGE, "bridge-B"
    )

    pAi = k.transport(h, bid, cI, map_id="A_to_I", original_id=pA, witness_id=chiA,
                      translated_claim=Claim("pI"), out_scope=B)
    pBi = k.transport(h, bid, cI, map_id="B_to_I", original_id=pB, witness_id=chiB,
                      translated_claim=Claim("pI"), out_scope=B)
    k.qualify_derived(h, s, bid, cI.id, "u", pAi, actor="joint", basis="transport")
    k.qualify_derived(h, s, bid, cI.id, "u", pBi, actor="joint", basis="transport")

    joint = k.infer(h, bid, cI.id, "jointI", [pAi, pBi], B)
    k.qualify_derived(h, s, bid, cI.id, "u", joint, actor="joint", basis="joint")
    k.license(h, s, bid, cI.id, ["A", "B"], "u",
              LicenseType.EPISTEMIC, share, [joint])

    # qA is usable in cA but cannot satisfy anything in cI.
    assert not s.usable(h.bindings[bid].profile_digest, cI.id, "u", qA)
    assert h.warrants[pAi].roots_by_role[Role.CONTENT] == frozenset({"sensor-A"})
    assert "bridge-A" in h.warrants[pAi].roots_by_role[Role.BRIDGE]


def test_toy4_novel_language_challenge_revalidates_dependency_chain_without_rewriting_history():
    c0 = Context("c0", frozenset({
        "CoverageAdequate", "DerivedCoverage", "Selected", "Challenges"
    }))
    c1 = Context("c1", frozenset({"q", "BridgeForChallenge", "Challenges"}))
    p = Profile("k0", "1")
    p.add_rule(Rule(
        "deriveCoverage", (Role.COVERAGE,), Role.COVERAGE,
        Claim("DerivedCoverage", ("d",))
    ))
    p.add_rule(Rule(
        "challenge", (Role.CONTENT, Role.BRIDGE), Role.BRIDGE,
        Claim("Challenges", ("PLACEHOLDER", "PLACEHOLDER"))
    ))
    share = Move("Share", ("d",), B)
    p.set_requirement(
        LicenseType.EPISTEMIC, share,
        conj(
            atom(Claim("DerivedCoverage", ("d",)), Role.COVERAGE, B),
            atom(Claim("Selected", ("d",)), Role.SELECTION, B),
        )
    )

    k = ProofKernel("K0")
    h = History()
    s = EvaluationState()
    h.register_context(c0)
    h.register_context(c1)
    bid = k.bind_profile(h, s, p, B, "u", source="procedure")

    w0 = add_admitted_root(k, h, s, bid, c0, "cov",
                           Claim("CoverageAdequate", ("d",)), Role.COVERAGE, "coverage-source")
    sel = add_admitted_root(k, h, s, bid, c0, "sel",
                            Claim("Selected", ("d",)), Role.SELECTION, "selection-source")
    w1 = k.infer(h, bid, c0.id, "deriveCoverage", [w0], B)
    k.qualify_derived(h, s, bid, c0.id, "u", w1, actor="fixture", basis="derive")
    L0 = k.license(h, s, bid, c0.id, ["G"], "u",
                   LicenseType.EPISTEMIC, share, [w1, sel])

    historical_warrants = set(h.warrants)
    historical_licenses = set(h.licenses)

    q = add_admitted_root(k, h, s, bid, c1, "q",
                          Claim("q"), Role.CONTENT, "new-sensor")
    b0 = add_admitted_root(k, h, s, bid, c1, "b0",
                           Claim("BridgeForChallenge", ("q",)), Role.BRIDGE, "reviewer")

    # The generic profile rule cannot encode dynamic IDs in its output claim,
    # so create the exact bridge as an explicit root at the external bridge boundary.
    beta = add_admitted_root(
        k, h, s, bid, c1, "beta",
        Claim("Challenges", (q, w0)), Role.BRIDGE, "cross-context-reviewer"
    )

    impacted = k.challenge(
        h, s, bid, c1.id, "u",
        challenger_id=q, challenge_bridge_id=beta, target_id=w0
    )
    assert w0 in impacted and w1 in impacted

    pd = h.bindings[bid].profile_digest
    assert s.epi[s.key(pd, c0.id, "u", w0)] == EpiStatus.SUSPENDED
    assert s.epi[s.key(pd, c0.id, "u", w1)] == EpiStatus.SUSPENDED
    assert s.placement[s.key(pd, c0.id, "u", w1)] == Placement.PENDING
    assert L0.id in s.review_required

    assert historical_warrants <= set(h.warrants)
    assert historical_licenses <= set(h.licenses)
    assert L0.id in h.licenses

    with pytest.raises(SatisfactionError):
        k.license(h, s, bid, c0.id, ["G"], "u",
                  LicenseType.EPISTEMIC, share, [w1, sel])


# ------------------------------------------------------------
# V0.1.1 hardening regressions requested in review
# ------------------------------------------------------------

def test_spoofed_warrant_id_cannot_change_role():
    c = Context("c0", frozenset({"Evidence", "Authorized"}))
    p = Profile("k0", "1")
    p.add_rule(Rule(
        "auth-id", (Role.AUTHORIZATION,), Role.AUTHORIZATION,
        Claim("Authorized", ("a",))
    ))
    k, h, s, bid = make_env(p, c)
    wid = add_admitted_root(k, h, s, bid, c, "x",
                            Claim("Evidence", ("p",)), Role.CONTENT, "sensor")

    # Caller can manufacture a Python object, but public API accepts only IDs.
    spoof = Warrant(
        id=wid,
        claim=Claim("Authorized", ("fake",)),
        role=Role.AUTHORIZATION,
        scope=B,
        constructor="root",
        parents=(),
        formation_profile_digest=h.bindings[bid].profile_digest,
        formation_context=c.id,
        source="attacker",
        roots_by_role={Role.AUTHORIZATION: frozenset({"attacker"})},
    )
    assert spoof.id == wid
    with pytest.raises(FormationError):
        # Canonical history object is CONTENT, so the auth rule cannot consume it.
        k.infer(h, bid, c.id, "auth-id", [spoof.id], B)


def test_spoofed_binding_id_cannot_widen_scope():
    c = Context("c0", frozenset({"Selected"}))
    p = Profile("k0", "1")
    move = Move("Share", ("d",), WIDE)
    p.set_requirement(
        LicenseType.EPISTEMIC, move,
        atom(Claim("Selected", ("d",)), Role.SELECTION, B)
    )
    k, h, s, bid = make_env(p, c)
    sel = add_admitted_root(k, h, s, bid, c, "s",
                            Claim("Selected", ("d",)), Role.SELECTION, "selector")

    fake_binding = copy.copy(h.bindings[bid])
    object.__setattr__(fake_binding, "scope", WIDE)
    assert fake_binding.id == bid
    with pytest.raises(LicenseError):
        # LICENSE resolves canonical binding by id; fake object is irrelevant.
        k.license(h, s, fake_binding.id, c.id, ["G"], "u",
                  LicenseType.EPISTEMIC, move, [sel])


def test_cross_context_use_requires_transport():
    cA = Context("cA", frozenset({"p"}))
    cI = Context("cI", frozenset({"p", "Selected"}))
    p = Profile("k0", "1")
    move = Move("Share", ("p",), B)
    p.set_requirement(
        LicenseType.EPISTEMIC, move,
        atom(Claim("Selected", ("p",)), Role.SELECTION, B)
    )
    p.add_rule(Rule("select", (Role.CONTENT,), Role.SELECTION, Claim("Selected", ("p",))))

    k = ProofKernel("K0")
    h = History()
    s = EvaluationState()
    h.register_context(cA)
    h.register_context(cI)
    bid = k.bind_profile(h, s, p, B, "u", source="owner")
    wp = add_admitted_root(k, h, s, bid, cA, "p", Claim("p"), Role.CONTENT, "sensor")

    with pytest.raises(FormationError):
        k.infer(h, bid, cI.id, "select", [wp], B)


def test_bound_profile_is_immutable_snapshot():
    c = Context("c0", frozenset({"Selected", "Authorization"}))
    p = Profile("k0", "1")
    share = Move("Share", ("d",), B)
    p.set_requirement(
        LicenseType.EPISTEMIC, share,
        atom(Claim("Selected", ("d",)), Role.SELECTION, B)
    )
    k, h, s, bid = make_env(p, c)

    # Mutate builder after bind: the active binding must still point to old snapshot.
    p.set_requirement(LicenseType.EPISTEMIC, share, TOP)
    p.add_rule(Rule("late", (Role.CONTENT,), Role.SELECTION, Claim("Selected", ("d",))))

    with pytest.raises(SatisfactionError):
        k.license(h, s, bid, c.id, ["G"], "u",
                  LicenseType.EPISTEMIC, share, [])


def test_challenge_ancestor_revalidates_descendants_and_licenses():
    c = Context("c0", frozenset({
        "p0", "p1", "p2", "Selected", "Challenges"
    }))
    p = Profile("k0", "1")
    p.add_rule(Rule("r1", (Role.CONTENT,), Role.CONTENT, Claim("p1")))
    p.add_rule(Rule("r2", (Role.CONTENT,), Role.CONTENT, Claim("p2")))
    share = Move("Share", ("p2",), B)
    p.set_requirement(
        LicenseType.EPISTEMIC, share,
        conj(
            atom(Claim("p2"), Role.CONTENT, B),
            atom(Claim("Selected", ("p2",)), Role.SELECTION, B),
        )
    )
    k, h, s, bid = make_env(p, c)
    w0 = add_admitted_root(k, h, s, bid, c, "w0", Claim("p0"), Role.CONTENT, "s0")
    sel = add_admitted_root(k, h, s, bid, c, "sel",
                            Claim("Selected", ("p2",)), Role.SELECTION, "selector")
    w1 = k.infer(h, bid, c.id, "r1", [w0], B)
    k.qualify_derived(h, s, bid, c.id, "u", w1, actor="x", basis="r1")
    w2 = k.infer(h, bid, c.id, "r2", [w1], B)
    k.qualify_derived(h, s, bid, c.id, "u", w2, actor="x", basis="r2")
    L = k.license(h, s, bid, c.id, ["G"], "u",
                  LicenseType.EPISTEMIC, share, [w2, sel])

    challenger = add_admitted_root(k, h, s, bid, c, "ch",
                                   Claim("p0"), Role.CONTENT, "counter")
    bridge = add_admitted_root(
        k, h, s, bid, c, "cb",
        Claim("Challenges", (challenger, w0)), Role.BRIDGE, "reviewer"
    )
    impacted = k.challenge(
        h, s, bid, c.id, "u",
        challenger_id=challenger, challenge_bridge_id=bridge, target_id=w0
    )
    assert {w0, w1, w2} <= set(impacted)
    assert L.id in s.review_required
    pd = h.bindings[bid].profile_digest
    assert not s.usable(pd, c.id, "u", w2)


def test_top_cannot_license_adopt():
    c = Context("c0", frozenset({"x"}))
    p = Profile("k0", "1")
    adopt = Move("Adopt", ("SigmaPrime",), B)
    p.set_requirement(LicenseType.EPISTEMIC, adopt, TOP)
    k, h, s, bid = make_env(p, c)
    with pytest.raises(LicenseError):
        k.license(h, s, bid, c.id, ["i"], "u",
                  LicenseType.EPISTEMIC, adopt, [])


def test_normative_license_is_explicitly_disabled_in_v011():
    c = Context("c0", frozenset({"Selected"}))
    p = Profile("k0", "1")
    m = Move("AcceptNorm", ("n",), B)
    p.set_requirement(LicenseType.NORMATIVE, m, TOP)
    k, h, s, bid = make_env(p, c)
    with pytest.raises(LicenseError):
        k.license(h, s, bid, c.id, ["i"], "u",
                  LicenseType.NORMATIVE, m, [])


def test_transport_witness_is_bound_to_target_claim_and_context():
    cA = Context("cA", frozenset({"pA", "Transportable"}))
    cI = Context("cI", frozenset({"pI", "evil"}))
    p = Profile("k0", "1")
    k = ProofKernel("K0")
    h = History()
    s = EvaluationState()
    h.register_context(cA)
    h.register_context(cI)
    bid = k.bind_profile(h, s, p, B, "u", source="owner")

    pA = add_admitted_root(k, h, s, bid, cA, "pA",
                           Claim("pA"), Role.CONTENT, "sensor")
    chi = add_admitted_root(
        k, h, s, bid, cA, "chi",
        Claim("Transportable", ("A_to_I", pA, cI.id, Claim("pI").key())),
        Role.BRIDGE, "bridge-audit"
    )

    # Witness was for pI, not arbitrary 'evil'.
    with pytest.raises(FormationError):
        k.transport(
            h, bid, cI, map_id="A_to_I", original_id=pA, witness_id=chi,
            translated_claim=Claim("evil"), out_scope=B
        )


# Extra kernel regressions

def test_bad_profile_cannot_turn_top_into_action_license():
    c = Context("c0", frozenset({"x"}))
    p = Profile("k0", "1")
    act = Move("Act", ("dangerous",), B)
    p.set_requirement(LicenseType.ACTION, act, TOP)
    k, h, s, bid = make_env(p, c)
    with pytest.raises(LicenseError):
        k.license(h, s, bid, c.id, ["i"], "u",
                  LicenseType.ACTION, act, [])


def test_bad_profile_cannot_define_content_to_authorization_rule():
    c = Context("c0", frozenset({"Evidence", "Authorized"}))
    p = Profile("k0", "1")
    p.add_rule(Rule(
        "bad", (Role.CONTENT,), Role.AUTHORIZATION, Claim("Authorized", ("a",))
    ))
    k, h, s, bid = make_env(p, c)
    x = add_admitted_root(k, h, s, bid, c, "x",
                          Claim("Evidence", ("p",)), Role.CONTENT, "sensor")
    with pytest.raises(FormationError):
        k.infer(h, bid, c.id, "bad", [x], B)


def test_license_requires_canonical_context_even_for_top_requirement():
    c = Context("c0", frozenset({"x"}))
    p = Profile("k0", "1")
    m = Move("Accept", ("x",), B)
    p.set_requirement(LicenseType.EPISTEMIC, m, TOP)
    k, h, s, bid = make_env(p, c)

    with pytest.raises(KernelError):
        k.license(h, s, bid, "invented-context", ["i"], "u",
                  LicenseType.EPISTEMIC, m, [])


def test_challenge_does_not_silently_cross_use_boundary():
    c = Context("c0", frozenset({"p", "Challenges"}))
    p = Profile("k0", "1")
    k = ProofKernel("K0")
    h = History()
    s = EvaluationState()
    h.register_context(c)
    b_u1 = k.bind_profile(h, s, p, B, "u1", source="owner")
    # Same snapshot, separately bound for another use.
    b_u2 = k.bind_profile(h, s, p, B, "u2", source="owner")

    w = k.root(h, b_u1, c, RootToken("w", Claim("p"), Role.CONTENT, B, "source"))
    # Same historical warrant cannot be admitted under b_u2 because it formed under same
    # profile digest and context; use is an evaluation axis, so both admissions are explicit.
    k.admit_root(h, s, b_u1, c.id, "u1", w, actor="x", basis="u1")
    k.admit_root(h, s, b_u2, c.id, "u2", w, actor="x", basis="u2")

    challenger = k.root(
        h, b_u1, c, RootToken("ch", Claim("p"), Role.CONTENT, B, "counter")
    )
    bridge = k.root(
        h, b_u1, c,
        RootToken("br", Claim("Challenges", (challenger, w)), Role.BRIDGE, B, "reviewer")
    )
    k.admit_root(h, s, b_u1, c.id, "u1", challenger, actor="x", basis="u1")
    k.admit_root(h, s, b_u1, c.id, "u1", bridge, actor="x", basis="u1")

    k.challenge(h, s, b_u1, c.id, "u1",
                challenger_id=challenger, challenge_bridge_id=bridge, target_id=w)

    pd = h.bindings[b_u1].profile_digest
    assert not s.usable(pd, c.id, "u1", w)
    assert s.usable(pd, c.id, "u2", w)
