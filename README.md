# James's dotfiles

- The collection of the installation of some basic develop tools, some handy aliases and functions.
- I maintain this repossitory as my dotfiles and just support for [`bash`](https://en.wikipedia.org/wiki/Bash_(Unix_shell)) and [`Z`](https://en.wikipedia.org/wiki/Z_shell) shell.

## Usages

### Installation

```sh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/jamesnguyen46/dotfiles/main/scripts/bootstrap.sh)" \
   -s install
```

*Note that your original config file will be backed up to the same directory with name `*_dotfilesbackup_YYMMDDHHMMSS`.*

### Uninstalling

```sh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/jamesnguyen46/dotfiles/main/scripts/bootstrap.sh)" \
   -s uninstall
```

*Backup file `*_dotfilesbackup_YYMMDDHHMMSS` will be restored after uninstalling completely.*

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

### Docker

This project uses Docker to improve the development and testing experience.
You can use some of the commands below or use via the `make` command :

|        | Commands                                   | Make cmd         | Description                             |
| ------ | ------------------------------------------ | ---------------- | --------------------------------------- |
| Bash   | `docker-compose run ubuntu-bash`           | `make run_bash`  | Build docker image and run `bash` shell |
|        | `docker-compose exec -it ubuntu-bash bash` | `make exec_bash` | Exec to the existing `bash` shell       |
| zsh    | `docker-compose run ubuntu-zsh`            | `make run_zsh`   | Build docker image and run `zsh` shell  |
|        | `docker-compose exec -it ubuntu-zsh zsh`   | `make exec_zsh`  | Exec to the existing `zsh` shell        |
| others |                                            | `make clean`     | Clean all existing containers           |
