import pytest

from v0121_kernel import (
    Claim, Context, ContextStatus, EpiStatus, EvaluationState,
    FormationError, History, KernelError, LicenseError, LicenseType,
    Move, MoveKind, Placement, Profile, ProofKernel, RevisionDepth,
    RevisionReach, Role, RootToken, Rule, Scope, SatisfactionError,
    TOP, atom, conj,
)

B = Scope.of("shared")
WIDE = Scope.of("shared", "extra")


def base_context(context_id="c0", extra=()):
    return Context(
        context_id,
        frozenset({
            "p", "p0", "p1", "p2", "q",
            "Evidence", "Authorized",
            "PersistentResidual", "RepairCoverage",
            "EscalationDepth", "Selected",
            "DescentCandidate", "AuditedDistinctSources",
            "AuditedDistinctRoots", "Transportable",
            "JointCandidate", "CoverageAdequate",
            "DerivedCoverage", "Challenges",
            "BridgeForChallenge",
            *extra,
        }),
    )


def make_env(profile: Profile, context: Context, use="u"):
    k = ProofKernel("K0")
    h = History()
    s = EvaluationState()
    k.register_context_candidate(h, context, source="fixture")
    bid = k.bind_profile(h, s, profile, B, use, source="project-owner")
    k.bootstrap_activate_context(
        h, s, bid, context.id, use, source="initial-boundary"
    )
    return k, h, s, bid


def add_admitted_root(
    k, h, s, bid, c, token_id, claim, role, source, use="u"
):
    wid = k.root(
        h, bid, c.id,
        RootToken(token_id, claim, role, B, source),
    )
    k.admit_root(
        h, s, bid, c.id, use, wid,
        actor="fixture", basis="toy-admission",
    )
    return wid


# ============================================================
# G1 — trusted transition state
# ============================================================

def test_direct_state_mutation_is_outside_trusted_api():
    c = base_context()
    p = Profile("k", "1")
    k, h, s, bid = make_env(p, c)

    with pytest.raises(TypeError):
        h.warrants["forged"] = object()

    with pytest.raises(TypeError):
        h.bindings["forged"] = object()

    with pytest.raises(TypeError):
        s.epi[object()] = EpiStatus.LIVE

    assert not hasattr(s, "set_status")


# ============================================================
# G2 — candidate context != active context
# ============================================================

def test_new_context_cannot_become_active_without_context_adoption():
    c0 = base_context("c0")
    c1 = base_context("c1")
    p = Profile("k", "1")

    adopt = Move(
        MoveKind.ADOPT,
        (c1.id,),
        B,
        RevisionDepth.DISTINCTION,
    )
    p.set_requirement(
        LicenseType.EPISTEMIC,
        adopt,
        conj(
            atom(
                Claim("EscalationDepth", (str(int(RevisionDepth.DISTINCTION)),)),
                Role.ESCALATION,
                B,
            ),
            atom(Claim("Selected", (c1.id,)), Role.SELECTION, B),
        ),
    )

    k, h, s, bid = make_env(p, c0)
    k.register_context_candidate(h, c1, source="candidate-proposal")

    # Candidate context may host exploratory roots.
    q = add_admitted_root(
        k, h, s, bid, c1, "q", Claim("q"),
        Role.CONTENT, "candidate-sensor",
    )
    assert s.context_status(bid, c1.id, "u") == ContextStatus.CANDIDATE

    # But no operational license can be issued there yet.
    accept_q = Move(MoveKind.ACCEPT, ("q",), B)
    p2 = Profile("irrelevant", "2")
    with pytest.raises(LicenseError):
        # Bound snapshot has no requirement anyway, but active-context gate is first.
        k.license(
            h, s, bid, c1.id, ["i"], "u",
            LicenseType.EPISTEMIC, accept_q, [q],
        )

    esc = add_admitted_root(
        k, h, s, bid, c0, "esc",
        Claim("EscalationDepth", (str(int(RevisionDepth.DISTINCTION)),)),
        Role.ESCALATION, "review-board",
    )
    sel = add_admitted_root(
        k, h, s, bid, c0, "sel",
        Claim("Selected", (c1.id,)),
        Role.SELECTION, "selection-board",
    )
    L = k.license(
        h, s, bid, c0.id, ["i"], "u",
        LicenseType.EPISTEMIC, adopt, [esc, sel],
    )
    assert k.check_license_current(h, s, L.id)

    k.activate_context_with_adopt_license(h, s, L.id, c1.id)
    assert s.context_status(bid, c1.id, "u") == ContextStatus.ACTIVE


# ============================================================
# G3 — closed move strength
# ============================================================

def test_unknown_move_kind_cannot_bypass_strengthening_gate():
    with pytest.raises(TypeError):
        Move("ReplaceArchitecture", ("SigmaPrime",), B)  # type: ignore[arg-type]


def test_top_cannot_license_adopt():
    c0 = base_context("c0")
    c1 = base_context("c1")
    p = Profile("k", "1")
    adopt = Move(
        MoveKind.ADOPT,
        (c1.id,),
        B,
        RevisionDepth.DISTINCTION,
    )
    p.set_requirement(LicenseType.EPISTEMIC, adopt, TOP)

    k, h, s, bid = make_env(p, c0)
    k.register_context_candidate(h, c1, source="candidate")

    with pytest.raises(LicenseError):
        k.license(
            h, s, bid, c0.id, ["i"], "u",
            LicenseType.EPISTEMIC, adopt, [],
        )


def test_top_cannot_license_action():
    c = base_context()
    p = Profile("k", "1")
    act = Move(MoveKind.ACT, ("effect",), B)
    p.set_requirement(LicenseType.ACTION, act, TOP)
    k, h, s, bid = make_env(p, c)

    with pytest.raises(LicenseError):
        k.license(
            h, s, bid, c.id, ["i"], "u",
            LicenseType.ACTION, act, [],
        )


