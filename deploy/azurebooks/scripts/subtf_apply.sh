#!/usr/bin/env bash
eval "$(cat $(dirname "${BASH_SOURCE[0]}")/header.sh)"

if chk_flag --help $@ || chk_flag -h $@ || chk_flag -help $@; then
    title "$__file_name [ args ]: simply runs terraform apply in the azurebooks/subt directory, args are passed to terraform."
    terraform apply $@
    exit 0
fi

# source the terraform environment
source_terra_env

cd $__dir/../subt

terraform apply $@

cd $__call_dir
