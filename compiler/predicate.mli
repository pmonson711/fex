val filter_to_predicate : Ast.t -> string * string -> bool

val key_match_operation : Ast.match_operation -> string -> bool

val value_match_operation : Ast.match_operation -> string -> bool
