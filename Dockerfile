FROM alpine AS build
RUN apk update
RUN apk add build-base perl libressl-dev libpcap-dev clang
RUN wget https://curl.se/download/curl-8.8.0.tar.gz
RUN wget https://www.tcpdump.org/release/tcpdump-4.99.4.tar.xz
RUN tar -xf curl-8.8.0.tar.gz
RUN tar -xf tcpdump-4.99.4.tar.xz
RUN mv curl-8.8.0 curl
RUN mv tcpdump-4.99.4 tcpdump
ENV CC=clang
WORKDIR /curl
RUN ./configure LDFLAGS="-static" PKG_CONFIG="pkg-config --static" --with-openssl --enable-optimize --enable-static --disable-shared --disable-imap --disable-smtp --disable-gopher --disable-unix-sockets --disable-docs --disable-manual --disable-dict --disable-file --disable-telnet --disable-tftp --disable-pop3 --disable-threaded-resolver --disable-ipv6 --disable-smb --disable-ntlm-wb --disable-mqtt --disable-tls-srp --disable-aws --without-libpsl --without-brotli --without-libidn2 --without-librtmp --without-libssh2 --without-nss --without-zstd --without-libgsasl --without-winidn --without-msh3 --without-zsh-functions-dir --without-fish-functions-dir
RUN make LDFLAGS="-static -all-static"
RUN strip src/curl
WORKDIR /tcpdump
RUN ./configure LDFLAGS="-static" PKG_CONFIG="pkg-config --static" --enable-static --disable-shared --enable-optimize
RUN make LDFLAGS="-static"
RUN strip tcpdump

FROM busybox:musl AS runtime
COPY --from=build /curl/src/curl /bin/curl
COPY --from=build /tcpdump/tcpdump /bin/tcpdump
