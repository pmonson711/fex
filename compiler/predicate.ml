type pair = string * Ast.match_type

let invert = Bool.not
let match_operation ~match_fun op (m : Ast.match_type) : bool = match_fun m op
let match_type_of_string str : Ast.match_type = String str

let key_match_operation ~match_fun op (k : string) : bool =
  match_operation ~match_fun op @@ match_type_of_string k

let value_match_operation ~match_fun op (v : Ast.match_type) : bool =
  match_fun v op

let pair_of (`Pair (`Key (`String k), `Value v)) =
  match v with
  | `String s -> (k, Ast.String s)
  | `Int i -> (k, Ast.Int i)
  | `Float f -> (k, Ast.Float f)

let filter_to_predicate ~match_fun ast pair =
  let open Ast in
  let _, value = pair in
  let key, _ = pair in
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

let pair_of_strings k v = (k, Ast.String v)
