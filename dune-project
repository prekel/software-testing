(lang dune 2.7)

(name lab-calculator)

(license MIT)

(authors "Vladislav Prekel")

(maintainers "Vladislav Prekel")

(generate_opam_files true)

(package
 (name lab-calculator)
 (synopsis "A short, but powerful statement about your project")
 (description "A short, but powerful statement about your project")
 (depends
  (ocaml
   (>= 4.08.0))
  dune
  core
  js_of_ocaml
  lwt
  (bonsai
   (and
    (>= v0.15~)
    (< v0.16)))
  ppx_jane
  (bisect_ppx :with-test)
  (ocaml-lsp-server :with-test)
  (ocamlformat :with-test)
  (ocamlformat-rpc :with-test)
  (utop :with-test)
  (odoc :with-doc)))
