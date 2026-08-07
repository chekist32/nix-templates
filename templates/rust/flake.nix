{
  description = "Simple Rust dev shell";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      rust-overlay,
      ...
    }:
    let
      systems = [
        "x86_64-linux"
      ];
      forAllSystems = nixpkgs.lib.genAttrs systems;

      overlays = [ rust-overlay.overlays.default ];

      pkgsFor = forAllSystems (system: import nixpkgs { inherit system overlays; });
      rustToolchainFor = forAllSystems (
        system:
        pkgsFor.${system}.rust-bin.stable.latest.default.override {
          extensions = [
            "rust-src"
            "rust-analyzer"
          ];
        }
      );
    in
    {
      devShells = forAllSystems (
        system:
        let
          pkgs = pkgsFor.${system};
          rustToolchain = rustToolchainFor.${system};
        in
        {
          devShells.default = pkgs.mkShell {
            packages = [ rustToolchain ];
            shellHook = ''
              export RUST_LLDB_SYSROOT="${rustToolchain}"
              export RUST_BACKTRACE=1
            '';
          };
        }
      );
    };
}
