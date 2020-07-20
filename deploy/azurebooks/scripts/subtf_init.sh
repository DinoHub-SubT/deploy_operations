#!/usr/bin/env bash
eval "$(cat $(dirname "${BASH_SOURCE[0]}")/header.sh)"

if chk_flag --help $@; then
    title "$__file_name : initializes subt's terraform setup with the correct tfstate file"
    exit 0
fi

cd $__dir/../subt

# Echo the path to the state file variable into the terraform init command
echo "workspaces/${TF_VAR_azure_username}/terraform.tfstate" | terraform init

cd $__call_dir
