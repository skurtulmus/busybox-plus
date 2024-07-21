#!/bin/sh

VERSION="4.99.4"

wget https://www.tcpdump.org/release/tcpdump-$VERSION.tar.xz
tar -xf tcpdump-$VERSION.tar.xz
mv tcpdump-$VERSION /tcpdump
cd /tcpdump
sh configure
make
strip tcpdump
