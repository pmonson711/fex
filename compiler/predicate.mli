type 'a key = [ `Key of 'a ]
type ('a, 'b) value = [ `Value of [ `String of 'a | `Int of 'b ] ]
type ('a, 'b) pair = [ `Pair of 'a key * ('a, 'b) value ]

val filter_to_predicate :
     match_fun:('a -> 'a Ast.match_operation -> bool)
  -> 'a Ast.t
  -> ('a, 'b) pair
  -> bool

val pair_of_strings : 'a -> 'a -> ('a, 'b) pair
val pair_of_int : 'a -> 'b -> ('a, 'b) pair
