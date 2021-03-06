#!/bin/bash

# include headers
. "$SUBT_PATH/operations/scripts/header.sh"
. "$SUBT_PATH/operations/scripts/formatters.sh"

# help message
if chk_flag --help $@ || chk_flag help $@ || chk_flag -h $@ || chk_flag -help $@; then
  title "$__file_name -p [bags logging path]"
  GL_TEXT_COLOR=$FG_LCYAN
  text_color "Flags:"
  text_color " 	-p	: logging path with bags to transfer (if not given use current working directory)."
  GL_TEXT_COLOR=$FG_DEFAULT
  exit_success
fi

# create a main title and catch ctrl-c actions
main azurebags

# get the logging path with bags to transfer (if not given use current working directory)
path=$(pwd)
if chk_flag -p $@; then
	path=$(get_arg -p $@)
fi

# check if the directory exists
if ! dir_exists $path; then
	error "Failed to transfer: directory $path does not exist"
	exit_failure
fi

export AZCOPY_SPA_CLIENT_SECRET=~GvAI1eI_H13P21E.I5-0FL_UMiFpRuz4N
azcopy login --service-principal  --application-id 466f5541-f74b-4b1c-88eb-1d33aa2a5869 --tenant-id=353ab185-e593-4dd3-9981-5ffe7f5d47eb

for FILENAME in $path/*; do
	# get the absoluate filepath
	FILENAME=$(realpath $path/$(basename $FILENAME))

	# remove the filename from the directory path, then find the date directory
	DIRECTORY=$(dirname $FILENAME)
	DIRECTORY=$(echo $DIRECTORY | grep -Eo '[[:digit:]]{4}-[[:digit:]]{2}-[[:digit:]]{2}')

	# make the directory on azure
	azcopy make https://subtdatasets.blob.core.windows.net/$DIRECTORY
	NORMAL_HOSTNAME=$(hostname)
	CAPITAL_HOSTNAME=${NORMAL_HOSTNAME^^}
	echo "$CAPITAL_HOSTNAME"

	# copy files to azure
	warning "transfering file: $FILENAME"
	warning "transfering to: https://subtdatasets.blob.core.windows.net/$DIRECTORY/$ROBOT/$COMPUTER/"
	azcopy copy $FILENAME https://subtdatasets.blob.core.windows.net/$DIRECTORY/$ROBOT/$COMPUTER/
done

# cleanup, exit success
exit_success
