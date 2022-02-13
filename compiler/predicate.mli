type key = [ `Key of string ]
type value = [ `Value of [ `String of string ] ]
type pair = [ `Pair of key * value ]

val pair_of_strings : string -> string -> pair
val filter_to_predicate : Ast.t -> pair -> bool
val key_match_operation : Ast.match_operation -> key -> bool
val value_match_operation : Ast.match_operation -> value -> bool
