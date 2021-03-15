# //////////////////////////////////////////////////////////////////////////////
# tensorflow ros -- version: 0.1 devel
# //////////////////////////////////////////////////////////////////////////////
ARG BUILD_TYPE=devel
ARG BUILD_VERSION=0.1
FROM subt/tensorflow-1804:0.1

# == warning == this is a security issue
# ssh keys: copy bitbucket ssh keys from host to image
RUN rm -rf ~/.ssh
RUN mkdir ~/.ssh
ARG ssh_priv_key
ARG ssh_pub_key
RUN eval "$(ssh-agent -s)" \
 && sudo chmod 700 ~/.ssh \
 && sudo chown -R $USERNAME:$USERNAME ~/.ssh \
 && echo "$ssh_priv_key" >> /home/$USERNAME/.ssh/id_rsa \
 && echo "$ssh_pub_key" >> /home/$USERNAME/.ssh/id_rsa.pub \
 && chmod 400 ~/.ssh/id_rsa \
 && chmod 400 ~/.ssh/id_rsa.pub \
 && ssh-add ~/.ssh/id_rsa \
 && ssh-keyscan bitbucket.org >> ~/.ssh/known_hosts

# //////////////////////////////////////////////////////////////////////////////
# default arguments: please always add this to every docker file even if not used
ARG user_id
ARG ssh_priv_key
ARG ssh_pub_key

USER root

# //////////////////////////////////////////////////////////////////////////////
# general tools install
RUN apt-get update \
 && apt-get install -y \
  build-essential \ 
  cmake \
  cppcheck \
  gdb \
  git \
  libbluetooth-dev \
  libcwiid-dev \
  libgoogle-glog-dev \
  libspnav-dev \
  libusb-dev \
  lsb-release \
  mercurial \
  python3-dbg \
  python3-empy \
  python3-numpy \
  python3-pip \
  python3-venv \
  software-properties-common \
  sudo \
  vim \
  wget \
  wget \
  tmux \
  curl \
  less \
  net-tools \
  byobu \
  xvfb \
  qtbase5-dev \
  locate \
 && apt-get clean

# run as the developer user
ENV USERNAME developer
USER $USERNAME

# running container start dir
WORKDIR /home/$USERNAME

# //////////////////////////////////////////////////////////////////////////////
# ROS setup
ARG USER=developer

RUN sudo /bin/sh -c 'echo "deb http://packages.osrfoundation.org/gazebo/ubuntu-stable `lsb_release -cs` main" > /etc/apt/sources.list.d/gazebo-stable.list' \
 && sudo /bin/sh -c 'wget -q http://packages.osrfoundation.org/gazebo.key -O - | APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1 sudo apt-key add -' \
 && sudo /bin/sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list' \
 && sudo /bin/sh -c 'apt-key adv --keyserver  hkp://keyserver.ubuntu.com:80 --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654' \
 && sudo /bin/sh -c 'apt-key adv --keyserver keys.gnupg.net --recv-key C8B3A55A6F3EFCDE || apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-key C8B3A55A6F3EFCDE' \
 && sudo /bin/sh -c 'echo "deb http://realsense-hw-public.s3.amazonaws.com/Debian/apt-repo bionic main" > /etc/apt/sources.list.d/realsense.list' \
 && sudo apt-get update \
 && sudo apt-get install -y \
  python-rosdep \
  python-catkin-pkg \
  python-catkin-tools \
  python-rosinstall \
  python-rosinstall-generator \
  python-wstool \
  build-essential \
  libconsole-bridge-dev \
 && sudo rosdep init \
 && sudo apt-get clean
RUN rosdep update

# install ros melodic from source -- but dont build yet, so that we can build opencv from source below
RUN mkdir /home/$USER/ros_osrf/ \
 && mkdir /home/$USER/ros_osrf/src \
 && mkdir /home/$USER/ros_osrf/rosinstalls \
 && rosinstall_generator desktop_full --rosdistro melodic --deps --wet-only --tar > /home/$USER/ros_osrf/rosinstalls/melodic.rosinstall \
 && wstool init /home/$USER/ros_osrf/src /home/$USER/ros_osrf/rosinstalls/melodic.rosinstall \
 && rosdep install --from-paths /home/$USER/ros_osrf/src --ignore-src --rosdistro melodic -y \
 && touch /home/$USER/ros_osrf/src/gazebo_ros_pkgs/CATKIN_IGNORE
 
# catkin build tools
# RUN sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu `lsb_release -sc` main" > /etc/apt/sources.list.d/ros-latest.list' \
#  && sudo apt-get update \
#  && wget http://packages.ros.org/ros.key -O - | sudo apt-key add - \
#  && sudo apt-get install python-catkin-tools -y

