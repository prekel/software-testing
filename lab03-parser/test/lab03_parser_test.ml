open Core
module P = Lab03_parser.Parser
module V0 = Lab03_parser.Vector.Vector0
module V1 = Lab03_parser.Vector.Vector0
module V2 = Lab03_parser.Vector.Vector0

let%test "false" = true

let%expect_test "" =
  let a = Lab03_parser.Parser.Empty in
  print_s [%sexp (a : Lab03_parser.Parser.token)];
  [%expect {| Empty |}]
;;

let%expect_test "vec" =
  let a = Lab03_parser.Vector.Vector2.make 1. 2. in
  print_s [%sexp (a : Lab03_parser.Vector.Vector2.t)];
  [%expect {| (1 (2 ())) |}]
;;

let%expect_test "parser" =
  print_s [%sexp (P.process_line "" : P.token)];
  [%expect {| (Error NoParens) |}];
  print_s [%sexp (P.process_line "(" : P.token)];
  [%expect {| (Error NoParens) |}];
  print_s [%sexp (P.process_line "( )" : P.token)];
  [%expect {| Empty |}];
  print_s [%sexp (P.process_line "(  )" : P.token)];
  [%expect {| Empty |}];
  print_s [%sexp (P.process_line "(12)" : P.token)];
  [%expect {| (OneNumber 12) |}];
  print_s [%sexp (P.process_line "(123)" : P.token)];
  [%expect {| (OneNumber 123) |}];
  print_s [%sexp (P.process_line "(123.12)" : P.token)];
  [%expect {| (OneNumber 123.12) |}];
  print_s [%sexp (P.process_line "(123q)" : P.token)];
  [%expect {| (Error OneNumberFail) |}];
  print_s [%sexp (P.process_line "(123,123)" : P.token)];
  [%expect {| (TwoNumbers 123 123) |}];
  print_s [%sexp (P.process_line "(123.12,123)" : P.token)];
  [%expect {| (TwoNumbers 123.12 123) |}];
  print_s [%sexp (P.process_line "(arsa,asrt)" : P.token)];
  [%expect {| (Error TwoNumberFail) |}];
  print_s [%sexp (P.process_line "(1231, 123122222222222222222222222222222222222222222221.2121)" : P.token)];
  [%expect {| (TwoNumbers 1231 1.2312222222222222E+47) |}];
  print_s [%sexp (P.process_line "(sntratroaeintstsrdrsatd.r.s,rnetrapl 283;9tp;hawlu)" : P.token)];
  [%expect {| (Error TwoNumberFail) |}]
;;

let%expect_test "parse vector0" =
  let a = V0.parse "()" |> Option.value_exn in
  print_s [%sexp (a : Lab03_parser.Vector.Vector0.t)];
  [%expect {| () |}]
;;
