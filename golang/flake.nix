{
  description = "CHANGEME";

  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";
    utils.url = "github:numtide/flake-utils";
    gow-src = {
      url = "github:mitranim/gow";
      flake = false;
    };
    yaegi-src = {
      url = "github:traefik/yaegi";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, utils, gow-src, yaegi-src }: {
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
            version = "0.1.0";
            src = gow-src;
            vendorSha256 = "o6KltbjmAN2w9LMeS9oozB0qz9tSMYmdDW3CwUNChzA=";
          };
          yaegi-rlwrapped =
            let
              yaegi = final.buildGoModule rec {
                pname = "yaegi-rlwrapped";
                version = yaegi-src.shortRev;
                src = yaegi-src;
                vendorSha256 = "pQpattmS9VmO3ZIQUFn66az8GSmB4IvYhTTCFn6SUmo=";
                GOROOT = "${final.go_1_18}/share/go";
              };
            in
            final.writeShellScriptBin "yaegi" ''
              ${final.rlwrap}/bin/rlwrap ${yaegi}/bin/yaegi "$@"
            '';
        })
        self.overlays.default
      ]; inherit system;
    }; rec {
    packages.default = CHANGEME;

    devShells.default = mkShell {
      packages = [ go gopls gow revive yaegi-rlwrapped ];
    };
  });
}
