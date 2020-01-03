#!/bin/sh

# lava-server's entrypoint requires that some files are owned by lavaserver
# https://git.lavasoftware.org/lava/pkg/docker/merge_requests/42

set -ex

chown --recursive lavaserver:lavaserver /etc/lava-server/dispatcher-config/
