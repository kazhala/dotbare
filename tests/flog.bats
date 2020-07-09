#!/usr/bin/env bats

help() {
  bash "${BATS_TEST_DIRNAME}"/../dotbare flog -h
}

invalid_option() {
  bash "${BATS_TEST_DIRNAME}"/../dotbare flog -p
}

menu() {
  export PATH="${BATS_TEST_DIRNAME}:$PATH"
  bash "${BATS_TEST_DIRNAME}"/../dotbare flog
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

@test "flog invalid option" {
  run invalid_option
  [ "${status}" -eq 1 ]
  [ "${lines[0]}" = "Invalid option: -p" ]
}

@test "flog menu" {
  run menu
  [ "${status}" -eq 0 ]
}

@test "flog reset" {
  run reset
  [[ "${output}" =~ "reset --flog_reset" ]]
}
