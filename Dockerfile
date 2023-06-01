FROM ubuntu:21.04

# Release is EOL, update apt sources
RUN sed -i -r 's/([a-z]{2}.)?archive.ubuntu.com/old-releases.ubuntu.com/g' /etc/apt/sources.list \
 && sed -i -r 's/ports.ubuntu.com/old-releases.ubuntu.com/g' /etc/apt/sources.list \
 && sed -i -r 's/ubuntu-ports/ubuntu/g' /etc/apt/sources.list \
 && sed -i -r 's/security.ubuntu.com/old-releases.ubuntu.com/g' /etc/apt/sources.list

# Install systemd
RUN apt-get update \
    && apt-get install -y systemd \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Disable multi-user.target.wants, this can interfere with
# the parent console on linux systems when using systemd
# as a container subcomponent
RUN rm -f /lib/systemd/system/multi-user.target.wants/*

# Remove the MOTD unminimize message for Ubuntu systems
RUN rm -rf /etc/update-motd.d/60-unminimize

# Specify a different stop signal for systemd
STOPSIGNAL SIGRTMIN+3

# Mask and unmask services
RUN systemctl mask systemd-firstboot.service systemd-udevd.service systemd-modules-load.service \
&& systemctl unmask systemd-logind

# Execute systemd via the container-entrypoint.sh script
COPY container-entrypoint.sh /bin/container-entrypoint.sh
ENTRYPOINT ["/bin/container-entrypoint.sh"]
