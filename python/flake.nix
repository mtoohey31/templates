{
  description = "CHANGEME";

  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, utils }: {
    overlays.default = final: prev: {
      CHANGEME = final.poetry2nix.mkPoetryApplication {
        projectDir = ./.;
      };
    };
  } // utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs {
        overlays = [ self.overlays.default ];
        inherit system;
      };
    in
    with pkgs; {
      packages.default = CHANGEME;

      devShells.default = (pkgs.poetry2nix.mkPoetryEnv {
        projectDir = ./.;
      }).overrideAttrs (oldAttrs: {
        nativeBuildInputs = oldAttrs.nativeBuildInputs ++ [
          poetry
          python3
          (python3Packages.python-lsp-server.overrideAttrs (_: {
            # TODO: remove this once https://github.com/NixOS/nixpkgs/pull/183862 is merged
            doInstallCheck = false;
          }))
        ];
      });
    });
}
