open Alcotest
open Lab03_parser.Parser

let test_empty_string () = 
  let actual = process_line "" in 
  let expected = EmptyString in
  check' () ~msg:"" ~expected ~actual 


let suite =  "", ["Empty string", `Quick, test_empty_string]
