#!/usr/bin/env bash
#
# dotfiles installation script.
#
# Usage:
# ./install (--force)
#

#
# This command is used for both the initial installation and updating.
#
# Source: https://github.com/mathiasbynens/dotfiles/blob/master/bootstrap.sh
#
# Argbash docs: http://argbash.readthedocs.io/en/stable/example.html
#
# ARG_OPTIONAL_BOOLEAN([force], , [Force the bootstrap installation script to be executed again])
# ARG_OPTIONAL_BOOLEAN([dry-run], , [Get a report on what will happen running this script. Nothing on the system will be changed.])
# ARG_OPTIONAL_BOOLEAN([backups], ,[List backups made for this system.])
# ARG_HELP(Run once to install the dotfiles and associated dependencies. Run again to get updates.)
# ARGBASH_GO

# [ <-- needed because of Argbash

## Parameters parsed and made available by argbash
forced=$_arg_force
is_dry_run=$_arg_dry_run
show_backups=$_arg_backups

## Configuration
dotfiles=(".path" ".bash_profile" ".bash_prompt" ".exports" ".aliases" ".functions" ".extra" ".inputrc" ".osx" ".vimrc")
backup_location="$HOME/.dotfile-backups/"
software_dependencies=("node" "n" "diff-so-fancy" "ag")

########################################
#  Pre-installation checks.
########################################

## Make sure brew is installed on OSX
if [[ $OSTYPE == "darwin15" ]]; then
  if [[ ! $(type -P brew) ]]; then
    echo "Please install homebrew (brew) before continuing: https://brew.sh/"
  fi
fi

########################################
#  Dry run (--dry-run)
########################################
if [[ $is_dry_run == "on" ]]; then

  ## Report which files would be affected by running this script
  existing_files=()

  for file in "${dotfiles[@]}"; do
    if [[ -e "$HOME/$file" ]]; then
        existing_files+=("$file")
    fi
  done

  if [[ "${existing_files[@]}" != "" ]]; then
    echo "The following file(s) were found in your home directory and would be archived and replaced:"
    for file in "${existing_files[@]}"; do
      echo "  - ~/$file"
    done
  fi

  ## Report the software that would be installed - I know this is duplicated. I could possibly set some boolean variables
  ## at the start of the script so that the conditional statment isn't repeated
  echo "Software summary:"

  for dependency in "${software_dependencies[@]}"; do
    if [[ ! $(type -P "$dependency") ]]; then
      echo "  - $dependency will be installed."
    else
      echo "  - $dependency already installed @ $(type -P "$dependency")."
    fi
  done

  exit
fi

########################################
#  Backups (--backups)
#  List all backups that have been made so far.
########################################

if [[ $_arg_backups == "on" ]]; then
  if [[ -e "$backup_location" ]]; then
      echo "Found the following backups @ $backup_location:"
      ls -l "$backup_location"
    else
      echo "No backups found."
  fi

  exit
fi

########################################
#  Main script
########################################

## Read user input, taking the first character that was entered (-n 1)
read -p "This will backup all existing dotfiles and could break your system. Are you sure? (y/n) " -n 1;
echo "";

## Sync files into the relevant locations, overwriting anything that exists.
if [[ "$REPLY" =~ ^[Yy]$ ]]; then

  ## Make backups of existing files before we replace anything
  if [[ "${dotfiles[@]}" != "" ]]; then
    backup_dir="$backup_location$(date +%s)"
    mkdir -p $backup_dir
    echo "Creating backup @ $backup_dir"
    for file in ${dotfiles[@]}; do
      if [[ -e "$HOME/$file" ]]; then
          cp $HOME/$file $backup_dir/$file
          echo "Backed up $HOME/$file"
      fi
    done

    echo "Existing dotfiles have been backed up."
  else
    echo "No existing dotfiles found."
  fi

  ## Grab the latest version
  git pull origin master

  ## Optionally run the bootstrap script in the following circumstances:
  ## - --forced flag passed
  ## - If the script hasn't been run before
  if [ $forced == "on" -o  ! -e "$HOME/.dotfile-bootstrapped" ]; then
    ./bootstrap
  fi

  rsync --exclude ".git/" \
    --exclude ".DS_Store" \
    --exclude "install" \
    --exclude "install_template.m4" \
    --exclude "bootstrap" \
    --exclude "README.md" \
    --exclude "themes/" \
    --exclude "npm-debug.log" \
    -avh --no-perms . $HOME;

  source $HOME/.bash_profile
else
  echo "User cancelled installation. - :("
fi;


# ] <-- needed because of Argbash
