#!/bin/bash
set -e
container=docker
export container

# If a command is provided but a TTY isn't enabled, exit
if [ $# -ne 0 ] && [ ! -t 0 ]; then
   echo >&2 'ERROR: TTY needs to be enabled (`docker run -t ...`).'
   exit 1
fi

# If a command is provided, configure a systemd service for execution
if [ $# -ne 0 ]; then
   env >/etc/container-entrypoint-env

   cat >/etc/systemd/system/container-entrypoint.target <<EOF
[Unit]
Description=for container-entrypoint.service
Requires=container-entrypoint.service systemd-logind.service systemd-user-sessions.service
EOF

   quoted_args="$(printf " %q" "${@}")"
   echo "${quoted_args}" >/etc/container-entrypoint-cmd

   cat >/etc/systemd/system/container-entrypoint.service <<EOF
[Unit]
Description=container-entrypoint.service

[Service]
ExecStart=/bin/bash -exc "source /etc/container-entrypoint-cmd"
# EXIT_STATUS is either an exit code integer or a signal name string, see systemd.exec(5)
ExecStopPost=/bin/bash -ec "if echo \${EXIT_STATUS} | grep [A-Z] > /dev/null; then echo >&2 \"got signal \${EXIT_STATUS}\"; systemctl exit \$(( 128 + \$( kill -l \${EXIT_STATUS} ) )); else systemctl exit \${EXIT_STATUS}; fi"
StandardInput=tty-force
StandardOutput=inherit
StandardError=inherit
WorkingDirectory=$(pwd)
EnvironmentFile=/etc/container-entrypoint-env

[Install]
WantedBy=multi-user.target
EOF

   systemctl enable container-entrypoint.service
fi

# Capture the systemd location
systemd=
if [ -x /lib/systemd/systemd ]; then
   systemd=/lib/systemd/systemd
elif [ -x /usr/lib/systemd/systemd ]; then
   systemd=/usr/lib/systemd/systemd
elif [ -x /sbin/init ]; then
   systemd=/sbin/init
else
   echo >&2 'ERROR: systemd is not installed'
   exit 1
fi

# Toggle systemd_args whether or not a command is being executed
if [ $# -ne 0 ]; then
   systemd_args="--show-status=true --unit=container-entrypoint.target"
else
   systemd_args="--show-status=true"
fi

# Start systemd
exec $systemd $systemd_args
