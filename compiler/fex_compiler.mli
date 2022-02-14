module Ast = Ast

type parsed_result = (string Ast.t list, string) result [@@deriving show]
(** A result from parsing a fex query. *)

exception Grammar_error of string
(** Grammer errors are errors that lex correctly but include no valid [!Ast] *)

val filter_from_string : string -> parsed_result
(** Gets the filter ast from a string. *)

val filter_from_file : string -> parsed_result
(** Gets the filter ast from a file. *)

val pair_of_strings : string -> string -> string Predicate.pair
(** constructor for a pair of strings, useful to convert a source before appling a filter. *)

val apply_filter : string Ast.t -> string Predicate.pair -> bool
(** Does the filtering work on the pair, one filter and one pair. *)

val apply_list_filter : string Ast.t list -> string Predicate.pair -> bool
(** Does the filtering of a group of filters on a single pair. *)

val apply_list_filter_for_pairs :
  string Ast.t list -> string Predicate.pair list -> bool
(** Does the filtering of a group of filters on a list of pairs. *)
