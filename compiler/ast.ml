type match_operation_result =
  | Include
  | Exclude
[@@deriving show, eq]

type 'a match_type = [ `String of 'a ] [@@deriving show, eq]

type 'a match_operation =
  | Exact of 'a match_type
  | Contains of 'a match_type list
  | BeginsWith of 'a match_type list
  | EndsWith of 'a match_type list
[@@deriving show, eq]

type 'a t =
  | ValueFilter of match_operation_result * 'a match_operation
  | KeyFilter of match_operation_result * 'a match_operation
  | PairFilter of
      match_operation_result * 'a match_operation * 'a match_operation
[@@deriving show, eq]

let exc = Exclude
let inc = Include
let of_match_type (str : 'a) : 'a match_type = `String str

let list_of_match_type (lst : 'a list) : 'a match_type list =
  List.map of_match_type lst

let exact str = Exact (of_match_type str)
let contains_in_order lst = Contains (list_of_match_type lst)
let contains str = contains_in_order [ str ]
let begins_with_in_order lst = BeginsWith (list_of_match_type lst)
let begins_with str = begins_with_in_order [ str ]
let ends_with_in_order lst = EndsWith (list_of_match_type lst)
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
