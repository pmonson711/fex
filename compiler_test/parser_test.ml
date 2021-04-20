let test_name = "Filter Parser"

let fex =
  let open Alcotest in
  Fex_compiler.Ast.(testable pp equal)

let parse = Fex_compiler.filter_from_string

let parse_single_test case_name expected to_parse =
  let some_single t = Ok [ t ] in
  Alcotest.(
    check
      (result (list fex) string)
      case_name (some_single expected) (parse to_parse))

let parse_test case_name expected to_parse =
  Alcotest.(
    check (result (list fex) string) case_name (Ok expected) (parse to_parse))

let empty () =
  Alcotest.(check (result (list fex) string) "empty is None" (Ok []) (parse "")) ;
  Alcotest.(
    check (result (list fex) string) "empty is None" (Ok []) (parse " "))

let value_only () =
  let open Fex_compiler.Ast in
  let make_test expected input =
    parse_single_test ("value is " ^ expected) (contains_value expected) input
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
  let open Fex_compiler.Ast in
  let make_test expected input =
    parse_single_test
      ("inverted value is " ^ expected)
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
  let open Fex_compiler.Ast in
  let make_test expected input =
    parse_single_test ("key is " ^ expected) (contains_key expected) input
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
  let open Fex_compiler.Ast in
  let make_test expected input =
    parse_single_test ("key is " ^ expected)
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
  let open Fex_compiler.Ast in
  let make_test (expected_key, expected_value) input =
    parse_single_test
      ("key value is expected (" ^ expected_key ^ ", " ^ expected_value ^ ")")
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
  let open Fex_compiler.Ast in
  let make_test (expected_key, expected_value) input =
    parse_single_test
      ( "inverted key value is expected (" ^ expected_key ^ ", "
      ^ expected_value ^ ")" )
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
  let open Fex_compiler.Ast in
  let make_test lst input =
    parse_test
      (Printf.sprintf "combined is expected for (" ^ input ^ ")")
      lst input
  in
  make_test [ contains_value "value1"; contains_value "value2" ] "value1,value2" ;
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
  let open Fex_compiler.Ast in
  let make_test expected input =
    parse_single_test
      ("begin with value is expected " ^ expected)
      (value_filter inc @@ begins_with expected)
      input
  in
  make_test "value" "value..."

let value_only_ends_with () =
  let open Fex_compiler.Ast in
  let make_test expected input =
    parse_single_test
      ("ends with value is expected " ^ expected)
      (value_filter inc @@ ends_with expected)
      input
  in
  make_test "value" "..value" ;
  make_test "value" "...value"

let key_string_test () =
  let open Fex_compiler.Ast in
  let make_test ?(op = exact) expected input =
    parse_single_test
      ("quoted value is expected " ^ expected)
      (value_filter inc @@ op expected)
      input
  in
  make_test {|value:|} {|'value:'|} ;
  make_test {|value,|} {|'value,'|} ;
  make_test {|value:|} {|"value:"|} ;
  make_test {|value,|} {|"value,"|} ;
  make_test {|value"|} {|"value\""|} ;
  make_test {|value'|} {|"value'"|} ;
  make_test {|value'|} {|'value\''|} ;
  make_test {|value"|} {|'value"'|} ;
  make_test ~op:ends_with {|value"|} {|..'value"'|} ;
  make_test ~op:begins_with {|value"|} {|'value"'..|} ;
  make_test ~op:contains {|value"|} {|..'value"'..|}

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
    ; test_case "String tests" `Quick key_string_test
    ] )
