open Alcotest

module AlcotestExt = struct
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
end

let vf =
  AlcotestExt.fixtures_parameterized
    ~before:(fun () ->
      let ret = ref 1 in
      Caml.Printf.printf "Before: %d\n" !ret;
      ret)
    ~after:(fun c -> Caml.Printf.printf "After: %d\n" !c)
    ~params:[ 0.; 1. ] ~param_to_string:Float.to_string
    ~tests:
      [
        ( "test1",
          `Quick,
          fun c p ->
            Caml.Printf.printf "Test: c=%d p=%f\n" !c p;
            c := Float.to_int p );
      ]

let test_hello_with_name name () = check' int ~msg:"" ~expected:2 ~actual:2

let suite =
  [
    ("can greet Tom", `Quick, test_hello_with_name "Tom");
    ("can greet John", `Quick, test_hello_with_name "John");
  ]

let () = Alcotest.run "lab01-vector" [ ("Lab01_vector", suite); ("f", vf) ]
