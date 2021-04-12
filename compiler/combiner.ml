type t =
  | IncludeValueGroup
  | ExcludeValueGroup
  | IncludeKeyGroup
  | ExcludeKeyGroup
  | IncludePairGroupExact      of string
  | IncludePairGroupContains   of string list
  | IncludePairGroupBeginsWith of string list
  | IncludePairGroupEndsWith   of string list
  | ExcludePairGroupExact      of string
  | ExcludePairGroupContains   of string list
  | ExcludePairGroupBeginsWith of string list
  | ExcludePairGroupEndsWith   of string list
[@@deriving eq]

let group_as a b =
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
  equal category_a category_b

let group ~fn lst =
  let rec grouping acc = function
    | []       -> acc
    | hd :: tl ->
        let lst1, lst2 = List.partition (fn hd) tl in
        grouping ((hd :: lst1) :: acc) lst2
  in
  grouping [] lst

let imply_logical_operators a = group ~fn:group_as a

let apply_list_of_filters_for_pair lst pair =
  let and_group = imply_logical_operators lst in
  let if_has_one =
    List.exists (fun filter -> Predicate.filter_to_predicate filter pair)
  in
  List.for_all if_has_one and_group

let apply_list_of_filters_for_list_of_pairs lst (pairs : Predicate.pair list) =
  let and_group = imply_logical_operators lst in
  List.for_all
    (fun or_group ->
      let hd = List.hd or_group in
      match Ast.is_include hd with
      | true  ->
          List.exists
            (fun filter ->
              List.exists (Predicate.filter_to_predicate filter) pairs)
            or_group
      | false ->
          List.for_all
            (fun filter ->
              Bool.not
              @@ List.exists (Predicate.filter_to_predicate filter) pairs)
            or_group)
    and_group
