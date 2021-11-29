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

module MakeVecInfix (V : VEC) = struct
  let ( +^ ) = V.add

  let ( -^ ) = V.sub

  let ( *^ ) = V.mult

  let ( ^* ) a b = V.mult b a

  let ( *.* ) = V.dot_product
end

module VZ : VEC = struct
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

module VS (V : VEC) = struct
  module T : VEC = struct
    let n = V.n + 1

    type t = float * V.t

    let zero = (0., V.zero)

    let one = (1., V.one)

    let of_list = function [] -> assert false | a :: b -> (a, V.of_list b)

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
  end

  include T
  module Infix = MakeVecInfix (T)
end

module Vec2 = struct
  include VS (VS (VZ))

  let make a b : t = of_list [ a; b ]
end

module Vector1 = VS (VZ)
module Vector2 = VS (Vector1)
module Vector3 = VS (Vector2)
module Vector4 = VS (Vector3)
module Vector5 = VS (Vector4)

let greet name = "Hello " ^ name ^ "!"

let n1 = Vector1.n

let n2 = Vector2.n
