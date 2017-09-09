Semi-automated script to create binary packages for (multiple version) of Ubuntu [![Build Status](https://travis-ci.org/pinepain/ppa-packaging.svg?branch=master)](https://travis-ci.org/pinepain/ppa-packaging)
==============================

Based on https://github.com/named-data/ppa-packaging and http://anonscm.debian.org/git/collab-maint/libv8.git

See [pinepain/devtools](https://github.com/pinepain/homebrew-devtools) tap for homebrew formulae.

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

Building
--------

I use DigitalOcean machine to make source builds, you can use whatever you want, from docket and vagrant to Travis CI
and Jenkins slaves.

If you don't have DigitalOcean account yet, [feels free to use my referral link](https://m.do.co/c/7fb61a28c9ea),

> Everyone you refer gets $10 in credit. Once they’ve spent $25 with us, you'll get $25. There is no limit to the amount of credit you can earn through referrals.

To create build machine, setup and configure all necessary software I use Ansible. You may follow whatever approach you
get used to and like. Feels free to use roles under `ansible` directory as inspiration. 

If you want to go with my approach, I assume you already have DO account,
[got DO API token](https://www.digitalocean.com/community/tutorials/how-to-use-the-digitalocean-api-v2),
[installed ansible](http://docs.ansible.com/ansible/intro_installation.html) (I personally prefer to just `brew install ansible`, 
if you are using macOS, you can too) and that you also have
[valid and active PGP keys](https://help.launchpad.net/YourAccount/ImportingYourPGPKey).

**WARNING: for performance reasosn `8gb` droplet is used by default, which costs $80 per month,
           so you probably want to destroy it (not just turn off) when you don't need it anymore
           to avoid being charged at full.**

To get started we need to export some environment variables:

 - `export DO_API_TOKEN="<your DigitalOcean token>"`, required
 - `export DO_SSH_KEY_NAME="<ssh key name in DigitalOcean>"`, default is `Default SSH key`
 - `export DO_SSH_PUBLIC_KEY_PATH="<path to ssh public key>"`, default is `~/.ssh/id_rsa.pub`
 - `export DO_SSH_PRIVATE_KEY_PATH="<path to ssh private key>"`, default is `~/.ssh/id_rsa`

now we good to create and provision DO droplet (or ensure that it created and configured as we want):
 
    // assume that we are in current repository root, so let's first 
    cd ansible
    ansible-playbook do-ppa-sandbox.yml


if you will get something like this (formatted for readability): 


    TASK [setup] *******************************************************************
    fatal: [ppa-sandobox]: FAILED! => {
                                        "changed": false,
                                        "failed": true,
                                        "module_stderr": "Shared connection to <droplet ip> closed.",
                                        "module_stdout": "/bin/sh: 1: python2.7: not found",
                                        "msg": "MODULE FAILURE"
                                      }

don't worry, it means that `python2.7` which is required by `ansible` has not been installed yet on DO machine and simply
re-run `ansible-playbook do-ppa-sandbox.yml` command. 

During the run, you will see a message with your droplet IP

    TASK [do : Display droplet IP] *************************************************
    ok: [localhost] => {
        "msg": "Droplet IP is <ip address>, to connect run ssh@<ip address>"
    }

where `<ip address>` ip your droplet's real ip address.

Next, you will probably want to transfer you PGP keys to DO droplet to be able to sign builds. You may implement this 
process as you wish, I show you the simple way - copying it right to droplet and then importing it with `gpg`.

So first let's copy keys: `scp /path/to/keys_pair/* ansible@<ip address>:~`
Next, let's ssh to DO droplet (run `ssh@<ip address>`) and import keys: 

    gpg --import <public key>
    gpg --allow-secret-key-import --import <private key>
    gpg --keyserver keyserver.ubuntu.com --send-keys <key id from previos command output>
    gpg --fingerprint
    rm -f <public key> <private key>

Now we need to export your name and email to be utilized in build process:

    export DEBFULLNAME="<your name>"
    export DEBEMAIL="<your email>"

Now we good to start building, packaging repository is under `~/ppa-packaing` directory. Your typical flow is to go to
specific package folder, optionally alter package version and target ppa repo to upload it to in `Makefile`
and then create and upload source build by running `make dput`.
