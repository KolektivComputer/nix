# kolektiv/nix

Umbrella flake. Compose app flakes into one input. Use `inputs.kolektiv.packages.${system}.katalog` (and friends), or overlay to `pkgs.kolektiv.*`. Prefer a single app’s flake when you only need that package.

```nix
{
  inputs.kolektiv.url = "github:KolektivComputer/nix";
}
```

```bash
nix build github:KolektivComputer/nix#katalog
nix build github:KolektivComputer/nix#kascade
```

```nix
# after overlays.default
pkgs.kolektiv.katalog
pkgs.kolektiv.kascade
```

Don’t invent `inputs.kolektiv.pkgs` — use `packages.${system}.*` or the overlay.

## How it works

This repo does **not** vendor app sources. Each Kolektiv app ships its own flake; this umbrella lists them as inputs and re-exports every package under one attrset. Extending = add an input + one re-export line. Users pick which packages to build/install; they can also depend on an app flake directly when they only want that one.

Pin `nixpkgs.follows` across children so the tree shares one nixpkgs.
