#!/bin/sh

VERSION="1.8.12"

wget https://www.ivarch.com/programs/sources/pv-$VERSION.tar.gz
tar -xf pv-$VERSION.tar.gz
mv pv-$VERSION /pv
cd /pv
sh configure
make
strip pv
