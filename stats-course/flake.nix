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
  };

  outputs = { nixpkgs, utils, colorout-src, taskmatter, ... }:
    utils.lib.eachDefaultSystem (system:
      with import nixpkgs
        {
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
          ];
        }; {
        devShells.default = mkShell {
          packages = [
            nodePackages.cspell
            pandoc
            ((
              pkgs.rWrapper.override {
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
            (pkgs.texlive.combine {
              inherit (pkgs.texlive) scheme-small mdframed needspace zref;
            })
          ];
          shellHook = ''
            export R_PROFILE_USER="$PWD/.Rprofile"
            export R_HISTFILE="$PWD/.Rhistory"
          '';
        };
      });
}
