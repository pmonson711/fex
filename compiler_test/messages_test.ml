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

let colon_plus () =
  let msg =
    "The `+` (plus) operator can not directly follow a `:` (colon) operator."
  in
  parse_single_test "COLON PLUS" msg ":+" ;
  parse_single_test "COLON" msg (* TODO why is this being hit here? *) ":"

let colon_qstring_colon () =
  let msg = "The `:` (colon) can only be included once in each query term." in
  parse_single_test "COLON Q_STRING COLON" msg ":'':" ;
  parse_single_test "COLON Q_STRING COLON" msg {|:"":|}

let colon_space_comma () =
  let msg =
    "The `+` (plus) operator can not directly follow a `:` (colon) operator."
  in
  parse_single_test "COLON SPACE COMMA" msg ": ,"

let colon_string () =
  let msg =
    "A `,` (comma) followed by a string seems to be missing a filiter before \
     the `,`"
  in
  parse_single_test "COLON STRING" msg ",somestring"

let base_cases =
  let state_msg =
    [ ( "COLON PLUS"
      , {|`+` (plus) in only valid before a term.
here the (plus) is used directly after a `:` (colon)
did you mean `+:` instead of `:+`?|}
      )
    ; ( "COLON Q_STRING COLON"
      , {|`:` (colon) in only valid between a key term and value term.
Here the `:` both begins and ends the filter which is ambiguous.
did you forget a `,` (comma) or add an extra `:`?|}
      )
    ; ( "COLON SPACE COMMA"
      , {|`:` (colon) alone is not a valid filter term.
Here `:` has no key or value term before a `,` (comma)
Did you forget to add a key or value term?|}
      )
    ; ( "COMMA STRING"
      , {|`,` (comma) is only valid as a term separator.
Here `,` seems to a beginning empty filter.
did you mean to have the beginning `,`?|}
      )
    ; ( "COMMA SPACE STRING"
      , {|`,` (comma) is only valid as a term separator.
Here `,` seems to a beginning empty filter.
did you mean to have the beginning `,`?|}
      )
    ; ("DOTDOT Q_STRING STRING", "<YOUR SYNTAX ERROR MESSAGE HERE>")
    ; ( "DOTDOT SPACE"
      , {|`..` (dot dot) must be followed by a string.
Here `..` is followed by a ` ` (space).
Did you mean to have a string directly before or after the `..`?|}
      )
    ; ("MINUS SPACE", "<YOUR SYNTAX ERROR MESSAGE HERE>")
    ; ("MINUS STRING COLON PLUS", "<YOUR SYNTAX ERROR MESSAGE HERE>")
    ; ("MINUS STRING COLON SPACE PLUS", "<YOUR SYNTAX ERROR MESSAGE HERE>")
    ; ("MINUS STRING DOTDOT STRING", "<YOUR SYNTAX ERROR MESSAGE HERE>")
    ; ("PLUS SPACE", "<YOUR SYNTAX ERROR MESSAGE HERE>")
    ; ("PLUS STRING COLON PLUS", "<YOUR SYNTAX ERROR MESSAGE HERE>")
    ; ("PLUS STRING COLON SPACE PLUS", "<YOUR SYNTAX ERROR MESSAGE HERE>")
    ; ("PLUS STRING DOTDOT STRING", "<YOUR SYNTAX ERROR MESSAGE HERE>")
    ; ("Q_STRING SPACE Q_STRING EOF", "<YOUR SYNTAX ERROR MESSAGE HERE>")
    ; ("Q_STRING SPACE STRING", "<YOUR SYNTAX ERROR MESSAGE HERE>")
    ; ("Q_STRING STRING", "<YOUR SYNTAX ERROR MESSAGE HERE>")
    ; ("SPACE COLON", "<YOUR SYNTAX ERROR MESSAGE HERE>")
      (* ; ("SPACE STRING", "") *)
    ; ("STRING COLON PLUS", "<YOUR SYNTAX ERROR MESSAGE HERE>")
    ; ("STRING COLON SPACE PLUS", "<YOUR SYNTAX ERROR MESSAGE HERE>")
    ; ("STRING COMMA EOF", "<YOUR SYNTAX ERROR MESSAGE HERE>")
      (* ; ("STRING COMMA SPACE EOF", "<YOUR SYNTAX ERROR MESSAGE HERE>") *)
    ; ("STRING DOTDOT STRING", "<YOUR SYNTAX ERROR MESSAGE HERE>")
      (* ; ("STRING EOF STRING", "") *)
      (* ; ("STRING SPACE SPACE", "") *)
      (* ; ("STRING STRING", "") *)
    ]
  in
  let to_char = function
    | "MINUS"    -> "-"
    | "PLUS"     -> "+"
    | "STRING"   -> "abc"
    | "COLON"    -> ":"
    | "SPACE"    -> " "
    | "COMMA"    -> ","
    | "DOTDOT"   -> ".."
    | "Q_STRING" -> "'abc'"
    | "EOF"      -> "\n"
    | str        -> failwith ("unknown [" ^ str ^ "]")
  in
  let build_filter str =
    List.map to_char @@ String.split_on_char ' ' str |> String.concat ""
  in
  let to_test (s, m) () = parse_single_test s m (build_filter s) in
  let to_test_case (s, m) = Alcotest.test_case s `Quick (to_test (s, m)) in
  List.map to_test_case state_msg

let suite = (test_name, base_cases)
