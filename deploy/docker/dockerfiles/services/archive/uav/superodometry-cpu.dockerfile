# //////////////////////////////////////////////////////////////////////////////
# @brief subt's uav:nuc dockerfile
# //////////////////////////////////////////////////////////////////////////////

# using subt's ros docker image as the base image
FROM subt/uav-cpu:uav

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
  # superodometry \
  libgoogle-glog-dev \
  libatlas-base-dev \
  libeigen3-dev  \
  libsuitesparse-dev \
  libparmetis-dev \
  libmetis-dev \
  # nodejs-dev node-gyp libssl1.0-dev npm \
 && sudo apt-get clean \
 && sudo rm -rf /var/lib/apt/lists/*

# //////////////////////////////////////////////////////////////////////////////
# adding superodometry -- for now all in same dockerfile
# //////////////////////////////////////////////////////////////////////////////

# ceras solver
RUN mkdir -p /home/developer/thirdparty-software/ \
 && cd /home/developer/thirdparty-software/ \
 && git clone https://ceres-solver.googlesource.com/ceres-solver ceres-solver/src \
 && cd ceres-solver/src \
 && git checkout 1.14.0 \
 && cd /home/developer/thirdparty-software/ceres-solver \
 && mkdir build \
 && cd build \
 && cmake ../src \
 && make -j3 \
 && make test \
 && sudo make install

# gtsam
RUN mkdir -p /home/developer/thirdparty-software/ \
 && cd /home/developer/thirdparty-software/ \
 && git clone https://github.com/borglab/gtsam.git gtsam/src \
 && cd /home/developer/thirdparty-software/gtsam/src \
 && git checkout 4.0.2 \
 && cd /home/developer/thirdparty-software/gtsam/ \
 && mkdir build \
 && cd build \
 && cmake -DGTSAM_BUILD_WITH_MARCH_NATIVE=OFF ../src \
 && sudo make install -j8

# sophus
COPY --chown=$USERNAME:$USERNAME thirdparty-software/ /home/$USERNAME/thirdparty-software/
RUN mkdir -p /home/developer/thirdparty-software/ \
 && cd /home/developer/thirdparty-software/ \
 && git clone http://github.com/strasdat/Sophus.git sophus/src \
 && cd sophus/src \
 # && git checkout a621ff \
 # apply patch \
 # && cd /home/developer/thirdparty-software/sophus/src \
 # && cp /home/$USERNAME/thirdparty-software/sophus/sophus.patch sophus.patch \
 # && git apply sophus.patch \
 # cmake build \
 && cd /home/developer/thirdparty-software/sophus/ \
 && mkdir build \
 && cd build \
 && cmake ../src \
 && make -j8 \
 && sudo make install -j8 \
 && export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/include/

# opencv3 -- build opencv from source
# ARG OPENCV_VERSION=3.4.0
# RUN mkdir /home/$USER/opencv_dep  \
#  && cd /home/$USER/opencv_dep \
#  && mkdir src \
#  && cd src \
#  && git clone https://github.com/opencv/opencv \
#  && cd opencv \
#  && git checkout tags/$OPENCV_VERSION \
#  && cd .. \
#  && git clone https://github.com/opencv/opencv_contrib \
#  && cd opencv_contrib \
#  && git checkout tags/$OPENCV_VERSION \
#  && cd ../.. \
#  && mkdir build \
#  && cd build \
#  && cmake \
#   -DOPENCV_EXTRA_MODULES_PATH=../src/opencv_contrib/modules/ \
#   -DCMAKE_BUILD_TYPE=Release \
#   -DCUDA_NVCC_FLAGS=--expt-relaxed-constexpr \
#   -D WITH_CUDA=ON \
#   -D ENABLE_FAST_MATH=1 \
#   -D CUDA_FAST_MATH=1 \
#   -D WITH_CUBLAS=1 \
#   -D INSTALL_PYTHON_EXAMPLES=ON \
#   # -D BUILD_EXAMPLES=ON \
#   -D CMAKE_INSTALL_PREFIX=/usr/local \
#   ../src/opencv \
#  && make -j8 \
#  && sudo make install

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
