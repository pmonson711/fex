val imply_logical_operators : Ast.t list -> Ast.t list list

val apply_list_of_filters_for_pair : Ast.t list -> Predicate.pair -> bool

val apply_list_of_filters_for_list_of_pairs :
  Ast.t list -> Predicate.pair list -> bool
