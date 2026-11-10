# minidots

Standalone home-manager flake for `max` on `nixos-laptop`. See `README.md` for what it sets up and how to apply it.

## Git

- **Integration branch:** `main`.
- **Integration method:** a local `git merge --no-ff <branch>` into `main`, then push `main` to `origin`
  (`Butev/minidots`). No pull request. Work happens on a `type/…` branch in a separate worktree, as in the global
  instructions; `max` gets a change by pulling `main` and rebuilding.
