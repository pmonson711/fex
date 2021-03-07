include Ast

let str_parse str =
  str |> Lexing.from_string |> Filter_parser.prog @@ Lexer.read_tokens
