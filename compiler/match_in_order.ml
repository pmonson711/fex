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

let string_match_operation (from_input : string)
    (ast : string Ast.match_operation) : bool =
  let open CCString in
  match ast with
  | Exact `String expected ->
      equal
        (String.lowercase_ascii from_input)
        (String.lowercase_ascii expected)
  | Contains subs ->
      contains_in_order
        ~subs:(List.map String.lowercase_ascii subs)
        (String.lowercase_ascii from_input)
  | BeginsWith subs ->
      begins_with_in_order
        ~subs:(List.map String.lowercase_ascii subs)
        (String.lowercase_ascii from_input)
  | EndsWith subs ->
      ends_with_in_order
        ~subs:(List.map String.lowercase_ascii subs)
        (String.lowercase_ascii from_input)

module T = struct
  type t = string [@@deriving show]

  let equal = CCString.equal
end
