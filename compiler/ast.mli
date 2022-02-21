(** Delcare filter expression on operations

   {1 Overview}

    Declare filter expression on operations

    {1 Examples}

    TBD
    *)

(** To include or exclude the match in the final results *)
type match_operation_result =
  | Include
  | Exclude
[@@deriving show, eq]

type number = int * float option [@@deriving show, eq, ord]

type 'a match_type =
  [ `String of 'a
  | `Int of int
  | `Float of float
  ]

(** The type of operation to use in the the filter *)
type 'a string_match_operation =
  | ExactString of 'a
  | ContainsString of 'a list
  | BeginsWithString of 'a list
  | EndsWithString of 'a list
[@@deriving show, eq]

type number_match_operation =
  | ExactNumber of number
  | LessThanNumber of number
  | GreaterThanNumber of number
  | BetweeNumber of number * number
[@@deriving show, eq]

type 'a match_operation =
  | StringOp of 'a string_match_operation
  | NumberOp of number_match_operation
[@@deriving show, eq]

(** The full AST including opterations and include vs exclude result *)
type 'a t =
  | ValueFilter of match_operation_result * 'a match_operation
  | KeyFilter of match_operation_result * 'a match_operation
  | PairFilter of
      match_operation_result * 'a match_operation * 'a match_operation
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

val begins_with : 'a -> 'a match_operation
(** [begins_with s] Begins with builder for a single ['string] *)

val begins_with_in_order : 'a list -> 'a match_operation
(** [begins_with_in_order lst] Begin with operation builder for a list of ['string]. *)

val contains : 'a -> 'a match_operation
(** [contains s] Contains operation builder for a single ['string] *)

val contains_in_order : 'a list -> 'a match_operation
(** [contains_in_order lst] Conatins operation build for list of ['string]s *)

val ends_with : 'a -> 'a match_operation
(** [ends_with s] Ends with operation builder for single ['string] *)

val ends_with_in_order : 'a list -> 'a match_operation
(** [ends_with_in_order lst] Ends with operation builder for a list of ['string]s *)

val exact : 'a -> 'a match_operation
(** [exact str] Exact match operation builder for a single ['string] *)

val contains_key : ?op:match_operation_result -> 'a -> 'a t
(** [contains_key ?result k] Contains match operation builder for a single ['string] *)

val contains_pair : ?op:match_operation_result -> 'a -> 'a -> 'a t
(** [contains_pair ?result k v] Contains a pair with the key of k and a value of v *)

val contains_value : ?op:match_operation_result -> 'a -> 'a t
(** [contains_value ?result v] Contains a value of v *)

(** {2 Ast helpers} *)

val pair_filter :
  match_operation_result -> 'a match_operation -> 'a match_operation -> 'a t
(** [pair_filter result key_op value_op] Ast builder for a pair filter *)

val key_filter : match_operation_result -> 'a match_operation -> 'a t
(** [key_filter result op] Ast builder for a key filter *)

val value_filter : match_operation_result -> 'a match_operation -> 'a t
(** [value_filter result value_op] Ast builder for a value filter *)

val is_exclude : 'a t -> bool
(** [is_exclude ast] Check if an ast is exclude *)

val is_include : 'a t -> bool
(** [is_include ast] Check if an ast is include *)

val number_of_int : int -> number
val number_of_float : float -> number
val string_op_of_op : 'a match_operation -> 'a string_match_operation option
val number_op_of_op : 'a match_operation -> number_match_operation option
val number_comp : number -> number -> int
