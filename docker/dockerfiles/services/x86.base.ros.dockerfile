# //////////////////////////////////////////////////////////////////////////////
# @brief Base, ros melodic docker images
# //////////////////////////////////////////////////////////////////////////////

# get the passed, deployerbooks environment variables (for maintaining the docker image names)
ARG DOCKER_IMAGE_TAG=$DOCKER_IMAGE_TAG
ARG DOCKER_BASE_IMAGE_ROS=$DOCKER_BASE_IMAGE_ROS
ARG DOCKER_BASE_IMAGE_PROJECT=$DOCKER_BASE_IMAGE_PROJECT
ARG DOCKER_IMAGE_ARCH=$DOCKER_IMAGE_ARCH

# Get the base image, either cpu or gpu version, found defined in: operations/scenarios/.docker.env
FROM $DOCKER_BASE_IMAGE_ROS

# //////////////////////////////////////////////////////////////////////////////
# general tools install
RUN export DEBIAN_FRONTEND=noninteractive \
 && apt-get update --no-install-recommends \
 && apt-get install -y \
  build-essential \
  cmake \
  cppcheck \
  gdb \
  git \
  lsb-release \
  software-properties-common \
  sudo \
  vim \
  wget \
  tmux \
  curl \
  less \
  net-tools \
  byobu \
  libgl-dev \
  iputils-ping \
  nano \
  doxygen \
  graphviz \
  python-requests \
  python-pip \
  locales \
  xvfb \
  tzdata \
  emacs \
  unzip \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# Set the locale
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
 && dpkg-reconfigure --frontend=noninteractive locales \
 && update-locale LANG=en_US.UTF-8
ENV LANG en_US.UTF-8

# Add a user with the same user_id as the user outside the container
# Requires a docker build argument `user_id`
ARG user_id=$user_id
ENV USERNAME developer
ENV USER=developer
RUN useradd -U --uid ${user_id} -ms /bin/bash $USERNAME \
 && echo "$USERNAME:$USERNAME" | chpasswd \
 && adduser $USERNAME sudo \
 && echo "$USERNAME ALL=NOPASSWD: ALL" >> /etc/sudoers.d/$USERNAME
# Commands below run as the developer user
USER $USERNAME
# When running a container start in the developer's home folder
WORKDIR /home/$USERNAME

# TODO: == warning == this is a security issue
# ssh keys: copy bitbucket ssh keys from host to image
# RUN rm -rf ~/.ssh
# RUN mkdir ~/.ssh
# ARG ssh_priv_key
# ARG ssh_pub_key
# RUN eval "$(ssh-agent -s)" \
#  && sudo chmod 700 ~/.ssh \
#  && sudo chown -R $USERNAME:$USERNAME ~/.ssh \
#  && echo "$ssh_priv_key" >> /home/$USERNAME/.ssh/id_rsa \
#  && echo "$ssh_pub_key" >> /home/$USERNAME/.ssh/id_rsa.pub \
#  && chmod 400 ~/.ssh/id_rsa \
#  && chmod 400 ~/.ssh/id_rsa.pub \
#  && ssh-add ~/.ssh/id_rsa \
#  && ssh-keyscan bitbucket.org >> ~/.ssh/known_hosts

# remove ssh host checking (for git clone in container)
# eventually to be removed by the above ssh keys setup
RUN mkdir $HOME/.ssh && ssh-keyscan bitbucket.org >> $HOME/.ssh/known_hosts

# Set the timezone
RUN sudo ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime \
 && sudo dpkg-reconfigure --frontend noninteractive tzdata \
 && sudo apt-get clean

