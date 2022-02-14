module MakeCalcsVector (Vector : Vector.VECTOR) : Calc.Calcs = struct
  module V = Vector

  type num = V.t [@@deriving sexp]

  type op =
    | Add
    | Sub
  [@@deriving sexp]

  let calculate op acc arg =
    match op with
    | Add -> Some (V.add acc arg)
    | Sub -> Some (V.sub acc arg)
  ;;
end

module MakeCalcsVector0 = MakeCalcsVector (Vector.Vector0)
module MakeCalcsVector1 = MakeCalcsVector (Vector.Vector1)
module MakeCalcsVector2 = MakeCalcsVector (Vector.Vector2)

module Make (Vector : Vector.VECTOR) (Calcs : Calc.Calcs with type num = Vector.t) =
struct
  module StateMachine = Calc.StateMachine (Calcs)

  let string_to_action line =
    match Vector.parse line with
    | Some v -> StateMachine.Action.Num v
    | None ->
      (match Parser.process_line line with
      | Ok Empty -> StateMachine.Action.Empty
      | Ok Back -> StateMachine.Action.Back
      | Ok Reset -> StateMachine.Action.Reset
      | Ok Calculate -> StateMachine.Action.Calculate
      | _ -> StateMachine.Action.Back)
  ;;

  let update _state _line = ()
end
