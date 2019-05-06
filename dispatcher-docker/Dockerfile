FROM lavasoftware/lava-dispatcher:2019.04

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get -y install \
        apt-transport-https \
        ca-certificates \
        curl \
        gnupg2 \
        software-properties-common && \
    curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - && \
    add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/debian \
stretch \
stable" && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get -y install docker-ce docker-ce-cli
