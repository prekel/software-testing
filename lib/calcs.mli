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
end) : sig
  include
    Calcs
      with type num = Number.t
       and type op =
        [ `Add
        | `Sub
        | `Mult
        | `Div
        ]
end

module CalcsFloat : module type of MakeCalcsNumber (Core.Float)
module CalcsInt : module type of MakeCalcsNumber (Core.Int)

module MakeCalcsVector (Vector : Vector.VECTOR) : sig
  include
    Calcs
      with type num = Vector.t
       and type op =
        [ `Add
        | `Sub
        ]
end

module CalcsVector0 : module type of MakeCalcsVector (Vector.Vector0)
module CalcsVector1 : module type of MakeCalcsVector (Vector.Vector1)
module CalcsVector2 : module type of MakeCalcsVector (Vector.Vector2)
