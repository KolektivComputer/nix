# kolektiv/nix

Umbrella flake. App flakes as inputs; pick the packages you want under `inputs.kolektiv.packages.${system}.*`, or overlay into `pkgs.kolektiv.*`.

Two families in one flake: `packages` for CLIs and desktop apps; `nixosModules` (and `*-server` packages when needed) for deployables. Keep attrs clear (`kalendee` vs `kalendee-server`).

Don’t invent `inputs.kolektiv.pkgs`. No second branch.

```nix
{
  inputs.kolektiv.url = "github:KolektivComputer/nix";
}
```

```bash
nix build github:KolektivComputer/nix#katalog
nix build github:KolektivComputer/nix#kalendee-server   # when wired
```

```nix
# after overlays.default
pkgs.kolektiv.katalog
pkgs.kolektiv.kalendee-server
```

Prefer a single app’s flake when you only need that package.

## Per-repo rule

- **Desktop Linux target** ⇒ that repo ships a flake exporting `packages`.
- **Deployable server** ⇒ also export a NixOS module and/or `*-server` package; the umbrella re-exports under clear names.

## How it works

This repo does **not** vendor app sources. Each Kolektiv app ships its own flake; this umbrella lists them as inputs and re-exports every package/module under one attrset. Extending = add an input + re-export lines. Users pick which packages/modules they want.

Pin `nixpkgs.follows` across children so the tree shares one nixpkgs.
