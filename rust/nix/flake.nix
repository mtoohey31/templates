{
  description = "CHANGEME";

  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";
    utils.url = "github:numtide/flake-utils";
    naersk = {
      url = "github:nix-community/naersk";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, utils, naersk }: {
    overlays = rec {
      expects-naersk = final: _: {
        CHANGEME = final.callPackage
          ({ naersk }: naersk.buildPackage {
            pname = "CHANGEME";
            root = builtins.path { path = ./..; name = "CHANGEME-src"; };
          })
          { };
      };

      default = _: prev: {
        inherit (prev.appendOverlays [ naersk.overlay expects-naersk ])
          CHANGEME;
      };
    };
  } // utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs {
        overlays = [ self.overlays.default ];
        inherit system;
      };
      inherit (pkgs) CHANGEME mkShell rust-analyzer rustfmt;
    in
    {
      packages.default = CHANGEME;

      devShells.default = mkShell {
        inputsFrom = [ CHANGEME ];
        packages = [ rust-analyzer rustfmt ];
      };
    });
}
