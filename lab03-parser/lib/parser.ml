open Core

type token =
  | Number of int
  | Plus
  | Minus
  | Mult
  | Div
  | EmptyString
  | Error 
[@@deriving sexp]

let process_line = function
  | "+" -> Plus
  | "-" -> Minus
  | "*" -> Mult
  | "/" -> Div
  | "" -> EmptyString
  | other ->
    (try Number (Int.of_string other) with
    | _ -> Error)
;;
