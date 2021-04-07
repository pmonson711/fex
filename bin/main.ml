open Cmdliner

let print_pair (`Pair (`Key key, `Value value)) =
  Printf.sprintf "%15s : %s" key value

let parse str =
  let trimmed =
    match str.[0] with
    | '\\' -> String.sub str 1 (String.length str - 1)
    | _    -> str
  in
  Fex_compiler.filter_from_string trimmed

let fex_op fex_str json_str =
  let json = Yojson.Safe.from_string json_str in
  let pairs = Fex_flattener.pair_list_of_json json in
  let fex = parse fex_str in
  match fex with
  | Ok [ f1 ] ->
      List.iter
        (fun pair ->
          Printf.printf "%5b %s\n"
            (Fex_compiler.apply_filter f1 pair)
            (print_pair pair))
        pairs
  | Ok []     -> print_endline "empty filter"
  | Ok lst    ->
      List.iter
        (fun pair ->
          Printf.printf "%5b %s\n"
            (Fex_compiler.apply_list_filter lst pair)
            (print_pair pair))
        pairs
  | Error s   -> print_endline s

let input_string =
  let doc = "JSON string to filter" in
  let docv = "JSON" in
  Arg.(value & pos 1 string "[]" & info [] ~docv ~doc)

let fex_string =
  let doc = "Filter string to predicate" in
  let docv = "FEX" in
  Arg.(value & pos 0 string "" & info [] ~docv ~doc)

let fex_t = Term.(const fex_op $ fex_string $ input_string)

let info =
  let doc = "Filter JSON via the fex expression" in
  let man =
    [ `S Manpage.s_bugs; `P "Email bug reports to <pmonson711@gmail.com>." ]
  in
  Term.info "fex" ~version:"%%VERSION%%" ~doc ~exits:Cmdliner.Term.default_exits
    ~man

let () = Term.exit @@ Term.eval (fex_t, info)
