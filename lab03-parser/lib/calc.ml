module States = struct
  type ('a, 'b) t =
    | WaitInitial
    | WaitOperation of
        { acc : 'a
        ; acc' : 'a
        }
    | WaitArgument of
        { acc : 'a
        ; acc' : 'a
        ; op : 'b
        }
    | Calculation of
        { acc : 'a
        ; acc' : 'a
        ; op : 'b
        ; arg : 'a
        }
    | ErrorState of ('a, 'b) t
    | ErrorInput of ('a, 'b) t
    | ErrorOperation of ('a, 'b) t
    | Finish of 'a
end

module Actions = struct
  type ('a, 'b) t =
    | Num of 'a
    | Op of 'b
    | Empty
    | Invalid
    | Calculate
    | Back
    | Reset
end

module StateMachine = struct
  open States
  open Actions

  type a
  type b

  let doop (_acc : a) (_arg : a) (_op : b) : a option = None

  let update (state : (a, b) States.t) action =
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
      (match doop acc arg op with
      | Some acc -> WaitOperation { acc; acc' }
      | None -> ErrorOperation state)
    | (ErrorState old_state | ErrorInput old_state | ErrorOperation old_state), Back ->
      old_state
    | (ErrorState _ | ErrorInput _ | ErrorOperation _), _ -> state
    | Finish _, _ -> state
  ;;
end
