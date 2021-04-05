type key = [ `Key of string ] [@@deriving show, eq]

type value = [ `Value of string ] [@@deriving show, eq]

type t = [ `Pair of key * value ] [@@deriving show, eq]

val key_of_string : string -> key

val value_of_string : string -> value

val of_strings : string -> string -> t
