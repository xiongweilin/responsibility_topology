import pytest

from v0122_kernel import (
    ContextStatus,
    Profile,
    RevisionReach,
)
from test_v0122_kernel import B, base_context, make_env
from test_v0122_currentness import (
    install_adopt_requirement,
    issue_adopt_license,
)
from v0122_currentness_conformance import (
    ContextKey,
    build_grounded_certificate,
    capture_context_refresh_snapshot,
    capture_pre_refresh_boundary,
    certify_python_currentness,
    check_license_base_current,
    issuer_context_is_active,
    license_current_factorization_holds,
    run_currentness_lean_fixture,
)


def _build_chain(length: int):
    contexts = [base_context(f"c{i}") for i in range(length + 1)]
    profile = Profile("currentness", "1")
    moves = {
        context.id: install_adopt_requirement(profile, context.id)
        for context in contexts[1:]
    }

    kernel, history, state, binding_id = make_env(profile, contexts[0])
    for context in contexts[1:]:
        kernel.register_context_candidate(
            history, context, source=f"candidate-{context.id}"
        )

    licenses = []
    for index in range(1, len(contexts)):
        issuer = contexts[index - 1]
        target = contexts[index]
        license_record = issue_adopt_license(
            kernel,
            history,
            state,
            binding_id,
            issuer,
            target.id,
            moves[target.id],
            label=f"{issuer.id}-{target.id}",
        )
        kernel.activate_context_with_adopt_license(
            history, state, license_record.id, target.id
        )
        licenses.append(license_record)

    return kernel, history, state, binding_id, contexts, licenses, profile


def _key(binding_id, context, use="u"):
    return ContextKey(binding_id, context.id, use)


def _assert_reference_factorization(kernel, history, state):
    for license_id in history.licenses:
        assert license_current_factorization_holds(
            kernel, history, state, license_id
        )
        assert kernel.check_license_current(history, state, license_id) == (
            check_license_base_current(kernel, history, state, license_id)
            and issuer_context_is_active(history, state, license_id)
        )


def _close_and_check(kernel, history, state, before):
    snapshot = capture_context_refresh_snapshot(
        kernel, history, state, before
    )
    _assert_reference_factorization(kernel, history, state)
    certified = certify_python_currentness(snapshot)
    assert len(certified) == len(snapshot.context_keys)
    run_currentness_lean_fixture(snapshot)
    return snapshot


def _invalidate_license_support(
    kernel,
    history,
    state,
    binding_id,
    license_record,
    *,
    reason,
):
    target_warrant = sorted(license_record.used_warrants)[0]
    kernel.apply_revision(
        history,
        state,
        binding_id,
        [target_warrant],
        reach=RevisionReach.USE_LOCAL,
        use="u",
        reason=reason,
    )


def test_bootstrap_stays_grounded():
    c0 = base_context("c0")
    profile = Profile("currentness", "1")
    kernel, history, state, binding_id = make_env(profile, c0)

    before = capture_pre_refresh_boundary(state)
    kernel._refresh_context_currentness_fixed_point(history, state)
    snapshot = _close_and_check(kernel, history, state, before)

    assert snapshot.seed_active_before[_key(binding_id, c0)]
    assert snapshot.python_active_after[_key(binding_id, c0)]


def test_single_adopt_is_grounded():
    kernel, history, state, binding_id, contexts, _, _ = _build_chain(1)

    before = capture_pre_refresh_boundary(state)
    kernel._refresh_context_currentness_fixed_point(history, state)
    snapshot = _close_and_check(kernel, history, state, before)

    assert snapshot.python_active_after[_key(binding_id, contexts[0])]
    assert snapshot.python_active_after[_key(binding_id, contexts[1])]


def test_multi_hop_adopt_chain_is_grounded():
    kernel, history, state, binding_id, contexts, _, _ = _build_chain(3)

    before = capture_pre_refresh_boundary(state)
    kernel._refresh_context_currentness_fixed_point(history, state)
    snapshot = _close_and_check(kernel, history, state, before)

    assert all(snapshot.python_active_after[_key(binding_id, c)] for c in contexts)


def test_upstream_base_invalidation_cascades():
    kernel, history, state, binding_id, contexts, licenses, _ = _build_chain(3)
    before = capture_pre_refresh_boundary(state)

    _invalidate_license_support(
        kernel,
        history,
        state,
        binding_id,
        licenses[0],
        reason="invalidate-L1",
    )
    snapshot = _close_and_check(kernel, history, state, before)

    assert snapshot.base_current_after[licenses[0].id] is False
    assert snapshot.python_active_after[_key(binding_id, contexts[0])]
    assert all(
        not snapshot.python_active_after[_key(binding_id, c)]
        for c in contexts[1:]
    )


def test_middle_invalidation_preserves_upstream_and_removes_suffix():
    kernel, history, state, binding_id, contexts, licenses, _ = _build_chain(3)
    before = capture_pre_refresh_boundary(state)

    _invalidate_license_support(
        kernel,
        history,
        state,
        binding_id,
        licenses[1],
        reason="invalidate-L2",
    )
    snapshot = _close_and_check(kernel, history, state, before)

    assert snapshot.base_current_after[licenses[1].id] is False
    assert snapshot.python_active_after[_key(binding_id, contexts[0])]
    assert snapshot.python_active_after[_key(binding_id, contexts[1])]
    assert not snapshot.python_active_after[_key(binding_id, contexts[2])]
    assert not snapshot.python_active_after[_key(binding_id, contexts[3])]


