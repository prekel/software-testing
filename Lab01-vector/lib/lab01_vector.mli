module type VEC =
  sig
    val n : int
    type t
    val zero : t
    val one : t
    val of_list : float list -> t
    val equal : ?eps:float -> t -> t -> bool
    val pp : ?start:bool -> Format.formatter -> t -> unit
    val show : t -> string
    val add : t -> t -> t
    val sub : t -> t -> t
    val mult : t -> float -> t
    val dot_product : t -> t -> float
    val length_squared : t -> float
    val length : t -> float
  end
module MakeVecInfix :
  functor (V : VEC) ->
    sig
      val ( +^ ) : V.t -> V.t -> V.t
      val ( -^ ) : V.t -> V.t -> V.t
      val ( *^ ) : V.t -> float -> V.t
      val ( ^* ) : float -> V.t -> V.t
      val ( *.* ) : V.t -> V.t -> float
    end
module VZ : VEC
exception EmptyList of int
module VS :
  functor (V : VEC) ->
    sig
      module T :
        sig
          val n : int
          type t = float * V.t
          val zero : float * V.t
          val one : float * V.t
          exception NotEnough of { need : int; got : int; failed_on : int; }
          val of_list : float list -> float * V.t
          val equal : ?eps:float -> float * V.t -> float * V.t -> bool
          val pp : ?start:bool -> Format.formatter -> float * V.t -> unit
          val show : float * V.t -> string
          val add : float * V.t -> float * V.t -> float * V.t
          val sub : float * V.t -> float * V.t -> float * V.t
          val mult : float * V.t -> float -> float * V.t
          val dot_product : float * V.t -> float * V.t -> float
          val length_squared : float * V.t -> float
          val length : float * V.t -> float
          val of_vec : float -> V.t -> t
        end
      val n : int
      type t = float * V.t
      val zero : float * V.t
      val one : float * V.t
      exception NotEnough of { need : int; got : int; failed_on : int; }
      val of_list : float list -> float * V.t
      val equal : ?eps:float -> float * V.t -> float * V.t -> bool
      val pp : ?start:bool -> Format.formatter -> float * V.t -> unit
      val show : float * V.t -> string
      val add : float * V.t -> float * V.t -> float * V.t
      val sub : float * V.t -> float * V.t -> float * V.t
      val mult : float * V.t -> float -> float * V.t
      val dot_product : float * V.t -> float * V.t -> float
      val length_squared : float * V.t -> float
      val length : float * V.t -> float
      val of_vec : float -> V.t -> t
      module Infix :
        sig
          val ( +^ ) : T.t -> T.t -> T.t
          val ( -^ ) : T.t -> T.t -> T.t
          val ( *^ ) : T.t -> float -> T.t
          val ( ^* ) : float -> T.t -> T.t
          val ( *.* ) : T.t -> T.t -> float
        end
    end
module Vector0 :
  sig
    val n : int
    type t = VZ.t
    val zero : t
    val one : t
    val of_list : float list -> t
    val equal : ?eps:float -> t -> t -> bool
    val pp : ?start:bool -> Format.formatter -> t -> unit
    val show : t -> string
    val add : t -> t -> t
    val sub : t -> t -> t
    val mult : t -> float -> t
    val dot_product : t -> t -> float
    val length_squared : t -> float
    val length : t -> float
    val make : unit -> t
  end
module Vector1 :
  sig
    module T :
      sig
        val n : int
        type t = float * VZ.t
        val zero : float * VZ.t
        val one : float * VZ.t
        exception NotEnough of { need : int; got : int; failed_on : int; }
        val of_list : float list -> float * VZ.t
        val equal : ?eps:float -> float * VZ.t -> float * VZ.t -> bool
        val pp : ?start:bool -> Format.formatter -> float * VZ.t -> unit
        val show : float * VZ.t -> string
        val add : float * VZ.t -> float * VZ.t -> float * VZ.t
        val sub : float * VZ.t -> float * VZ.t -> float * VZ.t
        val mult : float * VZ.t -> float -> float * VZ.t
        val dot_product : float * VZ.t -> float * VZ.t -> float
        val length_squared : float * VZ.t -> float
        val length : float * VZ.t -> float
        val of_vec : float -> VZ.t -> t
      end
    val n : int
    type t = float * VZ.t
    val zero : float * VZ.t
    val one : float * VZ.t
    exception NotEnough of { need : int; got : int; failed_on : int; }
    val of_list : float list -> float * VZ.t
    val equal : ?eps:float -> float * VZ.t -> float * VZ.t -> bool
    val pp : ?start:bool -> Format.formatter -> float * VZ.t -> unit
    val show : float * VZ.t -> string
    val add : float * VZ.t -> float * VZ.t -> float * VZ.t
    val sub : float * VZ.t -> float * VZ.t -> float * VZ.t
    val mult : float * VZ.t -> float -> float * VZ.t
    val dot_product : float * VZ.t -> float * VZ.t -> float
    val length_squared : float * VZ.t -> float
    val length : float * VZ.t -> float
    val of_vec : float -> VZ.t -> t
    module Infix :
      sig
        val ( +^ ) : T.t -> T.t -> T.t
        val ( -^ ) : T.t -> T.t -> T.t
        val ( *^ ) : T.t -> float -> T.t
        val ( ^* ) : float -> T.t -> T.t
        val ( *.* ) : T.t -> T.t -> float
      end
    val make : float -> t
  end
