open Core

module type Calcs = sig
  type num [@@deriving sexp]
  type op [@@deriving sexp]

  val calculate : op -> num -> num -> num option
end

module MakeCalcsNumber (Number : sig
  type t [@@deriving sexp]

  val ( + ) : t -> t -> t
  val ( - ) : t -> t -> t
  val ( * ) : t -> t -> t
  val ( / ) : t -> t -> t
end) =
struct
  type num = Number.t [@@deriving sexp]

  type op =
    [ `Add
    | `Sub
    | `Mult
    | `Div
    ]
  [@@deriving sexp]

  let calculate op acc arg =
    let open Number in
    match op with
    | `Add -> Some (acc + arg)
    | `Sub -> Some (acc - arg)
    | `Mult -> Some (acc * arg)
    | `Div ->
      (try Some (acc / arg) with
      | _ -> None)
  ;;
end

module CalcsFloat = MakeCalcsNumber (Float)

module CalcsInt = MakeCalcsNumber (Int)