def test_normative_license_is_explicitly_disabled():
    c = base_context()
    p = Profile("k", "1")
    move = Move(MoveKind.ACCEPT, ("n",), B)
    p.set_requirement(LicenseType.NORMATIVE, move, TOP)
    k, h, s, bid = make_env(p, c)

    with pytest.raises(LicenseError):
        k.license(
            h, s, bid, c.id, ["i"], "u",
            LicenseType.NORMATIVE, move, [],
        )


# ============================================================
# G4 — typed revision depth
# ============================================================

def test_reopen_depth_requires_matching_escalation_depth():
    c = base_context()
    p = Profile("k", "1")
    reopen = Move(
        MoveKind.REOPEN,
        ("O4",),
        B,
        RevisionDepth.DISTINCTION,
    )
    p.set_requirement(
        LicenseType.EPISTEMIC,
        reopen,
        atom(
            Claim("EscalationDepth", (str(int(RevisionDepth.LOCAL)),)),
            Role.ESCALATION,
            B,
        ),
    )
    k, h, s, bid = make_env(p, c)
    weak = add_admitted_root(
        k, h, s, bid, c, "weak",
        Claim("EscalationDepth", (str(int(RevisionDepth.LOCAL)),)),
        Role.ESCALATION, "local-review",
    )

    with pytest.raises(LicenseError):
        k.license(
            h, s, bid, c.id, ["i"], "u",
            LicenseType.EPISTEMIC, reopen, [weak],
        )


def test_inference_cannot_amplify_escalation_depth():
    c = base_context()
    p = Profile("k", "1")
    p.add_rule(Rule(
        "inflate",
        (Role.ESCALATION,),
        Role.ESCALATION,
        Claim(
            "EscalationDepth",
            (str(int(RevisionDepth.ARCHITECTURE)),),
        ),
    ))
    k, h, s, bid = make_env(p, c)
    weak = add_admitted_root(
        k, h, s, bid, c, "weak",
        Claim("EscalationDepth", (str(int(RevisionDepth.LOCAL)),)),
        Role.ESCALATION, "local-review",
    )
    with pytest.raises(FormationError):
        k.infer(h, bid, c.id, "inflate", [weak], B)


# ============================================================
# G5 — use-local invalidation
# ============================================================

def test_challenge_does_not_review_other_use_license():
    c = base_context()
    p = Profile("k", "1")
    share = Move(MoveKind.SHARE, ("p",), B)
    p.set_requirement(
        LicenseType.EPISTEMIC,
        share,
        conj(
            atom(Claim("p"), Role.CONTENT, B),
            atom(Claim("Selected", ("p",)), Role.SELECTION, B),
        ),
    )

    k = ProofKernel("K0")
    h = History()
    s = EvaluationState()
    k.register_context_candidate(h, c, source="fixture")
    b1 = k.bind_profile(h, s, p, B, "u1", source="owner")
    b2 = k.bind_profile(h, s, p, B, "u2", source="owner")
    k.bootstrap_activate_context(h, s, b1, c.id, "u1", source="init")
    k.bootstrap_activate_context(h, s, b2, c.id, "u2", source="init")

    # Same historical roots are explicitly admitted for both uses.
    w = k.root(
        h, b1, c.id,
        RootToken("w", Claim("p"), Role.CONTENT, B, "source"),
    )
    sel = k.root(
        h, b1, c.id,
        RootToken("sel", Claim("Selected", ("p",)), Role.SELECTION, B, "selector"),
    )
    for bid, use in ((b1, "u1"), (b2, "u2")):
        k.admit_root(h, s, bid, c.id, use, w, actor="x", basis=use)
        k.admit_root(h, s, bid, c.id, use, sel, actor="x", basis=use)

    L1 = k.license(
        h, s, b1, c.id, ["G"], "u1",
        LicenseType.EPISTEMIC, share, [w, sel],
    )
    L2 = k.license(
        h, s, b2, c.id, ["G"], "u2",
        LicenseType.EPISTEMIC, share, [w, sel],
    )

    challenger = k.root(
        h, b1, c.id,
        RootToken("ch", Claim("p"), Role.CONTENT, B, "counter"),
    )
    bridge = k.root(
        h, b1, c.id,
        RootToken(
            "br",
            Claim("Challenges", (challenger, w)),
            Role.BRIDGE,
            B,
            "reviewer",
        ),
    )
    k.admit_root(h, s, b1, c.id, "u1", challenger, actor="x", basis="u1")
    k.admit_root(h, s, b1, c.id, "u1", bridge, actor="x", basis="u1")

    k.challenge(
        h, s, b1, c.id, "u1",
        challenger_id=challenger,
        challenge_bridge_id=bridge,
        target_id=w,
    )

    assert L1.id in s.review_required
    assert L2.id not in s.review_required
    assert k.check_license_current(h, s, L2.id)


# ============================================================
# G6 — explicit revision reach
# ============================================================

def test_revision_scope_is_explicit_about_use():
    c = base_context()
    p = Profile("k", "1")
    k = ProofKernel("K0")
    h = History()
    s = EvaluationState()
    k.register_context_candidate(h, c, source="fixture")
    b1 = k.bind_profile(h, s, p, B, "u1", source="owner")
    b2 = k.bind_profile(h, s, p, B, "u2", source="owner")
    k.bootstrap_activate_context(h, s, b1, c.id, "u1", source="init")
    k.bootstrap_activate_context(h, s, b2, c.id, "u2", source="init")

    w = k.root(
        h, b1, c.id,
        RootToken("w", Claim("p"), Role.CONTENT, B, "source"),
    )
    k.admit_root(h, s, b1, c.id, "u1", w, actor="x", basis="u1")
    k.admit_root(h, s, b2, c.id, "u2", w, actor="x", basis="u2")

    k.apply_revision(
        h, s, b1, [w],
        reach=RevisionReach.USE_LOCAL,
        use="u1",
        reason="local revision",
    )
    pd = h.bindings[b1].profile_digest
    assert not s.usable(pd, c.id, "u1", w)
    assert s.usable(pd, c.id, "u2", w)

    # Re-admit for u1 and then apply an explicitly global profile revision.
    k.admit_root(h, s, b1, c.id, "u1", w, actor="x", basis="requalify")
    k.apply_revision(
        h, s, b1, [w],
        reach=RevisionReach.PROFILE_GLOBAL,
        use=None,
        reason="global profile revision",
    )
    assert not s.usable(pd, c.id, "u1", w)
    assert not s.usable(pd, c.id, "u2", w)


