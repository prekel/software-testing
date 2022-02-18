open Core

type error =
  | NoParensFail
  | OneNumberFail
  | TwoNumberFail
  | TooMany
[@@deriving sexp]

type token =
  | Empty
  | Number of float
  | ParenEmpty
  | ParenOneNumber of float
  | ParenTwoNumbers of float * float
  | OpPlus
  | OpMinus
  | OpMult
  | OpDiv
  | Back
  | Reset
  | Calculate
  | Quit
[@@deriving sexp]

let process_line line =
  let without_parens =
    Option.Let_syntax.(
      let%bind without_prefix = String.chop_prefix ~prefix:"(" line in
      String.chop_suffix ~suffix:")" without_prefix)
  in
  match without_parens with
  | Some l ->
    let splitted = l |> String.split ~on:',' in
    begin
      match splitted with
      | [] ->
        (* String.split cannot return empty list *)
        assert false
      | [ x ] when String.for_all ~f:Char.is_whitespace x -> Ok ParenEmpty
      | [ x ] ->
        begin
          match Caml.Float.of_string_opt x with
          | Some a -> Ok (ParenOneNumber a)
          | None -> Error OneNumberFail
        end
      | [ x; y ] ->
        begin
          match Caml.Float.of_string_opt x, Caml.Float.of_string_opt y with
          | Some a, Some b -> Ok (ParenTwoNumbers (a, b))
          | _ -> Error TwoNumberFail
        end
      | _ -> Error TooMany
    end
  | None ->
    (match line with
    | "" -> Ok Empty
    | "+" -> Ok OpPlus
    | "-" -> Ok OpMinus
    | "*" -> Ok OpMult
    | "/" -> Ok OpDiv
    | "b" | "back" -> Ok Back
    | "c" | "calc" | "calculate" | "=" -> Ok Calculate
    | "r" | "reset" -> Ok Reset
    | "q" | "quit" -> Ok Quit
    | l ->
      (match Caml.Float.of_string_opt l with
      | Some num -> Ok (Number num)
      | None -> Error NoParensFail))
;;
