open Alcotest
open Lab03_parser.Parser

let token = of_pp token_pp

type test_process_line_data =
  { input : string
  ; expected : token
  ; msg : string
  }

let test_process_line () =
  [ { input = "12"; expected = Number 12; msg = "Number 12" }
  ; { input = "12231"; expected = Number 12231; msg = "Number 12231" }
  ; { input = "-12231"; expected = Number (-12231); msg = "Number -12231" }
  ; { input = "+"; expected = Plus; msg = "Plus" }
  ; { input = "-"; expected = Minus; msg = "Minus" }
  ; { input = "*"; expected = Mult; msg = "Mult" }
  ; { input = "/"; expected = Div; msg = "Div" }
  ; { input = ""; expected = EmptyString; msg = "EmptyString" }
  ; { input = "q"; expected = Error; msg = "Error on q" }
  ; { input = " "; expected = Error; msg = "Error on space" }
  ]
  |> List.iter ~f:(fun { input; expected; msg } ->
         check' token ~msg ~expected ~actual:(process_line input))
;;

type test_pp_data =
  { input : token
  ; expected : string
  ; msg : string
  }

let test_pp () =
  [ { input = Number 12; expected = "Number(12)"; msg = "Number 12" }
  ; { input = Number 12231; expected = "Number(12231)"; msg = "Number 12231" }
  ; { input = Number (-12231); expected = "Number(-12231)"; msg = "Number -12231" }
  ; { input = Plus; expected = "Plus"; msg = "Plus" }
  ; { input = Minus; expected = "Minus"; msg = "Minus" }
  ; { input = Mult; expected = "Mult"; msg = "Mult" }
  ; { input = Div; expected = "Div"; msg = "Div" }
  ; { input = EmptyString; expected = "EmptyString"; msg = "EmptyString" }
  ; { input = Error; expected = "Error"; msg = "Error on space" }
  ]
  |> List.iter ~f:(fun { input; expected; msg } ->
         check' string ~msg ~expected ~actual:(Caml.Format.asprintf "%a" token_pp input))
;;

let suite =
  ( "Parser tests"
  , [ "Process line tests", `Quick, test_process_line
    ; "Pretty print tests", `Quick, test_pp
    ] )
;;
