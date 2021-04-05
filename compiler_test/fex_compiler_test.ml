let suites = [ Parser_test.suite; Predicate_test.suite ]

let () =
  let open Alcotest in
  run "Fex Parser" suites
