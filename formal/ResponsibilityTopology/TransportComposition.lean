import ResponsibilityTopology.TransportFormation
import ResponsibilityTopology.TransportConservation

namespace ResponsibilityTopology

/-!
Reachable two-hop TRANSPORT formation conservation.

This milestone lifts the pure T4a conservation laws to two adjacent historical
TRANSPORT formation steps.  It adds no qualification propagation, path datatype,
activation/adoption premise, cross-profile transport, or temporal closure.
-/

/-- T4b: two adjacent reachable TRANSPORT formations compose through the exact
historical child identity produced by the first step.  The proof recovers both
historical objects through `transportStep_newWarrant_exact` and then delegates
scope, strength, and lineage conservation to the pure T4a laws. -/
theorem twoHopTransportFormationBoundary
    {S₀ S₁ S₂ : CanonicalState}
    {originalId witness₁Id child₁ witness₂Id child₂ : WarrantId}
    {binding₁Id context₁ map₁ binding₂Id context₂ map₂ : String}
    {translated₁ translated₂ : Claim}
    {scope₁ scope₂ : Scope}
    (hReachable : Reachable S₀)
    (hFirst :
      Step S₀
        (.transport child₁ binding₁Id context₁ map₁ originalId witness₁Id
          translated₁ scope₁)
        S₁)
    (hSecond :
      Step S₁
        (.transport child₂ binding₂Id context₂ map₂ child₁ witness₂Id
          translated₂ scope₂)
        S₂) :
    Reachable S₁ ∧
      Reachable S₂ ∧
      ∃ binding₁ binding₂ original witness₁ witness₂ W₁ W₂,
        S₀.binding binding₁Id = some binding₁ ∧
        S₁.binding binding₂Id = some binding₂ ∧
        S₀.warrant originalId = some original ∧
        S₀.warrant witness₁Id = some witness₁ ∧
        S₁.warrant child₁ = some W₁ ∧
        S₁.warrant witness₂Id = some witness₂ ∧
        S₂.warrant child₂ = some W₂ ∧
        W₁ = transportHistoricalWarrant
          map₁ binding₁.profileDigest context₁ originalId witness₁Id
          original witness₁ translated₁ scope₁ ∧
        W₂ = transportHistoricalWarrant
          map₂ binding₂.profileDigest context₂ child₁ witness₂Id
          W₁ witness₂ translated₂ scope₂ ∧
        ScopeNarrowerOrEqual W₂.scope original.scope ∧
        (∀ originalDepth finalDepth,
          original.role = .escalation →
          canonicalEscalationDepth original.claim = some originalDepth →
          canonicalEscalationDepth W₂.claim = some finalDepth →
          finalDepth ≤ originalDepth) ∧
        (∀ role rootId,
          role ≠ .bridge →
          (W₂.rootLineage role rootId ↔
            original.rootLineage role rootId)) ∧
        (∀ rootId,
          W₂.rootLineage .bridge rootId ↔
            original.rootLineage .bridge rootId ∨
              (∃ role, witness₁.rootLineage role rootId) ∨
              (∃ role, witness₂.rootLineage role rootId)) ∧
        (∀ role sourceId,
          role ≠ .bridge →
          (W₂.sourceLineage role sourceId ↔
            original.sourceLineage role sourceId)) ∧
        (∀ sourceId,
          W₂.sourceLineage .bridge sourceId ↔
            original.sourceLineage .bridge sourceId ∨
              (∃ role, witness₁.sourceLineage role sourceId) ∨
              (∃ role, witness₂.sourceLineage role sourceId)) := by
  have hReachable₁ : Reachable S₁ := Reachable.step hReachable hFirst
  have hReachable₂ : Reachable S₂ := Reachable.step hReachable₁ hSecond
  refine ⟨hReachable₁, hReachable₂, ?_⟩

  rcases transportStep_newWarrant_exact hFirst with
    ⟨binding₁, targetContext₁, original, witness₁,
      hBinding₁, hContext₁, hOriginal, hWitness₁, hDiscipline₁, hChild₁⟩
  rcases transportStep_newWarrant_exact hSecond with
    ⟨binding₂, targetContext₂, recoveredIntermediate, witness₂,
      hBinding₂, hContext₂, hRecoveredIntermediate, hWitness₂,
      hDiscipline₂, hChild₂⟩

  let W₁ := transportHistoricalWarrant
    map₁ binding₁.profileDigest context₁ originalId witness₁Id
    original witness₁ translated₁ scope₁
  have hWarrant₁ : S₁.warrant child₁ = some W₁ := by
    simpa [W₁] using hChild₁
  have hRecoveredEq : recoveredIntermediate = W₁ := by
    exact Option.some.inj (hRecoveredIntermediate.symm.trans hWarrant₁)
  subst recoveredIntermediate

  let W₂ := transportHistoricalWarrant
    map₂ binding₂.profileDigest context₂ child₁ witness₂Id
    W₁ witness₂ translated₂ scope₂
  have hWarrant₂ : S₂.warrant child₂ = some W₂ := by
    simpa [W₂] using hChild₂

  have hSecondScope : ScopeNarrowerOrEqual scope₂ scope₁ := by
    simpa [W₁, transportHistoricalWarrant] using
      hDiscipline₂.scopeWithinOriginal
  have hScopeRaw : ScopeNarrowerOrEqual scope₂ original.scope :=
    transportTwoHop_scope_conservative
      hDiscipline₁.scopeWithinOriginal hSecondScope
  have hScope : ScopeNarrowerOrEqual W₂.scope original.scope := by
    simpa [W₂, transportHistoricalWarrant] using hScopeRaw

  have hStrength :
      ∀ originalDepth finalDepth,
        original.role = .escalation →
        canonicalEscalationDepth original.claim = some originalDepth →
        canonicalEscalationDepth W₂.claim = some finalDepth →
        finalDepth ≤ originalDepth := by
    intro originalDepth finalDepth hRole hOriginalDepth hFinalDepth
    have hTranslated₂Depth :
        canonicalEscalationDepth translated₂ = some finalDepth := by
      simpa [W₂, transportHistoricalWarrant] using hFinalDepth
    have hSecondStrength :
        NoTransportEscalationAmplification
          (transportHistoricalWarrant
            map₁ binding₁.profileDigest context₁ originalId witness₁Id
            original witness₁ translated₁ scope₁)
          translated₂ := by
      simpa [W₁] using hDiscipline₂.noEscalationAmplification
    exact transportTwoHop_strength_nonamplifying
      original witness₁ map₁ binding₁.profileDigest context₁
      originalId witness₁Id translated₁ translated₂ scope₁
      hRole hOriginalDepth hTranslated₂Depth
      hDiscipline₁.noEscalationAmplification hSecondStrength

  have hRootNonBridge :
      ∀ role rootId,
        role ≠ .bridge →
        (W₂.rootLineage role rootId ↔
          original.rootLineage role rootId) := by
    intro role rootId hRole
    have hComposed :=
      (transportRootLineage_twoHop_unfold
        original witness₁ witness₂ map₁ binding₁.profileDigest context₁
        originalId witness₁Id translated₁ scope₁ role rootId).trans
        (transportRootLineageTwoHop_nonBridge_exact
          original witness₁ witness₂ role rootId hRole)
    simpa [W₁, W₂, transportHistoricalWarrant] using hComposed

  have hRootBridge :
      ∀ rootId,
        W₂.rootLineage .bridge rootId ↔
          original.rootLineage .bridge rootId ∨
            (∃ role, witness₁.rootLineage role rootId) ∨
            (∃ role, witness₂.rootLineage role rootId) := by
    intro rootId
    have hComposed :=
      (transportRootLineage_twoHop_unfold
        original witness₁ witness₂ map₁ binding₁.profileDigest context₁
        originalId witness₁Id translated₁ scope₁ .bridge rootId).trans
        (transportRootLineageTwoHop_bridge_exact
          original witness₁ witness₂ rootId)
    simpa [W₁, W₂, transportHistoricalWarrant] using hComposed

  have hSourceNonBridge :
      ∀ role sourceId,
        role ≠ .bridge →
        (W₂.sourceLineage role sourceId ↔
          original.sourceLineage role sourceId) := by
    intro role sourceId hRole
    have hComposed :=
      (transportSourceLineage_twoHop_unfold
        original witness₁ witness₂ map₁ binding₁.profileDigest context₁
        originalId witness₁Id translated₁ scope₁ role sourceId).trans
        (transportSourceLineageTwoHop_nonBridge_exact
          original witness₁ witness₂ role sourceId hRole)
    simpa [W₁, W₂, transportHistoricalWarrant] using hComposed

  have hSourceBridge :
      ∀ sourceId,
        W₂.sourceLineage .bridge sourceId ↔
          original.sourceLineage .bridge sourceId ∨
            (∃ role, witness₁.sourceLineage role sourceId) ∨
            (∃ role, witness₂.sourceLineage role sourceId) := by
    intro sourceId
    have hComposed :=
      (transportSourceLineage_twoHop_unfold
        original witness₁ witness₂ map₁ binding₁.profileDigest context₁
        originalId witness₁Id translated₁ scope₁ .bridge sourceId).trans
        (transportSourceLineageTwoHop_bridge_exact
          original witness₁ witness₂ sourceId)
    simpa [W₁, W₂, transportHistoricalWarrant] using hComposed

  exact ⟨binding₁, binding₂, original, witness₁, witness₂, W₁, W₂,
    hBinding₁, hBinding₂, hOriginal, hWitness₁, hWarrant₁, hWitness₂,
    hWarrant₂, rfl, rfl, hScope, hStrength,
    hRootNonBridge, hRootBridge, hSourceNonBridge, hSourceBridge⟩

end ResponsibilityTopology
