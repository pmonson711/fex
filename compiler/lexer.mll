{
open Lexing
open Tokens

exception SyntaxError of string

let next_line lexbuf =
  let pos = lexbuf.lex_curr_p in
  lexbuf.lex_curr_p <-
    { pos with pos_bol = lexbuf.lex_curr_pos;
               pos_lnum = pos.pos_lnum + 1
    }
}

let digit = ['0'-'9']
let alpha = ['a'-'z' 'A'-'Z']
let int = '-'? digit+
let id = (alpha) (alpha|digit|'_')*
let whitespace = [' ' '\t']+
let newline = '\r' | '\n' | "\r\n"

rule read_tokens =
  parse
  | whitespace { read_tokens lexbuf }
  | newline    { next_line lexbuf; read_tokens lexbuf }
  | ':'        { COLON }
  | ','        { COMMA }
  | '-'        { MINUS }
  | '+'        { PLUS }
  | id         { STRING (Lexing.lexeme lexbuf) }
  | _          { raise (SyntaxError ("Unexpected char: " ^ Lexing.lexeme lexbuf)) }
  | eof        { EOF }
