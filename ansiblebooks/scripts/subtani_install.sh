#!/usr/bin/env bash

# include headers
. "$SUBT_OPERATIONS_PATH/scripts/header.sh"
. "$SUBT_OPERATIONS_PATH/scripts/formatters.sh"

if chk_flag --help $@ || chk_flag help $@ || chk_flag -h $@ || chk_flag -help $@; then
  title "$__file_name [ flags ] < system_name > < playbook > : Installs base system library dependencies, extra tools & sets up system configuration on the different systems."
  text "Flags:"
  text "    -s  : Show the available system names."
  text "    -b  : Show the available playbooks."
  text "    -p  : Provide system password, to allow sudo installs."
  text "Args:"
  text "    system_name: the name of the remote system to install on"
  text "    playbook: the name of the robot ansible playbook to run"
  text
	text "For more help, please see the README.md or wiki."
  exit_success
fi

# globals
_GL_EXTRA_OPTS= # extra ansible options
_GL_pwd="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )/../"
_GL_inv_dir="$_GL_pwd/inventory/"

# parse ansible .ini file lines, to find the list of remote (or local) ansible system names
function get_system_names() {
  # get the given filename
  filename=$1

  # if not given filename, exit on error.
  if is_empty $filename; then
    error "error: filename is empty."
    exit_failure
  fi

  if ! file_exists $filename; then
    error "error: filename $filename does not exist."
    exit_failure
  fi

  # setup array of line numbers that contain the system name header. i.e. line header: '[system name]'
  local linenums=()
  # setup array to contain the name of the remote (or local) ansible systems
  local systems=()

  # find the line numbers for the lines that contain the system headers
  #   - regex: look-behind & look-ahead for '[', ']' and match text between
  for str in $(grep -Pon "(?<=\[).*(?=\])" $filename | paste -s -); do
    num=$(echo $str | cut -f1 -d:)

    # TODO: save as a pair, avoid re-reading file line twice
    # value=$(echo $str | cut -f2 -d:)

    linenums+=( $num )
  done

  # add end-of-file line count, in case there is just one system header line
  wc=$(($(wc -l < "$filename")+1))
  linenums+=($wc)

  # two iterators: we are re-reading the lines between two line numbers, i.e. the two iterators.
  iter1=${linenums[0]}
  for iter2 in "${linenums[@]:1}"; do

    # get the line at the current iterator
    headerline=$(sed -n "${iter1}p" < $filename)

    # ignore lines that contains ':vars', those lines do not contain system names.
    #   regex: look-ahead for ':'. Non-empty result means match found.
    filter=$(printf $headerline | grep -Po ".+?(?=\:)" )
    ! is_empty $filter && { iter1=$iter2; continue; }

    # get the lines between the two pointers
    systemlines=$(sed -n "$(($iter1+1)),$(($iter2-1))p" < $filename)

    # read each line: get the system name (column1) from the line
    while read -r system
    do
      # skip empty lines
      is_empty $system && { continue; }

      # skip comment lines
      #   regex: negative look ahead for '#'. Empty result means match found: removes match value found.
      system=$(printf $system | grep -P '^(?!#)' )
      is_empty $system && { continue; }

      # add system name
      if ! in_arr "$system" "${systems[@]}"; then
        systems+=( "$system" )
      fi
    done <<< "$systemlines"

    # reset the first pointer, moving it forward
    iter1=$iter2

  done
  echo ${systems[@]}
}

# //////////////////////////////////////////////////////////////////////////////
# @brief run the ansible robot playbook
# //////////////////////////////////////////////////////////////////////////////
main SubT Ansible PlayBooks

# go to top-level ansible robotbooks path
pushd $_GL_pwd

# exit on error if any other type of flag given (besides system name check)
# if ! chk_flag -s $@ && ! chk_flag -b $@ && ! chk_flag -p $@ ; then
#   error Unrecognized given flag $@. Run '--help'
#   exit_pop_error
# fi

# -- get available playbooks --

if chk_flag -b $@; then
  text \\n Ansible Playbooks \\n

  # find all ansible playbooks, in top-level robotbooks path
  for file in $_GL_pwd/*.yaml; do
    if file_exists $file; then
      text \\t $(basename $file)
    fi
  done

  # find all ansible playbooks, in tasks robotbooks path
  for file in $_GL_pwd/tasks/*.yaml; do
    if file_exists $file; then
      text \\t tasks/$(basename $file)
    fi
  done
fi

# -- get available system names --

# get localhost ansible system names
if chk_flag -s $@ ; then
  # output the system name resutls
  text \\n System Names Available  \\n

  # go through every inventory file
  for _filename in $_GL_inv_dir/*.ini; do
    # print the system name results
    systems=($(get_system_names $_filename))
    printf '\t%s\n' "${systems[@]}"
  done
fi

# exit early, if given books or system flags
if chk_flag -s $@ || chk_flag -b $@ ; then
  # cleanup & exit
  exit_pop_success
fi

# -- install playbook on remote system --

if ! chk_flag -s $@ && ! chk_flag -b $@; then

  # Make sure we actually have an argument...
  if [[ $# -lt 2 ]]; then
    error Not enough arguments provided, unable to run command. Run '--help'
    exit_pop_error
  fi

  # set the password, if given to enable by user input
  if chk_flag -p $@; then
    read -sp "Enter system password (leave empty for default): " client_password
    # _GL_EXTRA_OPTS="$_GL_EXTRA_OPTS --extra-vars \"ansible_sudo_pass=$client_password\""
  fi

  # named arguments (for readably)
  system=$1
  playbook=$2

  # find the inventory file matching system name
  for _filename in $_GL_inv_dir/*.ini; do
    systems=($(get_system_names $_filename))
    # inventory file contains system name
    if in_arr "$system" "${systems[@]}"; then
      inv=$_filename
      break
    fi
  done

  # no inventory file found, exit on error
  if is_empty $inv; then
    error Something went wrong.
    text - check your \'system_name\' or \'playbook\' filename arguments are valid.
    text - if given valid arguments, then please notify the maintainer.
    exit_pop_error
  fi

  # print, for user verification and debugging purposes
  text "...system: $system"
  text "...task: $playbook"
  text "...inventory: $(basename $inv)"
  newline

  # run ansible installer
  ansible-playbook -v -i $inv $playbook --limit $system $_GL_EXTRA_OPTS --extra-vars "ansible_sudo_pass=$client_password project_name=$DEPLOYER_PROJECT_NAME"

  # ansible-playbook install failed
  if last_command_failed; then
    error Ansible playbook install script failed. \\n
    text - please check your network connection. If you were disconnected, re-connect and try again.
    text - please check if there were any errors during an install command. If so, please notify the maintainer.
    text - if \'user interrupted execution\' invoked \(by CTRL-C\), then you can safely ignore this error message.
    exit_pop_error
  fi

  # cleanup & exit
  exit_pop_success
fi

# verify file parser did not fail
if last_command_failed; then
  echo ${systems[@]}  # gets the last error message, since systems is expecting an echo return
  error Something went wrong. Please notify the maintainer.
  exit_pop_error
fi

# cleanup & exit
exit_pop_success
