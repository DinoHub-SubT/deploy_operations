#!/usr/bin/env bash
eval "$(cat $(dirname "${BASH_SOURCE[0]}")/header.sh)"

if chk_flag --help $@; then
    title "subtf_apply.sh [ args ]: simply runs terraform apply in the azurebooks/subt directory, args are passed to terraform."
    terraform apply $@
    exit 0
fi

cd $__dir/../subt

terraform apply $@

cd $__call_dir