{
  description = "CHANGEME";

  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, utils }:
    utils.lib.eachDefaultSystem
      (system:
        with import nixpkgs { inherit system; }; rec {
          packages.CHANGEME = buildGoModule rec {
            name = "CHANGEME";
            pname = name;
            src = ./.;
            vendorSha256 = "";
          };
          defaultPackage = packages.CHANGEME;

          devShell = mkShell { nativeBuildInputs = [ go gopls ]; };
        }) // {
      overlay = (final: prev: { CHANGEME = self.defaultPackage."${prev.system}"; });
    };
}
