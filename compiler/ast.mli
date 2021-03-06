(** {1 Overview} 

    Declare filter expression on operations

    {1 Examples}

    TBD
    *)

(** To include or exclude the match in the final results *)
type match_operation_result =
  | Include
  | Exclude
[@@deriving show, eq]

(** The type of operation to use in the the filter *)
type match_operation =
  | Exact      of string
  | Contains   of string list
  | BeginsWith of string list
  | EndsWith   of string list
[@@deriving show, eq]

(** The full AST including opterations and include vs exclude result *)
type t =
  | ValueFilter of match_operation_result * match_operation
  | KeyFilter   of match_operation_result * match_operation
  | PairFilter  of match_operation_result * match_operation * match_operation
[@@deriving show, eq]

(** {1 Helpers } 

    Helper functions to allow easy building of the type.  

    {2 Result builders} 

    Functions wich return static values of the match_operation_result type. 
    *)

val exc : match_operation_result
(** [exc] Exclude helper *)

val inc : match_operation_result
(** [inc] Include helper *)

(** {2 Operation Helpers} 

    Helpers to build operations
    *)

val begins_with : string -> match_operation
(** [begins_with s] Begins with builder for a single string *)

val begins_with_in_order : string list -> match_operation
(** [begins_with_in_order lst] Begin with operation builder for a list of string. *)

val contains : string -> match_operation
(** [contains s] Contains operation builder for a single string *)

val contains_in_order : string list -> match_operation
(** [contains_in_order lst] Conatins operation build for list of strings *)

val ends_with : string -> match_operation
(** [ends_with s] Ends with operation builder for single string *)

val ends_with_in_order : string list -> match_operation
(** [ends_with_in_order lst] Ends with operation builder for a list of strings *)

val exact : string -> match_operation
(** [exact str] Exact match operation builder for a single string *)

val contains_key : ?op:match_operation_result -> string -> t
(** [contains_key ?result k] Contains match operation builder for a single string *)

val contains_pair : ?op:match_operation_result -> string -> string -> t
(** [contains_pair ?result k v] Contains a pair with the key of k and a value of v *)

val contains_value : ?op:match_operation_result -> string -> t
(** [contains_value ?result v] Contains a value of v *)

(** {2 Ast helpers} *)

val pair_filter :
  match_operation_result -> match_operation -> match_operation -> t
(** [pair_filter result key_op value_op] Ast builder for a pair filter *)

val key_filter : match_operation_result -> match_operation -> t
(** [key_filter result op] Ast builder for a key filter *)

val value_filter : match_operation_result -> match_operation -> t
(** [value_filter result value_op] Ast builder for a value filter *)

val is_exclude : t -> bool
(** [is_exclude ast] Check if an ast is exclude *)

val is_include : t -> bool
(** [is_include ast] Check if an ast is include *)
