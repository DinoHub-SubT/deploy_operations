#!/usr/bin/env bash
# //////////////////////////////////////////////////////////////////////////////

# setup default arguments
user="subt"
pass="Password1234!"
res="1440x900!"

# parse user input arguments
while [[ $# -gt 0 ]]
do
  key="${1}"
  case ${key} in
  --user)
    user="${2}"
    shift # past argument
    shift # past value
    ;;
  --pass)
    pass="${2}"
    shift # past argument
    shift # past value
    ;;
  --res)
    res="${2}"
    shift # past argument
    shift # past value
    ;;
  --title)
    title="${2}"
    shift # past argument
    shift # past value
    ;;
  --host)
    host="${2}"
    shift # past argument
    shift # past value
    ;;
  help)
    help=true
    shift # past argument
    ;;
  -h)
    help=true
    shift # past argument
    ;;
  --help)
    help=true
    shift # past argument
    ;;
  *)      # unknown option
    shift # past argument
    ;;
  esac
done

# //////////////////////////////////////////////////////////////////////////////
# @brief verify given arguments are set
# //////////////////////////////////////////////////////////////////////////////
verify_user_input_args() {
  verify_arg "$title" "Error: option '--title' must be given." "$usage_msg"
  verify_arg "$host" "Error: option '--host' must be given." "$usage_msg"
}

# print given user argments
print_user_arguments() {
  minor_text "user is: $user"
  minor_text "password is: $pass"
  minor_text "resolution is: $res"
  minor_text "title is: $title"
  minor_text "host is: $host"
  newline
}
