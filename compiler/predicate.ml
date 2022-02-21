type 'a match_type =
  [ `String of 'a
  | `Int of int
  | `Float of float
  ]

type 'a key = [ `Key of [ `String of 'a ] ]
type 'a value = [ `Value of 'a match_type ]
type 'a pair = [ `Pair of 'a key * 'a value ]

let invert = Bool.not
let match_operation ~match_fun op (m : 'a match_type) : bool = match_fun m op
let match_type_of_string str : 'a match_type = `String str

let key_match_operation ~match_fun op (`Key (`String k) : 'a key) : bool =
  match_operation ~match_fun op @@ match_type_of_string k

let value_match_operation ~match_fun op (`Value v : 'a value) : bool =
  match_fun v op

let filter_to_predicate ~match_fun ast pair =
  let open Ast in
  let (`Pair (_, value)) = pair in
  let (`Pair (key, _)) = pair in
  match ast with
  | ValueFilter (Include, match_op) ->
      value_match_operation ~match_fun match_op value
  | ValueFilter (Exclude, match_op) ->
      invert @@ value_match_operation ~match_fun match_op value
  | KeyFilter (Include, match_op) -> key_match_operation ~match_fun match_op key
  | KeyFilter (Exclude, match_op) ->
      invert @@ key_match_operation ~match_fun match_op key
  | PairFilter (Include, key_match_op, value_match_op) ->
      key_match_operation ~match_fun key_match_op key
      && value_match_operation ~match_fun value_match_op value
  | PairFilter (Exclude, key_match_op, value_match_op) -> (
      match key_match_operation ~match_fun key_match_op key with
      | false -> true
      | true -> invert @@ value_match_operation ~match_fun value_match_op value)

let pair_of_strings k v = `Pair (`Key (`String k), `Value (`String v))
