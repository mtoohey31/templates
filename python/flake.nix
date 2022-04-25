{
  description = "CHANGEME";

  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";
    utils.url = "github:numtide/flake-utils";
    poetry2nix.url = "github:nix-community/poetry2nix";
  };

  outputs = { self, nixpkgs, utils, poetry2nix }:
    utils.lib.eachDefaultSystem (system:
      let pkgs = import nixpkgs {
        inherit system;
        overlays = [ poetry2nix.overlay ];
      }; in
      with pkgs; rec {
        packages.CHANGEME = pkgs.poetry2nix.mkPoetryApplication {
          projectDir = ./.;
        };
        defaultPackage = packages.CHANGEME;

        devShell = pkgs.poetry2nix.mkPoetryEnv {
          projectDir = ./.;
        };
      });
}
