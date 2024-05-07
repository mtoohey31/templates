{
  description = "CHANGEME";

  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, utils }: {
    overlays.default = final: _: {
      CHANGEME = final.callPackage
        ({ stdenv }: stdenv.mkDerivation {
          pname = "CHANGEME";
          version = "0.1.0";
          src = builtins.path { path = ./..; name = "CHANGEME-src"; };
        })
        { };
    };
  } // utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs {
        overlays = [ self.overlays.default ];
        inherit system;
      };
      inherit (pkgs) CHANGEME mkShell;
    in
    {
      packages.default = CHANGEME;

      devShells.default = mkShell { inputsFrom = [ CHANGEME ]; };
    });
}
