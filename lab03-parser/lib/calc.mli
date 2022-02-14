open Calcs

module MakeStateMachine (Calcs : Calcs) : sig
  module C : Calcs

module type S = sig
  module Calcs : Calcs
  open Calcs

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
<<<<<<< HEAD
  val result : State.t -> num option
  val update : action:Action.t -> State.t -> State.t
end

module MakeStateMachine (Calcs : Calcs) : sig
  include S with module Calcs = Calcs
=======
  val result : State.t -> Calcs.num option
  val update : action:Action.t -> State.t -> State.t
>>>>>>> mockparser
end
