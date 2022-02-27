let test_name = "Filter Parser"

let fex =
  let open Alcotest in
  let string_pp = Fex_compiler.Ast.pp Fex_compiler__Match_in_order.T.pp in
  let string_equal =
    Fex_compiler.Ast.equal Fex_compiler__Match_in_order.T.equal
  in
  testable string_pp string_equal

let parse = Fex_compiler.filter_from_string

let parse_single_test case_name expected to_parse =
  let some_single t = Ok [ t ] in
  let _ = print_endline @@ Printf.sprintf "`%s`" to_parse in
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
      ("inverted key value is expected (" ^ expected_key ^ ", " ^ expected_value
     ^ ")")
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
    print_endline @@ Printf.sprintf "`%s`" input ;
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

let int_value_number_test () =
  let open Fex_compiler.Ast in
  let make_test op expected input =
    parse_single_test
      ("quoted value is expected [" ^ string_of_int expected ^ "]")
      (value_filter inc @@ op expected)
      input
  in
  make_test greater_than_of_int 5 {|:> 5|} ;
  make_test less_than_of_int 10 {|:< 10|} ;
  make_test greater_than_of_int (-10) {|:> -10|} ;
  make_test less_than_of_int (-15) {|:< -15|} ;
  make_test greater_than_of_int 5 {|:>5|} ;
  make_test less_than_of_int 10 {|:<10|} ;
  make_test greater_than_of_int (-10) {|:>-10|} ;
  make_test less_than_of_int (-15) {|:<-15|}

let int_value_number_betwween_test () =
  let open Fex_compiler.Ast in
  let make_test op expected1 expected2 input =
    parse_single_test
      ("quoted value is expected [" ^ string_of_int expected1 ^ ", "
     ^ string_of_int expected2 ^ "]")
      (value_filter inc @@ op expected1 expected2)
      input
  in
  make_test between_of_int 1 10 ":1..10" ;
  make_test between_of_int (-1) 10 ":-1..10" ;
  make_test between_of_int (-1) (-10) ":-1..-10"

let float_value_number_betwween_test () =
  let open Fex_compiler.Ast in
  let make_test op expected1 expected2 input =
    parse_single_test
      ("quoted value is expected [" ^ string_of_float expected1 ^ ", "
     ^ string_of_float expected2 ^ "]")
      (value_filter inc @@ op expected1 expected2)
      input
  in
  make_test between_of_float 1. 10.01 ":1..10.01" ;
  make_test between_of_float (-1.01) 10. ":-1.01..10" ;
  make_test between_of_float (-1.01) (-10.01) ":-1.01..-10.01"

let float_value_number_test () =
  let open Fex_compiler.Ast in
  let make_test op expected input =
    parse_single_test
      ("quoted value is expected [" ^ string_of_float expected ^ "]")
      (value_filter inc @@ op expected)
      input
  in
  make_test greater_than_of_float 5. {|:> 5|} ;
  make_test greater_than_of_float 5. {|:> 5.0|} ;
  make_test greater_than_of_float 5.1 {|:> 5.1|} ;
  make_test less_than_of_float 10. {|:< 10|} ;
  make_test less_than_of_float 10. {|:< 10.0|} ;
  make_test less_than_of_float 10.2 {|:< 10.2|} ;
  make_test greater_than_of_float (-10.) {|:> -10|} ;
  make_test greater_than_of_float (-10.) {|:> -10.0|} ;
  make_test greater_than_of_float (-10.3) {|:> -10.3|} ;
  make_test less_than_of_float (-15.) {|:< -15|} ;
  make_test less_than_of_float (-15.) {|:< -15.0|} ;
  make_test less_than_of_float (-15.4) {|:< -15.4|} ;
  make_test greater_than_of_float 5. {|:>5|} ;
  make_test less_than_of_float 10. {|:<10|} ;
  make_test greater_than_of_float (-10.) {|:>-10|} ;
  make_test less_than_of_float (-15.) {|:<-15|}

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
    ; test_case "Int Number tests" `Quick int_value_number_test
    ; test_case "Int Between Number tests" `Quick int_value_number_betwween_test
    ; test_case "Float Number tests" `Quick float_value_number_test
    ; test_case "Float Between Number tests" `Quick
        float_value_number_betwween_test
    ] )
