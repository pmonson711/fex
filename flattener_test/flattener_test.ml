let suites = [ Json_test.suite ]

let () =
  let open Alcotest in
  run "Flattener Tests" suites
