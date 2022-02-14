.PHONY: build
build:
	@dune build @all -j8

.PHONY: build-js
build-js:
	@dune build fex_js/fex.bc.js --profile=release -j8

.PHONY: install-deps
install-deps:
	@opam install . --deps-only --with-doc --with-test

.PHONY: update
update:
	opam update

.PHONY: upgrade
upgrade:
	opam upgrade

.PHONY: lock
lock:
	opam lock fex

.PHONY: update-deps
update-deps: update upgrade lock

.PHONY: watch
watch:
	@dune build @all --watch -j8

.PHONY: build-js
watch-js:
	@dune build fex_js/fex.bc.js --profile=release -w -j8

.PHONY: install
install:
	@dune install

.PHONY: test
test:
	@dune runtest

.PHONY: watch-test
watch-test:
	@dune runtest -w

.PHONY: coverage
coverage:
	@dune runtest --instrument-with bisect_ppx --force
	@bisect-ppx-report summary --per-file
	@bisect-ppx-report html

.PHONY: fmt
format:
	@dune build @fmt --auto-promote

.PHONY: clean
clean:
	@dune clean
	@rm -Rf _coverage

.PHONY: doc
doc:
	@dune build @doc

.PHONY: doc-serve
doc-serve:
	@dune build @doc -w &
	@(cd _build/default/_doc/_html/; cohttp-server-lwt)
