import ResponsibilityTopology.Conservativity
import ResponsibilityTopology.ExecutableSatisfaction

/-!
Proof-audit surface for the current mechanization milestones.
CI prints the axiom dependencies of the machine-checked declarations.
-/

#print axioms ResponsibilityTopology.derives_transport
#print axioms ResponsibilityTopology.branchConservativity
#print axioms ResponsibilityTopology.firstSat_sound
#print axioms ResponsibilityTopology.firstSat_none_rejects
#print axioms ResponsibilityTopology.firstSat_none_of_rejects
#print axioms ResponsibilityTopology.firstSat_noNewWitness
#print axioms ResponsibilityTopology.noNewWitness
#print axioms ResponsibilityTopology.satisfySound
