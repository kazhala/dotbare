# shellcheck disable=SC2207

mydir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
[[ :$PATH: != *:"${mydir}":* ]] && export PATH="$PATH:${mydir}"

__dotbare_completion()
{
  local IFS=$'\n' subcommands curr prev options verbose_options suggestions
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
              $2=""
              print $0
            }
          }'
    )
    verbose_options=$("${mydir}"/dotbare -h | awk '$0 ~ /^  -.*/ {print $2}')
    if [[ "${curr}" == --* ]]; then
      suggestions=($(compgen -W "${verbose_options}" -- "${curr}"))
    elif [[ "${curr}" == -* ]]; then
      suggestions=($(compgen -W "${options}" -- "${curr}"))
    else
      suggestions=($(compgen -W "${subcommands}" -- "${curr}"))
    fi

  elif [[ "${COMP_WORDS[1]}" == "fbackup" && "${prev}" == "-p" ]]; then
    COMPREPLY=($(compgen -d -- "${curr}"))
    return
  elif [[ "${COMP_WORDS[1]}" == "finit" && "${prev}" == "-u" ]]; then
    return
  elif [[ "${curr}" == --* && "${prev}" != "-h" && "${prev}" != "--help" ]]; then
    verbose_options=$(
      "${mydir}"/dotbare "${COMP_WORDS[1]}" -h 2> /dev/null \
        | awk '{
            if ($0 ~ /^  -p PATH/) {
              print "--path"
            } else if ($0 ~ /^  -u URL/) {
              print "--url"
            } else if ($0 ~ /^  -*/) {
              print $2
            }
          }'
    )
    suggestions=($(compgen -W "${verbose_options}" -- "${curr}"))
  elif [[ "${prev}" != "-h" && "${prev}" != "--help" ]]; then
    options=$(
      "${mydir}"/dotbare "${COMP_WORDS[1]}" -h 2> /dev/null \
        | awk '{
            gsub(/,/, " ", $0)
            if ($0 ~ /^  -p PATH/) {
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

_dotbare_completion_cmd() {
  local complete_name="${1:-dotbare}"
  complete -F __dotbare_completion "${complete_name}"
}

_dotbare_completion_git() {
  local complete_name="${1:-dotbare}"
  complete -F _git "${complete_name}"
}
