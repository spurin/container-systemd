# Multi-stage build.  Using the equivalent version of Ubuntu, build a 
# customised version of systemd
#
# By default, systemd uses the unified hierarchy. CentOS, uses legacy.
# It was noticed during testing that legacy hierarchy permits containers to 
# be stopped and started on all docker container subsystems, regardless of 
# the OS, whether cgroups v1 or v2 are used and within all WSL Subsystems
#
# The unified hierarchy seems to be the related to this issue.  Parameters
# to configure this option are limited as kernel boot parameters which,
# doesn't help us much when we're running with a shared kernel.  
#
# As a workaround we build a customised version of systemd, with legacy as the 
# default hierarchy option
FROM ubuntu:21.10 as systemdbuild
ENV DEBIAN_FRONTEND=noninteractive

WORKDIR /build_systemd

# Download the source code for systemd and build a .deb package
# with a customised version (defaulting to legacy, as the default_hierarchy)
RUN perl -p -i -e 's/^# deb-src/deb-src/g' /etc/apt/sources.list \
    && apt-get update \
    && apt-get -y install dpkg-dev \
    && apt-get source systemd \
    && cd systemd-* \
    && perl -p -i -e "s/default_hierarchy = get_option\('default-hierarchy'\)/default_hierarchy = 'legacy'/g" meson.build \
    && apt-get -y build-dep systemd \
    && apt-get -y install devscripts \
    && DEB_BUILD_OPTIONS=nocheck debuild -us -uc -b

# Main Build
FROM ubuntu:21.10

# Copy the customised version of systemd to /tmp
COPY --from=systemdbuild /build_systemd/systemd_*.deb /tmp

# Install our customised systemd
RUN apt-get update \
    && apt-get install -y /tmp/systemd_*.deb \
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
