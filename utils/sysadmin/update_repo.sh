#!/bin/bash
__dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
__file="${__dir}/$(basename "${BASH_SOURCE[0]}")"

__verbosity=0
for var in "$@"; do
    if [ "$var" == "-v" ]; then
        __verbosity=$((++verbosity))
    fi
done


function update_operations() {
    cache_dir=$(pwd)
    cd $__dir/src

    # clone the submodules
    git submodule update --recursive --init operations
    cd $cache_dir
}

function update_common() {
    cache_dir=$(pwd)
    cd $__dir/src
    # clone the submodules
    git submodule update --recursive --init common

    # check the git status (please do this step and wait until command is completed)
    git status

    # checkout the git-lfs files
    cd common/communication_manager
    git lfs fetch
    git lfs pull
    cd $cache_dir
}

function update_central_launch() {
    cache_dir=$(pwd)
    cd $__dir/src
    # clone the submodules
    git submodule update --recursive --init subt_launch

    # check the git status (please do this step and wait until command is compl$
    git status
    cd $cache_dir
}

function update_basestation() {
    cache_dir=$(pwd)
    cd $__dir/src
    # clone the submodules
    git submodule update --recursive --init basestation

    # check the git status (please do this step and wait until command is completed)
    git status
    cd $cache_dir
}

function update_ugv() {
    cache_dir=$(pwd)
    cd $__dir/src
    # clone the submodules
    git submodule update --init ugv

    # check the git status (please do this step and wait until command is completed)
    git status

    cd ugv/
    git submodule update --init --recursive planning-pc/
    git submodule update --init --recursive nuc/


    git submodule update --init --recursive hardware
    cd $cache_dir
}

function update_uav() {
    cache_dir=$(pwd)
    cd $__dir/src

    # clone the submodules
    git submodule update --init uav

    # check the git status (please do this step and wait until command is completed)
    cd uav/

    git submodule update --init --recursive core

    git status
    cd $cache_dir
}

function update_perception() {
    cache_dir=$(pwd)
    cd $__dir/src
    
    # clone the submodules
    git submodule update --recursive --init perception

    # check the git status (please do this step and wait until command is completed)
    git status

    cd $cache_dir
}

function update_simulation() {
    cache_dir=$(pwd)
    cd $__dir/src

    # clone the submodules
    git submodule update --recursive --init simulation

    # check the git status (please do this step and wait until command is compl$
    git status

    cd simulation/subt_gazebo
    git lfs fetch
    git lfs pull

    cd $cache_dir
}

function update_all() {
    update_operations
    update_common
    update_central_launch
    update_basestation
    update_ugv
    update_uav
    update_perception
}

function update_ugv1_ansible() {
    cache_dir=$(pwd)
    cd $__dir/src/operations/deploy/robotbooks

    ansible-playbook -v -i inventory/azure.ini install-azure.yaml --limit azure-ugv1

    cd $cache_dir
}

function update_basestation_ansible() {
    cache_dir=$(pwd)
    cd $__dir/src/operations/deploy/robotbooks

    ansible-playbook -v -i inventory/azure.ini install-azure.yaml --limit azure-basestation

    cd $cache_dir
}

function update_perception_ansible() {
    cache_dir=$(pwd)
    cd $__dir/src/operations/deploy/robotbooks

    ansible-playbook -v -i inventory/azure.ini install-azure.yaml --limit azure-perception1

    cd $cache_dir
}

function build_docker_basestation() {
    cache_dir=$(pwd)
    cd $__dir/src/

    ./deployer -s azure.basestation.vm.compose.compose.docker.image
    ./deployer -r azure.basestation.cpu.docker.shell


    cd $cache_dir
}

function build_docker_ugv1() {
    cache_dir=$(pwd)
    cd $__dir/src/

    ./deployer -s azure.ugv1.vm.compose.compose.docker.image -a
    ./deployer -s azure.ugv1.vm.compose.compose.docker.shell -a

    cd $cache_dir
}

function build_docker_perception() {
    cache_dir=$(pwd)
    cd $__dir/src/

    ./deployer -s azure.perception1.vm.compose.compose.docker.image
    ./deployer -s azure.perception1.vm.compose.compose.docker.shell

    cd $cache_dir
}

function build_code_basestation() {
    cache_dir=$(pwd)
    cd $__dir/src/

    ./deployer -r azure.basestation.cpu.catkin.gui.clean
    ./deployer -r azure.basestation.cpu.catkin.gui.build

    cd $cache_dir
}

function build_code_ugv1() {
    cache_dir=$(pwd)
    cd $__dir/src/

    ./deployer -r azure.ugv1.catkin.clean
    ./deployer -r azure.ugv1.catkin.build

    cd $cache_dir
}

function build_code_perception() {
    cache_dir=$(pwd)
    cd $__dir/src/

    ./deployer -r azure.perception1.gpu.catkin.clean
    ./deployer -r azure.perception1.gpu.catkin.build

    cd $cache_dir
}

function update_all_ansible() {
    update_ugv1_ansible
    update_basestation_ansible
}

function build_docker_all {
    build_docker_basestation
    build_docker_ugv1
    build_docker_perception
}

function build_code_all {
    build_docker_basestation
    build_docker_ugv1
    build_docker_perception
}

function do_perception_all {
    update_perception_ansible
    build_docker_perception
    build_code_perception
}

function do_basestation_all {
    update_basestation_ansible
    build_docker_basestation
    build_code_basestation
}

function do_ugv_all {
    update_ugv_ansible
    build_docker_ugv
    build_code_ugv
}


if [ $# != 0 ]; then
    arg=$1
    if [ "$arg" == "repo" ]; then
        update_all
    elif [ "$arg" == "ansible" ]; then
        update_all_ansible
    elif [ "$arg" == "docker" ]; then
        build_docker_all
    elif [ "$arg" == "basestation" ]; then
        do_basestation_all
    elif [ "$arg" == "perception" ]; then
        do_perception_all
    elif [ "$arg" == "docker" ]; then
        do_ugv_all
    fi
fi
