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
        CHANGEME = final.naersk.buildPackage {
          pname = "CHANGEME";
          root = ./.;
        };
      };

      default = _: prev: {
        inherit (prev.appendOverlays [
          naersk.overlay
          expects-naersk
        ]) CHANGEME;
      };
    };
  } // utils.lib.eachDefaultSystem (system: with import nixpkgs
    { overlays = [ self.overlays.default ]; inherit system; }; {
    packages.default = CHANGEME;

    devShells.default = mkShell {
      packages = [
        cargo
        cargo-watch
        rust-analyzer
        rustc
        rustfmt
      ];
      shellHook = ''
        export RUST_SRC_PATH=${rustPlatform.rustLibSrc}
      '';
    };
  });
}
