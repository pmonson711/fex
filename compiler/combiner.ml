type 'a t =
  | IncludeValueGroup
  | ExcludeValueGroup
  | IncludeKeyGroup
  | ExcludeKeyGroup
  | IncludePairGroupExact of 'a
  | IncludePairGroupContains of 'a list
  | IncludePairGroupBeginsWith of 'a list
  | IncludePairGroupEndsWith of 'a list
  | ExcludePairGroupExact of 'a
  | ExcludePairGroupContains of 'a list
  | ExcludePairGroupBeginsWith of 'a list
  | ExcludePairGroupEndsWith of 'a list
[@@deriving eq]

let group_as ~equal_fun a b =
  let categorize =
    let open Ast in
    function
    | ValueFilter (Include, _) -> IncludeValueGroup
    | ValueFilter (Exclude, _) -> ExcludeValueGroup
    | KeyFilter (Include, _) -> IncludeKeyGroup
    | KeyFilter (Exclude, _) -> ExcludeKeyGroup
    | PairFilter (Include, Exact key, _) -> IncludePairGroupExact key
    | PairFilter (Include, Contains keys, _) -> IncludePairGroupContains keys
    | PairFilter (Include, BeginsWith keys, _) ->
        IncludePairGroupBeginsWith keys
    | PairFilter (Include, EndsWith keys, _) -> IncludePairGroupEndsWith keys
    | PairFilter (Exclude, Exact key, _) -> ExcludePairGroupExact key
    | PairFilter (Exclude, Contains keys, _) -> ExcludePairGroupContains keys
    | PairFilter (Exclude, BeginsWith keys, _) ->
        ExcludePairGroupBeginsWith keys
    | PairFilter (Exclude, EndsWith keys, _) -> ExcludePairGroupEndsWith keys
  in
  let category_a = categorize a in
  let category_b = categorize b in
  equal equal_fun category_a category_b
(* constrain 'a to have equal *)

let group ~fn lst =
  let rec grouping acc = function
    | [] -> acc
    | hd :: tl ->
        let lst1, lst2 = List.partition (fn hd) tl in
        grouping ((hd :: lst1) :: acc) lst2
  in
  grouping [] lst

let imply_logical_operators ~equal_fun a = group ~fn:(group_as ~equal_fun) a

let apply_list_of_filters_for_pair ~match_fun ~equal_fun lst pair =
  let and_group = imply_logical_operators ~equal_fun lst in
  let if_has_one =
    List.exists (fun filter ->
        Predicate.filter_to_predicate ~match_fun filter pair)
  in
  List.for_all if_has_one and_group

let apply_list_of_filters_for_list_of_pairs ~match_fun ~equal_fun lst
    (pairs : ('a, 'b) Predicate.pair list) =
  let and_group = imply_logical_operators ~equal_fun lst in
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
  List.for_all apply_logic and_group
