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
             msg, mode, fn))
;;

let check_float ?(eps = 1e-6) ~msg ~expected ~actual =
  check' bool ~msg ~expected:true ~actual:Float.(abs (expected - actual) <= eps)
;;

module CheckVector (V : Lab01_vector.Vector.VEC) = struct
  let check_vector ?(eps = 1e-6) ~msg ~expected ~actual =
    check' bool ~msg ~expected:true ~actual:(V.equal ~eps actual expected)
  ;;
end
