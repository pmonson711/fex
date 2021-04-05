include Pair

type pairs = Pair.t list [@@deriving show, eq]

module JSON = struct
  type t =
    [ `Null
    | `Bool    of bool
    | `Int     of int
    | `Intlit  of string
    | `Float   of float
    | `String  of string
    | `Assoc   of (string * t) list
    | `List    of t list
    | `Tuple   of t list
    | `Variant of string * t option
    ]
end

let rec pair_of_json' ~prefix (json : JSON.t) : Pair.t list =
  let prefix_sep = match prefix with "" -> "" | _ -> "." in
  let pair_list_of_json_assoc =
    List.fold_left
      (fun acc (k, v) ->
        let prefix' = Printf.sprintf "%s%s%s" prefix prefix_sep k in
        acc @ pair_of_json' ~prefix:prefix' v)
      []
  in
  let pair_list_of_json_list l =
    List.mapi
      (fun i v ->
        let one_base_index = i + 1 in
        let prefix' =
          Printf.sprintf "%s%s%i" prefix prefix_sep one_base_index
        in
        pair_of_json' ~prefix:prefix' v)
      l
    |> List.flatten
  in
  match json with
  | `Null                -> [ Pair.of_strings prefix "" ]
  | `Bool b              -> [ Pair.of_strings prefix @@ string_of_bool b ]
  | `Int i               -> [ Pair.of_strings prefix @@ string_of_int i ]
  | `Intlit s            -> [ Pair.of_strings prefix @@ s ]
  | `Float f             -> [ Pair.of_strings prefix @@ string_of_float f ]
  | `String s            -> [ Pair.of_strings prefix @@ s ]
  | `Assoc l             -> pair_list_of_json_assoc l
  | `List l              -> pair_list_of_json_list l
  | `Tuple l             -> pair_list_of_json_list l
  | `Variant (_, None)   -> []
  | `Variant (s, Some v) ->
      pair_of_json' ~prefix:(Printf.sprintf "%s%s%s" prefix prefix_sep s) v

let pair_of_json = pair_of_json' ~prefix:""
