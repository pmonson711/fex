module JSON : sig
  type t =
    [ `Null
    | `Bool   of bool
    | `Int    of int
    | `Float  of float
    | `String of string
    | `Assoc  of (string * t) list
    | `List   of t list
    ]

end

val pair_of_json : JSON.t -> Pair.t list
