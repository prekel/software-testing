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
    | ErrorInput of state
    | ErrorOperation of state
    | Finish of num
  [@@deriving sexp, equal]

  type action =
    | Num of num
    | Op of op
    | Empty
    | Invalid
    | Calculate
    | Back
    | Reset
  [@@deriving sexp, equal]

  val initial : state
  val result : state -> num option
  val update : action:action -> state -> state
end

module MakeStateMachine (Calcs : Calcs.Calcs) : sig
  include S with type num = Calcs.num and type op = Calcs.op
end
