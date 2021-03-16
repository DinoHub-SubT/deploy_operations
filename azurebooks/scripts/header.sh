##
# source the terraform environment variables
##
function source_terra_env() {
    # source the terraform env
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
}
