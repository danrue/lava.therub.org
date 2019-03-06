# Using LAVA with Docker

This is the repository that stores the configuration for
[lava.therub.org](https://lava.therub.org/). The goals for this lab are:
- [kernelCI](https://kernelci.org/) participation
- [lavafed](https://federation.lavasoftware.org/) participation
- Best practice reference for deploying and managing LAVA

![LAVA board farm with embedded ARM boards mounted in
rack](documentation/lava-lab.jpg)

## Lab Description

This lab is deployed using [Docker](https://docs.docker.com/install/) and
[docker-compose](https://docs.docker.com/compose/install/) on a single physical
LAVA server+dispatcher running on the same host, with several physical and
virtual devices attached for testing. Over time, it may scale to multiple LAVA
hosts and more boards.

## Configuration

The configuration is specific to the boards in this lab. However, the approach
to running LAVA is useful as a reference.

## Usage

`docker-compose up -d`: Bring up the lab

`docker-compose down`: Bring down the lab

## Upgrades

1. Stop containers.
2. Back up pgsql from its docker volume

    sudo tar cvzf $HOME/lava-server-pgdata-$(date +%Y%m%d).tgz /var/lib/docker/volumes/lava-server-pgdata

3. Change e.g. `lavasoftware/lava-server:2019.01` to
`lavasoftware/lava-server:2019.03` and
`lavasoftware/lava-dispatcher:2019.01` to
`lavasoftware/lava-dispatcher:2019.03` in docker-compose.yml.
4. Change the FROM line if any containers are being rebuilt, such as
[./dispatcher-docker/Dockerfile](./dispatcher-docker/Dockerfile)
5. Start containers.

## Useful Commands

Spy on the serial port:

    docker-compose exec dispatcher telnet ser2net 5001 # beaglebone-black-01
    docker-compose exec dispatcher telnet ser2net 5002 # x15-01

View logs:

    docker-compose logs -f # all containers
    docker-compose logs -f server # only the server
