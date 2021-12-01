exception
  NotEnough of {
    need : int;  (** needed length *)
    got : int;  (** given list length *)
    failed_on : int;  (** TODO *)
  }
(** [NotEnough] throws when trying to create vector from not long enough list *)

(** A vector with [n] dimensions which uses [float] as type for numbers *)
module type VEC = sig
  val n : int
  (** [n] is dimensions of vector *)

  type t
  (** [t] represents the vector *)

  val zero : t
  (** [zero] is zero-length vector (zero vector) *)

  val one : t
  (** [one] is vector with [1] in all dimensions (unit vector) *)

  val of_list : float list -> t
  (** [of_list lst] is vector created from list [lst]. @raise: [NotEnough] if
      [List.length lst < n] *)

  val equal : ?eps:float -> t -> t -> bool
  (** [equal ~eps x y] is result of equality comparing with given accuracy [eps]
      of vectors [x] and [y] *)

  val pp : ?start:bool -> Formatter.t -> t -> unit
  (** [pp ~start ppf x] pretty-prints vector [x] using formatter [ppf] *)

  val show : t -> string
  (** [show x] is string representation of vector [x] *)

  val add : t -> t -> t
  (** [add x y] is sum of vector [x] and vector [y] *)

  val sub : t -> t -> t
  (** [sub x y] is subtraction of vector [x] and vector [y] *)

  val mult : t -> float -> t
  (** [mult x k] is vector [x] with lengths multiplied by [k] *)

  val dot_product : t -> t -> float
  (** [dot_product x y] is scalar (dot) product of vector [x] and vector [y] *)

  val length_squared : t -> float
  (** [length_squared x] is length of vector [x] multiplied by self *)

  val length : t -> float
  (** [length x] is length of vector [x] *)
end

(** Infix operations with vector *)
module type VECINFIX = sig
  type t
  (** [t] represents the vector*)

  (** Module with operators itself *)
  module Infix : sig
    val ( +^ ) : t -> t -> t
    (** [x +^ y] is sum of vector [x] and vector [y] *)

    val ( -^ ) : t -> t -> t
    (** [x -^ y] is subtraction of vector [x] and vector [y] *)

    val ( *^ ) : t -> float -> t
    (** [x *^ k] is vector [x] with lengths multiplied by [k] *)

    val ( ^* ) : float -> t -> t
    (** [k ^* x] is vector [x] with lengths multiplied by [k] *)

    val ( *.* ) : t -> t -> float
    (** [x *.* y] is scalar (dot) product of vector [x] and vector [y] *)
  end
end

(** Degenerate vector (0 dimension) *)
module Vector0 : sig
  include VEC

  include VECINFIX with type t := t

  val make : t
  (** [make] is single instance of 0-dimension degenerate vector *)
end

(** 1-dimension vector*)
module Vector1 : sig
  include VEC

  include VECINFIX with type t := t

  val make : float -> t
  (** [make x1] is 1-dimension vector with length [x1] *)
end

(** 2-dimension vector *)
module Vector2 : sig
  include VEC

  include VECINFIX with type t := t

  val make : float -> float -> t
  (** [make x1 x2] is 2-dimension vector with coords [x1] and [x2] *)
end

(** 3-dimension vector *)
module Vector3 : sig
  include VEC

  include VECINFIX with type t := t

  val make : float -> float -> float -> t
  (** [make x1 x2 x3] is 3-dimension vector with coords [x1], [x2] and [x3] *)
end

(** 4-dimension vector *)
module Vector4 : sig
  include VEC

  include VECINFIX with type t := t

  val make : float -> float -> float -> float -> t
  (** [make x1 x2 x3 x4] is 4-dimension vector with coords [x1], [x2], [x3] and
      [x4] *)
end

(** 5-dimension vector *)
module Vector5 : sig
  include VEC

  include VECINFIX with type t := t

  val make : float -> float -> float -> float -> float -> t
  (** [make x1 x2 x3 x4 x5] is 4-dimension vector with coords [x1], [x2], [x3],
      [x4] and [x5] *)
end
