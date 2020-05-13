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

@test "fedit help" {
  run help
  [ "${status}" -eq 0 ]
  [ "${lines[0]}" = "Usage: dotbare fedit [-h] [-m] [-c] ..." ]
}

@test "fedit invalid option" {
  run invalid_option
  [ "${status}" -eq 1 ]
  [ "${lines[0]}" = "Invalid option: p" ]
}

@test "fedit no file selected" {
  run no_file_selected
  [ "${status}" -eq 1 ]
}