# ============================================================
# G7 — historical issuance != current reusability
# ============================================================

def test_historical_license_cannot_be_reused_after_support_suspension():
    c0 = base_context("c0")
    c1 = base_context("c1")
    p = Profile("k", "1")

    adopt = Move(
        MoveKind.ADOPT,
        (c1.id,),
        B,
        RevisionDepth.DISTINCTION,
    )
    p.set_requirement(
        LicenseType.EPISTEMIC,
        adopt,
        conj(
            atom(
                Claim("EscalationDepth", (str(int(RevisionDepth.DISTINCTION)),)),
                Role.ESCALATION,
                B,
            ),
            atom(Claim("Selected", (c1.id,)), Role.SELECTION, B),
        ),
    )
    k, h, s, bid = make_env(p, c0)
    k.register_context_candidate(h, c1, source="candidate")

    esc = add_admitted_root(
        k, h, s, bid, c0, "esc",
        Claim("EscalationDepth", (str(int(RevisionDepth.DISTINCTION)),)),
        Role.ESCALATION, "review-board",
    )
    sel = add_admitted_root(
        k, h, s, bid, c0, "sel",
        Claim("Selected", (c1.id,)), Role.SELECTION, "selection-board",
    )
    L = k.license(
        h, s, bid, c0.id, ["i"], "u",
        LicenseType.EPISTEMIC, adopt, [esc, sel],
    )
    assert L.binding_id == bid
    assert k.check_license_current(h, s, L.id)

    # Explicit revision suspends a supporting leaf and marks the license for review.
    k.apply_revision(
        h, s, bid, [esc],
        reach=RevisionReach.USE_LOCAL,
        use="u",
        reason="escalation basis revised",
    )
    assert not k.check_license_current(h, s, L.id)
    assert L.id in h.licenses  # historical issuance remains

    with pytest.raises(KernelError):
        k.activate_context_with_adopt_license(h, s, L.id, c1.id)


# ============================================================
# G8 — provenance guard is actually exercised
# ============================================================

def _provenance_profile():
    p = Profile("k", "1")
    p.add_rule(Rule(
        "distinct-sources",
        (Role.CONTENT, Role.CONTENT, Role.CONTENT),
        Role.PROVENANCE,
        Claim("AuditedDistinctSources", ("p",)),
        kernel_guard="distinct_content_sources",
    ))
    return p


def test_distinct_root_guard_succeeds_on_distinct_sources():
    c = base_context()
    p = _provenance_profile()
    k, h, s, bid = make_env(p, c)
    a = add_admitted_root(k, h, s, bid, c, "a", Claim("p"), Role.CONTENT, "S1")
    b = add_admitted_root(k, h, s, bid, c, "b", Claim("p"), Role.CONTENT, "S2")
    d = add_admitted_root(k, h, s, bid, c, "d", Claim("p"), Role.CONTENT, "S3")

    cert = k.infer(h, bid, c.id, "distinct-sources", [a, b, d], B)
    assert h.warrants[cert].role == Role.PROVENANCE
    assert h.warrants[cert].claim == Claim("AuditedDistinctSources", ("p",))


def test_distinct_root_guard_fails_on_shared_source():
    c = base_context()
    p = _provenance_profile()
    k, h, s, bid = make_env(p, c)
    a = add_admitted_root(k, h, s, bid, c, "a", Claim("p"), Role.CONTENT, "S")
    b = add_admitted_root(k, h, s, bid, c, "b", Claim("p"), Role.CONTENT, "S")
    d = add_admitted_root(k, h, s, bid, c, "d", Claim("p"), Role.CONTENT, "S")

    with pytest.raises(FormationError):
        k.infer(h, bid, c.id, "distinct-sources", [a, b, d], B)


def test_unknown_kernel_guard_fails_closed():
    c = base_context()
    p = Profile("k", "1")
    p.add_rule(Rule(
        "mystery",
        (Role.CONTENT,),
        Role.PROVENANCE,
        Claim("AuditedDistinctSources", ("p",)),
        kernel_guard="magic_guard",
    ))
    k, h, s, bid = make_env(p, c)
    a = add_admitted_root(k, h, s, bid, c, "a", Claim("p"), Role.CONTENT, "S1")
    with pytest.raises(FormationError):
        k.infer(h, bid, c.id, "mystery", [a], B)


# ============================================================
# V0.1.1 regressions retained / strengthened
# ============================================================

def test_spoofed_warrant_id_cannot_change_role():
    c = base_context()
    p = Profile("k", "1")
    p.add_rule(Rule(
        "auth-id",
        (Role.AUTHORIZATION,),
        Role.AUTHORIZATION,
        Claim("Authorized", ("a",)),
    ))
    k, h, s, bid = make_env(p, c)
    wid = add_admitted_root(
        k, h, s, bid, c, "x",
        Claim("Evidence", ("p",)), Role.CONTENT, "sensor",
    )

    # Public proof API consumes only the canonical ID.
    with pytest.raises(FormationError):
        k.infer(h, bid, c.id, "auth-id", [wid], B)


def test_spoofed_binding_id_cannot_widen_scope():
    c = base_context()
    p = Profile("k", "1")
    move = Move(MoveKind.SHARE, ("p",), WIDE)
    p.set_requirement(
        LicenseType.EPISTEMIC,
        move,
        atom(Claim("Selected", ("p",)), Role.SELECTION, B),
    )
    k, h, s, bid = make_env(p, c)
    sel = add_admitted_root(
        k, h, s, bid, c, "sel",
        Claim("Selected", ("p",)), Role.SELECTION, "selector",
    )

    with pytest.raises(LicenseError):
        k.license(
            h, s, bid, c.id, ["G"], "u",
            LicenseType.EPISTEMIC, move, [sel],
        )


