# libhdfs3-deb
Steps to produce a .deb that can be installed dpkg for libhdfs3 (for use with python)

The script 'build-libhdfs3-deb.sh' works, but only with Ubuntu Xenial x86-64.

The debian file will end up in /tmp

This command was used to install dependencies on Xenial for this package:

    sudo apt-get install -y libcurl3 libgsasl7 libntlm0
