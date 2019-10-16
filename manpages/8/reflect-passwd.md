[//]: # (Use md2man to generate the man page from this Markdown)
[//]: # (https://github.com/sunaku/md2man)

REFLECT-PASSWD 8 "OCTOBER 2019"
===============================

NAME
----

reflect-passwd - sync some user, group info from host into guest OS

SYNOPSIS
--------

`reflect-passwd` *MACHINENAME*

DESCRIPTION
-----------

`reflect-passwd` ensures that the host's user and group information (for
users in the 1000 <= UID < 1100 range) is copied into the guest OS
image (with any conflicts resolved in favour of the host data).

The process operates broadly as follows:

* The host's */etc/group* file is parsed, to establish a mapping
between GID and group name.
* Then, the host's */etc/passwd* file is parsed, and any UIDS
1000 <= UID < 1100 in the host are recorded. Call this the active set.
* The guest's */etc/passwd* file is then processed, dropping any lines with 
overlapping UIDs or usernames, and inserting corresponding active set lines
from the counterpart host version of the file.
* Then the host's */etc/shadow* file is parsed, recording the (hashed)
password data corresponding to entries in the active set.
* Next, the guest's */etc/shadow* file is processed, dropping any overlapping
lines, and inserting the active set password data just captured.
* Then the host's */etc/group* file is parsed, recording any primary groups
for users in the active set.
* Next, the guest's */etc/group* file is processed, dropping any clashing
lines, and ensuring that all active set members belong
to their corresponding primary groups (creating these if required),
and of the `$USE_GROUP`
secondary groups (viz. `adm`, `dialout`, `sudo`,
`audio`, `video`, `plugdev`, `games`, `users`, `input`, `netdev`, 
`gpio`, `i2c` and `spi`) providing such groups are already defined on the
guest (i.e., these secondary groups are *not* created where absent on the
guest).
* Then, the host's */etc/gshadow* file is parsed, recording the (hashed)
password data corresponding to entries in the core group set just defined.
* Finally, the guest's */etc/gshadow* file is processed, removing any
clashing lines, and replacing these with those just captured from the
counterpart host file.

Modifications are made to a set of temporary files first, then switched
over en bloc, to mitigate against mid-execution crashes.

INVOCATION
----------

Note that `reflect-passwd` is not intended to be directly user-executed; it is
normally called via the systemd(1) `reflect-passwd@`*MACHINENAME* service.

EXIT STATUS
-----------

The exit status is 0 if the user and group information is successfully
sync'd; and a non-zero error code otherwise.

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

reflect-apps(8), reflect-locale(8), reflect-timezone(8),
systemd-nspawn(1)
