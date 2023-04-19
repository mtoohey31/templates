{
  inputs = {
    templates.url = "path:../";
    nixpkgs.follows = "templates/nixpkgs";
    utils.follows = "templates/utils";
  };

  outputs = { nixpkgs, utils, ... }: utils.lib.eachDefaultSystem
    (system:
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
