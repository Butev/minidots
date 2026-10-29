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
- **Updating dots:** `nix flake update cathe-dots`, then switch. Updating the pin is the only way dots' changes reach
  this config, so it happens when you choose.
- **VPN:** `globalprotect up` asks for your sudo password, opens the browser for the login, and then stays running in
  that terminal. Stop it with Ctrl-C or `globalprotect down` from another terminal. `globalprotect status` says
  whether it is up.

## Where the clone lives

The repo is expected at `~/Documents/git/Butev/minidots`, with `~/dots` linking to it (see below). The first is named
in `dots.nixd.flake` in `home.nix`, which lets the Nix language server in VS Code and neovim complete home-manager
options from this flake; it has to be the real path, not the `~/dots` link. If you move the clone, change that line.

## Why `modules/home/shell/zsh/` is here

dots' zsh module keeps its aliases (`alias-set NAME VALUE`) and directory shortcuts (`dhash-set NAME DIR`) in
`~/dots/modules/home/shell/zsh/`. So this repo is linked at `~/dots` on `max`'s account, and the two tracked files
`aliases.dots.zsh` and `dirs.dots.zsh` live here. Adding `--local` (`alias-set --local ...`) writes to the untracked
`*.local.zsh` files instead.
