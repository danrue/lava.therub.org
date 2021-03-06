#!/bin/sh

# Idempotentally provision users and devices in lava

set -ex

lava-server manage users list | grep -q drue || \
    lava-server manage users add --staff --superuser --email drue@therub.org --passwd admin drue

lava-server manage device-types list | grep -q qemu || \
    lava-server manage device-types add qemu

lava-server manage workers list | grep dispatcher || \
    lava-server manage workers add dispatcher

lava-server manage devices list | grep -q qemu-01 || \
    lava-server manage devices add --device-type qemu --worker dispatcher qemu-01

lava-server manage device-types list | grep -q beaglebone-black || \
    lava-server manage device-types add beaglebone-black

lava-server manage devices list | grep -q beaglebone-black-01 || \
    lava-server manage devices add --device-type beaglebone-black --worker dispatcher beaglebone-black-01

lava-server manage device-types list | grep -q am57xx-beagle-x15 || \
    lava-server manage device-types add am57xx-beagle-x15

lava-server manage devices list | grep -q am57xx-beagle-x15-01 || \
    lava-server manage devices add --device-type am57xx-beagle-x15 --worker dispatcher am57xx-beagle-x15-01

lava-server manage device-types list | grep -q docker || \
    lava-server manage device-types add docker

lava-server manage devices list | grep -q docker-lavafed-01 || \
    lava-server manage devices add --device-type docker --worker dispatcher docker-lavafed-01
