FROM phusion/baseimage:0.11

LABEL maintainer="Samuel Hautcoeur <samuel.hautcoeur@ep4.com>"

ENV DEBIAN_FRONTEND=noninteractive \
    LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 LANGUAGE=en_US.UTF-8 TERM=xterm container=docker

RUN cd /tmp \
    && apt-get update \
    && apt-get -y --no-install-recommends --allow-unauthenticated install \
       curl rsync sudo tar incron \
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
    && chmod +x /usr/bin/backup-creds.sh \
    && chmod +x /etc/service/incrond/run \
    && rm -rf /tmp/* \
    && apt-get -y autoremove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \

ENV DEBIAN_FRONTEND=teletype

VOLUME ["/backup"]

CMD ["/sbin/my_init"]
