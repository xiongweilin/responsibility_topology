import ResponsibilityTopology.TransportSemantics

namespace ResponsibilityTopology

/-!
Pure two-hop TRANSPORT conservation.

This module composes the T0 semantic laws without introducing a path datatype,
`Step`, `Reachable`, qualification, context activation, or cross-profile
semantics.  It is deliberately a two-hop closure result; reachable lifting is a
separate milestone.
-/

/-- Set-semantic scope narrowing is transitive. -/
theorem scopeNarrowerOrEqual_trans
    {a b c : Scope}
    (hab : ScopeNarrowerOrEqual a b)
    (hbc : ScopeNarrowerOrEqual b c) :
    ScopeNarrowerOrEqual a c := by
  intro atom hAtom
  exact hbc atom (hab atom hAtom)

/-- T4a scope law: two successive transport scope restrictions remain bounded
by the original warrant scope. -/
theorem transportTwoHop_scope_conservative
    {originalScope intermediateScope finalScope : Scope}
    (hFirst : ScopeNarrowerOrEqual intermediateScope originalScope)
    (hSecond : ScopeNarrowerOrEqual finalScope intermediateScope) :
    ScopeNarrowerOrEqual finalScope originalScope :=
  scopeNarrowerOrEqual_trans hSecond hFirst

/-- T4a strength law for the canonically interpretable escalation case.
If each transport hop satisfies the single-hop non-amplification law, an
interpretable final depth cannot exceed the original depth. -/
theorem transportTwoHop_strength_nonamplifying
    (original witness₁ : HistoricalWarrant)
    (map₁ profileDigest context₁ : String)
    (originalId witness₁Id : WarrantId)
    (translated₁ translated₂ : Claim)
    (scope₁ : Scope)
    {originalDepth finalDepth : RevisionDepth}
    (hRole : original.role = .escalation)
    (hOriginalDepth :
      canonicalEscalationDepth original.claim = some originalDepth)
    (hFinalDepth :
      canonicalEscalationDepth translated₂ = some finalDepth)
    (hFirst : NoTransportEscalationAmplification original translated₁)
    (hSecond : NoTransportEscalationAmplification
      (transportHistoricalWarrant map₁ profileDigest context₁
        originalId witness₁Id original witness₁ translated₁ scope₁)
      translated₂) :
    finalDepth ≤ originalDepth := by
  have hSecond' := hSecond
  simp [NoTransportEscalationAmplification, transportHistoricalWarrant,
    hRole, hFinalDepth] at hSecond'
  rcases hSecond' with ⟨intermediateDepth, hIntermediateDepth, hFinalLe⟩
  have hFirst' := hFirst
  simp [NoTransportEscalationAmplification, hRole, hIntermediateDepth] at hFirst'
  rcases hFirst' with ⟨observedOriginalDepth, hObservedOriginal, hIntermediateLe⟩
  have hDepthEq : observedOriginalDepth = originalDepth := by
    exact Option.some.inj (hObservedOriginal.symm.trans hOriginalDepth)
  subst observedOriginalDepth
  exact Nat.le_trans hFinalLe hIntermediateLe

/-- Root-lineage transform after two TRANSPORT hops: the original role-indexed
ancestry is retained, first-hop translation evidence is already BRIDGE-scoped,
and second-hop translation evidence is added under BRIDGE. -/
def transportRootLineageTwoHop
    (original witness₁ witness₂ : HistoricalWarrant) : RootLineage :=
  fun role rootId =>
    transportRootLineage original witness₁ role rootId ∨
      (role = .bridge ∧
        ∃ witnessRole, witness₂.rootLineage witnessRole rootId)

/-- Source-lineage analogue of `transportRootLineageTwoHop`. -/
def transportSourceLineageTwoHop
    (original witness₁ witness₂ : HistoricalWarrant) : SourceLineage :=
  fun role sourceId =>
    transportSourceLineage original witness₁ role sourceId ∨
      (role = .bridge ∧
        ∃ witnessRole, witness₂.sourceLineage witnessRole sourceId)

/-- The two-hop root transform is exactly the root lineage obtained by using the
first transported historical object as the original of the second hop. -/
theorem transportRootLineage_twoHop_unfold
    (original witness₁ witness₂ : HistoricalWarrant)
    (map₁ profileDigest context₁ : String)
    (originalId witness₁Id : WarrantId)
    (translated₁ : Claim) (scope₁ : Scope)
    (role : Role) (rootId : WarrantId) :
    transportRootLineage
        (transportHistoricalWarrant map₁ profileDigest context₁
          originalId witness₁Id original witness₁ translated₁ scope₁)
        witness₂ role rootId ↔
      transportRootLineageTwoHop original witness₁ witness₂ role rootId := by
  rfl

