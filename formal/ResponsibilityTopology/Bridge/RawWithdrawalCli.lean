import ResponsibilityTopology.Bridge.RawRuntimeWithdrawal
import Lean.Data.Json

open Lean
open ResponsibilityTopology.Bridge

/-- Parse the versioned raw runtime transition artifact.  Extra raw snapshot
fields are ignored by `FromJson`; the checker reads only the canonical fields
needed for the restricted B0 projection. -/
def parseRawWithdrawalTransition (text : String) : Except String RawWithdrawalTransitionV1 := do
  let json ← Json.parse text
  fromJson? json

/-- CI entry point for the exact portable-runtime raw JSON artifact. -/
def main (args : List String) : IO Unit := do
  match args with
  | [path] =>
      let text ← IO.FS.readFile ⟨path⟩
      match parseRawWithdrawalTransition text with
      | .error err =>
          throw <| IO.userError s!"REF-4 raw artifact parse failure: {err}"
      | .ok transition =>
          if checkRawWithdrawal transition then
            IO.println "STRICT-L6 REF-4 RAW CHECK PASS"
          else
            throw <| IO.userError "REF-4 raw artifact does not satisfy the Lean-computed B0 withdrawal contract"
  | _ =>
      throw <| IO.userError "usage: RawWithdrawalCli <raw-withdrawal-transition-v1.json>"
