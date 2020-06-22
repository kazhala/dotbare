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
  if ! "${BATS_TEST_DIRNAME}"/../dotbare log &>/dev/null; then
    [ "${lines[0]}" = "fatal: your current branch 'master' does not have any commits yet" ]
  else
    result=$(echo "${lines[0]}" | tr '`' "'")
    [ "${result}" = "error: unknown option 'no-multi'" ]
  fi
  [ "${status}" -eq 129 ]
}

@test "freset no selection made" {
  run no_selection_made
  [ "${status}" -eq 1 ]
}

@test "freset select files" {
  run select_files
  if ! "${BATS_TEST_DIRNAME}"/../dotbare log &>/dev/null; then
    [ "${status}" -eq 128 ]
    [ "${lines[0]}" = "fatal: ambiguous argument 'HEAD': unknown revision or path not in the working tree." ]
  else
    [ "${status}" -eq 0 ]
    [ -z "${output}" ]
  fi
}
