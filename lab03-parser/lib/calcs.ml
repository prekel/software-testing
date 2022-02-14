open Core

module type Calcs = sig
  type num [@@deriving sexp]
  type op [@@deriving sexp]

  val calculate : op -> num -> num -> num option
end

module CalcsInt = struct
  type num = int [@@deriving sexp]

  type op =
    | Add
    | Sub
    | Mult
    | Div
  [@@deriving sexp]

  let calculate op acc arg =
    match op with
    | Add -> Some (acc + arg)
    | Sub -> Some (acc - arg)
    | Mult -> Some (acc * arg)
    | Div -> if arg = 0 then None else Some (acc / arg)
  ;;
end
