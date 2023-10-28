OPAM_SWITCH_VER=5.0.0
RELEASE_NAME!=git describe --tags --always --abbrev=7
RELEASE_NAME ?= $(shell git describe --tags --always --abbrev=7)

.PHONY: build
build: deps
	@opam exec -- dune build @all -j8

.PHONY: build-js
build-js:
	@opam exec -- dune build fex_js/fex.bc.js --profile=release -j8

.PHONY: watch
watch:
	@opam exec -- dune build @all --watch -j8

.PHONY: build-js
watch-js:
	@opam exec -- dune build fex_js/fex.bc.js --profile=release -w -j8

.PHONY: test
test:
	@opam exec -- dune runtest --force

.PHONY: watch-test
watch-test:
	@opam exec -- dune runtest -w

.PHONY: coverage
coverage:
	@opam exec -- dune runtest --instrument-with bisect_ppx --force
	@opam exec -- bisect-ppx-report summary --per-file
	@opam exec -- bisect-ppx-report html

.PHONY: format
format:
	@opam exec -- dune build @fmt --auto-promote

.PHONY: clean
clean:
	@dune clean
	@rm -Rf _coverage

.PHONY: create-switch
create-switch: _opam/.opam-switch/config/ocaml.config
	@echo "current switch: $$(opam switch show)"

.PHONY: setup
setup: create-switch
	-opam install dune
	-opam install ocaml-lsp-server ocamlformat odig utop bisect_ppx
	-opam exec -- dune build @install
	opam install . --deps-only --with-test

.PHONY: deps
deps: create-switch
	@if ! opam install . --check --deps-only; then \
		echo "Fetching and building deps..."; \
		opam install . --deps-only --yes; \
	fi;

_opam/.opam-switch/config/ocaml.config:
	-opam switch create . ${OPAM_SWITCH_VER} --deps-only --yes 2>>/dev/null
