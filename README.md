# dotbare

[![Build Status](https://img.shields.io/travis/com/kazhala/dotbare/master?label=Travis&logo=Travis)](https://travis-ci.com/kazhala/dotbare)
![CI Status](https://github.com/kazhala/dotbare/workflows/CI/badge.svg)
![AWSCodeBuild](https://codebuild.ap-southeast-2.amazonaws.com/badges?uuid=eyJlbmNyeXB0ZWREYXRhIjoiYWVnOEdGbWxuMmpJdVF2S3RTOFdUeGhEZDZvVkZ1cnBtZGJjd0RuOFdxUWxGeG1zR2YycFcydFJZT25VV3NkZnNsRWJ4ZVNsZ0VxZnpOY3RFUGdMV0RNPSIsIml2UGFyYW1ldGVyU3BlYyI6IlNDNjNHTlkyS2ZmbE5lZGIiLCJtYXRlcmlhbFNldFNlcmlhbCI6MX0%3D&branch=master)
![Platform](https://img.shields.io/badge/platform-macos%20%7C%20linux-blue)
![License](https://img.shields.io/badge/license-MIT-green)

## Introduction

dotbare is a command line utility to help you manage your dotfiles. It wraps around git bare
repository and heavily utilise [fzf](https://github.com/junegunn/fzf) for better user experience.
It is inspired by [forgit](https://github.com/wfxr/forgit), a git wrapper that utilise fzf for interactive experience.
dotbare uses a different implementation approach and focuses on managing and interacting with your dotfiles.
Don't worry about migration if you have a symlink/GNU stow setup, you can easily integrate dotbare with them.

Pros:

- No symlink
- Simple setup/remove
- Customization
- Minimal dependency
- Easy migration
- Flat learning curve
- Manage dotfiles in any directory
- Integration with symlink/GNU stow setup

You could find out how git bare repository could be used for managing dotfiles [here](https://www.atlassian.com/git/tutorials/dotfiles).
Or a [video](https://www.youtube.com/watch?v=tBoLDpTWVOM&t=288s) explanation that helped me to get started. If you currently
is using symlink/GNU stow setup, checkout how to integrate dotbare with them [here](#migrating-from-a-generic-symlink-setup-or-gnu-stow).

![Demo](https://user-images.githubusercontent.com/43941510/82142379-4a1e7500-987f-11ea-8d35-8588a413efd3.png)

## Why

It has always been a struggle for me to get started with managing dotfiles using version control,
as some other tools like "GNU stow" really scares me off with all the symlinks, until I found
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

## Getting started

### Install

1. Clone the repository (change ~/.dotbare to the location of your preference)

   ```sh
   git clone https://github.com/kazhala/dotbare.git ~/.dotbare
   ```

2. Add dotbare to your PATH (below is only an example, put PATH into your appropriate shellrc file, `$HOME/.zshrc` etc)

   ```sh
   # echo "export PATH=$PATH:$HOME/.dotbare" >> "$HOME"/.bashrc
   # echo "export PATH=$PATH:$HOME/.dotbare" >> "$HOME"/.zshrc
   export PATH=$PATH:$HOME/.dotbare
   ```

3. Or you could create a alias which point to dotbare executable

   ```sh
   alias dotbare="$HOME/.dotbare/dotbare"
   ```

### Dependencies

- Required dependency
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

   Note: by default, `dotbare finit` will set up a bare repo in \$HOME/.cfg, to customize
   location and various other settings, checkout [customization](#customization)

   ```sh
   dotbare finit
   ```

2. add dotfiles you want to track

   ```sh
   # Treat dotbare as normal `git` commands.

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

4. remove the original alias and use dotbare the same except with _super power_

5. optionally you could alias config to dotbare so you keep your muscle memory

   ```sh
   alias config=dotbare
   ```

#### Migrating from a generic symlink setup or GNU stow

> If you already have a symlink setup either custom or with GNU stow.
> You could either integrate dotbare with your current set up or
> do a complete migration.

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

I haven't used GNU stow or any symlink setup, but I do recommand keep your current setup
and integrate with dotbare. If you are really happy with `dotbare`, as long as your remote
repository resembles the structure of your home holder (reference what I mean in my [repo](https://github.com/kazhala/dotfiles.git)),
simply run the command below.

```sh
# Disclaimer: I have not test this with GNU stow, migrate in this way with caution.
# I recommend you test this migration in docker, see #Test-it-in-docker
dotbare finit -u [URL]
```

#### Migrating dotbare to a new system

1. follow the steps in [install](#install) to install dotbare
2. Optionally set env variable to customize dotbare location. Checkout [customization](#customization)

   ```sh
   export DOTBARE_DIR="$HOME/.cfg"
   export DOTBARE_TREE="$HOME"
   ```

3. give dotbare your remote URL and let it handle the rest

   ```sh
   dotbare finit -u https://github.com/kazhala/dotfiles.git
   ```

#### Test it in docker

I strongly suggest you give dotbare a try in docker, especially
when it comes to first time migration.

```sh
docker pull kazhala/dotbare:latest
docker container run -it --rm --name dotbare kazhala/dotbare:latest
```

![migration demo](https://user-images.githubusercontent.com/43941510/82143024-201b8180-9884-11ea-9aee-388414bbcf19.gif)

## Customization

dotbare could be customized through modification of env variables.

Note: customization of fzf is not covered here, you should checkout their [wiki](https://github.com/junegunn/fzf/wiki).

### DOTBARE_DIR

This is the location of the bare repository, dotbare will look for this directory
and query git information or it will create this directory when initializing dotbare.
Change this to location or rename the directory to your liking.

If you are using symlink/GNU stow setup, set this variable point to your .git folder
in your working directory of your dotfiles.

```sh
# Default
DOTBARE_DIR="$HOME/.cfg"
```

### DOTBARE_TREE

This is the working tree for the git bare repository, meaning this is where the version
control will take place. I don't recommend changing this one unless **ALL** of your config
file is in something like \$XDG_CONFIG_HOME or if you are using symlink/GNU stow setup,
set this variable to point to the folder contains your actual dotfiles.

```sh
# Default
DOTBARE_TREE="$HOME"
```

### DOTBARE_BACKUP

This variable is used to determine where to store the backup of your files. It is used
mainly by `dotbare fbackup` which will back up all of your tracked dotfiles into this location.
It is also used by `dotbare finit -u [URL]`, when there is checkout conflict, dotbare will
automatically backup conflicted files to this location. You probably shouldn't change this
location.

```sh
# Default
# 2. If XDG_DATA_HOME exist, use XDG_DATA_HOME/dotbare
# 3. otherwise, use $HOME/.local/share/dotbare
DOTBARE_BACKUP="${XDG_DATA_HOME:-$HOME/.local/share}/dotbare"
```

### EDITOR

This is probably already set in your ENV. dotbare uses this variable to determine
which editor to use when running `dotbare fedit`.

```sh
# Default
EDITOR="vim"
```

### DOTBARE_KEY

This variable set default keybinds for fzf in dotbare. You could checkout a list of keybinds
to set [here](https://github.com/junegunn/fzf/blob/97a725fbd0e54cbc07e4d72661ea2bd2bb7c01c1/man/man1/fzf.1#L648).

```sh
# Default
DOTBARE_KEY="
  --bind=alt-a:toggle-all       # toggle all selection
  --bind=alt-j:jump             # label jump mode, sort of like easymotion
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
# You could also take a look at my fzf config
# https://github.com/kazhala/dotfiles/blob/5507a2dea4f4a420e6d65a423abaa247521f89a8/.zshrc#L56
```

## Commands

> dotbare doesn't have a man page yet, will come later, for help, type dotbare [COMMAND] -h

### Checkout all available scripts and their help manual

```sh
# run dotbare without any arguments
dotbare
# or checkout help for dotbare
dotbare -h
dotbare help
# for normal git help
dotbare --help
```

### fedit

List all tracked dotfiles and edit the selected file through \$EDITOR, it also support
edit commits through interactive rebase.

![fedit](https://user-images.githubusercontent.com/43941510/82144921-edc15280-988a-11ea-81c6-7fc1a845afd5.gif)

### fadd

Stage modified files, stage new file or directory interactive by through fzf.
By default `dotbare fadd` will list modified files and stage them on selection.

![fadd demo](https://user-images.githubusercontent.com/43941510/82143265-f5cac380-9885-11ea-9c0a-27d3fcc1866a.gif)

### freset

Reset/unstage file, reset HEAD back to certain commits and reset certain file back to certain
commits. Demo only shows unstaging files, detailed usage checkout `dotbare freset -h`.

![freset demo](https://user-images.githubusercontent.com/43941510/82147148-295f1b00-9891-11ea-9765-e5befd30cfd9.gif)

### fcheckout

Checkout files/commit/branch interactively, default behavior is to checkout files back
to HEAD (Reset file changes back to HEAD).

![fcheckout demo](https://user-images.githubusercontent.com/43941510/82147244-d043b700-9891-11ea-8778-9fb9df6b441d.gif)

### flog

Interactive log viewer that will prompt you with a menu after selecting a commit. Allows
edit, reset, revert and checkout the selected commits.

![flog demo](https://user-images.githubusercontent.com/43941510/82210660-d057bb80-9952-11ea-81fb-564cf8d4b143.gif)

### fstash

View and manage your stash interactively. Pass `-p` flag for `pop`, otherwise by default,
`stash apply` is used under the hood. Pass `-d` flag for deleting a stash.

![fstash demo](https://user-images.githubusercontent.com/43941510/82211351-119c9b00-9954-11ea-9579-66cd83b9ca8a.gif)

### fbackup

Backup all of the tracked dotfiles to DOTBARE_BACKUP directory. This is used also by
`dotbare finit -u [URL]` for backing up conflicted checkout files.

![fbackup demo](https://user-images.githubusercontent.com/43941510/82210006-9a660780-9951-11ea-8343-a6a8ca55138c.gif)

### fstat

Interactively toggle stage/unstage of files. This is less used compare to `dotbare fadd`,
it might get deprecated.

![fstat demo](https://user-images.githubusercontent.com/43941510/82325049-f0a07c80-9a1d-11ea-9d3f-e4de5987bedb.gif)

### finit

Initialise dotbare with a bare repository or add -u [URL] flag for migrating current
dotfiles to a new system.

Note: do not use this command if you are using symlink/GNU stow.

### funtrack

Stop tracking the selected git files. It could also be used to temporarily stop tracking changes
for files and then later on resume tracking changes.

**Note: This command has severe limitations.**

By default, selected files are permanently untracked starting from next commit.
It will not remove it from history. And if your other system pull down the new commit,
the untracked files on the other system will actually get removed by git. This is a limitation
with git, to overcome this, after untracking the files, run `dotbare fbackup` to backup the files.
After pulling new changes, move the deleted files from backup back to their original position.
More discussions [here](https://stackoverflow.com/questions/1274057/how-to-make-git-forget-about-a-file-that-was-tracked-but-is-now-in-gitignore).

`dotbare funtrack` does come with capabilities to temporarily untrack files, which will not
actually remove the untracked files from other system. However, this is **NOT** recommanded
way to untrack files, explained [here](https://www.git-scm.com/docs/git-update-index#_notes).

### fupgrade

Update dotbare to the latest version in master. It basically just pull down changes from master,
except you don't have to cd into dotbare directory, you can run this command any where.

## Tips and Tricks

- Most commands related to files support multi selection (default fzf setting is TAB)
- Most commands related to commits and branches doesn't support multi selection
- Checkout [this](https://github.com/junegunn/fzf/blob/97a725fbd0e54cbc07e4d72661ea2bd2bb7c01c1/man/man1/fzf.1#L648)
  for more default fzf keybinds information.
- Alias dotbare to shorter words to type less

  ```sh
  alias db=dotbare
  ```

- Create keybinds for dotbare (e.g. bind ctrl-g to launch fedit and edit files)

  ```sh
  # zsh example
  bindkey -s '^g' "dotbare fedit"^j
  # bash example
  bind -x '"\C-g":"dotbare fedit"'
  ```

## Background

dotbare was initially part of my personal scripts, however as the number of scripts grows,
I feel like is more appropriate to make a dedicated project for it. I've just started
scripting for a few months, so there must be a lot of improvements that could be made, please
help me out by firing up issues and any PR is welcome.

## Testing

dotbare is unit tested on a _best effort_ due the nature of fzf which require human input.
Mock test are coming if I could make it work.

Some functions may have a lot more coverage than others, so please fire up issues if something went wrong.
dotbare uses [bats](https://github.com/bats-core/bats-core) to test individual functions.

I've added AWSCodeBuild to CI/CD just for my personal practice, if you are interested in what's happening in AWSCodeBuild
you could checkout my cloudformation [template](https://github.com/kazhala/AWSCloudFormationStacks/blob/master/CICD_dotbare.yaml).

## Contributing

Please help me out by pointing out things that I could improve, as I said, I've only been
scripting for a few months and are still adapting many new things every day. PR are always welcome
and please fire up issues if something went wrong.

Leave a star if possible :)

## Coming up

- [ ] Improve unit test with mocking
- [ ] Command line completion for dotbare commands
- [ ] Man page
- [ ] Command line completion for git commands?
- [ ] Installation method

## Credit

- credit to [forgit](https://github.com/wfxr/forgit) for inspiration
- credit to [fzf](https://github.com/junegunn/fzf)
- credit to [this](https://www.atlassian.com/git/tutorials/dotfiles) post
- credit to [this](https://www.youtube.com/watch?v=tBoLDpTWVOM&t=288s) video
