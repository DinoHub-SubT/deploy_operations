# Localhost Deployment Operation Tools

## Install Repository Dependencies

All system dependencies are written in dockerfiles.
  - docker image is a template, represented by a *built dockerfile*
  - docker container is an **instantiation of the docker image**

**Docker Image: Basestation**

        cd ~/deploy_ws/src
        ./deployer -s desktop.basestation.docker.image

**Docker Image: UGV: Planning-pc**

        cd ~/deploy_ws/src
        ./deployer -s desktop.ugv.ppc.docker.image

**Docker Image: UGV: NUC**

        cd ~/deploy_ws/src
        ./deployer -s desktop.ugv.nuc.docker.image

**Docker Image: UAV: Simulation**

        cd ~/deploy_ws/src
        ./deployer -s desktop.uav.sim.docker.image

## Staring Docker Containers

Any image has an associated container.

**Docker Container: Basestation**

        cd ~/deploy_ws/src
        ./deployer -s desktop.basestation.docker.shell

**Docker Container: UGV: Planning-pc**

        cd ~/deploy_ws/src
        ./deployer -s desktop.ugv.ppc.docker.shell

**Docker Container: UGV: NUC **

        cd ~/deploy_ws/src
        ./deployer -s desktop.ugv.nuc.docker.shell

**Docker Container: UAV: Simulation**

      cd ~/deploy_ws/src
      ./deployer -s desktop.uav.sim.docker.shell

- to view started containers, please do: `docker ps`
- to view all containers, please do: `docker ps -a`

## Access Docker Container

To enter the container, please do: `docker-join.bash --name [container-name]`

- to view started containers, please do: `docker ps`
- `docker-join` will be installed if you have followed the top level `README.md` correctly.

To launch the system, please refer to the repository's readme to launch.


## Build The Repositories

- Assuming you have already entered the docker container

**Example Launch: basestation**

        # build the common workspace
        cd ~/deploy_ws/src/common
        
        # set the correct catkin profile, all settings are already pre-defined
        catkin profile set system76-pc
        catkin build

        # build the basestation workspace
        cd ~/deploy_ws/src/basestation

        # all settings are already pre-defined
        catkin profile set system76-pc
        catkin build

**Example Launch: UGV:ppc**

        # build the common workspace
        cd ~/deploy_ws/src/common
        
        # set the correct catkin profile, all settings are already pre-defined
        catkin profile set ugv
        catkin build

        # build the ugv:ppc workspace
        cd ~/deploy_ws/src/ugv/planning-pc

        # all settings are already pre-defined
        catkin profile set ugv
        catkin build

**Example Launch: UGV:nuc**

        # build the common workspace
        cd ~/deploy_ws/src/common
        
        # set the correct catkin profile, all settings are already pre-defined
        catkin profile set ugv
        catkin build

        # build the ugv:nuc workspace
        cd ~/deploy_ws/src/ugv/nuc

        # all settings are already pre-defined
        catkin profile set ugv
        catkin build

**Example Launch: UAV:sim**

        # build the common workspace
        cd ~/deploy_ws/src/common
        
        # set the correct catkin profile, all settings are already pre-defined
        catkin profile set uav
        catkin build

        # build the uav:sim workspace
        cd ~/deploy_ws/src/uav/sim

        # all settings are already pre-defined
        catkin profile set sim
        catkin build

## Launch The Repositories

**Basestation**

        # enter the container
        docker-join.bash --name gui-shell

        # source the repository
        source ~/deploy_ws/devel/basestation/setup.bash

        # launch gui
        roslaunch basestation_launch basestation.launch

* * *

# Azure Deployment Operation Tools

Deploying dockerfiles on azure is a similar process as on a localhost.

Recommended way to do things is to go directly on the vm and apply the *Localhost Deployment Operation Tools* steps directly on the VM.

## Install System Dependencies

You will need to install some dependencies directly on the VM.

**Connect to your VM using VPN**

        # ssh into your VM
        ssh [username]@[private IP]

