# dotbare

![CI Status](https://github.com/kazhala/dotbare/workflows/CI/badge.svg)
![AWSCodeBuild](https://codebuild.ap-southeast-2.amazonaws.com/badges?uuid=eyJlbmNyeXB0ZWREYXRhIjoiVVo4eUt6T0JGSFU1M1plVml0Y1dOWkJnaTV0eWZNNm5uY043Z3MwaUY2aUhaTHllQklhaVFiWmxIcTNVc0ZFRFhwbFdpZ3dsb3RMZFU0aDk3S1FUQUpRPSIsIml2UGFyYW1ldGVyU3BlYyI6ImVUdjloSlNTa3NyTUJVemIiLCJtYXRlcmlhbFNldFNlcmlhbCI6MX0%3D&branch=master)
![Platform](https://img.shields.io/badge/platform-macos%20%7C%20linux-blue)
![License](https://img.shields.io/badge/license-MIT-green)

## Introduction

`dotbare` is a command line utility to help manage dotfiles and or as a generic fuzzy git client. As a dotfile management tool,
it wraps around git bare repository, query git information from it and display them through [fzf](https://github.com/junegunn/fzf) for an
interactive experience. It is originally inspired by [forgit](https://github.com/wfxr/forgit), a git wrapper using fzf.
`dotbare` uses a different implementation approach and focuses on managing and interacting with system dotfiles. Because
of the flexible implementation of `dotbare`, it can easily integrate with symlink/GNU stow setup or even as a generic
fuzzy git client to use in any git repository.

As a generic fuzzy git client (using `--git` flag), `dotbare` dynamically determine the top level `.git` folder and process git information
and perform git operation in the current working tree.

You could find out how git bare repository could be used for managing dotfiles [here](https://www.atlassian.com/git/tutorials/dotfiles).
Or a [video](https://www.youtube.com/watch?v=tBoLDpTWVOM&t=288s) explanation that helped me to get started. If you are currently
using a symlink/GNU stow setup, checkout how to integrate `dotbare` with them [here](#migrating-from-a-generic-symlink-setup-or-gnu-stow).

Select and edit dotfiles.
![fedit](https://user-images.githubusercontent.com/43941510/87669391-37f28180-c7b1-11ea-907d-3b26f363a279.png)
Stage and unstage dotfiles.
![fstat](https://user-images.githubusercontent.com/43941510/87669408-43de4380-c7b1-11ea-8a31-fc702eb69804.png)
Interactive log viewer.
![flog](https://user-images.githubusercontent.com/43941510/87669399-3e80f900-c7b1-11ea-9bfa-5db31c4307c3.png)
For more capabilities and commands, checkout [wiki](https://github.com/kazhala/dotbare/wiki/Commands).

## Why

It has always been a struggle for me to get started with managing dotfiles using version control,
as tools like "GNU stow" really scares me off with all the symlinks, until I found
out about using git bare repository for managing dotfiles, zero symlinks, minimal setup
required while keeping dotfiles at the location they should be.

However, it has always lack some interactive experience as it does not provide any auto
completion on git commands nor file paths by default. It is also a pain when migrating the setup over
to another system as you will have to manually resolve all the git checkout issues.

`dotbare` solves the above problems by providing a series of scripts starts with a prefix f
(e.g. `dotbare fadd`, `dotbare flog` etc) that will enable a interactive experience by processing
all the git information and display it through fzf. In addition, `dotbare` also comes with command line completion
that you could choose to either to complete `git` commands or `dotbare` commands.
`dotbare` also comes with the ability to integrate with GNU stow or any symlink set up as long as you are using git.
It is easy to migrate to any system with minimal set up required. In addition, with a simple flag `--git`, you can
now also use `dotbare` as a generic fuzzy git client to manage any git repository.

## Install

### zsh

`dotbare` should work with any zsh plugin manager, below is only demonstration. Checkout [wiki](https://github.com/kazhala/dotbare/wiki/Completion#zsh)
about how to enable completion for zsh.

#### zinit

```sh
zinit light kazhala/dotbare
```

#### oh-my-zsh

- Clone the repository in to [oh-my-zsh](https://github.com/ohmyzsh/ohmyzsh) plugins directory.

  ```sh
  git clone https://github.com/kazhala/dotbare.git $HOME/.oh-my-zsh/custom/plugins/dotbare
  ```

- Activate the plugin in `~/.zshrc`.

  ```zsh
  plugins=( [plugins...] dotbare [plugins...] )
  ```

#### Antigen

```sh
antigen bundle kazhala/dotbare
```

#### Manual

- Clone the repository (change ~/.dotbare to the location of your preference).

  ```sh
  git clone https://github.com/kazhala/dotbare.git ~/.dotbare
  ```

- Put below into `.zshrc`.

  ```sh
  source ~/.dotbare/dotbare.plugin.zsh
  ```

### bash

`dotbare` comes with a `dotbare.plugin.bash` which contains the command line completion
function for both `git` and `dotbare`, checkout [wiki](https://github.com/kazhala/dotbare/wiki/Completion#bash)
about how to enable it.

- Clone the repository (change ~/.dotbare to the location of your preference).

  ```sh
  git clone https://github.com/kazhala/dotbare.git ~/.dotbare
  ```

- Put below into `.bashrc` or `.bash_profile`.

  ```sh
  source ~/.dotbare/dotbare.plugin.bash
  ```

### others

1. Clone the repository (change ~/.dotbare to the location of your preference).

   ```sh
   git clone https://github.com/kazhala/dotbare.git ~/.dotbare
   ```

2. Add `dotbare` to your PATH.

   ```sh
   # This is only an example command for posix shell
   # If you are on fish, use the fish way to add dotbare to your path
   export PATH=$PATH:$HOME/.dotbare
   ```

   Or you could create a alias which point to dotbare executable.

   ```sh
   alias dotbare="$HOME/.dotbare/dotbare"
   ```

## Getting started

### Dependencies

You will need git on the system for obvious reasons..and because `dotbare` is written in bash,
it will require you to have bash in the system (You don't need to run bash, just need to be in the system).

#### Required dependency

- [fzf](https://github.com/junegunn/fzf)

#### Optional dependency

- [tree](https://linux.die.net/man/1/tree) (Provide a directory tree view when finding directory)

  ```sh
  # if you are on macos
  brew install tree
  ```

- [bat](https://github.com/sharkdp/bat) or [highlight](http://www.andre-simon.de/doku/highlight/en/highlight.php) or [coderay](https://github.com/rubychan/coderay)
  or [rougify](https://github.com/rouge-ruby/rouge) (Syntax highlighting when previewing files, otherwise cat will be used)
- [delta](https://github.com/dandavison/delta) or [diff-so-fancy](https://github.com/so-fancy/diff-so-fancy)
  or any diff tools of your choice (Fancy git diff preview like in the screen shot)

### Setup

1. init git bare repository.

   Note: by default, `dotbare finit` will set up a bare repository in \$HOME/.cfg, to customize
   location and various other settings, checkout [customization](#customization)

   ```sh
   dotbare finit
   ```

2. add dotfiles you want to track.

   Treat `dotbare` as normal `git` commands.

   ```sh
   dotbare fadd -f
   # or
   dotbare add [FILENAME]

   # add entire repository like .config directory
   dotbare fadd -d
   # or
   dotbare add [DIRECTORY]
   ```

3. commit changes and push to remote.

   ```sh
   dotbare commit -m "First commit"
   dotbare remote add origin [URL]
   dotbare push -u origin master
   ```

### Migration

#### Migrating from normal git bare repository

1. follow the steps in [install](#install) to install `dotbare`.
2. check your current alias of git bare reference.

   ```sh
   # Below is an example alias, check yours for reference
   alias config=/usr/bin/git --git-dir=$HOME/.cfg --work-tree=$HOME
   ```

3. set env variable for `dotbare`.

   ```sh
   export DOTBARE_DIR="$HOME/.cfg"
   export DOTBARE_TREE="$HOME"
   ```

4. remove the original alias and use `dotbare`.

5. optionally you could alias `config` to `dotbare` so you keep your muscle memory.

   ```sh
   alias config=dotbare
   ```

#### Migrating from a generic symlink setup or GNU stow

##### Keep your current setup but integrate dotbare

1. follow the steps in [install](#install) to install `dotbare`.
2. set environment variable so that `dotbare` knows where to look for git information.

   ```sh
   # e.g. I have all my dotfiles stored in folder $HOME/.myworld and symlinks all of them to appropriate location.
   # export DOTBARE_DIR="$HOME/.myworld/.git"
   # export DOTBARE_TREE="$HOME/.myworld"
   export DOTBARE_DIR=<Path to your .git location>
   export DOTBARE_TREE=<Path to directory which contains all your dotfiles>
   ```

3. Run `dotbare` anywhere in your system.

Note: with this method, you do not run `dotbare finit -u [URL]` when migrating to new system,
you will do your normal migration steps and then do the above steps.

##### Complete migration

While bare method is great and easy, I recommend keeping your current symlink/GNU stow setup and integrate it with `dotbare` instead of a migration.
If you are really happy with `dotbare`, as long as your remote repository resembles the structure of your home holder
(reference what I mean in my [repo](https://github.com/kazhala/dotfiles.git)), simply run the command below.

**Disclaimer**: I have not done nearly enough test on this as I don't personally use symlink/GNU stow setup, migrate this way with caution.
I recommend you test this migration in docker, see [Test-it-in-docker](#test-it-in-docker).

```sh
# dotbare will replace all symlinks with the original file and a bare repository will be created at $DOTBARE_DIR
dotbare finit -u [URL]
```

#### Migrating dotbare to a new system

1. follow the steps in [install](#install) to install `dotbare`.
2. Optionally set env variable to customize `dotbare` location (checkout [customization](#customization)).

   ```sh
   export DOTBARE_DIR="$HOME/.cfg"
   export DOTBARE_TREE="$HOME"
   ```

3. give `dotbare` your remote URL and let it handle the rest.

   ```sh
   dotbare finit -u https://github.com/kazhala/dotfiles.git
   ```

#### Test it in docker

When you are about to do migrations, I strongly suggest you give the migration a try in docker first.
The `dotbare` image is based on alpine linux.

```sh
docker pull kazhala/dotbare:latest
docker container run -it --rm --name dotbare kazhala/dotbare:latest
```

![migration demo](https://user-images.githubusercontent.com/43941510/82392054-3ee96600-9a86-11ea-9ea9-158452c62d06.gif)

## Customization

`dotbare` could be customized through modification of env variables.

Note: customization of fzf is not covered here, checkout their [wiki](https://github.com/junegunn/fzf/wiki).

### DOTBARE_DIR

This is the location of the bare repository, `dotbare` will look for this directory
and query git information or it will create this directory when initializing `dotbare`.
Change this to location or rename the directory to your liking.

If you are using symlink/GNU stow setup, set this variable point to the .git folder
within your dotfile directory.

```sh
# Default value
export DOTBARE_DIR="$HOME/.cfg"
```

### DOTBARE_TREE

This is the working tree for the git bare repository, meaning this is where the version
control will take place. I don't recommend changing this one unless **ALL** of your config
file is in something like \$XDG_CONFIG_HOME. If you are using symlink/GNU stow setup,
set this variable to point to the folder containing all of your dotfiles.

```sh
# Default value
export DOTBARE_TREE="$HOME"
```

### DOTBARE_BACKUP

This variable is used to determine where to store the backup of your files. It is used
mainly by `dotbare fbackup` which will back up all of your tracked dotfiles into this location.
It is also used by `dotbare finit -u [URL]`, when there is checkout conflict, `dotbare` will
automatically backup conflicted files to this location.

```sh
# Default value
export DOTBARE_BACKUP="${XDG_DATA_HOME:-$HOME/.local/share}/dotbare"
```

### EDITOR

This is probably already set in your ENV. `dotbare` uses this variable to determine
which editor to use when running `dotbare fedit`.

```sh
# Default value
export EDITOR="vim"
```

### DOTBARE_KEY

This variable set default keybinds for fzf in `dotbare`. You could checkout a list of keybinds
to set [here](https://github.com/junegunn/fzf/blob/97a725fbd0e54cbc07e4d72661ea2bd2bb7c01c1/man/man1/fzf.1#L648).

```sh
# Default value
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
# By default this variable is not set
# More settings checkout fzf man page and their wiki
# Example: if you want your preview window for dotbare to be bigger
export DOTBARE_FZF_DEFAULT_OPTS="--preview-window=right:65%"
```

### DOTBARE_PREVIEW

This variable determines the preview command for file previews. By default, the preview is automatically determined
using fall back (bat -> highlight -> coderay -> rougify -> cat). Set this variable to control the preview command if
you have a specific preference or if you want extra flags/settings. Reference [here](https://github.com/kazhala/dotbare/blob/master/helper/preview.sh).

```sh
# By default this value is not set, dotbare uses a fall back method to determine which command to use.
# Make sure to have "{}" included when customizing it, the preview script substitute "{}" for actual filename.
# Example: enable line number for cat command
export DOTBARE_PREVIEW="cat -n {}"
```

### DOTBARE_DIFF_PAGER

This variable controls the diff output pager in previews like `dotbare flog`, `dotbare fadd` etc. It will read the value
of `git config core.pager` to determine the pager to use. If you have a specific preference for `dotbare` or have not set
the global pager in git config, you could use this variable to customize the diff preview.

```sh
# By default this value uses fall back (git config core.pager -> cat)
export DOTBARE_DIFF_PAGER="delta --diff-so-fancy --line-numbers"
```

## Usage

All usage and commands are documented in **[wiki](https://github.com/kazhala/dotbare/wiki/Commands)**.

- [Commands](https://github.com/kazhala/dotbare/wiki/Commands)
- [Completion](https://github.com/kazhala/dotbare/wiki/Completion)
- [Custom Scripts and API](https://github.com/kazhala/dotbare/wiki/Custom-Scripts)
- [Tips and Tricks](https://github.com/kazhala/dotbare/wiki/Tips-and-Tricks)

## Changes

Latest changes are documented in [CHANGELOG](https://github.com/kazhala/dotbare/blob/master/CHANGELOG.md).

## Testing

`dotbare` is unit tested using [bats](https://github.com/bats-core/bats-core). Mock tests are implemented using PATH override method.
This is documented [here](https://github.com/kazhala/dotbare/blob/master/tests/README.md) for better readability and extensibility.

Not all functions have 100% coverage and lots of user interaction cannot be effectively tested, please fire up issues if something went wrong.

I've added AWSCodeBuild to CI/CD to build the docker image. It is mainly for my personal practice. If you are interested in what's happening in AWSCodeBuild
you could checkout my cloudformation [template](https://github.com/kazhala/AWSCloudFormationStacks/blob/master/CICD_dotbare.yaml).

## Contributing

Checkout out [CONTRIBUTING.md](https://github.com/kazhala/dotbare/blob/master/CONTRIBUTING.md) to see how you could contribute to `dotbare`. PRs are
welcome and I'm happy to improve/extend `dotbare`'s functionality.

Don't forget to leave a star :)

## Background

`dotbare` was initially part of my personal scripts, I had a hard time sharing those scripts
and as the number of scripts grows, I feel like is more appropriate to make a dedicated project
for it. I hope you find it useful and enjoy it, thanks!

## Credit

- credit to [forgit](https://github.com/wfxr/forgit) for inspiration.
- credit to [fzf](https://github.com/junegunn/fzf) for fzf and the preview script from fzf.vim.
- credit to [OMZ](https://github.com/ohmyzsh/ohmyzsh) for upgrading method.
- credit to [this](https://www.atlassian.com/git/tutorials/dotfiles) post for step by step guide of setting up git bare repo.
- credit to [this](https://www.youtube.com/watch?v=tBoLDpTWVOM&t=288s) video for introducing git bare repo.

## Demo

You could find some more demo [here](https://github.com/kazhala/dotbare/issues/1)
[![asciicast](https://asciinema.org/a/332231.svg)](https://asciinema.org/a/332231)
