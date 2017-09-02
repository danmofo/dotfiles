# Dotfiles

A collection of my dotfiles. It borrows heavily from several other popular dotfile repositories:
- Mathias Bynens, https://github.com/mathiasbynens/dotfiles
- Paul Irish, https://github.com/paulirish/dotfiles

## What does it contain?

- Aliases
- Bash prompt configuration
- Themes for iTerm2
- Scripts
  - `z` for faster navigation
  - `gitignore` for creating .gitignore files from a list of technologies

## Using

### Installation

1. Clone the repository `git clone https://github.com/danmofo/dotfiles --recursive`, **it's very important you use --recursive, otherwise the Git submodules won't be checked out**.
2. Run `./install`
3. Log out and in to see the changes.

### Updating

1. Run `./install` to get the latest updates from the master branch.

### Developing

The installation script was created using `argbash` (https://github.com/matejak/argbash/), using the template inside `install_template.m4` with the following command (assuming argbash is in the default install location): `~/.local/bin/argbash ~/dev/dotfiles/install_template.m4 -o install`

`argbash` wraps our installation script and gives us access to passed arguments, without having to write any argument parsing code.

## TODO

1. Fill in missing files.
2. Add steps to apply the theme.
