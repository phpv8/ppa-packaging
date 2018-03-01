Semi-automated script to create binary packages for (multiple version) of Ubuntu [![Build Status](https://travis-ci.org/pinepain/ppa-packaging.svg?branch=master)](https://travis-ci.org/pinepain/ppa-packaging)
==============================

Based on https://github.com/named-data/ppa-packaging and http://anonscm.debian.org/git/collab-maint/libv8.git

See [pinepain/devtools](https://github.com/pinepain/homebrew-devtools) tap for homebrew formulae.

### PLEASE READ:

Maintaining this project takes significant amount of time and efforts.
If you like my work and want to show your appreciation, please consider supporting me at https://www.patreon.com/pinepain.

Prerequisites
-------------

The following packages needs to be installed in order to build source .deb package to be
upload to PPA:

    sudo apt-get install git devscripts debhelper dh-make

Building source packages
------------------------

The build process is very much automated and the following command can be used to build
all packages and upload them to the ppa.

    make dput

Before running dput make sure that you have access to upload packages to `named-data/ppa`
(or modify target PPA repository in `packaging.mk`).

To build a specific package, go to the package's folder and run the same `make dput` command.

Advanced uses
-------------

The scripts by default create source packages for Ubuntu 14.04 LTS (trusty), 15.10 (wily),
and 16.04 LTS (xenial).  If necessary, default actions and distributions can be overriden:

To only build source packages (no upload) only for Ubuntu 16.04:

    make build DISTROS=precise

To build binary package that can be installed with `dpkg -i <package>.deb`:

    make build DEBUILD=debuild DISTROS=xenial

The build package will be in `<package-folder>/work/<package-name>_<version>.deb`

Building using Travis-CI
------------------------

By default Travis-CI is used to building source package and push to PPA. That's done by pushing a commit with a message
in a format `build <dir name under packaging/ folder>`. All other commits should go with `[skip ci]` to do not abuse
travis and to avoid yielding red builds.