# //////////////////////////////////////////////////////////////////////////////
# OpenCV

# Remove OpenCV
RUN sudo apt-get autoremove opencv* -y \
 && sudo apt-get remove opencv* -y \
 && sudo find / -name "*opencv*" -exec rm -i -fr {} \; || true

# downgrade gcc to build opencv 3.4 (cant build with higher gcc)
RUN sudo apt-get install gcc-6 g++-6 g++-6-multilib gfortran-6 -y \
 # && sudo update-alternatives --remove-all gcc \
 # && sudo update-alternatives --remove-all g++ \
 && sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-6 20 \
 && sudo update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-6 20

# build opencv from source
ARG OPENCV_VERSION=3.4.0
RUN mkdir /home/$USER/opencv_dep  \
 && cd /home/$USER/opencv_dep \
 && mkdir src \
 && cd src \
 && git clone https://github.com/opencv/opencv \
 && cd opencv \
 && git checkout tags/$OPENCV_VERSION \
 && cd .. \
 && git clone https://github.com/opencv/opencv_contrib \
 && cd opencv_contrib \
 && git checkout tags/$OPENCV_VERSION \
 && cd ../.. \
 && mkdir build \
 && cd build \
 && cmake \
  -DOPENCV_EXTRA_MODULES_PATH=../src/opencv_contrib/modules/ \
  -DCMAKE_BUILD_TYPE=Release \
  -DCUDA_NVCC_FLAGS=--expt-relaxed-constexpr \
  -D WITH_CUDA=ON \
  -D ENABLE_FAST_MATH=1 \
  -D CUDA_FAST_MATH=1 \
  -D WITH_CUBLAS=1 \
  -D INSTALL_PYTHON_EXAMPLES=ON \
  # -D BUILD_EXAMPLES=ON \
  -D CMAKE_INSTALL_PREFIX=/usr/local \
  ../src/opencv \ 
 && make -j8 \
 && sudo make install

# //////////////////////////////////////////////////////////////////////////////
# Install Eigen 3.3.5
RUN mkdir -p thirdparty/eigen \
 && cd thirdparty/eigen \
 && wget http://bitbucket.org/eigen/eigen/get/3.3.5.tar.bz2 \
 && bzip2 -d 3.3.5.tar.bz2 \
 && tar xvf 3.3.5.tar \
 && mkdir build \
 && cd build \
 && cmake ../eigen-eigen-b3f3d4950030/ \
 && make -j8 \
 && sudo make install

# //////////////////////////////////////////////////////////////////////////////
# Install pcl 1.9.1 -- don't install yet, needs ros_osrf changes.

# RUN mkdir -p thirdparty/pcl \
#  && cd thirdparty/pcl \
#  && wget https://github.com/PointCloudLibrary/pcl/archive/pcl-1.9.1.tar.gz \
#  && tar xvfj pcl-1.9.1.tar.gz \
#  && mkdir build \
#  && cd build \
#  && cmake -DCMAKE_BUILD_TYPE=Release .. \
#  && make -j8 \
#  && sudo make install

# //////////////////////////////////////////////////////////////////////////////
# Install realsense camera driver libs
RUN sudo /bin/sh -c 'apt-key adv --keyserver keys.gnupg.net --recv-key C8B3A55A6F3EFCDE || sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-key C8B3A55A6F3EFCDE' \ 
 && sudo /bin/sh -c 'echo "deb http://realsense-hw-public.s3.amazonaws.com/Debian/apt-repo bionic main" > /etc/apt/sources.list.d/ros-realsense.list' \
 && sudo apt-get update \
 && sudo apt-get install -y \
  librealsense2-dkms \
  librealsense2-utils \
  librealsense2-dev \
  librealsense2-dbg

# //////////////////////////////////////////////////////////////////////////////
# Python3

# install subt python packages
RUN sudo apt-get install python3-pip python3-yaml python3-dev python3-numpy -y --no-install-recommends
RUN pip3 install wheel --user 
RUN pip3 install rospkg catkin_pkg hurry.filesize graphviz serial pyserial multiping shapely catkin_pkg --user
RUN echo "alias python=/usr/bin/python3" >> ~/.bash_profile

