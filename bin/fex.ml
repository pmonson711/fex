open Cmdliner

let sprint_value = function
  | `String value -> Printf.printf "%s|" value
  | `Int value -> Printf.printf "%d|" value
  | `Float value -> Printf.printf "%f|" value

let sprint_key (`Pair (`Key key, _value)) = sprint_value key
let sprint_pair (`Pair (_key, `Value value)) = sprint_value value

let fex_record_op fex json =
  let (list_of_pairs : Fex_flattener.pairs list) =
    match json with
    | `List lst -> Fex_flattener.pairs_from_json_array (`List lst)
    | _ ->
        Printf.eprintf "must be a json array" ;
        exit 124
  in
  let print_for_pairs filter_lst pairs =
    if
      Fex_compiler.apply_list_filter_for_pairs filter_lst
        (List.map Fex_compiler.Predicate.pair_of pairs)
    then (
      try
        List.iter sprint_pair pairs ;
        print_newline ()
      with
      | Invalid_argument a ->
          let stack = Printexc.get_backtrace () in
          Printf.eprintf "Argument Error [%s] %s\n" a stack ;
          exit 124
      | e ->
          let msg = Printexc.to_string e
          and stack = Printexc.get_backtrace () in
          Printf.eprintf "Error %s%s\n" msg stack ;
          exit 123)
  in
  let _ =
    list_of_pairs |> List.hd |> List.iter sprint_key ;
    print_newline ()
  in
  match fex with
  | Ok [] -> print_endline "empty filter"
  | Ok filter_lst -> List.iter (print_for_pairs filter_lst) list_of_pairs
  | Error s -> print_endline s

let build_input_for fn fex1 file1 fex2 file2 =
  let json = Json_file.get_json file1 file2 in
  let fex = Fex_string.get_fex fex1 fex2 in
  fn fex json

let fex_t =
  let info =
    let doc = "Filter JSON via the fex expression" in
    let man =
      [ `S Manpage.s_bugs; `P "Email bug reports to <pmonson711@gmail.com>." ]
    in
    Cmd.info "fex" ~version:"%%VERSION%%" ~doc ~exits:Cmd.Exit.defaults ~man
  in
  let term =
    Term.(
      const (build_input_for fex_record_op)
      $ Fex_string.pos $ Json_file.pos $ Fex_string.flag $ Json_file.flag)
  in
  Cmd.v info term

let () = exit @@ Cmd.eval fex_t
