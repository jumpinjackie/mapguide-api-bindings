#!/bin/sh
SWIG_VER=3.0.7
ROOT=$PWD
if [ ! -f swig-${SWIG_VER}.tar.gz ];
then
	wget http://prdownloads.sourceforge.net/swig/swig-${SWIG_VER}.tar.gz
fi
if [ -d swig-${SWIG_VER} ]; 
then
	rm -rf swig-${SWIG_VER}
fi
if [ -d swig ]; 
then
	rm -rf swig
fi
mkdir swig
tar -zxf swig-${SWIG_VER}.tar.gz
cd swig-${SWIG_VER}
./configure --prefix=${ROOT}/swig && make && make install