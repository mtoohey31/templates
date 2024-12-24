{
  description = "CHANGEME";

  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }: {
    overlays.default = final: _: {
      CHANGEME = final.callPackage
        ({ buildGoModule }: buildGoModule {
          pname = "CHANGEME";
          version = "0.1.0";
          src = builtins.path { path = ./..; name = "CHANGEME-src"; };
          vendorHash = null;
        })
        { };
    };
  } // flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs {
        overlays = [ self.overlays.default ];
        inherit system;
      };
      inherit (pkgs) CHANGEME gopls mkShell;
    in
    {
      packages.default = CHANGEME;

      devShells.default = mkShell {
        inputsFrom = [ CHANGEME ];
        packages = [ gopls ];
      };
    });
}
