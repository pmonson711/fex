type 'a key = [ `Key of [ `String of 'a ] ]
type 'a value = [ `Value of [ `String of 'a | `Int of int | `Float of float ] ]
type 'a pair = [ `Pair of 'a key * 'a value ]

val filter_to_predicate :
     match_fun:('a Ast.match_type -> Ast.match_operation -> bool)
  -> Ast.t
  -> 'a pair
  -> bool

val pair_of_strings : 'a -> 'a -> 'a pair
