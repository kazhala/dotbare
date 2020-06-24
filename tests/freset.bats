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

@test "freset no selection made" {
  run no_selection_made
  [ "${status}" -eq 1 ]
}

@test "freset select commit" {
  if ! "${BATS_TEST_DIRNAME}"/../dotbare log &>/dev/null; then
    skip
  fi
  run select_commit
  result=$(echo "${lines[0]}" | tr '`' "'")
  [[ "${result}" =~ "error: unknown option 'commitshow'" ]]
  [ "${status}" -eq 129 ]
}

@test "freset select files" {
  if ! "${BATS_TEST_DIRNAME}"/../dotbare log &>/dev/null; then
    skip
  fi
  run select_files
  [ "${status}" -eq 128 ]
  [[ "${lines[0]}" =~ "fatal: ambiguous argument '$HOME/modifiedfile': unknown revision or path not in the working tree" ]]
}
