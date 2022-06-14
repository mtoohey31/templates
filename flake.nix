{
  description = "My Nix flake templates";

  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";
    utils.url = "github:numtide/flake-utils";

    gow-src = {
      url = "github:mitranim/gow";
      flake = false;
    };
    naersk = {
      url = "github:nix-community/naersk";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs-mozilla.url = "github:mozilla/nixpkgs-mozilla";
    poetry2nix = {
      url = "github:nix-community/poetry2nix";
      inputs.flake-utils.follows = "utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    go = {
      url = "./go";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        utils.follows = "utils";
        gow-src.follows = "gow-src";
      };
    };
    go118 = {
      url = "./go118";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        utils.follows = "utils";
        gow-src.follows = "gow-src";
      };
    };
    python = {
      url = "./python";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        utils.follows = "utils";
        poetry2nix.follows = "poetry2nix";
      };
    };
    rust-bin = {
      url = "./rust-bin";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        utils.follows = "utils";
        naersk.follows = "naersk";
        nixpkgs-mozilla.follows = "nixpkgs-mozilla";
      };
    };
    rust-lib = {
      url = "./rust-lib";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        utils.follows = "utils";
        nixpkgs-mozilla.follows = "nixpkgs-mozilla";
      };
    };
  };

  outputs = { self, nixpkgs, utils, go, go118, python, rust-bin, rust-lib, ... }:
    utils.lib.eachDefaultSystem
      (system: with import nixpkgs { inherit system; }; {
        devShells = builtins.mapAttrs (_: value: value.devShells."${system}".default) {
          inherit go go118 python rust-bin rust-lib;
        };
      }) // {
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
