.DEFAULT_GOAL := all

ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
$(eval $(ARGS):;@:)

.PHONY: all
all:
	opam exec -- dune build --root . @install

.PHONY: lock
lock: ## Generate a lock file
	opam lock -y .

.PHONY: build
build: ## Build the project, including non installable libraries and executables
	opam exec -- dune build --root .

.PHONY: install
install: all ## Install the packages on the system
	opam exec -- dune install --root .

.PHONY: start
start: all ## Run the produced executable
	opam exec -- dune exec --root . bin/main.exe $(ARGS)

.PHONY: test
test: ## Run the unit tests
	opam exec -- dune runtest --root .

.PHONY: clean
clean: ## Clean build artifacts and other generated files
	opam exec -- dune clean --root .

.PHONY: doc
doc: ## Generate odoc documentation
	opam exec -- dune build --root . @doc

.PHONY: servedoc
servedoc: doc ## Open odoc documentation with default web browser
	open _build/default/_doc/_html/index.html

.PHONY: fmt
fmt: ## Format the codebase with ocamlformat
	opam exec -- dune build --root . --auto-promote @fmt

.PHONY: watch
watch: ## Watch for the filesystem and rebuild on every change
	opam exec -- dune build --root . --watch

.PHONY: utop
utop: ## Run a REPL and link with the project's libraries
	opam exec -- dune utop --root . lib -- -implicit-bindings

.PHONY: release
release: all ## Run the release script 
	opam exec -- dune-release tag
	opam exec -- dune-release distrib
	opam exec -- dune-release publish distrib -y
	opam exec -- dune-release opam pkg
	opam exec -- dune-release opam submit --no-auto-open -y


#######

.PHONY: create_switch
create_switch: ## Create an opam switch without any dependency
	opam switch create . 4.13.1 --no-install -y --repos=janestreet-bleeding=https://ocaml.janestreet.com/opam-repository,default

.PHONY: deps_all
deps_all: ## Install dependencies and development dependencies 
	opam install --deps-only --with-test --with-doc . -y

.PHONY: deps
deps: ## Install dependencies
	opam install --deps-only . -y

.PHONY: coverage
coverage: ## Run coverage
	find . -name '*.coverage' | xargs rm -f
	opam exec -- dune runtest --instrument-with bisect_ppx --force
	bisect-ppx-report html

.PHONY: serve_coverage
serve_coverage:
	http-server _coverage

.PHONY: build_bundle
build_bundle:
	opam exec -- dune build app --release

.PHONY: serve_app
serve_app:
	http-server _build/default/app

.PHONY: copy_bundle
copy_bundle:
	mkdir build -p  
	cp -f ./_build/default/app/index.html build
	cp -f ./_build/default/app/main.bc.js build


.PHONY: serve_bundle
serve_bundle:
	http-server build