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
      url = "github:mtoohey31/taskmatter?dir=nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
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
        inherit (pkgs) efm-langserver mkShell nodePackages
          taskmatter-bin-wrapped tinymist typst typstyle;
        inherit (nodePackages) cspell;
      in
      rec {
        checks.pre-commit = pre-commit-hooks.lib.${system}.run {
          src = ./..;
          hooks = {
            cspell = {
              enable = true;
              args = [ "--config" ".cspell.yaml" "lint" "." ];
              always_run = true;
              pass_filenames = false;
            };
            typstyle.enable = true;
          };
        };

        devShells.default = mkShell {
          inherit (checks.pre-commit) shellHook;
          packages = [
            cspell
            efm-langserver
            taskmatter-bin-wrapped
            tinymist
            typst
            typstyle
          ];
        };
      });
}
