{
  description = "Kolektiv umbrella — app flakes → packages (desktop/CLI) + nixosModules (servers)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # App flakes (re-export only). Uncomment as each ships packages / nixosModules:
    # katalog.url = "github:KolektivComputer/katalog";
    # katalog.inputs.nixpkgs.follows = "nixpkgs";
    # kascade.url = "github:KolektivComputer/kascade";
    # kascade.inputs.nixpkgs.follows = "nixpkgs";
    # kalendee.url = "github:KolektivComputer/kalendee";
    # kalendee.inputs.nixpkgs.follows = "nixpkgs";
    # keel.url = "github:KolektivComputer/keel";
    # keel.inputs.nixpkgs.follows = "nixpkgs";
    # wake.url = "github:KolektivComputer/wake";
    # wake.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, ... }@inputs:
    let
      systems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f system);

      # Desktop / CLI packages: attr → flake input exposing packages.${system}.default
      appPackages = {
        # katalog = "katalog";
        # kascade = "kascade";
        # kalendee = "kalendee";       # desktop client package
        # wake = "wake";
      };

      # Optional *-server package attrs from the same or sibling flake outputs
      serverPackages = {
        # kalendee-server = { input = "kalendee"; attr = "kalendee-server"; };
      };

      # nixosModules: attr → flake input exposing nixosModules.default (or named)
      appModules = {
        # kalendee = "kalendee";
      };

      packagesFor = system:
        (nixpkgs.lib.mapAttrs (_: inputName:
          inputs.${inputName}.packages.${system}.default
        ) appPackages)
        // (nixpkgs.lib.mapAttrs (_: spec:
          inputs.${spec.input}.packages.${system}.${spec.attr}
        ) serverPackages);

      modulesFor =
        nixpkgs.lib.mapAttrs (_: inputName:
          inputs.${inputName}.nixosModules.default or inputs.${inputName}.nixosModules.${inputName}
        ) appModules;

    in
    {
      packages = forAllSystems packagesFor;
      legacyPackages = forAllSystems packagesFor;

      nixosModules = modulesFor // {
        # default = …;  # optional aggregate
      };

      overlays.default = final: prev: {
        kolektiv = packagesFor final.stdenv.hostPlatform.system;
      };
    };
}
