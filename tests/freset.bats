#!/usr/bin/env bats

help() {
  bash "${BATS_TEST_DIRNAME}"/../dotbare freset -h
}

invalid_option() {
  bash "${BATS_TEST_DIRNAME}"/../dotbare freset -p
}

@test "freset help" {
  run help
  [ "${status}" -eq 0 ]
  [ "${lines[0]}" = "Usage: dotbare freset [-h] [-c] [-S] [-H] ..." ]
}

@test "freset invalid option" {
  run invalid_option
  [ "${status}" -eq 1 ]
  [ "${lines[0]}" = "Invalid option: p" ]
}
