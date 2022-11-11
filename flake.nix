{
  description = "My Nix flake templates";

  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";
    utils.url = "github:numtide/flake-utils";

    gow-src = {
      url = "github:mitranim/gow";
      flake = false;
    };
    idris2-pkgs = {
      url = "github:claymager/idris2-pkgs";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "utils";
        idris-server.follows = "";
      };
    };
    naersk = {
      url = "github:nix-community/naersk";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    go = {
      url = "./golang";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        utils.follows = "utils";
        gow-src.follows = "gow-src";
      };
    };
    idris = {
      url = "./idris";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        utils.follows = "utils";
        idris2-pkgs.follows = "idris2-pkgs";
      };
    };
    python = {
      url = "./python";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        utils.follows = "utils";
      };
    };
    rust = {
      url = "./rust";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        utils.follows = "utils";
        naersk.follows = "naersk";
      };
    };
  };

  outputs = { nixpkgs, utils, ... }@inputs: {
    devShells = utils.lib.eachDefaultSystemMap (system: builtins.listToAttrs
      (builtins.map
        (name: {
          inherit name;
          value = inputs.${name}.devShells.${system}.default;
        })
        (builtins.filter (name: inputs.${name}.devShells ? "${system}")
          [ "go" "idris" "python" "rust" ])));

    templates = rec {
      course.description = "A flake for my university courses with cspell spellcheck, taskmatter for task management, and pandoc and latex for PDF documents.";
      course.path = ./course;
      stats-course.description = "An extended version of the course flake that includes R and the R packages I use frequently.";
      stats-course.path = ./stats-course;

      empty.description = "An empty flake to be used as a starting point for creating new templates.";
      empty.path = ./empty;

      go.description = "A flake for Go projects.";
      go.path = ./golang; # named differently so the build doesn't fail

      idris.description = "A flake for Idris projects.";
      idris.path = ./idris;

      python.description = "A flake for Python projects.";
      python.path = ./python;

      rust.description = "A flake for Rust projects.";
      rust.path = ./rust;

      default = empty;
    };
  };
}
