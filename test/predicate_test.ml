let test_name = "Predicate"

let filter_to_bool to_check with_filter =
  Fex_compiler__Predicate.filter_to_predicate to_check with_filter

let make_key_test op_result filter expected =
  let filter' = Fex_compiler.key_filter op_result filter in
  Alcotest.(
    check bool
      (Fex_compiler.show filter' ^ {| to ("key", "value") |})
      expected
      (filter_to_bool filter' ("key", "value")))

let make_value_test op_result filter expected =
  let filter' = Fex_compiler.value_filter op_result filter in
  Alcotest.(
    check bool
      (Fex_compiler.show filter' ^ {| to ("key", "value") |})
      expected
      (filter_to_bool filter' ("key", "value")))

let make_pair_test op_result key_filter value_filter expected =
  let filter' = Fex_compiler.pair_filter op_result key_filter value_filter in
  Alcotest.(
    check bool
      (Fex_compiler.show filter' ^ {| to ("key", "value") |})
      expected
      (filter_to_bool filter' ("key", "value")))

let exact_keys () =
  let open Fex_compiler in
  let make_test result_op str expected =
    make_key_test result_op (exact str) expected
  in
  make_test inc "key" true ;
  make_test inc "other" false ;
  make_test exc "key" false ;
  make_test exc "other" true

let exact_values () =
  let open Fex_compiler in
  let make_test result_op str expected =
    make_value_test result_op (exact str) expected
  in
  make_test inc "value" true ;
  make_test inc "other" false ;
  make_test exc "value" false ;
  make_test exc "other" true

let begins_with_keys () =
  let open Fex_compiler in
  let make_test result_op str expected =
    make_key_test result_op (begins_with str) expected
  in
  make_test inc "key" true ;
  make_test inc "keys" false ;
  make_test exc "k" false ;
  make_test exc "ke" false ;
  make_test exc "key" false ;
  make_test exc "keys" true

let begins_with_values () =
  let open Fex_compiler in
  let make_test result_op str expected =
    make_value_test result_op (begins_with str) expected
  in
  make_test inc "value" true ;
  make_test inc "values" false ;
  make_test exc "v" false ;
  make_test exc "va" false ;
  make_test exc "value" false ;
  make_test exc "values" true

let begins_with_in_order_keys () =
  let open Fex_compiler in
  let make_test result_op lst expected =
    make_key_test result_op (begins_with_in_order lst) expected
  in
  make_test inc [] false ;
  make_test exc [] true ;
  make_test inc [ "k"; "e" ] true ;
  make_test inc [ "k"; "y" ] false ;
  make_test inc [ "k"; "ey" ] true ;
  make_test inc [ "ke"; "y" ] true ;
  make_test inc [ "k"; "e"; "y" ] true ;
  make_test inc [ "ke"; "y" ] true ;
  make_test exc [ "k"; "e"; "y" ] false ;
  make_test exc [ "ke"; "y" ] false ;
  make_test exc [ "k"; "ey" ] false

let begins_with_in_order_values () =
  let open Fex_compiler in
  let make_test result_op lst expected =
    make_value_test result_op (begins_with_in_order lst) expected
  in
  make_test inc [] false ;
  make_test exc [] true ;
  make_test inc [ "v"; "a" ] true ;
  make_test inc [ "v"; "e" ] false ;
  make_test inc [ "v"; "al" ] true ;
  make_test inc [ "va"; "l" ] true ;
  make_test inc [ "v"; "a"; "l" ] true ;
  make_test inc [ "v"; "al" ] true ;
  make_test exc [ "v"; "a"; "l" ] false ;
  make_test exc [ "va"; "l" ] false ;
  make_test exc [ "v"; "al" ] false

let ends_with_keys () =
  let open Fex_compiler in
  let make_test result_op str expected =
    make_key_test result_op (ends_with str) expected
  in
  make_test inc "key" true ;
  make_test inc "keys" false ;
  make_test exc "y" false ;
  make_test exc "ey" false ;
  make_test exc "key" false ;
  make_test exc "keys" true ;
  make_test inc "_key" false ;
  make_test exc "y" false ;
  make_test exc "ey" false ;
  make_test exc "key" false ;
  make_test exc "keys" true

let ends_with_values () =
  let open Fex_compiler in
  let make_test result_op str expected =
    make_value_test result_op (ends_with str) expected
  in
  make_test inc "value" true ;
  make_test inc "values" false ;
  make_test exc "e" false ;
  make_test exc "ue" false ;
  make_test exc "value" false ;
  make_test exc "values" true ;
  make_test inc "_value" false ;
  make_test exc "e" false ;
  make_test exc "ue" false ;
  make_test exc "value" false ;
  make_test exc "values" true

let ends_with_in_order_keys () =
  let open Fex_compiler in
  let make_test result_op lst expected =
    make_key_test result_op (ends_with_in_order lst) expected
  in
  make_test inc [] false ;
  make_test exc [] true ;
  make_test inc [ "e"; "y" ] true ;
  make_test inc [ "k"; "e" ] false ;
  make_test inc [ "k"; "ey" ] true ;
  make_test inc [ "ke"; "y" ] true ;
  make_test inc [ "k"; "e"; "y" ] true ;
  make_test inc [ "k"; "ey" ] true ;
  make_test inc [ "ke"; "y" ] true ;
  make_test exc [ "k"; "e"; "y" ] false ;
  make_test exc [ "ke"; "y" ] false ;
  make_test exc [ "k"; "ey" ] false

let ends_with_in_order_values () =
  let open Fex_compiler in
  let make_test result_op lst expected =
    make_value_test result_op (ends_with_in_order lst) expected
  in
  make_test inc [] false ;
  make_test exc [] true ;
  make_test inc [ "u"; "e" ] true ;
  make_test inc [ "v"; "a" ] false ;
  make_test inc [ "l"; "ue" ] true ;
  make_test inc [ "lu"; "e" ] true ;
  make_test inc [ "l"; "u"; "e" ] true ;
  make_test inc [ "al"; "ue" ] true ;
  make_test inc [ "valu"; "e" ] true ;
  make_test exc [ "l"; "u"; "e" ] false ;
  make_test exc [ "lu"; "e" ] false ;
  make_test exc [ "l"; "ue" ] false

let contains_key () =
  let open Fex_compiler in
  let make_test result_op str expected =
    make_key_test result_op (contains str) expected
  in
  make_test inc "k" true ;
  make_test inc "e" true ;
  make_test inc "y" true ;
  make_test inc "ke" true ;
  make_test inc "key" true ;
  make_test inc "ey" true ;
  make_test exc "k" false ;
  make_test exc "e" false ;
  make_test exc "y" false ;
  make_test exc "ke" false ;
  make_test exc "key" false ;
  make_test exc "ey" false

let contains_value () =
  let open Fex_compiler in
  let make_test result_op str expected =
    make_value_test result_op (contains str) expected
  in
  make_test inc "v" true ;
  make_test inc "a" true ;
  make_test inc "l" true ;
  make_test inc "va" true ;
  make_test inc "val" true ;
  make_test inc "lu" true ;
  make_test exc "v" false ;
  make_test exc "a" false ;
  make_test exc "l" false ;
  make_test exc "va" false ;
  make_test exc "val" false ;
  make_test exc "al" false

let contains_in_order_key () =
  let open Fex_compiler in
  let make_test result_op lst expected =
    make_key_test result_op (contains_in_order lst) expected
  in
  make_test inc [] false ;
  make_test exc [] true ;
  make_test inc [ "k" ] true ;
  make_test inc [ "k"; "e" ] true ;
  make_test inc [ "k"; "e"; "y" ] true ;
  make_test inc [ "y"; "e"; "k" ] false ;
  make_test exc [ "y"; "e"; "k" ] true ;
  make_test inc [ "e"; "y" ] true

let contains_in_order_value () =
  let open Fex_compiler in
  let make_test result_op lst expected =
    make_value_test result_op (contains_in_order lst) expected
  in
  make_test inc [] false ;
  make_test exc [] true ;
  make_test inc [ "v" ] true ;
  make_test inc [ "v"; "a" ] true ;
  make_test inc [ "v"; "a"; "l" ] true ;
  make_test inc [ "e"; "u"; "l" ] false ;
  make_test exc [ "e"; "u"; "l" ] true ;
  make_test inc [ "a"; "u" ] true

let simple_pair_test () =
  let open Fex_compiler in
  let make_test result_op k v expected =
    make_pair_test result_op k v expected
  in
  make_test inc (exact "key") (exact "value") true ;
  make_test inc (exact "value") (exact "key") false ;
  make_test inc (contains "k") (exact "value") true ;
  make_test exc (contains "k") (exact "value") false ;
  make_test exc (contains "other") (exact "value") true

let suite =
  let open Alcotest in
  ( test_name
  , [ test_case "Exact Keys" `Quick exact_keys
    ; test_case "Exact Values" `Quick exact_values
    ; test_case "Begins With Keys" `Quick begins_with_keys
    ; test_case "Begins With Values" `Quick begins_with_values
    ; test_case "Begins With in order Keys" `Quick begins_with_in_order_keys
    ; test_case "Begins With in order Values" `Quick begins_with_in_order_values
    ; test_case "Ends with Keys" `Quick ends_with_keys
    ; test_case "Ends with Values" `Quick ends_with_values
    ; test_case "Ends with in order Keys" `Quick ends_with_in_order_keys
    ; test_case "Ends with in order Values" `Quick ends_with_in_order_values
    ; test_case "Contains Keys" `Quick contains_key
    ; test_case "Contains Values" `Quick contains_value
    ; test_case "Contains in order Keys" `Quick contains_in_order_key
    ; test_case "Contains in order Values" `Quick contains_in_order_value
    ; test_case "Simple Pair Test" `Quick simple_pair_test
    ] )
