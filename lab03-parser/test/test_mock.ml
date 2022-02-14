open Core
module V0 = Lab03_parser.Vector.Vector0

module CalcsInt = struct
  type num = int [@@deriving sexp]

  type op =
    | Add
    | Sub
    | Mult
    | Div
  [@@deriving sexp]

  let calculate op acc arg =
    match op with
    | Add -> Some (acc + arg)
    | Sub -> Some (acc - arg)
    | Mult -> Some (acc * arg)
    | Div -> if arg = 0 then None else Some (acc / arg)
  ;;
end

module MakeCalcsMock (Calcs : Lab03_parser.Calc.Calcs) = struct
  include Calcs

  let history = Stack.create ()

  let calculate op acc arg =
    Stack.push history (op, acc, arg);
    Calcs.calculate op acc arg
  ;;
end

module CalcsMock = MakeCalcsMock (CalcsInt)
module MockStateMachine = Lab03_parser.Calc.StateMachine (CalcsMock)

let update_and_print action state =
  print_s [%sexp (state : MockStateMachine.State.t)];
  let new_state = MockStateMachine.update state action in
  new_state
;;

let%expect_test "test1" =
  Stack.clear CalcsMock.history;
  let final =
    MockStateMachine.initial
    |> update_and_print (MockStateMachine.Action.Num 1)
    |> update_and_print (MockStateMachine.Action.Op Add)
    |> update_and_print (MockStateMachine.Action.Num 40)
    |> update_and_print MockStateMachine.Action.Calculate
    |> update_and_print MockStateMachine.Action.Empty
  in
  [%expect
    {|
    WaitInitial
    (WaitOperation (acc 1) (acc' 1))
    (WaitArgument (acc 1) (acc' 1) (op Add))
    (Calculation (acc 1) (acc' 1) (op Add) (arg 40))
    (WaitOperation (acc 41) (acc' 1)) |}];
  print_s [%sexp (final : MockStateMachine.State.t)];
  [%expect {| (Finish 41) |}];
  print_s [%sexp (CalcsMock.history : (CalcsInt.op * int * int) Stack.t)];
  [%expect {| ((Add 1 40)) |}]
;;

let%expect_test "test1" =
  Stack.clear CalcsMock.history;
  let final =
    MockStateMachine.initial
    |> update_and_print (MockStateMachine.Action.Num 1)
    |> update_and_print (MockStateMachine.Action.Op Add)
    |> update_and_print (MockStateMachine.Action.Op Add)
    |> update_and_print (MockStateMachine.Action.Num 40)
    |> update_and_print MockStateMachine.Action.Calculate
    |> update_and_print MockStateMachine.Action.Empty
  in
  [%expect
    {|
    WaitInitial
    (WaitOperation (acc 1) (acc' 1))
    (WaitArgument (acc 1) (acc' 1) (op Add))
    (ErrorState (WaitArgument (acc 1) (acc' 1) (op Add)))
    (ErrorState (WaitArgument (acc 1) (acc' 1) (op Add)))
    (ErrorState (WaitArgument (acc 1) (acc' 1) (op Add))) |}];
  print_s [%sexp (final : MockStateMachine.State.t)];
  [%expect {| (ErrorState (WaitArgument (acc 1) (acc' 1) (op Add))) |}];
  print_s [%sexp (CalcsMock.history : (CalcsInt.op * int * int) Stack.t)];
  [%expect {| () |}]
;;
