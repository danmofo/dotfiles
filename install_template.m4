#!/bin/bash
#
# dotfiles installation script.
#
# Usage:
# ./install (--force)
#
# This command is used for both the initial installation and updating.
#
# Source: https://github.com/mathiasbynens/dotfiles/blob/master/bootstrap.sh
#
# Argbash docs: http://argbash.readthedocs.io/en/stable/example.html
#
# ARG_OPTIONAL_BOOLEAN([force], , [Force the bootstrap installation script to be executed again])
# ARGBASH_GO

# [ <-- needed because of Argbash

forced=$_arg_force

## Read user input, taking the first character that was entered (-n 1)
read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1;
echo "";

## Sync files into the relevant locations, overwriting anything that exists.
## todo: possibly store a backup of these somewhere incase the installation screws something up
if [[ $REPLY =~ ^[Yy]$ ]]; then

  ## Grab the latest version
  git pull origin master

  ## Optionally run the bootstrap script in the following circumstances:
  ## - --forced flag passed
  ## - If the script hasn't been run before
  if [[ $forced == "on"] || [! -e "$HOME/.dotfile-bootstrapped" ]]; then
    ./bootstrap
  fi

  rsync --exclude ".git/" \
    --exclude ".DS_Store" \
    --exclude ".osx" \
    --exclude "install" \
    --exclude "bootstrap" \
    --exclude "README.md" \
    --exclude "themes/" \
    -avh --no-perms . ~;

    source ~/.bash_profile
else
  echo "User cancelled installation. - :("
fi;


# ] <-- needed because of Argbash
