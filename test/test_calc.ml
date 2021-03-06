open Core
open Lab_calculator
open Calcs

module MakePrintAndUpdate (CalcStateMachine : Calc.S) = struct
  let print_and_update action state =
    print_s [%sexp (state : CalcStateMachine.state)];
    CalcStateMachine.update ~action state
  ;;
end

let%test_module "test with mock" =
  (module struct
    module MakeHistoryCalcsMock (Calcs : Calcs) = struct
      include Calcs

      let history = Stack.create ()

      let calculate op acc arg =
        Stack.push history (op, acc, arg);
        Calcs.calculate op acc arg
      ;;
    end

    module CalcsMock = MakeHistoryCalcsMock (CalcsInt)
    module MockStateMachine = Calc.MakeStateMachine (CalcsMock)
    open MakePrintAndUpdate (MockStateMachine)

    let%expect_test "test1" =
      Stack.clear CalcsMock.history;
      let final =
        MockStateMachine.initial
        |> print_and_update (MockStateMachine.Num 1)
        |> print_and_update (MockStateMachine.Op `Add)
        |> print_and_update (MockStateMachine.Num 40)
        |> print_and_update MockStateMachine.Calculate
        |> print_and_update MockStateMachine.Empty
      in
      [%expect
        {|
        WaitInitial
        (WaitOperation (acc 1))
        (WaitArgument (acc 1) (op Add))
        (Calculation (acc 1) (op Add) (arg 40))
        (WaitOperation (acc 41)) |}];
      print_s [%sexp (final : MockStateMachine.state)];
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
        |> print_and_update (MockStateMachine.Num 1)
        |> print_and_update (MockStateMachine.Op `Add)
        |> print_and_update (MockStateMachine.Op `Add)
        |> print_and_update (MockStateMachine.Num 40)
        |> print_and_update MockStateMachine.Calculate
        |> print_and_update MockStateMachine.Empty
      in
      [%expect
        {|
        WaitInitial
        (WaitOperation (acc 1))
        (WaitArgument (acc 1) (op Add))
        (ErrorState (WaitArgument (acc 1) (op Add)))
        (ErrorState (WaitArgument (acc 1) (op Add)))
        (ErrorState (WaitArgument (acc 1) (op Add))) |}];
      print_s [%sexp (final : MockStateMachine.state)];
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
        |> print_and_update (MockStateMachine.Num 2)
        |> print_and_update (MockStateMachine.Op `Mult)
        |> print_and_update (MockStateMachine.Num (-40))
        |> print_and_update MockStateMachine.Calculate
        |> print_and_update MockStateMachine.Empty
      in
      [%expect
        {|
        WaitInitial
        (WaitOperation (acc 2))
        (WaitArgument (acc 2) (op Mult))
        (Calculation (acc 2) (op Mult) (arg -40))
        (WaitOperation (acc -80)) |}];
      print_s [%sexp (final : MockStateMachine.state)];
      [%expect {| (Finish -80) |}];
      print_s [%sexp (MockStateMachine.result final : int option)];
      [%expect {| (-80) |}];
      print_s [%sexp (CalcsMock.history : (CalcsInt.op * int * int) Stack.t)];
      [%expect {| ((Mult 2 -40)) |}]
    ;;
  end)
;;

let%test_module "stub test" =
  (module struct
    module FloatCalcsStub = struct
      include CalcsFloat

      let calculate op acc arg =
        match op, acc, arg with
        | `Add, 1., 2. -> Some 0.
        | _ -> assert false
      ;;
    end

    module StubStateMachine = Calc.MakeStateMachine (FloatCalcsStub)
    open MakePrintAndUpdate (StubStateMachine)

    let%expect_test "test1" =
      let final =
        StubStateMachine.initial
        |> print_and_update (StubStateMachine.Num 1.)
        |> print_and_update (StubStateMachine.Op `Add)
        |> print_and_update (StubStateMachine.Num 2.)
        |> print_and_update StubStateMachine.Calculate
        |> print_and_update StubStateMachine.Empty
      in
      [%expect
        {|
        WaitInitial
        (WaitOperation (acc 1))
        (WaitArgument (acc 1) (op Add))
        (Calculation (acc 1) (op Add) (arg 2))
        (WaitOperation (acc 0)) |}];
      print_s [%sexp (final : StubStateMachine.state)];
      [%expect {| (Finish 0) |}];
      print_s [%sexp (StubStateMachine.result final : float option)];
      [%expect {| (0) |}]
    ;;
  end)
;;
