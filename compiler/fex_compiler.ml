open Lexing
module I = Filter_parser.MenhirInterpreter
module Ast = Ast

exception Grammar_error of string

type parsed_result = (string Ast.t list, string) result [@@deriving show]

exception Syntax_error of ((int * int * int option) option * string)

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
        (None, "invalid syntax (no specific message for this eror)"))

let rec parse lexbuf (checkpoint : string Ast.t list I.checkpoint) =
  match checkpoint with
  | I.InputNeeded _env ->
      let token = Filter_lexer.read_tokens lexbuf in
      let startp = lexbuf.lex_start_p
      and endp = lexbuf.lex_curr_p in
      let checkpoint = I.offer checkpoint (token, startp, endp) in
      parse lexbuf checkpoint
  | I.Shifting _ | I.AboutToReduce _ ->
      let checkpoint = I.resume checkpoint in
      parse lexbuf checkpoint
  | I.HandlingError env ->
      let line, pos = get_lexing_position lexbuf in
      let state, err = get_parse_error env in
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
      | None -> Error (Printf.sprintf "Syntax error: %s" err))
  | Grammar_error msg -> Error (Printf.sprintf "Grammar error: %s" msg)

let filter_from_string str = str |> Lexing.from_string |> parse_from
let filter_from_channel ic = ic |> Lexing.from_channel |> parse_from
let filter_from_file filename = filename |> open_in |> filter_from_channel
let pair_of_strings = Predicate.pair_of_strings

let apply_filter =
  Predicate.filter_to_predicate ~match_fun:Match_in_order.match_operation

let apply_list_filter =
  Combiner.apply_list_of_filters_for_pair
    ~match_fun:Match_in_order.match_operation ~equal_fun:CCString.equal

let apply_list_filter_for_pairs =
  Combiner.apply_list_of_filters_for_list_of_pairs
    ~match_fun:Match_in_order.match_operation ~equal_fun:CCString.equal
