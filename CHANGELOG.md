# Changelog

Noteble changes are documentated in this file.

## dev

### Added

- dynamic preview (detect bats, hightlight etc)
- Custom preview ENV (DOTBARE_PREVIEW)
  Note: has to be this format `export DOTBARE_PREVIEW='cat {}'`, the `{}` is
  used for fzf to subsitute for the filepath.

## 1.2.0 (01/07/2020)

### Added

- `dotbare` now accept verbose type of argument e.g. `dotbare fadd --file` `dotbare fcheckout --branch`.
  More information please refer to each commands help manual
- Added support for handling files with spaces
- Improved unittest with mocking
- A more reliable `dotbare fupgrade` behavior
- Added version flag for `dotbare`, `dotbare --version` or `dotbare -v`

### Changed

- `dotbare fcheckout -a` has now been renamed to `dotbare fcheckout -s` or `dotbare fcheckout --select`
- `dotbare fstash -f` has now been renamed to `dotbare fstash -s` or `dotbare fstash --select`
- `dotbare funtrack -s` has now been renamed to `dotbare funtrack -t` or `dotbare funtrack --temp`
- `dotbare funtrack -S` has now been renamed to `dotbare funtrack -r` or `dotbare funtrack --resume`
- dryrun information no longer will display if `-y` or `--yes` flag has been passed

### Removed

- Removed `-a` flag of `dotbare freset`. It's not working as intended because I misunderstand it, the intended
  behavior is actually achieved by `dotbare fcheckout -a`, use `dotbare fcheckout -a` instead.
  (Edit: `dotbare fcheckout -a` is now `dotbare fcheckout -s` or `dotbare fcheckout --select`)

## 1.1.0 (28/06/2020)

### Added

- Added zsh plugin [#4](https://github.com/kazhala/dotbare/pull/4)
- Added bash plugin
- Added drop-in functionality [#6](https://github.com/kazhala/dotbare/pull/6)
  - User can now place custom fzf scripts into scripts folder
- Added bash completion capabilities [#7](https://github.com/kazhala/dotbare/pull/7)
- Added option to clone submodule [#8](https://github.com/kazhala/dotbare/issues/8)

### Fixed

- Fixed ambiguous argument error [#3](https://github.com/kazhala/dotbare/pull/3)

### Removed

- Removed global .gitignore manipulation during migration, not needed. Added .gitignore tips to README and
  let user handle it

## 1.0.0 (20/05/2020)
