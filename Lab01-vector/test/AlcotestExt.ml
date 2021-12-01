open Alcotest

let fixtures_parameterized ~before ~after ~params ~param_to_string ~tests =
  tests
  |> List.concat_map ~f:(fun (name, mode, tst) ->
         List.map params ~f:(fun p ->
             let msg = name ^ " (" ^ param_to_string p ^ ")" in
             let fn () =
               let c = before () in
               tst c p;
               after c
             in
             (msg, mode, fn)))

let check_float ~msg ~expected ~actual ?(eps = 1e-6) =
  check' ~msg ~expected:true ~actual:Float.(abs (expected - actual) <= eps)
