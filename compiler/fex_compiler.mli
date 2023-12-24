module Ast = Ast
module Predicate = Predicate
module Matcher = Match_in_order
module Combiner = Combiner

type parsed_result = (string Ast.t list, string) result
(** A result from parsing a fex query. *)

val pp_parsed_result : Format.formatter -> parsed_result -> unit
val show_parsed_result : parsed_result -> string

exception Grammar_error of string
(** Grammer errors are errors that lex correctly but include no valid [!Ast] *)

val filter_from_string : string -> parsed_result
(** Gets the filter ast from a string. *)

val filter_from_file : string -> parsed_result
(** Gets the filter ast from a file. *)

val pair_of_strings : string -> string -> string Predicate.pair
(** constructor for a pair of strings, useful to convert a source before appling a filter. *)

val apply_filter :
     ?match_fun:(string Ast.match_type -> string Ast.match_operation -> bool)
  -> string Ast.t
  -> string Predicate.pair
  -> bool
(** Does the filtering work on the pair, one filter and one pair. *)

val apply_list_filter :
     ?match_fun:(string Ast.match_type -> string Ast.match_operation -> bool)
  -> string Ast.t list
  -> string Predicate.pair
  -> bool
(** Does the filtering of a group of filters on a single pair. *)

val apply_list_filter_for_pairs :
     ?match_fun:(string Ast.match_type -> string Ast.match_operation -> bool)
  -> string Ast.t list
  -> string Predicate.pair list
  -> bool
(** Does the filtering of a group of filters on a list of pairs. *)
