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
          packages.default = buildGoModule rec {
            name = "CHANGEME";
            pname = name;
            src = ./.;
            vendorSha256 = "";
          };

          devShells.default = mkShell { packages = [ go gopls ]; };
        }) // {
      overlays.default = (final: _: {
        CHANGEME = self.packages."${final.system}".default;
      });
    };
}
