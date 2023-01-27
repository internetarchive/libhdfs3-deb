#!/bin/bash
set -e
workdir=$(mktemp -d)
cd $workdir
wget -q https://repo.continuum.io/miniconda/Miniconda3-4.3.27.1-Linux-x86_64.sh
echo '640f505f06f87d75bebc629e4a677ebb185ea9a34eb6d7c199db0753ffc42f62  Miniconda3-4.3.27.1-Linux-x86_64.sh' | sha256sum -c - || exit 1

bash Miniconda3-4.3.27.1-Linux-x86_64.sh -b -p ./miniconda -u
./miniconda/bin/conda install -q -y -c conda-forge libhdfs3
mkdir -p libhdfs3_1-1/usr/lib/x86_64-linux-gnu/
rsync -l ./miniconda/lib/libprotobuf.* ./libhdfs3_1-1/usr/lib/x86_64-linux-gnu/
rsync -l ./miniconda/lib/libhdfs* ./libhdfs3_1-1/usr/lib/x86_64-linux-gnu/

# create metadata items for .deb package
mkdir libhdfs3_1-1/DEBIAN
cat >libhdfs3_1-1/DEBIAN/control <<EOF
Package: libhdfs3
Version: 1-1
Section: utils
Priority: optional
Architecture: amd64
Depends: libasn1-8-heimdal, libc6, libcomerr2, libcurl3, libffi6, libgcc1, libgmp10, libgnutls30, libgsasl7, libgssapi-krb5-2, libgssapi3-heimdal, libhcrypto4-heimdal, libheimbase1-heimdal, libheimntlm0-heimdal, libhogweed4, libhx509-5-heimdal, libicu55, libidn11, libk5crypto3, libkeyutils1, libkrb5-26-heimdal, libkrb5-3, libkrb5support0, libldap-2.4-2, liblzma5, libnettle6, libntlm0, libp11-kit0, libroken18-heimdal, librtmp1, libsasl2-2, libsqlite3-0, libssl1.0.0, libstdc++6, libtasn1-6, libuuid1, libwind0-heimdal, libxml2, zlib1g
Maintainer: James Kafader <jkafader@archive.org>
Description: Binary package for libhdfs3
 Package to avoid having to install anaconda/miniconda and competing python installations.
EOF

dpkg-deb --build libhdfs3_1-1
mv libhdfs3_1-1.deb /tmp
cd /tmp
rm -R $workdir
echo "built deb file: /tmp/libhdfs3_1-1.deb"
