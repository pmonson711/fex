open Ast

let invert = function true -> false | false -> true

module MatchInOrder = struct
  let match_in_order_acc ~comp ~subs:sub_list to_check =
    let open CCString in
    let init_acc = (false, 0) in
    let is_in_order acc to_find =
      match acc with
      | false, left when left != 0 -> (false, left)
      | _, idx ->
          let found = find ~start:idx ~sub:to_find to_check in
          let is_found = comp found idx in
          let next_idx = if is_found then found + length to_find else idx in
          (is_found, next_idx)
    in
    List.fold_left is_in_order init_acc sub_list

  let fst input = match input with b, _ -> b

  let match_in_order ~comp ~subs to_check =
    match_in_order_acc ~comp ~subs to_check |> fst

  let contains_in_order ~subs string_to_check =
    match_in_order ~comp:(fun found _ -> found != -1) ~subs string_to_check

  let begins_with_in_order ~subs string_to_check =
    match_in_order ~comp:(fun found idx -> found == idx) ~subs string_to_check

  let ends_with_in_order ~subs to_check =
    begins_with_in_order
      ~subs:(List.rev subs |> List.map CCString.rev)
      (CCString.rev to_check)

  let string_match_operation (from_input : string) =
    let open CCString in
    function
    | Exact expected  -> equal from_input expected
    | Contains subs   -> contains_in_order ~subs from_input
    | BeginsWith subs -> begins_with_in_order ~subs from_input
    | EndsWith subs   -> ends_with_in_order ~subs from_input
end

let key_match_operation = MatchInOrder.string_match_operation

let value_match_operation = MatchInOrder.string_match_operation

let filter_to_predicate (key, value) = function
  | ValueFilter (Include, match_op) -> value_match_operation value match_op
  | ValueFilter (Exclude, match_op) ->
      invert @@ value_match_operation value match_op
  | KeyFilter (Include, match_op) -> key_match_operation key match_op
  | KeyFilter (Exclude, match_op) -> invert @@ key_match_operation key match_op
  | PairFilter (Include, key_match_op, value_match_op) ->
      key_match_operation key key_match_op
      && value_match_operation value value_match_op
  | PairFilter (Exclude, key_match_op, value_match_op) -> (
      match key_match_operation key key_match_op with
      | false -> true
      | true  -> invert @@ value_match_operation value value_match_op )
