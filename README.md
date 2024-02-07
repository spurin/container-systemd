## ✨ Popular linux distributions configured with systemd ✨

[![Follow](https://shields.io/twitter/follow/jamesspurin?label=Follow)](https://twitter.com/jamesspurin)
[![GitHub Stars](https://shields.io/docker/pulls/spurin/container-systemd)](https://hub.docker.com/r/spurin/container-systemd)

Popular linux distributions with systemd.  Superb for use with Docker 🐋

These are the base source of the lab container images used in the [Dive Into Ansible Lab](https://github.com/spurin/diveintoansible-lab)

This container image is designed to be used independently with the likes of ```/bin/bash``` or, as I have done with the [Dive Into Ansible Lab](https://github.com/spurin/diveintoansible-lab) as a base image in a multistage build (see the 'See Also' section below)

## Overview

Up until recently (ubuntu_23.04), it was possible to build an image with a custom systemd that used the legacy hierarchy.  This as expected, appears to be deprecated from ubuntu 23.04 onwards.  That said, hopefully by the point that this or even when 24.04 becomes an adopted standard, the requirement to fall back on the _legacy images (with the progression to linux distributions that supports cgroups v2 natively) will demise.

See the individual branches for sources.  The image can be executed directly (with for example, ```/bin/bash```) or, can be used as a systemd base for other projects.  Execution examples are in the README.md

## See Also

Convenient GitHub links for where I make use of these source images -

* Customised with sshd and ttyd to mimic virtual machine distributions - [spurin/container-systemd-sshd-ttyd](https://github.com/spurin/container-systemd-sshd-ttyd)

## Credits and Thanks

* [@bothaf](https://github.com/bothaf) and [@dazzla76](https://github.com/dazzla76) - Thanks for your support in general and in the testing of these images

* [@AkihiroSuda](https://github.com/AkihiroSuda) - Thanks for your efforts on [Github](https://github.com/AkihiroSuda/containerized-systemd) and the feedback you provided to my question regarding /sys/fs/cgroup.  In testing, the clarification of the use of /sys/fs/cgroup helped a lot and this bridge cgroups v1 and v2 compatibility.  Also appreciate your docker-entrypoint.sh script that I've made use of in this project 🚀
