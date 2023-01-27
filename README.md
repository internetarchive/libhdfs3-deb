# libhdfs3-deb
Steps to produce a .deb that can be installed dpkg for libhdfs3 (for use with python)

Build scripts are provided for different Ubuntu LTS, but only with Ubuntu x86-64.

The debian file will end up in /tmp

This command was used to install dependencies for this package:

    Focal:
    sudo apt-get install -y libcurl4 libgsasl7 libntlm0

    Xenial:
    sudo apt-get install -y libcurl3 libgsasl7 libntlm0

To install the deb on the target machine:

    sudo dpkg -i libhdfs3.deb

updated packages since the xenial version:
- libcurl3 -> libcurl4
- libffi6 -> libffi7
- libhogweed4 -> libhogweed5
- libicu55 -> libicu66
- libnettle6 -> libnettle7
- libssl1.0.0 -> libssl1.1 
