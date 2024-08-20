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
  };

  outputs = { nixpkgs, utils, taskmatter, ... }:
    utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          overlays = [ taskmatter.overlays.default ];
          inherit system;
        };
        inherit (pkgs) efm-langserver mkShell nodePackages tinymist typst
          typstyle;
        inherit (nodePackages) cspell;
      in
      {
        devShells.default = mkShell {
          packages = [
            cspell
            efm-langserver
            pkgs.taskmatter
            tinymist
            typst
            typstyle
          ];
        };
      });
}
