[//]: # (Use md2man to generate the man page from this Markdown)
[//]: # (https://github.com/sunaku/md2man)

CHECK-AARCH64 1 "FEBRUARY 2020"
===============================

NAME
----

check-aarch64 - check if running kernel is aarch64 (64-bit)

SYNOPSIS
--------

`check-aarch64`

DESCRIPTION
-----------

`check-aarch64` checks if the currently running kernel is 64-bit; a
warning (using zenity, if available) is displayed if not.

EXIT STATUS
-----------

The exit status is 0 if the kernel is aarch64, and 1 otherwise.

FILES
-----

*/etc/ds64.conf*

Configuration file specifying various controlling environment
variables, including `$DS64_NAME` (defaults to *debian-buster-64*) and
`$DS64_DIR` (defaults to */var/lib/machines/debian-buster-64*).

BUGS
----

Bugs should be reported on the
[project's GitHub page](https://github.com/sakaki-/raspbian-nspawn-64/issues).

COPYRIGHT
---------

Copyright &copy; 2020 sakaki

License GPLv3+ [GNU GPL version 3 or later](http://gnu.org/licenses/gpl.html)

This is free software, you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.


AUTHORS
-------

sakaki <sakaki@deciban.com>


SEE ALSO
--------
uname(1), zenity(1)
