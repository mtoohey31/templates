{
  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        inherit (pkgs) mkShell deadnix nil nixpkgs-fmt statix;
      in
      {
        devShells.default = mkShell {
          packages = [ deadnix nil nixpkgs-fmt statix ];
        };
      });
}
