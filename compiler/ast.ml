type match_operation_result =
  | Include
  | Exclude
[@@deriving show, eq]

type 'a match_type = [ `String of 'a ]

module Number = struct
  type t = int * float option [@@deriving show, eq, ord]

  let of_int i = (i, None)

  let of_float f =
    if Float.is_integer f then (Float.to_int f, None)
    else (Float.to_int f, Some (f -. Float.trunc f))
end

type 'a string_match_operation =
  | ExactString of 'a
  | ContainsString of 'a list
  | BeginsWithString of 'a list
  | EndsWithString of 'a list
[@@deriving show, eq]

type number = Number.t [@@deriving show, eq, ord]

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

type 'a t =
  | ValueFilter of match_operation_result * 'a match_operation
  | KeyFilter of match_operation_result * 'a match_operation
  | PairFilter of
      match_operation_result * 'a match_operation * 'a match_operation
[@@deriving show, eq]

let exc = Exclude
let inc = Include
let string_op op = StringOp op

let string_op_of_op = function
  | StringOp op -> op
  | NumberOp _ -> failwith "Attempted to get StringOp for NumberOp"

let exact str = string_op (ExactString str)
let contains_in_order lst = string_op (ContainsString lst)
let contains str = contains_in_order [ str ]
let begins_with_in_order lst = string_op (BeginsWithString lst)
let begins_with str = begins_with_in_order [ str ]
let ends_with_in_order lst = string_op (EndsWithString lst)
let ends_with str = ends_with_in_order [ str ]
let value_filter a b = ValueFilter (a, b)
let key_filter a b = KeyFilter (a, b)
let pair_filter a b c = PairFilter (a, b, c)
let contains_value ?(op = Include) value = value_filter op (contains value)

let contains_pair ?(op = Include) key value =
  pair_filter op (contains key) (contains value)

let contains_key ?(op = Include) key = key_filter op (contains key)

let is_include = function
  | ValueFilter (Include, _) -> true
  | KeyFilter (Include, _) -> true
  | PairFilter (Include, _, _) -> true
  | _ -> false

let is_exclude = function
  | ValueFilter (Exclude, _) -> true
  | KeyFilter (Exclude, _) -> true
  | PairFilter (Exclude, _, _) -> true
  | _ -> false

let number_of_int = Number.of_int
let number_of_float = Number.of_float
