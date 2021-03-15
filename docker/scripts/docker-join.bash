#!/usr/bin/env bash

# load header helper functions
. "$SUBT_PATH/operations/scripts/.header.bash"
. "$SUBT_PATH/operations/scripts/automate/.header.bash"
. "$SUBT_PATH/operations/azurebooks/scripts/header.sh"

if chk_flag --help $@ || chk_flag help $@ || chk_flag -h $@; then
  GL_TEXT_COLOR=$FG_LCYAN
  text
  title "Usage: $(basename $0) [flag] [ optional docker join options ] "
  text_color "Flags:"
  text_color "      -help                     : shows usage message."
  text_color "      --preview                 : preview the docker join command."
  text_color "      --name [ container name ] : joins the docker container with given name as an argument."
  text_color "Joins the docker container. Call $(basename $0) script multiple times to join the same container."
  text_color "For more help, please see the README.md or wiki."
  GL_TEXT_COLOR=$FG_DEFAULT
  exit_success
fi

# //////////////////////////////////////////////////////////////////////////////
# @brief: script main entrypoint
# //////////////////////////////////////////////////////////////////////////////

title " \n\n == Docker Join == \n\n"

# verify user has given the '--name' flag
if ! chk_flag --name $@ && ! chk_flag -n $@; then
  error "Docker joing missing flag and argument as such: '--name [container name]' . "
  xhost -
  exit_failure;
fi

# get the directory of this script -- "build.bash"
script_path="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
pushd $script_path  # go so script path

# access control disabled, clients can connect from any host
xhost +

# get the docker container name
if chk_flag --name $@; then
  docker_container=$(get_arg --name $@)
else
  docker_container=$(get_arg -n $@)
fi

# verify the docker container exists
if [[ "$(docker ps -a | grep ${docker_container})" == "" ]]; then
  error "Docker container, '${docker_container}' does not exist. "
  xhost -
  exit_failure;
fi

# prepare: start the docker container
docker_start_command="docker start ${docker_container}"

# start the container
if [[ "$(docker inspect -f {{.State.Running}}  $CONTAINER)" == false ]]; then
  warning "Docker container, '${docker_container}' is not started, starting the container."
  # preview the docker start command
  subtitle "docker start: " "${docker_start_command}"

  # execute the docker start command, if not in 'preview' mode
  if ! chk_flag --preview $@ && ! chk_flag -p $@; then
    eval ${docker_start_command}
  fi
fi

# prepare: docker execute /bin/bash to the docker container (with default below options)
docker_execute_command="docker exec
  --privileged
  -e DISPLAY=${DISPLAY}
  -e LINES=`tput lines`
  -e ROBOT=${ROBOT}
  ${JOIN_OPTIONS}
  -it ${docker_container} /bin/bash"

# preview the docker exec command
subtitle "${docker_execute_command} "
subtitle
title "== SubT Docker Container == \n "
subtitle "!! You are inside the docker container '${docker_container}' !! "
newline
subtitle "Catkin: \n"
subtitle "  - Your catkin workspace should be automatically sourced. \n"
subtitle "  - If not, check that you have build the workspace. "
newline
subtitle "Docker Networking: \n"
subtitle "  - Simulation containers have their own IP.\n"
subtitle "  - Robot containers use the roobot computer host's networking. \n"
subtitle "  - You should be able to ping any of the IPs from your localhost (outside docker) or from any other container (inside docker). "
newline
subtitle "Directories: \n "
subtitle "  - The deploy workspace is mounted inside the container. \n"
subtitle "  - So you can edit files in 'deploy_ws' using your editor and see the changes inside the container. \n"
subtitle "  - To add other files inside the container, just add to 'deploy_ws' and will see the files inside the container. "
newline
subtitle "For more information, please see readme. \n"
newline

# execute the docker exec command, if not in 'preview' mode
if ! chk_flag --preview $@ && ! chk_flag -p $@; then
  eval ${docker_execute_command}
fi

# cleanup & exit
# access control enabled, only authorized clients can connect
newline
xhost -
# cleanup & exit
exit_on_success
