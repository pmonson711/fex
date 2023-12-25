type key = [ `Key of [ `String of string ] ]
type value = [ `Value of [ `String of string | `Int of int | `Float of float ] ]
type pair = [ `Pair of key * value ]

val filter_to_predicate :
     match_fun:(Ast.match_type -> Ast.match_operation -> bool)
  -> Ast.t
  -> pair
  -> bool

val pair_of_strings : string -> string -> pair
