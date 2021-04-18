##
# source the terraform environment variables
##
function source_terra_env() {
    local GL_TERRA_ENV_PATH=$SUBT_CONFIGURATION_PATH

    # source the terraform env
    if ! file_exists $GL_TERRA_ENV_PATH/terraform_id.bashrc ]; then
        warning "[ $GL_TERRA_ENV_PATH/terraform_id.bashrc ] does not exist..., this command might not work..."
    else
        source $GL_TERRA_ENV_PATH/terraform_id.bashrc
    fi

    if ! file_exists $GL_TERRA_ENV_PATH/terraform_flags.bashrc; then
        warning "[ $GL_TERRA_ENV_PATH/terraform_flags.bashrc ] does not exist..., this command might not work..."
    else
        source $GL_TERRA_ENV_PATH/terraform_flags.bashrc
    fi
}
