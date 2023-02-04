{
  sources ? import ./sources.nix,
  nixpkgs ? sources.nixpkgs,
  niv ? sources.niv,
}: let
  niv-overlay = self: _: {
    niv = self.symlinkJoin {
      name = "niv";
      paths = [niv];
      buildInputs = [self.makeWrapper];
      postBuild = ''
        wrapProgram $out/bin/niv \
          --add-flags "--sources-file ${toString ./sources.json}"
      '';
    };
  };

  pkgs = import nixpkgs {
    overlays = [
      niv-overlay
      (import ./overlay.nix)
    ];
  };

  cli = pkgs.lib.mkCli "cli" {
    _noAll = true;

    test = {
      lint.nix = "${pkgs.statix}/bin/statix check .";
      dead-code.nix = "${pkgs.deadnix}/bin/deadnix .";
      format.nix = "${pkgs.alejandra}/bin/alejandra --check .";
    };

    fix = {
      lint.nix = "${pkgs.statix}/bin/statix fix .";
      dead-code.nix = "${pkgs.deadnix}/bin/deadnix -e .";
      format.nix = "${pkgs.alejandra}/bin/alejandra .";
    };
  };
in
  pkgs.mkShell {
    buildInputs = [
      pkgs.git
      cli
    ];
  }
