#!/usr/bin/env bash
# //////////////////////////////////////////////////////////////////////////////

# parse user input arguments
while [[ $# -gt 0 ]]
do
  key="${1}"
  case ${key} in
  --task)
    task="${2}"
    shift # past argument
    shift # past value
    ;;
  --host)
    host="${2}"
    shift # past argument
    shift # past value
    ;;
  --inv)
    inv="${2}"
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
  verify_arg "$task" "Error: option '--task' must be given." "$usage_msg"
  verify_arg "$host" "Error: option '--host' must be given." "$usage_msg"
  verify_arg "$inv" "Error: option '--inv' must be given." "$usage_msg"
}

# print given user argments
print_user_arguments() {
  minor_text "task is: $task"
  minor_text "host is: $host"
  minor_text "inv is: $inv"
  newline
}
