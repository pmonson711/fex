type 'a key = [ `Key of 'a ]
type ('a, 'b) value = [ `Value of [ `String of 'a | `Int of 'b ] ]
type ('a, 'b) pair = [ `Pair of 'a key * ('a, 'b) value ]

let invert = Bool.not

let key_match_operation ~match_fun op (`Key str : 'a key) : bool =
  match_fun str op

let value_match_operation ~match_fun op (`Value value : ('a, 'b) value) : bool =
  match value with
  | `String str -> match_fun str op
  | `Int _n -> failwith "Not implemented yet"

let filter_to_predicate ~match_fun (ast : 'a Ast.t) (pair : ('a, 'b) pair) =
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

let pair_of_strings k v = `Pair (`Key k, `Value (`String v))
let pair_of_int k v = `Pair (`Key k, `Value (`Int v))
