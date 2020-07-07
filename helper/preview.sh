#!/usr/bin/env bash
#
# dynamic preview command for dotbare
# borrowed and modified from fzf.vim
#
# @params
# Globals
#   reverse_seq: reverse highlight sequence for easier print
#   reset_seq: reset highlight sequence for eaiser print
#   input_option: the array containing informaiton from cmd argument
#   preview_file: the file path to be previewed
#   preview_center: the center/highlight line of the preview, if not set, display entire file
#   preview_lines: total lines to be previed, used to determine the first line and last line to be printed
#   preview_first: the first line number of the file to be printed
#   preview_last: the last line number of the file to be printed
#   file_mime: mime of the file, used to display information for binary file
# Arguments
#   $1: The filename and line info to be previewed
#     Format: filepath[:lineno][:ignored]
# Example
#   preview "$HOME/.bashrc:15"

#######################################
# display the preview of the file
# construct argument for the action, execute and exit
# Arguments:
#   $1: the file path to be previewed
#   $2: the first line number to be previewd, optional
#   $3: the center/highlight line in the preview, optional
#   $4: the last line number to be previewed, optional
# Note:
#   if the line number information such as $2 $3 $4 is not given, the entire
#   file will be printed.
#   Otherwise only the $2-$4 parts of the file will be printed and $3 will be highlighted
#######################################
function display_preview() {
  local fallback_cmd preview_cmd preview_file preview_first preview_last preview_center
  preview_file="$1"
  preview_first="$2"
  preview_center="$3"
  preview_last="$4"
  fallback_cmd="highlight -O ansi -l {} || coderay {} || rougify {} || cat {}"
  preview_cmd=${DOTBARE_PREVIEW:-${fallback_cmd}}
  preview_cmd=${preview_cmd//{\}/$(printf %q "${preview_file}")}

  if [[ -z "${preview_first}" ]] || [[ -z "${preview_center}" ]] || [[ -z "${preview_last}" ]]; then
    if [[ -z "${DOTBARE_PREVIEW}" ]] && command -v bat > /dev/null; then
      bat --color=always --pager=never "${preview_file}"
      exit $?
    fi
    eval "${preview_cmd}" 2> /dev/null
    exit 0
  else
    if [ -z "${DOTBARE_PREVIEW}" ] && command -v bat > /dev/null; then
      bat --color=always --pager=never \
          --line-range="${preview_first}":"${preview_last}" --highlight-line="${preview_center}" "${preview_file}"
      exit $?
    fi
    eval "${preview_cmd}" 2> /dev/null \
      | awk "NR >= ${preview_first} && NR <= ${preview_last} { \
          if (NR == ${preview_center}) \
            { gsub(/\x1b[[0-9;]*m/, \"&${reverse_seq}\"); printf(\"${reverse_seq}%s\n${reset_seq}\", \$0); } \
          else \
            printf(\"${reset_seq}%s\n\", \$0); \
        }"
    exit 0
  fi
}

reverse_seq="\x1b[7m"
reset_seq="\x1b[m"

IFS=':' read -r -a input_option <<< "$1"
preview_file=${input_option[0]}
preview_center=${input_option[1]}

# potential fix for windows? Although I don't think dotbare will be usable in windows yet
if [[ $1 =~ ^[A-Z]:\\ ]]; then
  preview_file=$preview_file:${input_option[1]}
  preview_center=${input_option[2]}
fi

preview_file="${preview_file/#\~\//$HOME/}"
if [ ! -r "${preview_file}" ]; then
  echo "File not found ${preview_file}"
  exit 1
fi

# if binary, display binary info and exit
file_mime=$(file --dereference --mime "${preview_file}")
[[ "${file_mime}" =~ binary ]] \
  && echo "${file_mime}" \
  && exit 0

# if no line number was given, just preview the entire file
[[ -z "${preview_center}" ]] && display_preview "${preview_file}"

# if invalid line number was given, just preview the entire file
[[ -n "${preview_center}" && ! "${preview_center}" =~ ^[0-9] ]] && display_preview "${preview_file}"

# get the size of the termianl window and determine the first line and last line
preview_center=${preview_center/[^0-9]*/}

if [ -n "${FZF_PREVIEW_LINES}" ]; then
  preview_lines="${FZF_PREVIEW_LINES}"
else
  if [ -r /dev/tty ]; then
    preview_lines=$(stty size < /dev/tty | awk '{print $1}')
  else
    preview_lines=40
  fi
fi

preview_first=$((preview_center-preview_lines/3))
preview_first=$((preview_first < 1 ? 1 : preview_first))
preview_last=$((preview_first+preview_lines-1))

display_preview "${preview_file}" "${preview_first}" "${preview_center}" "${preview_last}"
