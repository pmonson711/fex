type match_operation_result =
  | Include
  | Exclude
[@@deriving show, eq]

type match_operation =
  | Exact      of string
  | Contains   of string list
  | BeginsWith of string list
  | EndsWith   of string list
[@@deriving show, eq]

type t =
  | ValueFilter of match_operation_result * match_operation
  | KeyFilter   of match_operation_result * match_operation
  | PairFilter  of match_operation_result * match_operation * match_operation
[@@deriving show, eq]

type parsed = t list option [@@deriving show]

let inc = Include

let exc = Exclude

let exact str = Exact str

let contains str = Contains [ str ]

let begins_with str = BeginsWith [ str ]

let ends_with str = EndsWith [ str ]

let value_filter a b = ValueFilter (a, b)

let key_filter a b = KeyFilter (a, b)

let pair_filter a b c = PairFilter (a, b, c)

let contains_value ?(op = Include) value = value_filter op (contains value)

let contains_pair ?(op = Include) key value =
  pair_filter op (contains key) (contains value)

let contains_key ?(op = Include) key = key_filter op (contains key)
