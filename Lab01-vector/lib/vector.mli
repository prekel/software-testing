exception NotEnough of { need : int; got : int; failed_on : int }

module type VEC = sig
  (** [n] is dimensions of vector *)
  val n : int

  (** [t] represents the vector *)
  type t

  (** [zero] is zero-length vector *)
  val zero : t

  (** [one] is vector with [1] in all dimensions *)
  val one : t

  (** [of_list lst] creates the vector. Raises: [NotEnough] if [List.length lst < n] *)
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

module Vector0 : sig
  include VEC

  include VECINFIX with type t := t

  val make : t
end

module Vector1 : sig
  include VEC

  include VECINFIX with type t := t

  val make : float -> t
end

module Vector2 : sig
  include VEC

  include VECINFIX with type t := t

  val make : float -> float -> t
end

module Vector3 : sig
  include VEC

  include VECINFIX with type t := t

  val make : float -> float -> float -> t
end

module Vector4 : sig
  include VEC

  include VECINFIX with type t := t

  val make : float -> float -> float -> float -> t
end

module Vector5 : sig
  include VEC

  include VECINFIX with type t := t

  val make : float -> float -> float -> float -> float -> t
end
