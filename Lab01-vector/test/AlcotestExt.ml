open Alcotest

let fixtures_parameterized ~(before : unit -> 'c) ~(after : 'c -> unit)
    ~(params : 'a list) ~(param_to_string : 'a -> string)
    ~(tests : (string * speed_level * ('c -> 'a -> unit)) list) =
  tests
  |> List.concat_map ~f:(fun (name, mode, tst) ->
         List.map params ~f:(fun p ->
             let name = name ^ " (" ^ param_to_string p ^ ")" in
             let fn () =
               let c = before () in
               tst c p;
               after c
             in
             (name, mode, fn)))

let check_float ~msg ~expected ~actual ?(eps = 1e-6) =
  check' ~msg ~expected:true ~actual:Float.(abs (expected - actual) <= eps)
