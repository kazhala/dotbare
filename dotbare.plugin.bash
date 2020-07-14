# shellcheck disable=SC2207

mydir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
[[ :$PATH: != *:"${mydir}":* ]] && export PATH="$PATH:${mydir}"

__dotbare_completion()
{
  local IFS=$'\n' subcommands curr prev options selected suggestions
  curr="${COMP_WORDS[$COMP_CWORD]}"
  prev="${COMP_WORDS[$COMP_CWORD-1]}"

  if [[ "$COMP_CWORD" -eq "1" ]]; then
    subcommands=$(
      "${mydir}"/dotbare -h \
        | awk '{
            if ($0 ~ /^  f.*/) {
              gsub(/^  /, "", $0)
              gsub(/\t\t/, "    ", $0)
              print $0
            }
          }'
    )

    options=$(
      "${mydir}"/dotbare -h \
        | awk '{
            if ($0 ~ /^  -.*/) {
              gsub(/,/, " ", $0)
              gsub(/^  /, "", $0)
              gsub(/\t\t/, "    ", $0)
              print $0
            }
          }'
    )

    if [[ "${curr}" == -* ]]; then
      suggestions=($(compgen -W "${options}" -- "${curr}"))
    else
      suggestions=($(compgen -W "${subcommands}" -- "${curr}"))
    fi

  elif [[ "${COMP_WORDS[1]}" == "fbackup" && "${prev}" == "-p" ]]; then
    COMPREPLY=($(compgen -d -- "${curr}"))
    return
  elif [[ "${COMP_WORDS[1]}" == "finit" && "${prev}" == "-u" ]]; then
    return

  elif [[ "${prev}" != "-h" && "${prev}" != "--help" ]]; then
    selected=("${COMP_WORDS[@]:1}")
    options=$(
      "${mydir}"/dotbare "${COMP_WORDS[1]}" -h \
        | awk -v selected="${selected[*]}" '{
            gsub(/,/, " ", $0)
            if (selected ~ $1) {
              next
            } else if ($0 ~ /^  -p PATH/) {
              gsub(/^  -p PATH  --path PATH/, "-p", $0)
              gsub(/\t/, "  ", $0)
              print $0
            } else if ($0 ~ /^  -u URL/) {
              gsub(/^  -u URL  --url URL/, "-u", $0)
              gsub(/\t/, "  ", $0)
              print $0
            } else if ($0 ~ /^  -*/) {
              gsub(/^  /, "", $0)
              gsub(/\t/, "  ", $0)
              $2=""
              print $0
            }
          }'
    )
    suggestions=($(compgen -W "${options}" -- "${curr}"))
  fi

  if [[ "${#suggestions[*]}" -eq 1 ]]; then
    COMPREPLY=("${suggestions[@]%% *}")
  else
    for i in "${!suggestions[@]}"; do
      suggestions[$i]="$(printf '%*s' "-$COLUMNS"  "${suggestions[$i]}")"
    done
    COMPREPLY=("${suggestions[@]}")
  fi
}
complete -F _dotbare_completions dotbare

_dotbare_completion_cmd() {
  local complete_name="${1:-dotbare}"
  complete -F __dotbare_completion "${complete_name}"
}

_dotbare_completion_git() {
  local complete_name="${1:-dotbare}"
  complete -F _git "${complete_name}"
}
