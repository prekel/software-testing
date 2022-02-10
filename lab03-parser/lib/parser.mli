(** [error] represents the parsing error *)
type error =
  | NoParens
  | OneNumberFail
  | TwoNumberFail
  | TooMany
[@@deriving sexp]

(** [token] represents the parsed token *)
type token =
  | Empty
  | OneNumber of float
  | TwoNumbers of float * float
[@@deriving sexp]

(** [process_line str] returns parsed token *)
val process_line : string -> (token, error) result
