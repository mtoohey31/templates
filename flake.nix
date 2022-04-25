{
  description = "My Nix flake templates.";
  
  outputs = { self }: {
    templates = {
      course.path = ./course;
      empty.path = ./empty;
      go.path = ./go;
      go118.path = ./go118;
      # TODO: add go+container template
      python.path = ./python;
      rust-bin.path = ./rust-bin;
      rust-lib.path = ./rust-lib;
    };

    defaultTemplate = self.templates.empty;
  };
}
