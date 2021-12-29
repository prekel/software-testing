(** [token] represents the parsed token *)
type token =
  | Number of int
  | Plus
  | Minus
  | Mult
  | Div
  | EmptyString
  | Error

(** [token_pp ppf tkn] pretty-prints token [tkn] using formatter [ppf] *)
val token_pp : Formatter.t -> token -> unit

(** [process_line str] returns parsed token *)
val process_line : string -> token
