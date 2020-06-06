mydir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
[[ :$PATH: != *:"${mydir}":* ]] && export PATH="$PATH:${mydir}"

_dotbare_completions()
{
  local IFS=$'\n' subcommands
  if [[ "$COMP_CWORD" -eq "1" ]]; then
    subcommands="$(./dotbare -h \
      | awk '{
          if ($0 ~ /^  f.*/) {
            gsub(/^  /, "", $0)
            gsub(/\t\t/, "    ", $0)
            print $0
          }
        }')"

    COMPREPLY=($(compgen -W "${subcommands}" -- "${COMP_WORDS[1]}"))
    if [[ ${#COMPREPLY[*]} -eq 1 ]]; then
      COMPREPLY=( ${COMPREPLY[0]%% *} )
    fi
  fi
}

complete -F _dotbare_completions dotbare
