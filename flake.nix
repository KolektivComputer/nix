{
  description = "Kolektiv apps and CLIs — one flake input, packages + pkgs.kolektiv overlay";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    # App flakes / package.nix sources — wire as they grow flakes:
    # katalog.url = "github:KolektivComputer/katalog";
    # kascade.url = "github:KolektivComputer/kascade";
  };

  outputs = { self, nixpkgs, ... }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f system);
      # Placeholder set — replace with real derivations from per-app package.nix
      kolektivPkgs = pkgs: {
        # katalog = pkgs.callPackage ./pkgs/katalog { };
        # kascade = pkgs.callPackage ./pkgs/kascade { };
      };
    in
    {
      packages = forAllSystems (system:
        let pkgs = nixpkgs.legacyPackages.${system};
        in kolektivPkgs pkgs
      );

      # Optional nixpkgs-style browsing
      legacyPackages = forAllSystems (system:
        let pkgs = nixpkgs.legacyPackages.${system};
        in kolektivPkgs pkgs
      );

      overlays.default = final: prev: {
        kolektiv = kolektivPkgs final;
      };
    };
}
