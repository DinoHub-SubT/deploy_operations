#!/usr/bin/env bash

# load header helper functions
. "$SUBT_PATH/operations/scripts/header.sh"
. "$SUBT_PATH/operations/scripts/formatters.sh"

if chk_flag --help $@ || chk_flag help $@ || chk_flag -h $@; then
  GL_TEXT_COLOR=$FG_LCYAN
  text
  title "Usage: $(basename $0) [flag] "
  text_color "Verifies all deploy operations tools are functional."
  text_color "For more help, please see the README.md or wiki."
  GL_TEXT_COLOR=$FG_DEFAULT
  exit_success
fi

# main entrypoint
main Verify Operations Tools

# verify operation tool -- error failure if not found
verify_operations_tool_fail() {
  subtitle "Verifing ($1)..."
  shift
  if [[ $( $@ ) ]]; then
    $@
  else
    error "Verification failed: ($1) does not exist."
    exit_failure
  fi
  newline
}

# verify operation tool -- warning text if not found
verify_operations_tool_warning() {
  subtitle "Verifing ($1)..."
  shift
  if [[ $( $@ ) ]]; then
    $@
  else
    warning "Verification failed: ($1) does not exist."
  fi
  newline
}

source ~/.subt/subtrc.bash

# verify docker ce
verify_operations_tool_fail     "docker"                                docker --version
verify_operations_tool_fail     "docker compose"                        docker-compose -v
verify_operations_tool_warning  "nvidia docker"                         nvidia-docker -v
verify_operations_tool_fail     "ansible"                               ansible --version
verify_operations_tool_warning  "terraform"                             terraform --version
verify_operations_tool_warning  "azure cli"                             az --help
verify_operations_tool_warning  "azure copy"                            azcopy -v
verify_operations_tool_warning  "teamviewer"                    teamviewer --version
verify_operations_tool_fail     "subt custom: docker compose wrapper"   docker-compose-wrapper --help
verify_operations_tool_fail     "deployer"                              deployer --help
verify_operations_tool_fail     "subt auto-complete"                    subt help

subtitle "All operations tools verified functional."

# cleanup & exit
exit_success
