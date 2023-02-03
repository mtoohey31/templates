{
  description = "tree-sitter-CHANGEME";

  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { nixpkgs, utils, ... }: utils.lib.eachDefaultSystem
    # TODO: add package output
    (system: with import nixpkgs { inherit system; }; {
      devShells.default = mkShell {
        packages = [
          nodejs
          python3
          tree-sitter
          typescript
          nodePackages.typescript-language-server
        ];
      };
    });
}