def test_cross_context_use_requires_transport():
    cA = base_context("cA")
    cI = base_context("cI")
    p = Profile("k", "1")
    p.add_rule(Rule(
        "select",
        (Role.CONTENT,),
        Role.SELECTION,
        Claim("Selected", ("p",)),
    ))

    k, h, s, bid = make_env(p, cA)
    k.register_context_candidate(h, cI, source="candidate")
    wp = add_admitted_root(
        k, h, s, bid, cA, "p",
        Claim("p"), Role.CONTENT, "sensor",
    )
    with pytest.raises(FormationError):
        k.infer(h, bid, cI.id, "select", [wp], B)


def test_bound_profile_is_immutable_snapshot():
    c = base_context()
    p = Profile("k", "1")
    share = Move(MoveKind.SHARE, ("p",), B)
    p.set_requirement(
        LicenseType.EPISTEMIC,
        share,
        atom(Claim("Selected", ("p",)), Role.SELECTION, B),
    )
    k, h, s, bid = make_env(p, c)

    # Mutation after bind changes only the builder, not the active snapshot.
    p.set_requirement(LicenseType.EPISTEMIC, share, TOP)

    with pytest.raises(SatisfactionError):
        k.license(
            h, s, bid, c.id, ["G"], "u",
            LicenseType.EPISTEMIC, share, [],
        )


def test_challenge_ancestor_revalidates_descendants_and_licenses():
    c = base_context()
    p = Profile("k", "1")
    p.add_rule(Rule("r1", (Role.CONTENT,), Role.CONTENT, Claim("p1")))
    p.add_rule(Rule("r2", (Role.CONTENT,), Role.CONTENT, Claim("p2")))
    share = Move(MoveKind.SHARE, ("p2",), B)
    p.set_requirement(
        LicenseType.EPISTEMIC,
        share,
        conj(
            atom(Claim("p2"), Role.CONTENT, B),
            atom(Claim("Selected", ("p2",)), Role.SELECTION, B),
        ),
    )
    k, h, s, bid = make_env(p, c)
    w0 = add_admitted_root(k, h, s, bid, c, "w0", Claim("p0"), Role.CONTENT, "S0")
    sel = add_admitted_root(
        k, h, s, bid, c, "sel",
        Claim("Selected", ("p2",)), Role.SELECTION, "selector",
    )
    w1 = k.infer(h, bid, c.id, "r1", [w0], B)
    k.qualify_derived(h, s, bid, c.id, "u", w1, actor="x", basis="r1")
    w2 = k.infer(h, bid, c.id, "r2", [w1], B)
    k.qualify_derived(h, s, bid, c.id, "u", w2, actor="x", basis="r2")
    L = k.license(
        h, s, bid, c.id, ["G"], "u",
        LicenseType.EPISTEMIC, share, [w2, sel],
    )

    challenger = add_admitted_root(
        k, h, s, bid, c, "ch", Claim("p0"), Role.CONTENT, "counter",
    )
    bridge = add_admitted_root(
        k, h, s, bid, c, "cb",
        Claim("Challenges", (challenger, w0)),
        Role.BRIDGE, "reviewer",
    )
    impacted = k.challenge(
        h, s, bid, c.id, "u",
        challenger_id=challenger,
        challenge_bridge_id=bridge,
        target_id=w0,
    )
    assert {w0, w1, w2} <= set(impacted)
    assert L.id in s.review_required
    pd = h.bindings[bid].profile_digest
    assert not s.usable(pd, c.id, "u", w2)


def test_transport_witness_is_bound_to_target_claim_and_context():
    cA = base_context("cA")
    cI = base_context("cI")
    p = Profile("k", "1")
    k, h, s, bid = make_env(p, cA)
    k.register_context_candidate(h, cI, source="candidate")

    pA = add_admitted_root(
        k, h, s, bid, cA, "pA", Claim("p"), Role.CONTENT, "sensor",
    )
    target = Claim("q")
    chi = add_admitted_root(
        k, h, s, bid, cA, "chi",
        Claim(
            "Transportable",
            ("A_to_I", pA, cI.id, target.key()),
        ),
        Role.BRIDGE, "bridge-audit",
    )

    with pytest.raises(FormationError):
        k.transport(
            h, bid, cI.id,
            map_id="A_to_I",
            original_id=pA,
            witness_id=chi,
            translated_claim=Claim("p"),
            out_scope=B,
        )


def test_transport_preserves_content_sources_and_adds_bridge_sources_only():
    cA = base_context("cA")
    cI = base_context("cI")
    p = Profile("k", "1")
    k, h, s, bid = make_env(p, cA)
    k.register_context_candidate(h, cI, source="candidate")

    pA = add_admitted_root(
        k, h, s, bid, cA, "pA", Claim("p"), Role.CONTENT, "sensor-A",
    )
    target = Claim("q")
    chi = add_admitted_root(
        k, h, s, bid, cA, "chi",
        Claim(
            "Transportable",
            ("A_to_I", pA, cI.id, target.key()),
        ),
        Role.BRIDGE, "bridge-A",
    )
    pI = k.transport(
        h, bid, cI.id,
        map_id="A_to_I",
        original_id=pA,
        witness_id=chi,
        translated_claim=target,
        out_scope=B,
    )
    w = h.warrants[pI]
    assert w.source_ids_by_role[Role.CONTENT] == frozenset({"sensor-A"})
    assert "bridge-A" in w.source_ids_by_role[Role.BRIDGE]


def test_profile_cannot_define_content_to_authorization_rule():
    c = base_context()
    p = Profile("k", "1")
    p.add_rule(Rule(
        "bad",
        (Role.CONTENT,),
        Role.AUTHORIZATION,
        Claim("Authorized", ("a",)),
    ))
    k, h, s, bid = make_env(p, c)
    x = add_admitted_root(
        k, h, s, bid, c, "x",
        Claim("Evidence", ("p",)), Role.CONTENT, "sensor",
    )
    with pytest.raises(FormationError):
        k.infer(h, bid, c.id, "bad", [x], B)


