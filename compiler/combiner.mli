val imply_logical_operators :
  equal_fun:(string -> string -> bool) -> Ast.t list -> Ast.t list list

val apply_list_of_filters_for_pair :
     match_fun:('a Ast.match_type -> Ast.match_operation -> bool)
  -> equal_fun:(string -> string -> bool)
  -> Ast.t list
  -> 'a Predicate.pair
  -> bool

val apply_list_of_filters_for_list_of_pairs :
     match_fun:('a Ast.match_type -> Ast.match_operation -> bool)
  -> equal_fun:(string -> string -> bool)
  -> Ast.t list
  -> 'a Predicate.pair list
  -> bool
