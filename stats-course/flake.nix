# cspell:disable
{
  description = "CHANGEME";

  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";
    utils.url = "github:numtide/flake-utils";
    colorout-src = {
      url = "github:jalvesaq/colorout";
      flake = false;
    };
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

  outputs = { nixpkgs, utils, colorout-src, spaced, taskmatter, ... }:
    utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            (_: prev: {
              rPackages = prev.rPackages // {
                # TODO: create nixpkgs PR for this
                colorout = prev.rPackages.buildRPackage {
                  name = "colorout";
                  version = colorout-src.shortRev;
                  src = colorout-src;
                };
              };
            })
            spaced.overlays.default
            taskmatter.overlays.default
          ];
        };
        inherit (pkgs) mkShell nodePackages pandoc rPackages rWrapper texlive
          writeShellScriptBin;
        pandoc-wrapped = writeShellScriptBin "pandoc" ''
          ${pandoc}/bin/pandoc --metadata-file "$PANDOC_METADATA_FILE" "$@"
        '';
      in
      {
        devShells.default = mkShell {
          packages = [
            nodePackages.cspell
            pandoc-wrapped
            ((
              rWrapper.override {
                packages = with rPackages; [
                  colorout
                  ggplot2
                  languageserver
                ];
              }).overrideAttrs (oldAttrs: {
              buildCommand = oldAttrs.buildCommand + ''
                wrapProgram $out/bin/R \
                  --add-flags "--quiet" \
                  --add-flags "--save"
              '';
            }))
            pkgs.spaced
            pkgs.taskmatter
            (texlive.combine {
              inherit (texlive) mdframed needspace scheme-small zref;
            })
          ];
          shellHook = ''
            export PANDOC_METADATA_FILE="$PWD/.pandoc-metadata.yaml"
            export R_PROFILE_USER="$PWD/.Rprofile"
            export R_HISTFILE="$PWD/.Rhistory"
          '';
        };
      });
}
