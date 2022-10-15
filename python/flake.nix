{
  description = "CHANGEME";

  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, utils }: {
    overlays.default = final: prev: {
      CHANGEME = final.poetry2nix.mkPoetryApplication {
        projectDir = ./.;
      };
    };
  } // utils.lib.eachDefaultSystem (system: with import nixpkgs
    { overlays = [ self.overlays.default ]; inherit system; }; {
    packages.default = CHANGEME;

    devShells.default = (poetry2nix.mkPoetryEnv {
      projectDir = ./.;
    }).overrideAttrs (oldAttrs: {
      nativeBuildInputs = oldAttrs.nativeBuildInputs ++ [
        poetry
        python3
        python3Packages.python-lsp-server
      ];
    });
  });
}
