let test_name = "Combiner"
let equal_fun = CCString.equal

let filter_list_to_bool to_check with_filters =
  Fex_compiler__Combiner.apply_list_of_filters_for_list_of_pairs
    ~match_fun:Fex_compiler__Match_in_order.string_match_operation ~equal_fun
    to_check with_filters

let empty () = Alcotest.(check bool "empty" true (filter_list_to_bool [] []))

let simple_implies () =
  let open Fex_compiler.Ast in
  let contains_a = value_filter inc (contains "a") in
  let contains_b = value_filter inc (contains "b") in
  let contains_aa = pair_filter exc (exact "a") (contains "a") in
  let contains_bb = pair_filter inc (exact "b") (contains "b") in
  Alcotest.(
    check bool {|[["a"; "b"]] matches `a,c`|} true
      (Fex_compiler__Combiner.imply_logical_operators ~equal_fun
         [ contains_a; contains_b ]
      = [ [ contains_a; contains_b ] ]) ;
    check bool {|[["a:a"; "b:b"]] matches `a:a,b:b`|} true
      (Fex_compiler__Combiner.imply_logical_operators ~equal_fun
         [ contains_aa; contains_bb ]
      = [ [ contains_bb ]; [ contains_aa ] ]))

let two_include_union () =
  let open Fex_compiler.Ast in
  let contains_ab_or_c =
    [ value_filter inc (contains "a"); value_filter inc (contains "c") ]
  in
  let pair_of_value value = `Pair (`Key "", `Value (`String value)) in
  let make_test expected str_value =
    Alcotest.(
      check bool
        (Printf.sprintf {|[%s] doesn't match `a,c`|} str_value)
        expected
        (filter_list_to_bool contains_ab_or_c [ pair_of_value str_value ]))
  in
  make_test true "a" ;
  make_test false "b" ;
  make_test true "bc" ;
  make_test true "c" ;
  make_test true "ac" ;
  make_test false "z"

let one_include_one_exclude_union () =
  let open Fex_compiler.Ast in
  let contains_ab_or_c =
    [ value_filter inc (contains "a"); value_filter exc (contains "c") ]
  in
  let pair_of_value value = `Pair (`Key "", `Value (`String value)) in
  let make_test expected str_value =
    Alcotest.(
      check bool
        (Printf.sprintf {|[%s] doesn't match `a,-c`|} str_value)
        expected
        (filter_list_to_bool contains_ab_or_c [ pair_of_value str_value ]))
  in
  make_test true "a" ;
  make_test false "b" ;
  make_test false "bc" ;
  make_test false "c" ;
  make_test false "ac" ;
  make_test true "ab"

let paired_union () =
  let open Fex_compiler.Ast in
  let contains_ab_or_c =
    [ pair_filter inc (exact "a") (contains "a")
    ; pair_filter inc (exact "a") (contains "b")
    ]
  in
  let pair_of_keyed_a value = `Pair (`Key "a", `Value (`String value)) in
  let make_test expected str_value =
    Alcotest.(
      check bool
        (Printf.sprintf {|[%s] doesn't match `a:a,a:b`|}
           (String.concat "; " str_value))
        expected
        (filter_list_to_bool contains_ab_or_c
        @@ List.map pair_of_keyed_a str_value))
  in
  make_test true [ "a"; "b" ] ;
  make_test true [ "a" ] ;
  make_test true [ "b" ] ;
  make_test true [ "b"; "a" ] ;
  make_test true [ "b"; "z" ] ;
  make_test true [ "a"; "z" ] ;
  make_test false [ "y"; "z" ]

let mixed_paired_union () =
  let open Fex_compiler.Ast in
  let contains_ab_or_c =
    [ pair_filter exc (exact "a") (contains "a")
    ; pair_filter inc (exact "a") (contains "b")
    ]
  in
  let pair_of_keyed_a value = `Pair (`Key "a", `Value (`String value)) in
  let make_test expected str_value =
    Alcotest.(
      check bool
        (Printf.sprintf {|[%s] doesn't match `-a:a,a:b`|}
           (String.concat "; " str_value))
        expected
        (filter_list_to_bool contains_ab_or_c
        @@ List.map pair_of_keyed_a str_value))
  in
  make_test false [ "a"; "b" ] ;
  make_test false [ "a" ] ;
  make_test true [ "b" ] ;
  make_test false [ "b"; "a" ] ;
  make_test true [ "b"; "z" ] ;
  make_test false [ "a"; "z" ] ;
  make_test false [ "y"; "z" ]

let mixed_paired_intersect () =
  let open Fex_compiler.Ast in
  let contains_ab_or_c =
    [ pair_filter inc (exact "a") (contains "a")
    ; pair_filter inc (exact "b") (contains "b")
    ]
  in
  let pair_of_keyed_a value = `Pair (`Key "a", `Value (`String value)) in
  let pair_of_keyed_b value = `Pair (`Key "b", `Value (`String value)) in
  let make_test expected a_value b_value =
    Alcotest.(
      check bool
        (Printf.sprintf {|[{a: %s, b: %s}] match `a:a,b:b`|} a_value b_value)
        expected
        (filter_list_to_bool contains_ab_or_c
           [ pair_of_keyed_a a_value; pair_of_keyed_b b_value ]))
  in
  make_test true "a" "b" ;
  make_test false "b" "a" ;
  make_test true "ab" "ab"

let suite =
  let open Alcotest in
  ( test_name
  , [ test_case "Empty" `Quick empty
    ; test_case "Simple Implies" `Quick simple_implies
    ; test_case "Basic Union" `Quick two_include_union
    ; test_case "Mixed Union" `Quick one_include_one_exclude_union
    ; test_case "Paired Union" `Quick paired_union
    ; test_case "Mixed Paired Union" `Quick mixed_paired_union
    ; test_case "Mixed Paired Intersect" `Quick mixed_paired_intersect
    ] )
