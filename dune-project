(lang dune 2.5)
(using menhir 2.0)
(explicit_js_mode)
(name fex)

(generate_opam_files true)
(version unreleased)

(authors "Paul Monson")
(maintainers "pmonson711@gmail.com")
(license MIT)
(source (uri "git+http://gitlab.com"))
(homepage "http://gitlab.com")
(bug_reports "http://gitlab.com")
(documentation "http://gitlab.com")

(package
  (name fex)
  (synopsis "Parser generater for fex")
  (description "Parser generater for fex")
  (depends
    (dune (>= 2.5))
    (ocaml (>= 4.08))
    
    (cmdliner (>= 0.9))
    (bos (>= 0.2))
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
