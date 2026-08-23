from __future__ import annotations

import shutil

import pytest

from v0122_conformance import (
    capture_licensing_read,
    python_satisfy_option,
    run_cross_language_fixture,
)
from v0122_kernel import (
    Claim,
    Context,
    EvaluationState,
    History,
    KernelError,
    LicenseError,
    LicenseType,
    Move,
    MoveKind,
    Profile,
    ProofKernel,
    RevisionDepth,
    Role,
    RootToken,
    Scope,
    atom,
    conj,
)


B = Scope.of("shared")
WIDE = Scope.of("shared", "extra")


def make_env(
    profile: Profile,
    *,
    binding_scope: Scope = B,
    use: str = "u",
    active_context: bool = True,
):
    kernel = ProofKernel("K0")
    history = History()
    state = EvaluationState()
    context = Context("c0", frozenset({"*"}))
    kernel.register_context_candidate(history, context, source="conformance")
    binding_id = kernel.bind_profile(
        history,
        state,
        profile,
        binding_scope,
        use,
        source="conformance",
    )
    if active_context:
        kernel.bootstrap_activate_context(
            history,
            state,
            binding_id,
            context.id,
            use,
            source="conformance",
        )
    return kernel, history, state, binding_id, context


def add_root(
    kernel: ProofKernel,
    history: History,
    state: EvaluationState,
    binding_id: str,
    context: Context,
    *,
    token_id: str,
    claim: Claim,
    role: Role,
    scope: Scope = B,
    use: str = "u",
):
    warrant_id = kernel.root(
        history,
        binding_id,
        context.id,
        RootToken(token_id, claim, role, scope, f"src:{token_id}"),
    )
    kernel.admit_root(
        history,
        state,
        binding_id,
        context.id,
        use,
        warrant_id,
        actor="conformance",
        basis="fixture",
    )
    return warrant_id


def require_lean() -> None:
    if shutil.which("lake") is None:
        pytest.skip("Lean/Lake is required for cross-language conformance fixtures")


def assert_cross_language(result) -> None:
    assert result.lean.ambient == result.python_ambient
    assert result.lean.satisfy_matches is True
    assert result.lean.floor == result.python_floor


def test_share_fixture_and_duplicate_candidate_occurrences():
    require_lean()
    move = Move(MoveKind.SHARE, (), B)
    evidence = Claim("Evidence", ("doc",))
    selected = Claim("Selected", ("doc",))
    profile = Profile("p", "1")
    profile.set_requirement(
        LicenseType.EPISTEMIC,
        move,
        conj(
            atom(evidence, Role.CONTENT, B),
            atom(selected, Role.SELECTION, B),
        ),
    )
    kernel, history, state, binding_id, context = make_env(profile)
    w_content = add_root(
        kernel,
        history,
        state,
        binding_id,
        context,
        token_id="content",
        claim=evidence,
        role=Role.CONTENT,
    )
    w_selection = add_root(
        kernel,
        history,
        state,
        binding_id,
        context,
        token_id="selection",
        claim=selected,
        role=Role.SELECTION,
    )

    candidates = [w_content, w_content, w_selection]
    result = run_cross_language_fixture(
        kernel,
        history,
        state,
        binding_id,
        context.id,
        "u",
        LicenseType.EPISTEMIC,
        move,
        candidates,
    )
    assert_cross_language(result)
    assert result.python_ambient is True
    assert result.python_branch is not None
    assert result.python_branch.kind == "and"
    encoded = result.read.id_encoding.encode_sequence(candidates)
    assert encoded[0] == encoded[1]
    assert len(encoded) == len(candidates)


