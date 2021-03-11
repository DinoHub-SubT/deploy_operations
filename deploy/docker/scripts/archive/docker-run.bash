#!/usr/bin/env bash
# //////////////////////////////////////////////////////////////////////////////
# display usage
usage_msg="\
Usage: $(basename $0)
options:
  * optional arguments are enclosed in square brackets

  --config <config-file>
      load the project config file
  [--preview]
      preview docker build command; docker build is not called
  [--no-nvidia]
      system does not contain an nvidia gpu;

  Creates a docker container from a specified docker image & starts it.

For more help, please see the README.md or wiki."

# //////////////////////////////////////////////////////////////////////////////
# load scripts

# get filename prefix (for per-project docker build)
prefix="$( cut -d '_' -f 1 <<< "$(basename $0)" )"
if [[ "${prefix}" != "$(basename $0)" ]]; then
  # prefix is set, calling from install script
  prefix="${prefix}_";
else
  # prefix is not set, calling script directly -- not from installed
  prefix=""
fi;

# load print-info
. "$(dirname $0)/${prefix}docker-utils.bash"
validate "load utils failed"

# load args
. "$(dirname $0)/${prefix}docker-args.bash"
validate "load utils failed"

# display usage message
is_display_usage "$usage_msg"

# verify env arg was set
verify_arg "$config" "Error: option '--config' must be given." "$usage_msg"

# load the env config file
script_path="$(dirname $(realpath $0))/../../dockerfiles/"
. "$script_path/$config"
validate "load config file, '$config' failed"

# validate all the config env variables have been set
validate_env_config

# set some local variables
env_path="$(dirname $script_path/$config.config)"
dockerfile_file_path="$script_path/../dockerfiles/$DOCKERFILE_PATH"
dockerfile_path="$(dirname $dockerfile_file_path)"

# prints
divider_large
title "Create: Docker Container"

# //////////////////////////////////////////////////////////////////////////////
# docker container setup

# get the directory of this script -- "build.bash"
script_path="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
pushd $script_path  # go so script path

# use nvidia, i.e. no_nvidia is unset. keep the large space.
[[ -z "$no_nvidia" ]] && {  opts="--runtime=nvidia     ${opts}"; }

# debug
[[ "$debug" ]] && { print_env; print_image_info; }

# get the image name
set_docker_image

# subt:
  # Make sure processes in the container can connect to the x server
  # Necessary so gazebo can create a context for OpenGL rendering (even headless)
XAUTH=/tmp/.docker.xauth
if [ ! -f $XAUTH ]
then
  xauth_list=$(xauth nlist :0 | sed -e 's/^..../ffff/')
  if [ ! -z "$xauth_list" ]
  then
    echo $xauth_list | xauth -f $XAUTH nmerge -
  else
    touch $XAUTH
  fi
  chmod a+r $XAUTH
fi

# container create command
dcreate="\
  docker run
    -it
    -e DISPLAY
    -e QT_X11_NO_MITSHM=1
    -e XAUTHORITY=$XAUTH
    -v "$XAUTH:$XAUTH"
    -v "/tmp/.X11-unix:/tmp/.X11-unix"
    -v "/etc/localtime:/etc/localtime:ro"
    -v "/dev/input:/dev/input"
    --privileged
    --name=$CONTAINER
    --security-opt seccomp=unconfined
    $RUN_OPTIONS
    $opts
    $image"

# container start command
dstart="docker start $CONTAINER"

# //////////////////////////////////////////////////////////////////////////////
# docker container creation

# check if container exists
if [[ "$(docker ps -a --format '{{.Names}}' | grep -x $CONTAINER)" == "" ]]; then
  # create the docker container
  warning "Docker container: '$CONTAINER' does not exist, creating new container."
  display_text "$dcreate"
  # create & start the container
  if [ $text == false ]; then eval $dcreate; fi
  validate "docker create command failed."
else
  warning "Docker container, '$CONTAINER' already exists, only starting the container."
fi

# start the container
newline
text "docker start: " "$dstart"
if [ $text == false ]; then eval $dstart; fi
validate "docker start command failed."

# cleanup & exit
popd
exit_success

