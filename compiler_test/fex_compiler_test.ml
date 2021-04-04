let () =
  let open Alcotest in
  run "Fex Parser" [ Parser_test.suite; Predicate_test.suite ]
