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

  open Lwt
  open Lwt.Let_syntax

  let rec loop' ~stream ~mvar state =
    let%bind () = Lwt_mvar.put mvar (Sexp.to_string_hum [%sexp (state : M.state)]) in
    match%bind Lwt_stream.next stream >|= Parser.process_line with
    | Ok token ->
      let action = M.token_to_action token in
      begin
        match action with
        | Ok action -> M.update ~action state |> loop' ~stream ~mvar
        | Error `Quit -> return (M.result state)
        | Error `WrongToken -> loop' ~stream ~mvar state
      end
    | Error parse_error ->
      let%bind () =
        Lwt_mvar.put
          mvar
          (Sexp.to_string_hum
             [%message "Parse error" ~parse_error:(parse_error : Parser.error)])
      in
      loop' ~stream ~mvar state
  ;;

  let run' () =
    let stream = Lwt_stream.from (fun () -> Lwt_io.(read_line stdin) >|= Option.some) in
    let mvar = Lwt_mvar.create_empty () in
    let rec pr () =
      let%bind v = Lwt_mvar.take mvar in
      let%bind () = Lwt_io.printl v in
      pr ()
    in
    Lwt.pick [ loop' ~stream ~mvar M.WaitInitial; pr () ]
  ;;
end

module MakeCalculatorS (M : sig
  type t
end) =
struct
  type _t = M.t

  let run = assert false
  let run' = assert false
end

module MakeCalculatorVector (Vector : Vector.VECTOR) = struct
  include MakeCalculator (struct
    include Calc.MakeStateMachine (Calcs.MakeCalcsVector (Vector))

    let token_to_action = function
      | Parser.Number _ -> Error `WrongToken
      | (ParenEmpty | ParenOneNumber _ | ParenTwoNumbers _) as token ->
        (match Vector.of_token token with
        | Some a -> Ok (Num a)
        | None -> Error `WrongToken)
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

module CalculatorVector0 = MakeCalculatorVector (Vector.Vector0)
module CalculatorVector1 = MakeCalculatorVector (Vector.Vector1)
module CalculatorVector2 = MakeCalculatorVector (Vector.Vector2)
