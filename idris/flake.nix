{
  description = "CHANGEME";

  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, utils }: {
    overlays.default = final: _: {
      CHANGEME = final.stdenvNoCC.mkDerivation {
        pname = "CHANGEME";
        version = "0.1.0";
        nativeBuildInputs = [ final.idris2 ];
        src = builtins.path { path = ./.; name = "CHANGEME-src"; };
        makeFlags = [ "PREFIX=$(out)" ];
        meta.platforms = final.idris2.meta.platforms;
      };
    };
  } // utils.lib.eachSystem [ "x86_64-linux" "x86_64-darwin" ]
    (system:
      let
        pkgs = import nixpkgs {
          overlays = [ self.overlays.default ];
          inherit system;
        };
        inherit (pkgs) CHANGEME idris2 mkShell;
      in
      {
        packages.default = CHANGEME;

        devShells.default = mkShell {
          packages = [ idris2 ];
        };
      });
}
