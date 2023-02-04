# Dotfiles

James's git, zsh, vim, etc config files.

## Usages

### Installation

```sh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/jamesnguyen46/dotfiles/main/scripts/bootstrap.sh)" \
   -s install
```

*Note that your rc file will be renamed to `.zshrc.dotfilesbackup_YYMMDDHHMMSS` or `.bashrc.dotfilesbackup_YYMMDDHHMMSS` depend on your default shell.*

### Uninstalling

```sh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/jamesnguyen46/dotfiles/main/scripts/bootstrap.sh)" \
   -s uninstall
```

*File `.zshrc.dotfilesbackup_YYMMDDHHMMSS` or `.bashrc.dotfilesbackup_YYMMDDHHMMSS` will be restored as `.zshrc` or `.bashrc` after uninstalling completely.*

## Development

### Code analysis and formatter

The project uses [shellcheck](https://github.com/koalaman/shellcheck) and [shfmt](https://github.com/mvdan/sh) (requires [Go](https://go.dev/doc/install) 1.18 or later) to analyze and format shell scripts.

Use them via `pre-commit` as below :

```sh
pre-commit run
```

Or

```sh
pre-commit run --all-files
```
