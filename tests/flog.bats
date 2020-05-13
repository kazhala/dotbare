#!/usr/bin/env bats

help() {
  bash "${BATS_TEST_DIRNAME}"/../dotbare flog -h
}

invalid_option() {
  bash "${BATS_TEST_DIRNAME}"/../dotbare flog -p
}

@test "flog help" {
  run help
  [ "${status}" -eq 0 ]
  [ "${lines[0]}" = "Usage: dotbare flog [-h] [-r] [-R] [-e] [-c] ..." ]
}

@test "flog invalid option" {
  run invalid_option
  [ "${status}" -eq 1 ]
  [ "${lines[0]}" = "Invalid option: p" ]
}
