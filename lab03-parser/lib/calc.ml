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
    | Finish
end

module Actions = struct
  type ('a, 'b) t =
    | Num of 'a
    | Op of 'b
    | Empty
    | Invalid
end

module StateMachine = struct
  open States
  open Actions

  let update state action =
    match state, action with
    | WaitInitial, Num a -> WaitOperation { acc = a; acc' = a }
    | WaitInitial, Op _ | WaitInitial, Empty -> ErrorState state
    | WaitInitial, Invalid -> ErrorInput state
    | WaitOperation _, Num _ -> ErrorState state
    | WaitOperation { acc; acc' }, Op op -> WaitArgument { acc; acc'; op }
    | WaitOperation _, Empty -> Finish
    | WaitOperation _, Invalid -> ErrorInput state
    | WaitArgument { acc; acc'; op }, Num arg -> Calculation { acc; acc'; op; arg }
    | WaitArgument _, Op _ 
    | WaitArgument _, Empty -> ErrorState state
    | WaitArgument _, Invalid -> ErrorInput state
    | _, _ -> state
  ;;
end
