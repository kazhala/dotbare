#!/usr/bin/env bats

help() {
  bash "${BATS_TEST_DIRNAME}"/../dotbare fedit -h
}

invalid_option() {
  bash "${BATS_TEST_DIRNAME}"/../dotbare fedit -p
}

no_file_selected() {
  cd "${BATS_TEST_DIRNAME}"
  bash "${BATS_TEST_DIRNAME}"/../dotbare fedit -m
}

edit_commits() {
  if "${BATS_TEST_DIRNAME}"/../dotbare log &>/dev/null; then
    export PATH="${BATS_TEST_DIRNAME}:$PATH"
  fi
  bash "${BATS_TEST_DIRNAME}"/../dotbare fedit --commit
}

edit_files() {
  export PATH="${BATS_TEST_DIRNAME}:$PATH"
  bash "${BATS_TEST_DIRNAME}"/../dotbare fedit
}

@test "fedit help" {
  run help
  [ "${status}" -eq 0 ]
  [ "${lines[0]}" = "Usage: dotbare fedit [-h] [-m] [-c] ..." ]
}

@test "fedit invalid option" {
  run invalid_option
  [ "${status}" -eq 1 ]
  [ "${lines[0]}" = "Invalid option: -p" ]
}

@test "fedit no file selected" {
  run no_file_selected
  [ "${status}" -eq 1 ]
}

@test "fedit edit commits" {
  run edit_commits
  if ! "${BATS_TEST_DIRNAME}"/../dotbare log &>/dev/null; then
    [ "${status}" -eq 1 ]
    [ "${output}" = "fatal: your current branch 'master' does not have any commits yet" ]
  else
    [ "${status}" -eq 128 ]
    [ "${lines[0]}" = "fatal: invalid upstream 'commitdiff~'" ]
  fi
}

@test "fedit edit files" {
  run edit_files
  [ "${status}" -eq 1 ]
  [ -z "${output}" ]
}
