{
  description = "CHANGEME";

  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";
    utils.url = "github:numtide/flake-utils";
    poetry2nix = {
      url = "github:nix-community/poetry2nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, utils, poetry2nix }: {
    overlays = rec {
      expects-poetry2nix = final: _: {
        CHANGEME = final.callPackage
          ({ poetry2nix }: poetry2nix.mkPoetryApplication {
            projectDir = builtins.path { path = ./..; name = "CHANGEME-src"; };
          })
          { };
      };

      default = _: prev: {
        inherit (prev.appendOverlays [
          poetry2nix.overlays.default
          expects-poetry2nix
        ]) CHANGEME;
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
