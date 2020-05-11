#!/usr/bin/env bash
#
# run shellcheck against all scripts

set -e

scripts=()
while IFS=  read -r -d $'\0' line; do
    scripts+=("$line")
done < <(
  find \
    dotbare \
    helper/* \
    scripts/* \
    shellcheck.sh \
    -type f \
    -print0
  )

shellcheck -e SC1090 "${scripts[@]}"

exit $?
