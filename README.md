# UCB Logo 6.0

This is a fork of UCB Logo version 6.0 from Brian Harvey at [Cal](https://www.cs.berkeley.edu/~bh/logo.html)

The goal of this fork is to keep it up to date on OS X, BSD, Linux, 
and possibly Windows.

Currently code has been updated to build on Yosemite OS X 10.10 
and wxWidgets 3.1 

Help welcome.

## TODO

* fix autoconf setup stuff
* remove Mac Classic code and other legacy code
* clarify application flow execution
* add doc strings to code and clean up formatting
* if we're feeling brave, port to Qt to take advantage of Qt Creator?

## Installation OS X

1. Install wxWidgets 3.1.  I configured it with:

    ./configure --with-macosx-version-min=10.10 --with-libpng --with-zlib --enable-clipboard --enable-svg --with-osx_cocoa --with-libjpeg --with-libtiff
    make
    make install

2. build this repo with:

    ./configure --wx-enable --includedir=/usr/local/include/wx-3.1/ --with-x=no
    make


## Changes
(9/8/2015)
* segfault on closing fixed in getFromWX_2
* fixed FontDialog issue by using wxWidgets 3.1, as 3.0.2 seemed broken
* regressed (possibly) to wxCOPY in the Blit in wxTerminal::InvertArea
* lots of compiler warnings caught by Clang fixed


