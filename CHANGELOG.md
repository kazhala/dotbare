# Changelog

Noteble changes are documentated in this file.

## 1.0.0

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
- Removed `-a` flag of `dotbare freset`. It's not working as intended because I misunderstand git, the intended
  behavior is actually achieved by `dotbare fcheckout -a`, use `dotbare fcheckout -a` instead.
