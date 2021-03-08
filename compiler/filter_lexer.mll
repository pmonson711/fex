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

let str = [^ ':' '-' '+' ',' '.' '\'' '"' ' ']+
let whitespace = [' ' '\t']+
let ws = [' ' '\t']*
let newline = '\r' | '\n' | "\r\n"

rule read_tokens =
  parse
  | whitespace { SPACE }
  | newline    { next_line lexbuf; read_tokens lexbuf }
  | ws ':' ws  { COLON }
  | ws ',' ws  { COMMA }
  | ws '-' ws  { MINUS }
  | ws '+' ws  { PLUS }
  | '.'+       { DOTDOT }
  | '\''       { read_string (Buffer.create 17) lexbuf }
  | '"'        { read_string2 (Buffer.create 17) lexbuf }
  | str        { STRING (Lexing.lexeme lexbuf)}
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
