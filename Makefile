.PHONY: build
build:
	dune build @all -j8

.PHONY: watch
watch:
	dune build @all --watch -j8

.PHONY: install
install:
	dune install

.PHONY: test
test:
	dune runtest

.PHONY: coverage
coverage:
	dune runtest --instrument-with bisect_ppx --force
	bisect-ppx-report summary --per-file
	bisect-ppx-report html 

.PHONY: fmt
format:
	dune build @fmt --auto-promote

.PHONY: clean
clean:
	dune clean
	rm -Rf _coverage
