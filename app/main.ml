open Core
open Bonsai_web
open Bonsai.Let_syntax
open Js_of_ocaml
open Lab_calculator

let quit () : never_returns =
  Dom_html.window##.location##reload;
  failwith "Quit"
;;

module MakeComponent (LF : Calculator.S) = struct
  let btn text action update =
    Vdom.(Node.button ~attr:(Attr.on_click (fun _ -> update action)) [ Node.text text ])
  ;;

  let back = btn "back" LF.Back
  let calc = btn "calc" LF.Calculate
  let empty = btn "empty" LF.Empty
  let invalid = btn "invalid" (LF.Invalid (Error.create_s (Sexp.Atom "")))
  let reset = btn "reset" LF.Reset

  let quit =
    Vdom.(
      Node.button
        ~attr:(Attr.on_click (fun _ -> never_returns @@ quit ()))
        [ Node.text "quit" ])
  ;;

  let btns update =
    Vdom.(
      Node.div
        [ back update; calc update; empty update; invalid update; reset update; quit ])
  ;;

  let btn update =
    let%sub text, set_text = Bonsai.state [%here] (module String) ~default_model:"" in
    let%arr text = text
    and set_text = set_text
    and update = update in
    let update a = Effect.(set_text "" >>= fun () -> update a) in
    let on_enter () = LF.line_to_action text |> update in
    Vdom.(
      Node.div
        [ Node.create
            "form"
            ~attr:
              (Attr.on_submit (fun _ ->
                   Effect.Many
                     [ Vdom.Effect.Prevent_default
                     ; Vdom.Effect.Stop_propagation
                     ; on_enter ()
                     ]))
            [ Node.input
                ~attr:
                  (Attr.many [ Attr.on_input (fun _ -> set_text); Attr.value_prop text ])
                []
            ]
        ; Node.button ~attr:(Attr.on_click (fun _ -> on_enter ())) [ Node.text "enter" ]
        ; btns update
        ])
  ;;

  let statelf =
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
    Vdom.(
      Node.div
        [ Node.pre [ [%sexp (state : LF.state)] |> Sexp.to_string_hum |> Node.text ]
        ; btn
        ])
  ;;
end

module LF = MakeComponent (Calculator.CalculatorFloat)
module LI = MakeComponent (Calculator.CalculatorInt)
module L0 = MakeComponent (Calculator.CalculatorVector0)
module L1 = MakeComponent (Calculator.CalculatorVector1)
module L2 = MakeComponent (Calculator.CalculatorVector2)

module Var = struct
  type t =
    | Float
    | Int
    | Vector0
    | Vector1
    | Vector2
  [@@deriving sexp, equal]
end

let component =
  let%sub state, set_state = Bonsai.state [%here] (module Var) ~default_model:Var.Float in
  let name = "variants" in
  let%sub lf = LF.statelf in
  let%sub li = LI.statelf in
  let%sub l0 = L0.statelf in
  let%sub l1 = L1.statelf in
  let%sub l2 = L2.statelf in
  let%arr state = state
  and set_state = set_state
  and lf = lf
  and li = li
  and l0 = l0
  and l1 = l1
  and l2 = l2 in
  Vdom.(
    let radio v a =
      Node.div
        [ Node.input
            ~attr:
              (Attr.many
                 [ Attr.type_ "radio"
                 ; Attr.name name
                 ; Attr.value v
                 ; Attr.on_change (fun _ _ -> set_state a)
                 ; (if [%equal: Var.t] state a then Attr.checked else Attr.empty)
                 ])
            []
        ; Node.label [ Node.text v ]
        ]
    in
    Node.div
      [ (match state with
        | Float -> lf
        | Int -> li
        | Vector0 -> l0
        | Vector1 -> l1
        | Vector2 -> l2)
      ; radio "float" Float
      ; radio "int" Int
      ; radio "vector0" Vector0
      ; radio "vector1" Vector1
      ; radio "vector2" Vector2
      ])
;;

let (_ : _ Start.Handle.t) =
  Start.start Start.Result_spec.just_the_view ~bind_to_element_with_id:"app" component
;;
