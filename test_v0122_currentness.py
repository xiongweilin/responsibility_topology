import pytest

from v0122_kernel import (
    Claim,
    ContextStatus,
    KernelError,
    LicenseType,
    Move,
    MoveKind,
    Profile,
    RevisionDepth,
    Role,
    atom,
    conj,
)
from test_v0122_kernel import B, add_admitted_root, base_context, make_env


def adopt_move(target_context_id: str) -> Move:
    return Move(
        MoveKind.ADOPT,
        (target_context_id,),
        B,
        RevisionDepth.DISTINCTION,
    )


def install_adopt_requirement(profile: Profile, target_context_id: str) -> Move:
    move = adopt_move(target_context_id)
    profile.set_requirement(
        LicenseType.EPISTEMIC,
        move,
        conj(
            atom(
                Claim(
                    "EscalationDepth",
                    (str(int(RevisionDepth.DISTINCTION)),),
                ),
                Role.ESCALATION,
                B,
            ),
            atom(
                Claim("Selected", (target_context_id,)),
                Role.SELECTION,
                B,
            ),
        ),
    )
    return move


def issue_adopt_license(
    kernel,
    history,
    state,
    binding_id,
    issuer_context,
    target_context_id,
    move,
    *,
    label,
):
    escalation = add_admitted_root(
        kernel,
        history,
        state,
        binding_id,
        issuer_context,
        f"esc-{label}",
        Claim(
            "EscalationDepth",
            (str(int(RevisionDepth.DISTINCTION)),),
        ),
        Role.ESCALATION,
        f"review-{label}",
    )
    selection = add_admitted_root(
        kernel,
        history,
        state,
        binding_id,
        issuer_context,
        f"sel-{label}",
        Claim("Selected", (target_context_id,)),
        Role.SELECTION,
        f"selector-{label}",
    )
    return kernel.license(
        history,
        state,
        binding_id,
        issuer_context.id,
        ["i"],
        "u",
        LicenseType.EPISTEMIC,
        move,
        [escalation, selection],
    )


def test_adopt_cannot_replace_bootstrap_activation_provenance():
    c0 = base_context("c0")
    profile = Profile("k", "1")
    adopt_c0 = install_adopt_requirement(profile, c0.id)
    kernel, history, state, binding_id = make_env(profile, c0)

    bootstrap_key = (binding_id, c0.id, "u")
    assert state.context_status(binding_id, c0.id, "u") == ContextStatus.ACTIVE
    assert state.context_activation_license[bootstrap_key] is None

    replacement = issue_adopt_license(
        kernel,
        history,
        state,
        binding_id,
        c0,
        c0.id,
        adopt_c0,
        label="bootstrap-replacement",
    )

    with pytest.raises(
        KernelError,
        match="active context activation provenance is immutable",
    ):
        kernel.activate_context_with_adopt_license(
            history,
            state,
            replacement.id,
            c0.id,
        )

    assert state.context_status(binding_id, c0.id, "u") == ContextStatus.ACTIVE
    assert state.context_activation_license[bootstrap_key] is None


def test_cyclic_adopt_activation_dependency_cannot_become_self_supporting():
    c0 = base_context("c0")
    c1 = base_context("c1")
    c2 = base_context("c2")
    profile = Profile("k", "1")
    adopt_c1 = install_adopt_requirement(profile, c1.id)
    adopt_c2 = install_adopt_requirement(profile, c2.id)

    kernel, history, state, binding_id = make_env(profile, c0)
    kernel.register_context_candidate(history, c1, source="candidate-1")
    kernel.register_context_candidate(history, c2, source="candidate-2")

    # Grounded chain: bootstrap c0 -> L1 -> c1 -> L2 -> c2.
    L1 = issue_adopt_license(
        kernel,
        history,
        state,
        binding_id,
        c0,
        c1.id,
        adopt_c1,
        label="c0-c1",
    )
    kernel.activate_context_with_adopt_license(history, state, L1.id, c1.id)

    L2 = issue_adopt_license(
        kernel,
        history,
        state,
        binding_id,
        c1,
        c2.id,
        adopt_c2,
        label="c1-c2",
    )
    kernel.activate_context_with_adopt_license(history, state, L2.id, c2.id)

    # A current license issued in c2 may target c1, but consuming it as a new
    # activation would replace c1's existing provenance and create c1 <-> c2.
    cycle = issue_adopt_license(
        kernel,
        history,
        state,
        binding_id,
        c2,
        c1.id,
        adopt_c1,
        label="c2-c1-cycle",
    )

    with pytest.raises(
        KernelError,
        match="active context activation provenance is immutable",
    ):
        kernel.activate_context_with_adopt_license(
            history,
            state,
            cycle.id,
            c1.id,
        )

    c1_key = (binding_id, c1.id, "u")
    c2_key = (binding_id, c2.id, "u")
    assert state.context_activation_license[c1_key] == L1.id
    assert state.context_activation_license[c2_key] == L2.id
    assert state.context_status(binding_id, c1.id, "u") == ContextStatus.ACTIVE
    assert state.context_status(binding_id, c2.id, "u") == ContextStatus.ACTIVE
