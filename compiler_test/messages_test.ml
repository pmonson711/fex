let test_name = "Parser Messages"

let fex =
  let open Alcotest in
  Fex_compiler.Ast.(testable pp equal)

let parse = Fex_compiler.filter_from_string

let parse_single_test case_name expected to_parse =
  let scanned msg =
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
    "The `+` (plus) operator can not directly follow a `:` (colon) operator."
  in
  parse_single_test "COLON STRING" msg ":abc"

let suite =
  let open Alcotest in
  ( test_name
  , [ test_case "Colon Plus" `Quick colon_plus
    ; test_case "Colon Qstring Colon" `Quick colon_qstring_colon
    ; test_case "Colon Space Comma" `Quick colon_space_comma
    ; test_case "Colon String" `Quick colon_string
    ] )
