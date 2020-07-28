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

@test "fgrep help" {
  run help
  [ "${status}" -eq 0 ]
  [ "${lines[0]}" = "Usage: dotbare fgrep [-h] ..." ]
}

@test "fgrep invalid option" {
  run invalid_option
  [ "${status}" -eq 1 ]
  [ "${lines[0]}" = "Invalid option: -p" ]
}

@test "fgrep edit lines" {
  run edit_lines
  [[ "${output}" =~ "fgrep_words" ]]
}
