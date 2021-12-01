module type VEC = sig
  val n : int

  type t

  val zero : t

  val one : t

  val of_list : float list -> t

  val equal : ?eps:float -> t -> t -> bool

  val pp : ?start:bool -> Formatter.t -> t -> unit

  val show : t -> string

  val add : t -> t -> t

  val sub : t -> t -> t

  val mult : t -> float -> t

  val dot_product : t -> t -> float

  val length_squared : t -> float

  val length : t -> float
end

module type VECINFIX = sig
  type t

  module Infix : sig
    val ( +^ ) : t -> t -> t

    val ( -^ ) : t -> t -> t

    val ( *^ ) : t -> float -> t

    val ( ^* ) : float -> t -> t

    val ( *.* ) : t -> t -> float
  end
end

module MakeVecInfix (V : VEC) = struct
  let ( +^ ) = V.add

  let ( -^ ) = V.sub

  let ( *^ ) = V.mult

  let ( ^* ) a b = V.mult b a

  let ( *.* ) = V.dot_product
end

module VZ = struct
  module T = struct
    let n = 0

    type t = unit

    let zero = ()

    let one = ()

    let of_list _ = ()

    let equal ?eps:_ _ _ = true

    let pp ?(start = true) ppf a = if start then Caml.Format.fprintf ppf "()"

    let show _ = "()"

    let add _ _ = ()

    let sub _ _ = ()

    let mult _ _ = ()

    let dot_product _ _ = 0.

    let length_squared _ = 0.

    let length _ = 0.
  end

  include T
  module Infix = MakeVecInfix (T)
end

exception EmptyList of int
exception NotEnough of { need : int; got : int; failed_on : int }

module VS (V : VEC) = struct
  module T = struct
    let n = V.n + 1

    type t = float * V.t

    let zero = (0., V.zero)

    let one = (1., V.one)

    let of_list = function
      | [] -> raise @@ EmptyList n
      | a :: b -> begin
          try (a, V.of_list b)
          with EmptyList ni ->
            raise
            @@ NotEnough { need = n; got = List.length b + 1; failed_on = ni }
        end

    let equal ?(eps = 1e-6) (a, x) (b, y) =
      let open Float in
      abs (a -. b) <= eps && V.equal x y ~eps

    let pp ?(start = true) ppf (a, x) =
      let open Caml.Format in
      if start then pp_open_hbox ppf ();
      pp_print_float ppf a;
      pp_print_space ppf ();
      V.pp ~start:false ppf x;
      if start then pp_close_box ppf ()

    let show x = Caml.Format.asprintf "%a" (pp ~start:true) x

    let add (a, x) (b, y) = (a +. b, V.add x y)

    let sub (a, x) (b, y) = (a -. b, V.add x y)

    let mult (a, x) k = (a *. k, V.mult x k)

    let dot_product (a, x) (b, y) = (a *. b) +. V.dot_product x y

    let length_squared (a, b) = (a *. a) +. V.length_squared b

    let length a = Float.sqrt @@ length_squared a

    let of_vec a x : t = (a, x)
  end

  include T
  module Infix = MakeVecInfix (T)
end

module Vector0 = struct
  include VZ

  let make = VZ.zero
end

module Vector1 = struct
  include VS (Vector0)

  let make a = of_vec a (Vector0.make)
end

module Vector2 = struct
  include VS (Vector1)

  let make a b = of_vec a (Vector1.make b)
end

module Vector3 = struct
  include VS (Vector2)

  let make a b c = of_vec a (Vector2.make b c)
end

module Vector4 = struct
  include VS (Vector3)

  let make a1 a2 a3 a4 = of_vec a1 (Vector3.make a2 a3 a4)
end

module Vector5 = struct
  include VS (Vector4)

  let make a1 a2 a3 a4 a5 = of_vec a1 (Vector4.make a2 a3 a4 a5)
end
