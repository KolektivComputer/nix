# kolektiv/nix

Umbrella flake. Compose app flakes into one input. Use `inputs.kolektiv.packages.${system}.katalog` (and friends), or overlay to `pkgs.kolektiv.*`. Prefer a single app’s flake when you only need that package.

```nix
{
  inputs.kolektiv.url = "github:KolektivComputer/nix";
}
```

## Two families (one flake)

| Family | For | Example |
| --- | --- | --- |
| `packages.${system}.*` | CLIs + desktop Linux apps | `katalog`, `kascade`, `kalendee` (client) |
| `nixosModules.*` (+ optional `packages.*.*-server`) | Deployable servers / services | `nixosModules.kalendee`, `packages.*.kalendee-server` |

Attr names stay clear: `kalendee` vs `kalendee-server`. No second `nix-server` repo or branch — selective attrs on this umbrella.

```bash
nix build github:KolektivComputer/nix#katalog
nix build github:KolektivComputer/nix#kalendee-server   # when wired
```

```nix
# after overlays.default
pkgs.kolektiv.katalog
pkgs.kolektiv.kalendee-server
```

Don’t invent `inputs.kolektiv.pkgs`.

## Per-repo rule

- **Desktop Linux target** ⇒ that repo ships a flake exporting `packages`.
- **Deployable server** ⇒ also export a NixOS module and/or `*-server` package; the umbrella re-exports under clear names.

## How it works

This repo does **not** vendor app sources. Each Kolektiv app ships its own flake; this umbrella lists them as inputs and re-exports every package/module under one attrset. Extending = add an input + re-export lines. Users pick which packages/modules they want.

Pin `nixpkgs.follows` across children so the tree shares one nixpkgs.
