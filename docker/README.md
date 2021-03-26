# Docker and Tools

*Docker & Tools* can be installed on an **ARM** or **x86** system.

- Different systems have different instructions. Please see your systems' relevant install instructions.

Please have a basic understanding of the following the docker tools:

- [Docker](https://docs.docker.com/get-started/)
- [Docker Compose (optional)](https://docs.docker.com/compose/)
- [Docker Context (optional)](https://docs.docker.com/engine/context/working-with-contexts/)

**Table Of Contents**

[TOC]

* * *

# System Requirements

- *At minimum*:
    - x86: Ubuntu 16.04
    - arm: Ubuntu 16.04
- Internet connection

# Installation

## System x86

- An example x86 system would be your local laptop.

### Install Docker

1. Remove old versions of Docker

    `sudo apt-get remove docker docker-engine docker.io`

2. Install dependencies and keys

    `sudo apt install curl apt-transport-https ca-certificates curl software-properties-common`

3. Add the official GPG key of Docker

        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
        sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

4. Install Docker

    `sudo apt-get update && sudo apt-get install docker-ce`

5. Add your user to the docker group:

    `sudo usermod -a -G docker $USER`

    - logout-log-back-in for the changes to take effect

6. Verify your Docker installation

    * **Please** do not run with `sudo docker`. Go back to Step 5 if you still cannot run as a non-root user.

    *To verify if `docker` is installed:*

    `docker -v`

    *Try running a sample container:*

    `sudo docker run hello-world`

    - You should see the message *Hello from Docker!* confirming that your installation was successfully completed.

### Docker Compose

1. Download current stable release of *docker compose*

        sudo apt-get update
        sudo apt-get install -y --no-install-recommends curl
        sudo curl -L "https://github.com/docker/compose/releases/download/1.24.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

2. Apply executable permissions to the binary

        sudo chmod +x /usr/local/bin/docker-compose
        sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

3. Test docker compose install

        docker-compose --version

### Install NVIDIA Docker

* **Proceed with the below instructions only if you have a NVidia GPU.**

1. Remove old version of Nvidia Docker

        docker volume ls -q -f driver=nvidia-docker | xargs -r -I{} -n1 docker ps -q -a -f volume={} | xargs -r docker rm -f

2. Install NVIDIA Docker

        sudo apt-get purge -y nvidia-docker

3. Setup the NVIDIA Docker Repository

        curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
        distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
        curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list
        sudo apt-get update

4. Install NVIDIA Docker (version 2):

        sudo apt-get install -y nvidia-docker2

5. Restart the Docker daemon

        sudo service docker restart

6. Verify the installation:

    *To verify if `nvidia-docker` is installed:*

    `nvidia-docker -v`

    *Try running a sample container:*

    `docker run --runtime=nvidia --rm nvidia/cuda nvidia-smi`

    - The docker image `nvidia/cuda` requires a recent CUDA version. If you have an earlier CUDA version, then [find a tag](https://hub.docker.com/r/nvidia/cuda/tags) with an earlier version.
        - Example: `docker pull nvidia/cuda:8.0-runtime` and then run the `docker run` command with the `nvidia/cuda:8.0-runtime` image.

    - This command should print your GPU information.

#### Enable NVidia Docker


1. Test NVIDIA Docker runntime is enabled:

        docker run --runtime=nvidia --rm nvidia/cuda nvidia-smi

2. If NVIDIA docker fails to run, with the following error message: `Unknown runtime specified nvidia`

    - Systemd drop-in file

            sudo mkdir -p /etc/systemd/system/docker.service.d
            sudo tee /etc/systemd/system/docker.service.d/override.conf <<EOF
            [Service]
            ExecStart=
            ExecStart=/usr/bin/dockerd --host=fd:// --add-runtime=nvidia=/usr/bin/nvidia-container-runtime
            EOF
            sudo systemctl daemon-reload
            sudo systemctl restart docker

    - Daemon configuration file

            sudo tee /etc/docker/daemon.json <<EOF
            {
            "runtimes": {
                    "nvidia": {
                    "path": "/usr/bin/nvidia-container-runtime",
                    "runtimeArgs": []
                    }
            }
            }
            EOF
            sudo pkill -SIGHUP dockerd

    - Try NVIDIA runntime argument again:

            docker run --runtime=nvidia --rm nvidia/cuda nvidia-smi

## System ARM

- An example ARM system would be an NVIDIA Jetson Xavier.

### Install Docker

1. Install Docker

        sudo apt-get update
        sudo apt-get install curl
        curl -fsSL test.docker.com -o get-docker.sh && sh get-docker.sh

2. Add your user to the docker group

        sudo usermod -aG docker $USER

3. Reboot your system.

        sudo reboot -h now

4. Build an example docker image

        docker run hello-world

- Do not run `docker` with `sudo`...

### Docker Compose

There is [no offical](https://github.com/docker/compose/issues/6188) docker-compose binary for ARM, so docker-compose must be install using `python-pip`.

1. Install latest python & python pip packages

        sudo apt-get update
        sudo apt install -y --no-install-recommends python python-setuptools python-pip

2. Install docker-compose dependencies

        sudo apt install -y --no-install-recommends libssl-dev libffi-dev python-backports.ssl-match-hostname

3. Install docker-compose

        sudo pip install docker-compose

### Install NVIDIA Docker

Currently, `nvidia-docker` install is done.

Instead, `docker run` will pass the NVIDIA `/dev` devices to docker as arguments.
  - See [here](https://github.com/Technica-Corporation/Tegra-Docker) for more details.

To test out that docker NVIDIA passthu works, please try out the following:

1. Build deviceQuery on local system

        cd /usr/local/cuda/samples/1_Utilities/deviceQuery/
        make -j8
        ./deviceQuery

  * Make sure you **do not** see:

                cudaGetDeviceCount returned 35
                -> CUDA driver version is insufficient for CUDA runtime version
                Result = FAIL

2. Copy deviceQuery executable to the subt docker build context

        cp /usr/local/cuda/samples/1_Utilities/deviceQuery/deviceQuery ${SUBT_PATH}/deploy/docker/dockerfiles/cuda/arm/deviceQuery

3. Build the docker `deviceQuery` image

        docker-compose-wrapper --env arch=arm -f dockerfiles/cuda/cuda.yml build deviceQuery

4. Run the docker `deviceQuery` image

        docker-compose-wrapper --env arch=arm -f dockerfiles/cuda/cuda.yml up deviceQuery

* * *

# Folder Organization

deploy (meta-repo) [submodule]

    operations/docker/

      docker-compose.yml
        * This is the top level docker compose entrpypint.
        * All docker services extend on one of base services listed in this top level docker compose.

      scripts/
        * helper scripts to hide details from the user docker-compose
        * these scripts are added to the user's path, so they can be run from anywhere

      dockerfiles/
        * maintains specific project services' docker-compose.ymls & dockerfiles

        entrypoints/
          * maintains docker images' entrypoint scripts

        thirdparty-software/
          * maintains configuration files (used during docker build) for thirdparty packages.
          * placeholder folder (in the docker context) for third-party packages to be copied into docker build steps

        basestation/ (example)
          * specific project service -- the basestation service

          docker-compose.yml
            * project service contains its own top level docker-compose.yml -- this file extends services found in the base docker-compose.yml

          services/
            * maintains a dockerfile for each service in this project

            ros-cpu.dockerfile
            basestation-cpu.dockerfile
            ...

        ...

* * *

# Docker Services With Docker Compose

## About

**Project Services**

The project services must list multiple docker-compose.ymls to be extended.

- Since this can become tiresome to write out, the docker compose wrapper script `docker-compose-wrapper` is available to hide these details.

**Scenario Files**

The docker compose files are expecting environment variables, which are variables that become substituted inside the `docker-compose.yml` files.

- The user can manually set these env variables either directly on the terminal or in a bash script that exports these variables.

- The `docker-compose-wrapper` takes in a file as an user argument, called a *scenario* file.

    - Scenario files explicitly export env variable that the `docker-compose.yml` files are expecting.
    - Scenario files are found in: `operations/scenarios`
    - Example scenario file: `operations/scenarios/systems/azure/basestation-cpu.env`

## Docker Compose Wrapper

The docker compose wrapper, hides the implementation details of extending multiple `docker-compose.yml` files.

The docker-compose-wrapper runs from the relative path: `operations/docker/dockerfiles`

- Scenario files that are required as an argument, look in the relative path: `operations/scenarios`

## Example: Build Docker Images

**Usage:**

    docker-compose-wrapper --scenario systems/azure/basestation-cpu build --force-rm ros-cpu-image

**Usage Help:**

    docker-compose-wrapper --scenario [scenario file path] [build or config] [extra docker compose build arguments] [docker compose service name]

**Where the above wrapper performs the following command:**

    Command: docker-compose -f docker-compose.yml -f dockerfiles/basestation//docker-compose.yml  build --force-rm ros-cpu-image

    Scenario: systems/azure/basestation-cpu

**Discussion:**

There are two docker-compose.yml files being extend: `docker-compose.yml` and `dockerfiles/basestation//docker-compose.yml`

The environment variables that get set for the `docker-compose.yml` to use are found in the scenario file: `systems/azure/basestation-cpu.env`

The docker compose `build` command indicates that the docker images listed for the services `ros-cpu-image` will be built.

## Example: Create Docker Containers


**Usage:**

    docker-compose-wrapper --scenario systems/azure/basestation-cpu -p basestation-cpu-shell up --force-recreate -d basestation-cpu-shell

**Usage Help:**

    docker-compose-wrapper --scenario [scenario file path] -p [any unique name] up [extra docker compose up arguments] [docker compose service name]

**Where the above wrapper performs the following command:**

    Command: docker-compose -f docker-compose.yml -f dockerfiles/basestation//docker-compose.yml -p basestation-cpu-shell up --force-recreate -d basestation-cpu-shell

    Scenario: systems/azure/basestation-cpu

**Discussion:**

There are two docker-compose.yml files being extend: `docker-compose.yml` and `dockerfiles/basestation//docker-compose.yml`

The environment variables that get set for the `docker-compose.yml` to use are found in the scenario file: `systems/azure/basestation-cpu.env`

The docker compose `up` command indicates that the docker containers listed for the services `ros-cpu-shell` will be started.
