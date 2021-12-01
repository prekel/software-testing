val fixtures_parameterized :
  before:(unit -> 'c) ->
  after:('c -> unit) ->
  params:'a list ->
  param_to_string:('a -> string) ->
  tests:(string * Alcotest.speed_level * ('c -> 'a -> unit)) list ->
  (string * Alcotest.speed_level * (unit -> unit)) list

val check_float :
  msg:string ->
  expected:float ->
  actual:float ->
  ?eps:float ->
  ?here:Lexing.position ->
  ?pos:Alcotest.Source_code_position.pos ->
  bool Alcotest.testable ->
  unit
