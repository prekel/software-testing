open Core

module CalculatorFloat = struct
  module M = Calc.MakeStateMachine (Calcs.CalcsFloat)

  let rec cycle state =
    Stdio.Out_channel.(print_s [%sexp (state : M.state)]);
    match Stdio.In_channel.(input_line_exn stdin) |> Parser.process_line with
    | Ok token ->
      let action =
        match token with
        | Number num -> Ok (M.Num num)
        | ParenEmpty | ParenOneNumber _ | ParenTwoNumbers _ -> Error (Some None)
        | OpPlus -> Ok (M.Op `Add)
        | OpMinus -> Ok (M.Op `Sub)
        | OpMult -> Ok (M.Op `Mult)
        | OpDiv -> Ok (M.Op `Div)
        | Back -> Ok M.Back
        | Reset -> Ok M.Reset
        | Calculate -> Ok M.Calculate
        | Empty -> Ok M.Empty
        | Quit -> Error None
      in
      (match action with
      | Ok action -> M.update ~action state |> cycle
      | Error None -> M.result state
      | Error _ -> cycle state)
    | Error parse_error ->
      Stdio.Out_channel.(
        print_s [%message "Parse error" ~parse_error:(parse_error : Parser.error)]);
      cycle state
  ;;

  let run () = cycle M.WaitInitial
end
