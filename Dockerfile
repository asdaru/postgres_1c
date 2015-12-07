FROM ubuntu:14.04
MAINTAINER asdaru

RUN apt-get update
RUN groupadd -r postgres && useradd -r -g postgres postgres

RUN gpg --keyserver pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4
RUN apt-get update && apt-get install -y \
        make dpkg-dev libselinux1-dev curl

RUN curl -o /usr/local/bin/gosu -SL "https://github.com/tianon/gosu/releases/download/1.4/gosu-$(dpkg --print-architecture)" \
        && curl -o /usr/local/bin/gosu.asc -SL "https://github.com/tianon/gosu/releases/download/1.4/gosu-$(dpkg --print-architecture).asc" \
        && gpg --verify /usr/local/bin/gosu.asc \
        && rm /usr/local/bin/gosu.asc \
        && chmod +x /usr/local/bin/gosu


RUN curl -o /tmp/libicu48_4.8.1.1-3_amd64.deb  http://security.ubuntu.com/ubuntu/pool/main/i/icu/libicu48_4.8.1.1-3_amd64.deb \
        && dpkg -i /tmp/libicu48_4.8.1.1-3_amd64.deb

RUN echo "kernel.shmmax=8589934592" >> /etc/sysctl.conf
RUN echo "kernel.shmall=2097152" >> /etc/sysctl.conf

RUN locale-gen en_US ru_RU ru_RU.UTF-8
ENV LANG ru_RU.utf8

RUN mkdir /docker-entrypoint-initdb.d

ENV PG_MAJOR 9.4
ENV PG_VERSION 9.4.2-1
ENV PG_ARCH amd64
ENV DIST_1C_POSTGRES_9_4 ./dist
ENV PG_CLIENT_COMMON 154.1

RUN apt-get update && apt-get install -y \
        gcc build-essential \
        python-distutils-extra uuid-dev libldap2-dev python-all-dev \
        bison libgss-dev libpam-dev libxml2-dev \
        flex libssl-dev libxslt-dev heimdal-dev \
        libreadline-dev zlib1g-dev tcl tcl-dev libperl-dev \
        libssl0.9.8 libossp-uuid16 libxslt1.1 libedit2  ssl-cert

ADD ${DIST_1C_POSTGRES_9_4} /opt/

ENV PATH "/usr/bin:/usr/local/pgsql/bin:$PATH

COPY install_patch.sh /opt/
CMD ["/bin/bash"]

RUN bash /opt/install_patch.sh

RUN mkdir /tmp/postgresql-contrib \
        && dpkg -x /opt/postgresql-contrib-${PG_MAJOR}_${PG_VERSION}.1C_${PG_ARCH}.deb /tmp/postgresql-contrib \
        && cp /tmp/postgresql-contrib/usr/lib/postgresql/9.4/lib/*.so /usr/local/pgsql/lib/


RUN mkdir -p /var/run/postgresql && chown -R postgres /var/run/postgresql

ENV PGDATA /var/lib/postgresql/data
VOLUME /var/lib/postgresql/data

COPY docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]

EXPOSE 5432
CMD ["postgres"]

