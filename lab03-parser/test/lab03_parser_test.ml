open Core

let%test "false" = true

let%expect_test "" =
  let a = Lab03_parser.Parser.Minus in
  print_s [%sexp (a : Lab03_parser.Parser.token)];
  [%expect {| Minus |}]
;;

let%expect_test "vec" =
  let a = Lab03_parser.Vector.Vector2.make 1. 2. in
  print_s [%sexp (a : Lab03_parser.Vector.Vector2.t)]
;;
