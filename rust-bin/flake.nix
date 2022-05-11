{
  description = "CHANGEME";

  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";
    utils.url = "github:numtide/flake-utils";
    naersk = {
      url = "github:nix-community/naersk";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs-mozilla.url = "github:mozilla/nixpkgs-mozilla";
  };

  outputs = { self, nixpkgs, utils, naersk, nixpkgs-mozilla }:
    utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          overlays = [ nixpkgs-mozilla.overlays.rust ];
          inherit system;
        };
        rustChannel = pkgs.rustChannelOf {
          date = "2022-04-24";
          channel = "nightly";
          sha256 = "LE515NwqEieN9jVZcpkGGmd5VLXTix3TTUNiXb01sJM=";
        };
        inherit (rustChannel) rust;
        naersk-lib = naersk.lib."${system}".override {
          cargo = rust;
          rustc = rust;
        };
      in
      rec {
        packages.default = naersk-lib.buildPackage {
          pname = "CHANGEME";
          root = ./.;
        };

        devShells.default = pkgs.mkShell {
          packages = [
            rust
            pkgs.rust-analyzer
          ];
          shellHook = ''
            export RUST_SRC_PATH="${rustChannel.rust-src}/lib/rustlib/src/rust/library"
          '';
        };
      });
}
