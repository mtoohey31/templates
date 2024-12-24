{
  description = "CHANGEME";

  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }: {
    overlays.default = _: prev: {
      ocamlPackages = prev.ocamlPackages.overrideScope (final: _: {
        CHANGEME = final.buildDunePackage {
          pname = "CHANGEME";
          version = "0.1.0";
          src = builtins.path { path = ./..; name = "CHANGEME-src"; };
          minimalOcamlVersion = "4.14.1";
          duneVersion = "3";
        };
      });
    };
  } // flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs {
        overlays = [ self.overlays.default ];
        inherit system;
      };
      inherit (pkgs) mkShell ocamlformat ocamlPackages;
      inherit (ocamlPackages) CHANGEME ocaml-lsp;
    in
    {
      packages.default = CHANGEME;

      devShells.default = mkShell {
        inputsFrom = [ CHANGEME ];
        packages = [ ocamlformat ocaml-lsp ];
      };
    });
}
