module type Calcs = sig
  type num [@@deriving sexp]
  type op [@@deriving sexp]

  val calculate : op -> num -> num -> num option
end

module MakeStates (Calcs : Calcs) = struct
  open Calcs

  type t =
    | WaitInitial
    | WaitOperation of
        { acc : num
        ; acc' : num
        }
    | WaitArgument of
        { acc : num
        ; acc' : num
        ; op : op
        }
    | Calculation of
        { acc : num
        ; acc' : num
        ; op : op
        ; arg : num
        }
    | ErrorState of t
    | ErrorInput of t
    | ErrorOperation of t
    | Finish of num
  [@@deriving sexp]
end

module MakeActions (Calcs : Calcs) = struct
  open Calcs

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

module StateMachine (Calcs : Calcs) = struct
  module State = MakeStates (Calcs)
  module Action = MakeActions (Calcs)

  let update state action =
    let open State in
    let open Action in
    match state, action with
    | _, Reset -> WaitInitial
    | _, Invalid -> ErrorInput state
    | WaitInitial, Num a -> WaitOperation { acc = a; acc' = a }
    | WaitInitial, (Op _ | Empty | Calculate) -> ErrorState state
    | WaitInitial, Back -> WaitInitial
    | WaitOperation _, (Num _ | Calculate) -> ErrorState state
    | WaitOperation { acc; acc' }, Op op -> WaitArgument { acc; acc'; op }
    | WaitOperation { acc; _ }, Empty -> Finish acc
    | WaitOperation _, Back -> WaitInitial
    | WaitArgument { acc; acc'; op }, Num arg -> Calculation { acc; acc'; op; arg }
    | WaitArgument _, (Op _ | Empty | Calculate) -> ErrorState state
    | WaitArgument { acc; acc'; _ }, Back -> WaitOperation { acc; acc' }
    | Calculation _, (Empty | Num _ | Op _) -> ErrorState state
    | Calculation { acc; acc'; op; _ }, Back -> WaitArgument { acc; acc'; op }
    | Calculation { acc; acc'; op; arg }, Calculate ->
      (match Calcs.calculate op acc arg with
      | Some acc -> WaitOperation { acc; acc' }
      | None -> ErrorOperation state)
    | (ErrorState old_state | ErrorInput old_state | ErrorOperation old_state), Back ->
      old_state
    | (ErrorState _ | ErrorInput _ | ErrorOperation _), _ -> state
    | Finish _, _ -> state
  ;;
end
