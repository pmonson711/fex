let test_name = "Filter Parser"

let fex =
  let open Alcotest in
  Fex_compiler.Fex.(testable pp equal)

let parse str =
  let open Fex_compiler in
  str |> Lexing.from_string |> Filter_parser.prog @@ Lexer.read_tokens

let parse_single_test case_name expected to_parse =
  let some_single t = Some [ t ] in
  Alcotest.(
    check (option (list fex)) case_name (some_single expected) (parse to_parse))

let parse_test case_name expected to_parse =
  Alcotest.(
    check (option (list fex)) case_name (Some expected) (parse to_parse))

let empty () =
  Alcotest.(check (option (list fex)) "empty is None" None (parse "")) ;
  Alcotest.(check (option (list fex)) "empty is None" None (parse " "))

let value_only () =
  let open Fex_compiler.Fex in
  let make_test expected input =
    parse_single_test "value is expected" (contains_value expected) input
  in
  make_test "value" "value" ;
  make_test "other" "other" ;
  make_test "surround" " surround " ;
  make_test "leadingspace" " leadingspace" ;
  make_test "trailingspace" "+trailingspace " ;
  make_test "value" "+value" ;
  make_test "other" "+other" ;
  make_test "surround" "+ surround " ;
  make_test "surround" " +surround " ;
  make_test "leadingspace" "+ leadingspace" ;
  make_test "leadingspace" " +leadingspace" ;
  make_test "trailingspace" "trailingspace " ;
  make_test "trailingspace" "+trailingspace "

let value_only_exclude () =
  let open Fex_compiler.Fex in
  let make_test expected input =
    parse_single_test "value is expected"
      (contains_value ~op:Exclude expected)
      input
  in
  make_test "value" "-value" ;
  make_test "other" "-other" ;
  make_test "surround" "- surround " ;
  make_test "surround" " -surround " ;
  make_test "leadingspace" "- leadingspace" ;
  make_test "leadingspace" " -leadingspace" ;
  make_test "trailingspace" "-trailingspace "

let key_only () =
  let open Fex_compiler.Fex in
  let make_test expected input =
    parse_single_test "key is expected" (contains_key expected) input
  in
  make_test "key" "key:" ;
  make_test "other" "other:" ;
  make_test "surround" " surround :" ;
  make_test "leadingspace" " leadingspace:" ;
  make_test "trailingspace" "trailingspace :" ;
  make_test "key" "+key:" ;
  make_test "other" "+other:" ;
  make_test "surround" "+ surround :" ;
  make_test "surround" " +surround :" ;
  make_test "leadingspace" "+ leadingspace:" ;
  make_test "leadingspace" " +leadingspace:" ;
  make_test "trailingspace" "+trailingspace :"

let key_only_exclude () =
  let open Fex_compiler.Fex in
  let make_test expected input =
    parse_single_test "key is expected"
      (contains_key ~op:Exclude expected)
      input
  in
  make_test "key" "-key:" ;
  make_test "other" "-other:" ;
  make_test "surround" "- surround :" ;
  make_test "surround" " -surround :" ;
  make_test "leadingspace" "- leadingspace:" ;
  make_test "leadingspace" " -leadingspace:" ;
  make_test "trailingspace" "-trailingspace :"

let key_value () =
  let open Fex_compiler.Fex in
  let make_test (expected_key, expected_value) input =
    parse_single_test "key value is expected"
      (contains_pair expected_key expected_value)
      input
  in
  make_test ("key", "value") "key:value" ;
  make_test ("surround", "value") " surround :value" ;
  make_test ("leadingspace", "value") " leadingspace:value" ;
  make_test ("trailingspace", "value") "trailingspace :value" ;
  make_test ("key", "surround") "key: surround " ;
  make_test ("key", "leadingspace") "key: leadingspace" ;
  make_test ("key", "trailingspace") "key:trailingspace " ;
  make_test ("key", "value") "+key:value" ;
  make_test ("surround", "value") "+ surround :value" ;
  make_test ("surround", "value") " +surround :value" ;
  make_test ("leadingspace", "value") "+ leadingspace:value" ;
  make_test ("leadingspace", "value") " +leadingspace:value" ;
  make_test ("trailingspace", "value") "+trailingspace :value" ;
  make_test ("key", "surround") "+key: surround " ;
  make_test ("key", "leadingspace") "+key: leadingspace" ;
  make_test ("key", "trailingspace") "+key:trailingspace "

let key_value_exclude () =
  let open Fex_compiler.Fex in
  let make_test (expected_key, expected_value) input =
    parse_single_test "key value is expected"
      (contains_pair ~op:Exclude expected_key expected_value)
      input
  in
  make_test ("key", "value") "-key:value" ;
  make_test ("surround", "value") " -surround :value" ;
  make_test ("surround", "value") "- surround :value" ;
  make_test ("leadingspace", "value") " -leadingspace:value" ;
  make_test ("leadingspace", "value") "- leadingspace:value" ;
  make_test ("trailingspace", "value") "-trailingspace :value" ;
  make_test ("key", "surround") "-key: surround " ;
  make_test ("key", "leadingspace") "-key: leadingspace" ;
  make_test ("key", "trailingspace") "-key:trailingspace "

let combinatorials () =
  let open Fex_compiler.Fex in
  let make_test lst input = parse_test "key value is expected" lst input in
  make_test
    [ contains_value "value1"; contains_value "value2" ]
    "value1, value2" ;
  make_test
    [ contains_value ~op:exc "value1"; contains_value "value2" ]
    "-value1, value2" ;
  make_test
    [ contains_value "value1"; contains_value ~op:exc "value2" ]
    "value1, -value2" ;
  make_test [ contains_key "key1"; contains_value "value2" ] "key1:, value2" ;
  make_test [ contains_key "key1"; contains_key "key2" ] "key1:, key2:" ;
  make_test
    [ contains_pair "key1" "value1"; contains_key "key2" ]
    "key1:value1, key2:" ;
  make_test
    [ contains_pair "key1" "value1"; contains_pair "key2" "value2" ]
    "key1:value1, key2:value2" ;
  make_test
    [ contains_pair "key1" "value1"; contains_pair "key2" "value2" ]
    "+key1:value1, +key2:value2"

let value_only_begins_with () =
  let open Fex_compiler.Fex in
  let make_test expected input =
    parse_single_test "value is expected"
      (value_filter inc @@ begins_with expected)
      input
  in
  make_test "value" "value.."

let value_only_ends_with () =
  let open Fex_compiler.Fex in
  let make_test expected input =
    parse_single_test "value is expected"
      (value_filter inc @@ ends_with expected)
      input
  in
  make_test "value" "..value"

let suite =
  let open Alcotest in
  ( test_name
  , [ test_case "Empty" `Quick empty
    ; test_case "Value Only" `Quick value_only
    ; test_case "Value Only Exclude" `Quick value_only_exclude
    ; test_case "Key Only" `Quick key_only
    ; test_case "Key Only Exclude" `Quick key_only_exclude
    ; test_case "Key Value" `Quick key_value
    ; test_case "Key Value Exclude" `Quick key_only_exclude
    ; test_case "Splits" `Quick combinatorials
    ; test_case "Begins with" `Quick value_only_begins_with
    ; test_case "Ends with" `Quick value_only_ends_with
    ] )
