type pair = string * Ast.match_type

val filter_to_predicate :
     match_fun:(Ast.match_type -> Ast.match_operation -> bool)
  -> Ast.t
  -> pair
  -> bool

val pair_of_strings : string -> string -> pair

val pair_of :
     [ `Pair of
       [ `Key of [ `String of string ] ]
       * [ `Value of [ `String of string | `Int of int | `Float of float ] ]
     ]
  -> pair
