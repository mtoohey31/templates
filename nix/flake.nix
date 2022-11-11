{
  inputs = {
    templates.url = "../";
    nixpkgs.follows = "templates/nixpkgs";
    utils.follows = "templates/utils";
  };

  outputs = { nixpkgs, utils, ... }: utils.lib.eachDefaultSystem
    (system: with import nixpkgs { inherit system; }; {
      devShells.default = mkShell {
        packages = [ deadnix nil nixpkgs-fmt statix ];
      };
    });
}
