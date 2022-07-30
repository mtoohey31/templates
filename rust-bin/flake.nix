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

  outputs = { self, nixpkgs, utils, naersk }:
    utils.lib.eachDefaultSystem (system:
      with import nixpkgs { inherit system; }; rec {
        packages.default = naersk.lib.${system}.buildPackage {
          pname = "CHANGEME";
          root = ./.;
        };

        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
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
