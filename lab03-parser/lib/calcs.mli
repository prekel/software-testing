module type Calcs = sig
  type num

  val sexp_of_num : num -> Ppx_sexp_conv_lib.Sexp.t
  val num_of_sexp : Ppx_sexp_conv_lib.Sexp.t -> num

  type op

  val sexp_of_op : op -> Ppx_sexp_conv_lib.Sexp.t
  val op_of_sexp : Ppx_sexp_conv_lib.Sexp.t -> op
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
