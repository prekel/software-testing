module type Calcs = sig
  type num [@@deriving sexp]
  type op [@@deriving sexp]

  val calculate : op -> num -> num -> num option
end

module StateMachine (Calcs : Calcs) : sig
  module State : sig
    type t =
      | WaitInitial
      | WaitOperation of
          { acc : Calcs.num
          ; acc' : Calcs.num
          }
      | WaitArgument of
          { acc : Calcs.num
          ; acc' : Calcs.num
          ; op : Calcs.op
          }
      | Calculation of
          { acc : Calcs.num
          ; acc' : Calcs.num
          ; op : Calcs.op
          ; arg : Calcs.num
          }
      | ErrorState of t
      | ErrorInput of t
      | ErrorOperation of t
      | Finish of Calcs.num
    [@@deriving sexp]
  end

  module Action : sig
    type t =
      | Num of Calcs.num
      | Op of Calcs.op
      | Empty
      | Invalid
      | Calculate
      | Back
      | Reset
    [@@deriving sexp]
  end

  val initial : State.t
  val result : State.t -> Calcs.num option
  val update : State.t -> Action.t -> State.t
end
