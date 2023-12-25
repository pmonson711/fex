val imply_logical_operators : Ast.t list -> Ast.t list list
val apply : fn:(Ast.t -> bool) -> Ast.t list -> bool
val apply_list : fn:(Ast.t list -> bool) -> Ast.t list list -> bool

val apply_list_of_filters_for_pair :
     match_fun:(Ast.match_type -> Ast.match_operation -> bool)
  -> Ast.t list
  -> Predicate.pair
  -> bool

val apply_list_of_filters_for_list_of_pairs :
     match_fun:(Ast.match_type -> Ast.match_operation -> bool)
  -> Ast.t list
  -> Predicate.pair list
  -> bool

val list_of_filters_for_list_of_pairs :
     match_fun:(Ast.match_type -> Ast.match_operation -> bool)
  -> Predicate.pair list
  -> Ast.t list
  -> bool

val list_of_filters_for_pair :
     match_fun:(Ast.match_type -> Ast.match_operation -> bool)
  -> Predicate.pair
  -> Ast.t list
  -> bool
