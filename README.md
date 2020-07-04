# dotbare

![CI Status](https://github.com/kazhala/dotbare/workflows/CI/badge.svg)
![AWSCodeBuild](https://codebuild.ap-southeast-2.amazonaws.com/badges?uuid=eyJlbmNyeXB0ZWREYXRhIjoiYWVnOEdGbWxuMmpJdVF2S3RTOFdUeGhEZDZvVkZ1cnBtZGJjd0RuOFdxUWxGeG1zR2YycFcydFJZT25VV3NkZnNsRWJ4ZVNsZ0VxZnpOY3RFUGdMV0RNPSIsIml2UGFyYW1ldGVyU3BlYyI6IlNDNjNHTlkyS2ZmbE5lZGIiLCJtYXRlcmlhbFNldFNlcmlhbCI6MX0%3D&branch=master)
![Platform](https://img.shields.io/badge/platform-macos%20%7C%20linux-blue)
![License](https://img.shields.io/badge/license-MIT-green)

## Introduction

dotbare is a command line utility to help you manage your dotfiles. It wraps around git bare
repository and heavily utilises [fzf](https://github.com/junegunn/fzf) for an interactive experience.
It is inspired by [forgit](https://github.com/wfxr/forgit), a git wrapper using fzf.
dotbare uses a different implementation approach and focuses on managing and interacting with your dotfiles.
Don't worry about migration if you have a symlink/GNU stow setup, you can easily integrate dotbare with them.

Pros:

- No symlink
- Simple setup/remove
- Customizable
- Easy migration
- Flat learning curve
- Manage dotfiles anywhere in your system
- Integration with symlink/GNU stow setup

You could find out how git bare repository could be used for managing dotfiles [here](https://www.atlassian.com/git/tutorials/dotfiles).
Or a [video](https://www.youtube.com/watch?v=tBoLDpTWVOM&t=288s) explanation that helped me to get started. If you are currently
using a symlink/GNU stow setup, checkout how to integrate dotbare with them [here](#migrating-from-a-generic-symlink-setup-or-gnu-stow).

![Demo](https://user-images.githubusercontent.com/43941510/82142379-4a1e7500-987f-11ea-8d35-8588a413efd3.png)

## Why

It has always been a struggle for me to get started with managing dotfiles using version control,
as some tools like "GNU stow" really scares me off with all the symlinks, until I found
out about using git bare repository for managing dotfiles, zero symlinks, minimal setup
required and you keep your dotfiles at the location they should be.

However, it has always lack some interactive experience as it does not provide any auto
completion on git commands nor file paths by default. It is also a pain when migrating the setup over
to another system as you will have to manually resolve all the git checkout issues.

dotbare solves the above problems by providing a series of scripts starts with a prefix f
(e.g. `dotbare fadd`, `dotbare flog` etc) that will enable a interactive experience by processing
all the git information and display it through fzf. dotbare also comes with the ability to integrate with
GNU stow or any symlink set up as long as you are using git. It is easy to migrate to any system
with minimal set up required.

## Table of Contents

- [Install](#install)
  - [zsh](#zsh)
  - [bash](#bash)
  - [others](#others)
- [Getting started](#getting-started)
  - [Dependencies](#dependencies)
  - [Setup](#setup)
  - [Migration](#migration)
    - [Migrating from normal git bare repository](#migrating-from-normal-git-bare-repository)
    - [Migrating from a generic symlink setup or GNU stow](#migrating-from-a-generic-symlink-setup-or-gnu-stow)
    - [Migrating dotbare to a new system](#migrating-dotbare-to-a-new-system)
    - [Test it in docker](#test-it-in-docker)
- [Customization](#customization)
  - [DOTBARE_DIR: location of the git directory](#dotbare_dir)
  - [DOTBARE_TREE: location of the working index](#dotbare_key)
  - [DOTBARE_BACKUP: location to backup files](#dotbare_backup)
  - [EDITOR: editor used to open files](#editor)
  - [DOTBARE_KEY: keybinds](#dotbare_key)
  - [DOTBARE_FZF_DEFAULT_OPTS: fzf customization](#dotbare_fzf_default_opts)
- [Commands](#commands)
  - [Checkout all available scripts and their help manual](#checkout-all-available-scripts-and-their-help-manual)
  - [fedit: edit dotfiles](#fedit)
  - [fadd: stage changes](#fadd)
  - [freset: unstage changes](#freset)
  - [fcheckout: discard changes/checkout commits and branch](#fcheckout)
  - [flog: interactive log viewer](#flog)
  - [fstash: stash management](#fstash)
  - [fbackup: backup tracked files](#fbackup)
  - [fstat: toggle stage/unstage files](#fstat)
  - [finit: initialise/migrating dotbare](#finit)
  - [funtrack: untrack files](#funtrack)
  - [fupgrade: update dotbare](#fupgrade)
- [Custom scripts](#custom-scripts)
- [Tips and Tricks](#tips-and-tricks)
- [Testing](#testing)
- [Contributing](#contributing)
- [Coming up](#coming-up)
- [Background](#background)
- [Credit](#credit)
- [Demo](#demo)

## Install

### zsh

dotbare should work with any zsh plugin manager, below is only demonstration.

#### zinit

```sh
zinit light kazhala/dotbare
```

#### oh-my-zsh

- Clone the repository in to [oh-my-zsh](https://github.com/ohmyzsh/ohmyzsh) plugins directory

  ```sh
  git clone https://github.com/kazhala/dotbare.git $HOME/.oh-my-zsh/custom/plugins/dotbare
  ```

- Activate the plugin in `~/.zshrc`

  ```zsh
  plugins=( [plugins...] dotbare [plugins...] )
  ```

#### Antigen

```sh
antigen bundle kazhala/dotbare
```

#### Manual

- Clone the repository (change ~/.dotbare to the location of your preference)

  ```sh
  git clone https://github.com/kazhala/dotbare.git ~/.dotbare
  ```

- Put below into `.zshrc`

  ```sh
  source ~/.dotbare/dotbare.plugin.zsh
  ```

### bash

dotbare comes with a `dotbare.plugin.bash` which will enable both bash command line
completion for dotbare commands and adding dotbare to your PATH. If you don't want the completion,
follow the instructions in [others](#others) which simply add dotbare to your PATH.

- Clone the repository (change ~/.dotbare to the location of your preference)

  ```sh
  git clone https://github.com/kazhala/dotbare.git ~/.dotbare
  ```

- Put below into `.bashrc` or `.bash_profile`

  ```sh
  source ~/.dotbare/dotbare.plugin.bash
  ```

### others

1. Clone the repository (change ~/.dotbare to the location of your preference)

   ```sh
   git clone https://github.com/kazhala/dotbare.git ~/.dotbare
   ```

2. Add dotbare to your PATH

   ```sh
   # This is only an example command for posix shell
   # If you are on fish, use the fish way to add dotbare to your path
   export PATH=$PATH:$HOME/.dotbare
   ```

3. Or you could create a alias which point to dotbare executable

   ```sh
   alias dotbare="$HOME/.dotbare/dotbare"
   ```

## Getting started

### Dependencies

- Required dependency

  - git
  - [fzf](https://github.com/junegunn/fzf)
  - bash(You don't need to run bash, but dotbare does require you have bash in your system)

- Optional dependency

  - [tree](https://linux.die.net/man/1/tree) (Will provide a directory tree view when finding directory)

    ```sh
    # if you are on macos
    brew install tree
    ```

### Setup

1. init git bare repository

   Note: by default, `dotbare finit` will set up a bare repository in \$HOME/.cfg, to customize
   location and various other settings, checkout [customization](#customization)

   ```sh
   dotbare finit
   ```

2. add dotfiles you want to track

   Treat dotbare as normal `git` commands.

   ```sh
   dotbare fadd -f
   # or
   dotbare add [FIELNAME]

   # add entire repository like .config
   dotbare fadd -d
   # or
   dotbare add [DIRECTORY]
   ```

3. commit changes and push to remote

   ```sh
   dotbare commit -m "First commit"
   dotbare remote add origin [URL]
   dotbare push -u origin master
   ```

### Migration

#### Migrating from normal git bare repository

1. follow the steps in [install](#install) to install dotbare
2. check your current alias of git bare reference

   ```sh
   # Below is an example alias, check yours for reference
   alias config=/usr/bin/git --git-dir=$HOME/.cfg --work-tree=$HOME
   ```

3. set env variable for dotbare

   ```sh
   export DOTBARE_DIR="$HOME/.cfg"
   export DOTBARE_TREE="$HOME"
   ```

4. remove the original alias and use `dotbare`

5. optionally you could alias config to dotbare so you keep your muscle memory

   ```sh
   alias config=dotbare
   ```

#### Migrating from a generic symlink setup or GNU stow

##### Keep your current setup but integrate dotbare

1. follow the steps in [install](#install) to install dotbare
2. set environment variable so that dotbare knows where to look for git information

   ```sh
   # e.g. I have all my dotfiles stored in folder $HOME/.myworld and symlinks all of them to appropriate location.
   # export DOTBARE_DIR="$HOME/.myworld/.git"
   # export DOTBARE_TREE="$HOME/.myworld"
   export DOTBARE_DIR=<Path to your .git directory>
   export DOTBARE_TREE=<Path to directory which contains all your dotfiles>
   ```

3. Run dotbare anywhere in your system
4. Note: with this method, you do not run `dotbare finit -u [URL]` when migrating to new system,
   you will do your normal migration steps and then do the above steps.

##### Complete migration

**NOTE**: There's an open [issue](https://github.com/kazhala/dotbare/issues/12) where if you have more than 100 dotfiles
tracked, this method would cause a crash during migration. Please don't use this method before the issue get resolved.

While bare method is great and easy, I recommend keeping your current GNU stow/symlink setup and integrate it with dotbare instead of a migration.
If you are really happy with `dotbare`, as long as your remote repository resembles the structure of your home holder
(reference what I mean in my [repo](https://github.com/kazhala/dotfiles.git)), simply run the command below.

**Disclaimer**: I have not done nearly enough test on this as I don't personally use GNU stow or symlink setup, migrate this way with caution.
I recommend you test this migration in docker, see [Test-it-in-docker](#test-it-in-docker).

```sh
# dotbare will replace all symlinks with the original file and a bare repository will be created at $DOTBARE_DIR
dotbare finit -u [URL]
```

#### Migrating dotbare to a new system

1. follow the steps in [install](#install) to install dotbare
2. Optionally set env variable to customize dotbare location

   > Checkout [customization](#customization)

   ```sh
   export DOTBARE_DIR="$HOME/.cfg"
   export DOTBARE_TREE="$HOME"
   ```

3. give dotbare your remote URL and let it handle the rest

   ```sh
   dotbare finit -u https://github.com/kazhala/dotfiles.git
   ```

#### Test it in docker

When you are about to do migrations, I strongly suggest you give the migration a try in docker first.
The dotbare image is based on alpine linux.

```sh
docker pull kazhala/dotbare:latest
docker container run -it --rm --name dotbare kazhala/dotbare:latest
```

![migration demo](https://user-images.githubusercontent.com/43941510/82392054-3ee96600-9a86-11ea-9ea9-158452c62d06.gif)

## Customization

dotbare could be customized through modification of env variables.

Note: customization of fzf is not covered here, you should checkout their [wiki](https://github.com/junegunn/fzf/wiki).

### DOTBARE_DIR

This is the location of the bare repository, dotbare will look for this directory
and query git information or it will create this directory when initializing dotbare.
Change this to location or rename the directory to your liking.

If you are using symlink/GNU stow setup, set this variable point to the .git folder
within your dotfile directory.

```sh
# Default
export DOTBARE_DIR="$HOME/.cfg"
```

### DOTBARE_TREE

This is the working tree for the git bare repository, meaning this is where the version
control will take place. I don't recommend changing this one unless **ALL** of your config
file is in something like \$XDG_CONFIG_HOME or if you are using symlink/GNU stow setup,
set this variable to point to the folder containing your dotfiles.

```sh
# Default
export DOTBARE_TREE="$HOME"
```

### DOTBARE_BACKUP

This variable is used to determine where to store the backup of your files. It is used
mainly by `dotbare fbackup` which will back up all of your tracked dotfiles into this location.
It is also used by `dotbare finit -u [URL]`, when there is checkout conflict, dotbare will
automatically backup conflicted files to this location.

```sh
# Default
# 2. If XDG_DATA_HOME exist, use XDG_DATA_HOME/dotbare
# 3. otherwise, use $HOME/.local/share/dotbare
export DOTBARE_BACKUP="${XDG_DATA_HOME:-$HOME/.local/share}/dotbare"
```

### EDITOR

This is probably already set in your ENV. dotbare uses this variable to determine
which editor to use when running `dotbare fedit`.

```sh
# Default
export EDITOR="vim"
```

### DOTBARE_KEY

This variable set default keybinds for fzf in dotbare. You could checkout a list of keybinds
to set [here](https://github.com/junegunn/fzf/blob/97a725fbd0e54cbc07e4d72661ea2bd2bb7c01c1/man/man1/fzf.1#L648).

```sh
# Default
export DOTBARE_KEY="
  --bind=alt-a:toggle-all       # toggle all selection
  --bind=alt-j:jump             # label jump mode, sort of like vim-easymotion
  --bind=alt-0:top              # set cursor back to top
  --bind=alt-s:toggle-sort      # toggle sorting
  --bind=alt-t:toggle-preview   # toggle preview
"
```

### DOTBARE_FZF_DEFAULT_OPTS

Customize fzf settings for dotbare. This is useful when you want a different
fzf behavior from your normal system fzf settings.

```sh
# Default is unset
# More settings checkout fzf man page and their wiki
```

## Commands

> dotbare doesn't have a man page yet (it is planned tho), for help, type dotbare [COMMAND] -h

### Checkout all available scripts and their help manual

```sh
# run dotbare without any arguments will display all available `f` scripts
dotbare
# or checkout help for dotbare
dotbare -h
dotbare --help
# for normal git help
dotbare help
```

### fedit

Select files/commits through fzf and edit selected files/commits in \$EDITOR.
Editing commits will perform a interactive rebase.

- Default: list all tracked files and open \$EDITOR to edit the selected files. Support multi selection.
- `-h, --help`: show the help message of `dotbare fedit` and exit.
- `-m, --modified`: list all modified files and open \$EDITOR to edit the selected files. Support multi selection.
- `-c, --commit`: list all commits and edit the selected commit through interactive rebase.

![fedit](https://user-images.githubusercontent.com/43941510/82388905-0d6c9c80-9a7e-11ea-845f-21338c2d3a1f.png)

### fadd

Select files/directories or modified files through fzf and stage the selected files/directories.

- Default: list all modified files and stage selected files. Support multi selection.
- `-h, --help`: show the help message of `dotbare fadd` and exit.
- `-f, --file`: list all files in current directory and stage selected files. Support multi selection. (Used for staging new files to index).
- `-d, --dir`: list all directory under current directory and stage selected directory. Support multi selection. (Used for staging new files to index).

![fadd demo](https://user-images.githubusercontent.com/43941510/82388994-4e64b100-9a7e-11ea-953a-621d85347c57.png)

### freset

Select staged files or commits through fzf and then reset(unstage) staged files or reset HEAD back to certain commits.
Also supports reset HEAD back to certain commits using either `--soft`, `--hard`, `--mixed` flags.
More information on differences between flags [here](https://git-scm.com/docs/git-reset#Documentation/git-reset.txt-emgitresetemltmodegtltcommitgt).

- Default: list all staged files and unstage the selected files. Support multi selection.
- `-h, --help`: show the help message of `dotbare freset` and exit.
- `-c, --commit`: list all commits and then reset HEAD back to the selected commits. (Default: `--mixed`, put all changes into modified state).
- `-S, --soft`: use `--soft` flag instead of `--mixed` flag, reset HEAD to certain commit without modifying working tree.
- `-H, --hard`: use `--hard` flag instead of `--mixed` flag, reset HEAD to certain commit discard all changes from the working tree.
- `-y, --yes`: acknowledge all actions that will be taken and skip confirmation.

### fcheckout

Checkout files/commit/branch interactively through fzf.

- Default: list all modified files and reset selected files back to HEAD. Support multi selection. (Discard all changes)
  **Note**: if your file is staged, you will need to unstage first before running fcheckout to make it work.
- `-h, --help`: show the help message of `dotbare fcheckout` and exit.
- `-s, --select`: list all tracked files and select a commit to checkout the selected files. Support multi selection.
- `-b, --branch`: list all branch and switch/checkout the selected branch.
- `-c, --commit`: list all commits and checkout selected commit.
- `-y, --yes`: acknowledge all actions that will be taken and skip confirmation.

![fcheckout demo](https://user-images.githubusercontent.com/43941510/82389569-e2834800-9a7f-11ea-92b5-ed20c8f2ecda.png)

### flog

Interactive log viewer that will prompt you with a menu after selecting a commit. The action menu contains options including
edit, reset, revert and checkout the selected commits.

- Default: list all commits and then prompt menu to select action to perform.
- `-h, --help`: show the help message of `dotbare flog` and exit.
- `-r, --revert`: revert the selected commit and skip action menu.
- `-R, --reset`: reset HEAD back to the selected commit and skip action menu.
- `-e, --edit`: edit selected commit through interactive rebase and skip action menu.
- `-c, --checkout`: checkout selected commit and skip action menu.
- `-y, --yes`: acknowledge all actions that will be taken and skip confirmation.

![flog demo](https://user-images.githubusercontent.com/43941510/82389843-810fa900-9a80-11ea-9653-544816eb9eb8.png)

### fstash

View and manage stash interactively.

- Default: list all stashes and apply the selected stash. (Default: `apply`).
- `-h, --help`: show the help message of `dotbare fstash` and exit.
- `-s, --select`: list modified files and stash the selected files. Support multi selection.
- `-d, --delete`: list all stashes and delete selected stash. Support multi selection.
- `-p, --pop`: use `pop` instead of `apply`. (`pop` would remove the stash while `apply` preserve the stash).

![fstash demo](https://user-images.githubusercontent.com/43941510/82390106-275bae80-9a81-11ea-8c7c-6573bb1ecada.png)

### fbackup

Backup files to \$DOTBARE_BACKUP directory. This is particular useful when untracking files
or migrating to new machines. This is used by `dotbare finit -u [URL]` for backing up conflicted checkout files.

- Default: backup all tracked files to \$DOTBARE_BACKUP directory. (Default: use `cp` command).
- `-h, --help`: show the help message of `dotbare fbackup` and exit.
- `-s, --select`: list all tracked files and only backup the selected files. Support multi selection.
- `-p PATH, --path PATH`: specify path to files to backup. (This is mainly used by `dotbare finit -u [URL]`).
- `-m, --move`: use `mv` instead of the default `cp` command to backup. (This is mainly used by `dotbare finit -u [URL]`).

### fstat

Display interactive git status menu. Toggle file stage/unstage status interactively.

- `-h, --help`: show the help message of `dotbare fstat` and exit.

### finit

Initialise dotbare with a bare repository or add -u [URL] flag for migrating existing dotfiles from
remote git repo to current system.

Note: do not use this command if you are using symlink/GNU stow and want to keep your current setup.

- Default: init the bare repository at \$DOTBARE_DIR.
- `-h, --help`: show the help message of `dotbare finit` and exit.
- `-u URL, --url URL`: migrate existing dotfiles from remote git repo to current system.
- `-s, --submodule`: if you have defined submodules in your bare repo (i.e. containes .gitmodule), add -s
  flag to clone submodules as well during migration.
- `-y, --yes`: acknowledge all actions that will be taken and skip confirmation.

### funtrack

Stop tracking the selected git files. It could also be used to temporarily stop tracking changes
for files and then later on resume tracking changes.

**Note: This command has severe limitations.**

By default, selected files are permanently untracked from git. Selected files will be
remove from index while keeping the file in your current system. However, when your other
machines pull down the changes, the untracked files will be deleted by git. This is a limitation
with git, to overcome this, after untracking the files, run `dotbare fbackup` to backup all files on
other machines before pulling down the changesto avoid any file loss.
After pulling new changes, move the deleted files from backup back to their original position.
More discussions [here](https://stackoverflow.com/questions/1274057/how-to-make-git-forget-about-a-file-that-was-tracked-but-is-now-in-gitignore).

`dotbare funtrack` does come with capabilities to temporarily untrack files, which will not
remove the untracked files from other system. However, this is **NOT** recommended
way to untrack files, explained [here](https://www.git-scm.com/docs/git-update-index#_notes).

- Default: list all tracked files and permanently untrack the selected files. Support multi selection.
- `-h, --help`: show the help message of `dotbare funtrack` and exit.
- `-t, --temp`: list all tracked files and temporarily untrack changes of the selected files. Support multi selection.
- `-r, --resume`: list all tracked files and resume tracking changes of the selected files.
- `-y, --yes`: acknowledge all actions that will be taken and skip confirmation.

### fupgrade

Update dotbare to the latest master. It will perform a `git pull --rebase --stat` and also
performing a auto-stash if needed (copied the method from OMZ). This is useful if you are not
using a plugin manager.

- `-h, --help`: show the help message of `dotbare fstat` and exit.

## Custom scripts

`dotbare` may not contains all the functionalities of your need, feel free to open up feature request. You could also
define your custom scripts under the scripts folder in `dotbare`. The `.gitignore` are configured to ignore everything except the scripts used by `dotbare` default,
so you can name your scripts any name you want. You can then track your custom scripts using `dotbare` to ensure the scripts are available in all of your machines.
Feel free to open pull request for your script, I'm happy to review and discuss for merging.

A dedicated wiki page will be setup to document API for helper functions.

## Tips and Tricks

- Most commands related to files support multi selection (default fzf setting is TAB for multi select).
- Most commands related to commits and branches doesn't support multi selection.
- Checkout fzf [doc](https://github.com/junegunn/fzf/blob/97a725fbd0e54cbc07e4d72661ea2bd2bb7c01c1/man/man1/fzf.1#L648)
  for more default fzf keybinds information.
- Alias dotbare to shorter words to type less.

  ```sh
  alias dots=dotbare
  ```

- Create keybinds for dotbare (e.g. bind ctrl-g to launch fedit and edit files).

  ```sh
  # zsh example
  bindkey -s '^g' "dotbare fedit"^j
  # bash example
  bind -x '"\C-g":"dotbare fedit"'
  ```

- `dotbare` has disabled the command `dotbare add --All` as it is a really dangerous command in the conext of `dotbare` as it will stage everything in your \$DOTBARE_TREE to the index.

  ```sh
  # Recommended ways
  dotbare fadd  # and then press alt-a to select all
  dotbare add -u # stage all modified file to index
  dotbare commit -am "message" # this also works, it will stage all modified files and then commit
  ```

- Add the value of `$DOTBARE_DIR` to global .gitignore to avoid any weird recursion problem if accidentally adding
  `$DOTBARE_DIR` to index, the value needs to be relative path to `$DOTBARE_TREE`

  ```sh
  # e.g. DOTBARE_DIR="$HOME/.cfg", DOTBARE_TREE="$HOME"
  echo ".cfg" >> $HOME/.gitignore
  # e.g. DOTBARE_DIR="$HOME/.config/.cfg" DOTBARE_TREE="$HOME"
  echo ".config/.cfg" >> $HOME/.gitignore
  # e.g. DOTBARE_DIR="$HOME/.config/.cfg" DOTBARE_TREE="$HOME/.config"
  echo ".cfg" >> $HOME/.gitignore
  ```

- Define a custom vim command to select dotfiles using [fzf.vim](https://github.com/junegunn/fzf.vim)

  ```vim
  command! Dots call fzf#run(fzf#wrap({
    \ 'source': 'dotbare ls-files --full-name --directory "${DOTBARE_TREE}" | awk -v home="$HOME/" "{print home \$0}"',
    \ 'sink': 'e',
    \ 'options': [ '--multi', '--preview', 'cat {}' ]
    \ }))
  ```

## Testing

`dotbare` is unit tested using [bats](https://github.com/bats-core/bats-core). A very weird mock tests are implemented using PATH override method.
This will be improved later and documented in a dedicated README in tests folder for more readability and extensibility.

Not all functions have 100% coverage and lots of user interaction cannot be effectively tested, please fire up issues if something went wrong.

I've added AWSCodeBuild to CI/CD to build the docker image. It is mainly for my personal practice. If you are interested in what's happening in AWSCodeBuild
you could checkout my cloudformation [template](https://github.com/kazhala/AWSCloudFormationStacks/blob/master/CICD_dotbare.yaml).

## Contributing

> A CONTRIBUTING.md is coming.

Please help me out by pointing out things that I could improve.
I've only been scripting for a few months and are still learning many new things every day. PR are always welcome
and please fire up issues if something went wrong.

Leave a star :)

## Coming up

- [x] Improve unit test with mocking
- [x] Support submodules during migration
- [ ] Command line completion for dotbare in zsh
- [x] Command line completion for dotbare in bash
- [ ] Command line completion for git commands
- [ ] Man page
- [x] Installation method

## Background

dotbare was initially part of my personal scripts, I had a hard time sharing those scripts
and as the number of scripts grows, I feel like is more appropriate to make a dedicated project
for it. I hope you find it useful and enjoy it, thanks!

## Credit

- credit to [forgit](https://github.com/wfxr/forgit) for inspiration.
- credit to [fzf](https://github.com/junegunn/fzf) for fzf.
- credit to [OMZ](https://github.com/ohmyzsh/ohmyzsh) for upgrading method.
- credit to [this](https://www.atlassian.com/git/tutorials/dotfiles) post for step by step guide of setting up git bare repo.
- credit to [this](https://www.youtube.com/watch?v=tBoLDpTWVOM&t=288s) video for introducing git bare repo.

## Demo

You could find some more gif demo [here](https://github.com/kazhala/dotbare/issues/1)
[![asciicast](https://asciinema.org/a/332231.svg)](https://asciinema.org/a/332231)
