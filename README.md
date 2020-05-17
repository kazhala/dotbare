# dotbare

[![Build Status](https://img.shields.io/travis/com/kazhala/dotbare/master?label=Travis&logo=Travis)](https://travis-ci.com/kazhala/dotbare)
![CI Status](https://github.com/kazhala/dotbare/workflows/CI/badge.svg)
![AWSCodeBuild](https://codebuild.ap-southeast-2.amazonaws.com/badges?uuid=eyJlbmNyeXB0ZWREYXRhIjoiYWVnOEdGbWxuMmpJdVF2S3RTOFdUeGhEZDZvVkZ1cnBtZGJjd0RuOFdxUWxGeG1zR2YycFcydFJZT25VV3NkZnNsRWJ4ZVNsZ0VxZnpOY3RFUGdMV0RNPSIsIml2UGFyYW1ldGVyU3BlYyI6IlNDNjNHTlkyS2ZmbE5lZGIiLCJtYXRlcmlhbFNldFNlcmlhbCI6MX0%3D&branch=master)
![License](https://img.shields.io/badge/license-MIT-green)

## Introduction

dotbare is a command line utility to help you manage your dotfiles. It wraps around git bare
repository and heavily utilise [fzf](https://github.com/junegunn/fzf) for better user expereince.
It is inspired by [forgit](https://github.com/wfxr/forgit), a git wrapper that utilise fzf for interactive expereince.
dotbare uses a different implementation approach and focuses on managing and interacting with your dotfiles.

Core characteristics:

- No symlink
- Easy setup/remove
- Customization
- Minimal dependency
- Easy migration
- Zero learning curve
- Manage dotfiles in any directory

You could find out how git bare repository could be used for managing dotfiles [here](https://www.atlassian.com/git/tutorials/dotfiles).

![Demo](https://user-images.githubusercontent.com/43941510/82142379-4a1e7500-987f-11ea-8d35-8588a413efd3.png)

## Why

It has always been a struggle for me to get started with managing dotfiles using version control,
as some other tools like "gnu stow" really scares me off with all the symlinks, until I found
out about using git bare repository for managing dotfiles, zero symlinks, minimal setup
required and you keep your dotfiles at the location they should be.

However, it has always lack some interactive expereince as it does not provide any auto
completion on git commands nor file paths by default. It is also a pain when migrating the setup over
to another system as you will have to manully resolve all the git checkout issues.

dotbare solves the above problems by providing a series of scripts starts with a prefix f
(e.g. dotbare fadd, dotbare flog etc) that will enable a interactive expereince by processing
all the git information from your bare repository and display it through fzf.
dotbare also comes with the ability to migrate easily to other systems with one single
command without having user to do any extra work.

## Getting started

### Install

1. Clone the repository (change ~/.dotbare to the location of your preference)

```sh
git clone https://github.com/kazhala/dotbare.git ~/.dotbare
```

2. Add dotbare to your PATH (below is only an example, put PATH into your appropriate shellrc file, `$HOME/.zshrc` etc)

```sh
echo "PATH=$PATH:$HOME/.dotbare" >> "$HOME"/.bashrc
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

> Treat dotbare as normal `git` commands. For interactive commands, check out [usage](#usage)

1. init git bare repository
   > Note: by default, `dotbare finit` will set up a bare repo in \$HOME/.cfg, to customize
   > location and various other settings, checkout [customization](#customization)

```sh
dotbare finit
```

2. add dotfiles you want to track

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

1. follow the steps in [install](#Install) to install dotbare
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

4. optionally you could alias config to dotbare so you keep your muscle memory

```sh
alias config=dotbare
```

#### Migrating dotbare to a new system

1. follow the steps in [install](#Install) to install dotbare
2. set env variable to let dotbare know where to init dotbare, backup etc.
   > Copy below to your cmd line and set them temporarily

```sh
export DOTBARE_DIR="$HOME/.cfg"
export DOTBARE_TREE="$HOME"
```

3. give dotbare your remote URL and let it handle the rest

```sh
dotbare finit -u https://github.com/kazhala/dotfiles.git
```

#### Migrating from gnu stow

I haven't used gnu stow but I would advise to stay with gnu stow if you are happy with it.
If you want to give dotbare a try, as long as your remote repository resembles the structure
of your home folder (reference what I mean in my [repo](https://github.com/kazhala/dotfiles.git))

```sh
dotbare finit -u [URL]
```

#### Test it in docker

If you know docker, I stronly suggest you give dotbare a try in docker, especially
when it comes to first time migration.

```sh
docker pull kazhala/dotbare:latest
docker container run -it --rm --name dotbare kazhala/dotbare:latest
```

![migration demo](https://user-images.githubusercontent.com/43941510/82143024-201b8180-9884-11ea-9aee-388414bbcf19.gif)

## Customization

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

Stage modified files, stage new file or directory interactivly through fzf.
By default `dotbare fadd` will list modified files and stage them on selection.

![fadd demo](https://user-images.githubusercontent.com/43941510/82143265-f5cac380-9885-11ea-9c0a-27d3fcc1866a.gif)

### freset

Reset/unstage file, reset HEAD back to certain commits and reset certain file back to certain
commits. Demo only shows unstaging files, detailed usage checkout `dotbare freset -h`.

![freset demo](https://user-images.githubusercontent.com/43941510/82147148-295f1b00-9891-11ea-9765-e5befd30cfd9.gif)

### fcheckout

Checkout files/commit/branch interactivly, default behavior is to checkout files back
to HEAD (Reset file changes back to HEAD).

![fcheckout demo](https://user-images.githubusercontent.com/43941510/82147244-d043b700-9891-11ea-8778-9fb9df6b441d.gif)

## Background

dotbare was initially part of my personal scripts, however as the number of scripts grows,
I feel like is more appropriate to make a dedicated project for it. I've just started
scripting for a few months, so there must be a lot of improvements that could be made, please
help me out by firing up issues and any PR is welcome.