module Vector2 :
  sig
    module T :
      sig
        val n : int
        type t = float * Vector1.t
        val zero : float * Vector1.t
        val one : float * Vector1.t
        exception NotEnough of { need : int; got : int; failed_on : int; }
        val of_list : float list -> float * Vector1.t
        val equal :
          ?eps:float -> float * Vector1.t -> float * Vector1.t -> bool
        val pp : ?start:bool -> Format.formatter -> float * Vector1.t -> unit
        val show : float * Vector1.t -> string
        val add : float * Vector1.t -> float * Vector1.t -> float * Vector1.t
        val sub : float * Vector1.t -> float * Vector1.t -> float * Vector1.t
        val mult : float * Vector1.t -> float -> float * Vector1.t
        val dot_product : float * Vector1.t -> float * Vector1.t -> float
        val length_squared : float * Vector1.t -> float
        val length : float * Vector1.t -> float
        val of_vec : float -> Vector1.t -> t
      end
    val n : int
    type t = float * Vector1.t
    val zero : float * Vector1.t
    val one : float * Vector1.t
    exception NotEnough of { need : int; got : int; failed_on : int; }
    val of_list : float list -> float * Vector1.t
    val equal : ?eps:float -> float * Vector1.t -> float * Vector1.t -> bool
    val pp : ?start:bool -> Format.formatter -> float * Vector1.t -> unit
    val show : float * Vector1.t -> string
    val add : float * Vector1.t -> float * Vector1.t -> float * Vector1.t
    val sub : float * Vector1.t -> float * Vector1.t -> float * Vector1.t
    val mult : float * Vector1.t -> float -> float * Vector1.t
    val dot_product : float * Vector1.t -> float * Vector1.t -> float
    val length_squared : float * Vector1.t -> float
    val length : float * Vector1.t -> float
    val of_vec : float -> Vector1.t -> t
    module Infix :
      sig
        val ( +^ ) : T.t -> T.t -> T.t
        val ( -^ ) : T.t -> T.t -> T.t
        val ( *^ ) : T.t -> float -> T.t
        val ( ^* ) : float -> T.t -> T.t
        val ( *.* ) : T.t -> T.t -> float
      end
    val make : float -> float -> t
  end
module Vector3 :
  sig
    module T :
      sig
        val n : int
        type t = float * Vector2.t
        val zero : float * Vector2.t
        val one : float * Vector2.t
        exception NotEnough of { need : int; got : int; failed_on : int; }
        val of_list : float list -> float * Vector2.t
        val equal :
          ?eps:float -> float * Vector2.t -> float * Vector2.t -> bool
        val pp : ?start:bool -> Format.formatter -> float * Vector2.t -> unit
        val show : float * Vector2.t -> string
        val add : float * Vector2.t -> float * Vector2.t -> float * Vector2.t
        val sub : float * Vector2.t -> float * Vector2.t -> float * Vector2.t
        val mult : float * Vector2.t -> float -> float * Vector2.t
        val dot_product : float * Vector2.t -> float * Vector2.t -> float
        val length_squared : float * Vector2.t -> float
        val length : float * Vector2.t -> float
        val of_vec : float -> Vector2.t -> t
      end
    val n : int
    type t = float * Vector2.t
    val zero : float * Vector2.t
    val one : float * Vector2.t
    exception NotEnough of { need : int; got : int; failed_on : int; }
    val of_list : float list -> float * Vector2.t
    val equal : ?eps:float -> float * Vector2.t -> float * Vector2.t -> bool
    val pp : ?start:bool -> Format.formatter -> float * Vector2.t -> unit
    val show : float * Vector2.t -> string
    val add : float * Vector2.t -> float * Vector2.t -> float * Vector2.t
    val sub : float * Vector2.t -> float * Vector2.t -> float * Vector2.t
    val mult : float * Vector2.t -> float -> float * Vector2.t
    val dot_product : float * Vector2.t -> float * Vector2.t -> float
    val length_squared : float * Vector2.t -> float
    val length : float * Vector2.t -> float
    val of_vec : float -> Vector2.t -> t
    module Infix :
      sig
        val ( +^ ) : T.t -> T.t -> T.t
        val ( -^ ) : T.t -> T.t -> T.t
        val ( *^ ) : T.t -> float -> T.t
        val ( ^* ) : float -> T.t -> T.t
        val ( *.* ) : T.t -> T.t -> float
      end
    val make : float -> float -> float -> t
  end
