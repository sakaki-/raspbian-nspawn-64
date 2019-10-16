[//]: # (Use md2man to generate the man page from this Markdown)
[//]: # (https://github.com/sunaku/md2man)

DS64-STOP 1 "OCTOBER 2019"
==========================

NAME
----

ds64-stop - shut down the 64-bit Debian sidekick OS, if running

SYNOPSIS
--------

`ds64-stop`

DESCRIPTION
-----------

`ds64-stop` attempts to shut down the current 64-bit Debian 'sidekick' guest
OS, if it is running.

Upon a error-free return from this command, you can rely upon the guest OS
being down, allowing you to e.g., safely take a backup of its root filesystem.

NB: any programs or shells currently running inside the guest will be
forcibly closed when the container is stopped.

To start the guest back up again, use ds64-start(1).

A zenity(1) dialog status display is provided on exit, with a 5 second
auto-dismissal timeout.

EXIT STATUS
-----------

The exit status is 0 if the guest OS is shut down upon exit, and 1 otherwise.

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

SEE ALSO
--------

ds64-runner(1), ds64-start(1), zenity(1)
