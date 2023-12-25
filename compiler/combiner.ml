type t =
  | IncludeValueGroup
  | ExcludeValueGroup
  | IncludeKeyGroup
  | ExcludeKeyGroup
  | IncludePairGroupExactString of string
  | IncludePairGroupContainsString of string list
  | IncludePairGroupBeginsWithString of string list
  | IncludePairGroupEndsWithString of string list
  | ExcludePairGroupExactString of string
  | ExcludePairGroupContainsString of string list
  | ExcludePairGroupBeginsWithString of string list
  | ExcludePairGroupEndsWithString of string list
  | IncludePairGroupExactNumber of Ast.number
  | IncludePairGroupLessThanNumber of Ast.number
  | IncludePairGroupGreaterThanNumber of Ast.number
  | IncludePairGroupBetweenNumber of Ast.number * Ast.number
  | ExcludePairGroupExactNumber of Ast.number
  | ExcludePairGroupLessThanNumber of Ast.number
  | ExcludePairGroupGreaterThanNumber of Ast.number
  | ExcludePairGroupBetweenNumber of Ast.number * Ast.number
[@@deriving eq]

let as_group a b =
  let categorize =
    let open Ast in
    function
    | ValueFilter (Include, _) -> IncludeValueGroup
    | ValueFilter (Exclude, _) -> ExcludeValueGroup
    | KeyFilter (Include, _) -> IncludeKeyGroup
    | KeyFilter (Exclude, _) -> ExcludeKeyGroup
    | PairFilter (Include, StringOp (ExactString key), _) ->
        IncludePairGroupExactString key
    | PairFilter (Include, StringOp (ContainsString keys), _) ->
        IncludePairGroupContainsString keys
    | PairFilter (Include, StringOp (BeginsWithString keys), _) ->
        IncludePairGroupBeginsWithString keys
    | PairFilter (Include, StringOp (EndsWithString keys), _) ->
        IncludePairGroupEndsWithString keys
    | PairFilter (Exclude, StringOp (ExactString key), _) ->
        ExcludePairGroupExactString key
    | PairFilter (Exclude, StringOp (ContainsString keys), _) ->
        ExcludePairGroupContainsString keys
    | PairFilter (Exclude, StringOp (BeginsWithString keys), _) ->
        ExcludePairGroupBeginsWithString keys
    | PairFilter (Exclude, StringOp (EndsWithString keys), _) ->
        ExcludePairGroupEndsWithString keys
    | PairFilter (Include, NumberOp (ExactNumber num), _) ->
        IncludePairGroupExactNumber num
    | PairFilter (Include, NumberOp (LessThanNumber num), _) ->
        IncludePairGroupLessThanNumber num
    | PairFilter (Include, NumberOp (GreaterThanNumber num), _) ->
        IncludePairGroupGreaterThanNumber num
    | PairFilter (Include, NumberOp (BetweenNumber (bottom, top)), _) ->
        IncludePairGroupBetweenNumber (bottom, top)
    | PairFilter (Exclude, NumberOp (ExactNumber num), _) ->
        ExcludePairGroupExactNumber num
    | PairFilter (Exclude, NumberOp (LessThanNumber num), _) ->
        ExcludePairGroupLessThanNumber num
    | PairFilter (Exclude, NumberOp (GreaterThanNumber num), _) ->
        ExcludePairGroupGreaterThanNumber num
    | PairFilter (Exclude, NumberOp (BetweenNumber (bottom, top)), _) ->
        ExcludePairGroupBetweenNumber (bottom, top)
  in
  let category_a = categorize a in
  let category_b = categorize b in
  equal category_a category_b

let group ~fn lst =
  let rec grouping acc = function
    | [] -> acc
    | hd :: tl ->
        let lst1, lst2 = List.partition (fn hd) tl in
        grouping ((hd :: lst1) :: acc) lst2
  in
  grouping [] lst

let imply_logical_operators a = group ~fn:as_group a
let apply ~fn groups = List.for_all fn groups
let apply_list = apply

let list_of_filters_for_pair ~match_fun pair =
  List.exists (fun filter ->
      Predicate.filter_to_predicate ~match_fun filter pair)

let apply_list_of_filters_for_pair ~match_fun lst pair =
  let and_group = imply_logical_operators lst in
  let if_has_one = list_of_filters_for_pair ~match_fun pair in
  apply ~fn:if_has_one and_group

let list_of_filters_for_list_of_pairs ~match_fun (pairs : Predicate.pair list) =
  let apply_logic group =
    let hd = List.hd group in
    match Ast.is_include hd with
    | true ->
        List.exists
          (fun filter ->
            List.exists (Predicate.filter_to_predicate ~match_fun filter) pairs)
          group
    | false ->
        List.for_all
          (fun filter ->
            List.for_all (Predicate.filter_to_predicate ~match_fun filter) pairs)
          group
  in
  apply_logic

let apply_list_of_filters_for_list_of_pairs ~match_fun lst
    (pairs : Predicate.pair list) =
  let and_group = imply_logical_operators lst in
  let (apply_logic : Ast.t list -> bool) =
    list_of_filters_for_list_of_pairs ~match_fun pairs
  in
  apply ~fn:apply_logic and_group
