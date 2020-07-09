#!/usr/bin/env bats

setup() {
  export PATH="${BATS_TEST_DIRNAME}:$PATH"
}

help() {
  bash "${BATS_TEST_DIRNAME}"/../dotbare funtrack -h
}

invalid_option() {
  bash "${BATS_TEST_DIRNAME}"/../dotbare funtrack -p
}

untrack_file() {
  bash "${BATS_TEST_DIRNAME}"/../dotbare funtrack --yes
}

temp_untrack() {
  bash "${BATS_TEST_DIRNAME}"/../dotbare funtrack --yes -t
}

resume_track() {
  bash "${BATS_TEST_DIRNAME}"/../dotbare funtrack --yes --resume
}

@test "funtrack help" {
  run help
  [ "${status}" -eq 0 ]
  [ "${lines[0]}" = "Usage: dotbare funtrack [-h] [-t] [-r] [-y] ..." ]
}

@test "funtrack invalid option" {
  run invalid_option
  [ "${status}" -eq 1 ]
  [ "${lines[0]}" = "Invalid option: -p" ]
}

@test "funtrack untrack file" {
  run untrack_file
  [[ "${output}" =~ "rm --cached" ]]
  [[ "${output}" =~ "funtrack_file" ]]
}

@test "funtrack temp untrack" {
  run temp_untrack
  [[ "${output}" =~ "update-index --assume-unchanged" ]]
  [[ "${output}" =~ "funtrack_file" ]]
}

@test "funtrack resume track" {
  run resume_track
  [[ "${output}" =~ "update-index --no-assume-unchanged" ]]
  [[ "${output}" =~ "funtrack_file" ]]
}
