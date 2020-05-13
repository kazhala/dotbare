#!/usr/bin/env bats

help() {
  bash "${BATS_TEST_DIRNAME}"/../dotbare fstash -h
}

invalid_option() {
  bash "${BATS_TEST_DIRNAME}"/../dotbare fstash -w
}

stash_file() {
  bash "${BATS_TEST_DIRNAME}"/../dotbare fstash -f
}

@test "fstash help" {
  run help
  [ "${status}" -eq 0 ]
  [ "${lines[0]}" = "Usage: dotbare fstash [-h] [-f] [-d] [-p] ..." ]
}

@test "fstash invalid option" {
  run invalid_option
  [ "${status}" -eq 1 ]
  [ "${lines[0]}" = "Invalid option: w" ]
}

@test "fstash stash single file" {
  run stash_file
  [ "${status}" -eq 1 ]
}
