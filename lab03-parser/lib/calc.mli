module type S = sig
  module C : Calcs.Calcs

  type state =
    | WaitInitial
    | WaitOperation of { acc : C.num }
    | WaitArgument of
        { acc : C.num
        ; op : C.op
        }
    | Calculation of
        { acc : C.num
        ; op : C.op
        ; arg : C.num
        }
    | ErrorState of state
    | ErrorInput of state
    | ErrorOperation of state
    | Finish of C.num
  [@@deriving sexp]

  type action =
    | Num of C.num
    | Op of C.op
    | Empty
    | Invalid
    | Calculate
    | Back
    | Reset
  [@@deriving sexp]

  val initial : state
  val result : state -> C.num option
  val update : action:action -> state -> state
end

module MakeStateMachine (Calcs : Calcs.Calcs) : sig
  include S with module C = Calcs
end
