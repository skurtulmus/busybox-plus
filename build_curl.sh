#!/bin/sh

VERSION="8.8.0"

wget https://curl.se/download/curl-$VERSION.tar.gz
tar -xf curl-$VERSION.tar.gz
mv curl-$VERSION /curl
cd /curl
sh configure --with-bearssl --enable-optimize --enable-static --disable-shared --disable-imap --disable-smtp --disable-gopher --disable-unix-sockets --disable-docs --disable-manual --disable-ldap --disable-ldaps --disable-dict --disable-file --disable-telnet --disable-tftp --disable-pop3 --disable-threaded-resolver --disable-ipv6 --disable-smb --disable-mqtt --disable-tls-srp --disable-aws --without-libpsl --without-brotli --without-libidn2 --without-librtmp --without-libssh2 --without-zstd --without-libgsasl --without-winidn --without-msh3 --without-zsh-functions-dir --without-fish-functions-dir
make LDFLAGS="-static -all-static"
strip src/curl