def test_license_requires_canonical_context_even_for_top():
    c = base_context()
    p = Profile("k", "1")
    move = Move(MoveKind.ACCEPT, ("p",), B)
    p.set_requirement(LicenseType.EPISTEMIC, move, TOP)
    k, h, s, bid = make_env(p, c)

    with pytest.raises(KernelError):
        k.license(
            h, s, bid, "invented", ["i"], "u",
            LicenseType.EPISTEMIC, move, [],
        )


# ============================================================
# Original conceptual toy tests
# ============================================================

def test_suspect_but_not_deeper_reopen():
    c = base_context()
    p = Profile("k", "1")
    suspect = Move(
        MoveKind.SUSPECT, ("O2",), B, RevisionDepth.STRUCTURE
    )
    reopen = Move(
        MoveKind.REOPEN, ("O4",), B, RevisionDepth.DISTINCTION
    )

    weak_depth = Claim(
        "EscalationDepth", (str(int(RevisionDepth.STRUCTURE)),)
    )
    p.set_requirement(
        LicenseType.EPISTEMIC,
        suspect,
        conj(
            atom(Claim("PersistentResidual", ("z",)), Role.CONTENT, B),
            atom(Claim("RepairCoverage", ("z", "O2")), Role.COVERAGE, B),
            atom(weak_depth, Role.ESCALATION, B),
        ),
    )
    p.set_requirement(
        LicenseType.EPISTEMIC,
        reopen,
        conj(
            atom(Claim("PersistentResidual", ("z",)), Role.CONTENT, B),
            atom(Claim("RepairCoverage", ("z", "O2")), Role.COVERAGE, B),
            atom(weak_depth, Role.ESCALATION, B),
        ),
    )

    k, h, s, bid = make_env(p, c)
    z = add_admitted_root(
        k, h, s, bid, c, "z",
        Claim("PersistentResidual", ("z",)), Role.CONTENT, "sensor",
    )
    r = add_admitted_root(
        k, h, s, bid, c, "r",
        Claim("RepairCoverage", ("z", "O2")), Role.COVERAGE, "audit",
    )
    e = add_admitted_root(
        k, h, s, bid, c, "e", weak_depth,
        Role.ESCALATION, "review",
    )

    k.license(
        h, s, bid, c.id, ["i"], "u",
        LicenseType.EPISTEMIC, suspect, [z, r, e],
    )
    with pytest.raises(LicenseError):
        k.license(
            h, s, bid, c.id, ["i"], "u",
            LicenseType.EPISTEMIC, reopen, [z, r, e],
        )


def test_three_votes_one_source_no_share():
    c = base_context()
    p = Profile("k", "1")
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
        Claim("AuditedDistinctSources", ("p",)),
        kernel_guard="distinct_content_sources",
    ))
    share = Move(MoveKind.SHARE, ("p",), B)
    p.set_requirement(
        LicenseType.EPISTEMIC,
        share,
        conj(
            atom(Claim("DescentCandidate", ("p",)), Role.SELECTION, B),
            atom(Claim("AuditedDistinctSources", ("p",)), Role.PROVENANCE, B),
        ),
    )

    k, h, s, bid = make_env(p, c)
    a = add_admitted_root(k, h, s, bid, c, "a", Claim("p"), Role.CONTENT, "DB")
    b = add_admitted_root(k, h, s, bid, c, "b", Claim("p"), Role.CONTENT, "DB")
    d = add_admitted_root(k, h, s, bid, c, "d", Claim("p"), Role.CONTENT, "DB")

    descent = k.infer(h, bid, c.id, "joint", [a, b, d], B)
    k.qualify_derived(h, s, bid, c.id, "u", descent, actor="x", basis="joint")
    with pytest.raises(FormationError):
        k.infer(h, bid, c.id, "distinct", [a, b, d], B)
    with pytest.raises(SatisfactionError):
        k.license(
            h, s, bid, c.id, ["A", "B", "C"], "u",
            LicenseType.EPISTEMIC, share, [descent],
        )


def test_candidate_context_exploration_can_challenge_active_context_without_adoption():
    c0 = base_context("c0")
    c1 = base_context("c1")
    p = Profile("k", "1")
    share = Move(MoveKind.SHARE, ("p",), B)
    p.set_requirement(
        LicenseType.EPISTEMIC,
        share,
        conj(
            atom(Claim("p"), Role.CONTENT, B),
            atom(Claim("Selected", ("p",)), Role.SELECTION, B),
        ),
    )
    k, h, s, bid = make_env(p, c0)
    k.register_context_candidate(h, c1, source="novel-language")

    w = add_admitted_root(
        k, h, s, bid, c0, "w", Claim("p"), Role.CONTENT, "old-source",
    )
    sel = add_admitted_root(
        k, h, s, bid, c0, "sel",
        Claim("Selected", ("p",)), Role.SELECTION, "old-selector",
    )
    L = k.license(
        h, s, bid, c0.id, ["G"], "u",
        LicenseType.EPISTEMIC, share, [w, sel],
    )

    q = add_admitted_root(
        k, h, s, bid, c1, "q", Claim("q"), Role.CONTENT, "new-source",
    )
    beta = add_admitted_root(
        k, h, s, bid, c1, "beta",
        Claim("Challenges", (q, w)), Role.BRIDGE, "new-bridge",
    )
    assert s.context_status(bid, c1.id, "u") == ContextStatus.CANDIDATE

    k.challenge(
        h, s, bid, c1.id, "u",
        challenger_id=q,
        challenge_bridge_id=beta,
        target_id=w,
    )
    assert L.id in s.review_required
    assert not k.check_license_current(h, s, L.id)
    assert L.id in h.licenses


# ============================================================
# Explicit non-goal witness: agents are metadata, not obligation owners
# ============================================================