**Install Dependencies**

        # installing python 2.7 and pip
        sudo apt update
        sudo apt install python2.7 python-pip
        sudo apt-get update
        sudo apt install -y --no-install-recommends python python-setuptools python-pip
        pip2 install wheel --user
        pip2 install setuptools PyYAML pexpect --user

**Installing Docker**

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

**Installing Docker Compose**

1. Download current stable release of *docker compose*
   
        sudo apt-get update
        sudo apt-get install -y --no-install-recommends curl
        sudo curl -L "https://github.com/docker/compose/releases/download/1.24.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

2. Apply executable permissions to the binary

        sudo chmod +x /usr/local/bin/docker-compose
        sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

3. Test docker compose install
        
        docker-compose --version

**Remote Desktop**

Please see `operations/deploy/azurebooks/README.md` for how to install remote desktop dependencies.

## Remote Deploy Workspace

There are two options to develop. Either mount the deploy directory or do a rsync.

**Setup your host and ssh configuration files**

- Add the azure IPs to your `/etc/hosts` file.

- Add the ssh configuration:

        # Example ssh config setup
        vim ~/.ssh/config

        # add the below
        Host [ azure name alias]
          HostName [azure vm hostname]
          User [azure vm username]
          IdentitiesOnly yes
          IdentityFile [azure vm ssh key]

### (Option 1) Remote mount the deploy workspace

Please see [sshfs](https://github.com/libfuse/sshfs) on how to remote mount a directory.

### (Option 2) Transfer The Deploy Workspace

**Edit the scenario configuration files**

Change all the appropriate params in `operations/deploy/docker/scenarios/azure-[robot].env`

- example params: `user`, `host`, `ssh_config`, `LOCAL_DEPLOY_PATH`, `REMOTE_DEPLOY_PATH`

**Transfer the deploy repo to azure vm**

The `transfer.to` does a `rsync` to the azure vm. So any changes locally need to always be transfered.

        # transfer to the basestation
        ./deployer -s azure.basestation.transfer

        # transfer to the uav
        ./deployer -s azure.uav.transfer

        # transfer to the ugv
        ./deployer -s azure.ugv.transfer

## Install Repository Dependencies

**Docker Image: Basestation**

        cd ~/deploy_ws/src
        ./deployer -s azure.basestation.docker.image

**Docker Image: UGV: Planning-pc**

        cd ~/deploy_ws/src
        ./deployer -s azure.ugv.ppc.docker.image

**Docker Image: UGV: NUC**

        cd ~/deploy_ws/src
        ./deployer -s azure.ugv.nuc.docker.image

**Docker Image: UAV: Simulation**

        cd ~/deploy_ws/src
        ./deployer -s azure.uav.sim.docker.image

## Staring Docker Containers

Any image has an associated container.

**Docker Container: Basestation**

        cd ~/deploy_ws/src
        ./deployer -s azure.basestation.docker.shell

**Docker Container: UGV: Planning-pc**

        cd ~/deploy_ws/src
        ./deployer -s azure.ugv.ppc.docker.shell

**Docker Container: UGV: NUC **

        cd ~/deploy_ws/src
        ./deployer -s azure.ugv.nuc.docker.shell

**Docker Container: UAV: Simulation**

      cd ~/deploy_ws/src
      ./deployer -s azure.uav.sim.docker.shell

## Accessing Docker Containers

      # ssh into your VM
      ssh [username]@[private IP]

      # install docker wrappers
      cd ~/deploy_ws/src
      ./install-deployer.bash --install

      # see running containers
      docker ps

      # enter the container
      `docker-join.bash --name [container-name]`

- to view started containers, please do: `docker ps`
- `docker-join` will be installed if you have followed the top level `README.md` correctly.

To launch the system, please refer to the repository's readme to launch.


## Build The Repositories

Assuming you have already entered the docker container in the remote vm, just follow the same commands as in the local *build the repositories* instructions above.

## Launch The Repositories

Assuming you have already entered the docker container in the remote vm, just follow the same commands as in the local *launch the repositories* instructions above.