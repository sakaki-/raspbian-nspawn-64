## Miscellaneous Config

This directory contains miscellaneous configuration files from the 
image:
* <a id="debian-stretch-64-nspawn"></a>`debian-stretch-64.nspawn`: this is the configuration for the  
`systemd-nspawn@debian-stretch-64.service`. You may wish to change / 
tighten some of the parameters used here. See [this 
manpage](http://man7.org/linux/man-pages/man5/systemd.nspawn.5.html) for 
details of the keys and values. Specifically:
  * By default, containers started by `systemd-nspawn@.service` are 
booted, so we don't need to specify this here.
  * However, also by default such containers will be launched in a 
private namespace. We turn this *off* using the `PrivateUsers=no` 
directive, as user mapping makes e.g. sharing the `pi` user's home 
directory problematic.
  * Not obvious, but automatically started containers drop the 
`CAP_NET_ADMIN` [capability](http://man7.org/linux/man-pages/man7/capabilities.7.html) 
(unless they have a private network namespace), so we re-instate it.
  * We bind mount the `/home` directory into the container, so all (regular) users can
access their home directories when using the container.
  * We also bind mount the special directory `/run/user` to `/run/host-user` 
in the container. This will allow connection to the `pulseaudio` server 
socket.
  * We also bind mount the DNS servers file, `/etc/resolv.conf`, so that 
changes to this are propagated into the container.
  * By default, automatically started containers run in their own network 
namespace, and don't share network interfaces or configuration with 
the host. We don't want that (both because piggybacking on the host's networking is easier (you can `ping`, `wget` etc. out of the box), but also because turning it on would restrict access to the host's [Unix abstract domain sockets](https://wiki.gentoo.org/wiki/Sakaki's_EFI_Install_Guide/Sandboxing_the_Firefox_Browser_with_Firejail#Graphical_Isolation_via_Xephyr), and we need such access, to be able to use the host's X11 server (since in `systemd-232`, due to [bug #4789](https://github.com/systemd/systemd/issues/4789), bind mounts in `/tmp` don't work properly)), so we restore the default 
command-line-launched behaviour with `Private=no`.
  * Similarly, by default automatically started containers get a `veth` 
tunnel created back to the host (a sort of inter-network-namespace 
wormhole); this implies `Private=yes`, so we explicitly turn it off, with 
`VirtualEthernet=no`.