def test_agents_are_recorded_but_not_used_for_discharge_semantics():
    c = base_context()
    p = Profile("k", "1")
    move = Move(MoveKind.ACCEPT, ("p",), B)
    p.set_requirement(
        LicenseType.EPISTEMIC,
        move,
        atom(Claim("p"), Role.CONTENT, B),
    )
    k, h, s, bid = make_env(p, c)
    w = add_admitted_root(
        k, h, s, bid, c, "w", Claim("p"), Role.CONTENT, "source",
    )
    L = k.license(
        h, s, bid, c.id, ["A", "B"], "u",
        LicenseType.EPISTEMIC, move, [w],
    )
    assert L.agents == ("A", "B")


def test_v011_toy3_explicit_bridges_enable_weaker_shared_determination():
    cA = Context("v11-cA", frozenset({
        "pA", "qA", "Transportable", "EscalationDepth", "Selected"
    }))
    cB = Context("v11-cB", frozenset({"pB", "Transportable"}))
    cI = Context("v11-cI", frozenset({"pI", "JointCandidate"}))

    p = Profile("v11-k", "1")
    p.add_rule(Rule(
        "joint-I",
        (Role.CONTENT, Role.CONTENT),
        Role.SELECTION,
        Claim("JointCandidate", ("pI",)),
    ))
    share = Move(MoveKind.SHARE, ("pI",), B)
    p.set_requirement(
        LicenseType.EPISTEMIC,
        share,
        atom(Claim("JointCandidate", ("pI",)), Role.SELECTION, B),
    )
    adopt = Move(MoveKind.ADOPT, (cI.id,), B, RevisionDepth.DISTINCTION)
    p.set_requirement(
        LicenseType.EPISTEMIC,
        adopt,
        conj(
            atom(
                Claim("EscalationDepth", (str(int(RevisionDepth.DISTINCTION)),)),
                Role.ESCALATION,
                B,
            ),
            atom(Claim("Selected", (cI.id,)), Role.SELECTION, B),
        ),
    )

    k = ProofKernel("K0")
    h = History()
    s = EvaluationState()
    for c in (cA, cB, cI):
        k.register_context_candidate(h, c, source="compat")
    bid = k.bind_profile(h, s, p, B, "u", source="compat-owner")
    k.bootstrap_activate_context(h, s, bid, cA.id, "u", source="initial")

    pA = add_admitted_root(
        k, h, s, bid, cA, "v11-pA", Claim("pA"), Role.CONTENT, "sensor-A"
    )
    qA = add_admitted_root(
        k, h, s, bid, cA, "v11-qA", Claim("qA"), Role.CONTENT, "sensor-Aq"
    )
    pB = k.root(
        h, bid, cB.id,
        RootToken("v11-pB", Claim("pB"), Role.CONTENT, B, "sensor-B"),
    )
    k.admit_root(h, s, bid, cB.id, "u", pB, actor="compat", basis="exploration")

    target = Claim("pI")
    chiA = add_admitted_root(
        k, h, s, bid, cA, "v11-chiA",
        Claim("Transportable", ("A_to_I", pA, cI.id, target.key())),
        Role.BRIDGE, "bridge-A",
    )
    chiB = k.root(
        h, bid, cB.id,
        RootToken(
            "v11-chiB",
            Claim("Transportable", ("B_to_I", pB, cI.id, target.key())),
            Role.BRIDGE, B, "bridge-B",
        ),
    )
    k.admit_root(h, s, bid, cB.id, "u", chiB, actor="compat", basis="exploration")

    pAi = k.transport(
        h, bid, cI.id, map_id="A_to_I", original_id=pA,
        witness_id=chiA, translated_claim=target, out_scope=B,
    )
    pBi = k.transport(
        h, bid, cI.id, map_id="B_to_I", original_id=pB,
        witness_id=chiB, translated_claim=target, out_scope=B,
    )
    k.qualify_derived(h, s, bid, cI.id, "u", pAi, actor="compat", basis="bridge-A")
    k.qualify_derived(h, s, bid, cI.id, "u", pBi, actor="compat", basis="bridge-B")

    esc = add_admitted_root(
        k, h, s, bid, cA, "v11-esc",
        Claim("EscalationDepth", (str(int(RevisionDepth.DISTINCTION)),)),
        Role.ESCALATION, "review-board",
    )
    sel = add_admitted_root(
        k, h, s, bid, cA, "v11-sel",
        Claim("Selected", (cI.id,)), Role.SELECTION, "selection-board",
    )
    L_adopt = k.license(
        h, s, bid, cA.id, ["A", "B"], "u",
        LicenseType.EPISTEMIC, adopt, [esc, sel],
    )
    k.activate_context_with_adopt_license(h, s, L_adopt.id, cI.id)

    joint = k.infer(h, bid, cI.id, "joint-I", [pAi, pBi], B)
    k.qualify_derived(h, s, bid, cI.id, "u", joint, actor="compat", basis="joint")
    L_share = k.license(
        h, s, bid, cI.id, ["A", "B"], "u",
        LicenseType.EPISTEMIC, share, [joint],
    )
    assert k.check_license_current(h, s, L_share.id)

    # qA has no transport witness, so it is not usable in cI and cannot
    # silently enter the common determination.
    pd = h.bindings[bid].profile_digest
    assert not s.usable(pd, cI.id, "u", qA)
    assert all(w.claim != Claim("qI") for w in h.warrants.values())


def test_historical_monotonicity_survives_challenge_and_review():
    c = base_context("hist-c")
    p = Profile("hist-k", "1")
    share = Move(MoveKind.SHARE, ("p",), B)
    p.set_requirement(
        LicenseType.EPISTEMIC,
        share,
        conj(
            atom(Claim("p"), Role.CONTENT, B),
            atom(Claim("Selected", ("p",)), Role.SELECTION, B),
        ),
    )
    k, h, s, bid = make_env(p, c)
    w = add_admitted_root(k, h, s, bid, c, "hist-w", Claim("p"), Role.CONTENT, "source")
    sel = add_admitted_root(k, h, s, bid, c, "hist-sel",
                            Claim("Selected", ("p",)), Role.SELECTION, "selector")
    L = k.license(h, s, bid, c.id, ["G"], "u",
                  LicenseType.EPISTEMIC, share, [w, sel])
    warrants_before = frozenset(h.warrants)
    licenses_before = frozenset(h.licenses)

    challenger = add_admitted_root(k, h, s, bid, c, "hist-ch",
                                   Claim("p"), Role.CONTENT, "counter")
    bridge = add_admitted_root(
        k, h, s, bid, c, "hist-br",
        Claim("Challenges", (challenger, w)), Role.BRIDGE, "reviewer",
    )
    k.challenge(h, s, bid, c.id, "u",
                challenger_id=challenger, challenge_bridge_id=bridge, target_id=w)

    assert warrants_before <= frozenset(h.warrants)
    assert licenses_before <= frozenset(h.licenses)
    assert L.id in h.licenses
    assert not k.check_license_current(h, s, L.id)


