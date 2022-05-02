{
  description = "CHANGEME";

  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, utils }:
    utils.lib.eachDefaultSystem (system:
        with import nixpkgs { inherit system; }; rec {
          packages.default = buildGo118Module rec {
            name = "CHANGEME";
            pname = name;
            src = ./.;
            vendorSha256 = "";
          };

          devShells.default = mkShell { nativeBuildInputs = [ go_1_18 gopls ]; };
        }) // {
      overlays.default = (final: _: {
        CHANGEME = self.packages."${final.system}".default;
      });
    };
}
