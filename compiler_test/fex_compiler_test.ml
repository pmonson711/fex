let suites =
  [ Parser_test.suite
  ; Predicate_test.suite
  ; Combiner_test.suite (* ; Messages_test.suite *)
  ]

let () =
  let open Alcotest in
  run "Fex_Parser" suites
