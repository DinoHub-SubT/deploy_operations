#!/usr/bin/env bash

# include headers
eval "$(cat $(dirname "${BASH_SOURCE[0]}")/header.sh)"
. "$SUBT_PATH/operations/scripts/header.sh"
. "$SUBT_PATH/operations/scripts/formatters.sh"

if chk_flag --help $@ || chk_flag -h $@ || chk_flag -help $@; then
    title "$__file_name : initializes subt's terraform setup with the correct tfstate file"
    exit 0
fi

# source the terraform environment
source_terra_env

# go to the terraform project path
pushd $SUBT_OPERATIONS_PATH/azurebooks/subt

# Echo the path to the state file variable into the terraform init command
echo "workspaces/${TF_VAR_azure_username}/terraform.tfstate" | terraform init

# cleanup & exit
exit_pop_success
