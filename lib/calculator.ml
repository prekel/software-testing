open Core

module type S = sig
  include Calc.S

  val line_to_action : ?quit:(unit -> never_returns) -> string -> action
end

let q (quit : (unit -> never_returns) option) =
  match quit with
  | Some quit -> never_returns @@ quit ()
  | None -> failwith "Quit"
;;

module CalculatorFloat = struct
  module LF = Calc.MakeStateMachine (Calcs.CalcsFloat)
  include LF

  let line_to_action ?quit line =
    let open LF in
    match Parser.process_line line with
    | Ok token ->
      begin
        match token with
        | Parser.Number num -> Num num
        | ParenEmpty | ParenOneNumber _ | ParenTwoNumbers _ ->
          Invalid (Error.create_s [%message "Wrong token" (token : Parser.token)])
        | OpPlus -> Op `Add
        | OpMinus -> Op `Sub
        | OpMult -> Op `Mult
        | OpDiv -> Op `Div
        | Back -> Back
        | Reset -> Reset
        | Calculate -> Calculate
        | Empty -> Empty
        | Quit -> q quit
      end
    | Error err -> Invalid (Error.create_s [%message "Parse error" (err : Parser.error)])
  ;;
end

module CalculatorInt = struct
  module LF = Calc.MakeStateMachine (Calcs.CalcsInt)
  include LF

  let line_to_action ?quit line =
    let open LF in
    match Parser.process_line line with
    | Ok token ->
      begin
        match token with
        | Parser.Number num -> Num (Int.of_float num)
        | ParenEmpty | ParenOneNumber _ | ParenTwoNumbers _ ->
          Invalid (Error.create_s [%message "Wrong token" (token : Parser.token)])
        | OpPlus -> Op `Add
        | OpMinus -> Op `Sub
        | OpMult -> Op `Mult
        | OpDiv -> Op `Div
        | Back -> Back
        | Reset -> Reset
        | Calculate -> Calculate
        | Empty -> Empty
        | Quit -> q quit
      end
    | Error err -> Invalid (Error.create_s [%message "Parse error" (err : Parser.error)])
  ;;
end

module MakeCalculatorVector
    (Vector : Vector.VECTOR)
    (C : module type of Calcs.MakeCalcsVector (Vector) with type num = Vector.t) =
    struct
  module LF = Calc.MakeStateMachine (C)
  include LF

  let line_to_action ?quit line =
    let open LF in
    match Parser.process_line line with
    | Ok token ->
      begin
        match token with
        | Parser.Number _ ->
          Invalid (Error.create_s [%message "Wrong token" (token : Parser.token)])
        | (ParenEmpty | ParenOneNumber _ | ParenTwoNumbers _) as token ->
          begin
            match Vector.of_token token with
            | Some a -> Num a
            | None ->
              Invalid (Error.create_s [%message "Wrong token" (token : Parser.token)])
          end
        | OpPlus -> Op `Add
        | OpMinus -> Op `Sub
        | OpMult | OpDiv ->
          Invalid (Error.create_s [%message "Wrong token" (token : Parser.token)])
        | Back -> Back
        | Reset -> Reset
        | Calculate -> Calculate
        | Empty -> Empty
        | Quit -> q quit
      end
    | Error err -> Invalid (Error.create_s [%message "Parse error" (err : Parser.error)])
  ;;
end

module CalculatorVector0 = MakeCalculatorVector (Vector.Vector0) (Calcs.CalcsVector0)
module CalculatorVector1 = MakeCalculatorVector (Vector.Vector1) (Calcs.CalcsVector1)
module CalculatorVector2 = MakeCalculatorVector (Vector.Vector2) (Calcs.CalcsVector2)
