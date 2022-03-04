# lab-calculator

Requirements: [opam](https://opam.ocaml.org/).

## Install dependencies, build and run tests witch coverage

```sh
make create_switch
make deps_all
make build
make coverage
```

## Build bundle (needed for Playwright tests)

```sh
make build_bundle
make copy_bundle
```

## Playwright tests: install dependencies, run tests 

```sh
cd app_test
npm ci
npm run test
```
