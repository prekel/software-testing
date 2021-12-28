(** [NotEnough] throws when trying to create vector from not long enough list *)
exception
  NotEnough of
    { need : int (** needed length *)
    ; got : int (** given list length *)
    ; failed_on : int (** TODO *)
    }

(** A vector with [n] dimensions which uses [float] as type for numbers *)
module type VEC = sig
  (** [n] is dimensions of vector *)
  val n : int

  (** [t] represents the vector *)
  type t

  (** [zero] is zero-length vector (zero vector) *)
  val zero : t

  (** [one] is vector with [1] in all dimensions (unit vector) *)
  val one : t

  (** [of_list lst] is vector created from list [lst].

      @raise NotEnough if [List.length lst < n] *)
  val of_list : float list -> t

  (** [equal ~eps x y] is result of equality comparing with given accuracy [eps] of
      vectors [x] and [y] *)
  val equal : ?eps:float -> t -> t -> bool

  (** [pp ~start ppf x] pretty-prints vector [x] using formatter [ppf] *)
  val pp : ?start:bool -> Formatter.t -> t -> unit

  (** [show x] is string representation of vector [x] *)
  val show : t -> string

  (** [add x y] is sum of vector [x] and vector [y] *)
  val add : t -> t -> t

  (** [sub x y] is subtraction of vector [x] and vector [y] *)
  val sub : t -> t -> t

  (** [mult x k] is vector [x] with lengths multiplied by [k] *)
  val mult : t -> float -> t

  (** [dot_product x y] is scalar (dot) product of vector [x] and vector [y] *)
  val dot_product : t -> t -> float

  (** [length_squared x] is length of vector [x] multiplied by self *)
  val length_squared : t -> float

  (** [length x] is length of vector [x] *)
  val length : t -> float
end

(** Infix operations with vector *)
module type VECINFIX = sig
  (** [t] represents the vector*)
  type t

  (** Module with operators itself *)
  module Infix : sig
    (** [x = y] is true if vectors coordinats equal to each other with epsilon = 0 *)
    val ( = ) : t -> t -> bool

    (** [x + y] is sum of vector [x] and vector [y] *)
    val ( + ) : t -> t -> t

    (** [x - y] is subtraction of vector [x] and vector [y] *)
    val ( - ) : t -> t -> t

    (** [x *^ k] is vector [x] with lengths multiplied by [k] *)
    val ( *^ ) : t -> float -> t

    (** [k ^* x] is vector [x] with lengths multiplied by [k] *)
    val ( ^* ) : float -> t -> t

    (** [x *.* y] is scalar (dot) product of vector [x] and vector [y] *)
    val ( *.* ) : t -> t -> float
  end
end

(** Degenerate vector (0 dimension) *)
module Vector0 : sig
  include VEC
  include VECINFIX with type t := t

  (** [make] is single instance of 0-dimension degenerate vector *)
  val make : t
end

(** 1-dimension vector*)
module Vector1 : sig
  include VEC
  include VECINFIX with type t := t

  (** [make x1] is 1-dimension vector with length [x1] *)
  val make : float -> t
end

(** 2-dimension vector *)
module Vector2 : sig
  include VEC
  include VECINFIX with type t := t

  (** [make x1 x2] is 2-dimension vector with coords [x1] and [x2] *)
  val make : float -> float -> t
end

(** 3-dimension vector *)
module Vector3 : sig
  include VEC
  include VECINFIX with type t := t

  (** [make x1 x2 x3] is 3-dimension vector with coords [x1], [x2] and [x3] *)
  val make : float -> float -> float -> t
end

(** 4-dimension vector *)
module Vector4 : sig
  include VEC
  include VECINFIX with type t := t

  (** [make x1 x2 x3 x4] is 4-dimension vector with coords [x1], [x2], [x3] and [x4] *)
  val make : float -> float -> float -> float -> t
end

(** 5-dimension vector *)
module Vector5 : sig
  include VEC
  include VECINFIX with type t := t

  (** [make x1 x2 x3 x4 x5] is 4-dimension vector with coords [x1], [x2], [x3], [x4] and
      [x5] *)
  val make : float -> float -> float -> float -> float -> t
end