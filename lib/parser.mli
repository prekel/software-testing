(** [error] represents the parsing error *)
type error =
  | NoParensFail
  | OneNumberFail
  | TwoNumberFail
  | TooMany
[@@deriving sexp]

(** [token] represents the parsed token *)
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

(** [process_line str] returns parsed token *)
val process_line : string -> (token, error) result
