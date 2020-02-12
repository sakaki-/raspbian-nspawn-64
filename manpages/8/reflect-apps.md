[//]: # (Use md2man to generate the man page from this Markdown)
[//]: # (https://github.com/sunaku/md2man)

REFLECT-APPS 8 "FEBRUARY 2020"
==============================

NAME
----

reflect-apps - map desktop files from guest to host OS

SYNOPSIS
--------

`reflect-apps` *MACHINENAME*

DESCRIPTION
-----------

`reflect-apps` maps desktop files from the guest to host's
*/usr/share/applications*, prefixing their
`Exec` stanzas with `ds-runner` or `ds-shell -c` (as appropriate), to
allow direct invocation of their underlying 64-bit applications
(inside the container) from the 32-bit host GUI.

Desktop files without `Type=Application` are ignored, and any prior
desktop files at the target location in the host which have `NoDisplay=true`
set will not be overwritten.

The contents of */usr/share/icons* on the guest are also copied, with
symlinks resolved, into */usr/share/gdm/icons* on the host,
so that (most, at least) icons referenced from the mapped desktop files
will still refer.

INVOCATION
----------

Note that `reflect-apps` is not intended to be directly user-executed; it is
normally called via the systemd(1) `reflect-apps@`*MACHINENAME* service.

EXIT STATUS
-----------

The exit status is 0 if the user and group information is successfully
sync'd; and a non-zero error code otherwise.

FILES
-----

Sources data from the bootable 64-bit OS image tree at
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

reflect-locale(8), reflect-passwd(8), reflect-timezone(8),
systemd-nspawn(1)
