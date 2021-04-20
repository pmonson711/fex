module JSON : sig
  type t =
    [ `Null
    | `Bool    of bool
    | `Int     of int
    | `Intlit  of string
    | `Float   of float
    | `String  of string
    | `Assoc   of (string * t) list
    | `List    of t list
    | `Tuple   of t list
    | `Variant of string * t option
    ]
end

type pairs = Pair.StringPair.t list [@@deriving show, eq]

val pair_of_json : JSON.t -> Pair.StringPair.t list

val pairs_of_json_array :
  [ `List of JSON.t list ] -> Pair.StringPair.t list list

val pair_list_of_json : JSON.t -> Pair.StringPair.t list
