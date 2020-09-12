#!/usr/bin/env bash
eval "$(cat $(dirname "${BASH_SOURCE[0]}")/header.sh)"

if chk_flag --help $@ || chk_flag help $@ || chk_flag -h $@ || chk_flag -help $@; then
    title "$__file_name [ args ]: simply runs terraform plan in the azurebooks/subt directory, args are passed to terraform."
    terraform plan $@
    exit 0
fi


if [ ! -e ~/.terraform_id.bashrc ]; then 
    echo "WARNING: [~/.terraform_id.bashrc] does not exist..., this command might not work..."
else
    source ~/.terraform_id.bashrc
fi

if [ ! -e ~/.terraform_flags.bashrc ]; then
    echo "WARNING: [~/.terraform_flags.bashrc] does not exist..., this command might not work..."
else
    source ~/.terraform_flags.bashrc
fi


cd $__dir/../subt

terraform plan $@

cd $__call_dir
