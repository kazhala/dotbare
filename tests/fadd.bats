#!/usr/bin/env bats

help() {
  bash "${BATS_TEST_DIRNAME}"/../dotbare fadd -h
}

invalid_option() {
  bash "${BATS_TEST_DIRNAME}"/../dotbare fadd -p
}

no_file_selected() {
  cd "${BATS_TEST_DIRNAME}"
  bash "${BATS_TEST_DIRNAME}"/../dotbare fadd -d
}

stage_selected_file() {
  export PATH="${BATS_TEST_DIRNAME}:$PATH"
  bash "${BATS_TEST_DIRNAME}"/../dotbare fadd -f
}

stage_selected_dir() {
  export PATH="${BATS_TEST_DIRNAME}:$PATH"
  bash "${BATS_TEST_DIRNAME}"/../dotbare fadd --dir
}

stage_modified_file() {
  export PATH="${BATS_TEST_DIRNAME}:$PATH"
  bash "${BATS_TEST_DIRNAME}"/../dotbare fadd
}

@test "fadd help" {
  run help
  [ "${status}" -eq 0 ]
  [ "${lines[0]}" = "Usage: dotbare fadd [-h] [-f] [-d] ..." ]
}

@test "fadd invalid option" {
  run invalid_option
  [ "${status}" -eq 1 ]
  [ "${lines[0]}" = "Invalid option: -p" ]
}

@test "fadd no file selected" {
  run no_file_selected
  [ "${status}" -eq 1 ]
}

@test "fadd stage selected file" {
  run stage_selected_file
  [ "${status}" -eq 128 ]
  [[ "${output}" =~ "fatal: pathspec 'searchfile' did not match any files" ]]
}

@test "fadd stage selected dir" {
  run stage_selected_dir
  [ "${status}" -eq 128 ]
  [ "${lines[0]}" = "fatal: pathspec 'searchdir' did not match any files" ]
}

@test "fadd stage modified file" {
  run stage_modified_file
  [ "${status}" -eq 128 ]
  [ "${lines[0]}" = "fatal: pathspec '$HOME/modifiedfile' did not match any files" ]
}
