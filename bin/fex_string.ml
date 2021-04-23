open Cmdliner

let doc = "Filter string to predicate"

let docv = "fex"

let pos = Arg.(value & pos 0 (some string) None & info [] ~docv ~doc)

let flag =
  Arg.(value & opt (some string) None & info [ "f"; "fex-string" ] ~docv ~doc)

let parse str =
  let trimmed =
    match str.[0] with
    | '\\' -> String.sub str 1 (String.length str - 1)
    | _    -> str
  in
  Fex_compiler.filter_from_string trimmed

let get_fex' = function
  | Some str, None -> parse str
  | None, Some str -> parse str
  | Some p, Some f ->
      Printf.eprintf "Can't have the `--fex-string %s` and `%s` set" f p ;
      exit 124
  | None, None     ->
      Printf.eprintf "Must provide at `--fex-string or " ;
      exit 124

let get_fex opt1 opt2 = get_fex' (opt1, opt2)
