{
  description = "My Nix flake templates";

  outputs = _: {
    templates = rec {
      course.description = "A flake for my university courses with cspell spellcheck, taskmatter for task management, and typst for PDF documents.";
      course.path = ./course;

      empty.description = "An empty flake to be used as a starting point for creating new templates.";
      empty.path = ./empty;

      go.description = "A flake for Go projects.";
      go.path = ./go;

      idris.description = "A flake for Idris projects.";
      idris.path = ./idris;

      lean.description = "A flake for Lean 4 projects.";
      lean.path = ./lean;

      ocaml.description = "A flake for OCaml projects.";
      ocaml.path = ./ocaml;

      python.description = "A flake for Python projects.";
      python.path = ./python;

      rust.description = "A flake for Rust projects.";
      rust.path = ./rust;

      tree-sitter.description = "A flake for tree-sitter grammars.";
      tree-sitter.path = ./tree-sitter;

      zig.description = "A flake for Zig projects.";
      zig.path = ./zig;

      default = empty;
    };
  };
}
