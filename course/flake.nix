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
        inherit (pkgs) mkShell nodePackages pandoc texlive writeShellScriptBin;
        pandoc-wrapped = writeShellScriptBin "pandoc" ''
          ${pandoc}/bin/pandoc --metadata-file "$PANDOC_METADATA_FILE" "$@"
        '';
      in
      {
        devShells.default = mkShell {
          packages = [
            nodePackages.cspell
            pandoc-wrapped
            pkgs.spaced
            pkgs.taskmatter
            (texlive.combine {
              inherit (texlive) scheme-small mdframed needspace zref;
            })
          ];
          shellHook = ''
            export PANDOC_METADATA_FILE="$PWD/.pandoc-metadata.yaml"
          '';
        };
      });
}
