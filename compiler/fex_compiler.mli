module Ast = Ast

type parsed_result = (Ast.t list, string) result [@@deriving show]

exception Grammar_error of string

val filter_from_string : string -> parsed_result
val filter_from_file : string -> parsed_result
val pair_of_strings : string -> string -> Predicate.pair
val apply_filter : Ast.t -> Predicate.pair -> bool
val apply_list_filter : Ast.t list -> Predicate.pair -> bool
val apply_list_filter_for_pairs : Ast.t list -> Predicate.pair list -> bool
