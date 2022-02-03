# Main Build
FROM centos:8

# Fix for Centos8 EOL
RUN sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-Linux-* &&\
    sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-Linux-*

# Install systemd
RUN yum install -y systemd systemd-udev \
    && yum clean all

# Disable multi-user.target.wants, this can interfere with
# the parent console on linux systems when using systemd
# as a container subcomponent
RUN rm -f /lib/systemd/system/multi-user.target.wants/*

# Specify a different stop signal for systemd
STOPSIGNAL SIGRTMIN+3

# Mask and unmask services
RUN systemctl mask systemd-firstboot.service systemd-udevd.service systemd-modules-load.service \
&& systemctl unmask systemd-logind

# Execute systemd via the container-entrypoint.sh script
COPY container-entrypoint.sh /bin/container-entrypoint.sh
ENTRYPOINT ["/bin/container-entrypoint.sh"]
