type key = [ `Key of string ]

type value = [ `Value of string ]

type t = [ `Pair of key * value ]

val key_of_string : string -> key

val value_of_string : string -> value

val of_strings : string -> string -> t
