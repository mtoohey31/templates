{
  description = "CHANGEME";

  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, utils }:
    utils.lib.eachDefaultSystem (system:
        with import nixpkgs { inherit system; }; rec {
          packages.CHANGEME = buildGo118Module rec {
            name = "CHANGEME";
            pname = name;
            src = ./.;
            vendorSha256 = "";
          };
          defaultPackage = packages.CHANGEME;

          devShell = mkShell { nativeBuildInputs = [ go_1_18 gopls ]; };
        }) // {
      overlay = (final: prev: { CHANGEME = self.defaultPackage."${prev.system}"; });
    };
}
