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
- 1 step migration
- Zero learning curve
- Manage dotfiles in any directory

You could find out how git bare repository could be used for managing dotfiles [here](https://www.atlassian.com/git/tutorials/dotfiles).

![Demo](../assets/demo.gif?raw=true)

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

1. Clone the repository
   > Note: change ~/.dotbare to the location of your preference

```sh
git clone https://github.com/kazhala/dotbare.git ~/.dotbare
```

2. Add dotbare to your PATH (below is only an example, put PATH into your appropriate shellrc file)

   > Note: change the \$HOME/.dotbare to your install location

```sh
echo "PATH=$PATH:$HOME/.dotbare" >> "$HOME"/.bashrc
```

### Dependencies

- Required dependency
  - [fzf](https://github.com/junegunn/fzf)
  - bash(You don't need to run bash, but dotbare does require you have bash in your system)
- Optional dependency
  - [fd](https://github.com/sharkdp/fd) (Faster local file search, if you have `fd`, dotbare bare will use fd instead of `find` when finding local files)
  - [tree](https://linux.die.net/man/1/tree) (Will provide a directory tree view when finding directory)
    ```sh
    # if you are on macos
    brew install tree
    ```

### Setup

> Treat dotbare as normal `git` commands

> For interactive commands, check out [usage](#usage)

1. init git bare repository

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

## Usage

> dotbare doesn't have a man page yet, will come later, for help, type dotbare [COMMANDS] -h

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

### dotbare fadd

interactivly stage and view changes for modified files

## Background

dotbare was initially part of my personal scripts, however as the number of scripts grows,
I feel like is more appropriate to make a dedicated project for it. I've just started
scripting for a few months, so there must be a lot of improvements that could be made, please
help me out by firing up issues and any PR is welcome.
