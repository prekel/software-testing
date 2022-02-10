open Core

let triple_or (type t) (module E : Equal.S with type t = t) a b c =
  let ( = ) = E.equal in
  a = b || b = c || a = c
;;

let triple_and (type t) (module E : Equal.S with type t = t) a b c =
  let ( = ) = E.equal in
  a = b && b = c && a = c
;;
