open Core
module V0 = Lab03_parser.Vector.Vector0

let%expect_test "vec" =
  let a = V0.parse "123" |> Option.value_exn in
  print_s [%sexp (a : V0.t)];
  [%expect {|
    "123"
    () |}]
;;
