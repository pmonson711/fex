open Js_of_ocaml

let a =
  Js.export_all
    (object%js
       (* method flattenArray (arr:Js.json Js.js_array Js.t)= *) 
       (*   let as_list = arr##toString in *)
       (*   Fex_flattener.pairs_of_json_array as_list *)

       (* method flattenObject (arr:Js.json Js.js_array Js.t) = *) 
       (*   let as_list = arr |> Js.to_array |> Array.to_list in *)
       (*   Fex_flattener.pair_list_of_json as_list *)

       method applyListFilter filter pairs =
         let filter' = Fex_compiler.filter_from_string filter in
         match filter' with
         | Ok filters -> Fex_compiler.apply_list_filter filters pairs
         | Error err  -> failwith err

       method applyListOfFiltersForPair filter pairs =
         let filter' = Fex_compiler.filter_from_string filter in
         match filter' with
         | Ok filters -> Fex_compiler.apply_list_filter_for_pairs filters pairs
         | Error err  -> failwith err
    end)
