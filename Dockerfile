FROM alpine:latest AS build
RUN apk update
RUN apk add build-base perl bearssl-static bearssl-libs bearssl-dev libpcap-dev ca-certificates clang
RUN wget https://curl.se/download/curl-8.8.0.tar.gz
RUN wget https://www.tcpdump.org/release/tcpdump-4.99.4.tar.xz
RUN wget https://www.ivarch.com/programs/sources/pv-1.8.12.tar.gz
RUN tar -xf curl-8.8.0.tar.gz
RUN tar -xf tcpdump-4.99.4.tar.xz
RUN tar -xf pv-1.8.12.tar.gz
RUN mv curl-8.8.0 curl
RUN mv tcpdump-4.99.4 tcpdump
RUN mv pv-1.8.12 pv
ENV CC=clang
ENV CFLAGS="-Os -march=native -flto -fdata-sections -ffunction-sections -fno-unwind-tables -fno-asynchronous-unwind-tables"
ENV LDFLAGS="-static -Wl,--gc-sections -Wl,-Bsymbolic -Wl,-s"
ENV PKG_CONFIG="pkg-config --static"
WORKDIR /curl
RUN ./configure --with-bearssl --enable-optimize --enable-static --disable-shared --disable-imap --disable-smtp --disable-gopher --disable-unix-sockets --disable-docs --disable-manual --disable-ldap --disable-ldaps --disable-dict --disable-file --disable-telnet --disable-tftp --disable-pop3 --disable-threaded-resolver --disable-ipv6 --disable-smb --disable-mqtt --disable-tls-srp --disable-aws --without-libpsl --without-brotli --without-libidn2 --without-librtmp --without-libssh2 --without-zstd --without-libgsasl --without-winidn --without-msh3 --without-zsh-functions-dir --without-fish-functions-dir
RUN make LDFLAGS="-static -all-static"
RUN strip src/curl
WORKDIR /tcpdump
RUN ./configure
RUN make
RUN strip tcpdump
WORKDIR /pv
RUN ./configure
RUN make
RUN strip pv

FROM busybox:musl AS runtime
COPY --from=build /etc/ssl/certs /etc/ssl/certs
COPY --from=build /curl/src/curl /bin/curl
COPY --from=build /tcpdump/tcpdump /bin/tcpdump
COPY --from=build /pv/pv /bin/pv
