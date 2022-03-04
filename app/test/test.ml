open Core
(* open Lab_calculator_app_lib.Lib *)

let%test_module "q" =
  (module struct
    let%expect_test "w" =
      print_string "1231";
      [%expect {| 1231 |}]
    ;;
  end)
;;
