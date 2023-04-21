{
  description = "CHANGEME";

  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, utils }: {
    overlays.default = final: _: {
      CHANGEME = final.buildGoModule {
        pname = "CHANGEME";
        version = "0.1.0";
        src = builtins.path { path = ./.; name = "CHANGME-src"; };
        vendorSha256 = null;
      };
    };
  } // utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs {
        overlays = [
          (final: _: {
            gow = final.buildGoModule rec {
              pname = "gow";
              version = builtins.substring 0 7 src.rev;
              src = final.fetchFromGitHub {
                owner = "mitranim";
                repo = pname;
                rev = "36c8536a96b851631e800bb00f73383fc506f210";
                sha256 = "q56s97j+Npurb942TeQhJPqq1vl/XFe7a2Dj5fw7EtQ=";
              };
              vendorSha256 = "o6KltbjmAN2w9LMeS9oozB0qz9tSMYmdDW3CwUNChzA=";
            };
          })
          self.overlays.default
        ]; inherit system;
      };
      inherit (pkgs) CHANGEME go gopls gow mkShell;
    in
    {
      packages.default = CHANGEME;

      devShells.default = mkShell {
        packages = [ go gopls gow ];
      };
    });
}
