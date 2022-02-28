open Core
open Lwt.Let_syntax

let main () =
  let%bind v = Lwt_io.(read_line stdin) in
  match v with
  | "f" -> Run.RunFloat.run' ()
  | "i" -> Run.RunInt.run' ()
  | "0" -> Run.RunVector0.run' ()
  | "1" -> Run.RunVector1.run' ()
  | "2" -> Run.RunVector2.run' ()
  | _ -> assert false
;;

let () = never_returns @@ Lwt_main.run @@ main ()
