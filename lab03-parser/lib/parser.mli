(** [token] represents the parsed token *)
type token =
  | Number of int
  | Plus
  | Minus
  | Mult
  | Div
  | EmptyString
  | Error
[@@deriving sexp]

(** [process_line str] returns parsed token *)
val process_line : string -> token
