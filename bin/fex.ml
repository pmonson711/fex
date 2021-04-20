open Cmdliner

let print_pair (`Pair (`Key key, `Value (`String value))) =
  Printf.sprintf "%15s : %s" key value

let parse str =
  let trimmed =
    match str.[0] with
    | '\\' -> String.sub str 1 (String.length str - 1)
    | _    -> str
  in
  Fex_compiler.filter_from_string trimmed

let fex_field_op fex_str file =
  let json = Yojson.Safe.from_file file in
  let pairs = Fex_flattener.pair_list_of_json json in
  let fex = parse fex_str in
  match fex with
  | Ok []   -> print_endline "empty filter"
  | Ok lst  ->
      List.iter
        (fun pair ->
          if Fex_compiler.apply_list_filter lst pair then
            print_endline (print_pair pair))
        pairs
  | Error s -> print_endline s

let fex_record_op fex_str file =
  let json = Yojson.Safe.from_file file in
  let list_of_pairs =
    match json with
    | `List lst -> Fex_flattener.pairs_of_json_array (`List lst)
    | _         -> failwith "must be a json array"
  in
  let fex = parse fex_str in
  match fex with
  | Ok []   -> print_endline "empty filter"
  | Ok lst  ->
      List.iter
        (fun pairs ->
          if Fex_compiler.apply_list_filter_for_pairs lst pairs then (
            List.iter (fun y -> print_endline (print_pair y)) pairs ;
            print_endline "-------" ))
        list_of_pairs
  | Error s -> print_endline s

let input_string =
  let doc = "JSON string to filter" in
  let docv = "JSON" in
  Arg.(value & pos 1 file "[]" & info [] ~docv ~doc)

let fex_string =
  let doc = "Filter string to predicate" in
  let docv = "FEX" in
  Arg.(value & pos 0 string "" & info [] ~docv ~doc)

let fex_t = Term.(const fex_record_op $ fex_string $ input_string)

let info =
  let doc = "Filter JSON via the fex expression" in
  let man =
    [ `S Manpage.s_bugs; `P "Email bug reports to <pmonson711@gmail.com>." ]
  in
  Term.info "fex" ~version:"%%VERSION%%" ~doc ~exits:Cmdliner.Term.default_exits
    ~man

let () = Term.exit @@ Term.eval (fex_t, info)
