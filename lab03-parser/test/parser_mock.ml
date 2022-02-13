open Core
open Lab03_parser.Parser

let process_line line =
  print_s [%sexp (line : string)];
  Ok Empty
;;
