{
  description = "My (chekist32) personal flake templates";

  outputs =
    { self }:
    {
      templates = {
        devshell = {
          path = ./templates/devshell;
          description = "Basic dev shell";
        };
        rust = {
          path = ./templates/rust;
          description = "Simple Rust dev shell with VSCode config";
        };
      };
    };
}
