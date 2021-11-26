module type VEC = sig
  val n : int

  type 'a t

  val fill : 'a -> 'a t

  val map : ('a -> 'b) -> 'a t -> 'b t

  val zip_with : ('a -> 'b -> 'c) -> 'a t -> 'b t -> 'c t

  val fold : ('a -> 'b -> 'a) -> 'a -> 'b t -> 'a
end

module VZ : VEC = struct
  let n = 0

  type _ t = unit

  let fill _ = ()

  let map _ _ = ()

  let zip_with _ _ _ = ()

  let fold _ a _ = a
end

module VS (V : VEC) : VEC = struct
  let n = V.n + 1

  type 'a t = 'a * 'a V.t

  let fill a = (a, V.fill a)

  let map f (a, b) = (f a, V.map f b)

  let zip_with f (a, b) (c, d) = (f a c, V.zip_with f b d)

  let fold f z (a, b) = f (V.fold f z b) a
end

module Vector1 = VS (VZ)
module Vector2 = VS (Vector1)

let greet name = "Hello " ^ name ^ "!"

let n1 = Vector1.n

let n2 = Vector2.n
