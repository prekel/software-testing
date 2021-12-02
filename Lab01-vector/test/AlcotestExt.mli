val fixtures_parameterized :
  before:(unit -> 'c) ->
  after:('c -> unit) ->
  params:'a list ->
  param_to_string:('a -> string) ->
  tests:(string * Alcotest.speed_level * ('c -> 'a -> unit)) list ->
  (string * Alcotest.speed_level * (unit -> unit)) list

val check_float :
  ?eps:float -> msg:string -> expected:float -> actual:float -> unit

module CheckVector (V : Lab01_vector.Vector.VEC) : sig
  val check_vector :
    ?eps:float -> msg:string -> expected:V.t -> actual:V.t -> unit
end
