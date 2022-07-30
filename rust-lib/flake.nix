{
  description = "CHANGEME";

  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, utils }:
    utils.lib.eachDefaultSystem (system:
      with import nixpkgs { inherit system; }; rec {
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
