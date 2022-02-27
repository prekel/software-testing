open Core

module type Calcs = sig
  type num [@@deriving sexp, equal]
  type op [@@deriving sexp, equal]

  val calculate : op -> num -> num -> num option
end

module MakeCalcsNumber (Number : sig
  type t [@@deriving sexp, equal]

  val ( + ) : t -> t -> t
  val ( - ) : t -> t -> t
  val ( * ) : t -> t -> t
  val ( / ) : t -> t -> t
end) =
struct
  type num = Number.t [@@deriving sexp, equal]

  type op =
    [ `Add
    | `Sub
    | `Mult
    | `Div
    ]
  [@@deriving sexp, equal]

  let calculate op acc arg =
    let open Number in
    match op with
    | `Add -> Some (acc + arg)
    | `Sub -> Some (acc - arg)
    | `Mult -> Some (acc * arg)
    | `Div ->
      begin
        try Some (acc / arg) with
        | _ -> None
      end
  ;;
end

module CalcsFloat = MakeCalcsNumber (Float)
module CalcsInt = MakeCalcsNumber (Int)

module MakeCalcsVector (Vector : Vector.VECTOR) = struct
  type num = Vector.t [@@deriving sexp, equal]

  type op =
    [ `Add
    | `Sub
    ]
  [@@deriving sexp, equal]

  let calculate op acc arg =
    let open Vector.Infix in
    match op with
    | `Add -> Some (acc + arg)
    | `Sub -> Some (acc - arg)
  ;;
end

module CalcsVector0 = MakeCalcsVector (Vector.Vector0)
module CalcsVector1 = MakeCalcsVector (Vector.Vector1)
module CalcsVector2 = MakeCalcsVector (Vector.Vector2)
