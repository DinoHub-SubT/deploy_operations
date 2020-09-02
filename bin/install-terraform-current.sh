#!/bin/bash
# This script will update the terraform bash scripting to contain the correct variables
# Joshua Spisak <joshs333@live.com>
# Jul 7, 2020
if [ -z "$SUBT_PATH" ]; then
    echo "SUBT_PATH not found!!! Make sure the deployer is installed and ~/bashrc is sourced!"
    exit 1
fi

if [ "$1" == "--help" ]; then
    echo "Usage: install-terraform-current.sh"
    echo
    echo "Installs the current terraform bashrc's to ~/"
    exit 0
fi

if [ -e $HOME/.terraform_id.bashrc ]; then
    echo "Terraform ID Bashrc (~/.terraform_id.bashrc) already exists.. not overwritting. Delete the file to reset."
else
    echo "Installing Terraform ID Bashrc (~/.terraform_id.bashrc)... MAKE SURE TO FILL OUT DEFAULT VALUES!"
    cp $SUBT_PATH/operations/deploy/azurebooks/.default_terraform_bash/.terraform_id.bashrc $HOME/.terraform_id.bashrc
fi

grep -q "# source .terraform_id.bashrc" $HOME/.bashrc
if [ "$?" == "1" ]; then
    echo "Making ~/.bashrc source ~/.terraform_id.bashrc"
    echo "source ~/.terraform_id.bashrc # source .terraform_id.bashrc" >> $HOME/.bashrc
fi

if [ -e $HOME/.zshrc ]; then
    grep -q "# source .terraform_id.bashrc" $HOME/.zshrc
    if [ "$?" == "1" ]; then
        echo "Making ~/.zshrc source ~/.terraform_id.bashrc"
        echo "source ~/.terraform_id.bashrc # source .terraform_id.bashrc" >> $HOME/.zshrc
    fi
fi

echo

if [ -e $HOME/.terraform_flags.bashrc ]; then
    echo "Terraform Flags Bashrc (~/.terraform_flags.bashrc) already exists. Copying existing config to ~/.terraform_flags.bashrc.bkp before copying over default .terraform_flags.bashrc"
    echo
    mv $HOME/.terraform_flags.bashrc $HOME/.terraform_flags.bashrc.bkp
fi
echo "Installing Terraform Flags Bashrc (~/.terraform_flags.bashrc)."
cp $SUBT_PATH/operations/deploy/azurebooks/.default_terraform_bash/.terraform_flags.bashrc $HOME/.terraform_flags.bashrc

grep -q "# source .terraform_flags.bashrc" $HOME/.bashrc
if [ "$?" == "1" ]; then
    echo "Making ~/.bashrc source ~/.terraform_flags.bashrc"
    echo "source ~/.terraform_flags.bashrc # source .terraform_flags.bashrc" >> $HOME/.bashrc
fi

if [ -e $HOME/.zshrc ]; then
    grep -q "# source .terraform_flags.bashrc" $HOME/.zshrc
    if [ "$?" == "1" ]; then
        echo "Making ~/.zshrc source ~/.terraform_flags.bashrc"
        echo "source ~/.terraform_flags.bashrc # source .terraform_flags.bashrc" >> $HOME/.zshrc
    fi
fi

echo
echo "Make sure to run \`source ~/.bashrc\` or \`source ~/.zshrc\` to update your environment every time you change the variables!"
