let test_name = "Json Flattener"

let flat_pair =
  let open Alcotest in
  Fex_flattener__Pair.(testable pp equal)

let flatten_test expected from_input =
  let open Alcotest in
  check (list flat_pair)
    (Printf.sprintf "%s value" @@ Yojson.Safe.to_string from_input)
    expected
    (Fex_flattener.pair_of_json from_input)

let primitives () =
  let open Fex_flattener__Pair in
  let make_test expected from_input =
    flatten_test [ of_strings "" expected ] from_input
  in
  make_test "a" @@ `String "a" ;
  make_test "" `Null ;
  make_test "true" @@ `Bool true ;
  make_test "false" @@ `Bool false ;
  make_test "1" @@ `Int 1 ;
  make_test "1" @@ `Intlit "1" ;
  make_test "1.1" @@ `Float 1.1

let l1_composite () =
  let open Fex_flattener__Pair in
  let make_test expected_key expected_value from_input =
    flatten_test [ of_strings expected_key expected_value ] from_input
  in
  make_test "key" "value" @@ `Assoc [ ("key", `String "value") ] ;
  make_test "l1.l2" "value"
  @@ `Assoc [ ("l1", `Assoc [ ("l2", `String "value") ]) ] ;
  make_test "1" "a" @@ `List [ `String "a" ] ;
  make_test "1" "b" @@ `Tuple [ `String "b" ] ;
  make_test "a" "b" @@ `Variant ("a", Some (`String "b"))

let empty_composite () =
  let make_test = flatten_test in
  make_test [] @@ `Variant ("a", None) ;
  make_test [] @@ `List [] ;
  make_test [] @@ `List [ `List [] ] ;
  make_test [] @@ `Assoc [ ("l1", `List []) ] ;
  make_test [] @@ `Tuple [] ;
  make_test [] @@ `Tuple [ `Tuple [] ]

let l2_composite () =
  let open Fex_flattener__Pair in
  let make_test expected input =
    flatten_test (List.map (fun (k, v) -> of_strings k v) expected)
    @@ Yojson.Safe.from_string input
  in
  make_test [ ("l1.1", "a") ] {|{"l1": ["a"]}|} ;
  make_test [ ("l1.1", "a"); ("l1.2", "b") ] {|{"l1": ["a","b"]}|} ;
  make_test [ ("l1.a.1", "a"); ("l1.a.2", "b") ] {|{"l1": {"a":["a","b"]}}|} ;
  make_test
    [ ("1.a", "b"); ("2", "d"); ("3", "1"); ("4", "2.3") ]
    {|[{"a": "b"}, "d", 1, 2.3]|}

let suite =
  let open Alcotest in
  ( test_name
  , [ test_case "Primitive values" `Quick primitives
    ; test_case "Empty Composite values" `Quick empty_composite
    ; test_case "Level 1 Composite values" `Quick l1_composite
    ; test_case "Level 2 Composite values" `Quick l2_composite
    ] )
