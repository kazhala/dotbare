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
    dotbare.plugin.bash \
    dotbare \
    helper/* \
    scripts/* \
    tests/shellcheck.sh \
    -type f \
    -print0
  )

shellcheck -e SC1090 "${scripts[@]}"

exit $?
