let match_in_order_acc ~comp ~subs:sub_list to_check =
  let open CCString in
  let init_acc = (false, 0) in
  let is_in_order acc to_find =
    match acc with
    | false, left when left != 0 -> (false, left)
    | _, idx ->
        let found = find ~start:idx ~sub:to_find to_check in
        let is_found = comp found idx in
        let next_idx =
          if is_found then found + length to_find else idx + length to_find
        in
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
    (match_op : Ast.string_match_operation) : bool =
  let open CCString in
  match match_op with
  | ExactString expected ->
      equal
        (String.lowercase_ascii from_input)
        (String.lowercase_ascii expected)
  | ContainsString subs ->
      contains_in_order
        ~subs:(List.map String.lowercase_ascii subs)
        (String.lowercase_ascii from_input)
  | BeginsWithString subs ->
      begins_with_in_order
        ~subs:(List.map String.lowercase_ascii subs)
        (String.lowercase_ascii from_input)
  | EndsWithString subs ->
      ends_with_in_order
        ~subs:(List.map String.lowercase_ascii subs)
        (String.lowercase_ascii from_input)

let number_match_operation (from_input : Ast.number)
    (match_op : Ast.number_match_operation) : bool =
  match match_op with
  | ExactNumber expected -> Ast.number_comp from_input expected == 0
  | Ast.LessThanNumber lower -> Ast.number_comp lower from_input == 1
  | Ast.GreaterThanNumber upper -> Ast.number_comp from_input upper == 1
  | Ast.BetweenNumber (lower, upper) ->
      Ast.number_comp from_input upper == -1
      && Ast.number_comp lower from_input == -1

let match_operation (typed_from_input : Ast.match_type)
    (op : Ast.match_operation) : bool =
  match typed_from_input with
  | String s -> (
      match Ast.string_op_of_op op with
      | Some string_op -> string_match_operation s string_op
      | None -> false)
  | Int i -> (
      match Ast.number_op_of_op op with
      | Some num_op -> number_match_operation (Ast.number_of_int i) num_op
      | None -> false)
  | Float f -> (
      match Ast.number_op_of_op op with
      | Some num_op -> number_match_operation (Ast.number_of_float f) num_op
      | None -> false)

module T = struct
  type t = string [@@deriving show]

  let equal = CCString.equal
end
