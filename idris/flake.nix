{
  description = "CHANGEME";

  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, utils }: {
    overlays.default = final: _: {
      CHANGEME = final.callPackage
        ({ idris2, stdenvNoCC }: stdenvNoCC.mkDerivation {
          pname = "CHANGEME";
          version = "0.1.0";
          nativeBuildInputs = [ idris2 ];
          src = builtins.path { path = ./.; name = "CHANGEME-src"; };
          makeFlags = [ "PREFIX=$(out)" ];
          meta.platforms = idris2.meta.platforms;
        })
        { };
    };
  } // utils.lib.eachSystem [ "x86_64-linux" "x86_64-darwin" ]
    (system:
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