# //////////////////////////////////////////////////////////////////////////////
# ros install
RUN sudo /bin/sh -c 'echo "deb http://packages.osrfoundation.org/gazebo/ubuntu-stable `lsb_release -cs` main" > /etc/apt/sources.list.d/gazebo-stable.list' \
 && sudo /bin/sh -c 'wget -q http://packages.osrfoundation.org/gazebo.key -O - | APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1 sudo apt-key add -' \
 && sudo /bin/sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list' \
 && sudo /bin/sh -c 'apt-key adv --keyserver  hkp://keyserver.ubuntu.com:80 --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654' \
 && sudo /bin/sh -c 'apt-key adv --keyserver keys.gnupg.net --recv-key C8B3A55A6F3EFCDE || apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-key C8B3A55A6F3EFCDE' \
 && sudo /bin/sh -c 'echo "deb http://realsense-hw-public.s3.amazonaws.com/Debian/apt-repo bionic main" > /etc/apt/sources.list.d/realsense.list' \
 && sudo apt-get update \
 && sudo apt-get install -y --no-install-recommends \
  libboost-all-dev \
  libeigen3-dev \
  assimp-utils \
  libcgal-dev \
  libcgal-qt5-dev \
  ros-melodic-octomap-ros \
  libproj-dev \
  libnlopt-dev \
  ros-melodic-octomap-server \
  libignition-transport4-dev \
  ros-melodic-velodyne-description \
  python-wstool \
  ros-melodic-tf-conversions \
  # gazebo \
  ros-melodic-gazebo-* \
  ros-melodic-hector-sensors-description \
  ros-melodic-joint-state-controller \
  # ros-melodic-message-to-tf \
  ros-melodic-octomap \
  ros-melodic-octomap-server \
  # ros-melodic-octomap-rviz-plugins \
  ros-melodic-octomap-ros \
  ros-melodic-octomap-mapping \
  ros-melodic-octomap-msgs \
  ros-melodic-velodyne-* \
  libglfw3-dev libblosc-dev libopenexr-dev \
  ros-melodic-smach-viewer \
  ros-melodic-multimaster-fkie \
  ros-melodic-random-numbers \
  liblog4cplus-dev \
  cmake \
  libsuitesparse-dev \
  libsdl1.2-dev \
  doxygen \
  graphviz \
  ros-melodic-mav-msgs \
  ros-melodic-image-geometry \
  ros-melodic-tf2-geometry-msgs \
  # ros-melodic-rosmon \
  python-requests \
  ros-melodic-mavros-msgs \
  ros-melodic-rosserial \
  ros-melodic-catch-ros \
  ros-melodic-teleop-twist-joy \
  ros-melodic-rosfmt \
  ros-melodic-rqt-gui-cpp \
  ros-melodic-cmake-modules \
  #################### \
  # state est rosdeps  \ 
  #################### \
  gstreamer1.0-plugins-base \
  gir1.2-gst-plugins-base-1.0 \
  libgstreamer1.0-dev \
  festival \
  festvox-kallpc16k \
  gstreamer1.0-plugins-ugly \
  python-gi \
  gstreamer1.0-plugins-good \
  libgstreamer-plugins-base1.0-dev \
  gstreamer1.0-tools \
  gir1.2-gstreamer-1.0 \
  chrony \
  sharutils \
  graphviz \
  #################### \
  # realsense  \ 
  #################### \
  librealsense2-dkms \
  librealsense2-utils \
  librealsense2-dev \
  librealsense2-dbg \
  #################### \
  # other \
  #################### \
  iputils-ping \
  nano \
  # rosmon from source deps \
  libserial-dev \
  libncurses-dev \
  libncurses5-dev \
  libncurses5-dev \
  lm-sensors \
  python-rosdep \
  python-catkin-pkg \
  python-catkin-tools \
  python-rosinstall \
  python-rosinstall-generator \
  python-wstool \
  build-essential \
  libconsole-bridge-dev \
 && sudo apt-get clean \
 && sudo rm -rf /var/lib/apt/lists/*

# add tmux configuration
RUN git clone https://github.com/gpakosz/.tmux.git \
 && ln -s -f .tmux/.tmux.conf \
 && cp .tmux/.tmux.conf.local .

# //////////////////////////////////////////////////////////////////////////////
# entrypoint startup

# entrypoint env variables
ARG arch=$arch
ENV entrypoint_path /docker-entrypoint/
ENV launch_path     /ros-launch/

# add entrypoint scripts (general & system specific)
ADD entrypoints/ $entrypoint_path/
# ADD perception/entrypoints/ $entrypoint_path/
#ADD $arch/entrypoints/ $entrypoint_path/

# execute entrypoint script
RUN sudo chmod +x -R $entrypoint_path/

# set image to run entrypoint script
ENTRYPOINT $entrypoint_path/docker-entrypoint.bash

