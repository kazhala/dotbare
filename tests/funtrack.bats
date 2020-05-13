#!/usr/bin/env bats

help() {
  bash "${BATS_TEST_DIRNAME}"/../dotbare funtrack -h
}

invalid_option() {
  bash "${BATS_TEST_DIRNAME}"/../dotbare funtrack -p
}

@test "funtrack help" {
  run help
  [ "${status}" -eq 0 ]
  [ "${lines[0]}" = "Usage: dotbare funtrack [-h] [-s] [-S] ..." ]
}

@test "funtrack invalid option" {
  run invalid_option
  [ "${status}" -eq 1 ]
  [ "${lines[0]}" = "Invalid option: p" ]
}
