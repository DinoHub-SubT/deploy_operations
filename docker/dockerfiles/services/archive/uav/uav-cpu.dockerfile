# //////////////////////////////////////////////////////////////////////////////
# @brief subt's uav:nuc dockerfile
# //////////////////////////////////////////////////////////////////////////////

# using subt's ros docker image as the base image
FROM subt/uav-cpu:ros

# Add a user with the same user_id as the user outside the container
# Requires a docker build argument `user_id`
ARG user_id=$user_id
ENV USERNAME developer

# Commands below run as the developer user
USER $USERNAME

# When running a container start in the developer's home folder
WORKDIR /home/$USERNAME

# general tools install
RUN sudo apt-get update --no-install-recommends \
 && sudo apt-get install -y \
  git \
  git-lfs \
  lm-sensors \
  autoconf \
  automake \
  libflann-dev \
  libbluetooth-dev \
  libserial-dev \
  libusb-dev \
  libsdformat6-dev \
  libsuitesparse-dev \
  libeigen3-dev \
  libsdl1.2-dev \
  # OpenCL libs \
  clinfo \
  cpio \
  # nodejs-dev node-gyp libssl1.0-dev npm \
 && sudo apt-get clean \
 && sudo rm -rf /var/lib/apt/lists/*

# //////////////////////////////////////////////////////////////////////////////
# ros install
RUN sudo /bin/sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list' \
 && sudo /bin/sh -c 'apt-key adv --keyserver  hkp://keyserver.ubuntu.com:80 --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654' \
 && sudo /bin/sh -c 'apt-key adv --keyserver keys.gnupg.net --recv-key C8B3A55A6F3EFCDE || apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-key C8B3A55A6F3EFCDE' \
 && sudo apt-get update \
 && sudo apt-get install -y --no-install-recommends \
  ros-melodic-desktop-full \
  ros-melodic-ros-type-introspection \
  ros-melodic-pcl-ros \
  ros-melodic-rosfmt \
  ros-melodic-rqt-gui \
  ros-melodic-rqt-gui-cpp \
  ros-melodic-catch-ros \
  ros-melodic-mav-msgs \
  ros-melodic-rosbash \
  ros-melodic-rosserial \
  ros-melodic-serial \
  ros-melodic-geographic-msgs \
  ros-melodic-xacro \
  ros-melodic-eigen-conversions \
  ros-melodic-stereo-msgs \
  ros-melodic-mavlink \
  ros-melodic-mavros-msgs \
  ros-melodic-rqt-gui-cpp \
  ros-melodic-tf2-geometry-msgs \
  ros-melodic-image-geometry \
  ros-melodic-octomap \
  ros-melodic-octomap-msgs \
  ros-melodic-octomap-ros \
  ros-melodic-rqt-gui-py \
  ros-melodic-robot-state-publisher \
  ros-melodic-stereo-image-proc \
  ros-melodic-mav-msgs \
  ros-melodic-joy \
  python-wstool \
  python-jinja2 \
  libusb-dev \
  libsuitesparse-dev \
  ros-melodic-serial \
  ros-melodic-teraranger-array \
  ros-melodic-teraranger \
  ros-melodic-joystick-drivers \
  ros-melodic-rotors-control \
  ros-melodic-joint-trajectory-controller \
  ros-melodic-multimaster-launch \
  ros-melodic-interactive-marker-twist-server \
  ros-melodic-twist-mux \
  ros-melodic-teleop-twist-joy \
  ros-melodic-lms1xx \
  libglfw3-dev \
  libblosc-dev \
  libopenexr-dev \
  liblog4cplus-dev \
  libpcap-dev \
  opencl-headers \
  libgeographic-dev \
  geographiclib-tools \
  libncurses5-dev \
  libpcap0.8-dev \
  python-lxml \
  python-future \
  gazebo9 \
  libgazebo9-dev \
  libignition-gazebo2-plugins \
  libncurses5-dev \
  libpcap0.8-dev \
  # simulation (temporary) \
  ros-melodic-husky-description \
  ros-melodic-jackal-description \
  ros-melodic-mav-msgs \
  ros-melodic-octomap-msgs \
  ros-melodic-octomap-ros \
  ros-melodic-rotors-comm \
  ros-melodic-rotors-control \
  ros-melodic-rotors-gazebo-plugins \
  ros-melodic-twist-mux \
  libignition-gazebo2-plugins \
  ros-melodic-velocity-controllers \
  ros-melodic-ros-control \
  ros-melodic-diagnostic-aggregator \
  sharutils \
 && sudo apt-get clean \
 && sudo rm -rf /var/lib/apt/lists/*
RUN rosdep update

# add tmux configuration
RUN git clone https://github.com/gpakosz/.tmux.git \
 && ln -s -f .tmux/.tmux.conf \
 && cp .tmux/.tmux.conf.local .

# add user to groups
RUN sudo usermod -a -G dialout developer

# install subt python packages
RUN pip install --user wheel
RUN pip install --user \
 hurry.filesize \
 graphviz \
 serial \
 pyserial \
 shapely \
 empy \
 pybluez \
 pyyaml \
 rospkg \
 shapely \
 graphviz \
 protobuf \
 vislib \
 matplotlib \
 numpy \
 toml \
 future \
 psutil

# //////////////////////////////////////////////////////////////////////////////
# Install opencl
# -- assumes OpenCL download already exists in the `dockerfiles/thirdparty-software` context path.
# //////////////////////////////////////////////////////////////////////////////
RUN sudo add-apt-repository ppa:intel-opencl/intel-opencl \
 && sudo apt-get update --no-install-recommends \
 && sudo apt-get install -y --no-install-recommends \
  intel-opencl-icd \
  clinfo

# add user to groups
RUN sudo usermod -a -G video developer

# install geography datasets
RUN cd /home/$USERNAME/thirdparty-software/uav/ \
 && sudo ./install_geographiclib_datasets.sh

# install xsens libraries
RUN cd /home/$USERNAME/thirdparty-software/uav/ \
 && cd xsens_cpp_driver/receive_xsens/config/mt_sdk/ \
 && sudo ./mt_sdk_4.8.sh

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
