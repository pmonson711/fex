let match_operation (typed_from_input : Ast.match_type)
    (op : Ast.match_operation) : bool =
  match typed_from_input with
  | Ast.String s -> (
      match Ast.string_op_of_op op with
      | Some string_op -> Match_string.check_match s string_op
      | None -> false)
  | Ast.Int i -> (
      match Ast.number_op_of_op op with
      | Some num_op -> Match_number.check_match (Ast.number_of_int i) num_op
      | None -> false)
  | Ast.Float f -> (
      match Ast.number_op_of_op op with
      | Some num_op -> Match_number.check_match (Ast.number_of_float f) num_op
      | None -> false)
  | _ -> false
