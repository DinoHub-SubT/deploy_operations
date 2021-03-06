# //////////////////////////////////////////////////////////////////////////////
# @brief subt perception gpu dockerfile
# //////////////////////////////////////////////////////////////////////////////
FROM subt/perception-arm:0.1

# Change to root user, to install packages
USER root

# There is an error in the previous images: 'sudo: /usr/lib/sudo/sudoers.so must be owned by uid 0'
# For now, the below is a hack fix, until we can re-build the original images
RUN chown root:root /usr/bin/sudo \
 && chmod 4755 /usr/bin/sudo \
 && chmod -R a=rx,u+ws /usr/bin/sudo \
 && chown -R root:root /usr/bin/sudo \
 && chmod -R a=rx,u+ws /etc/sudoers \
 && chown -R root:root /etc/sudoers \
 && chmod -R a=rx,u+ws /etc/sudoers.d/ \
 && chown -R root:root /etc/sudoers.d/ \
 && chmod -R a=rx,u+ws /etc/sudoers \
 && chown -R root:root /etc/sudoers \
 && chmod -R a=rx,u+ws /usr/lib/sudo/sudoers.so \
 && chown -R root:root /usr/lib/sudo/sudoers.so

# add user to groups
RUN usermod -a -G dialout developer

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
 # && make test \
 && sudo make install

RUN git clone https://github.com/IntelRealSense/librealsense.git ~/librealsense \
 && cd ~/librealsense \
 && git checkout v2.39.0 \
 && mkdir build \
 && cd build \
 && cmake .. -DCMAKE_BUILD_TYPE=Release \
 && sudo make uninstall \
 && make clean \
 && make \
 && sudo make install

RUN sudo /bin/sh -c 'curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | sudo apt-key add -' \
 && sudo apt-get update \
 && sudo apt-get install -y --no-install-recommends \ 
  ros-melodic-image-proc \
  ros-melodic-image-transport-plugins \
  ros-melodic-rosmon \
  python-psutil \
 && sudo apt-get clean \
 && sudo rm -rf /var/lib/apt/lists/*

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

# need to re-set the root permission error again
RUN chown root:root /usr/bin/sudo && chmod 4755 /usr/bin/sudo

# switch to developer user

# Commands below run as the developer user
USER $USERNAME

# When running a container start in the developer's home folder
WORKDIR /home/$USERNAME

# install pymodbus
RUN pip3 install --user pymodbus
# uninstall py3 psutil -- conflict for central_health_monitor
RUN pip uninstall psutil -y

# set image to run entrypoint script
ENTRYPOINT $entry_path/docker-entrypoint.bash
