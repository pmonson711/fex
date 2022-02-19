type match_operation_result =
  | Include
  | Exclude
[@@deriving show, eq]

type 'a match_operation =
  | ExactString of 'a
  | ContainsString of 'a list
  | BeginsWithString of 'a list
  | EndsWithString of 'a list
[@@deriving show, eq]

type 'a t =
  | ValueFilter of match_operation_result * 'a match_operation
  | KeyFilter of match_operation_result * 'a match_operation
  | PairFilter of
      match_operation_result * 'a match_operation * 'a match_operation
[@@deriving show, eq]

let exc = Exclude
let inc = Include
let exact str = ExactString str
let contains_in_order lst = ContainsString lst
let contains str = contains_in_order [ str ]
let begins_with_in_order lst = BeginsWithString lst
let begins_with str = begins_with_in_order [ str ]
let ends_with_in_order lst = EndsWithString lst
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
