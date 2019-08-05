**Introduction**

Crash contains a ready-to-crash system image and scripts to run it under qemu. The image is accessible via ssh on localhost port 2112, and should be able to access the network through NAT.

**This repo requires Git Large File Storage
(https://git-lfs.github.com/). It is necessary to install git-lfs and
configure it before cloning the repo**.  The scripts depend on symbolic
links in the targets directory that may not be well preserved by git.

- disk1.img -> bionic-server-cloudimg-arm64.img
- initrd.img -> initrd.img-4.15.0-55-generic
- vmlinuz -> vmlinuz-4.15.0-55-generic

**Regular Usage Scripts**

Initial setup is necessary:

- `add_repos_to_host.sh` must be run once to add the debug symbol repos.  run this once before proceeding.
- `get_dbg_syms.sh` must be run once, after adding the repos to the host.
- `install_qemu.sh` installs the necessary emulator packages
- skip ahead to **Invoking _crash(8)_**, then return here

It is possible to analyze the sample crash dump without running the emulator.

- `analyze.sh` invokes _crash(8)_, using the dump in the `targets/` directory and the symbols previously downloaded.  Cross-targeted _crash(8)_ is a pre-requisite, see **Invoking _crash(8)_**, below.

The following scripts are only necessary to generate new dumps:

- `nat.sh` sets up tunneling on the host for nat from qemu.  run this first.
- `fwd.sh` sets up forwarding on the host, run this second.
- `run.sh` invokes the emulator in the normal mode.  run this third.

_This image has empty passwords for users **root** and **ubuntu**.  Please change them._

**To crash and move the dump to another system**

```
echo 1 > /proc/sys/kernel/sysrq
echo c > /proc/sysrq-trigger
```
The emulator will reboot after capturing the dump, which will be in /var/crash.  Afterward, log in to the emulated system and `scp` the file(s) out of `/var/crash`, or from the host, `scp -P 2112 ubuntu@localhost:/var/crash/...`

**Invoking crash**

Probably, _crash(8)_ on the host system lacks ARM64 support.  It will therefore be necessary to build crash from source:

```
sudo apt install bison++ # see https://github.com/crash-utility/crash/issues/18
pushd ~/Downloads
wget https://github.com/crash-utility/crash/archive/7.2.6.tar.gz
tar zxf 7.2.6.tar.gz
cd crash-7.2.6
make target=ARM64
mkdir -p ~/bin
cp -p crash ~/bin/crash-arm64
popd
```

If everything went well, it is now possible to invoke `~/bin/crash-arm64`.  Additional arguments will be necessary to analyze an actual crash dump, demonstrated in `analyze.sh`

**Other utility scripts and artifacts:**

- `boot_emu_to_shell.sh` use for emergency configuration changes to the emulated system
- `Readme.md` this file
- ` targets/` folder containing various artifacts necessary to run the emu, and also contains one dump

The following scripts are only necessary for starting over with a fresh image.

- `initialize_images.sh` downloads a fresh ubuntu image and generates EFI flash images
- `extract_kernel.sh` extracts kernel artifacts from the cloud image for use with qemu

***Resources***
This was cobbled together with information from several web posts.

A quick tutorial helped me set up the ubuntu image:
- https://rzycki.blogspot.com/2014/08/using-qemu-to-run-ubuntu-arm-64-bit.html

NAT setup resources:
- https://felipec.wordpress.com/2009/12/27/setting-up-qemu-with-a-nat/
- https://www.tecmint.com/configure-network-static-ip-address-in-ubuntu/

Understanding multiarch package management was eased by:
- https://wiki.debian.org/Multiarch/HOWTO#Configuring_architectures 

Generating a crash dump and invoking _crash(8)_:
- https://blog.richliu.com/2019/07/16/4024/kdump-in-ubuntu-18-04-arm64

With a crash dump, one probably wants to start analysis:
- https://www.dedoimedo.com/computers/crash-analyze.html

The _crash(8)_ home page: 
- http://people.redhat.com/anderson/extensions.html

