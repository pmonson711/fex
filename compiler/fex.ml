type match_operation_result =
  | Include
  | Exclude

type match_operation =
  | Exact           of string
  | Contains        of string
  | ContainsInOrder of string list
  | BeginsWith      of string
  | EndsWith        of string

type t =
  | ValueFiler of match_operation_result * match_operation
  | KeyFilter  of match_operation_result * match_operation
  | PairFilter of match_operation_result * match_operation * match_operation