# ============================================================
# V0.1.2.1 hardening
# ============================================================

def test_canonical_warrant_lineage_is_deeply_immutable():
    c = base_context()
    p = Profile("k", "1")
    k, h, s, bid = make_env(p, c)
    w = add_admitted_root(
        k, h, s, bid, c, "w", Claim("p"), Role.CONTENT, "S"
    )
    canonical = h.warrants[w]

    with pytest.raises(TypeError):
        canonical.source_ids_by_role[Role.CONTENT] = frozenset({"FORGED"})
    with pytest.raises(TypeError):
        canonical.root_ids_by_role[Role.CONTENT] = frozenset({"FORGED"})


def test_lineage_mutation_cannot_forge_distinct_sources():
    c = base_context()
    p = Profile("k", "1")
    p.add_rule(Rule(
        "distinct",
        (Role.CONTENT, Role.CONTENT, Role.CONTENT),
        Role.PROVENANCE,
        Claim("AuditedDistinctSources", ("p",)),
        kernel_guard="distinct_content_sources",
    ))
    k, h, s, bid = make_env(p, c)
    a = add_admitted_root(k, h, s, bid, c, "a", Claim("p"), Role.CONTENT, "S")
    b = add_admitted_root(k, h, s, bid, c, "b", Claim("p"), Role.CONTENT, "S")
    d = add_admitted_root(k, h, s, bid, c, "d", Claim("p"), Role.CONTENT, "S")

    with pytest.raises(TypeError):
        h.warrants[b].source_ids_by_role[Role.CONTENT] = frozenset({"S2"})

    with pytest.raises(FormationError):
        k.infer(h, bid, c.id, "distinct", [a, b, d], B)


def test_transport_scope_cannot_exceed_bridge_scope():
    wide = Scope.of("shared", "extra")
    narrow = Scope.of("shared")
    cA = base_context("cA")
    cI = base_context("cI")
    p = Profile("k", "1")
    k = ProofKernel("K0")
    h = History()
    s = EvaluationState()
    k.register_context_candidate(h, cA, source="fixture")
    k.register_context_candidate(h, cI, source="candidate")
    bid = k.bind_profile(h, s, p, wide, "u", source="owner")
    k.bootstrap_activate_context(h, s, bid, cA.id, "u", source="init")

    original = k.root(
        h, bid, cA.id,
        RootToken("p", Claim("p"), Role.CONTENT, wide, "sensor"),
    )
    k.admit_root(h, s, bid, cA.id, "u", original, actor="x", basis="input")

    target = Claim("q")
    witness = k.root(
        h, bid, cA.id,
        RootToken(
            "bridge",
            Claim("Transportable", ("A_to_I", original, cI.id, target.key())),
            Role.BRIDGE,
            narrow,
            "bridge-audit",
        ),
    )
    k.admit_root(h, s, bid, cA.id, "u", witness, actor="x", basis="bridge")

    with pytest.raises(FormationError):
        k.transport(
            h, bid, cI.id,
            map_id="A_to_I",
            original_id=original,
            witness_id=witness,
            translated_claim=target,
            out_scope=wide,
        )


def test_narrow_move_requirement_cannot_license_wider_move():
    narrow = Scope.of("shared")
    wide = Scope.of("shared", "extra")
    c = base_context()
    p = Profile("k", "1")

    narrow_share = Move(MoveKind.SHARE, ("p",), narrow)
    p.set_requirement(
        LicenseType.EPISTEMIC,
        narrow_share,
        atom(Claim("Selected", ("p",)), Role.SELECTION, narrow),
    )

    k = ProofKernel("K0")
    h = History()
    s = EvaluationState()
    k.register_context_candidate(h, c, source="fixture")
    bid = k.bind_profile(h, s, p, wide, "u", source="owner")
    k.bootstrap_activate_context(h, s, bid, c.id, "u", source="init")

    sel = k.root(
        h, bid, c.id,
        RootToken("sel", Claim("Selected", ("p",)), Role.SELECTION, wide, "selector"),
    )
    k.admit_root(h, s, bid, c.id, "u", sel, actor="x", basis="selection")

    wider_share = Move(MoveKind.SHARE, ("p",), wide)
    with pytest.raises(LicenseError):
        k.license(
            h, s, bid, c.id, ["G"], "u",
            LicenseType.EPISTEMIC, wider_share, [sel],
        )


