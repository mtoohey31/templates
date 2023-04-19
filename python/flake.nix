{
  description = "CHANGEME";

  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, utils }: {
    overlays.default = final: _: {
      CHANGEME = final.poetry2nix.mkPoetryApplication {
        projectDir = builtins.path { path = ./.; name = "CHANGME-src"; };
      };
    };
  } // utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs {
        overlays = [ self.overlays.default ];
        inherit system;
      };
      inherit (pkgs) CHANGEME poetry python3 python3Packages;
    in
    {
      packages.default = CHANGEME;

      devShells.default = CHANGEME.dependencyEnv.overrideAttrs (oldAttrs: {
        nativeBuildInputs = oldAttrs.nativeBuildInputs ++ [
          poetry
          python3
          python3Packages.python-lsp-server
        ];
      });
    });
}