def test_sibling_branch_invalidation_is_local():
    c0 = base_context("c0")
    c1 = base_context("c1")
    c2 = base_context("c2")
    c3 = base_context("c3")
    c4 = base_context("c4")
    profile = Profile("currentness", "1")
    moves = {
        c.id: install_adopt_requirement(profile, c.id)
        for c in (c1, c2, c3, c4)
    }
    kernel, history, state, binding_id = make_env(profile, c0)
    for c in (c1, c2, c3, c4):
        kernel.register_context_candidate(history, c, source=f"candidate-{c.id}")

    L1 = issue_adopt_license(
        kernel, history, state, binding_id, c0, c1.id, moves[c1.id], label="left-1"
    )
    kernel.activate_context_with_adopt_license(history, state, L1.id, c1.id)
    L2 = issue_adopt_license(
        kernel, history, state, binding_id, c0, c2.id, moves[c2.id], label="right-1"
    )
    kernel.activate_context_with_adopt_license(history, state, L2.id, c2.id)
    L3 = issue_adopt_license(
        kernel, history, state, binding_id, c1, c3.id, moves[c3.id], label="left-2"
    )
    kernel.activate_context_with_adopt_license(history, state, L3.id, c3.id)
    L4 = issue_adopt_license(
        kernel, history, state, binding_id, c2, c4.id, moves[c4.id], label="right-2"
    )
    kernel.activate_context_with_adopt_license(history, state, L4.id, c4.id)

    before = capture_pre_refresh_boundary(state)
    _invalidate_license_support(
        kernel, history, state, binding_id, L1, reason="invalidate-left"
    )
    snapshot = _close_and_check(kernel, history, state, before)

    assert snapshot.python_active_after[_key(binding_id, c0)]
    assert not snapshot.python_active_after[_key(binding_id, c1)]
    assert snapshot.python_active_after[_key(binding_id, c2)]
    assert not snapshot.python_active_after[_key(binding_id, c3)]
    assert snapshot.python_active_after[_key(binding_id, c4)]


def test_binding_use_context_key_separation():
    kernel, history, state, binding_id, contexts, _, profile = _build_chain(1)
    c0 = contexts[0]

    binding_v = kernel.bind_profile(
        history,
        state,
        profile,
        B,
        "v",
        source="second-use-owner",
    )
    kernel.bootstrap_activate_context(
        history,
        state,
        binding_v,
        c0.id,
        "v",
        source="second-use-boundary",
    )

    before = capture_pre_refresh_boundary(state)
    kernel._refresh_context_currentness_fixed_point(history, state)
    snapshot = _close_and_check(kernel, history, state, before)

    assert snapshot.python_active_after[_key(binding_id, c0, "u")]
    assert snapshot.python_active_after[_key(binding_v, c0, "v")]
    assert _key(binding_id, c0, "u") != _key(binding_v, c0, "v")


def test_pending_context_can_be_reactivated_from_grounded_issuer():
    kernel, history, state, binding_id, contexts, licenses, profile = _build_chain(1)
    c0, c1 = contexts

    _invalidate_license_support(
        kernel,
        history,
        state,
        binding_id,
        licenses[0],
        reason="pend-c1",
    )
    assert state.context_status(binding_id, c1.id, "u") == ContextStatus.PENDING

    move = install_adopt_requirement(profile, c1.id)
    # The binding holds the already-frozen requirement; `move` is structurally
    # identical to that exact requirement key.
    replacement = issue_adopt_license(
        kernel,
        history,
        state,
        binding_id,
        c0,
        c1.id,
        move,
        label="reactivate-c1",
    )
    kernel.activate_context_with_adopt_license(
        history, state, replacement.id, c1.id
    )
    assert state.context_status(binding_id, c1.id, "u") == ContextStatus.ACTIVE

    # Reactivation is state construction, not part of the measured refresh.
    # Start a fresh PR #9 boundary only after the topology change has completed.
    before = capture_pre_refresh_boundary(state)
    kernel._refresh_context_currentness_fixed_point(history, state)
    snapshot = _close_and_check(kernel, history, state, before)

    assert snapshot.python_active_after[_key(binding_id, c0)]
    assert snapshot.python_active_after[_key(binding_id, c1)]


def test_conformance_rejects_python_retained_too_much():
    kernel, history, state, binding_id, contexts, licenses, _ = _build_chain(1)
    c1 = contexts[1]
    before = capture_pre_refresh_boundary(state)

    _invalidate_license_support(
        kernel,
        history,
        state,
        binding_id,
        licenses[0],
        reason="invalidate-before-corruption",
    )
    # Adversarially corrupt only the observed post-state to model an
    # implementation that retained an ungrounded context.
    raw = (binding_id, c1.id, "u")
    state._pending_contexts.discard(raw)
    state._active_contexts.add(raw)

    snapshot = capture_context_refresh_snapshot(kernel, history, state, before)
    with pytest.raises(
        Exception,
        match="activation license is not BaseCurrent",
    ):
        build_grounded_certificate(snapshot, _key(binding_id, c1))


def test_conformance_rejects_python_removed_too_much():
    c0 = base_context("c0")
    profile = Profile("currentness", "1")
    kernel, history, state, binding_id = make_env(profile, c0)
    before = capture_pre_refresh_boundary(state)

    # Model an implementation that incorrectly removed a bootstrap context.
    raw = (binding_id, c0.id, "u")
    state._active_contexts.discard(raw)
    state._pending_contexts.add(raw)

    snapshot = capture_context_refresh_snapshot(kernel, history, state, before)
    with pytest.raises(
        Exception,
        match="pre-refresh active bootstrap context is Grounded",
    ):
        certify_python_currentness(snapshot)
