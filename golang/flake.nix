{
  description = "CHANGEME";

  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";
    utils.url = "github:numtide/flake-utils";
    gow-src = {
      url = "github:mitranim/gow";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, utils, gow-src }: {
    overlays.default = final: _: {
      CHANGEME = final.buildGoModule rec {
        name = "CHANGEME";
        pname = name;
        src = ./.;
        vendorSha256 = null;
      };
    };
  } // utils.lib.eachDefaultSystem (system: with import nixpkgs
    {
      overlays = [
        (final: prev: {
          gow = final.buildGoModule rec {
            pname = "gow";
            version = gow-src.shortRev;
            src = gow-src;
            vendorSha256 = "o6KltbjmAN2w9LMeS9oozB0qz9tSMYmdDW3CwUNChzA=";
          };
        })
        self.overlays.default
      ]; inherit system;
    }; {
    packages.default = CHANGEME;

    devShells.default = mkShell {
      packages = [ go gopls gow revive ];
    };
  });
}
