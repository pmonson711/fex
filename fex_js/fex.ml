open Js_of_ocaml

let a =
  Js.export_all
    (object%js
     (* method flattenArray (obj)= *)
     (*   let as_yojson = obj |> Jv.to_string |> Yojson.Safe.from_string in *)
     (*   let as_list = match as_yojson with *)
     (*     | `List lst -> `List lst *)
     (*     | _ -> failwith "must be a json array" *)
     (*   in *)
     (*   Fex_flattener.pairs_from_json_array as_list *)

     (* method flattenObject (obj:Jv.t) = *)
     (*   let as_yojson = obj |> Jv.to_string |> Yojson.Safe.from_string in *)
     (*   Fex_flattener.pair_list_of_json as_yojson *)

     (* method applyListFilter (filter:Jstr.t) pairs = *)
     (*   let filter' = Fex_compiler.filter_from_string filter in *)
     (*   match filter' with *)
     (*   | Ok filters -> Fex_compiler.apply_list_filter filters pairs *)
     (*   | Error err  -> failwith err *)

     (* method applyListOfFiltersForPair (filter:Jstr.t) pairs = *)
     (*   let filter' = Fex_compiler.filter_from_string filter in *)
     (*   match filter' with *)
     (*   | Ok filters -> Fex_compiler.apply_list_filter_for_pairs filters pairs *)
     (*   | Error err  -> failwith err *)
    end)
