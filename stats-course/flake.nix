{
  description = "CHANGEME";

  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";
    utils.url = "github:numtide/flake-utils";
    colorout = {
      url = "github:jalvesaq/colorout";
      flake = false;
    };
    taskmatter = {
      url = "github:mtoohey31/taskmatter";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "utils";
    };
  };

  outputs = { self, nixpkgs, utils, colorout, taskmatter }:
    utils.lib.eachDefaultSystem (system:
      with import nixpkgs
        {
          inherit system;
          overlays = [
            (self: super: {
              rPackages = super.rPackages // {
                # TODO: create nixpkgs PR for this
                colorout = super.rPackages.buildRPackage {
                  name = "colorout";
                  src = colorout;
                };
              };
            })
            taskmatter.overlay
          ];
        }; {
        devShells.default = mkShell {
          nativeBuildInputs = [
            nodePackages.cspell
            pandoc
            (symlinkJoin (
              let rWrapper = pkgs.rWrapper.override {
                packages = with rPackages; [
                  rPackages.colorout
                  ggplot2
                  languageserver
                ];
              }; in
              {
                name = rWrapper.name + "-wrapper";
                paths = [ rWrapper ];
                buildInputs = [ pkgs.makeWrapper ];
                postBuild = ''
                  wrapProgram $out/bin/R \
                    --add-flags "--quiet" \
                    --add-flags "--save"
                '';
              }
            ))
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
