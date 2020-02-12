[//]: # (Use md2man to generate the man page from this Markdown)
[//]: # (https://github.com/sunaku/md2man)

REFLECT-LOCALE 8 "FEBRUARY 2020"
================================

NAME
----

reflect-locale - sync host's */etc/default/locale* into guest OS

SYNOPSIS
--------

`reflect-locale` *MACHINENAME*

DESCRIPTION
-----------

`reflect-locale` ensures that the host's */etc/default/locale* is
copied across into the guest OS image, as */etc/default/host-locale*.

For correct operation, it relies upon the existence of a counterpart
`reflect-locale` path unit, service and */usr/sbin* script in the guest,
(set up by
init-container(8)), which monitors this file, and forces the
new locale to be compiled (if necessary) by locale-gen(8), and
then set as the system default by localectl(1), upon change.

INVOCATION
----------

Note that `reflect-locale` is not intended to be user-executed; it is
normally called via the systemd(1) `reflect-locale@`*MACHINENAME* service.

EXIT STATUS
-----------

The exit status is 0 if the locale is successfully copied to the guest, and a
non-zero error code otherwise.

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

Copyright &copy; 2019-20 sakaki

License GPLv3+ [GNU GPL version 3 or later](http://gnu.org/licenses/gpl.html)

This is free software, you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.


AUTHORS
-------

sakaki <sakaki@deciban.com>

SEE ALSO
--------

init-container(8), localetctl(1), locale-gen(8), reflect-apps(8),
reflect-passwd(8), reflect-timezone(8), systemd-nspawn(1), Xorg(1)
