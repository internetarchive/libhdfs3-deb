#!/bin/bash
set -e
workdir=$(mktemp -d)
cd $workdir
wget -q https://repo.anaconda.com/miniconda/Miniconda3-py38_4.11.0-Linux-x86_64.sh
echo '4bb91089ecc5cc2538dece680bfe2e8192de1901e5e420f63d4e78eb26b0ac1a  Miniconda3-py38_4.11.0-Linux-x86_64.sh' | sha256sum -c - || exit 1

bash Miniconda3-py38_4.11.0-Linux-x86_64.sh -b -p ./miniconda -u
./miniconda/bin/conda install -q -y -c conda-forge libhdfs3
mkdir -p libhdfs3/usr/lib/x86_64-linux-gnu/
rsync -l ./miniconda/lib/libprotobuf.* ./libhdfs3/usr/lib/x86_64-linux-gnu/
rsync -l ./miniconda/lib/libhdfs* ./libhdfs3/usr/lib/x86_64-linux-gnu/

# create metadata items for .deb package
mkdir libhdfs3/DEBIAN
cat >libhdfs3/DEBIAN/control <<EOF
Package: libhdfs3
Version: 2.3
Section: utils
Priority: optional
Architecture: amd64
Depends: libasn1-8-heimdal, libc6, libcomerr2, libcurl4, libffi7, libgcc1, libgmp10, libgnutls30, libgsasl7, libgssapi-krb5-2, libgssapi3-heimdal, libhcrypto4-heimdal, libheimbase1-heimdal, libheimntlm0-heimdal, libhogweed5, libhx509-5-heimdal, libicu66, libidn11, libk5crypto3, libkeyutils1, libkrb5-26-heimdal, libkrb5-3, libkrb5support0, libldap-2.4-2, liblzma5, libnettle7, libntlm0, libp11-kit0, libroken18-heimdal, librtmp1, libsasl2-2, libsqlite3-0, libssl1.1, libstdc++6, libtasn1-6, libuuid1, libwind0-heimdal, libxml2, zlib1g
Maintainer: Alex Dempsey <avdempsey@archive.org>
Description: Binary package for libhdfs3
 Package to avoid having to install anaconda/miniconda and competing python installations.
EOF

dpkg-deb --build libhdfs3
mv libhdfs3.deb /tmp
cd /tmp
rm -R $workdir
echo "built deb file: /tmp/libhdfs3.deb"
