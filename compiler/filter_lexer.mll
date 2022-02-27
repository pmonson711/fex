{
open Lexing
open Filter_parser

exception SyntaxError of string

let next_line lexbuf =
  let pos = lexbuf.lex_curr_p in
  lexbuf.lex_curr_p <-
    { pos with pos_bol = lexbuf.lex_curr_pos;
               pos_lnum = pos.pos_lnum + 1
    }
}

let digit = ['0'-'9']
let str_one = [^ ':' '-' '+' ',' '\'' '"' '.' ' ' '<' '>' '=']
let str_rest = [^ ':' ',' '\'' '"' '.' ' ']
let str = str_one str_rest*
let whitespace = [' ' '\t']+
let ws = [' ' '\t']*
let newline = '\r' | '\n' | "\r\n"

rule read_tokens =
  parse
  | whitespace { SPACE }
  | newline    { next_line lexbuf; read_tokens lexbuf }
  | ws ':'     { COLON }
  | ws ','     { COMMA }
  | ws '-'     { MINUS }
  | ws '+'     { PLUS }
  | ws '='     { EQUAL }
  | ws '<'     { L_ANGLE }
  | ws '>'     { R_ANGLE }
  | '.' '.'+   { DOTDOT }
  | ws '-'? digit+ 
               { FLOAT (Lexing.lexeme lexbuf |> float_of_string) }
  | ws '-'? digit+ '.' digit+ 
               { FLOAT (Lexing.lexeme lexbuf |> float_of_string) }
  | '\''       { read_string (Buffer.create 1) lexbuf }
  | '"'        { read_string2 (Buffer.create 1) lexbuf }
  | str        { STRING (Lexing.lexeme lexbuf |> String.trim) }
  | (str '.' str_rest)+
               { STRING (Lexing.lexeme lexbuf |> String.trim) }
  | _          { raise (SyntaxError ("Unexpected char: " ^ Lexing.lexeme lexbuf)) }
  | ws eof     { EOF }

and read_string buf =
  parse
  | '\''       { Q_STRING (Buffer.contents buf) }
  | '\\' '\''  { Buffer.add_char buf '\''; read_string buf lexbuf }
  | '\\' 'n'   { Buffer.add_char buf '\n'; read_string buf lexbuf }
  | '\\' 'r'   { Buffer.add_char buf '\r'; read_string buf lexbuf }
  | '\\' 't'   { Buffer.add_char buf '\t'; read_string buf lexbuf }
  | [^ '\'' '\\']+
    { Buffer.add_string buf (Lexing.lexeme lexbuf);
      read_string buf lexbuf }
  | _          { raise (SyntaxError ("Illegal string character: " ^ Lexing.lexeme lexbuf)) }
  | eof        { raise (SyntaxError ("String is not terminated")) }

and read_string2 buf =
  parse
  | '"'        { Q_STRING (Buffer.contents buf) }
  | '\\' '"'   { Buffer.add_char buf '"'; read_string2 buf lexbuf }
  | '\\' 'n'   { Buffer.add_char buf '\n'; read_string2 buf lexbuf }
  | '\\' 'r'   { Buffer.add_char buf '\r'; read_string2 buf lexbuf }
  | '\\' 't'   { Buffer.add_char buf '\t'; read_string2 buf lexbuf }
  | [^ '"' '\\']+
    { Buffer.add_string buf (Lexing.lexeme lexbuf);
      read_string2 buf lexbuf }
  | _          { raise (SyntaxError ("Illegal string character: " ^ Lexing.lexeme lexbuf)) }
  | eof        { raise (SyntaxError ("String is not terminated")) }
