# Better Git CLI (`bgt`)

`bgt` turns the repetitive GitHub flow into a few predictable commands. It owns
its GitHub authentication and never changes Git credential configuration.

## First-time setup

1. Revoke any token that has been pasted into a shell, chat or source file.
2. Install this CLI (see below), then use one of these authentication methods:

   ```bash
   bgt auth       # browser login; needs gh only for this login step
   bgt auth set   # enter a GitHub token manually
   ```

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

Add the public repository directly as a flake input—no clone is needed:

```nix
# flake.nix
inputs.better-git-cli.url = "github:rhantschk-cmyk/betterGitCli";

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
nix run github:rhantschk-cmyk/betterGitCli -- doctor
```

The Nix package includes Git, curl, and core utilities. `gh` is optional and is
needed only for the browser-based `bgt auth` flow.

## Portable installation (Linux and macOS)

With Bash, Git, curl, and coreutils available, install the standalone command
without Nix or cloning the repository:

```bash
mkdir -p ~/.local/bin
curl -fsSL https://raw.githubusercontent.com/rhantschk-cmyk/betterGitCli/main/bgt \
  -o ~/.local/bin/bgt
chmod +x ~/.local/bin/bgt
```

Ensure `~/.local/bin` is on your `PATH`, then run `bgt auth`. Install GitHub CLI
only if you want browser authentication; `bgt auth set` works without it.
