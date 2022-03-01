open Core
open Lab03_parser

let%test_module "parser" =
  (module struct
    module P = Parser

    let%expect_test "process_line" =
      print_s [%sexp (P.process_line "" : (P.token, P.error) Result.t)];
      [%expect {| (Ok Empty) |}];
      print_s [%sexp (P.process_line "(" : (P.token, P.error) Result.t)];
      [%expect {| (Error NoParensFail) |}];
      print_s [%sexp (P.process_line "()" : (P.token, P.error) Result.t)];
      [%expect {| (Ok ParenEmpty) |}];
      print_s [%sexp (P.process_line "( )" : (P.token, P.error) Result.t)];
      [%expect {| (Ok ParenEmpty) |}];
      print_s [%sexp (P.process_line "(  )" : (P.token, P.error) Result.t)];
      [%expect {| (Ok ParenEmpty) |}];
      print_s [%sexp (P.process_line "(             )" : (P.token, P.error) Result.t)];
      [%expect {| (Ok ParenEmpty) |}];
      print_s [%sexp (P.process_line "(12)" : (P.token, P.error) Result.t)];
      [%expect {| (Ok (ParenOneNumber 12)) |}];
      print_s [%sexp (P.process_line "(123)" : (P.token, P.error) Result.t)];
      [%expect {| (Ok (ParenOneNumber 123)) |}];
      print_s [%sexp (P.process_line "(123.12)" : (P.token, P.error) Result.t)];
      [%expect {| (Ok (ParenOneNumber 123.12)) |}];
      print_s [%sexp (P.process_line "(123q)" : (P.token, P.error) Result.t)];
      [%expect {| (Error OneNumberFail) |}];
      print_s [%sexp (P.process_line "(123,123)" : (P.token, P.error) Result.t)];
      [%expect {| (Ok (ParenTwoNumbers 123 123)) |}];
      print_s [%sexp (P.process_line "(123.12,123)" : (P.token, P.error) Result.t)];
      [%expect {| (Ok (ParenTwoNumbers 123.12 123)) |}];
      print_s [%sexp (P.process_line "(arsa,asrt)" : (P.token, P.error) Result.t)];
      [%expect {| (Error TwoNumberFail) |}];
      print_s
        [%sexp
          (P.process_line "(1231, 123122222222222222222222222222222222221.2121)"
            : (P.token, P.error) Result.t)];
      [%expect {| (Ok (ParenTwoNumbers 1231 1.2312222222222223E+38)) |}];
      print_s
        [%sexp
          (P.process_line "(sntratroaeintstsrdrsatd.r.s,rnetrapl 283;9tp;hawlu)"
            : (P.token, P.error) Result.t)];
      [%expect {| (Error TwoNumberFail) |}];
      print_s [%sexp (P.process_line "(1,2,3)" : (P.token, P.error) Result.t)];
      [%expect {| (Error TooMany) |}]
    ;;

    let%expect_test "to 100 percent" =
      print_s [%sexp (P.process_line "+" : (P.token, P.error) Result.t)];
      [%expect {| (Ok OpPlus) |}];
      print_s [%sexp (P.process_line "-" : (P.token, P.error) Result.t)];
      [%expect {| (Ok OpMinus) |}];
      print_s [%sexp (P.process_line "*" : (P.token, P.error) Result.t)];
      [%expect {| (Ok OpMult) |}];
      print_s [%sexp (P.process_line "/" : (P.token, P.error) Result.t)];
      [%expect {| (Ok OpDiv) |}];
      print_s [%sexp (P.process_line "b" : (P.token, P.error) Result.t)];
      [%expect {| (Ok Back) |}];
      print_s [%sexp (P.process_line "back" : (P.token, P.error) Result.t)];
      [%expect {| (Ok Back) |}];
      print_s [%sexp (P.process_line "c" : (P.token, P.error) Result.t)];
      [%expect {| (Ok Calculate) |}];
      print_s [%sexp (P.process_line "calc" : (P.token, P.error) Result.t)];
      [%expect {| (Ok Calculate) |}];
      print_s [%sexp (P.process_line "calculate" : (P.token, P.error) Result.t)];
      [%expect {| (Ok Calculate) |}];
      print_s [%sexp (P.process_line "=" : (P.token, P.error) Result.t)];
      [%expect {| (Ok Calculate) |}];
      print_s [%sexp (P.process_line "r" : (P.token, P.error) Result.t)];
      [%expect {| (Ok Reset) |}];
      print_s [%sexp (P.process_line "reset" : (P.token, P.error) Result.t)];
      [%expect {| (Ok Reset) |}];
      print_s [%sexp (P.process_line "quit" : (P.token, P.error) Result.t)];
      [%expect {| (Ok Quit) |}];
      print_s [%sexp (P.process_line "q" : (P.token, P.error) Result.t)];
      [%expect {| (Ok Quit) |}];
      print_s [%sexp (P.process_line "123" : (P.token, P.error) Result.t)];
      [%expect {| (Ok (Number 123)) |}];
      print_s [%sexp (P.process_line "-123" : (P.token, P.error) Result.t)];
      [%expect {| (Ok (Number -123)) |}];
      print_s [%sexp (P.process_line "-0" : (P.token, P.error) Result.t)];
      [%expect {| (Ok (Number -0)) |}];
      print_s [%sexp (P.process_line "0" : (P.token, P.error) Result.t)];
      [%expect {| (Ok (Number 0)) |}];
      [%sexp (P.Empty : P.token)] |> P.token_of_sexp |> P.sexp_of_token |> print_s;
      [%expect {| Empty |}];
      [%sexp (P.Number 123123. : P.token)]
      |> P.token_of_sexp
      |> P.sexp_of_token
      |> print_s;
      [%expect {| (Number 123123) |}];
      [%sexp (P.ParenEmpty : P.token)] |> P.token_of_sexp |> P.sexp_of_token |> print_s;
      [%expect {| ParenEmpty |}];
      [%sexp (P.ParenOneNumber 2131. : P.token)]
      |> P.token_of_sexp
      |> P.sexp_of_token
      |> print_s;
      [%expect {| (ParenOneNumber 2131) |}];
      [%sexp (P.ParenTwoNumbers (12312., 1231.) : P.token)]
      |> P.token_of_sexp
      |> P.sexp_of_token
      |> print_s;
      [%expect {| (ParenTwoNumbers 12312 1231) |}];
      [%sexp (P.NoParensFail : P.error)] |> P.error_of_sexp |> P.sexp_of_error |> print_s;
      [%expect {| NoParensFail |}];
      [%sexp (P.OneNumberFail : P.error)] |> P.error_of_sexp |> P.sexp_of_error |> print_s;
      [%expect {| OneNumberFail |}];
      [%sexp (P.TwoNumberFail : P.error)] |> P.error_of_sexp |> P.sexp_of_error |> print_s;
      [%expect {| TwoNumberFail |}];
      [%sexp (P.TooMany : P.error)] |> P.error_of_sexp |> P.sexp_of_error |> print_s;
      [%expect {| TooMany |}]
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
      let a = V2.make 1. 2. in
      print_s [%sexp (a : V2.t)];
      [%expect {| (1 (2 ())) |}]
    ;;

    let%expect_test "parse vector0" =
      let a =
        Option.(Parser.process_line "()" |> Result.ok >>= V0.of_token |> value_exn)
      in
      print_s [%sexp (a : V0.t)];
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

    let%expect_test "to 100 percent" =
      TrAO.triple_or (module Int) 2 1 1 |> print_bool;
      [%expect {| true |}];
      TrAO.triple_or (module Int) 0 1 0 |> print_bool;
      [%expect {| true |}]
    ;;
  end)
;;
