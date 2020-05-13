#!/usr/bin/env bats

help() {
  bash "${BATS_TEST_DIRNAME}"/../dotbare fstat -h
}

invalid_option() {
  bash "${BATS_TEST_DIRNAME}"/../dotbare fstat -p
}

no_modify() {
  bash "${BATS_TEST_DIRNAME}"/../dotbare fstat
}

@test "fstat help" {
  run help
  [ "${status}" -eq 0 ]
  [ "${lines[0]}" = "Usage: dotbare fstat [-h] ..." ]
}

@test "fstat invalid option" {
  run invalid_option
  [ "${status}" -eq 1 ]
  [ "${lines[0]}" = "Invalid option: p" ]
}

@test "fstat run no modify file" {
  run no_modify
  [ "${status}" -eq 0 ]
}
