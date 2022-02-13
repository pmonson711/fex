open Cmdliner

let doc = "json file to filter"
let docv = "./json_file.json"
let pos = Arg.(value & pos 1 (some file) None & info [] ~docv ~doc)

let flag =
  Arg.(value & opt (some file) None & info [ "j"; "json-file" ] ~docv ~doc)

let get_json' = function
  | Some file, None -> Yojson.Safe.from_file file
  | None, Some file -> Yojson.Safe.from_file file
  | Some p, Some f ->
      Printf.eprintf "Can't have both `--json-file %s` and `%s` set" f p ;
      exit 124
  | None, None ->
      Printf.eprintf "Must supply a json file" ;
      exit 124

let get_json opt1 opt2 = get_json' (opt1, opt2)
