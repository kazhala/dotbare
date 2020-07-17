# Testing dotbare

`dotbare` is unit tested using the [bats](https://github.com/bats-core/bats-core) testing
frame work. Interaction with `fzf` are mocked using the PATH override method.

Refer to bats homepage for usage of bats and their test basics.

## Mocking

One of the challenge when testing `dotbare` is interaction with `fzf`, `git` and some
other shell functions. `fzf` is the most pain because it does require human interaction.

Using the PATH override method, at the very least, we can assert if fzf is invoked with
right arguments.

### How it works

There is a executable file called fzf in the test folder as well as git, tree etc. Before
running test that requires fzf invokations, append the test folder path to the front of
PATH variable.

```sh
#!/usr/bin/env bats

stage_selected_dir() {
  export PATH="${BATS_TEST_DIRNAME}:$PATH"
  bash "${BATS_TEST_DIRNAME}"/../dotbare fadd --dir
}
```

This way the executable will be executed by `dotbare` instead of the real `fzf`.

### The fzf executable

I'm sure there might be more elegant way of doing this, if you have suggestions please
help me improve it. Currently for better readability in all the bats test file, I added
bunch of `if` statement in the `fzf` executable to assert if `fzf` is being called
correctly.

```sh
if [[ "$*" =~ '--multi --preview ' ]] && [[ "$*" =~ "tree -L 1 -C --dirsfirst {}" ]]; then
  # dotbare fadd --dir -- "./fadd.bats" @test "fadd stage selected dir"
  echo "fadd_stage_dir"
fi
```

When the executable is being called, it will check for it's arguments and echo out a shorter
word indicating the correct argument is passed.

```sh
#!/usr/bin/env bats

@test "fadd stage selected dir" {
  run stage_selected_dir
  # we could assert if fzf is actually being invoked correctly
  # in this case, it's supposed to search directory and using tree to provide preview
  [[ "${output}" =~ "add fadd_stage_dir" ]]
}
```

## Full example

> You could always checkout more examples in tests folder

The fzf executable

```sh
if [[ "$*" =~ '--header=select a commit' ]] && [[ "$*" =~ "show --color" ]]; then
  # dotbare flog --reset -y -- "./flog.bats" @test "flog reset"
  echo "--flog_reset"
fi
```

The bats unit test file.

```sh
#!/usr/bin/env bats

help() {
  bash "${BATS_TEST_DIRNAME}"/../dotbare flog -h
}
reset() {
  export PATH="${BATS_TEST_DIRNAME}:$PATH"
  bash "${BATS_TEST_DIRNAME}"/../dotbare flog --reset -y
}

@test "flog help" {
  run help
  [ "${status}" -eq 0 ]
  [ "${lines[0]}" = "Usage: dotbare flog [-h] [-r] [-R] [-e] [-c] [-y] ..." ]
}
@test "flog reset" {
  run reset
  [[ "${output}" =~ "reset --flog_reset" ]]
}
```
