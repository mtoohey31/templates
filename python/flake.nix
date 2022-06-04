{
  description = "CHANGEME";

  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";
    utils.url = "github:numtide/flake-utils";
    poetry2nix.url = "github:nix-community/poetry2nix";
  };

  outputs = { self, nixpkgs, utils, poetry2nix }:
    utils.lib.eachDefaultSystem
      (system:
        let pkgs = import nixpkgs {
          inherit system;
          overlays = [ poetry2nix.overlay ];
        }; in
        with pkgs; rec {
          packages.default = pkgs.poetry2nix.mkPoetryApplication {
            projectDir = ./.;
          };

          devShells.default = (pkgs.poetry2nix.mkPoetryEnv {
            projectDir = ./.;
          }).overrideAttrs (oldAttrs: {
            nativeBuildInputs = oldAttrs.nativeBuildInputs ++ [
              poetry
              python3Packages.python-lsp-server
            ];
          });
        }) // {
      overlays.default = nixpkgs.lib.composeManyExtensions [
        poetry2nix.overlay
        (final: _: { CHANGEME = self.packages."${final.system}".default; })
      ];
    };
}
