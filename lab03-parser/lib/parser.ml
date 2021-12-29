type token =
  | Number of int
  | Plus
  | Minus
  | Mult
  | Div
  | EmptyString
  | Error

let token_to_string = function
  | Number n -> "Number" ^ Int.to_string n
  | Plus -> "Plus"
  | Minus -> "Minus"
  | Mult -> "Mult"
  | Div -> "Div"
  | EmptyString -> "EmptyString"
  | Error -> "Error"
;;

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
