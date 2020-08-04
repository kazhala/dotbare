#!/usr/bin/env bash
#
# run shellcheck against all scripts

set -e

mydir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "${mydir}"/../

scripts=()
while IFS=  read -r -d $'\0' line; do
    scripts+=("$line")
done < <(
  find \
    dotbare \
    helper/* \
    scripts/* \
    tests/shellcheck.sh \
    -type f \
    -print0
  )

shellcheck -e SC1090 "${scripts[@]}"
shellcheck -e SC1090 --shell=bash "dotbare.plugin.bash"
shellcheck --shell=bash "pkg/completion/bash/dotbare"
# \shellcheck does not have zsh support yet, hence using bash for now
shellcheck -e SC2034 --shell=bash "dotbare.plugin.zsh"
shellcheck -e SC2034 --shell=bash "pkg/completion/zsh/_dotbare"

exit $?
