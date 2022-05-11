{
  description = "CHANGEME";

  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";
    utils.url = "github:numtide/flake-utils";
    taskmatter = {
      url = "github:mtoohey31/taskmatter";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "utils";
    };
  };

  # TODO: figure out how to add lf cards keybind
  outputs = { self, nixpkgs, utils, taskmatter }:
    utils.lib.eachDefaultSystem (system:
      with import nixpkgs { inherit system; overlays = [ taskmatter.overlay ]; }; {
        devShells.default = mkShell {
          packages = [
            nodePackages.cspell
            # TODO: wrap pandoc with defaults
            pandoc
            pkgs.taskmatter
            (pkgs.texlive.combine {
              inherit (pkgs.texlive) scheme-small mdframed needspace zref;
            })
          ];
        };
      });
}
