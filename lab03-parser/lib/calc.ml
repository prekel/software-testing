open Calcs

module type S = sig
  module C : Calcs
  open C

  module State : sig
    type t =
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
      | ErrorState of t
      | ErrorInput of t
      | ErrorOperation of t
      | Finish of num
    [@@deriving sexp]
  end

  module Action : sig
    type t =
      | Num of num
      | Op of op
      | Empty
      | Invalid
      | Calculate
      | Back
      | Reset
    [@@deriving sexp]
  end

  val initial : State.t
  val result : State.t -> num option
  val update : action:Action.t -> State.t -> State.t
end

module MakeStateMachine (Calcs : Calcs) = struct
  module C = Calcs
  open C

  module State = struct
    type t =
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
      | ErrorState of t
      | ErrorInput of t
      | ErrorOperation of t
      | Finish of num
    [@@deriving sexp]
  end

  module Action = struct
    type t =
      | Num of num
      | Op of op
      | Empty
      | Invalid
      | Calculate
      | Back
      | Reset
    [@@deriving sexp]
  end

  let initial = State.WaitInitial

  let result = function
    | State.Finish result -> Some result
    | _ -> None
  ;;

  let update ~action state =
    let open State in
    let open Action in
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
