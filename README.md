# minidots

The home-manager config for `max` on `nixos-laptop`. It is a standalone flake: applying it only touches `max`'s own
home directory, never the system configuration.

It started from the `home-manager-user` template in [thecathe/dots](https://github.com/thecathe/dots) and builds on
dots' shared modules, which it takes as the flake input `cathe-dots`.

## What it sets up

| Part | From | Where |
| --- | --- | --- |
| zsh, starship, tmux, kitty, zoxide, direnv | `cathe-dots.homeModules.shell` | `home.nix` |
| Neovim | `cathe-dots.homeModules.nvim` | `home.nix` |
| VS Code, with the profiles `default`, `java`, `python`, `rocq`, `haskell` | `cathe-dots.homeModules.vscode` | `dots.vscode` in `home.nix` |
| `globalprotect up \| down \| status` for the Kent VPN | `cathe-dots.homeModules.globalprotect` | `dots.globalprotect` in `home.nix` |
| Discord, git, gh, and a few command-line tools | nixpkgs | `home.nix` |

## Applying it

From this directory, as `max`:

```sh
home-manager switch --flake .#max@nixos-laptop
```

(`rebuild` is an alias for exactly that.) The very first time, before `home-manager` exists, use
`nix run home-manager/master -- switch --flake .#max@nixos-laptop` instead.

Quit VS Code before switching. Each profile's window layout is seeded from the default profile, and that step is
skipped while VS Code is running.

## Your git email (once per machine)

The email git commits with is not kept in this public repo. Set it once, in a file outside it:

```sh
git config --file ~/.config/git/identity user.email you@example.com
```

Until then `git commit` stops with "Author identity unknown", rather than guessing an address from the hostname.
GitHub has a private `<id>+<username>@users.noreply.github.com` address (Settings, Emails) if you would rather not
use your own.

## Everyday changes

- **VS Code profiles:** edit `dots.vscode.profiles` in `home.nix`. The names available are those in dots'
  [`groups.nix`](https://github.com/thecathe/dots/blob/main/modules/home/vscode/groups.nix). `default` is always built.
- **Tuning dots' VS Code settings:** this repo's own changes to them live in `modules/home/vscode/`, one file per part.
  `default.nix` explains how they combine with dots' settings and lists the files; start there to see how to customise
  more of what dots provides.
- **Grammar and spell checking (LTeX+, `latex` profile):** edit `modules/home/vscode/ltex.nix`; the commented lines
  there are examples (language, dictionary, disabled rules, LaTeX commands to ignore). They are added to dots' settings
  for that profile, so only a key dots itself sets (`ltex.enabled`, `ltex.java.path`, `ltex.ltex-ls.path`) needs
  `lib.mkForce`. These land in a Nix-managed, read-only `settings.json`; the extension's default is to save quick fixes
  such as "Add to dictionary" to files in the workspace instead.
- **Updating dots:** `nix flake update cathe-dots`, then switch. Updating the pin is the only way dots' changes reach
  this config, so it happens when you choose.
- **VPN:** `globalprotect up` asks for your sudo password, opens the browser for the login, and then stays running in
  that terminal. Stop it with Ctrl-C or `globalprotect down` from another terminal. `globalprotect status` says
  whether it is up.

## Zotero and the end-of-life Firefox

Zotero 10 is built on Firefox's engine and only works with Firefox 140 ESR, which reached end-of-life on 2026-10-13.
nixpkgs therefore flags the copy it ships for Zotero as insecure, and `flake.nix` permits exactly that package
(`config.permittedInsecurePackages`). It is Zotero's own embedded engine, separate from the Firefox you browse with, but
it does render web pages Zotero saves and the PDFs and EPUBs you open in it, so avoid opening untrusted ones there.

This is temporary. Zotero 11 is meant to move to Firefox ESR 153. Once nixpkgs has it, the rebuild fails on purpose
with the steps for removing the exception (an `assertions` entry in `home.nix`).

## Where the clone lives

The repo is expected at `~/Documents/git/Butev/minidots`, with `~/dots` linking to it (see below). The first is named
in `dots.nixd.flake` in `home.nix`, which lets the Nix language server in VS Code and neovim complete home-manager
options from this flake; it has to be the real path, not the `~/dots` link. If you move the clone, change that line.

## Why `modules/home/shell/zsh/` is here

dots' zsh module keeps its aliases (`alias-set NAME VALUE`) and directory shortcuts (`dhash-set NAME DIR`) in
`~/dots/modules/home/shell/zsh/`. So this repo is linked at `~/dots` on `max`'s account, and the two tracked files
`aliases.dots.zsh` and `dirs.dots.zsh` live here. Adding `--local` (`alias-set --local ...`) writes to the untracked
`*.local.zsh` files instead.

The rest of `modules/home/` is a different kind of thing: `modules/home/vscode/` is this repo's own home-manager module,
imported from `home.nix` and evaluated by Nix, not read at runtime like the zsh files. It is laid out the way dots lays
out its own modules (`modules/home/<name>/default.nix`), so the two are easy to compare.
