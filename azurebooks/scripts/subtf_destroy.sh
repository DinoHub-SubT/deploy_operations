#!/usr/bin/env bash

# include headers
eval "$(cat $(dirname "${BASH_SOURCE[0]}")/header.sh)"
. "$SUBT_PATH/operations/scripts/header.sh"
. "$SUBT_PATH/operations/scripts/formatters.sh"

if chk_flag --help $@ || chk_flag -h $@ || chk_flag -help $@; then
    title "$__file_name [ args ]: simply runs terraform destroy in the azurebooks/subt directory, args are passed to terraform."
    terraform apply $@
    exit 0
fi

# source the terraform environment
source_terra_env

cd $__dir/../subt

terraform destroy $@

cd $__call_dir
