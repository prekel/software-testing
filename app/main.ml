open Core
open Bonsai_web
open Bonsai.Let_syntax
module LC = Lab03_parser.Calcs
module LS = Lab03_parser.Calc
module LF = LS.MakeStateMachine (LC.CalcsFloat)

(* let line_to_action line = line |> Parser.process_line |> Result.(>>=) (function |
   Parser.Number _ -> Error `WrongToken | (ParenEmpty | ParenOneNumber _ | ParenTwoNumbers
   _) as token -> begin match Vector.of_token token with | Some a -> Ok (Num a) | None ->
   Error `WrongToken end | OpPlus -> Ok (Op `Add) | OpMinus -> Ok (Op `Sub) | OpMult |
   OpDiv -> Error `WrongToken | Back -> Ok Back | Reset -> Ok Reset | Calculate -> Ok
   Calculate | Empty -> Ok Empty | Quit -> Error `Quit) ;; *)

let btn update =
  let%sub text, set_text = Bonsai.state [%here] (module String) ~default_model:"" in
  let%arr text = text
  and set_text = set_text
  and update = update in
  Vdom.Node.div
    [ Vdom.Node.input
        ~attr:
          (Vdom.Attr.many
             [ Vdom.Attr.on_input (fun _ -> set_text); Vdom.Attr.value_prop text ])
        []
    ; Vdom.Node.button
        ~attr:
          (Vdom.Attr.on_click (fun _ ->
               update
               @@
               match text with
               | "1" -> LF.Num 1.
               | "+" -> LF.Op `Add
               | _ -> LF.Reset))
        [ Vdom.Node.text "q" ]
    ]
;;

let statelf () =
  let%sub state, update =
    Bonsai.state_machine0
      [%here]
      (module struct
        type t = LF.state [@@deriving sexp, equal]
      end)
      (module struct
        type t = LF.action [@@deriving sexp, equal]
      end)
      ~default_model:LF.initial
      ~apply_action:(fun ~inject:_ ~schedule_event:_ state action ->
        LF.update ~action state)
  in
  let%sub btn = btn update in
  let%arr state = state
  and btn = btn in
  Vdom.Node.div
    [ Vdom.Node.pre [ [%sexp (state : LF.state)] |> Sexp.to_string_hum |> Vdom.Node.text ]
    ; btn
    ]
;;

let component = statelf ()

let (_ : _ Start.Handle.t) =
  Start.start Start.Result_spec.just_the_view ~bind_to_element_with_id:"app" component
;;
