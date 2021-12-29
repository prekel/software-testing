type token =
  | Number of int
  | Plus
  | Minus
  | Mult
  | Div
  | EmptyString
  | Error

let token_pp ppf =
  let open Caml.Format in
  function
  | Number n -> fprintf ppf "Number(%d)" n
  | Plus -> fprintf ppf "Plus"
  | Minus -> fprintf ppf "Minus"
  | Mult -> fprintf ppf "Mult"
  | Div -> fprintf ppf "Div"
  | EmptyString -> fprintf ppf "EmptyString"
  | Error -> fprintf ppf "Error"
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
