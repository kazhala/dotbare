#!/usr/bin/env bats

help() {
  bash "${BATS_TEST_DIRNAME}"/../dotbare fgrep -h
}

invalid_option() {
  bash "${BATS_TEST_DIRNAME}"/../dotbare fgrep -p
}

edit_lines() {
  export PATH="${BATS_TEST_DIRNAME}:$PATH"
  export EDITOR="echo"
  bash "${BATS_TEST_DIRNAME}"/../dotbare fgrep
}

full_deli() {
  export PATH="${BATS_TEST_DIRNAME}:$PATH"
  export EDITOR="echo"
  bash "${BATS_TEST_DIRNAME}"/../dotbare fgrep --full
}

option_deli() {
  export PATH="${BATS_TEST_DIRNAME}:$PATH"
  export EDITOR="echo"
  bash "${BATS_TEST_DIRNAME}"/../dotbare fgrep --col 2
}

@test "fgrep option delimiter" {
  run option_deli
  [[ "${output}" =~ "--nth 2.. --header=select matches to edit" ]]
}

@test "fgrep full delimiter" {
  run full_deli
  [[ "${output}" =~ "--nth 1.. --header=select matches to edit" ]]
}

@test "fgrep help" {
  run help
  [ "${status}" -eq 0 ]
  [ "${lines[0]}" = "Usage: dotbare fgrep [-h] [-c] [-f] ..." ]
}

@test "fgrep invalid option" {
  run invalid_option
  [ "${status}" -eq 1 ]
  [ "${lines[0]}" = "Invalid option: -p" ]
}

@test "fgrep edit lines" {
  run edit_lines
  [[ "${output}" =~ "--nth 3.. --header=select matches to edit" ]]
}
