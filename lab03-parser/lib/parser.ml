open Core

type error =
  | NoParens
  | OneNumberFail
  | TwoNumberFail
  | TooMany
[@@deriving sexp]

type token =
  | Empty
  | OneNumber of float
  | TwoNumbers of float * float
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
      | [ x ] when String.for_all ~f:Char.is_whitespace x -> Ok Empty
      | [ x ] ->
        begin
          match Caml.Float.of_string_opt x with
          | Some a -> Ok (OneNumber a)
          | None -> Error OneNumberFail
        end
      | [ x; y ] ->
        begin
          match Caml.Float.of_string_opt x, Caml.Float.of_string_opt y with
          | Some a, Some b -> Ok (TwoNumbers (a, b))
          | _ -> Error TwoNumberFail
        end
      | _ -> Error TooMany
    end
  | None -> Error NoParens
;;
