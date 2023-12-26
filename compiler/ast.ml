type match_operation_result =
  | Include
  | Exclude
[@@deriving show, eq]

type match_type =
  | String of string
  | Int of int
  | Float of float

module Number = struct
  type t = string * int * float option [@@deriving show, ord]

  let equal (_, i1, rf1) (_, i2, rf2) = i1 = i2 && rf1 = rf2
  let of_int i = (string_of_int i, i, None)

  let of_float f =
    if Float.is_integer f then (Float.to_string f, Float.to_int f, None)
    else (Float.to_string f, Float.to_int f, Some (f -. Float.trunc f))

  let of_string s =
    let _, i, rf = of_float @@ Float.of_string s in
    (String.trim s, i, rf)
end

type string_match_operation =
  | ExactString of string
  | ContainsString of string list
  | BeginsWithString of string list
  | EndsWithString of string list
[@@deriving show, eq]

type number = Number.t [@@deriving show, eq, ord]

type number_match_operation =
  | ExactNumber of number
  | LessThanNumber of number
  | GreaterThanNumber of number
  | BetweenNumber of number * number
[@@deriving show, eq]

type match_operation =
  | StringOp of string_match_operation
  | NumberOp of number_match_operation
[@@deriving show, eq]

type t =
  | ValueFilter of match_operation_result * match_operation
  | KeyFilter of match_operation_result * match_operation
  | PairFilter of match_operation_result * match_operation * match_operation
[@@deriving show, eq]

let exc = Exclude
let inc = Include
let string_op op = StringOp op
let string_op_of_op = function StringOp op -> Some op | NumberOp _ -> None
let number_op_of_op = function StringOp _ -> None | NumberOp op -> Some op
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
let number_of_string = Number.of_string
let number_comp = Number.compare
let number_op op = NumberOp op
let exact_of_num num = number_op (ExactNumber num)
let exact_of_int num = num |> number_of_int |> exact_of_num
let exact_of_float num = num |> number_of_float |> exact_of_num
let exact_of_string num = num |> number_of_string |> exact_of_num
let less_than num = number_op (LessThanNumber num)
let less_than_of_int num = num |> number_of_int |> less_than
let less_than_of_float num = num |> number_of_float |> less_than
let less_than_of_string num = num |> number_of_string |> less_than
let greater_than num = number_op (GreaterThanNumber num)
let greater_than_of_int num = num |> number_of_int |> greater_than
let greater_than_of_float num = num |> number_of_float |> greater_than
let greater_than_of_string num = num |> number_of_string |> greater_than
let between low high = number_op (BetweenNumber (low, high))
let between_of_int low high = between (number_of_int low) (number_of_int high)

let between_of_float low high =
  between (number_of_float low) (number_of_float high)

let between_of_string low high =
  between (number_of_string low) (number_of_string high)