module Vector4 :
  sig
    module T :
      sig
        val n : int
        type t = float * Vector3.t
        val zero : float * Vector3.t
        val one : float * Vector3.t
        exception NotEnough of { need : int; got : int; failed_on : int; }
        val of_list : float list -> float * Vector3.t
        val equal :
          ?eps:float -> float * Vector3.t -> float * Vector3.t -> bool
        val pp : ?start:bool -> Format.formatter -> float * Vector3.t -> unit
        val show : float * Vector3.t -> string
        val add : float * Vector3.t -> float * Vector3.t -> float * Vector3.t
        val sub : float * Vector3.t -> float * Vector3.t -> float * Vector3.t
        val mult : float * Vector3.t -> float -> float * Vector3.t
        val dot_product : float * Vector3.t -> float * Vector3.t -> float
        val length_squared : float * Vector3.t -> float
        val length : float * Vector3.t -> float
        val of_vec : float -> Vector3.t -> t
      end
    val n : int
    type t = float * Vector3.t
    val zero : float * Vector3.t
    val one : float * Vector3.t
    exception NotEnough of { need : int; got : int; failed_on : int; }
    val of_list : float list -> float * Vector3.t
    val equal : ?eps:float -> float * Vector3.t -> float * Vector3.t -> bool
    val pp : ?start:bool -> Format.formatter -> float * Vector3.t -> unit
    val show : float * Vector3.t -> string
    val add : float * Vector3.t -> float * Vector3.t -> float * Vector3.t
    val sub : float * Vector3.t -> float * Vector3.t -> float * Vector3.t
    val mult : float * Vector3.t -> float -> float * Vector3.t
    val dot_product : float * Vector3.t -> float * Vector3.t -> float
    val length_squared : float * Vector3.t -> float
    val length : float * Vector3.t -> float
    val of_vec : float -> Vector3.t -> t
    module Infix :
      sig
        val ( +^ ) : T.t -> T.t -> T.t
        val ( -^ ) : T.t -> T.t -> T.t
        val ( *^ ) : T.t -> float -> T.t
        val ( ^* ) : float -> T.t -> T.t
        val ( *.* ) : T.t -> T.t -> float
      end
    val make : float -> float -> float -> float -> t
  end
module Vector5 :
  sig
    module T :
      sig
        val n : int
        type t = float * Vector4.t
        val zero : float * Vector4.t
        val one : float * Vector4.t
        exception NotEnough of { need : int; got : int; failed_on : int; }
        val of_list : float list -> float * Vector4.t
        val equal :
          ?eps:float -> float * Vector4.t -> float * Vector4.t -> bool
        val pp : ?start:bool -> Format.formatter -> float * Vector4.t -> unit
        val show : float * Vector4.t -> string
        val add : float * Vector4.t -> float * Vector4.t -> float * Vector4.t
        val sub : float * Vector4.t -> float * Vector4.t -> float * Vector4.t
        val mult : float * Vector4.t -> float -> float * Vector4.t
        val dot_product : float * Vector4.t -> float * Vector4.t -> float
        val length_squared : float * Vector4.t -> float
        val length : float * Vector4.t -> float
        val of_vec : float -> Vector4.t -> t
      end
    val n : int
    type t = float * Vector4.t
    val zero : float * Vector4.t
    val one : float * Vector4.t
    exception NotEnough of { need : int; got : int; failed_on : int; }
    val of_list : float list -> float * Vector4.t
    val equal : ?eps:float -> float * Vector4.t -> float * Vector4.t -> bool
    val pp : ?start:bool -> Format.formatter -> float * Vector4.t -> unit
    val show : float * Vector4.t -> string
    val add : float * Vector4.t -> float * Vector4.t -> float * Vector4.t
    val sub : float * Vector4.t -> float * Vector4.t -> float * Vector4.t
    val mult : float * Vector4.t -> float -> float * Vector4.t
    val dot_product : float * Vector4.t -> float * Vector4.t -> float
    val length_squared : float * Vector4.t -> float
    val length : float * Vector4.t -> float
    val of_vec : float -> Vector4.t -> t
    module Infix :
      sig
        val ( +^ ) : T.t -> T.t -> T.t
        val ( -^ ) : T.t -> T.t -> T.t
        val ( *^ ) : T.t -> float -> T.t
        val ( ^* ) : float -> T.t -> T.t
        val ( *.* ) : T.t -> T.t -> float
      end
    val make : float -> float -> float -> float -> float -> t
  end
