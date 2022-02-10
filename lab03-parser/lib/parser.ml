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
  | Error of error
[@@deriving sexp]

let process_line line =
  let par =
    Option.Let_syntax.(
      let%bind wop = String.chop_prefix ~prefix:"(" line in
      String.chop_suffix ~suffix:")" wop)
  in
  match par with
  | Some l ->
    let splitted = l |> String.split ~on:',' in
    begin
      match splitted with
      | [] -> assert false
      | [ x ] when String.for_all ~f:Char.is_whitespace x -> Empty
      | [ x ] ->
        begin
          match Caml.Float.of_string_opt x with
          | Some a -> OneNumber a
          | None -> Error OneNumberFail
        end
      | [ x; y ] ->
        begin
          match Caml.Float.of_string_opt x, Caml.Float.of_string_opt y with
          | Some a, Some b -> TwoNumbers (a, b)
          | _ -> Error TwoNumberFail
        end
      | _ -> Error TooMany
    end
  | None -> Error NoParens
;;