def test_revision_of_ancestor_revalidates_descendants_and_licenses():
    c = base_context()
    p = Profile("k", "1")
    p.add_rule(Rule("r1", (Role.CONTENT,), Role.CONTENT, Claim("p1")))
    p.add_rule(Rule("r2", (Role.CONTENT,), Role.CONTENT, Claim("p2")))
    share = Move(MoveKind.SHARE, ("p2",), B)
    p.set_requirement(
        LicenseType.EPISTEMIC,
        share,
        conj(
            atom(Claim("p2"), Role.CONTENT, B),
            atom(Claim("Selected", ("p2",)), Role.SELECTION, B),
        ),
    )
    k, h, s, bid = make_env(p, c)
    w0 = add_admitted_root(k, h, s, bid, c, "w0", Claim("p0"), Role.CONTENT, "S0")
    sel = add_admitted_root(
        k, h, s, bid, c, "sel",
        Claim("Selected", ("p2",)), Role.SELECTION, "selector"
    )
    w1 = k.infer(h, bid, c.id, "r1", [w0], B)
    k.qualify_derived(h, s, bid, c.id, "u", w1, actor="x", basis="r1")
    w2 = k.infer(h, bid, c.id, "r2", [w1], B)
    k.qualify_derived(h, s, bid, c.id, "u", w2, actor="x", basis="r2")
    L = k.license(
        h, s, bid, c.id, ["G"], "u",
        LicenseType.EPISTEMIC, share, [w2, sel],
    )

    k.apply_revision(
        h, s, bid, [w0],
        reach=RevisionReach.USE_LOCAL,
        use="u",
        reason="ancestor revised",
    )
    pd = h.bindings[bid].profile_digest
    assert not s.usable(pd, c.id, "u", w0)
    assert not s.usable(pd, c.id, "u", w1)
    assert not s.usable(pd, c.id, "u", w2)
    assert L.id in s.review_required
    assert not k.check_license_current(h, s, L.id)


def test_distinct_source_guard_requires_multiple_inputs():
    c = base_context()
    p = Profile("k", "1")
    p.add_rule(Rule(
        "distinct-one",
        (Role.CONTENT,),
        Role.PROVENANCE,
        Claim("AuditedDistinctSources", ("p",)),
        kernel_guard="distinct_content_sources",
    ))
    k, h, s, bid = make_env(p, c)
    a = add_admitted_root(k, h, s, bid, c, "a", Claim("p"), Role.CONTENT, "S1")
    with pytest.raises(FormationError):
        k.infer(h, bid, c.id, "distinct-one", [a], B)


def test_distinct_root_guard_requires_multiple_inputs():
    c = base_context()
    p = Profile("k", "1")
    p.add_rule(Rule(
        "distinct-one",
        (Role.CONTENT,),
        Role.PROVENANCE,
        Claim("AuditedDistinctRoots", ("p",)),
        kernel_guard="distinct_content_roots",
    ))
    k, h, s, bid = make_env(p, c)
    a = add_admitted_root(k, h, s, bid, c, "a", Claim("p"), Role.CONTENT, "S1")
    with pytest.raises(FormationError):
        k.infer(h, bid, c.id, "distinct-one", [a], B)


def test_transport_cannot_amplify_revision_depth():
    cA = base_context("cA")
    cI = base_context("cI")
    p = Profile("k", "1")
    k, h, s, bid = make_env(p, cA)
    k.register_context_candidate(h, cI, source="candidate")

    local = Claim("EscalationDepth", (str(int(RevisionDepth.LOCAL)),))
    architecture = Claim("EscalationDepth", (str(int(RevisionDepth.ARCHITECTURE)),))

    original = add_admitted_root(
        k, h, s, bid, cA, "esc", local, Role.ESCALATION, "review"
    )
    witness = add_admitted_root(
        k, h, s, bid, cA, "bridge",
        Claim(
            "Transportable",
            ("A_to_I", original, cI.id, architecture.key()),
        ),
        Role.BRIDGE,
        "bridge-audit",
    )

    with pytest.raises(FormationError):
        k.transport(
            h, bid, cI.id,
            map_id="A_to_I",
            original_id=original,
            witness_id=witness,
            translated_claim=architecture,
            out_scope=B,
        )


def test_adopt_support_review_pends_target_context_and_blocks_new_licenses():
    c0 = base_context("c0")
    c1 = base_context("c1")
    p = Profile("k", "1")

    adopt = Move(
        MoveKind.ADOPT,
        (c1.id,),
        B,
        RevisionDepth.DISTINCTION,
    )
    p.set_requirement(
        LicenseType.EPISTEMIC,
        adopt,
        conj(
            atom(
                Claim("EscalationDepth", (str(int(RevisionDepth.DISTINCTION)),)),
                Role.ESCALATION,
                B,
            ),
            atom(Claim("Selected", (c1.id,)), Role.SELECTION, B),
        ),
    )
    accept = Move(MoveKind.ACCEPT, ("q",), B)
    p.set_requirement(
        LicenseType.EPISTEMIC,
        accept,
        atom(Claim("q"), Role.CONTENT, B),
    )

    k, h, s, bid = make_env(p, c0)
    k.register_context_candidate(h, c1, source="candidate")

    esc = add_admitted_root(
        k, h, s, bid, c0, "esc",
        Claim("EscalationDepth", (str(int(RevisionDepth.DISTINCTION)),)),
        Role.ESCALATION,
        "review-board",
    )
    sel = add_admitted_root(
        k, h, s, bid, c0, "sel",
        Claim("Selected", (c1.id,)), Role.SELECTION, "selector",
    )
    L_adopt = k.license(
        h, s, bid, c0.id, ["i"], "u",
        LicenseType.EPISTEMIC, adopt, [esc, sel],
    )
    k.activate_context_with_adopt_license(h, s, L_adopt.id, c1.id)
    assert s.context_status(bid, c1.id, "u") == ContextStatus.ACTIVE

    q = add_admitted_root(
        k, h, s, bid, c1, "q", Claim("q"), Role.CONTENT, "new-sensor"
    )
    k.license(
        h, s, bid, c1.id, ["i"], "u",
        LicenseType.EPISTEMIC, accept, [q],
    )

    # Revising adoption support marks the Adopt license for review,
    # which in turn pends the context activated by that license.
    k.apply_revision(
        h, s, bid, [esc],
        reach=RevisionReach.USE_LOCAL,
        use="u",
        reason="adoption basis revised",
    )
    assert L_adopt.id in s.review_required
    assert s.context_status(bid, c1.id, "u") == ContextStatus.PENDING

    with pytest.raises(LicenseError):
        k.license(
            h, s, bid, c1.id, ["i"], "u",
            LicenseType.EPISTEMIC, accept, [q],
        )


def test_non_revision_move_cannot_carry_revision_depth():
    with pytest.raises(ValueError):
        Move(
            MoveKind.ACCEPT,
            ("p",),
            B,
            RevisionDepth.ARCHITECTURE,
        )
