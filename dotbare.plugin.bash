mydir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
[[ :$PATH: != *:"${mydir}":* ]] && export PATH="$PATH:${mydir}"

_dotbare_completions()
{
  local IFS=$'\n' subcommands cur prev options
  cur="${COMP_WORDS[$COMP_CWORD]}"
  prev="${COMP_WORDS[$COMP_CWORD-1]}"

  if [[ "$COMP_CWORD" -eq "1" ]]; then
    subcommands="$(${mydir}/dotbare -h \
      | awk '{
          if ($0 ~ /^  f.*/) {
            gsub(/^  /, "", $0)
            gsub(/\t\t/, "    ", $0)
            print $0
          }
        }')"

    if [[ $cur == -* ]]; then
      COMPREPLY+=($(compgen -W "-h" -- "${COMP_WORDS[1]}"))
    else
      COMPREPLY=($(compgen -W "${subcommands}" -- "${COMP_WORDS[1]}"))
    fi

  elif [[ "$COMP_CWORD" -eq "2" && "${prev}" != '-h' ]]; then
    case "${prev}" in
      fbackup)
        ;;
      finit)
        ;;
      *)
        options="$(${mydir}/dotbare ${prev} -h \
          | awk '{
              if ($0 ~ /  -*/) {
                gsub(/^  /, "", $0)
                gsub(/\t/, "  ", $0)
                print $0
              }
            }')"
        COMPREPLY=($(compgen -W "${options}" -- "${COMP_WORDS[2]}"))
        ;;
    esac
  fi

  if [[ ${#COMPREPLY[*]} -eq 1 ]]; then
    COMPREPLY=( "${COMPREPLY[0]%% *}" )
  fi
}

complete -F _dotbare_completions dotbare
