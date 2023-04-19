{
  description = "tree-sitter-CHANGEME";

  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, utils }: {
    overlays.default = _: prev: {
      tree-sitter = prev.tree-sitter.override {
        extraGrammars.tree-sitter-CHANGEME = {
          language = "CHANGEME";
          inherit (prev.tree-sitter) version;
          src = _: builtins.path { path = ./.; name = "CHANGME-src"; };
        };
      };
    };
  } // utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs {
        overlays = [ self.overlays.default ];
        inherit system;
      };
      inherit (pkgs) mkShell nodejs nodePackages python3 tree-sitter typescript;
    in
    {
      packages.default = tree-sitter.builtGrammars.tree-sitter-CHANGEME;

      devShells.default = mkShell {
        packages = [
          nodejs
          nodePackages.typescript-language-server
          python3
          tree-sitter
          typescript
        ];
      };
    });
}
