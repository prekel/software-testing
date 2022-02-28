open Core
open Bonsai_web
open Bonsai.Let_syntax
module LC = Lab03_parser.Calcs
module LS = Lab03_parser.Calc
module LF = LS.MakeStateMachine (LC.CalcsFloat)
open Lab03_parser

let line_to_action line =
  let open LF in
  let token = line |> Parser.process_line in
  match token with
  | Ok token ->
    begin
      match token with
      | Parser.Number num -> Or_error.return (Num num)
      | ParenEmpty | ParenOneNumber _ | ParenTwoNumbers _ ->
        Or_error.error_s [%sexp `WrongToken]
      | OpPlus -> Or_error.return (Op `Add)
      | OpMinus -> Or_error.return (Op `Sub)
      | OpMult -> Or_error.return (Op `Mult)
      | OpDiv -> Or_error.return (Op `Div)
      | Back -> Or_error.return Back
      | Reset -> Or_error.return Reset
      | Calculate -> Or_error.return Calculate
      | Empty -> Or_error.return Empty
      | Quit -> Or_error.error_s [%sexp `Quit]
    end
  | Error err -> Or_error.error_s [%sexp (err : Parser.error)]
;;

let btn text action update =
  Vdom.Node.button
    ~attr:(Vdom.Attr.on_click (fun _ -> update action))
    [ Vdom.Node.text text ]
;;

let back = btn "back" LF.Back
let calc = btn "calc" LF.Calculate
let empty = btn "empty" LF.Empty
let invalid = btn "invalid" LF.Invalid
let reset = btn "reset" LF.Reset

let btns update =
  Vdom.Node.div [ back update; calc update; empty update; invalid update; reset update ]
;;

let btn (update : (LF.action -> unit Ui_effect.t) Value.t) =
  let%sub text, set_text = Bonsai.state [%here] (module String) ~default_model:"" in
  let%sub errtext, set_errtext = Bonsai.state [%here] (module String) ~default_model:"" in
  let%arr text = text
  and set_text = set_text
  and update = update
  and errtext = errtext
  and set_errtext = set_errtext in
  let update a = Effect.(set_text "" >>= fun () -> update a) in
  Vdom.Node.div
    [ Vdom.Node.input
        ~attr:
          (Vdom.Attr.many
             [ Vdom.Attr.on_input (fun _ -> set_text); Vdom.Attr.value_prop text ])
        []
    ; Vdom.Node.button
        ~attr:
          (Vdom.Attr.on_click (fun _ ->
               match line_to_action text with
               | Ok action -> update action
               | Error err -> err |> Error.to_string_hum |> set_errtext))
        [ Vdom.Node.text "q" ]
    ; btns update
    ; Vdom.Node.pre [ Vdom.Node.text errtext ]
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
