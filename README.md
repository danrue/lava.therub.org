# Using LAVA with Docker

This is the repository that stores the configuration for
[lava.therub.org](https://lava.therub.org/). The goals for this personal lab
are:
- [kernelCI](https://kernelci.org/) participation
- [lavafed](https://federation.lavasoftware.org/) participation
- Best practice reference for deploying and managing LAVA
- Personal enjoyment and learning

![LAVA board farm with embedded ARM boards mounted in
rack](documentation/lava-lab.jpg)

## Lab Description

This lab is deployed using [Docker](https://docs.docker.com/install/) and
[docker-compose](https://docs.docker.com/compose/install/) on a single physical
LAVA server+dispatcher running on the same host, with several physical and
virtual devices attached for testing. Over time, it may scale to multiple LAVA
hosts and more boards.

Additional information about LAVA, Docker, and this lab can be found at
[Running LAVA with Docker
Compose](https://therub.org/2019/03/01/lava-docker-compose/) and [Setting up a
board farm with LAVA and
Docker](https://therub.org/2019/03/05/setting-up-a-board-farm-with-lava-and-docker/).

## Configuration

The configuration is specific to the boards in this lab. However, the approach
to running LAVA may be useful as a reference.

The following specific containers are used in this deployment:

`database`: Postgresql container for LAVA server. Database stored in a docker volume.

`squid`: HTTP caching container. Cache stored in a docker volume.

`server`: LAVA server. job-output stored in a docker volume. Configuration files
mounted in from this repository.

`dispatcher`: LAVA dispatcher. Requires escalated privileges for QEMU jobs as
well as Docker jobs. Docker volumes mounted in for tftpd and nfsd.

`ser2net`: Serial port to telnet interface. Requires exclusive access to the
serial devices.

`tftpd-hpa`: TFTPd container. Uses a docker volume which is also mounted into the
dispatcher.

`nfsd`: NFSd container. Uses a docker volume which is also mounted into the
dispatcher.

## Usage

`docker-compose up -d`: Bring up the lab

`docker-compose down`: Bring down the lab

## Upgrades

1. `docker-compose down`
2. Back up pgsql from its docker volume

```
    sudo tar cvzf $HOME/lava-server-pgdata-$(date +%Y%m%d).tgz /var/lib/docker/volumes/lava-server-pgdata
```

3. Change e.g. `lavasoftware/lava-server:2019.04` to
`lavasoftware/lava-server:2019.05` and
`lavasoftware/lava-dispatcher:2019.04` to
`lavasoftware/lava-dispatcher:2019.05` in docker-compose.yml.
4. Change the FROM line if any containers are being rebuilt, such as
[./dispatcher-docker/Dockerfile](./dispatcher-docker/Dockerfile)
5. `docker-compose up -d`

### 2019.05 to 2019.10

Needed to add a [chown
script](./server-overlay/root/entrypoint.d/chown-files.sh:/root/entrypoint.d/chown-files.sh)
to handle a file ownership check that was added to the docker containers.

Moved health-check binaries to a github lfs repo.

### 2019.03 to 2019.04

This upgrade changed the uid and gid of the lava user in the container to
200:200. After upgrading, run the following command to chown
/var/lib/lava-server accordingly:

```
$ docker-compose exec server chown -R lavaserver:lavaserver /var/lib/lava-server/
```

## Useful Commands

Spy on the serial port:

    docker-compose exec dispatcher telnet ser2net 5001 # beaglebone-black-01
    docker-compose exec dispatcher telnet ser2net 5002 # x15-01

View logs:

    docker-compose logs -f # all containers
    docker-compose logs -f server # only the server
