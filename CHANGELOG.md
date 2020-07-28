# Changelog

Noteble changes are documentated in this file.

## dev

### Added

- hide preview window on small window (when \$COLUMNS less than 80)
  - If using default keybinds, use `alt-t` to re-open the preview
- verbose flag completion for bash

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
