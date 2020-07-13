#!/usr/bin/env bash
# //////////////////////////////////////////////////////////////////////////////
clean=false
# parse user input arguments
while [[ $# -gt 0 ]]
do
  key="${1}"
  case ${key} in
  --clean)
    clean=true
    shift # past argument
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
