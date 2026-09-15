{
  description = "Kolektiv umbrella flake — compose app flakes into packages + pkgs.kolektiv overlay";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # App flakes (re-export only — sources stay in each repo).
    # Uncomment as each repo ships a flake with packages.${system}.default (or named attrs):
    # katalog.url = "github:KolektivComputer/katalog";
    # katalog.inputs.nixpkgs.follows = "nixpkgs";
    # kascade.url = "github:KolektivComputer/kascade";
    # kascade.inputs.nixpkgs.follows = "nixpkgs";
    # kalendee.url = "github:KolektivComputer/kalendee";
    # kalendee.inputs.nixpkgs.follows = "nixpkgs";
    # keel.url = "github:KolektivComputer/keel";
    # keel.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, ... }@inputs:
    let
      systems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f system);

      # Map: attr name under packages / pkgs.kolektiv → flake input name that exposes .packages.${system}.default
      # Add a line here when a new app flake lands.
      appFlakes = {
        # katalog = "katalog";
        # kascade = "kascade";
        # kalendee = "kalendee";
        # keel = "keel";
      };

      packagesFor = system:
        nixpkgs.lib.mapAttrs (_name: inputName:
          inputs.${inputName}.packages.${system}.default
        ) appFlakes;

    in
    {
      # Idiomatic: inputs.kolektiv.packages.${system}.katalog
      packages = forAllSystems packagesFor;

      legacyPackages = forAllSystems packagesFor;

      overlays.default = final: prev: {
        kolektiv = packagesFor final.stdenv.hostPlatform.system;
      };
    };
}
