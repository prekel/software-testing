open Core
open Lab03_parser
open Calcs

module MakeHistoryCalcsMock (Calcs : Calcs) = struct
  include Calcs

  let history = Stack.create ()

  let calculate op acc arg =
    Stack.push history (op, acc, arg);
    Calcs.calculate op acc arg
  ;;
end

module MakePrintAndUpdate (CalcStateMachine : Calc.S) = struct
  let print_and_update action state =
    print_s [%sexp (state : CalcStateMachine.State.t)];
    CalcStateMachine.update ~action state
  ;;
end

let%test_module "" =
  (module struct
    module CalcsMock = MakeHistoryCalcsMock (CalcsInt)
    module MockStateMachine = Calc.MakeStateMachine (CalcsMock)
    open MakePrintAndUpdate (MockStateMachine)

    let%expect_test "test1" =
      Stack.clear CalcsMock.history;
      let final =
        MockStateMachine.initial
        |> print_and_update (MockStateMachine.Action.Num 1)
        |> print_and_update (MockStateMachine.Action.Op `Add)
        |> print_and_update (MockStateMachine.Action.Num 40)
        |> print_and_update MockStateMachine.Action.Calculate
        |> print_and_update MockStateMachine.Action.Empty
      in
      [%expect {|
        WaitInitial
        (WaitOperation (acc 1))
        (WaitArgument (acc 1) (op Add))
        (Calculation (acc 1) (op Add) (arg 40))
        (WaitOperation (acc 41)) |}];
      print_s [%sexp (final : MockStateMachine.State.t)];
      [%expect {| (Finish 41) |}];
      print_s [%sexp (MockStateMachine.result final : int option)];
      [%expect {| (41) |}];
      print_s [%sexp (CalcsMock.history : (CalcsInt.op * int * int) Stack.t)];
      [%expect {| ((Add 1 40)) |}]
    ;;

    let%expect_test "test1" =
      Stack.clear CalcsMock.history;
      let final =
        MockStateMachine.initial
        |> print_and_update (MockStateMachine.Action.Num 1)
        |> print_and_update (MockStateMachine.Action.Op `Add)
        |> print_and_update (MockStateMachine.Action.Op `Add)
        |> print_and_update (MockStateMachine.Action.Num 40)
        |> print_and_update MockStateMachine.Action.Calculate
        |> print_and_update MockStateMachine.Action.Empty
      in
      [%expect {|
        WaitInitial
        (WaitOperation (acc 1))
        (WaitArgument (acc 1) (op Add))
        (ErrorState (WaitArgument (acc 1) (op Add)))
        (ErrorState (WaitArgument (acc 1) (op Add)))
        (ErrorState (WaitArgument (acc 1) (op Add))) |}];
      print_s [%sexp (final : MockStateMachine.State.t)];
      [%expect {| (ErrorState (WaitArgument (acc 1) (op Add))) |}];
      print_s [%sexp (MockStateMachine.result final : int option)];
      [%expect {| () |}];
      print_s [%sexp (CalcsMock.history : (CalcsInt.op * int * int) Stack.t)];
      [%expect {| () |}]
    ;;

    let%expect_test "test1" =
      Stack.clear CalcsMock.history;
      let final =
        MockStateMachine.initial
        |> print_and_update (MockStateMachine.Action.Num 2)
        |> print_and_update (MockStateMachine.Action.Op `Mult)
        |> print_and_update (MockStateMachine.Action.Num (-40))
        |> print_and_update MockStateMachine.Action.Calculate
        |> print_and_update MockStateMachine.Action.Empty
      in
      [%expect {|
        WaitInitial
        (WaitOperation (acc 2))
        (WaitArgument (acc 2) (op Mult))
        (Calculation (acc 2) (op Mult) (arg -40))
        (WaitOperation (acc -80)) |}];
      print_s [%sexp (final : MockStateMachine.State.t)];
      [%expect {| (Finish -80) |}];
      print_s [%sexp (MockStateMachine.result final : int option)];
      [%expect {| (-80) |}];
      print_s [%sexp (CalcsMock.history : (CalcsInt.op * int * int) Stack.t)];
      [%expect {| ((Mult 2 -40)) |}]
    ;;
  end)
;;
