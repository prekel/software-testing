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

module CalcsFloat : sig
  include
    Calcs
      with type num = float
       and type op =
        [ `Add
        | `Sub
        | `Mult
        | `Div
        ]
end

module CalcsInt : sig
  include
    Calcs
      with type num = int
       and type op =
        [ `Add
        | `Sub
        | `Mult
        | `Div
        ]
end

module MakeCalcsVector (Vector : Vector.VECTOR) : sig
  include
    Calcs
      with type num = Vector.t
       and type op =
        [ `Add
        | `Sub
        ]
end

module CalcsVector0 : sig
  include
    Calcs
      with type num = Vector.Vector0.t
       and type op =
        [ `Add
        | `Sub
        ]
end

module CalcsVector1 : sig
  include
    Calcs
      with type num = Vector.Vector1.t
       and type op =
        [ `Add
        | `Sub
        ]
end

module CalcsVector2 : sig
  include
    Calcs
      with type num = Vector.Vector2.t
       and type op =
        [ `Add
        | `Sub
        ]
end
