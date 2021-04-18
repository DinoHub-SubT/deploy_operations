#!/usr/bin/env bash

# load header helper functions
. "$SUBT_PATH/operations/scripts/header.sh"
. "$SUBT_PATH/operations/scripts/formatters.sh"

if chk_flag --help $@ || chk_flag help $@ || chk_flag -h $@; then
  GL_TEXT_COLOR=$FG_LCYAN
  text
  title "Usage: $(basename $0) [ flag1 ] [ flag2 ] < container1 >  < container2 > ...  "
  text_color "Flags:"
  text_color "      -h      : shows usage message."
  text_color "      -r      : azure resource group name"
  text_color "      -a      : azure storage account name"
  text_color "      -c      : azure storage container name"
  text_color "      -f      : azure storage container's file or folder name"
  text_color "      -p      : localhost src or dest path"
  text_color "      -up     : flag to indicate a data upload"
  text_color "      -down   : flag to indicate a data download"
  text_color
  text_color "Boostrap script for tmux before_script calls. Used to start or stop containters."
  text_color "For more help, please see the README.md or wiki."
  GL_TEXT_COLOR=$FG_DEFAULT
  exit_success
fi

# setup some default azure account globals
GL_RESOURCE_GROUP_NAME=subt
GL_STORAGE_ACCOUNT_NAME=subtdatasets
GL_CONTAINER_NAME=docker
GL_DATA_PATH="*"
GL_LOCALHOST_PATH="$(pwd)"
GL_DEFAULT_EXPIRE_TIME="60 minutes"

##
# @brief create the sas token for the storage account
##
azcopy_create_sas_token() {

  # get the storage account keys, for the storage account
  storage_account_key=$(az storage account keys list \
  -g $GL_RESOURCE_GROUP_NAME \
  --account-name $GL_STORAGE_ACCOUNT_NAME \
  --query "[0].value" \
  --output tsv)

  # setup the time start and expire times for sas token
  sas_date_start=$(date -u -d "-1 day" '+%Y-%m-%dT%H:%M:%SZ')
  sas_date_expire=$(date -u -d "$GL_DEFAULT_EXPIRE_TIME" '+%Y-%m-%dT%H:%M:%SZ')

  storage_account_sas_token=$(az storage account generate-sas \
  --account-name $GL_STORAGE_ACCOUNT_NAME \
  --account-key $storage_account_key \
  --start $sas_date_start \
  --expiry $sas_date_expire \
  --https-only \
  --resource-types sco \
  --services b \
  --permissions dlrw -o tsv | sed 's/%3A/:/g;s/\"//g')

  echo $storage_account_sas_token
}

##
# @brief transfer data from azure, using azcopy, via sas token
##
azcopy_transfer_data() {
  azcopy_transfer_data="azcopy cp "\"${1}"\" "\"${2}"\" \
  --recursive"
  warning "Executing... ${azcopy_transfer_data}"
  eval $azcopy_transfer_data
}

# //////////////////////////////////////////////////////////////////////////////
# @brief: script main entrypoint
# //////////////////////////////////////////////////////////////////////////////
main Azure Storage Account Data Transfer

# reset the resource group name
if chk_flag -r $@; then
  GL_RESOURCE_GROUP_NAME=$(get_arg -r $@)
fi

# reset the storage account name
if chk_flag -a $@; then
  GL_STORAGE_ACCOUNT_NAME=$(get_arg -a $@)
fi

# reset the storage container name
if chk_flag -c $@; then
  GL_CONTAINER_NAME=$(get_arg -c $@)
fi

# reset the storage account name
if chk_flag -f $@; then
  GL_DATA_PATH=$(get_arg -f $@)
fi

# reset the storage account name
if chk_flag -p $@; then
  GL_LOCALHOST_PATH=$(get_arg -p $@)
fi

# setup the azure transfer path
az_transfer_path="https://$GL_STORAGE_ACCOUNT_NAME.blob.core.windows.net/${GL_CONTAINER_NAME}/${GL_DATA_PATH}?$(azcopy_create_sas_token)"

# verify given correct azure transfer direction
if ! chk_flag --up $@ && ! chk_flag --down $@; then
  error "Error: please provide a azure transfer direction (--up for upload or --down for download)."
  exit_failure

# download the remote azure directory to the localhost path
elif chk_flag --down $@; then
  azcopy_transfer_data $az_transfer_path $GL_LOCALHOST_PATH

# upload the localhost data to remote azure directory
else
  azcopy_transfer_data $GL_LOCALHOST_PATH/${GL_DATA_PATH} $az_transfer_path
fi

# cleanup & exit
exit_success

