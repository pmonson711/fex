type key = [ `Key of string ] [@@deriving show, eq]

type value = [ `Value of string ] [@@deriving show, eq]

type t = [ `Pair of key * value ] [@@deriving show, eq]

let key_of_string k = `Key k

let value_of_string v = `Value v

let of_strings k v = `Pair (key_of_string k, value_of_string v)
