# Dotfiles

A collection of my dotfiles. It borrows heavily from several other popular dotfile repositories:
- Mathias Bynens, https://github.com/mathiasbynens/dotfiles
- Paul Irish, https://github.com/paulirish/dotfiles

## What does it contain?

- Aliases / functions
- `.inputrc`
- Bash prompt configuration
- Themes for iTerm2
- Scripts
  - `z` for faster navigation
  - `gitignore` for creating .gitignore files from a list of technologies

## Using

### Installation

It's worth noting that the installation script makes no attempt to reinstall existing software, and will only install them if they are completely
absent from the system. So if a super old version of *software X* is installed, the setup may fail and you will need to manually reinstall it.

1. Clone the repository `git clone https://github.com/danmofo/dotfiles --recursive`, **it's very important you use --recursive, otherwise the Git submodules won't be checked out**.
2. Run `./install`. The script **will always** back up existing dotfiles and will only install missing dependencies. You will be prompted before this happens.
3. Log out and in to see the changes.

#### Parameters

The install script accepts the following params:
- `--dry-run`, shows a report of what changes will be made to the system.
- `--backups`, lists the backups made so far.
- `--force`, forces the bootstrap script to be executed another time.

### Updating

1. Run `./install` to get the latest updates from the master branch.

### Developing

The installation script was created using `argbash` (https://github.com/matejak/argbash/), using the template inside `install_template.m4` with the following command (assuming argbash is in the default install location): `~/.local/bin/argbash ~/dev/dotfiles/install_template.m4 -o install`

`argbash` wraps our installation script and gives us access to passed arguments, without having to write any argument parsing code.

## TODO

1. Add steps to apply the theme.
2. Add a way to restore to previous versions in the backup directory.
3. Re add things to the Mac path as I discover what I broke...
4. Spend some more time learning Bash scripting as there are several areas I'd like to improve on
