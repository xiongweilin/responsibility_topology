import ResponsibilityTopology.ChallengeInvalidation
import ResponsibilityTopology.Bridge.CertifiedObservation

namespace ResponsibilityTopology.Bridge

/-!
Formal-side witness for the same restricted observation pattern checked by
`CertifiedObservation`.

This theorem does not identify Python assertion status with Lean `Usable`.  It
shows only that the existing challenge semantics contains a concrete instance of
the abstract pattern: the exact historical target referent remains present while
a previously usable target evaluation becomes unusable.
-/

structure FormalQualificationWithdrawalWitness
    (A A' : AdoptState)
    (targetId : WarrantId)
    (key : EvalKey) : Prop where
  sameHistoricalReferent :
    ∃ warrant,
      A.core.warrant targetId = some warrant ∧
      A'.core.warrant targetId = some warrant
  qualifiedBefore : Usable A.core key
  withdrawnAfter : ¬ Usable A'.core key

/-- One challenge step realizes the B0 withdrawal pattern at the exact challenged
target, provided that target was usable at the selected matching profile/use
coordinate before the challenge. -/
theorem challenge_target_realizes_formal_withdrawal_pattern
    {A A' : AdoptState}
    {bindingId contextId use : String}
    {challengerId bridgeId targetId : WarrantId}
    {binding : CanonicalBinding}
    {key : EvalKey}
    {target : HistoricalWarrant}
    (hStep : ChallengeStep A
      (.challenge bindingId contextId use challengerId bridgeId targetId) A')
    (hBinding : A.core.binding bindingId = some binding)
    (hProfile : key.profileDigest = binding.profileDigest)
    (hUse : key.use = use)
    (hTarget : key.warrantId = targetId)
    (hTargetCanonical : A.core.warrant targetId = some target)
    (hUsable : Usable A.core key) :
    FormalQualificationWithdrawalWitness A A' targetId key := by
  have hImmutable := challengeStep_historyReferentsImmutable hStep
  have hPostTarget : A'.core.warrant targetId = some target :=
    hImmutable.warrantImmutable hTargetCanonical
  have hSuspended : A'.core.epi key = some .suspended :=
    challengeStep_target_live_suspended
      hStep hBinding hProfile hUse hTarget hUsable.1
  have hNotUsable : ¬ Usable A'.core key := by
    intro hPostUsable
    have hImpossible : EpiStatus.suspended = EpiStatus.live :=
      Option.some.inj (hSuspended.symm.trans hPostUsable.1)
    cases hImpossible
  exact {
    sameHistoricalReferent := ⟨target, hTargetCanonical, hPostTarget⟩
    qualifiedBefore := hUsable
    withdrawnAfter := hNotUsable
  }

end ResponsibilityTopology.Bridge
