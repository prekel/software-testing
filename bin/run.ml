open Core
open Lab03_parser

module MakeRun (M : Calculator.S) = struct
  let rec loop state =
    Out_channel.(print_s [%sexp (state : M.state)]);
    let q = Stdio.In_channel.(input_line_exn stdin) in
    let action = M.line_to_action q in
    M.update ~action state |> loop
  ;;

  open Lwt.Let_syntax

  let rec loop' ~stream ~mvar state =
    let%bind () = Lwt_mvar.put mvar (Sexp.to_string_hum [%sexp (state : M.state)]) in
    let%bind q = Lwt_stream.next stream in
    let action = M.line_to_action q in
    M.update ~action state |> loop' ~stream ~mvar
  ;;

  let run' () : never_returns Lwt.t =
    let stream =
      Lwt_stream.from Lwt.(fun () -> Lwt_io.(read_line stdin) >|= Option.some)
    in
    let mvar = Lwt_mvar.create_empty () in
    let rec pr () =
      let%bind v = Lwt_mvar.take mvar in
      let%bind () = Lwt_io.printl v in
      pr ()
    in
    Lwt.pick [ loop' ~stream ~mvar M.WaitInitial; pr () ]
  ;;
end

module RunFloat = MakeRun (Calculator.CalculatorFloat)
module RunInt = MakeRun (Calculator.CalculatorInt)
module RunVector0 = MakeRun (Calculator.CalculatorVector0)
module RunVector1 = MakeRun (Calculator.CalculatorVector1)
module RunVector2 = MakeRun (Calculator.CalculatorVector2)
