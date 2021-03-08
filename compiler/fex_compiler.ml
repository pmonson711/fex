include Ast
open Lexing
module I = Filter_parser.MenhirInterpreter

exception Syntax_error of ((int * int * int option) option * string)

exception Grammar_error of string

let get_lexing_position lexbuf =
  let p = Lexing.lexeme_start_p lexbuf in
  let line_number = p.Lexing.pos_lnum in
  let column = p.Lexing.pos_cnum - p.Lexing.pos_bol + 1 in
  (line_number, column)

let get_parse_error env =
  match I.stack env with
  | (lazy Nil) -> (None, "Invalid syntax")
  | (lazy (Cons (I.Element (state, _, _, _), _))) -> (
      try
        (Some (I.number state), Filter_parser_messages.message (I.number state))
      with Not_found ->
        (None, "invalid syntax (no specific message for this eror)") )

let rec parse lexbuf (checkpoint : Ast.t list I.checkpoint) =
  match checkpoint with
  | I.InputNeeded _env ->
      let token = Lexer.read_tokens lexbuf in
      let startp = lexbuf.lex_start_p
      and endp = lexbuf.lex_curr_p in
      let checkpoint = I.offer checkpoint (token, startp, endp) in
      parse lexbuf checkpoint
  | I.Shifting _ | I.AboutToReduce _ ->
      let checkpoint = I.resume checkpoint in
      parse lexbuf checkpoint
  | I.HandlingError _env ->
      let line, pos = get_lexing_position lexbuf in
      let state, err = get_parse_error _env in
      raise (Syntax_error (Some (line, pos, state), err))
  | I.Accepted v -> v
  | I.Rejected ->
      raise (Syntax_error (None, "invalid syntax (parser rejected the input)"))

let parse_from lexbuf =
  try
    let checkpoint = Filter_parser.Incremental.terms lexbuf.lex_curr_p in
    let grammar = parse lexbuf checkpoint in
    Ok grammar
  with
  | Syntax_error (pos, err) -> (
      match pos with
      | Some (line, pos, state) ->
          Error
            (Printf.sprintf "Syntax error %d on line %d, character %d: %s"
               (Option.value state ~default:(-1))
               line pos err)
      | None                    -> Error (Printf.sprintf "Syntax error: %s" err)
      )
  | Grammar_error msg       -> Error (Printf.sprintf "Grammar error: %s" msg)

let filter_from_string str = str |> Lexing.from_string |> parse_from

let filter_from_channel ic = ic |> Lexing.from_channel |> parse_from

let filter_from_file filename =
  let ic = open_in filename in
  filter_from_channel ic

let filter_of = Filter_parser.prog @@ Lexer.read_tokens

let filter_of_string str = str |> Lexing.from_string |> filter_of
