# Contributing to dotbare

Thanks for stopping by! Happy to see you willing to improve `dotbare`.

`dotbare` has lots of improvement that could be made ranging from code efficiency,
functionality and possibility some best practice for safer code or portability.

## Efficiency

If you find some weird implementations that could be shorten or done better, feel free
to make a PR for it, I'm willing to learn how to improve and done better. For example,
before v1.2.3, the help message from `dotbare` were actually printed through multiple
invocations of `echo -e` which were very very unnecessary.

```sh
# Before
echo -e "usage: ...\n"
echo -e "foo boo\n"
echo -e "Optional arguments: ...\n"

# After
echo -e "usage: ...

foo boo

Optional arguments: ..."
```

## Functionality

`dotbare` was originally implemented to fill my own need with some extra that I think
others may use. There are two ways to improve functionality, adding new "f" scripts
or maybe adding extra flags for existing scripts.

### New scripts

Checkout [wiki](https://github.com/kazhala/dotbare/wiki/Custom-Scripts) about how
to create custom scripts as well as how to use the API from `dotbare` helper methods.

Feel free to open pull request for your script, I'm happy to review and discuss for merging.

Just make sure that they are indeed a separate category than all of the existing "f" scripts,
otherwise you may want to add extra flags to existing "f" scripts.

Before you could commit your custom scripts to the fork of `dotbare`, you need to add an
entry to `.gitignore` because it's written to ignore everything in the scripts folder.

```sh
# ignore everything in scripts folder except the !scripts/fadd etc
scripts/*
!scripts/fadd
!scripts/fbackup
....
!scripts/your new script
```

### Adding arguments

Existing "f" scripts could be extended through adding flags. For example maybe `dotbare fgrep`
could take a `--dryrun` option, instead of populating result in fzf, just print the result
to terminal.

After adding the new flag, don't forget to add the flag to `usage` function as well as `dotbare.plugin.zsh`
completion definitions.

## Helper functions

When making changes or extending helper functions like `git_query.sh`, make sure the changes are
backward compatible.

## Testing

There is no requirements for the changes to be unit tested, bash unit test is nasty.

Just make sure you have thoroughly tested manually and pass shellcheck.

If you are interested, checkout [here](https://github.com/kazhala/dotbare/blob/master/tests/README.md) to see how the unit test are implemented and
use current unit tests as reference.

## Finally

Thanks for your interest in improving `dotbare`!
