# Better Git CLI (`bgt`)

`bgt` turns the repetitive GitHub flow into a few predictable commands. It owns
its GitHub authentication and never changes Git credential configuration.

## First-time setup

1. Revoke any token that has been pasted into a shell, chat or source file.
2. Install this CLI (see below), then run `bgt auth set` and paste a newly
   created GitHub token when prompted.

The username and token are stored only in `~/.config/bgt/credentials` with mode
`0600`. They are never written to Git configuration or to the repository.

### Why this works with read-only Home Manager Git config

`bgt` never writes Git configuration, does not install a Git credential helper,
and does not use `GIT_ASKPASS`. For its own HTTPS clone, pull, and push
operations, it supplies an in-memory HTTP authorization header derived from its
own config. The token is never stored in `.git` or `~/.gitconfig`.

Plain `git push` remains intentionally unmanaged; use `bgt save` or `bgt sync`
when you want bgt to authenticate Git for you.

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
