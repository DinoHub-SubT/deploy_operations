eval "$(cat $(dirname "${BASH_SOURCE[0]}")/header.sh)"

cd $__dir/../subt


# Echo the path to the state file variable into the terraform init command
echo "workspaces/${TF_VAR_azure_username}/terraform.tfstate" | terraform init

cd $__call_dir
