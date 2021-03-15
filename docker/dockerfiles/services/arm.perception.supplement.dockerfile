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

# set image to run entrypoint script
ENTRYPOINT $entry_path/docker-entrypoint.bash