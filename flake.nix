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
      };
    };
}
