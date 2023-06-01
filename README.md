## ✨ Popular linux distributions configured with systemd ✨

[![Follow](https://shields.io/twitter/follow/jamesspurin?label=Follow)](https://twitter.com/jamesspurin)
[![GitHub Stars](https://shields.io/docker/pulls/spurin/container-systemd)](https://hub.docker.com/r/spurin/container-systemd)

Popular linux distributions with systemd.  Superb for use with Docker 🐋

These are the base source of the lab container images used in the [Dive Into Ansible Lab](https://github.com/spurin/diveintoansible-lab)

This container image is designed to be used independently with the likes of ```/bin/bash``` or, as I have done with the [Dive Into Ansible Lab](https://github.com/spurin/diveintoansible-lab) as a base image in a multistage build (see the 'See Also' section below)

## Overview

Whilst building the original Dive Into Ansible Lab, over the years I've encountered many difficulties with systemd running in a container and compatibility across different systems.  The issues and workarounds would vary for different systems, i.e. -

* Mac OS X x86 (Docker Desktop - cgroups v1)
* Mac OS X Apple Silicon (Docker Desktop - cgroups v1)
* Mac OS X x86 (Docker Desktop - cgroups v2 - **Dec 2021 Onwards**)
* Mac OS X Apple Silicon (Docker Desktop - cgroups v2 - **Dec 2021 Onwards**)
* Linux Distributions with cgroups v1
* Linux Distributions with cgroups v2
* Windows (Docker Desktop, default WSL)
* Windows (Docker Desktop, custom WSL)

With the custom builds of systemd in the ubuntu based images (ubuntu branches with _default), these images have in testing, worked as expected across different configurations as expected.  The use base is over 20K+ Students across 125+ countries.

See the individual branches for sources.  The image can be executed directly (with for example, ```/bin/bash```) or, can be used as a systemd base for other projects.  Execution examples are in the README.md

## See Also

Convenient GitHub links for where I make use of these source images -

* Customised with sshd and ttyd to mimic virtual machine distributions - [spurin/container-systemd-sshd-ttyd](https://github.com/spurin/container-systemd-sshd-ttyd)

## Credits and Thanks

* [@bothaf](https://github.com/bothaf) and [@dazzla76](https://github.com/dazzla76) - Thanks for your support in general and in the testing of these images

* [@AkihiroSuda](https://github.com/AkihiroSuda) - Thanks for your efforts on [Github](https://github.com/AkihiroSuda/containerized-systemd) and the feedback you provided to my question regarding /sys/fs/cgroup.  In testing, the clarification of the use of /sys/fs/cgroup helped a lot and this bridge cgroups v1 and v2 compatibility.  Also appreciate your docker-entrypoint.sh script that I've made use of in this project 🚀
