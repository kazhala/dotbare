# Changelog

Noteble changes are documentated in this file.

## dev

### Fixed

- unnecessary argument for zsh completion [#26](https://github.com/kazhala/dotbare/issues/26)

### Added

- common basic zsh widgets such as `dotbare fedit` [#24](https://github.com/kazhala/dotbare/issues/24)
- new zsh widget `dotbare-transform` (Not documented yet, will add to documendation in next release)
  - transform a generic `git` command to a `dotbare` command; e.g. `git log` -> `dotbare -g flog`
  - Bind this widget to keys of your choice (e.g. `ctrl-u`): `bindkey "^u" dotbare-transform`

## 1.3.1 (25/08/2020)

### Fixed

- dotbare with no args fails [#23](https://github.com/kazhala/dotbare/issues/23)
- some typos in help manual

## 1.3.0 (04/08/2020)

### Added

- hide preview window on small window (when \$COLUMNS less than 80)
  - If using default keybinds, use `alt-t` to re-open the preview
- verbose flag completion for bash
- `dotbare` can now be used as a generic fuzzy git tool, using `-g` or `--git flag`
  - Sort of like a replacement for `forgit`, bascially just dynamiclly switching
    `DOTBARE_DIR` and `DOTBARE_TREE` to the current git directory.
  - Seems kind of wierd to make `dotbare` also a fuzzy git client, but since it's literally
    like a few lines of changes, I figured why not ..
- options for `fgrep` to configure search behavior in fzf
  - `-c, --col`: pass in argument to specify which column to start searching in fzf (`dotbare fgrep --col 2`), by default `fgrep` starts the search from column 3, column 1 is the file name, column2 is the line number and starting from column 3 is the actual content.
  - `-f, --full`: configure the fzf search to include all columns, same as using `dotbare fgrep --col 1` which includes the file name, line number and the actual content.
- dedicated completion file to use for package installation

### CHANGED

- update the fzf header to make more sense, some wording issues

### Fixed

- bash completion raising unexpected git error

## 1.2.3 (17/07/2020)

### Added

- zsh completion for dotbare commands
- zsh completion for git commands
- bash completion for git commands
- fgrep: grep words within tracked dotfiles and edit them through EDITOR
  - More info is documented in wiki

### Changed

- adjusted how help messages are printed to reduce some calls

### Fixed

- bash completion awk panic on version 4.0+ bash on MacOS

## 1.2.2 (11/07/2020)

### Fixed

- dotbare crash when migrating a dotfile repo with over 100 files [#12](https://github.com/kazhala/dotbare/issues/12)
- dotbare fbackup crash when using cp command on symlink

## 1.2.1 (09/07/2020)

### Added

- dynamic preview function, detect bats, hightlight etc to provide syntax hightlighting when previewing files.
- custom preview ENV variable (DOTBARE_PREVIEW)
  - Note: has to be this format `export DOTBARE_PREVIEW='cat -n {}'`, the `{}` is
    used in preview functions to subsitute for the filepath.
- support for fancy diff tools like "diff-so-fancy" or "delta"
  - This is optional, only takes effect if installed and set as `git config core.pager`
  - Also configurable through DOTBARE_DIFF_PAGER, these are documentated in the README.

## 1.2.0 (01/07/2020)

### Added

- `dotbare` now accept verbose type of argument e.g. `dotbare fadd --file` `dotbare fcheckout --branch`.
  More information please refer to each commands help manual
- support for handling files with spaces
- improved unittest with mocking
- more reliable `dotbare fupgrade` behavior
- version flag for `dotbare`, `dotbare --version` or `dotbare -v`

### Changed

- `dotbare fcheckout -a` has now been renamed to `dotbare fcheckout -s` or `dotbare fcheckout --select`
- `dotbare fstash -f` has now been renamed to `dotbare fstash -s` or `dotbare fstash --select`
- `dotbare funtrack -s` has now been renamed to `dotbare funtrack -t` or `dotbare funtrack --temp`
- `dotbare funtrack -S` has now been renamed to `dotbare funtrack -r` or `dotbare funtrack --resume`
- dryrun information no longer will display if `-y` or `--yes` flag has been passed

### Removed

- removed `-a` flag of `dotbare freset`. It's not working as intended because I misunderstand it, the intended
  behavior is actually achieved by `dotbare fcheckout -a`, use `dotbare fcheckout -a` instead.
  (Edit: `dotbare fcheckout -a` is now `dotbare fcheckout -s` or `dotbare fcheckout --select`)

## 1.1.0 (28/06/2020)

### Added

- zsh plugin [#4](https://github.com/kazhala/dotbare/pull/4)
- bash plugin
- drop-in functionality [#6](https://github.com/kazhala/dotbare/pull/6)
  - User can now place custom fzf scripts into scripts folder
- bash completion capabilities [#7](https://github.com/kazhala/dotbare/pull/7)
- option to clone submodule [#8](https://github.com/kazhala/dotbare/issues/8)

### Fixed

- ambiguous argument error [#3](https://github.com/kazhala/dotbare/pull/3)

### Removed

- removed global .gitignore manipulation during migration, not needed. Added .gitignore tips to README and
  let user handle it

## 1.0.0 (20/05/2020)
