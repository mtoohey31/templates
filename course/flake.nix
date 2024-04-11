# cspell:disable
{
  description = "CHANGEME";

  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";
    utils.url = "github:numtide/flake-utils";
    spaced = {
      url = "github:mtoohey31/spaced";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        utils.follows = "utils";
      };
    };
    taskmatter = {
      url = "github:mtoohey31/taskmatter";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        utils.follows = "utils";
      };
    };
  };

  outputs = { nixpkgs, utils, spaced, taskmatter, ... }:
    utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          overlays = [
            spaced.overlays.default
            taskmatter.overlays.default
          ];
          inherit system;
        };
        inherit (pkgs) efm-langserver mkShell nodePackages typst typst-lsp;
        inherit (nodePackages) cspell;
      in
      {
        devShells.default = mkShell {
          packages = [
            cspell
            efm-langserver
            pkgs.spaced
            pkgs.taskmatter
            typst
            typst-lsp
          ];
        };
      });
}
