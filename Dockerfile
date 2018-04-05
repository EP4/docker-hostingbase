FROM hyperknot/baseimage16:1.0.4

LABEL maintainer="noogen <friends@niiknow.org>"

ENV DEBIAN_FRONTEND=noninteractive \
    LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 LANGUAGE=en_US.UTF-8 TERM=xterm container=docker

RUN cd /tmp \
    && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 4F4EA0AAE5267A6C \
    && add-apt-repository -y ppa:pinepain/libv8  \
    && apt-add-repository -y ppa:ondrej/php \
    && apt-get update && apt-get -y --no-install-recommends upgrade \
    && apt-get -y --no-install-recommends --allow-unauthenticated install curl rsync apt-transport-https \
       sudo tar \
    && systemctl disable incron \
    && echo 'root' >> /etc/incron.allow \
    && dpkg --configure -a \
    && apt-get -y autoremove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm -f /core \
    && find /etc/service/ -name "down" -exec rm -f {} \; \
    || true

COPY rootfs/. /

RUN cd /tmp \
    && chmod +x /etc/service/sshd/run \
    && chmod +x /usr/bin/backup-creds.sh \
    && chmod +x /etc/service/incrond/run \
    && rm -rf /tmp/* \
    && apt-get -y autoremove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \

ENV DEBIAN_FRONTEND=teletype

VOLUME ["/backup"]

CMD ["/sbin/my_init"]
