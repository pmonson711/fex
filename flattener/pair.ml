module JsonPrimatives = struct
  type t =
    [ `Null
    | `Bool of bool
    | `Int of int
    | `Float of float
    | `String of string
    ]
  [@@deriving show, eq]
end

type key = [ `Key of [ `String of string ] ] [@@deriving show, eq]
type value = [ `Value of JsonPrimatives.t ] [@@deriving show, eq]
type t = [ `Pair of key * value ] [@@deriving show, eq]

module StringPair = struct
  type key = [ `Key of [ `String of string ] ] [@@deriving show, eq]
  type value = [ `Value of [ `String of string ] ] [@@deriving show, eq]
  type t = [ `Pair of key * value ] [@@deriving show, eq]
end

let key_of_string k = `Key (`String k)
let value_of_string v = `Value (`String v)
let of_strings k v = `Pair (key_of_string k, value_of_string v)

let to_string_tuple
    (`Pair (`Key (`String k), `Value (`String v)) : StringPair.t) =
  (k, v)
