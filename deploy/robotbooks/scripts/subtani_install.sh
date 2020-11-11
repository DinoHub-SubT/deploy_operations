#!/usr/bin/env bash
eval "$(cat $(dirname "${BASH_SOURCE[0]}")/../../azurebooks/scripts/header.sh)"

if chk_flag --help $@ || chk_flag help $@ || chk_flag -h $@ || chk_flag -help $@; then
  title "$__file_name [ flags ] < system_name > < playbook > : Installs ."
  text "Flags:"
  text "    -az : Show the available azure ansible system names."
  text "    -r  : Show the available robot ansible system names."
  text "    -l  : Show the available localhost system names."
  text "    -b  : Show the available playbooks."
  text "    -p  : Provide system password, to allow sudo installs."
  text "Args:"
  text "    system_name: the name of the remote system to install on"
  text "    playbook: the name of the robot ansible playbook to run"
  exit 0
fi

# //////////////////////////////////////////////////////////////////////////////

# globals
_GL_EXTRA_OPTS= # extra ansible options
# script only utilities

# exit on success
function exit_on_success() {
  newline
  popd
  exit_success
}

# exit on failure
function exit_on_error() {
  error $1
  popd
  exit_failure
}

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
      if ! val_in_arr "$system" "${systems[@]}"; then
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
title == Running SubT ansible robotbooks ==

# go to top-level ansible robotbooks path
pushd $__dir/../

# set the password, if given to enable by user input
if chk_flag -p $@; then
  read -p "Enter system password (leave empty for default): " client_password
  # _GL_EXTRA_OPTS="$_GL_EXTRA_OPTS --extra-vars \"ansible_sudo_pass=$client_password\""
fi

# install playbook on remote system
if ! chk_flag -az $@ && ! chk_flag -r $@ && ! chk_flag -b $@ && ! chk_flag -l $@; then

  # Make sure we actually have an argument...
  if [[ $# -lt 2 ]]; then
    error Not enough arguments provided, unable to run command. Run '--help'
    exit_on_error
  fi

  # named arguments (for readably)
  system=$1
  playbook=$2

  # find the inventory file matching system name
  # -- assuming UNIQUE system names between all inventory file (weak assumption?)
  filenames=("" "./inventory/localhost.ini" "./inventory/azure.ini" "./inventory/robot.ini")
  for filename in "${filenames[@]:1}"; do
    systems=($(get_system_names $filename))
    # inventory file contains system name
    if val_in_arr "$system" "${systems[@]}"; then
      inv=$filename
      break
    fi
  done

  # no inventory file found, exit on error
  if is_empty $inv; then
    error Something went wrong.
    text - check your \'system_name\' or \'playbook\' filename arguments are valid.
    text - if given valid arguments, then please notify the maintainer.
    exit_on_error
  fi

  text "using inventory file: $inv"
  # run ansible installer
  ansible-playbook -v -i $inv $playbook --limit $system $_GL_EXTRA_OPTS --extra-vars "ansible_sudo_pass=$client_password"

  # ansible-playbook install failed
  if last_command_failed; then
    error Ansible playbook install script failed. \\n
    text - please check your network connection. If you were disconnected, re-connect and try again.
    text - please check if there were any errors during an install command. If so, please notify the maintainer.
    text - if \'user interrupted execution\' invoked \(by CTRL-C\), then you can safely ignore this error message.
    exit_on_error
  fi

  # cleanup & exit
  exit_on_success
fi

# get available playbooks
if chk_flag -b $@; then
  text Ansible Playbooks \\n

  # find all ansible playbooks, in top-level robotbooks path
  for file in $(pwd)/*.yaml; do
    if file_exists $file; then
      text \\t $(basename $file)
    fi
  done

  # find all ansible playbooks, in tasks robotbooks path
  for file in $(pwd)/tasks/*.yaml; do
    if file_exists $file; then
      text \\t tasks/$(basename $file)
    fi
  done

  # cleanup & exit
  exit_on_success
fi

# exit on error if any other type of flag given (besides system name check)
if ! chk_flag -az $@ && ! chk_flag -r $@ && ! chk_flag -l $@; then
  error Unrecognized given flag. Run '--help'
  exit_on_error
fi

# get localhost ansible system names
if chk_flag -l $@ ; then
  filename="./inventory/localhost.ini"
fi
# get robot ansible system names
if chk_flag -r $@ ; then
  filename="./inventory/robot.ini"
fi
# # get azure ansible system names
if chk_flag -az $@ ; then
  filename="./inventory/azure.ini"
fi

# print the system name results
systems=($(get_system_names $filename))

# verify file parser did not fail
if last_command_failed; then
  echo ${systems[@]}  # gets the last error message, since systems is expecting an echo return
  error Something went wrong. Please notify the maintainer.
  exit_on_error
fi

# output the system name resutls
text System Names Available  \\n
printf '\t%s\n' "${systems[@]}"

# cleanup & exit
exit_on_success
