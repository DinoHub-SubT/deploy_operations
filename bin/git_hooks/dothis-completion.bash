#/usr/bin/env bash

function get_all_files() {
  # ls
  echo "1 2 4 8 16 32 64 128"
}

_dothis_completions()
{
  echo "here?"
  # COMPREPLY=($(compgen -W "now tomorrow never" "${COMP_WORDS[1]}"))
  # COMPREPLY=($(compgen -W "$(fc -l -4 | sed 's/\t//')" -- "${COMP_WORDS[1]}"))

  # echo "args are: ${#COMP_WORDS[@]}"
  # echo "args are: ${COMP_WORDS[@]}"

  # if [ "${#COMP_WORDS[@]}" -lt "2" ]; then
  #   return
  # fi

  # COMPREPLY=($(compgen -W "$(get_all_files)" -- "${COMP_WORDS[1]}"))
  COMPREPLY=($(compgen -W "now tomorrow never" "${COMP_WORDS[1]}"))
}

# complete -F _dothis_completions info.bash
complete -F _dothis_completions info.bash