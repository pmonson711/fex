val filter_to_predicate : string * string -> Ast.t -> bool

val key_match_operation : string -> Ast.match_operation -> bool

val value_match_operation : string -> Ast.match_operation -> bool
