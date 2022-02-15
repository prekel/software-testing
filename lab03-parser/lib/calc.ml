open Calcs

module type S = sig
  module C : Calcs
  open C

  type state =
    | WaitInitial
    | WaitOperation of { acc : num }
    | WaitArgument of
        { acc : num
        ; op : op
        }
    | Calculation of
        { acc : num
        ; op : op
        ; arg : num
        }
    | ErrorState of state
    | ErrorInput of state
    | ErrorOperation of state
    | Finish of num
  [@@deriving sexp]

  type action =
    | Num of num
    | Op of op
    | Empty
    | Invalid
    | Calculate
    | Back
    | Reset
  [@@deriving sexp]

  val initial : state
  val result : state -> num option
  val update : action:action -> state -> state
end

module MakeStateMachine (Calcs : Calcs) = struct
  module C = Calcs
  open C

  type state =
    | WaitInitial
    | WaitOperation of { acc : num }
    | WaitArgument of
        { acc : num
        ; op : op
        }
    | Calculation of
        { acc : num
        ; op : op
        ; arg : num
        }
    | ErrorState of state
    | ErrorInput of state
    | ErrorOperation of state
    | Finish of num
  [@@deriving sexp]

  type action =
    | Num of num
    | Op of op
    | Empty
    | Invalid
    | Calculate
    | Back
    | Reset
  [@@deriving sexp]

  let initial = WaitInitial

  let result = function
    | Finish result -> Some result
    | _ -> None
  ;;

  let update ~action state =
    match state, action with
    | _, Reset -> WaitInitial
    | _, Invalid -> ErrorInput state
    | WaitInitial, Num a -> WaitOperation { acc = a }
    | WaitInitial, (Op _ | Empty | Calculate) -> ErrorState state
    | WaitInitial, Back -> WaitInitial
    | WaitOperation _, (Num _ | Calculate) -> ErrorState state
    | WaitOperation { acc }, Op op -> WaitArgument { acc; op }
    | WaitOperation { acc; _ }, Empty -> Finish acc
    | WaitOperation _, Back -> WaitInitial
    | WaitArgument { acc; op }, Num arg -> Calculation { acc; op; arg }
    | WaitArgument _, (Op _ | Empty | Calculate) -> ErrorState state
    | WaitArgument { acc; _ }, Back -> WaitOperation { acc }
    | Calculation _, (Empty | Num _ | Op _) -> ErrorState state
    | Calculation { acc; op; _ }, Back -> WaitArgument { acc; op }
    | Calculation { acc; op; arg }, Calculate ->
      (match Calcs.calculate op acc arg with
      | Some acc -> WaitOperation { acc }
      | None -> ErrorOperation state)
    | (ErrorState old_state | ErrorInput old_state | ErrorOperation old_state), Back ->
      old_state
    | (ErrorState _ | ErrorInput _ | ErrorOperation _), _ -> state
    | Finish _, _ -> state
  ;;
end
