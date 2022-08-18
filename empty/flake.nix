{
  description = "CHANGEME";

  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, utils }: {
    overlays.default = final: _: {
      CHANGEME = final.stdenv.mkDerivation {
        pname = "CHANGEME";
        version = "0.1.0";
        src = ./.;
      };
    };
  } // utils.lib.eachDefaultSystem (system: with import nixpkgs
    { overlays = [ self.overlays.default ]; inherit system; }; {
    packages.default = CHANGEME;

    devShells.default = mkShell {
      packages = [ ];
    };
  });
}
