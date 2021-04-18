#!/bin/bash
# This script will update the terraform bash scripting to contain the correct variables
# Joshua Spisak <joshs333@live.com>
# Jul 7, 2020

# include headers
eval "$(cat $(dirname "${BASH_SOURCE[0]}")/header.sh)"
. "$SUBT_PATH/operations/scripts/header.sh"
. "$SUBT_PATH/operations/scripts/formatters.sh"

if chk_flag --help $@ || chk_flag -h $@ || chk_flag -help $@; then
    text "Usage: install-terraform-current.sh"
    text
    text "    -c : Configuration file path."
    text "Installs the current terraform bashrc's to ~/"
    exit_success
fi

# terraform install path
GL_TERRA_ENV_PATH=$SUBT_CONFIGURATION_PATH
if ! chk_flag -c $@; then
    GL_TERRA_ENV_PATH=$(get_arg -c $@)
fi
newline

# verify the subt configuration folders are created

if ! dir_exists $SUBT_PATH; then
    error "SUBT_PATH not found!!! Make sure the deployer is installed and ~/bashrc is sourced!"
    exit_failure
fi

if ! dir_exists $GL_TERRA_ENV_PATH; then
    error "$GL_TERRA_ENV_PATH not found!!! Make sure the deployer is installed and ~/bashrc is sourced!"
    exit_failure
fi

# -- install the terraform configurations --


# install the terramform id configurations
if file_exists $GL_TERRA_ENV_PATH/terraform_id.bashrc; then
    warning "Terraform ID Bashrc (~/$GL_TERRA_ENV_PATH/terraform_id.bashrc) already exists, not overwritting. Delete the file to reset."
else
    text "Installing Terraform ID Bashrc (~/$GL_TERRA_ENV_PATH/terraform_id.bashrc)... MAKE SURE TO FILL OUT DEFAULT VALUES!"
    cp $SUBT_OPERATIONS_PATH/azurebooks/.template/.terraform_id.bashrc $GL_TERRA_ENV_PATH/terraform_id.bashrc
fi

# install the terramform flags configurations

if file_exists $GL_TERRA_ENV_PATH/terraform_flags.bashrc ; then
    warning "Terraform Flags Bashrc (~/$GL_TERRA_ENV_PATH/terraform_flags.bashrc) already exists. Copying existing config to ~/$GL_TERRA_ENV_PATH/terraform_flags.bashrc.bkp."
    text
    mv $GL_TERRA_ENV_PATH/terraform_flags.bashrc $GL_TERRA_ENV_PATH/terraform_flags.bashrc.bkp
fi
text "Installing Terraform Flags Bashrc (~/$GL_TERRA_ENV_PATH/terraform_flags.bashrc)."
cp $SUBT_OPERATIONS_PATH/azurebooks/.template/.terraform_flags.bashrc $GL_TERRA_ENV_PATH/terraform_flags.bashrc

text "Terraform: Make sure to run \`source ~/.bashrc\` or \`source ~/.zshrc\` to update your environment every time you change the variables!"

exit_success
