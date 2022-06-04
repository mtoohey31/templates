{
  description = "My Nix flake templates";

  outputs = { self }: {
    templates = rec {
      course.description = "A flake for my university courses with cspell spellcheck, taskmatter for task management, and pandoc and latex for PDF documents.";
      course.path = ./course;
      stats-course.description = "An extended version of the course flake that includes R and the R packages I use frequently.";
      stats-course.path = ./stats-course;

      empty.description = "An empty flake to be used as a starting point for creating new templates.";
      empty.path = ./empty;

      go.description = "A flake for building Go binaries with the stable version of the Go language.";
      go.path = ./go;
      go118.description = "A flake for building Go binaries with version 1.18 of the Go language.";
      go118.path = ./go118;

      # TODO: add go+container template
      python.description = "A flake for python programs that pins dependencies using poetry.";
      python.path = ./python;

      rust-bin.description = "A flake for rust binaries.";
      rust-bin.path = ./rust-bin;
      rust-lib.description = "A flake for rust libraries.";
      rust-lib.path = ./rust-lib;

      default = empty;
    };
  };
}
