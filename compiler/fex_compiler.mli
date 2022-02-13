module Ast = Ast

type parsed_result = (string Ast.t list, string) result [@@deriving show]

exception Grammar_error of string

val filter_from_string : string -> parsed_result
val filter_from_file : string -> parsed_result
val pair_of_strings : string -> string -> string Predicate.pair
val apply_filter : string Ast.t -> string Predicate.pair -> bool
val apply_list_filter : string Ast.t list -> string Predicate.pair -> bool

val apply_list_filter_for_pairs :
  string Ast.t list -> string Predicate.pair list -> bool
