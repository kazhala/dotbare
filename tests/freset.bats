#!/usr/bin/env bats

help() {
  bash "${BATS_TEST_DIRNAME}"/../dotbare freset -h
}

invalid_option() {
  bash "${BATS_TEST_DIRNAME}"/../dotbare freset -p
}

no_selection_made() {
  bash "${BATS_TEST_DIRNAME}"/../dotbare freset
}

select_commit() {
  export PATH="${BATS_TEST_DIRNAME}:$PATH"
  bash "${BATS_TEST_DIRNAME}"/../dotbare freset --commit -y
}

select_files() {
  export PATH="${BATS_TEST_DIRNAME}:$PATH"
  bash "${BATS_TEST_DIRNAME}"/../dotbare freset
}

@test "freset help" {
  run help
  [ "${status}" -eq 0 ]
  [ "${lines[0]}" = "Usage: dotbare freset [-h] [-c] [-S] [-H] [-y] ..." ]
}

@test "freset invalid option" {
  run invalid_option
  [ "${status}" -eq 1 ]
  [ "${lines[0]}" = "Invalid option: -p" ]
}

@test "freset select commit" {
  run select_commit
  result=$(echo "${lines[0]}" | tr '`' "'")
  [ "${status}" -eq 129 ]
  [ "${result}" = "error: unknown option 'no-multi'" ]
}

@test "freset no selection made" {
  run no_selection_made
  [ -z "${output}" ]
  [ "${status}" -eq 1 ]
}

@test "freset select files" {
  run select_files
  [ -z "${output}" ]
  [ "${status}" -eq 0 ]
}
