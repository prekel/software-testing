open Core
open Calcs

module type S = sig
  type num [@@deriving sexp, equal]
  type op [@@deriving sexp, equal]

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
    | ErrorInput of state * Error.t
    | ErrorOperation of state
    | Finish of num
  [@@deriving sexp, equal]

  type action =
    | Num of num
    | Op of op
    | Empty
    | Invalid of Error.t
    | Calculate
    | Back
    | Reset
  [@@deriving sexp, equal]

  val initial : state
  val result : state -> num option
  val update : action:action -> state -> state
end

module MakeStateMachine (Calcs : Calcs) = struct
  type num = Calcs.num [@@deriving sexp, equal]
  type op = Calcs.op [@@deriving sexp, equal]

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
    | ErrorInput of state * Error.t
    | ErrorOperation of state
    | Finish of num
  [@@deriving sexp, equal]

  type action =
    | Num of num
    | Op of op
    | Empty
    | Invalid of Error.t
    | Calculate
    | Back
    | Reset
  [@@deriving sexp, equal]

  let initial = WaitInitial

  let result = function
    | Finish result -> Some result
    | _ -> None
  ;;

  let update ~action state =
    match state, action with
    | _, Reset -> WaitInitial
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
      begin
        match Calcs.calculate op acc arg with
        | Some acc -> WaitOperation { acc }
        | None -> ErrorOperation state
      end
    | Finish _, _ -> state
    | ErrorInput (old_state, _), Invalid err -> ErrorInput (old_state, err)
    | (ErrorState old_state | ErrorInput (old_state, _) | ErrorOperation old_state), Back
      -> old_state
    | (ErrorState _ | ErrorInput _ | ErrorOperation _), _ -> state
    | _, Invalid err -> ErrorInput (state, err)
  ;;
end