def test_unsatisfied_atom_maps_only_satisfaction_error_to_lean_none():
    require_lean()
    move = Move(MoveKind.ACCEPT, (), B)
    required = Claim("Evidence", ("required",))
    profile = Profile("p", "1")
    profile.set_requirement(
        LicenseType.EPISTEMIC,
        move,
        atom(required, Role.CONTENT, B),
    )
    kernel, history, state, binding_id, context = make_env(profile)
    wrong = add_root(
        kernel,
        history,
        state,
        binding_id,
        context,
        token_id="wrong",
        claim=Claim("Evidence", ("wrong",)),
        role=Role.CONTENT,
    )

    result = run_cross_language_fixture(
        kernel,
        history,
        state,
        binding_id,
        context.id,
        "u",
        LicenseType.EPISTEMIC,
        move,
        [wrong],
    )
    assert result.python_ambient is True
    assert result.lean.ambient is True
    assert result.python_branch is None
    assert result.lean.satisfy_matches is True
    assert result.python_floor is None
    assert result.lean.floor is None


def test_floor_scope_failure_matches_safe_from_view():
    require_lean()
    move = Move(MoveKind.ACCEPT, (), WIDE)
    evidence = Claim("Evidence", ("doc",))
    profile = Profile("p", "1")
    profile.set_requirement(
        LicenseType.EPISTEMIC,
        move,
        atom(evidence, Role.CONTENT, B),
    )
    kernel, history, state, binding_id, context = make_env(
        profile,
        binding_scope=WIDE,
    )
    narrow = add_root(
        kernel,
        history,
        state,
        binding_id,
        context,
        token_id="narrow",
        claim=evidence,
        role=Role.CONTENT,
        scope=B,
    )

    result = run_cross_language_fixture(
        kernel,
        history,
        state,
        binding_id,
        context.id,
        "u",
        LicenseType.EPISTEMIC,
        move,
        [narrow],
    )
    assert_cross_language(result)
    assert result.python_ambient is True
    assert result.python_branch is not None
    assert result.python_floor is False


def test_action_authorization_floor_matches():
    require_lean()
    move = Move(MoveKind.ACCEPT, (), B)
    evidence = Claim("Evidence", ("doc",))
    profile = Profile("p", "1")
    profile.set_requirement(
        LicenseType.ACTION,
        move,
        atom(evidence, Role.CONTENT, B),
    )
    kernel, history, state, binding_id, context = make_env(profile)
    content = add_root(
        kernel,
        history,
        state,
        binding_id,
        context,
        token_id="content",
        claim=evidence,
        role=Role.CONTENT,
    )

    result = run_cross_language_fixture(
        kernel,
        history,
        state,
        binding_id,
        context.id,
        "u",
        LicenseType.ACTION,
        move,
        [content],
    )
    assert_cross_language(result)
    assert result.python_floor is False


def test_revision_depth_floor_uses_python_parser_projection():
    require_lean()
    move = Move(
        MoveKind.REOPEN,
        (),
        B,
        revision_depth=RevisionDepth.STRUCTURE,
    )
    escalation = Claim("EscalationDepth", ("3",))
    profile = Profile("p", "1")
    profile.set_requirement(
        LicenseType.EPISTEMIC,
        move,
        atom(escalation, Role.ESCALATION, B),
    )
    kernel, history, state, binding_id, context = make_env(profile)
    warrant_id = add_root(
        kernel,
        history,
        state,
        binding_id,
        context,
        token_id="escalation",
        claim=escalation,
        role=Role.ESCALATION,
    )

    result = run_cross_language_fixture(
        kernel,
        history,
        state,
        binding_id,
        context.id,
        "u",
        LicenseType.EPISTEMIC,
        move,
        [warrant_id],
    )
    assert_cross_language(result)
    assert result.read.escalation_depths[escalation] == 3
    assert result.python_floor is True


