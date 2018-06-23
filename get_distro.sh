#!/bin/sh

# getdistro.sh
#
# Uses lsb_release to get a suitable distro string
OS=$(lsb_release -si)
VER=$(lsb_release -sr)
BITNESS=$(uname -p)
echo -n "${OS}${VER}.${BITNESS}"