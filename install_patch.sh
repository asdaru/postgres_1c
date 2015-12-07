#!/bin/sh
cd /opt
tar -xvf ./postgresql-9.4_9.4.2.orig.tar.bz2
tar -xvf ./postgresql-9.4_9.4.2-1.1C.debian.tar.gz
cp -R ./debian/ ./postgresql-9.4.2/
cd ./postgresql-9.4.2/
patch -p1 < ./debian/patches/02-relax-sslkey-permscheck.patch
patch -p1 < ./debian/patches/50-per-version-dirs.patch
patch -p1 < ./debian/patches/51-default-sockets-in-var.patch
patch -p1 < ./debian/patches/52-tutorial-README.patch
patch -p1 < ./debian/patches/53-pg_service.conf_directory_doc.patch
patch -p1 < ./debian/patches/54-debian-alternatives-for-external-tools.patch
patch -p1 < ./debian/patches/64-pg_upgrade-sockdir
patch -p1 < ./debian/patches/65-1c_FULL_94-0.23
patch -p1 < ./debian/patches/66-applock-1c-9.4.patch
patch -p1 < ./debian/patches/67-postgresql-1c-9.4.patch
patch -p1 < ./debian/patches/68-online_analyze-9.4.patch
patch -p1 < ./debian/patches/69-plantuner.patch
patch -p1 < ./debian/patches/70-history


./configure --disable-integer-datetimes
make && make install
