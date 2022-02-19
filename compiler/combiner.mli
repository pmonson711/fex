val imply_logical_operators :
     equal_fun:('a Ast.match_type -> 'a Ast.match_type -> bool)
  -> 'a Ast.t list
  -> 'a Ast.t list list

val apply_list_of_filters_for_pair :
     match_fun:('a Ast.match_type -> 'a Ast.match_operation -> bool)
  -> equal_fun:('a Ast.match_type -> 'a Ast.match_type -> bool)
  -> 'a Ast.t list
  -> 'a Predicate.pair
  -> bool

val apply_list_of_filters_for_list_of_pairs :
     match_fun:('a Ast.match_type -> 'a Ast.match_operation -> bool)
  -> equal_fun:('a Ast.match_type -> 'a Ast.match_type -> bool)
  -> 'a Ast.t list
  -> 'a Predicate.pair list
  -> bool

val group_as :
     equal_fun:('a Ast.match_type -> 'a Ast.match_type -> bool)
  -> 'a Ast.t
  -> 'a Ast.t
  -> bool
