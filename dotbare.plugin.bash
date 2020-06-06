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
    if [[ ${#COMPREPLY[*]} -eq 1 ]]; then
      COMPREPLY=( "${COMPREPLY[0]%% *}" )
    fi

  elif [[ "$COMP_CWORD" -eq "2" && "${prev}" != '-h' ]]; then
    case "${prev}" in
      fbackup)
        options="$(${mydir}/dotbare ${prev} -h \
          | awk '{
              if ($0 ~ /  -p PATH/) {
                gsub(/^  -p PATH/, "-p  ", $0)
                gsub(/\t/, "  ", $0)
                print $0
              } else if ($0 ~ /  -*/) {
                gsub(/^  /, "", $0)
                gsub(/\t/, "  ", $0)
                print $0
              }
            }')"
        ;;
      finit)
        options="$(${mydir}/dotbare ${prev} -h \
          | awk '{
              if ($0 ~ /  -u URL/) {
                gsub(/^  -u URL/, "-u  ", $0)
                gsub(/\t/, "  ", $0)
                print $0
              } else if ($0 ~ /  -*/) {
                gsub(/^  /, "", $0)
                gsub(/\t/, "  ", $0)
                print $0
              }
            }')"
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
        ;;
    esac
    COMPREPLY=($(compgen -W "${options}" -- "${COMP_WORDS[2]}"))
    if [[ ${#COMPREPLY[*]} -eq 1 ]]; then
      COMPREPLY=( "${COMPREPLY[0]%% *}" )
    fi
  elif [[ "$COMP_CWORD" -eq "3" ]]; then
    [[ "${COMP_WORDS[1]}" == "fbackup" && "${COMP_WORDS[2]}" == "-p" ]] && \
      COMPREPLY=($(compgen -d -- "${COMP_WORDS[3]}"))
  fi
}
complete -F _dotbare_completions dotbare
