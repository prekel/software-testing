open Core
open Bonsai_web
open Bonsai.Let_syntax
open Lab03_parser
module LC = Calcs
module LS = Calc
(* module LF = LS.MakeStateMachine (LC.CalcsFloat) *)

let quit () =
  Js_of_ocaml.Dom_html.window##.location##reload;
  failwith "Quit"
;;

module MakeComponent (LF : sig
  include LS.S

  val line_to_action : string -> action
end) =
struct
  let btn text action update =
    Vdom.(Node.button ~attr:(Attr.on_click (fun _ -> update action)) [ Node.text text ])
  ;;

  let back = btn "back" LF.Back
  let calc = btn "calc" LF.Calculate
  let empty = btn "empty" LF.Empty
  let invalid = btn "invalid" (LF.Invalid (Error.create_s (Sexp.Atom "")))
  let reset = btn "reset" LF.Reset

  let quit =
    Vdom.(Node.button ~attr:(Attr.on_click (fun _ -> quit ())) [ Node.text "quit" ])
  ;;

  let btns update =
    Vdom.(
      Node.div
        [ back update; calc update; empty update; invalid update; reset update; quit ])
  ;;

  let btn update =
    let%sub text, set_text = Bonsai.state [%here] (module String) ~default_model:"" in
    let%sub errtext, set_errtext =
      Bonsai.state [%here] (module String) ~default_model:""
    in
    let%arr text = text
    and set_text = set_text
    and update = update
    and errtext = errtext
    and _set_errtext = set_errtext in
    let update a = Effect.(set_text "" >>= fun () -> update a) in
    let on_enter () = LF.line_to_action text |> update in
    Vdom.(
      Node.div
        [ Node.create
            "form"
            ~attr:
              (Attr.on_submit (fun _ ->
                   Effect.Many
                     [ on_enter ()
                     ; Vdom.Effect.Prevent_default
                     ; Vdom.Effect.Stop_propagation
                     ]))
            [ Node.input
                ~attr:
                  (Attr.many [ Attr.on_input (fun _ -> set_text); Attr.value_prop text ])
                []
            ]
        ; Node.button ~attr:(Attr.on_click (fun _ -> on_enter ())) [ Node.text "enter" ]
        ; btns update
        ; Node.pre [ Node.text errtext ]
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

module LF = MakeComponent (struct
  module LF = LS.MakeStateMachine (LC.CalcsFloat)
  include LF

  let line_to_action line =
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
        | Quit -> quit ()
      end
    | Error err -> Invalid (Error.create_s [%message "Parse error" (err : Parser.error)])
  ;;
end)

module LI = MakeComponent (struct
  module LF = LS.MakeStateMachine (LC.CalcsInt)
  include LF

  let line_to_action line =
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
        | Quit -> quit ()
      end
    | Error err -> Invalid (Error.create_s [%message "Parse error" (err : Parser.error)])
  ;;
end)

module MakeVectorComponet
    (Vector : Vector.VECTOR)
    (C : module type of LC.MakeCalcsVector (Vector) with type num = Vector.t) =
    MakeComponent (struct
  module LF = LS.MakeStateMachine (C)
  include LF

  let line_to_action line =
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
        | Quit -> quit ()
      end
    | Error err -> Invalid (Error.create_s [%message "Parse error" (err : Parser.error)])
  ;;
end)

module L0 = MakeVectorComponet (Vector.Vector0) (LC.CalcsVector0)
module L1 = MakeVectorComponet (Vector.Vector1) (LC.CalcsVector1)
module L2 = MakeVectorComponet (Vector.Vector2) (LC.CalcsVector2)

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
  let name = "abc" in
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
  let radio v a =
    Vdom.(
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
        ])
  in
  Vdom.(
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