# //////////////////////////////////////////////////////////////////////////////
# ros install
RUN sudo /bin/sh -c 'echo "deb http://packages.osrfoundation.org/gazebo/ubuntu-stable `lsb_release -cs` main" > /etc/apt/sources.list.d/gazebo-stable.list' \
 && sudo /bin/sh -c 'wget -q http://packages.osrfoundation.org/gazebo.key -O - | APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1 sudo apt-key add -' \
 && sudo /bin/sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list' \
 # && sudo /bin/sh -c 'apt-key adv --keyserver  hkp://keyserver.ubuntu.com:80 --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654' \
 # && sudo /bin/sh -c 'apt-key adv --keyserver keys.gnupg.net --recv-key C8B3A55A6F3EFCDE || apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-key C8B3A55A6F3EFCDE' \
 && sudo /bin/sh -c 'curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | sudo apt-key add -' \
 && sudo apt-get update \
 && sudo apt-get install -y --no-install-recommends \
  # general ros melodic dependencies \
  python-rosdep \
  libboost-all-dev \
  libeigen3-dev \
  assimp-utils \
  libcgal-dev \
  libcgal-qt5-dev \
  libproj-dev \
  libnlopt-dev \
  python-wstool \
  python-catkin-tools \
  libglfw3-dev \
  libblosc-dev \
  libopenexr-dev \
  liblog4cplus-dev \
  libsuitesparse-dev \
  libsdl1.2-dev \
  # basic ros-melodic packages \
  ros-melodic-catch-ros \
  ros-melodic-smach-viewer \
  ros-melodic-tf-conversions \
  ros-melodic-gazebo-* \
  ros-melodic-random-numbers \
  ros-melodic-cmake-modules \
  ros-melodic-rqt-gui-cpp \
  ros-melodic-rviz \
  # common workspace dependencies \
  ros-melodic-ros-type-introspection \
  ros-melodic-geometry \
  ros-melodic-tf2-geometry-msgs \
 && sudo apt-get clean \
 && sudo rm -rf /var/lib/apt/lists/*
# force a rosdep update
RUN sudo rosdep init && rosdep update

# //////////////////////////////////////////////////////////////////////////////
# Install pcl 1.9.1 -- don't install yet, needs ros_osrf changes.
# RUN mkdir -p thirdparty/pcl \
#  && cd thirdparty/pcl \
#  && wget https://github.com/PointCloudLibrary/pcl/archive/pcl-1.9.1.tar.gz \
#  && tar xvfz pcl-1.9.1.tar.gz \
#  && mkdir build \
#  && cd build \
#  && cmake -DCMAKE_BUILD_TYPE=Release ../pcl-pcl-1.9.1/ \
#  && make -j8 \
#  && sudo make install

# //////////////////////////////////////////////////////////////////////////////
# basic python packages
RUN pip install --user \
 wheel \
 setuptools \
 PyYAML \
 pexpect \
 tmuxp \
 libtmux

# add tmux configuration
RUN git clone https://github.com/gpakosz/.tmux.git \
 && ln -s -f .tmux/.tmux.conf \
 && cp .tmux/.tmux.conf.local .

# //////////////////////////////////////////////////////////////////////////////
# export environment variables

# Ugly: update the python environment path
ENV PYTHONPATH=${PYTHONPATH}:/home/$USERNAME/.local/lib/python2.7/site-packages/
ENV PATH=${PATH}:/home/$USERNAME/.local/bin/

# //////////////////////////////////////////////////////////////////////////////
# copy any thirdparty data
COPY --chown=developer:developer thirdparty-software/ /home/$USERNAME/thirdparty-software/

# unzip docker image data into home thirdparty directory
RUN cd /home/$USERNAME/thirdparty-software/ \
 && unzip docker-image-thirdparty-data.zip \
 && mv docker-image-thirdparty-data/* /home/$USERNAME/thirdparty-software/ \
 && rm -rf docker-image-thirdparty-data \
 && rm -rf docker-image-thirdparty-data.zip

# //////////////////////////////////////////////////////////////////////////////
# entrypoint startup
# //////////////////////////////////////////////////////////////////////////////

# entrypoint path inside the docker container
ENV entry_path /docker-entrypoint/

# add entrypoint scripts (general & system specific)
ADD entrypoints/ $entry_path/

# execute entrypoint script
RUN sudo chown -R $USERNAME:$USERNAME $entry_path/
RUN sudo chmod +x -R $entry_path/

# set image to run entrypoint script
ENTRYPOINT $entry_path/docker-entrypoint.bash
