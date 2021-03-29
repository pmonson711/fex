open Cmdliner

let parse str =
  let trimmed =
    match str.[0] with
    | '\\' -> String.sub str 1 (String.length str - 1)
    | _    -> str
  in
  Fex_compiler.filter_from_string trimmed

let fex json_str fex_str =
  let json = Yojson.Safe.from_string json_str in
  let fex = parse fex_str in
  print_endline @@ Yojson.Safe.pretty_to_string json ;
  print_endline @@ Fex_compiler.show_parsed_result fex

let input_string =
  let doc = "JSON string to filter" in
  let docv = "JSON" in
  Arg.(value & pos 0 string "[]" & info [] ~docv ~doc)

let fex_string =
  let doc = "Filter string to predicate" in
  let docv = "FEX" in
  Arg.(value & pos 1 string "" & info [] ~docv ~doc)

let fex_t = Term.(const fex $ input_string $ fex_string)

let info =
  let doc = "Filter JSON via the fex expression" in
  let man =
    [ `S Manpage.s_bugs; `P "Email bug reports to <pmonson711@gmail.com>." ]
  in
  Term.info "fex" ~version:"%%VERSION%%" ~doc ~exits:Cmdliner.Term.default_exits
    ~man

let () = Term.exit @@ Term.eval (fex_t, info)
