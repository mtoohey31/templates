{
  description = "CHANGEME";

  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";
    utils.url = "github:numtide/flake-utils";
    colorout-src = {
      url = "github:jalvesaq/colorout";
      flake = false;
    };
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

  outputs = { nixpkgs, utils, colorout-src, taskmatter, spaced, ... }:
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
            taskmatter.overlays.default
            spaced.overlays.default
          ];
        };
        inherit (pkgs) mkShell nodePackages pandoc rPackages rWrapper texlive;
      in
      {
        devShells.default = mkShell {
          packages = [
            nodePackages.cspell
            pandoc
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
            pkgs.taskmatter
            (texlive.combine {
              inherit (texlive) scheme-small mdframed needspace zref;
            })
            pkgs.spaced
          ];
          shellHook = ''
            export R_PROFILE_USER="$PWD/.Rprofile"
            export R_HISTFILE="$PWD/.Rhistory"
          '';
        };
      });
}
