## ✨ Popular linux distributions configured with systemd (ubuntu_20.04_legacy) ✨

Popular linux distributions with systemd.  Superb for use with Docker 🐋

## Overview

Source Dockerfile for running Ubuntu 20.04 with systemd in a convenient container.  The image relating to this Dockerfile is available for both amd64 and arm64 on Docker Hub - ```spurin/container-systemd:ubuntu_20.04_legacy```

## Examples

Run a systemd container and execute a bash shell, cleanup on exit -

```
docker run -it --rm --privileged spurin/container-systemd:ubuntu_20.04_legacy /bin/bash
```

---

Run a systemd container in the background (useful for further customisation, i.e. as a base image
for another container where additional systemd service files are added) -

```
CONTAINER=$(docker run -d --privileged spurin/container-systemd:ubuntu_20.04_legacy)
docker exec -it $CONTAINER bash
```

Terminate and Remove -

```
docker stop $CONTAINER
docker rm $CONTAINER
```

## Build

See the build.sh script for 3 options that can be used for build purposes

1. Build locally
2. Crossbuild with buildx for amd64 and arm64 (Slow!)
3. Crossbuild with buildx for amd64 and arm64 using a dedicated instance for alternative cross building (configure accordingly for your remote architecture)
