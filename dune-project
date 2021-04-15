(lang dune 2.7)
(using menhir 2.0)
(explicit_js_mode)
(name fex)

(generate_opam_files true)
(version unreleased)

(authors "Paul Monson")
(maintainers "pmonson711@gmail.com")
(license MIT)
(source (uri "git+https://github.com/pmonson711/fex/"))
(homepage "https://github.com/pmonson711/fex/")
(bug_reports "https://github.com/pmonson711/fex/issues")
(documentation "https://github.com/pmonson711/fex/")

(package
  (name fex)
  (synopsis "Parser generater for fex")
  (description "Parser generater for fex")
  (depends
    (dune (>= 2.5))
    (ocaml (>= 4.08))
    (js_of_ocaml-compiler (>= 3.7))
    
    (cmdliner (>= 0.9))
    (bos (>= 0.2))
    (containers (>= 3.2))
    (menhir (>= 20200624))
    (yojson (>= 1.7.0))
    (ppx_deriving (>= 4.4))

    ;; Testing
    (alcotest (and :with-test (>= 1.1)))

    (merlin :dev)
    (ocamlformat :dev)
    (ocp-indent :dev)
    (ocp-index :dev)
    (odig :dev)
    (utop :dev)
    (bisect_ppx :dev)
  )
 )
