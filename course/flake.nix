{
  description = "CHANGEME";

  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";
    utils.url = "github:numtide/flake-utils";
    taskmatter = {
      url = "github:mtoohey31/taskmatter";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        utils.follows = "utils";
      };
    };
    spaced = {
      url = "github:mtoohey31/spaced";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        utils.follows = "utils";
      };
    };
  };

  outputs = { nixpkgs, utils, taskmatter, spaced, ... }:
    utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          overlays = [
            taskmatter.overlays.default
            spaced.overlays.default
          ];
          inherit system;
        };
        inherit (pkgs) mkShell nodePackages pandoc texlive;
      in
      {
        devShells.default = mkShell {
          packages = [
            nodePackages.cspell
            # TODO: wrap pandoc with defaults
            pandoc
            pkgs.taskmatter
            (texlive.combine {
              inherit (texlive) scheme-small mdframed needspace zref;
            })
            pkgs.spaced
          ];
        };
      });
}
