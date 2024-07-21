FROM alpine:latest AS build
RUN apk update
RUN apk add build-base perl bearssl-static bearssl-libs bearssl-dev libpcap-dev ca-certificates clang
ENV CC=clang
ENV CFLAGS="-Os -march=native -flto -fdata-sections -ffunction-sections -fno-unwind-tables -fno-asynchronous-unwind-tables"
ENV LDFLAGS="-static -Wl,--gc-sections -Wl,-Bsymbolic -Wl,-s"
ENV PKG_CONFIG="pkg-config --static"
COPY build_curl.sh /build_curl.sh
COPY build_tcpdump.sh /build_tcpdump.sh
COPY build_pv.sh /build_pv.sh
RUN sh build_curl.sh
RUN sh build_tcpdump.sh
RUN sh build_pv.sh

FROM busybox:musl AS runtime
COPY --from=build /etc/ssl/certs /etc/ssl/certs
COPY --from=build /curl/src/curl /bin/curl
COPY --from=build /tcpdump/tcpdump /bin/tcpdump
COPY --from=build /pv/pv /bin/pv