def test_unknown_candidate_id_is_fail_fast_not_ordinary_unsatisfaction():
    move = Move(MoveKind.ACCEPT, (), B)
    evidence = Claim("Evidence", ("doc",))
    profile = Profile("p", "1")
    profile.set_requirement(
        LicenseType.EPISTEMIC,
        move,
        atom(evidence, Role.CONTENT, B),
    )
    kernel, history, state, binding_id, context = make_env(profile)
    valid = add_root(
        kernel,
        history,
        state,
        binding_id,
        context,
        token_id="valid",
        claim=evidence,
        role=Role.CONTENT,
    )
    read = capture_licensing_read(
        kernel,
        history,
        state,
        binding_id,
        context.id,
        "u",
        LicenseType.EPISTEMIC,
        move,
    )

    with pytest.raises(KernelError, match="Unknown canonical warrant id"):
        python_satisfy_option(
            kernel,
            history,
            state,
            binding_id,
            context.id,
            "u",
            read.requirement,
            ["missing", valid],
        )

    with pytest.raises(KernelError, match="outside the canonical conformance encoding"):
        read.id_encoding.encode_sequence(["missing", valid])


def test_exact_requirement_lookup_remains_adapter_boundary():
    accept_narrow = Move(MoveKind.ACCEPT, (), B)
    accept_wide = Move(MoveKind.ACCEPT, (), WIDE)
    narrow_claim = Claim("Evidence", ("narrow",))
    wide_claim = Claim("Evidence", ("wide",))
    profile = Profile("p", "1")
    profile.set_requirement(
        LicenseType.EPISTEMIC,
        accept_narrow,
        atom(narrow_claim, Role.CONTENT, B),
    )
    profile.set_requirement(
        LicenseType.EPISTEMIC,
        accept_wide,
        atom(wide_claim, Role.CONTENT, WIDE),
    )
    kernel, history, state, binding_id, context = make_env(
        profile,
        binding_scope=WIDE,
    )

    narrow = capture_licensing_read(
        kernel,
        history,
        state,
        binding_id,
        context.id,
        "u",
        LicenseType.EPISTEMIC,
        accept_narrow,
    )
    wide = capture_licensing_read(
        kernel,
        history,
        state,
        binding_id,
        context.id,
        "u",
        LicenseType.EPISTEMIC,
        accept_wide,
    )

    assert narrow.requirement == profile.freeze().requirement_for(
        LicenseType.EPISTEMIC, accept_narrow
    )
    assert wide.requirement == profile.freeze().requirement_for(
        LicenseType.EPISTEMIC, accept_wide
    )
    assert narrow.requirement != wide.requirement


@pytest.mark.parametrize(
    "case, expected_message",
    [
        ("use", "Binding/use mismatch"),
        ("context", "Operational licensing requires an active context"),
        ("binding", "Profile binding is not active"),
        ("scope", "Move exceeds canonical binding scope"),
    ],
)
def test_python_license_ambient_negative_paths_match_projection(case, expected_message):
    require_lean()
    move = Move(MoveKind.ACCEPT, (), WIDE if case == "scope" else B)
    profile = Profile("p", "1")
    profile.set_requirement(LicenseType.EPISTEMIC, move, atom(Claim("Evidence"), Role.CONTENT, B))

    kernel, history, state, binding_id, context = make_env(
        profile,
        binding_scope=B,
        active_context=(case != "context"),
    )
    content = add_root(
        kernel,
        history,
        state,
        binding_id,
        context,
        token_id="content",
        claim=Claim("Evidence"),
        role=Role.CONTENT,
    )

    invocation_use = "wrong-use" if case == "use" else "u"
    invocation_state = EvaluationState() if case == "binding" else state

    result = run_cross_language_fixture(
        kernel,
        history,
        invocation_state,
        binding_id,
        context.id,
        invocation_use,
        LicenseType.EPISTEMIC,
        move,
        [content],
    )
    assert result.python_ambient is False
    assert result.lean.ambient is False
    assert result.lean.satisfy_matches is True

    with pytest.raises(LicenseError, match=expected_message):
        kernel.license(
            history,
            invocation_state,
            binding_id,
            context.id,
            ("agent",),
            invocation_use,
            LicenseType.EPISTEMIC,
            move,
            [content],
        )
