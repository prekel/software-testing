open Core

module MakeCalculator (M : sig
  include Calc.S

  val token_to_action : Parser.token -> (action, [ `Quit | `WrongToken ]) result
end) =
struct
  let rec loop state =
    Out_channel.(print_s [%sexp (state : M.state)]);
    match Stdio.In_channel.(input_line_exn stdin) |> Parser.process_line with
    | Ok token ->
      let action = M.token_to_action token in
      begin
        match action with
        | Ok action -> M.update ~action state |> loop
        | Error `Quit -> M.result state
        | Error `WrongToken -> loop state
      end
    | Error parse_error ->
      Stdio.Out_channel.(
        print_s [%message "Parse error" ~parse_error:(parse_error : Parser.error)]);
      loop state
  ;;

  let run () = loop M.WaitInitial
end

module MakeCalculatorS (M : sig
  type t
end) =
struct
  type _t = M.t

  let run = assert false
end

module CalculatorFloat = MakeCalculator (struct
  include Calc.MakeStateMachine (Calcs.CalcsFloat)

  let token_to_action = function
    | Parser.Number num -> Ok (Num num)
    | ParenEmpty | ParenOneNumber _ | ParenTwoNumbers _ -> Error `WrongToken
    | OpPlus -> Ok (Op `Add)
    | OpMinus -> Ok (Op `Sub)
    | OpMult -> Ok (Op `Mult)
    | OpDiv -> Ok (Op `Div)
    | Back -> Ok Back
    | Reset -> Ok Reset
    | Calculate -> Ok Calculate
    | Empty -> Ok Empty
    | Quit -> Error `Quit
  ;;
end)

module CalculatorVector0 = MakeCalculator (struct
  include Calc.MakeStateMachine (Calcs.CalcsVector0)

  let token_to_action = function
    | Parser.Number _ -> Error `WrongToken
    | ParenEmpty -> Ok (Num Vector.Vector0.make)
    | ParenOneNumber _ | ParenTwoNumbers _ -> Error `WrongToken
    | OpPlus -> Ok (Op `Add)
    | OpMinus -> Ok (Op `Sub)
    | OpMult | OpDiv -> Error `WrongToken
    | Back -> Ok Back
    | Reset -> Ok Reset
    | Calculate -> Ok Calculate
    | Empty -> Ok Empty
    | Quit -> Error `Quit
  ;;
end)

module CalculatorVector1 = MakeCalculator (struct
  include Calc.MakeStateMachine (Calcs.CalcsVector1)

  let token_to_action = function
    | Parser.Number _ -> Error `WrongToken
    | ParenEmpty -> Error `WrongToken
    | ParenOneNumber x -> Ok (Num (Vector.Vector1.make x))
    | ParenTwoNumbers _ -> Error `WrongToken
    | OpPlus -> Ok (Op `Add)
    | OpMinus -> Ok (Op `Sub)
    | OpMult | OpDiv -> Error `WrongToken
    | Back -> Ok Back
    | Reset -> Ok Reset
    | Calculate -> Ok Calculate
    | Empty -> Ok Empty
    | Quit -> Error `Quit
  ;;
end)

module CalculatorVector2 = MakeCalculator (struct
  include Calc.MakeStateMachine (Calcs.CalcsVector2)

  let token_to_action = function
    | Parser.Number _ -> Error `WrongToken
    | ParenEmpty -> Error `WrongToken
    | ParenOneNumber _ -> Error `WrongToken
    | ParenTwoNumbers (x, y) -> Ok (Num (Vector.Vector2.make x y))
    | OpPlus -> Ok (Op `Add)
    | OpMinus -> Ok (Op `Sub)
    | OpMult | OpDiv -> Error `WrongToken
    | Back -> Ok Back
    | Reset -> Ok Reset
    | Calculate -> Ok Calculate
    | Empty -> Ok Empty
    | Quit -> Error `Quit
  ;;
end)
