{
  description = "A simple nix library to help generate development environment CLIs for projects.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    (
      flake-utils.lib.eachDefaultSystem (
        system: let
          cli-overlay = _: super: {
            cli = super.lib.mkCli "cli" {
              _noAll = true;

              test = {
                lint = "${pkgs.statix}/bin/statix check .";
                dead-code = "${pkgs.deadnix}/bin/deadnix .";
                format = "${pkgs.alejandra}/bin/alejandra --check .";
              };

              fix = {
                lint = "${pkgs.statix}/bin/statix fix .";
                dead-code = "${pkgs.deadnix}/bin/deadnix -e .";
                format = "${pkgs.alejandra}/bin/alejandra .";
              };
            };
          };

          pkgs = import nixpkgs {
            inherit system;
            overlays = [
              self.overlays.default
              cli-overlay
            ];
            config = {};
          };
        in {
          devShells.default = pkgs.mkShell {
            buildInputs = [pkgs.cli pkgs.git];
          };
        }
      )
    )
    // {
      overlays.default = final: prev: {
        lib = prev.lib // {mkCli = final.callPackage ./src {};};
      };
    };
}
