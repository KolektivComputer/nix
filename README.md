# kolektiv/nix

One flake input for Kolektiv apps and CLIs. Build `#katalog` / `#kascade`, or overlay to `pkgs.kolektiv.*`.

```nix
{
  inputs.kolektiv.url = "github:KolektivComputer/nix";
  # …
}
```

## Packages

```bash
nix build github:KolektivComputer/nix#katalog
nix build github:KolektivComputer/nix#kascade
```

## Overlay

```nix
# after applying inputs.kolektiv.overlays.default
pkgs.kolektiv.katalog
pkgs.kolektiv.kascade
```

Prefer this channel on NixOS over tool-managed Node envs (`vp env`). Aggregator calls each app's `package.nix` / flake — sources stay in their repos.
