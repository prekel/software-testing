module MakeCalculator (M : sig
  include Calc.S

  val token_to_action : Parser.token -> (action, [ `Quit | `WrongToken ]) result
end) : sig
  val run : unit -> M.num option
  (* val run' : unit -> M.num option Lwt.t *)
end

module MakeCalculatorS (M : sig
  type t
end) : sig
  val run : unit -> M.t option
  (* val run' : unit -> M.t option Lwt.t *)
end

module MakeCalculatorVector (Vector : Vector.VECTOR) :
    module type of MakeCalculatorS (Vector)

module CalculatorFloat : module type of MakeCalculatorS (Float)
module CalculatorVector0 : module type of MakeCalculatorS (Vector.Vector0)
module CalculatorVector1 : module type of MakeCalculatorS (Vector.Vector1)
module CalculatorVector2 : module type of MakeCalculatorS (Vector.Vector2)
