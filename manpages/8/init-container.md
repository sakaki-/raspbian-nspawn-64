[//]: # (Use md2man to generate the man page from this Markdown)
[//]: # (https://github.com/sunaku/md2man)

INIT-CONTAINER 8 "OCTOBER 2019"
============================

NAME
----

init-container - perform initial setup for 64-bit Debian guest OS

SYNOPSIS
--------

`init-container` *MACHINENAME*

DESCRIPTION
-----------

`init-container` performs initial setup on the bootable 64-bit Debian image
*/var/lib/machines/MACHINENAME*, to prepare it for use as part of the
`raspbian-nspawn-64` package.

Because all customization is performed by a host-side script in this
way, the actual image itself (supplied by e.g., the `debian-buster-64`
package) can be a vanilla system, itself created by e.g., debootstrap(1).

`init-container` performs the following modifications to the base
image:

* Ensures *MACHINENAME* resolves for the IPv4 and IPv6 loopback
  interfaces in */etc/hosts*.
* On first invocation only, removes any */etc/machine-id* file (one
  will automatically assigned on boot, and will be retained from that
  point forward).
* Copies in the (counterpart, guest-OS side) `container-init`,
  `reflect-timezone` and
  `reflect-locale` systemd service files, path units, and matching
  */usr/sbin* binaries, and enables them.
* Ensures all members of the `sudo` group can execute any command,
  without password.
* Masks issues due to the unavailability of the accessibility bus.
* Ensures that software DRI rendering is available (as, at the time of
  writing, the current Debian (Buster) `mesa` does not allow the use of
  */dev/dri*).
* Adds a fixup to pulseaudio(1) (inhibiting timer mode).
* Finally, calls the reflect-locale(8), reflect-passwd(8) and
  reflect-timezone(8) (host-side) helpers once, to ensure the
  relevant host data
  is available in the guest at startup. The reflect-apps(8) helper is *not*
  called, as that migrates data from guest to host (and will be invoked
  once the image is up in any event).

INVOCATION
----------

Note that `init-container` is not intended to be directly user-executed; it is
normally called via the systemd(1) `init-container@`*MACHINENAME* service.

EXIT STATUS
-----------

The exit status is 0 if the specified *MACHINENAME* image is present
and has been successfully modified; and a non-zero error code
otherwise.

FILES
-----

Operates on the bootable 64-bit OS image tree at
*/var/lib/machines/MACHINENAME*.

BUGS
----

Bugs should be reported on the
[project's GitHub page](https://github.com/sakaki-/raspbian-nspawn-64/issues).

COPYRIGHT
---------

Copyright &copy; 2019 sakaki

License GPLv3+ [GNU GPL version 3 or later](http://gnu.org/licenses/gpl.html)

This is free software, you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.


AUTHORS
-------

sakaki <sakaki@deciban.com>

SEE ALSO
--------

reflect-apps(8), reflect-locale(8), reflect-passwd(8),
reflect-timezone(8), systemd-nspawn(1), Xorg(1)
