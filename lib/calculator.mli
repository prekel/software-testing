open Core

module type S = sig
  include Calc.S

  val line_to_action : ?quit:(unit -> never_returns) -> string -> action
end

module CalculatorFloat : S with type num = float
module CalculatorInt : S with type num = int
module CalculatorVector0 : S with type num = Vector.Vector0.t
module CalculatorVector1 : S with type num = Vector.Vector1.t
module CalculatorVector2 : S with type num = Vector.Vector2.t
