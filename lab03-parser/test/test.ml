open Core
open Lab03_parser

let%test_module "parser" =
  (module struct
    module P = Parser

    let%expect_test "process_line" =
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
      print_s
        [%sexp
          (P.process_line "(1231, 123122222222222222222222222222222222222222222221.2121)"
            : P.token)];
      [%expect {| (TwoNumbers 1231 1.2312222222222222E+47) |}];
      print_s
        [%sexp
          (P.process_line "(sntratroaeintstsrdrsatd.r.s,rnetrapl 283;9tp;hawlu)"
            : P.token)];
      [%expect {| (Error TwoNumberFail) |}];
      print_s [%sexp (P.process_line "(1,2,3)" : P.token)];
      [%expect {| (Error TooMany) |}]
    ;;
  end)
;;

module V0 = Vector.Vector0
module V1 = Vector.Vector1
module V2 = Vector.Vector2

let%test_module "vector parsing tests" =
  (module struct
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

    let%expect_test "parse vector0" =
      let a = V0.parse "()" |> Option.value_exn in
      print_s [%sexp (a : Lab03_parser.Vector.Vector0.t)];
      [%expect {| () |}]
    ;;
  end)
;;

let%test_module "triple_or and triple_and tests" =
  (module struct
    module TrAO = Tripleorand

    let%test "triple_or v0" = TrAO.triple_or (module V0) V0.make V0.make V0.make
    let%test "triple_or v0" = TrAO.triple_and (module V0) V0.make V0.make V0.make

    let%test "triple_or v1 not" =
      not @@ TrAO.triple_or (module V1) (V1.make 1.) (V1.make 2.) (V1.make 3.)
    ;;

    let%test "triple_or v1 not" =
      not @@ TrAO.triple_and (module V1) (V1.make 1.) (V1.make 2.) (V1.make 3.)
    ;;

    let%test "triple_or v1" =
      TrAO.triple_or (module V1) (V1.make 1.) (V1.make 1.) (V1.make 3.)
    ;;

    let%test "triple_or v1" =
      TrAO.triple_and (module V1) (V1.make 1.) (V1.make 1.) (V1.make 1.)
    ;;

    let print_bool = printf "%b\n"

    let%expect_test "" =
      TrAO.triple_and (module Int) 1 2 3 |> print_bool;
      [%expect {| false |}];
      TrAO.triple_or (module Int) 1 1 3 |> print_bool;
      [%expect {| true |}]
    ;;
  end)
;;