/-- The two-hop source transform unfolds analogously. -/
theorem transportSourceLineage_twoHop_unfold
    (original witness₁ witness₂ : HistoricalWarrant)
    (map₁ profileDigest context₁ : String)
    (originalId witness₁Id : WarrantId)
    (translated₁ : Claim) (scope₁ : Scope)
    (role : Role) (sourceId : String) :
    transportSourceLineage
        (transportHistoricalWarrant map₁ profileDigest context₁
          originalId witness₁Id original witness₁ translated₁ scope₁)
        witness₂ role sourceId ↔
      transportSourceLineageTwoHop original witness₁ witness₂ role sourceId := by
  rfl

/-- T4a root-lineage conservation away from BRIDGE: after two hops, no
translation evidence can masquerade as original ancestry at another role. -/
theorem transportRootLineageTwoHop_nonBridge_exact
    (original witness₁ witness₂ : HistoricalWarrant)
    (role : Role) (rootId : WarrantId)
    (hRole : role ≠ .bridge) :
    transportRootLineageTwoHop original witness₁ witness₂ role rootId ↔
      original.rootLineage role rootId := by
  constructor
  · intro h
    rcases h with hFirst | hSecond
    · exact (transportRootLineage_nonBridge_exact
        original witness₁ role rootId hRole).mp hFirst
    · exact False.elim (hRole hSecond.1)
  · intro h
    exact Or.inl
      ((transportRootLineage_nonBridge_exact
        original witness₁ role rootId hRole).mpr h)

/-- T4a source-lineage conservation away from BRIDGE. -/
theorem transportSourceLineageTwoHop_nonBridge_exact
    (original witness₁ witness₂ : HistoricalWarrant)
    (role : Role) (sourceId : String)
    (hRole : role ≠ .bridge) :
    transportSourceLineageTwoHop original witness₁ witness₂ role sourceId ↔
      original.sourceLineage role sourceId := by
  constructor
  · intro h
    rcases h with hFirst | hSecond
    · exact (transportSourceLineage_nonBridge_exact
        original witness₁ role sourceId hRole).mp hFirst
    · exact False.elim (hRole hSecond.1)
  · intro h
    exact Or.inl
      ((transportSourceLineage_nonBridge_exact
        original witness₁ role sourceId hRole).mpr h)

/-- T4a BRIDGE root lineage is exactly original BRIDGE ancestry plus all
first-hop and second-hop translation-witness ancestry. -/
theorem transportRootLineageTwoHop_bridge_exact
    (original witness₁ witness₂ : HistoricalWarrant)
    (rootId : WarrantId) :
    transportRootLineageTwoHop original witness₁ witness₂ .bridge rootId ↔
      original.rootLineage .bridge rootId ∨
        (∃ role, witness₁.rootLineage role rootId) ∨
        (∃ role, witness₂.rootLineage role rootId) := by
  change
    ((original.rootLineage .bridge rootId ∨
        ∃ role, witness₁.rootLineage role rootId) ∨
      ∃ role, witness₂.rootLineage role rootId) ↔
      original.rootLineage .bridge rootId ∨
        (∃ role, witness₁.rootLineage role rootId) ∨
        (∃ role, witness₂.rootLineage role rootId)
  constructor
  · intro h
    rcases h with hFirst | hThird
    · rcases hFirst with hOriginal | hWitness₁
      · exact Or.inl hOriginal
      · exact Or.inr (Or.inl hWitness₁)
    · exact Or.inr (Or.inr hThird)
  · intro h
    rcases h with hOriginal | hRest
    · exact Or.inl (Or.inl hOriginal)
    · rcases hRest with hWitness₁ | hWitness₂
      · exact Or.inl (Or.inr hWitness₁)
      · exact Or.inr hWitness₂

/-- T4a BRIDGE source lineage has the corresponding exact accumulation law. -/
theorem transportSourceLineageTwoHop_bridge_exact
    (original witness₁ witness₂ : HistoricalWarrant)
    (sourceId : String) :
    transportSourceLineageTwoHop original witness₁ witness₂ .bridge sourceId ↔
      original.sourceLineage .bridge sourceId ∨
        (∃ role, witness₁.sourceLineage role sourceId) ∨
        (∃ role, witness₂.sourceLineage role sourceId) := by
  change
    ((original.sourceLineage .bridge sourceId ∨
        ∃ role, witness₁.sourceLineage role sourceId) ∨
      ∃ role, witness₂.sourceLineage role sourceId) ↔
      original.sourceLineage .bridge sourceId ∨
        (∃ role, witness₁.sourceLineage role sourceId) ∨
        (∃ role, witness₂.sourceLineage role sourceId)
  constructor
  · intro h
    rcases h with hFirst | hThird
    · rcases hFirst with hOriginal | hWitness₁
      · exact Or.inl hOriginal
      · exact Or.inr (Or.inl hWitness₁)
    · exact Or.inr (Or.inr hThird)
  · intro h
    rcases h with hOriginal | hRest
    · exact Or.inl (Or.inl hOriginal)
    · rcases hRest with hWitness₁ | hWitness₂
      · exact Or.inl (Or.inr hWitness₁)
      · exact Or.inr hWitness₂

end ResponsibilityTopology
