open Core

module type VEC = sig
  type t [@@deriving sexp]

  val n : int
  val zero : t
  val one : t
  val of_list : float list -> t
  val equal : t -> t -> bool
  val add : t -> t -> t
  val sub : t -> t -> t
  val mult : t -> float -> t
  val dot_product : t -> t -> float
  val length_squared : t -> float
  val length : t -> float
end

module type VECTOR = sig
  type t

  module Infix : sig
    val ( = ) : t -> t -> bool
    val ( + ) : t -> t -> t
    val ( - ) : t -> t -> t
    val ( *^ ) : t -> float -> t
    val ( ^* ) : float -> t -> t
    val ( *.* ) : t -> t -> float
  end

  val parse : string -> t option
end

module MakeVecInfix (V : VEC) = struct
  let ( = ) = V.equal
  let ( + ) = V.add
  let ( - ) = V.sub
  let ( *^ ) = V.mult
  let ( ^* ) a b = V.mult b a
  let ( *.* ) = V.dot_product
end

module VZ = struct
  module T = struct
    let n = 0

    type t = unit [@@deriving sexp]

    let zero = ()
    let one = ()
    let of_list _ = ()
    let equal _ _ = true
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

exception
  NotEnough of
    { need : int
    ; got : int
    ; failed_on : int
    }

module VS (V : VEC) = struct
  module T = struct
    let n = V.n + 1

    type t = float * V.t [@@deriving sexp]

    let zero = 0., V.zero
    let one = 1., V.one

    let of_list = function
      | [] -> raise @@ EmptyList n
      | a :: b ->
        begin
          try a, V.of_list b with
          | EmptyList ni ->
            raise @@ NotEnough { need = n; got = List.length b + 1; failed_on = ni }
        end
    ;;

    let equal (a, x) (b, y) = Float.Robustly_comparable.(a =. b) && V.equal x y
    let add (a, x) (b, y) = a +. b, V.add x y
    let sub (a, x) (b, y) = a -. b, V.sub x y
    let mult (a, x) k = a *. k, V.mult x k
    let dot_product (a, x) (b, y) = (a *. b) +. V.dot_product x y
    let length_squared (a, b) = (a *. a) +. V.length_squared b
    let length a = Float.sqrt @@ length_squared a
    let of_vec a x : t = a, x
  end

  include T
  module Infix = MakeVecInfix (T)
end

module Vector0 = struct
  include VZ

  let make = VZ.zero

  let parse s =
    match Parser.process_line s with
    | Empty -> Some make
    | _ -> None
  ;;
end

module Vector1 = struct
  include VS (Vector0)

  let make a = of_vec a Vector0.make

  let parse s =
    match Parser.process_line s with
    | OneNumber x -> Some (make x)
    | _ -> None
  ;;
end

module Vector2 = struct
  include VS (Vector1)

  let make a b = of_vec a (Vector1.make b)

  let parse s =
    match Parser.process_line s with
    | TwoNumbers (x, y) -> Some (make x y)
    | _ -> None
  ;;
end
