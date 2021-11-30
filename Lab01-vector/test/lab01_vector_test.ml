open Alcotest
open AlcotestExt

let vf =
  fixtures_parameterized
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
