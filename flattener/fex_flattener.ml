include Pair

type pairs = Pair.StringPair.t list [@@deriving show, eq]

module JSON = struct
  type t =
    [ `Null
    | `Bool of bool
    | `Int of int
    | `Intlit of string
    | `Float of float
    | `String of string
    | `Assoc of (string * t) list
    | `List of t list
    | `Tuple of t list
    | `Variant of string * t option
    ]
end

let rec pair_from_json' ~prefix (json : JSON.t) : pairs =
  let prefix_sep = match prefix with "" -> "" | _ -> "." in
  let pair_list_of_json_assoc =
    List.fold_left
      (fun acc (k, v) ->
        let prefix' = Printf.sprintf "%s%s%s" prefix prefix_sep k in
        acc @ pair_from_json' ~prefix:prefix' v)
      []
  in
  let pair_list_of_json_list l =
    List.mapi
      (fun i v ->
        let one_base_index = i + 1 in
        let prefix' =
          Printf.sprintf "%s%s%i" prefix prefix_sep one_base_index
        in
        pair_from_json' ~prefix:prefix' v)
      l
    |> List.flatten
  in
  match json with
  | `Null -> [ Pair.of_string prefix "" ]
  | `Bool b -> [ Pair.of_string prefix @@ string_of_bool b ]
  | `Int i -> [ Pair.of_int prefix i ]
  | `Intlit s -> [ Pair.of_string prefix @@ s ]
  | `Float f -> [ Pair.of_float prefix f ]
  | `String s -> [ Pair.of_string prefix @@ s ]
  | `Assoc l -> pair_list_of_json_assoc l
  | `List l -> pair_list_of_json_list l
  | `Tuple l -> pair_list_of_json_list l
  | `Variant (_, None) -> []
  | `Variant (s, Some v) ->
      pair_from_json' ~prefix:(Printf.sprintf "%s%s%s" prefix prefix_sep s) v

let pair_from_json = pair_from_json' ~prefix:""
let pairs_from_json_array (`List lst) = List.map pair_from_json lst

let pair_list_of_json = function
  | `List lst -> pairs_from_json_array (`List lst) |> List.flatten
  | json -> pair_from_json json
