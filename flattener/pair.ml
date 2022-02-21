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

  type value =
    [ `Value of [ `String of string | `Int of int | `Float of float ] ]
  [@@deriving show, eq]

  type t = [ `Pair of key * value ] [@@deriving show, eq]
end

let key_of_string k = `Key (`String k)
let value_of_string v = `Value (`String v)
let value_of_int v = `Value (`Int v)
let value_of_float v = `Value (`Float v)
let of_string k v = `Pair (key_of_string k, value_of_string v)
let of_int k v = `Pair (key_of_string k, value_of_int v)
let of_float k v = `Pair (key_of_string k, value_of_float v)

let of_json_primatives k v =
  match v with
  | `Int i -> of_int k i
  | `Float f -> of_float k f
  | `String s -> of_string k s

let to_string_tuple = function
  | (`Pair (`Key (`String k), `Value (`String v)) : StringPair.t) -> (k, v)
  | (`Pair (`Key (`String k), `Value (`Int v)) : StringPair.t) ->
      (k, string_of_int v)
  | (`Pair (`Key (`String k), `Value (`Float v)) : StringPair.t) ->
      (k, string_of_float v)
