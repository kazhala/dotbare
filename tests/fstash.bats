#!/usr/bin/env bats

setup() {
  export PATH="${BATS_TEST_DIRNAME}:$PATH"
}

help() {
  bash "${BATS_TEST_DIRNAME}"/../dotbare fstash -h
}

invalid_option() {
  bash "${BATS_TEST_DIRNAME}"/../dotbare fstash -w
}

stash_file() {
  bash "${BATS_TEST_DIRNAME}"/../dotbare fstash -s
}

stash_delete() {
  bash "${BATS_TEST_DIRNAME}"/../dotbare fstash --delete --yes
}

stash_apply() {
  bash "${BATS_TEST_DIRNAME}"/../dotbare fstash --yes
}

@test "fstash help" {
  run help
  [ "${status}" -eq 0 ]
  [ "${lines[0]}" = "Usage: dotbare fstash [-h] [-s] [-d] [-p] ..." ]
}

@test "fstash invalid option" {
  run invalid_option
  [ "${status}" -eq 1 ]
  [ "${lines[0]}" = "Invalid option: -w" ]
}

@test "fstash stash select file" {
  run stash_file
  [ "${status}" -eq 1 ]
  [[ "${output}" =~ "stash_select" ]]
}

@test "fstash stash delete" {
  run stash_delete
  [ "${status}" -eq 1 ]
  [[ "${output}" =~ "stash_delete" ]]
}

@test "fstash apply stash" {
  run stash_apply
  [ "${status}" -eq 1 ]
  [[ "${output}" =~ "stash_apply" ]]
}
