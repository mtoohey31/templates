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

  outputs = { self, nixpkgs, utils, idris2-pkgs }: {
    overlays = rec {
      expects-idris2-pkgs = final: _: {
        CHANGEME = final.idris2-pkgs._builders.idrisPackage ./. { };
      };

      default = _: prev: {
        inherit (prev.appendOverlays [
          idris2-pkgs.overlay
          expects-idris2-pkgs
        ]) CHANGEME;
      };
    };
  } // utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs {
        overlays = [ idris2-pkgs.overlay self.overlays.expects-idris2-pkgs ];
        inherit system;
      };
      inherit (pkgs.idris2-pkgs._builders) devEnv;
    in
    with pkgs; {
      packages.default = CHANGEME;

      devShells.default = mkShell {
        packages = [ (devEnv CHANGEME) ];
      };
    });
}
