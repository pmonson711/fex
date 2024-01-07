let test_name = "Parser Messages"

let fex =
  let open Alcotest in
  Fex_compiler.Ast.(testable pp equal)

let parse = Fex_compiler.filter_from_string

let parse_single_test case_name expected to_parse =
  let scanned msg =
    print_endline @@ Printf.sprintf "`%s`" to_parse ;
    print_endline msg ;
    Scanf.sscanf msg "Syntax error %s on line %s character %s %s@!"
      (fun _ _ _ m -> m |> String.trim)
  in
  Alcotest.(
    check string case_name expected
      (Result.get_error (parse to_parse) |> scanned))

let base_cases =
  let state_msg = [] in
  let to_char = function
    | "MINUS" -> "-"
    | "PLUS" -> "+"
    | "STRING" -> "abc"
    | "COLON" -> ":"
    | "SPACE" -> " "
    | "COMMA" -> ","
    | "DOTDOT" -> ".."
    | "Q_STRING" -> "'abc'"
    | "EOF" -> "\n"
    | str -> failwith ("unknown [" ^ str ^ "]")
  in
  let build_filter str =
    List.map to_char @@ String.split_on_char ' ' str |> String.concat ""
  in
  let to_test (s, m) () = parse_single_test s m (build_filter s) in
  let to_test_case (s, m) = Alcotest.test_case s `Quick (to_test (s, m)) in
  List.map to_test_case state_msg

let suite = (test_name, base_cases)
