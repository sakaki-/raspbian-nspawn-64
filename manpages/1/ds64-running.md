[//]: # (Use md2man to generate the man page from this Markdown)
[//]: # (https://github.com/sunaku/md2man)

DS64-RUNNING 1 "OCTOBER 2019"
=============================

NAME
----

ds64-running - test if the 64-bit Debian sidekick OS is up

SYNOPSIS
--------

`ds64-running`

DESCRIPTION
-----------

`ds64-runnng` checks if the 64-bit Debian 'sidekick' OS is currently
running.

EXIT STATUS
-----------

The exit status is 0 if the sidekick OS is up, and 1 otherwise.

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

Copyright &copy; 2019 sakaki

License GPLv3+ [GNU GPL version 3 or later](http://gnu.org/licenses/gpl.html)

This is free software, you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.


AUTHORS
-------

sakaki <sakaki@deciban.com>

