#!/usr/bin/env bash

apt-get clean
find /usr/share/locale -mindepth 1 -maxdepth 1 ! -name 'en' |xargs rm -rf
find /usr/share/doc -depth -type f | xargs rm -f || true
find /usr/share/doc -empty | xargs rmdir || true
rm -rf /usr/share/man /usr/share/groff /usr/share/info /usr/share/lintian /usr/share/linda /var/cache/man