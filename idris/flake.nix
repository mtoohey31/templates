{
  description = "CHANGEME";

  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";
    utils.url = "github:numtide/flake-utils";
    idris2-pkgs = {
      url = "github:claymager/idris2-pkgs";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "utils";
        idris-server.follows = "";
      };
    };
  };

  outputs = { self, nixpkgs, utils, idris2-pkgs }:
    utils.lib.eachDefaultSystem
      (system:
        let
          pkgs = import nixpkgs
            {
              overlays = [ idris2-pkgs.overlay ];
              inherit system;
            };
          inherit (pkgs.idris2-pkgs._builders) idrisPackage devEnv;
        in
        rec {
          packages.default = idrisPackage ./. { };

          devShells.default = pkgs.mkShell {
            packages = [ (devEnv packages.default) ];
          };
        }
      ) // {
      overlays.default = (final: _: {
        CHANGEME = self.packages.${final.system}.default;
      });
    };
}
