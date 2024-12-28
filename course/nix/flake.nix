{
  description = "CHANGEME";

  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    pre-commit-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    taskmatter = {
      url = "github:mtoohey31/taskmatter";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        utils.follows = "flake-utils";
      };
    };
  };

  outputs = { nixpkgs, flake-utils, pre-commit-hooks, taskmatter, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          overlays = [ taskmatter.overlays.default ];
          inherit system;
        };
        inherit (pkgs) efm-langserver mkShell nodePackages tinymist typst
          typstyle;
        inherit (nodePackages) cspell;
      in
      rec {
        checks.pre-commit = pre-commit-hooks.lib.${system}.run {
          src = ./..;
          hooks = {
            cspell = {
              enable = true;
              args = [ "--config" (toString ../.cspell.yaml) ];
            };
            typstyle.enable = true;
          };
        };

        devShells.default = mkShell {
          inherit (checks.pre-commit) shellHook;
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
