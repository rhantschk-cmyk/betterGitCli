{
  description = "A small opinionated Git and GitHub CLI";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in {
      packages = forAllSystems (system:
        let pkgs = import nixpkgs { inherit system; };
        in {
          default = pkgs.writeShellApplication {
            name = "bgt";
            runtimeInputs = [ pkgs.git pkgs.curl pkgs.coreutils pkgs.zip ];
            text = builtins.readFile ./bgt;
          };
        });

      apps = forAllSystems (system: {
        default = {
          type = "app";
          program = "${self.packages.${system}.default}/bin/bgt";
        };
      });

      homeModules.default = { config, lib, pkgs, ... }:
        let
          cfg = config.programs.bgt;
        in {
          options.programs.bgt = {
            enable = lib.mkEnableOption "Better Git CLI";
            browserLogin = lib.mkOption {
              type = lib.types.bool;
              default = true;
              description = "Install GitHub CLI for the optional bgt auth browser flow.";
            };
          };

          config = lib.mkIf cfg.enable {
            home.packages = [
              self.packages.${pkgs.stdenv.hostPlatform.system}.default
            ] ++ lib.optional cfg.browserLogin pkgs.gh;
          };
        };
    };
}
