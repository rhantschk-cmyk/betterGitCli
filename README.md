# Better Git CLI (`bgt`)

`bgt` turns the repetitive GitHub flow into a few predictable commands while
delegating authentication to the official GitHub CLI (`gh`). It never stores or
accepts a GitHub token itself.

## First-time setup

1. Revoke any token that has been pasted into a shell, chat or source file, and
   create a new one only if you really need a personal-access token. The normal
   `gh` browser login is preferable.
2. Install `gh` and `git` in NixOS, then install this CLI (see below).
3. Run `bgt setup`. It opens GitHub's browser login and makes Git ask `gh` for
   HTTPS credentials. Subsequent `git push`, `pull`, and all `bgt` commands use
   that login without prompting for a username or token.

## Commands

```text
bgt create my-project --private --description "A useful project"
bgt clone octocat/Hello-World
bgt save "Explain the thing"             # stages all, commits, pushes
bgt save "Only docs" README.md docs/
bgt sync                                  # pull --rebase, then push
bgt pr "Add a useful feature" --draft
bgt status
bgt open
bgt doctor
```

`create` must be run from a new empty directory. It creates `main`, a README,
the first commit, a private GitHub repo, `origin`, and pushes—all in one call.
Use `--public` when appropriate.

## System-wide NixOS installation

Add this repository as a flake input to your NixOS configuration:

```nix
# flake.nix
inputs.better-git-cli.url = "path:/home/raphael/Work/Projekte/betterGitCli";

# in the NixOS module's environment.systemPackages list
environment.systemPackages = [
  inputs.better-git-cli.packages.${pkgs.system}.default
];
```

Then rebuild your system:

```bash
sudo nixos-rebuild switch --flake /path/to/your/nixos-config
```

For a per-user but still persistent installation with Home Manager, put the
same package in `home.packages`. For a quick one-off run before installation:

```bash
nix run . -- doctor
```

The flake packages `git` and `gh` as runtime dependencies, so `bgt` works even
when they are not separately placed in your system packages.
